import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ensureDatabaseSeeded, resetSeedState } from '../../src/db/seed';
import { User } from '../../src/models/user.model';
import { Wallet } from '../../src/models/wallet.model';
import { Shipment } from '../../src/models/shipment.model';
import * as dbConnect from '../../src/db/connect';
import * as transactionModule from '../../src/db/transaction';
import mongoose from 'mongoose';

describe('Database Seed Module', () => {
  const fakeUserId = new mongoose.Types.ObjectId();
  const fakeDemoUser = {
    _id: fakeUserId,
    email: 'bunmi@securebypay.com',
    firstName: 'Bunmi',
    lastName: 'Tanny',
  };

  beforeEach(() => {
    vi.restoreAllMocks();
    resetSeedState();
    vi.spyOn(transactionModule, 'runInTransaction').mockImplementation(async (cb) => {
      return await cb({} as any);
    });
  });

  it('should skip seeding if DB is not connected', async () => {
    vi.spyOn(dbConnect, 'isDBConnected').mockReturnValue(false);
    const userFindSpy = vi.spyOn(User, 'findOne');

    await ensureDatabaseSeeded();

    expect(userFindSpy).not.toHaveBeenCalled();
  });

  it('should seed demo user, wallet, and shipments when database is empty', async () => {
    vi.spyOn(dbConnect, 'isDBConnected').mockReturnValue(true);
    vi.spyOn(User, 'findOne').mockResolvedValue(null as any);
    const userCreateSpy = vi.spyOn(User, 'create').mockResolvedValue([fakeDemoUser] as any);
    vi.spyOn(Wallet, 'findOne').mockResolvedValue(null as any);
    const walletCreateSpy = vi.spyOn(Wallet, 'create').mockResolvedValue([{}] as any);
    vi.spyOn(Shipment, 'countDocuments').mockResolvedValue(0 as any);
    const shipmentCreateSpy = vi.spyOn(Shipment, 'create').mockResolvedValue([] as any);

    await ensureDatabaseSeeded();

    expect(userCreateSpy).toHaveBeenCalledTimes(1);
    expect(walletCreateSpy).toHaveBeenCalledTimes(1);
    expect(shipmentCreateSpy).toHaveBeenCalledTimes(1);
  });

  it('should not re-create user or shipments if already present', async () => {
    vi.spyOn(dbConnect, 'isDBConnected').mockReturnValue(true);
    vi.spyOn(User, 'findOne').mockResolvedValue(fakeDemoUser as any);
    const userCreateSpy = vi.spyOn(User, 'create');
    vi.spyOn(Wallet, 'findOne').mockResolvedValue({ userId: fakeUserId } as any);
    const walletCreateSpy = vi.spyOn(Wallet, 'create');
    vi.spyOn(Shipment, 'countDocuments').mockResolvedValue(3 as any);
    const shipmentCreateSpy = vi.spyOn(Shipment, 'create');

    await ensureDatabaseSeeded();

    expect(userCreateSpy).not.toHaveBeenCalled();
    expect(walletCreateSpy).not.toHaveBeenCalled();
    expect(shipmentCreateSpy).not.toHaveBeenCalled();
  });

  it('should not execute again if already seeded in current process', async () => {
    vi.spyOn(dbConnect, 'isDBConnected').mockReturnValue(true);
    vi.spyOn(User, 'findOne').mockResolvedValue(fakeDemoUser as any);
    vi.spyOn(Wallet, 'findOne').mockResolvedValue({ userId: fakeUserId } as any);
    const shipmentCountSpy = vi.spyOn(Shipment, 'countDocuments').mockResolvedValue(3 as any);

    await ensureDatabaseSeeded();
    expect(shipmentCountSpy).toHaveBeenCalledTimes(1);

    await ensureDatabaseSeeded();
    expect(shipmentCountSpy).toHaveBeenCalledTimes(1);
  });
});
