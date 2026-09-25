import { StatusCodes } from 'http-status-codes';
import { CustomError } from './customError';

export class AuthError extends CustomError {
  constructor(message = 'Authentication failed') {
    super(message, StatusCodes.UNAUTHORIZED);
  }
}
