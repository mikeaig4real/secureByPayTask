import { StatusCodes } from 'http-status-codes';
import { CustomError } from './customError';

export class NotFoundError extends CustomError {
  constructor(message = 'Resource not found') {
    super(message, StatusCodes.NOT_FOUND);
  }
}
