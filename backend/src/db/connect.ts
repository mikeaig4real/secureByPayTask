import mongoose from 'mongoose';
import { config } from '../config';
import { logger } from '../utils/logger';

let isConnected = false;

export type DBConnectionStatus = 'connected' | 'connecting' | 'disconnecting' | 'disconnected';

/**
 * Maps Mongoose readyState numerical code to human-readable status
 */
export function getDBStatus(): DBConnectionStatus {
  switch (mongoose.connection.readyState) {
    case 1:
      return 'connected';
    case 2:
      return 'connecting';
    case 3:
      return 'disconnecting';
    default:
      return 'disconnected';
  }
}

/**
 * Checks whether the MongoDB connection is currently live and ready
 */
export function isDBConnected(): boolean {
  return mongoose.connection.readyState === 1;
}

/**
 * Retrieves the currently active database name
 */
export function getActiveDBName(): string | undefined {
  return mongoose.connection.name;
}

/**
 * Handles connecting to MongoDB for both production/dev and test environments.
 * Strictly prefers local MongoDB with directConnection=true, falling back to Atlas if configured.
 * Enforces that test environments target a database containing '_test'.
 */
export async function connectDB(isTest: boolean = false): Promise<typeof mongoose> {
  if (isDBConnected()) {
    return mongoose;
  }

  const primaryUri = isTest ? config.mongo.testUri : config.mongo.uri;
  const fallbackUri = isTest ? config.mongo.testFallbackUri : config.mongo.fallbackUri;

  if (!primaryUri) {
    throw new Error(
      `[Database Error] ${isTest ? 'MONGO_TEST_URI' : 'MONGO_URI'} is not defined in environment.`
    );
  }

  // Enforce test isolation: URI must contain '_test' to prevent test data pollution
  if (isTest && !primaryUri.toLowerCase().includes('_test')) {
    throw new Error(
      `[Database Security] Test database URI must explicitly contain '_test'. Got: ${primaryUri}`
    );
  }

  try {
    logger.info(`[Database] Connecting to preferred DB: ${primaryUri}...`);
    await mongoose.connect(primaryUri, {
      serverSelectionTimeoutMS: 2000,
    });
    isConnected = true;
    logger.info(`[Database] Successfully connected to primary DB: ${mongoose.connection.name}`);
    return mongoose;
  } catch (localError: any) {
    logger.warn(
      `[Database] Primary local connection failed (${localError.message}).`
    );

    if (fallbackUri) {
      if (isTest && !fallbackUri.toLowerCase().includes('_test')) {
        throw new Error(
          `[Database Security] Fallback test URI must also contain '_test'. Got: ${fallbackUri}`
        );
      }

      logger.info(`[Database] Falling back to fallback DB: ${fallbackUri.split('@')[1] || fallbackUri}...`);
      await mongoose.connect(fallbackUri, {
        serverSelectionTimeoutMS: 5000,
      });
      isConnected = true;
      logger.info(`[Database] Successfully connected to fallback DB: ${mongoose.connection.name}`);
      return mongoose;
    }

    throw localError;
  }
}

/**
 * Cleanly disconnects the database connection
 */
export async function disconnectDB(): Promise<void> {
  if (mongoose.connection.readyState !== 0) {
    await mongoose.disconnect();
    isConnected = false;
    logger.info('[Database] MongoDB connection cleanly closed.');
  }
}
