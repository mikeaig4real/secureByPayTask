import { Router } from 'express';
import { authController } from '../controllers/auth.controller';
import { validate } from '../middleware/validateRequest';
import { authMiddleware } from '../middleware/authMiddleware';
import { authLimiter } from '../middleware/rateLimiter';
import { registerSchema, loginSchema } from '../schemas/auth.schema';

const router = Router();

router.post('/register', authLimiter, validate(registerSchema), authController.register);
router.post('/login', authLimiter, validate(loginSchema), authController.login);
router.get('/me', authMiddleware, authController.getMe);

export default router;
