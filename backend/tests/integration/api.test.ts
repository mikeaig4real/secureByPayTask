import crypto from 'crypto';
import { describe, it, expect } from 'vitest';
import jwt from 'jsonwebtoken';
import { request } from '../helpers/testApp';
import { config } from '../../src/config';

describe('API Integration Tests', () => {
  const mockAuthToken = jwt.sign(
    {
      userId: '65f1a2b3c4d5e6f7a8b9c0d1',
      email: 'test@securebypay.com',
      firstName: 'Test',
      lastName: 'User',
    },
    config.jwtSecret || crypto.randomBytes(32).toString('hex')
  );

  it('GET /health - should return status and database info', async () => {
    const res = await request.get('/health');
    expect([200, 503]).toContain(res.status);
    expect(res.body.service).toBe('securebypay-backend');
    expect(res.body.database).toBeDefined();
    expect(typeof res.body.database.connected).toBe('boolean');
  });

  it('GET / - should redirect to /api-docs', async () => {
    const res = await request.get('/');
    expect(res.status).toBe(302);
    expect(res.header.location).toBe('/api-docs');
  });

  it('GET /api/dashboard/growth - should return 401 when token is missing', async () => {
    const res = await request.get('/api/dashboard/growth?period=Year');
    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
  });

  it('GET /api/dashboard/growth - should return chart points for Year with auth token', async () => {
    const res = await request
      .get('/api/dashboard/growth?period=Year')
      .set('Authorization', `Bearer ${mockAuthToken}`);
    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.labels).toHaveLength(12);
    expect(res.body.data.values).toHaveLength(12);
  });

  it('POST /api/auth/register - should return 400 on invalid payload', async () => {
    const res = await request.post('/api/auth/register').send({
      email: 'not-an-email',
      password: '123',
    });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.error).toContain('Validation Failed');
  });

  it('POST /api/auth/login - should return 400 when missing fields', async () => {
    const res = await request.post('/api/auth/login').send({});
    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.error).toContain('Validation Failed');
  });

  it('GET /api/auth/me - should return 401 when token is missing', async () => {
    const res = await request.get('/api/auth/me');
    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.error).toBe('Access token required');
  });

  it('GET /unknown-route - should return 404 for unknown endpoints', async () => {
    const res = await request.get('/unknown-endpoint');
    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
    expect(res.body.error).toContain('Route not found');
  });
});
