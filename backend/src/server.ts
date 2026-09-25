import { createApp } from './app';
import { config, validateEnv } from './config';
import { connectDB, disconnectDB } from './db/connect';
import { ensureDatabaseSeeded } from './db/seed';
import { logger } from './utils/logger';

async function bootstrap() {
  // Enforce environment integrity and security constraints at boot
  validateEnv();

  const app = createApp();

  try {
    await connectDB(false);
    await ensureDatabaseSeeded();
  } catch (err: any) {
    logger.warn(
      `[Database Warning] Could not establish MongoDB connection: ${err.message}. Ensure mongod is running locally or check fallback settings.`
    );
  }

  const server = app.listen(config.port, '0.0.0.0', () => {
    logger.info(`[SERVER RUNNING] SecureByPay API server running in ${config.nodeEnv} mode on port ${config.port}`);
    if (config.enableSwagger) {
      logger.info(`[DOCS AVAILABLE] Interactive Swagger Documentation: http://localhost:${config.port}/api-docs`);
    }
  });

  // Graceful shutdown on process termination signals
  const shutdown = async () => {
    logger.info('Shutting down server...');
    server.close(async () => {
      await disconnectDB();
      logger.info('Server closed. Goodbye!');
      process.exit(0);
    });
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}

bootstrap().catch((err) => {
  logger.error(err, 'Failed to start server');
  process.exit(1);
});
