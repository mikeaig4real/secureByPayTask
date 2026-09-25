import { ZodError } from 'zod';
import { StatusCodes } from 'http-status-codes';
import { CustomError } from './customError';

export class ValidationError extends CustomError {
  public details?: Record<string, string>;

  constructor(zodError?: ZodError, message?: string) {
    const errorMap: Record<string, string> = {};
    if (zodError) {
      for (const issue of zodError.errors) {
        const path = issue.path.join('.');
        errorMap[path || 'global'] = issue.message;
      }
    }

    const flatMessage = zodError?.errors
      .map((err) => {
        const path = err.path.join('.');
        return path ? `${path}: ${err.message}` : err.message;
      })
      .join('; ');

    super(`Validation Failed: ${flatMessage || message}`, StatusCodes.BAD_REQUEST);
    this.details = errorMap;
  }
}
