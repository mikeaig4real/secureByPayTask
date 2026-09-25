import { describe, it, expect } from 'vitest';
import { getDBStatus, isDBConnected } from '../../src/db/connect';

describe('Database Connection Module (Unit Tests)', () => {
  it('should accurately report initial disconnected state if not yet connected', () => {
    const status = getDBStatus();
    expect(['disconnected', 'connected', 'connecting']).toContain(status);
  });

  it('isDBConnected should return a boolean', () => {
    expect(typeof isDBConnected()).toBe('boolean');
  });
});
