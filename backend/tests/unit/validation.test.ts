import { describe, it, expect } from 'vitest';
import { registerSchema, loginSchema } from '../../src/schemas/auth.schema';
import { fundWalletSchema } from '../../src/schemas/dashboard.schema';

describe('Validation Schemas (Unit Tests)', () => {
  describe('Register Schema', () => {
    it('should validate a valid register request', () => {
      const validPayload = {
        body: {
          firstName: 'Michael',
          lastName: 'Aigbovbiosa',
          email: 'michael@securebypay.com',
          phone: '+2348012345678',
          password: 'Password123!',
        },
      };

      const result = registerSchema.safeParse(validPayload);
      expect(result.success).toBe(true);
    });

    it('should fail if email is invalid', () => {
      const invalidPayload = {
        body: {
          firstName: 'Michael',
          lastName: 'Aigbovbiosa',
          email: 'not-an-email',
          phone: '+2348012345678',
          password: 'Password123!',
        },
      };

      const result = registerSchema.safeParse(invalidPayload);
      expect(result.success).toBe(false);
      if (!result.success) {
        expect(result.error.errors[0].message).toContain('Invalid email');
      }
    });

    it('should fail if password is shorter than 6 characters', () => {
      const invalidPayload = {
        body: {
          firstName: 'Michael',
          lastName: 'Aigbovbiosa',
          email: 'test@example.com',
          phone: '+2348012345678',
          password: '123',
        },
      };

      const result = registerSchema.safeParse(invalidPayload);
      expect(result.success).toBe(false);
      if (!result.success) {
        expect(result.error.errors[0].message).toContain('at least 6 characters');
      }
    });
  });

  describe('Login Schema', () => {
    it('should validate a valid login request', () => {
      const payload = {
        body: {
          email: 'user@example.com',
          password: 'SecretPassword',
        },
      };

      const result = loginSchema.safeParse(payload);
      expect(result.success).toBe(true);
    });

    it('should fail if email is missing', () => {
      const payload = {
        body: {
          password: 'SecretPassword',
        },
      };

      const result = loginSchema.safeParse(payload);
      expect(result.success).toBe(false);
    });
  });

  describe('Fund Wallet Schema', () => {
    it('should validate positive funding amounts', () => {
      const payload = { body: { amount: 5000 } };
      const result = fundWalletSchema.safeParse(payload);
      expect(result.success).toBe(true);
    });

    it('should reject non-positive or negative funding amounts', () => {
      const payload = { body: { amount: -100 } };
      const result = fundWalletSchema.safeParse(payload);
      expect(result.success).toBe(false);
    });
  });
});
