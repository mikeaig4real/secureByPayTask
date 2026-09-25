# ==========================================
# STAGE 1: Build Flutter Web Frontend
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS frontend-builder

WORKDIR /app/frontend

# Copy frontend dependency manifests first for layer caching
COPY frontend/pubspec.yaml frontend/pubspec.lock ./
RUN flutter pub get

# Copy frontend application source
COPY frontend/ ./

# Build production Web SPA bundle with /api relative routing
RUN flutter build web --release --dart-define=API_URL=/api --dart-define=ENVIRONMENT=production --dart-define=LOG_LEVEL=error

# ==========================================
# STAGE 2: Build Node.js TypeScript Backend
# ==========================================
FROM node:20-alpine AS backend-builder

WORKDIR /app/backend

# Copy backend dependency manifests
COPY backend/package.json backend/package-lock.json ./
RUN npm ci

# Copy backend source code & TypeScript configuration
COPY backend/ ./

# Compile TypeScript to dist/
RUN npm run build

# ==========================================
# STAGE 3: Production Runtime
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5000

# Install dumb-init for graceful signal handling
RUN apk add --no-cache dumb-init

# Copy backend dependency manifests and install production dependencies only
COPY backend/package.json backend/package-lock.json ./backend/
RUN cd backend && npm ci --omit=dev && npm cache clean --force

# Copy compiled backend output
COPY --from=backend-builder /app/backend/dist ./backend/dist

# Copy compiled frontend web build (served by backend/src/app.ts at ../../frontend/build/web)
COPY --from=frontend-builder /app/frontend/build/web ./frontend/build/web

# Set non-root ownership
RUN chown -R node:node /app

USER node

EXPOSE 5000

# Container health check using backend /health endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:${PORT:-5000}/health || exit 1

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "backend/dist/server.js"]
