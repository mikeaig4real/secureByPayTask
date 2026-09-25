import { Wallet } from '../models/wallet.model';
import { Shipment, IShipment } from '../models/shipment.model';
import { NotFoundError } from '../errors/notFoundError';
import { BadRequestError } from '../errors/badRequestError';
import { runInTransaction } from '../db/transaction';
import { config } from '../config';
import { SupportedCurrency } from '../schemas/currency.schema';
import { formatCurrency } from '../utils/currency';
import {
  mockGrowthChartData,
  mockOverviewStats,
} from '../mock-data';
import { GrowthPeriod } from '../schemas/dashboard.schema';

export class DashboardService {
  async getOverview(userId: string) {
    const wallet = await Wallet.findOne({ userId });
    const balance = wallet ? wallet.balance : config.wallet.initialBalance;
    const currency = (wallet?.currency as SupportedCurrency) || config.wallet.defaultCurrency;

    return {
      wallet: {
        balance,
        currency,
        formatted: formatCurrency(balance, currency),
      },
      stats: mockOverviewStats,
    };
  }

  async getGrowthChart(period: GrowthPeriod = 'Year') {
    return mockGrowthChartData[period] || mockGrowthChartData.Year;
  }

  async getRecentShipments(userId: string): Promise<any[]> {
    return Shipment.find({ userId }).sort({ createdAt: -1 }).lean();
  }

  async fundWallet(userId: string, amount: number) {
    if (amount <= 0) {
      throw new BadRequestError('Funding amount must be greater than zero');
    }

    // Atomic balance increment
    const wallet = await Wallet.findOneAndUpdate(
      { userId },
      { $inc: { balance: amount } },
      { new: true }
    );

    if (!wallet) {
      throw new NotFoundError('Wallet not found');
    }

    const currency = (wallet.currency as SupportedCurrency) || config.wallet.defaultCurrency;
    return {
      balance: wallet.balance,
      currency,
      formatted: formatCurrency(wallet.balance, currency),
    };
  }

  async payShipment(userId: string, shipmentId: string) {
    return runInTransaction(async (session) => {
      const activeSession = session || null;
      const shipment = await Shipment.findById(shipmentId).session(activeSession);
      if (!shipment) {
        throw new NotFoundError('Shipment not found');
      }

      // Tenant isolation: prevent cross-account IDOR payment manipulation
      if (shipment.userId && shipment.userId.toString() !== userId.toString()) {
        throw new NotFoundError('Shipment not found');
      }

      if (shipment.isPaid) {
        throw new BadRequestError('Shipment has already been paid');
      }

      // Atomic conditional deduction preventing race conditions and overdraft
      const wallet = await Wallet.findOneAndUpdate(
        {
          userId,
          balance: { $gte: shipment.amount },
        },
        {
          $inc: { balance: -shipment.amount },
        },
        {
          new: true,
          session: activeSession,
        }
      );

      if (!wallet) {
        throw new BadRequestError('Insufficient wallet balance to pay for this shipment');
      }

      shipment.isPaid = true;
      await shipment.save(session ? { session } : undefined);

      return {
        shipment: shipment.toObject ? shipment.toObject() : shipment,
        newBalance: wallet.balance,
      };
    });
  }
}

export const dashboardService = new DashboardService();
