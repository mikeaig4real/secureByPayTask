import pino from 'pino';
import pinoHttp from 'pino-http';
import { config } from '../config';

export const logger = pino({
  level: config.logLevel,
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
      // Suppress logging for high-frequency health probes and static docs
      return req.url?.startsWith('/api-docs') || req.url === '/health';
    },
  },
});
