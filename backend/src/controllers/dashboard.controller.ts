import { Response } from 'express';
import { DashboardService, dashboardService as defaultDashboardService } from '../services/dashboard.service';
import { CustomResponse } from '../responses/customResponse';
import { AuthenticatedRequest, getAuthUser } from '../middleware/authMiddleware';
import {
  GrowthChartQuery,
  FundWalletInput,
  PayShipmentParams,
} from '../schemas/dashboard.schema';

export class DashboardController {
  constructor(private service: DashboardService = defaultDashboardService) {}

  getOverview = async (req: AuthenticatedRequest, res: Response) => {
    const { userId } = getAuthUser(req);
    const overview = await this.service.getOverview(userId);
    return CustomResponse.success(res, overview, 'Overview data retrieved');
  };

  getGrowthChart = async (req: AuthenticatedRequest<{}, {}, {}, GrowthChartQuery>, res: Response) => {
    const period = req.query.period || 'Year';
    const chartData = await this.service.getGrowthChart(period);
    return CustomResponse.success(res, chartData, 'Growth chart data retrieved');
  };

  getShipments = async (req: AuthenticatedRequest, res: Response) => {
    const { userId } = getAuthUser(req);
    const shipments = await this.service.getRecentShipments(userId);
    return CustomResponse.success(res, shipments, 'Recent shipments retrieved');
  };

  fundWallet = async (req: AuthenticatedRequest<{}, {}, FundWalletInput>, res: Response) => {
    const { userId } = getAuthUser(req);
    const { amount } = req.body;
    const result = await this.service.fundWallet(userId, amount);
    return CustomResponse.success(res, result, 'Wallet funded successfully');
  };

  payShipment = async (req: AuthenticatedRequest<PayShipmentParams>, res: Response) => {
    const { userId } = getAuthUser(req);
    const { id } = req.params;
    const result = await this.service.payShipment(userId, id);
    return CustomResponse.success(res, result, 'Shipment payment processed');
  };
}

export const dashboardController = new DashboardController();
