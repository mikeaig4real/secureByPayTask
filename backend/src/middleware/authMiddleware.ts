import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { AuthError } from '../errors/authError';
import { config } from '../config';

export interface AuthUserPayload {
  userId: string;
  email: string;
  firstName: string;
  lastName: string;
}

/**
 * Authenticated Request interface
 */
export interface AuthRequest<
  Params = any,
  ResBody = any,
  ReqBody = any,
  ReqQuery = any
> extends Request<Params, ResBody, ReqBody, ReqQuery> {
  user?: AuthUserPayload;
}

export type AuthenticatedRequest<
  Params = any,
  ResBody = any,
  ReqBody = any,
  ReqQuery = any
> = AuthRequest<Params, ResBody, ReqBody, ReqQuery>;

/**
 * Helper to safely extract authenticated user from request
 */
export function getAuthUser(req: Request | AuthRequest): AuthUserPayload {
  const user = (req as AuthRequest).user;
  if (!user) {
    throw new AuthError('Access token required');
  }
  return user;
}

export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new AuthError('Access token required');
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, config.jwtSecret) as AuthUserPayload;
    (req as AuthenticatedRequest).user = decoded;
    next();
  } catch (err: any) {
    if (err.name === 'TokenExpiredError') {
      throw new AuthError('Token expired, please login again');
    }
    throw new AuthError('Invalid or malformed token');
  }
}

