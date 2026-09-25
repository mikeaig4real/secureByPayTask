import { Response } from 'express';
import { StatusCodes } from 'http-status-codes';

export class CustomResponse {
  static success<T>(res: Response, data: T, message = 'Success', status = StatusCodes.OK) {
    return res.status(status).json({
      success: true,
      message,
      data,
    });
  }

  static created<T>(res: Response, data: T, message = 'Created successfully') {
    return res.status(StatusCodes.CREATED).json({
      success: true,
      message,
      data,
    });
  }

  static error(res: Response, message: string, status = StatusCodes.INTERNAL_SERVER_ERROR, details?: any) {
    return res.status(status).json({
      success: false,
      error: message,
      details,
    });
  }
}
