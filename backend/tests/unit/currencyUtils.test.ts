import { describe, it, expect } from 'vitest';
import {
  CURRENCY_SYMBOLS,
  getCurrencySymbol,
  formatCurrency,
  toMinorUnits,
  fromMinorUnits,
} from '../../src/utils/currency';

describe('Currency Utility (Unit Tests)', () => {
  it('should provide standard currency symbols', () => {
    expect(CURRENCY_SYMBOLS.NGN).toBe('₦');
    expect(CURRENCY_SYMBOLS.USD).toBe('$');
    expect(CURRENCY_SYMBOLS.GBP).toBe('£');
    expect(CURRENCY_SYMBOLS.EUR).toBe('€');
  });

  it('getCurrencySymbol should return matching symbol', () => {
    expect(getCurrencySymbol('NGN')).toBe('₦');
    expect(getCurrencySymbol('USD')).toBe('$');
    expect(getCurrencySymbol('GBP')).toBe('£');
    expect(getCurrencySymbol('EUR')).toBe('€');
  });

  it('formatCurrency should correctly format numbers with commas and two decimals', () => {
    expect(formatCurrency(3000000.28, 'NGN')).toBe('₦3,000,000.28');
    expect(formatCurrency(1500, 'USD')).toBe('$1,500.00');
    expect(formatCurrency(0, 'EUR')).toBe('€0.00');
    expect(formatCurrency(999.9, 'GBP')).toBe('£999.90');
  });

  it('toMinorUnits should accurately convert to minor units (kobo/cents)', () => {
    expect(toMinorUnits(100.5)).toBe(10050);
    expect(toMinorUnits(3000000.28)).toBe(300000028);
  });

  it('fromMinorUnits should accurately convert from minor units to major units', () => {
    expect(fromMinorUnits(10050)).toBe(100.5);
    expect(fromMinorUnits(300000028)).toBe(3000000.28);
  });
});
