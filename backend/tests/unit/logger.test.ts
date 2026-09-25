import { describe, it, expect } from 'vitest';
import { sanitizeMongoUri } from '../../src/db/connect';
import { logger } from '../../src/utils/logger';

describe('Logger & URI Sanitization Unit Tests', () => {
  describe('sanitizeMongoUri', () => {
    it('masks credentials in mongodb+srv URIs', () => {
      const uri = 'mongodb+srv://adminUser:SuperSecretPass123!@cluster0.abcde.mongodb.net/securebypay?retryWrites=true';
      const sanitized = sanitizeMongoUri(uri);
      expect(sanitized).toBe('mongodb+srv://***:***@cluster0.abcde.mongodb.net/securebypay?retryWrites=true');
      expect(sanitized).not.toContain('SuperSecretPass123!');
      expect(sanitized).not.toContain('adminUser');
    });

    it('masks credentials in standard mongodb URIs with ports', () => {
      const uri = 'mongodb://dbuser:myPass@127.0.0.1:27017/securebypay';
      const sanitized = sanitizeMongoUri(uri);
      expect(sanitized).toBe('mongodb://***:***@127.0.0.1:27017/securebypay');
      expect(sanitized).not.toContain('myPass');
    });

    it('leaves URIs without credentials unmodified', () => {
      const uri = 'mongodb://127.0.0.1:27017/securebypay?directConnection=true';
      const sanitized = sanitizeMongoUri(uri);
      expect(sanitized).toBe(uri);
    });
  });

  describe('Pino Logger Instance', () => {
    it('is properly instantiated with correct log level', () => {
      expect(logger).toBeDefined();
      expect(typeof logger.info).toBe('function');
      expect(typeof logger.warn).toBe('function');
      expect(typeof logger.error).toBe('function');
    });
  });
});
