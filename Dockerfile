# Multi-stage build for Node.js application
# Stage 1: Build stage
FROM node:18-alpine AS builder

# Add metadata
LABEL maintainer="your-email@example.com"
LABEL description="Project Template Application"

# Install system dependencies needed for building
RUN apk add --no-cache \
    build-base \
    gcc \
    g++ \
    make \
    python3

# Set working directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy package files first for better caching
COPY package*.json ./
COPY yarn.lock ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY --chown=nextjs:nodejs . .

# Build the application (if needed)
# RUN npm run build

# Stage 2: Production stage
FROM node:18-alpine AS runner

# Install security updates
RUN apk update && apk upgrade

# Set NODE_ENV
ENV NODE_ENV=production
ENV PORT=3000

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy package files
COPY --from=builder --chown=nextjs:nodejs /app/package*.json ./

# Copy built application from builder stage
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/src ./src
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# If you have a build step, copy the built files instead:
# COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
# COPY --from=builder --chown=nextjs:nodejs /app/build ./build

# Ensure production dependencies only
RUN npm prune --production

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Start the application
CMD ["node", "src/index.js"]

# Alternative for different frameworks:
# CMD ["npm", "start"]
# CMD ["node", "dist/app.js"]
# CMD ["yarn", "start"] 