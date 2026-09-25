import supertest from 'supertest';
import { createApp } from '../../src/app';

/**
 * Singleton Express application instance for test suites.
 */
export const testApp = createApp();

/**
 * Pre-configured Supertest agent bound to the test app.
 * Usage:
 *   await request.get('/endpoint')
 *   await request.post('/endpoint').send(payload)
 */
export const request = supertest(testApp);
