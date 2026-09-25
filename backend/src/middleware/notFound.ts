import { Request, Response, NextFunction } from 'express';
import { NotFoundError } from '../errors/notFoundError';

export function notFound(req: Request, res: Response, next: NextFunction) {
  next(new NotFoundError(`Route not found: ${req.method} ${req.originalUrl}`));
}
