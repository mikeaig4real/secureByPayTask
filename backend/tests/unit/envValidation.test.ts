import crypto from 'crypto';
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { validateEnv, config } from '../../src/config';

describe('Environment Security & Integrity Validation (Unit Tests)', () => {
  const originalEnv = { ...process.env };

  beforeEach(() => {
    process.env = {
      ...originalEnv,
      NODE_ENV: 'test',
      JWT_SECRET: crypto.randomBytes(32).toString('hex'),
      MONGO_URI: 'mongodb://127.0.0.1:27017/securebypay_test',
      MONGO_TEST_URI: 'mongodb://127.0.0.1:27017/securebypay_test',
    };
  });

  afterEach(() => {
    process.env = { ...originalEnv };
  });

  it('should pass when all required variables and security requirements are satisfied', () => {
    expect(() => validateEnv()).not.toThrow();
  });

  it('should throw an error if JWT_SECRET is missing', () => {
    delete process.env.JWT_SECRET;
    expect(() => validateEnv()).toThrow(/Missing mandatory environment variable/);
  });

  it('should throw an error if JWT_SECRET is too short (< 16 characters)', () => {
    process.env.JWT_SECRET = 'short_secret';
    expect(() => validateEnv()).toThrow(/JWT_SECRET must be at least 16 characters/);
  });

  it('should throw an error if MONGO_TEST_URI does not contain _test in test mode', () => {
    process.env.NODE_ENV = 'test';
    process.env.MONGO_TEST_URI = 'mongodb://127.0.0.1:27017/securebypay_production';
    expect(() => validateEnv()).toThrow(/must contain '_test' in its database name/);
  });

  it('should not require MONGO_TEST_URI in production mode', () => {
    process.env.NODE_ENV = 'production';
    delete process.env.MONGO_TEST_URI;
    expect(() => validateEnv()).not.toThrow();
  });

  it('should throw an error if DEFAULT_CURRENCY is not in supported currencies enum', () => {
    process.env.DEFAULT_CURRENCY = 'BITCOIN';
    expect(() => validateEnv()).toThrow(/Invalid enum value|DEFAULT_CURRENCY/);
  });

  it('should throw an error if DEFAULT_INITIAL_WALLET_BALANCE is negative', () => {
    process.env.DEFAULT_INITIAL_WALLET_BALANCE = '-500';
    expect(() => validateEnv()).toThrow(/DEFAULT_INITIAL_WALLET_BALANCE must be a non-negative number/);
  });

  it('should dynamically provide configured wallet parameters via config.wallet', () => {
    process.env.DEFAULT_CURRENCY = 'USD';
    process.env.DEFAULT_INITIAL_WALLET_BALANCE = '1500000.50';

    expect(config.wallet.defaultCurrency).toBe('USD');
    expect(config.wallet.initialBalance).toBe(1500000.5);
  });

  it('should throw an error if BCRYPT_SALT_ROUNDS is below 4 or above 16', () => {
    process.env.BCRYPT_SALT_ROUNDS = '2';
    expect(() => validateEnv()).toThrow(/BCRYPT_SALT_ROUNDS must be at least 4/);

    process.env.BCRYPT_SALT_ROUNDS = '20';
    expect(() => validateEnv()).toThrow(/BCRYPT_SALT_ROUNDS cannot exceed 16/);
  });

  it('should dynamically provide configured bcrypt salt rounds via config.bcryptSaltRounds', () => {
    process.env.BCRYPT_SALT_ROUNDS = '12';
    expect(config.bcryptSaltRounds).toBe(12);
  });

  it('should dynamically provide configured demo user parameters via config.demoUser', () => {
    process.env.DEMO_USER_EMAIL = 'custom_demo@securebypay.com';
    process.env.DEMO_USER_PASSWORD = 'CustomPassword456!';
    process.env.DEMO_USER_FIRST_NAME = 'Ada';
    process.env.DEMO_USER_LAST_NAME = 'Lovelace';

    expect(config.demoUser.email).toBe('custom_demo@securebypay.com');
    expect(config.demoUser.password).toBe('CustomPassword456!');
    expect(config.demoUser.firstName).toBe('Ada');
    expect(config.demoUser.lastName).toBe('Lovelace');
  });

  it('should default enableSwagger to true in development and false in production', () => {
    delete process.env.ENABLE_SWAGGER;

    process.env.NODE_ENV = 'development';
    expect(config.enableSwagger).toBe(true);

    process.env.NODE_ENV = 'production';
    expect(config.enableSwagger).toBe(false);
  });

  it('should allow ENABLE_SWAGGER environment variable to explicitly override default environment behavior', () => {
    process.env.NODE_ENV = 'production';
    process.env.ENABLE_SWAGGER = 'true';
    expect(config.enableSwagger).toBe(true);

    process.env.NODE_ENV = 'development';
    process.env.ENABLE_SWAGGER = 'false';
    expect(config.enableSwagger).toBe(false);
  });
});
