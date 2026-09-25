# SecureByPay - Node.js TypeScript Backend

The backend REST API service for SecureByPay built with Node.js, Express, TypeScript, Mongoose, Zod validation, and express-rate-limit.

---

## Key Features

- **TypeScript Architecture**: Strict type checking with clean layered separation (Routes, Controllers, Services, Models).
- **Security Hardening**:
  - `authLimiter`: 20 requests per 15 minutes on login & registration endpoints to prevent brute-force attacks.
  - `financialLimiter`: 30 requests per minute on wallet funding and shipment payments.
  - `apiLimiter`: 500 requests per 15 minutes on general API routes.
  - **IDOR Protection**: Explicit tenant verification in `payShipment` prevents cross-tenant shipment manipulation.
  - **Compound Database Indexing**: `{ userId: 1, createdAt: -1 }` on `ShipmentSchema` for optimal multi-tenant query speeds.
- **Authentication**: JWT token-based auth with bcrypt password hashing (10 salt rounds).
- **Validation**: Strict Zod schema validation on all incoming request bodies, params, and query strings.
- **Unified Deployment Ready**: Includes static file serving and SPA fallback for Flutter Web builds (`frontend/build/web`).
- **Interactive Documentation**: Swagger OpenAPI UI served live at `/api-docs`.
- **Database Resilience**: MongoDB connection handling with transactional runners (and automatic fallback for standalone Mongo instances) plus seed engine on boot.
- **Structured Logging**: Low-overhead logging via Pino and Pino-HTTP.

---

## Environment Setup

Create `.env` from `.env.example`:

```powershell
Copy-Item .env.example .env
```

Ensure `MONGO_URI` and `JWT_SECRET` are configured:
```properties
PORT=5000
NODE_ENV=development
JWT_SECRET=your_mandatory_jwt_secret_key_here
CORS_ORIGIN=*
LOG_LEVEL=info
MONGO_URI=mongodb://127.0.0.1:27017/securebypay?directConnection=true
```

---

## Scripts & Testing

```powershell
# Install dependencies
npm install

# Run unit, integration, and security tests (Vitest + Supertest)
npm test

# Run tests in watch mode
npm run test:watch

# Start development server with auto-reload (runs on http://localhost:5000)
npm run dev

# Compile TypeScript production bundle
npm run build

# Start production server
npm start
```

---

## Available Endpoints

- `GET /health`: Health and database connection status
- `GET /api-docs`: Swagger OpenAPI UI
- `POST /api/auth/register`: User registration *(Rate-limited: 20 req / 15 min)*
- `POST /api/auth/login`: User login returning JWT *(Rate-limited: 20 req / 15 min)*
- `GET /api/auth/me`: Authenticated profile info *(Bearer token required)*
- `GET /api/dashboard/overview`: Wallet balance and high-level metrics *(Bearer token required)*
- `GET /api/dashboard/growth?period=Year|Month|Week`: Growth chart series data *(Bearer token required)*
- `GET /api/dashboard/shipments`: User shipments *(Bearer token required)*
- `POST /api/dashboard/wallet/fund`: Add funds to user wallet *(Rate-limited: 30 req / min, Bearer token required)*
- `POST /api/dashboard/shipments/:id/pay`: Pay shipment from balance *(Tenant-isolated, Rate-limited: 30 req / min, Bearer token required)*
