import { Request, Response, NextFunction } from 'express';
import { StatusCodes } from 'http-status-codes';
import { CustomError } from '../errors/customError';
import { ValidationError } from '../errors/validationError';
import { logger } from '../utils/logger';

export function errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
  // Delegate to Express default error handler if headers were already sent
  if (res.headersSent) {
    return next(err);
  }

  if (err instanceof CustomError) {
    logger.warn({ err: err.message, status: err.status, path: req.path }, 'Operational error');
    return res.status(err.status).json({
      success: false,
      error: err.message,
      ...(err instanceof ValidationError && err.details ? { details: err.details } : {}),
    });
  }

  // Mongoose duplicate key conflict (E11000)
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue || {})[0] || 'Field';
    const message = `${field} already exists`;
    logger.warn({ field, path: req.path }, 'Duplicate key error');
    return res.status(StatusCodes.CONFLICT).json({
      success: false,
      error: message,
    });
  }

  // Mongoose CastError (e.g. malformed ObjectId)
  if (err.name === 'CastError') {
    return res.status(StatusCodes.BAD_REQUEST).json({
      success: false,
      error: `Invalid ${err.path}: ${err.value}`,
    });
  }

  logger.error({ err, path: req.path }, 'Unhandled server error');
  return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
    success: false,
    error: 'Internal server error',
  });
}
