import { z } from 'zod';

/**
 * Currency Codes.
 */
export const SUPPORTED_CURRENCIES = ['NGN', 'USD', 'GBP', 'EUR'] as const;

export type SupportedCurrency = (typeof SUPPORTED_CURRENCIES)[number];

export const currencySchema = z.enum(SUPPORTED_CURRENCIES);
