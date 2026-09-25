import { User } from '../models/user.model';
import { Wallet } from '../models/wallet.model';
import { Shipment } from '../models/shipment.model';
import { createSeedShipments } from '../mock-data/seedShipments.data';
import { config } from '../config';
import { logger } from '../utils/logger';
import { isDBConnected } from './connect';
import { runInTransaction } from './transaction';

let isSeeded = false;

/**
 * Ensures initial seed data exists in the database.
 */
export async function ensureDatabaseSeeded(): Promise<void> {
  if (isSeeded) {
    return;
  }

  if (!isDBConnected()) {
    logger.warn('[SEED] Skipping database seed: MongoDB is not connected.');
    return;
  }

  try {
    await runInTransaction(async (session) => {
      let demoUser = await User.findOne({ email: config.demoUser.email }, null, { session });
      let isNewUser = false;
      if (!demoUser) {
        const createdUsers = await User.create(
          [
            {
              firstName: config.demoUser.firstName,
              lastName: config.demoUser.lastName,
              email: config.demoUser.email,
              phone: config.demoUser.phone,
              password: config.demoUser.password,
            },
          ],
          { session, ordered: true }
        );
        demoUser = createdUsers[0];
        isNewUser = true;
      }

      if (isNewUser) {
        logger.info(`[SEED] Initialized demo user (${config.demoUser.email}).`);
      }

      const existingWallet = await Wallet.findOne({ userId: demoUser._id }, null, { session });
      if (!existingWallet) {
        await Wallet.create(
          [
            {
              userId: demoUser._id,
              balance: config.wallet.initialBalance,
              currency: config.wallet.defaultCurrency,
            },
          ],
          { session, ordered: true }
        );
        logger.info(
          `[SEED] Initialized demo wallet with ${config.wallet.initialBalance} ${config.wallet.defaultCurrency}.`
        );
      }

      const shipmentCount = await Shipment.countDocuments({ userId: demoUser._id }, { session });
      if (shipmentCount === 0) {
        const shipmentsWithUser = createSeedShipments({ userId: demoUser._id });
        await Shipment.create(shipmentsWithUser, { session, ordered: true });
        logger.info(
          `[SEED] Initialized ${shipmentsWithUser.length} seed shipments linked to user ${config.demoUser.email}.`
        );
      }
    });

    isSeeded = true;
  } catch (err: any) {
    logger.error({ err: err.message }, '[SEED ERROR] Failed to seed initial database collections');
  }
}

/**
 * Resets the in-memory seed state (primarily for test environments).
 */
export function resetSeedState(): void {
  isSeeded = false;
}
