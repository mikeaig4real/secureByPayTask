# SecureByPay Technical Assessment

A full stack technical assessment application built with a responsive **Flutter Web** frontend and a **Node.js, TypeScript & Express** backend, backed by **MongoDB**. Designed for single-command fullstack deployment, enterprise security, and clean architecture (SOLID, DRY, YAGNI).

---

## Live Deployment

- **Live Application URL**: `TBD` *(Update with live Render/Railway URL once deployed)*
- **API Documentation**: `https://<your-app-domain>/api-docs`
- **Health & Status**: `https://<your-app-domain>/health`

---

## Architecture Overview

- **Frontend (Flutter Web)**:
  - Responsive multi-device layout (Desktop `>1024px`, Tablet `768px–1024px`, Mobile `<768px`) built to match Figma design specifications.
  - State management powered by **Provider** with reactive stores (`AuthStore`, `DashboardStore`).
  - Strict separation of concerns with reusable **Pure Components** (`StatusBadge`, `NigeriaFlagIcon`, `SectionHeader`, `PlaceholderView`, `EmptyStateWidget`, `SidebarNavItem`, `AuthLegalFooter`).
  - Strict compile-time configuration using `--dart-define-from-file=.env` with type-safe fallbacks.
  - Interactive spline chart using `fl_chart`, Lucide icons, and Plus Jakarta Sans typography.
- **Backend (Node.js & TypeScript)**:
  - RESTful architecture with layered Separation of Concerns (Routes -> Controllers -> Services -> Models).
  - Multi-tier **Rate Limiting** via `express-rate-limit` protecting against brute-force attacks, credential stuffing, and financial mutation spam.
  - Tenant isolation & IDOR prevention on sensitive financial transactions (e.g. shipment payment verification).
  - Robust input validation powered by **Zod** schemas.
  - Authentication with **JWT** Bearer tokens and **bcryptjs** password hashing (10 salt rounds).
  - High-performance structured logging with **Pino** and **Pino-HTTP**.
  - Database management via **Mongoose** with compound indexing (`userId + createdAt`), transactional safety, and automatic demo seeding on startup.
- **Unified Single-Place Deployment**:
  - The Express backend statically serves the compiled Flutter Web production bundle (`frontend/build/web`) with SPA routing fallback.
  - Single domain, single port, zero CORS hurdles in production.
- **API Documentation**:
  - Interactive Swagger OpenAPI UI served directly at `http://localhost:5000/api-docs`.

---

## Prerequisites

Ensure the following runtimes and tools are installed:
- **Node.js**: `v18.x` or `v20.x+` (with `npm`)
- **Flutter SDK**: `^3.4.0` (with Chrome / Web support enabled)
- **MongoDB**: Local MongoDB instance (`mongodb://127.0.0.1:27017`) or a free [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) connection URI.

---

## Quick Start (Monorepo Root)

You can run commands directly from the root directory:

```powershell
# 1. Install all dependencies (Backend + Frontend)
npm run install:all

# 2. Run both Backend & Frontend concurrently in development mode
npm run dev

# 3. Or run either service individually in development mode
npm run dev:backend
npm run dev:frontend

# 4. Run all tests across Frontend and Backend (68 total passing tests)
npm test

# 5. Build both Frontend and Backend for unified production deployment
npm run build

# 6. Start the unified production server (serves API, Swagger, and Flutter Web in one place)
npm start
```

---

## Service-Specific Workflows

### 1. Backend Service (`/backend`)

```powershell
cd backend

# Configure environment variables
Copy-Item .env.example .env

# Run unit and integration tests (56 passing tests)
npm test

# Start the development server (runs on http://localhost:5000 with ts-node-dev)
npm run dev

# Build TypeScript production bundle
npm run build
```

The server automatically seeds the initial demo user, wallet, and shipments into MongoDB on startup if they do not exist.

---

### 2. Frontend Service (`/frontend`)

```powershell
cd frontend

# Install Flutter dependencies
flutter pub get

# Configure environment variables (optional, defaults to http://localhost:5000/api)
Copy-Item .env.example .env

# Run unit and widget tests (12 passing tests)
flutter test

# Run code analyzer (0 issues)
flutter analyze

# Launch headless local web server on port 3000 (access from any browser tab)
flutter run -d web-server --web-port=3000 --web-hostname=localhost --dart-define-from-file=.env

# Build production static web bundle
flutter build web --release --dart-define=API_URL=/api
```

---

## Security Standards & Protections

| Security Measure | Implementation | Protection |
| :--- | :--- | :--- |
| **Brute-Force Protection** | `authLimiter` (20 req / 15 min) | Prevents password-guessing and credential stuffing on `/api/auth/*` |
| **Financial Mutation Guard** | `financialLimiter` (30 req / min) | Prevents rapid-fire wallet funding or payment race conditions |
| **General API Throttling** | `apiLimiter` (500 req / 15 min) | Shields backend services against denial-of-service attempts |
| **IDOR & Tenant Isolation** | `payShipment` userId check | Prevents users from manipulating or paying for other tenants' shipments |
| **Password Hashing** | `bcryptjs` with 10 salt rounds | One-way salted hashing before persistence to MongoDB |
| **Input Sanitization** | `Zod` schema validation | Blocks malformed inputs, prototype poisoning, and unexpected fields |
| **Schema & Surface Concealment** | `ENABLE_SWAGGER` environment toggle | Disables Swagger UI and activates strict Content Security Policy (CSP) in production |
| **Database Performance** | `{ userId: 1, createdAt: -1 }` index | Prevents full collection scans during high-frequency dashboard queries |

---

## API Endpoints

Interactive Swagger UI documentation is available at `http://localhost:5000/api-docs`.

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :---: |
| `GET` | `/health` | Server health and MongoDB connection status | No |
| `GET` | `/api-docs` | Interactive Swagger OpenAPI documentation | No |
| `POST` | `/api/auth/register` | Register new account (`firstName`, `lastName`, `email`, `phone`, `password`) | No |
| `POST` | `/api/auth/login` | Authenticate user with credentials | No |
| `GET` | `/api/auth/me` | Fetch authenticated user profile | **Yes (Bearer JWT)** |
| `GET` | `/api/dashboard/overview` | Fetch wallet balance and overview metric cards | **Yes (Bearer JWT)** |
| `GET` | `/api/dashboard/growth` | Fetch spline growth chart data (`?period=Year\|Month\|Week`) | **Yes (Bearer JWT)** |
| `GET` | `/api/dashboard/shipments` | Fetch authenticated user's shipment list | **Yes (Bearer JWT)** |
| `POST` | `/api/dashboard/wallet/fund` | Add funds to user wallet (`amount`, optional `currency`) | **Yes (Bearer JWT)** |
| `POST` | `/api/dashboard/shipments/:id/pay` | Pay for shipment from user's wallet balance | **Yes (Bearer JWT)** |

---

## Demo Persona & Seed Data

The backend seeds an initial demo user matching the Figma persona on startup:

| Field | Value |
| :--- | :--- |
| **Email** | `bunmi@securebypay.com` |
| **Password** | `Password123!` |
| **Full Name** | Bunmi Tanny |
| **Phone** | `+2348012345678` |
| **Initial Wallet Balance** | ₦3,000,000.28 NGN |
| **Initial Shipments** | 3 seeded Figma shipments (`MAF-100-234-291`, `MAF-100-234-292`, `MAF-100-234-293`) |

---

## Test Suites (68 Total Passing Tests)

- **Backend Test Suite (56 Passing)**:
  - Unit tests covering Zod environment validation, custom operational errors, date/currency formatters, auth services, database seeding, and rate limiting / IDOR security rules.
  - End-to-end integration tests using **Vitest** and **Supertest** covering registration, login, protected routes, and 404/health handlers.
- **Frontend Test Suite (12 Passing)**:
  - Model serialization unit tests (`UserModel`, `WalletModel`, `OverviewStatsModel`, `ShipmentModel`, `GrowthChartModel`).
  - Pure component widget tests (`StatusBadge`, `SectionHeader`, `EmptyStateWidget`, `NigeriaFlagIcon`).
  - App initialization and auth gating smoke widget tests.

---

## Project Structure

```
secureByPayTask/
├── backend/
│   ├── src/
│   │   ├── config/          # Zod-validated environment configuration & defaults
│   │   ├── constants/       # Currency definitions and constants
│   │   ├── controllers/     # Request controllers (AuthController, DashboardController)
│   │   ├── db/              # MongoDB connection, transactional runner & seed engine
│   │   ├── docs/            # Swagger OpenAPI 3.0 specification
│   │   ├── errors/          # Custom operational error classes (AuthError, BadRequestError, etc.)
│   │   ├── middleware/      # Auth guard (JWT), rate limiters, schema validation, error handlers
│   │   ├── mock-data/       # Figma template metrics and seed shipment definitions
│   │   ├── models/          # Mongoose models with compound indexes (User, Wallet, Shipment)
│   │   ├── responses/       # Standardized API response formatters
│   │   ├── routes/          # Express route definitions (/api/auth, /api/dashboard)
│   │   ├── schemas/         # Zod schemas for request validation
│   │   ├── services/        # Business logic (AuthService, DashboardService)
│   │   └── utils/           # Structured Pino logger, currency formatter, date helpers
│   ├── tests/
│   │   ├── integration/     # API integration test suite (Vitest + Supertest)
│   │   └── unit/            # Business logic, utility, and security unit tests
│   ├── .env.example         # Backend environment variables template
│   └── tsconfig.json        # TypeScript configuration
├── frontend/
│   ├── lib/
│   │   ├── components/      # UI components
│   │   │   ├── containers/  # Connected containers (metrics, charts, shipments)
│   │   │   └── pure/        # Pure reusable widgets (StatusBadge, SectionHeader, etc.)
│   │   ├── core/            # Config, theme, logger, errors, responsive breakpoints
│   │   ├── models/          # Data models (User, Wallet, Shipment, Growth)
│   │   ├── services/        # HTTP ApiClient, AuthService, DashboardService
│   │   ├── stores/          # Provider reactive state stores (AuthStore, DashboardStore)
│   │   ├── views/           # Screens (SignInView, SignUpView, DashboardView)
│   │   └── main.dart        # Application entrypoint & AuthGate routing
│   ├── assets/images/       # Extracted graphics and SVG icons
│   ├── test/                # Unit and widget test suite (12 tests)
│   ├── .env.example         # Frontend environment variables template
│   └── pubspec.yaml         # Flutter dependencies and assets configuration
├── design/                  # Figma screen references and extracted design tokens
└── package.json             # Root monorepo orchestration scripts (build, test, start)
```
