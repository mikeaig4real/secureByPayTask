import mongoose, { ClientSession } from 'mongoose';
import { logger } from '../utils/logger';

/**
 * Executes an atomic operation inside a MongoDB transaction.
 * Automatically commits on success and aborts on any failure.
 *
 * If connected to a standalone MongoDB instance that does not support replica set
 * transactions, it gracefully runs the operation while ensuring proper error propagation.
 */
export async function runInTransaction<T>(
  work: (session?: ClientSession) => Promise<T>
): Promise<T> {
  // Bypass session when offline or executing unit tests without an active connection
  if (mongoose.connection.readyState !== 1) {
    return await work();
  }

  let session: ClientSession | null = null;

  try {
    session = await mongoose.startSession();
    return await session.withTransaction(() => work(session!));
  } catch (error: any) {
    const isStandaloneError =
      error?.message?.includes('replica set member or mongos') ||
      error?.code === 20 ||
      error?.codeName === 'IllegalOperation';

    if (isStandaloneError) {
      logger.warn('[DATABASE] Standalone MongoDB detected: executing operation without replica set transaction.');
      return await work();
    }

    logger.error({ err: error.message }, '[DATABASE TRANSACTION ABORTED]');
    throw error;
  } finally {
    if (session) {
      await session.endSession();
    }
  }
}
