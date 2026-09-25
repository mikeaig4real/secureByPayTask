import { describe, it, expect } from 'vitest';
import {
  Temporal,
  getCurrentInstant,
  getCurrentISOString,
  getCurrentPlainDate,
  toTemporalInstant,
  toLegacyDate,
  formatDateReadable,
  formatDateTimeReadable,
  getRelativeTime,
  isPast,
  isFuture,
  addDays,
  diffInDays,
} from '../../src/utils/date';

describe('Date Temporal API & Date Utilities (Unit Tests)', () => {
  it('should expose a functional Temporal API instance', () => {
    expect(Temporal).toBeDefined();
    expect(typeof Temporal.Now.instant).toBe('function');
    expect(typeof Temporal.PlainDate).toBe('function');
  });

  it('getCurrentInstant() should return a valid Temporal.Instant with nanosecond precision', () => {
    const instant = getCurrentInstant();
    expect(instant).toBeInstanceOf(Temporal.Instant);
    expect(instant.epochMilliseconds).toBeGreaterThan(0);
  });

  it('getCurrentISOString() should return a valid ISO 8601 UTC timestamp', () => {
    const isoString = getCurrentISOString();
    expect(isoString).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/);
  });

  it('getCurrentPlainDate() should return a valid PlainDate with year, month, and day', () => {
    const plainDate = getCurrentPlainDate();
    expect(plainDate.year).toBeGreaterThanOrEqual(2024);
    expect(plainDate.month).toBeGreaterThanOrEqual(1);
    expect(plainDate.month).toBeLessThanOrEqual(12);
    expect(plainDate.day).toBeGreaterThanOrEqual(1);
    expect(plainDate.day).toBeLessThanOrEqual(31);
  });

  it('toTemporalInstant and toLegacyDate should convert back and forth without data loss', () => {
    const originalDate = new Date('2026-06-15T12:00:00.000Z');
    const instant = toTemporalInstant(originalDate);
    expect(instant.epochMilliseconds).toBe(originalDate.getTime());

    const convertedDate = toLegacyDate(instant);
    expect(convertedDate.getTime()).toBe(originalDate.getTime());
  });

  it('formatDateReadable should format dates cleanly (e.g., Sep 24, 2026)', () => {
    const testDate = new Date('2026-09-24T10:00:00.000Z');
    const formatted = formatDateReadable(testDate, 'UTC');
    expect(formatted).toBe('Sep 24, 2026');
  });

  it('formatDateTimeReadable should include 12-hour time and AM/PM', () => {
    const testDate = new Date('2026-09-24T14:35:00.000Z');
    const formatted = formatDateTimeReadable(testDate, 'UTC');
    expect(formatted).toBe('Sep 24, 2026, 2:35 PM');
  });

  it('getRelativeTime should compute human-friendly relative differences', () => {
    const baseInstant = Temporal.Instant.from('2026-09-24T12:00:00Z');

    const justNowInstant = Temporal.Instant.from('2026-09-24T11:59:50Z');
    expect(getRelativeTime(justNowInstant, baseInstant)).toBe('just now');

    const fifteenMinutesAgo = Temporal.Instant.from('2026-09-24T11:45:00Z');
    expect(getRelativeTime(fifteenMinutesAgo, baseInstant)).toBe('15 minutes ago');

    const twoHoursAgo = Temporal.Instant.from('2026-09-24T10:00:00Z');
    expect(getRelativeTime(twoHoursAgo, baseInstant)).toBe('2 hours ago');

    const threeDaysAgo = Temporal.Instant.from('2026-09-21T12:00:00Z');
    expect(getRelativeTime(threeDaysAgo, baseInstant)).toBe('3 days ago');

    const fiveMinutesLater = Temporal.Instant.from('2026-09-24T12:05:00Z');
    expect(getRelativeTime(fiveMinutesLater, baseInstant)).toBe('in 5 minutes');
  });

  it('isPast and isFuture should accurately determine temporal order', () => {
    const pastDate = new Date(Date.now() - 60000);
    const futureDate = new Date(Date.now() + 60000);

    expect(isPast(pastDate)).toBe(true);
    expect(isFuture(pastDate)).toBe(false);

    expect(isFuture(futureDate)).toBe(true);
    expect(isPast(futureDate)).toBe(false);
  });

  it('addDays and diffInDays should perform calendar arithmetic correctly', () => {
    const dateA = Temporal.PlainDate.from('2026-09-01');
    const dateB = addDays(dateA, 14);

    expect(dateB.toString()).toBe('2026-09-15');
    expect(diffInDays(dateB, dateA)).toBe(14);
  });
});
