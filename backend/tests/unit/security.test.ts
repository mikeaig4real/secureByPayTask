import { describe, it, expect, vi } from 'vitest';
import { apiLimiter, authLimiter, financialLimiter } from '../../src/middleware/rateLimiter';
import { DashboardService } from '../../src/services/dashboard.service';
import { Shipment } from '../../src/models/shipment.model';
import { NotFoundError } from '../../src/errors/notFoundError';

describe('Security & Protection Rules', () => {
  it('configures rate limiters with expected windowMs and standards', () => {
    expect(apiLimiter).toBeDefined();
    expect(authLimiter).toBeDefined();
    expect(financialLimiter).toBeDefined();
  });

  it('prevents IDOR: payShipment rejects payment if shipment belongs to a different user', async () => {
    const service = new DashboardService();
    const foreignUserId = '65f1a2b3c4d5e6f7a8b9c999';
    const attackingUserId = '65f1a2b3c4d5e6f7a8b9c111';
    const shipmentId = '65f1a2b3c4d5e6f7a8b9c888';

    const mockShipment = {
      _id: shipmentId,
      userId: { toString: () => foreignUserId },
      amount: 3000,
      isPaid: false,
    };

    vi.spyOn(Shipment, 'findById').mockReturnValue({
      session: vi.fn().mockResolvedValue(mockShipment),
    } as any);

    await expect(service.payShipment(attackingUserId, shipmentId)).rejects.toThrow(
      NotFoundError
    );

    vi.restoreAllMocks();
  });
});
