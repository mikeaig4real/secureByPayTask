import { Temporal } from '@js-temporal/polyfill';

// Polyfill registration for Temporal API in environments lacking native support
if (typeof (globalThis as any).Temporal === 'undefined') {
  (globalThis as any).Temporal = Temporal;
}

export { Temporal };

export const DEFAULT_TIMEZONE = 'Africa/Lagos';

/**
 * Returns the current Temporal Instant (UTC nanosecond precision).
 */
export function getCurrentInstant(): Temporal.Instant {
  return Temporal.Now.instant();
}

/**
 * Returns current ISO 8601 timestamp string (UTC).
 */
export function getCurrentISOString(): string {
  return Temporal.Now.instant().toString();
}

/**
 * Returns current PlainDate in the specified or default timezone.
 */
export function getCurrentPlainDate(timeZone: string = DEFAULT_TIMEZONE): Temporal.PlainDate {
  return Temporal.Now.plainDateISO(timeZone);
}

/**
 * Converts a legacy JavaScript Date, ISO string, or Temporal.Instant into a Temporal.Instant.
 */
export function toTemporalInstant(input: Temporal.Instant | Date | string | number): Temporal.Instant {
  if (input instanceof Temporal.Instant) {
    return input;
  }
  if (input instanceof Date) {
    return Temporal.Instant.fromEpochMilliseconds(input.getTime());
  }
  if (typeof input === 'number') {
    return Temporal.Instant.fromEpochMilliseconds(input);
  }
  return Temporal.Instant.from(input);
}

/**
 * Converts a Temporal.Instant back to a legacy JavaScript Date (for Mongoose/MongoDB compatibility).
 */
export function toLegacyDate(instant: Temporal.Instant): Date {
  return new Date(instant.epochMilliseconds);
}

/**
 * Formats an instant or date into a human-readable string (e.g. "Sep 24, 2026").
 */
export function formatDateReadable(
  input: Temporal.Instant | Date | string | number,
  timeZone: string = DEFAULT_TIMEZONE
): string {
  const instant = toTemporalInstant(input);
  const zonedDateTime = instant.toZonedDateTimeISO(timeZone);

  const monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  return `${monthNames[zonedDateTime.month - 1]} ${zonedDateTime.day}, ${zonedDateTime.year}`;
}

/**
 * Formats an instant or date with time (e.g. "Sep 24, 2026, 08:30 AM").
 */
export function formatDateTimeReadable(
  input: Temporal.Instant | Date | string | number,
  timeZone: string = DEFAULT_TIMEZONE
): string {
  const instant = toTemporalInstant(input);
  const zonedDateTime = instant.toZonedDateTimeISO(timeZone);

  const datePart = formatDateReadable(input, timeZone);
  const hour12 = zonedDateTime.hour % 12 || 12;
  const ampm = zonedDateTime.hour >= 12 ? 'PM' : 'AM';
  const minutePadded = zonedDateTime.minute.toString().padStart(2, '0');

  return `${datePart}, ${hour12}:${minutePadded} ${ampm}`;
}

/**
 * Computes human-friendly relative time (e.g. "just now", "15 minutes ago", "3 hours ago", "in 2 days").
 */
export function getRelativeTime(
  input: Temporal.Instant | Date | string | number,
  referenceInstant: Temporal.Instant = Temporal.Now.instant()
): string {
  const target = toTemporalInstant(input);
  const diffMilliseconds = target.epochMilliseconds - referenceInstant.epochMilliseconds;
  const isPast = diffMilliseconds <= 0;
  const absSeconds = Math.floor(Math.abs(diffMilliseconds) / 1000);

  if (absSeconds < 45) {
    return 'just now';
  }

  const absMinutes = Math.floor(absSeconds / 60);
  if (absMinutes < 60) {
    const unit = absMinutes === 1 ? 'minute' : 'minutes';
    return isPast ? `${absMinutes} ${unit} ago` : `in ${absMinutes} ${unit}`;
  }

  const absHours = Math.floor(absMinutes / 60);
  if (absHours < 24) {
    const unit = absHours === 1 ? 'hour' : 'hours';
    return isPast ? `${absHours} ${unit} ago` : `in ${absHours} ${unit}`;
  }

  const absDays = Math.floor(absHours / 24);
  if (absDays < 30) {
    const unit = absDays === 1 ? 'day' : 'days';
    return isPast ? `${absDays} ${unit} ago` : `in ${absDays} ${unit}`;
  }

  const absMonths = Math.floor(absDays / 30);
  if (absMonths < 12) {
    const unit = absMonths === 1 ? 'month' : 'months';
    return isPast ? `${absMonths} ${unit} ago` : `in ${absMonths} ${unit}`;
  }

  const absYears = Math.floor(absDays / 365);
  const unit = absYears === 1 ? 'year' : 'years';
  return isPast ? `${absYears} ${unit} ago` : `in ${absYears} ${unit}`;
}

/**
 * Checks if an instant is in the past relative to now.
 */
export function isPast(input: Temporal.Instant | Date | string | number): boolean {
  const target = toTemporalInstant(input);
  return target.epochMilliseconds < Temporal.Now.instant().epochMilliseconds;
}

/**
 * Checks if an instant is in the future relative to now.
 */
export function isFuture(input: Temporal.Instant | Date | string | number): boolean {
  const target = toTemporalInstant(input);
  return target.epochMilliseconds > Temporal.Now.instant().epochMilliseconds;
}

/**
 * Adds or subtracts days to a PlainDate using Temporal arithmetic.
 */
export function addDays(date: Temporal.PlainDate, days: number): Temporal.PlainDate {
  return date.add({ days });
}

/**
 * Calculates calendar difference in days between two PlainDate values.
 */
export function diffInDays(dateA: Temporal.PlainDate, dateB: Temporal.PlainDate): number {
  return dateA.since(dateB).days;
}
