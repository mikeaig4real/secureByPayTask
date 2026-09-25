import crypto from 'crypto';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    testTimeout: 20000,
    env: {
      NODE_ENV: 'test',
      JWT_SECRET: crypto.randomBytes(32).toString('hex'),
      MONGO_URI: 'mongodb://127.0.0.1:27017/securebypay_test',
      MONGO_TEST_URI: 'mongodb://127.0.0.1:27017/securebypay_test',
    },
  },
});
