import { Request, Response } from 'express';
import { AuthService, authService as defaultAuthService } from '../services/auth.service';
import { CustomResponse } from '../responses/customResponse';
import { AuthenticatedRequest, getAuthUser } from '../middleware/authMiddleware';
import { RegisterInput, LoginInput } from '../schemas/auth.schema';

export class AuthController {
  constructor(private service: AuthService = defaultAuthService) {}

  register = async (req: Request<{}, {}, RegisterInput>, res: Response) => {
    const result = await this.service.register(req.body);
    return CustomResponse.created(res, result, 'Account registered successfully');
  };

  login = async (req: Request<{}, {}, LoginInput>, res: Response) => {
    const result = await this.service.login(req.body);
    return CustomResponse.success(res, result, 'Logged in successfully');
  };

  getMe = async (req: AuthenticatedRequest, res: Response) => {
    const { userId } = getAuthUser(req);
    const profile = await this.service.getProfile(userId);
    return CustomResponse.success(res, profile, 'User profile retrieved');
  };
}

export const authController = new AuthController();
