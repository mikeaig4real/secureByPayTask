import dotenv from 'dotenv';
import { z } from 'zod';
import { currencySchema, SupportedCurrency } from '../schemas/currency.schema';

dotenv.config();

/**
 * Zod schema defining all environment and configuration variables.
 * Enforces strict typing, entropy constraints, and enterprise financial defaults.
 */
export const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(5000),
  JWT_SECRET: z
    .string({ required_error: 'Missing mandatory environment variable: JWT_SECRET' })
    .min(1, 'Missing mandatory environment variable: JWT_SECRET')
    .refine((val) => val.length >= 16, {
      message: 'JWT_SECRET must be at least 16 characters long to prevent brute-force signature attacks.',
    }),
  JWT_EXPIRES_IN: z.string().default('7d'),
  ENABLE_SWAGGER: z.string().optional(),
  CORS_ORIGIN: z.string().default('*'),
  LOG_LEVEL: z.string().default('info'),
  BCRYPT_SALT_ROUNDS: z.coerce
    .number({ invalid_type_error: 'BCRYPT_SALT_ROUNDS must be a number' })
    .int('BCRYPT_SALT_ROUNDS must be an integer')
    .min(4, 'BCRYPT_SALT_ROUNDS must be at least 4')
    .max(16, 'BCRYPT_SALT_ROUNDS cannot exceed 16')
    .default(10),
  DEFAULT_CURRENCY: currencySchema.default('NGN'),
  DEFAULT_INITIAL_WALLET_BALANCE: z.coerce
    .number({ invalid_type_error: 'DEFAULT_INITIAL_WALLET_BALANCE must be a valid number' })
    .min(0, 'DEFAULT_INITIAL_WALLET_BALANCE must be a non-negative number')
    .default(3000000.28),
  DEMO_USER_EMAIL: z.string().email('DEMO_USER_EMAIL must be a valid email').default('bunmi@securebypay.com'),
  DEMO_USER_PASSWORD: z.string().min(6, 'DEMO_USER_PASSWORD must be at least 6 characters').default('Password123!'),
  DEMO_USER_FIRST_NAME: z.string().min(1, 'DEMO_USER_FIRST_NAME is required').default('Bunmi'),
  DEMO_USER_LAST_NAME: z.string().min(1, 'DEMO_USER_LAST_NAME is required').default('Tanny'),
  DEMO_USER_PHONE: z.string().default('+2348012345678'),
  MONGO_URI: z
    .string({ required_error: 'Missing mandatory environment variable: MONGO_URI' })
    .min(1, 'Missing mandatory environment variable: MONGO_URI'),
  MONGO_TEST_URI: z
    .string({ required_error: 'Missing mandatory environment variable: MONGO_TEST_URI' })
    .min(1, 'Missing mandatory environment variable: MONGO_TEST_URI')
    .refine((val) => val.toLowerCase().includes('_test'), {
      message: "MONGO_TEST_URI must contain '_test' in its database name to prevent accidental test contamination of production/development data.",
    }),
  MONGO_FALLBACK_URI: z.string().optional(),
  MONGO_TEST_FALLBACK_URI: z.string().optional(),
});

export type EnvConfig = z.infer<typeof envSchema>;

/**
 * Validates environment variables using Zod before server boots.
 * Throws descriptive security / integrity errors on failure.
 */
export function validateEnv(): EnvConfig {
  const result = envSchema.safeParse(process.env);

  if (!result.success) {
    const errorDetails = result.error.errors
      .map((err) => ` - ${err.path.join('.')}: ${err.message}`)
      .join('\n');
    throw new Error(
      `[Security / Configuration Error] Invalid or missing mandatory environment variable(s):\n${errorDetails}\nPlease check backend/.env.`
    );
  }

  return result.data;
}

export interface AppConfig {
  port: number;
  nodeEnv: string;
  enableSwagger: boolean;
  jwtSecret: string;
  jwtExpiresIn: string;
  corsOrigin: string;
  logLevel: string;
  bcryptSaltRounds: number;
  wallet: {
    defaultCurrency: SupportedCurrency;
    initialBalance: number;
  };
  demoUser: {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    phone: string;
  };
  mongo: {
    uri: string;
    testUri: string;
    fallbackUri?: string;
    testFallbackUri?: string;
  };
}

/**
 * Strongly-typed application configuration accessor.
 * Uses dynamic getters so changes to process.env in tests or runtime are reflected accurately.
 */
export const config: AppConfig = {
  get port() {
    return parseInt(process.env.PORT || '5000', 10);
  },
  get nodeEnv() {
    return process.env.NODE_ENV || 'development';
  },
  get enableSwagger(): boolean {
    if (process.env.ENABLE_SWAGGER !== undefined) {
      return process.env.ENABLE_SWAGGER.toLowerCase() === 'true';
    }
    return this.nodeEnv !== 'production';
  },
  get jwtSecret() {
    return (process.env.JWT_SECRET || '') as string;
  },
  get jwtExpiresIn() {
    return process.env.JWT_EXPIRES_IN || '7d';
  },
  get corsOrigin() {
    return process.env.CORS_ORIGIN || '*';
  },
  get logLevel() {
    return process.env.LOG_LEVEL || 'info';
  },
  get bcryptSaltRounds() {
    const val = parseInt(process.env.BCRYPT_SALT_ROUNDS || '10', 10);
    return isNaN(val) ? 10 : val;
  },
  wallet: {
    get defaultCurrency(): SupportedCurrency {
      const parsed = currencySchema.safeParse(process.env.DEFAULT_CURRENCY || 'NGN');
      return parsed.success ? parsed.data : 'NGN';
    },
    get initialBalance(): number {
      const val = parseFloat(process.env.DEFAULT_INITIAL_WALLET_BALANCE || '3000000.28');
      return isNaN(val) ? 3000000.28 : val;
    },
  },
  demoUser: {
    get email(): string {
      return (process.env.DEMO_USER_EMAIL || 'bunmi@securebypay.com').toLowerCase();
    },
    get password(): string {
      return process.env.DEMO_USER_PASSWORD || 'Password123!';
    },
    get firstName(): string {
      return process.env.DEMO_USER_FIRST_NAME || 'Bunmi';
    },
    get lastName(): string {
      return process.env.DEMO_USER_LAST_NAME || 'Tanny';
    },
    get phone(): string {
      return process.env.DEMO_USER_PHONE || '+2348012345678';
    },
  },
  mongo: {
    get uri() {
      return (process.env.MONGO_URI || '') as string;
    },
    get testUri() {
      return (process.env.MONGO_TEST_URI || '') as string;
    },
    get fallbackUri() {
      return process.env.MONGO_FALLBACK_URI;
    },
    get testFallbackUri() {
      return process.env.MONGO_TEST_FALLBACK_URI;
    },
  },
};
