import { describe, it, expect } from 'vitest';
import { AuthService, authService } from '../../src/services/auth.service';

describe('AuthService - Tracking ID Generation', () => {
  it('generates standardized tracking IDs using instance method this.makeTrackingId', () => {
    const mockUserId = '65f1a2b3c4d5e6f7a8b9c0d1';
    const id1 = authService.makeTrackingId(mockUserId, 0);
    const id2 = authService.makeTrackingId(mockUserId, 1);
    const id3 = authService.makeTrackingId(mockUserId, 2);

    expect(id1).toBe('MAF-C0D1-234-291');
    expect(id2).toBe('MAF-C0D1-234-292');
    expect(id3).toBe('MAF-C0D1-234-293');
  });

  it('generates standardized tracking IDs using static method AuthService.generateTrackingId', () => {
    const mockObjectId = {
      toString: () => '507f1f77bcf86cd799439011',
    };
    const id = AuthService.generateTrackingId(mockObjectId, 0);
    expect(id).toBe('MAF-9011-234-291');
  });

  it('defaults index to 0 if not provided', () => {
    const id = authService.makeTrackingId('user-test-7890');
    expect(id).toBe('MAF-7890-234-291');
  });
});
