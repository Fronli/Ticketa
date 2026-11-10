# syntax=docker/dockerfile:1

# Build stage
FROM node:18-bookworm AS builder
WORKDIR /app

COPY backend/package.json backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN --mount=type=cache,target=/root/.npm npm ci

WORKDIR /app
COPY . .

WORKDIR /app/backend
RUN npm run build
RUN npx prisma generate

# Production stage
FROM node:18-bookworm-slim AS runtime

# Prisma 6 membutuhkan library OpenSSL saat dijalankan
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/backend/src/public ./backend/public
COPY --from=builder /app/backend/dist ./backend/dist
COPY --from=builder /app/backend/package.json ./backend/package.json
COPY --from=builder /app/backend/package-lock.json ./backend/package-lock.json
COPY --from=builder /app/backend/prisma ./backend/prisma
COPY --from=builder /app/frontend ./frontend

WORKDIR /app/backend
RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev

ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "dist/server.js"]