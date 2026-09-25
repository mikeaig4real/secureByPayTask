import rateLimit from 'express-rate-limit';
import { Request, Response } from 'express';
import { config } from '../config';

const isTest = config.nodeEnv === 'test';

/**
 * Standard API rate limiter.
 * Caps requests to prevent resource exhaustion and distributed DoS attacks.
 */
export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 500,
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => isTest,
  message: {
    success: false,
    error: 'Too many requests from this IP, please try again after 15 minutes.',
  },
});

/**
 * Strict authentication rate limiter.
 * Defends against brute-force password cracking and credential-stuffing attacks.
 */
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => isTest,
  handler: (req: Request, res: Response) => {
    res.status(429).json({
      success: false,
      error: 'Too many authentication attempts. Please try again after 15 minutes.',
    });
  },
});

/**
 * Financial operations rate limiter.
 * Protects against wallet funding spam and double-payment races.
 */
export const financialLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 30,
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => isTest,
  handler: (req: Request, res: Response) => {
    res.status(429).json({
      success: false,
      error: 'Rate limit exceeded for financial operations. Please wait a moment and try again.',
    });
  },
});
