import { SupportedCurrency } from '../schemas/currency.schema';

/**
 * Currency symbol mapping for supported ISO currencies.
 */
export const CURRENCY_SYMBOLS: Record<SupportedCurrency, string> = {
  NGN: '₦',
  USD: '$',
  GBP: '£',
  EUR: '€',
};

/**
 * Retrieves the display symbol for a given currency code.
 */
export function getCurrencySymbol(currency: SupportedCurrency = 'NGN'): string {
  return CURRENCY_SYMBOLS[currency] || '₦';
}

/**
 * Formats a monetary number with appropriate symbol and thousands separators.
 * Example: 3000000.28, 'NGN' -> '₦3,000,000.28'
 */
export function formatCurrency(amount: number, currency: SupportedCurrency = 'NGN'): string {
  const symbol = getCurrencySymbol(currency);
  return `${symbol}${amount.toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

/**
 * Converts a major currency unit (e.g. 100.50 NGN) to minor units (10050 kobo/cents).
 * Financial best practice for integer-based transactions without floating point precision issues.
 */
export function toMinorUnits(amount: number): number {
  return Math.round(amount * 100);
}

/**
 * Converts minor currency units (e.g. 10050 kobo/cents) to major units (100.50).
 */
export function fromMinorUnits(minorAmount: number): number {
  return minorAmount / 100;
}
