import { Router } from 'express';
import { dashboardController } from '../controllers/dashboard.controller';
import { authMiddleware } from '../middleware/authMiddleware';
import { validate } from '../middleware/validateRequest';
import { financialLimiter } from '../middleware/rateLimiter';
import { fundWalletSchema, payShipmentSchema, growthChartSchema } from '../schemas/dashboard.schema';

const router = Router();

// Enforce authentication across all dashboard routes
router.use(authMiddleware);

router.get('/overview', dashboardController.getOverview);
router.get('/growth', validate(growthChartSchema), dashboardController.getGrowthChart);
router.get('/shipments', dashboardController.getShipments);
router.post('/wallet/fund', financialLimiter, validate(fundWalletSchema), dashboardController.fundWallet);
router.post('/shipments/:id/pay', financialLimiter, validate(payShipmentSchema), dashboardController.payShipment);

export default router;
