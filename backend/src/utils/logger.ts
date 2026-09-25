import pino from 'pino';
import pinoHttp from 'pino-http';
import { config } from '../config';

export const logger = pino({
  level: config.logLevel,
  redact: {
    paths: [
      'req.headers.authorization',
      'req.headers.cookie',
      'req.headers["x-access-token"]',
      'password',
      '*.password',
      'token',
      '*.token',
      'secret',
      '*.secret',
      'jwtSecret',
    ],
    censor: '***REDACTED***',
  },
  transport:
    config.nodeEnv === 'development'
      ? {
          target: 'pino-pretty',
          options: {
            colorize: true,
            translateTime: 'HH:MM:ss',
            ignore: 'pid,hostname',
            singleLine: true,
          },
        }
      : undefined,
});

export const httpLogger = pinoHttp({
  logger,
  customLogLevel: function (req, res, err) {
    if (res.statusCode >= 500 || err) {
      return 'error';
    } else if (res.statusCode >= 400) {
      return 'warn';
    }
    return 'info';
  },
  customSuccessMessage: (req, res, responseTime) => {
    return `${req.method} ${req.url} ${res.statusCode} (${responseTime}ms)`;
  },
  customErrorMessage: (req, res, err) => {
    return `${req.method} ${req.url} ${res.statusCode} - ${err.message}`;
  },
  serializers: {
    req: () => undefined,
    res: () => undefined,
  },
  autoLogging: {
    ignore: (req) => {
      // Suppress logging for high-frequency health probes, swagger docs, and static SPA assets
      const url = req.url || '';
      return (
        url.startsWith('/api-docs') ||
        url === '/health' ||
        url.endsWith('.js') ||
        url.endsWith('.wasm') ||
        url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.ico') ||
        url.endsWith('.json') ||
        url.endsWith('.ttf') ||
        url.endsWith('.woff') ||
        url.endsWith('.woff2')
      );
    },
  },
});
