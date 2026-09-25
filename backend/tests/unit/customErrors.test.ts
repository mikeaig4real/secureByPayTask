import { describe, it, expect } from 'vitest';
import { StatusCodes } from 'http-status-codes';
import { z } from 'zod';
import { CustomError } from '../../src/errors/customError';
import { BadRequestError } from '../../src/errors/badRequestError';
import { AuthError } from '../../src/errors/authError';
import { NotFoundError } from '../../src/errors/notFoundError';
import { ValidationError } from '../../src/errors/validationError';

describe('Custom Errors (Unit Tests)', () => {
  it('should initialize CustomError with status code', () => {
    const error = new CustomError('Something broke', StatusCodes.INTERNAL_SERVER_ERROR);
    expect(error.message).toBe('Something broke');
    expect(error.status).toBe(500);
    expect(error instanceof Error).toBe(true);
  });

  it('should initialize BadRequestError with 400', () => {
    const error = new BadRequestError('Bad input');
    expect(error.message).toBe('Bad input');
    expect(error.status).toBe(StatusCodes.BAD_REQUEST);
  });

  it('should initialize AuthError with 401', () => {
    const error = new AuthError('Token invalid');
    expect(error.message).toBe('Token invalid');
    expect(error.status).toBe(StatusCodes.UNAUTHORIZED);
  });

  it('should initialize NotFoundError with 404', () => {
    const error = new NotFoundError('Item not found');
    expect(error.message).toBe('Item not found');
    expect(error.status).toBe(StatusCodes.NOT_FOUND);
  });

  it('should map ZodError details inside ValidationError', () => {
    const schema = z.object({
      email: z.string().email(),
    });

    const parsed = schema.safeParse({ email: 'bad-email' });
    expect(parsed.success).toBe(false);

    if (!parsed.success) {
      const error = new ValidationError(parsed.error);
      expect(error.status).toBe(StatusCodes.BAD_REQUEST);
      expect(error.details).toBeDefined();
      expect(error.details?.email).toBeDefined();
      expect(error.message).toContain('Validation Failed');
    }
  });
});
