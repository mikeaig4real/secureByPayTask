import { z } from 'zod';
import { currencySchema } from './currency.schema';

export const fundWalletSchema = z.object({
  body: z.object({
    amount: z.number().positive('Amount must be greater than zero'),
    currency: currencySchema.optional(),
  }),
});

export const payShipmentSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Shipment ID is required'),
  }),
});

export const growthChartSchema = z.object({
  query: z.object({
    period: z.enum(['Year', 'Month', 'Week']).optional().default('Year'),
  }),
});

export type FundWalletInput = z.infer<typeof fundWalletSchema>['body'];
export type PayShipmentParams = z.infer<typeof payShipmentSchema>['params'];
export type GrowthChartQuery = z.infer<typeof growthChartSchema>['query'];
export type GrowthPeriod = 'Year' | 'Month' | 'Week';
