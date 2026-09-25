import 'express-async-errors';
import fs from 'fs';
import path from 'path';
import express, { Express } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import { swaggerDocument } from './docs/swagger';
import { httpLogger } from './utils/logger';
import apiRouter from './routes';
import { errorHandler } from './middleware/errorHandler';
import { notFound } from './middleware/notFound';
import { apiLimiter } from './middleware/rateLimiter';
import { config } from './config';

import { isDBConnected, getDBStatus, getActiveDBName } from './db/connect';
import { getCurrentISOString } from './utils/date';

export function createApp(): Express {
  const app = express();

  // Disable ETags to prevent 304 caching on live financial data
  app.set('etag', false);

  app.use(
    helmet({
      contentSecurityPolicy: config.enableSwagger ? false : undefined, // Relax CSP only when Swagger UI is enabled
    })
  );
  app.use(
    cors({
      origin: config.corsOrigin === '*' ? true : config.corsOrigin,
      credentials: true,
    })
  );

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(httpLogger);

  app.get('/health', (req, res) => {
    const dbConnected = isDBConnected();
    res.status(dbConnected ? 200 : 503).json({
      status: dbConnected ? 'ok' : 'degraded',
      service: 'securebypay-backend',
      database: {
        connected: dbConnected,
        status: getDBStatus(),
        name: getActiveDBName() || null,
      },
      timestamp: getCurrentISOString(),
      uptime: process.uptime(),
    });
  });

  if (config.enableSwagger) {
    app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
  }

  // Disable downstream HTTP caching for real-time dashboard state
  app.use('/api', apiLimiter, (req, res, next) => {
    res.set('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
    res.set('Pragma', 'no-cache');
    res.set('Expires', '0');
    next();
  }, apiRouter);

  // Mount Flutter Web SPA bundle if built
  const frontendBuildPath = path.resolve(__dirname, '../../frontend/build/web');
  const hasFrontendBuild = fs.existsSync(frontendBuildPath);
  const shouldServeFrontend = config.nodeEnv !== 'test' && hasFrontendBuild;

  if (shouldServeFrontend) {
    app.use(express.static(frontendBuildPath, { index: false, maxAge: '1d' }));

    // SPA fallback: return index.html for non-API client routes
    app.get('*', (req, res, next) => {
      if (
        req.path.startsWith('/api') ||
        req.path.startsWith('/health') ||
        (config.enableSwagger && req.path.startsWith('/api-docs'))
      ) {
        return next();
      }
      return res.sendFile(path.join(frontendBuildPath, 'index.html'));
    });
  } else {
    // Root handler when Flutter Web SPA bundle is unmounted
    app.get('/', (req, res) => {
      if (config.enableSwagger) {
        res.redirect('/api-docs');
      } else {
        res.json({
          service: 'securebypay-backend',
          status: 'running',
          environment: config.nodeEnv,
        });
      }
    });
  }

  app.use(notFound);
  app.use(errorHandler);

  return app;
}
