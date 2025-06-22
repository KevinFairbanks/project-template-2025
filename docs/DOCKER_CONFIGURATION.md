# Docker Configuration Guide

## Overview

This guide covers both Docker configuration files and documentation for optimal development and production environments.

## 📁 Docker File Structure

```
project-root/
├── Dockerfile                 # Multi-stage production build
├── docker-compose.yml         # Local development environment
├── docker-compose.prod.yml    # Production environment (optional)
├── .dockerignore              # Files to exclude from build context
├── docker/
│   ├── nginx.conf             # Nginx configuration (if using)
│   ├── entrypoint.sh          # Custom startup script
│   └── healthcheck.sh         # Health check script
└── scripts/
    ├── docker-build.sh        # Build automation script
    └── docker-deploy.sh       # Deployment automation script
```

## 🐳 Optimized Dockerfile Configuration

### Current Dockerfile Analysis
Our current Dockerfile uses multi-stage builds, which is excellent for:
- ✅ Smaller production images
- ✅ Security (no dev dependencies in production)
- ✅ Build caching optimization

### Enhanced Dockerfile (Optional Upgrade)
```dockerfile
# syntax=docker/dockerfile:1
FROM node:22-alpine AS base
WORKDIR /app

# Install dependencies in separate layer for better caching
FROM base AS deps
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Build stage with dev dependencies
FROM base AS build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --production

# Production stage
FROM node:22-alpine AS production
WORKDIR /app

# Create non-root user for security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs

# Copy built application
COPY --from=deps --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nodejs:nodejs /app/dist ./dist
COPY --from=build --chown=nodejs:nodejs /app/package*.json ./

# Add health check
COPY docker/healthcheck.sh ./
RUN chmod +x healthcheck.sh
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ./healthcheck.sh

# Switch to non-root user
USER nodejs

EXPOSE 3000
CMD ["npm", "start"]
```

## 🔧 Enhanced Docker Compose Configuration

### Local Development (docker-compose.yml)
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: base  # Use base stage for development
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules  # Prevent overwriting node_modules
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:password@db:5432/myapp_dev
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    command: npm run dev

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp_dev
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Optional: Nginx for local SSL/reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/ssl:/etc/ssl/certs
    depends_on:
      - app

volumes:
  postgres_data:
  redis_data:
```

### Production Compose (docker-compose.prod.yml)
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: production
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
    depends_on:
      - db
      - redis
    networks:
      - app-network

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    volumes:
      - redis_data:/data
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
```

## 📜 Supporting Configuration Files

### Health Check Script (docker/healthcheck.sh)
```bash
#!/bin/sh
# Health check for Docker container

# Check if the application is responding
curl -f http://localhost:3000/health || exit 1

# Optional: Check database connection
# node -e "require('./src/utils/db-check.js')" || exit 1

echo "Health check passed"
exit 0
```

### Nginx Configuration (docker/nginx.conf)
```nginx
events {
    worker_connections 1024;
}

http {
    upstream app {
        server app:3000;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /health {
            proxy_pass http://app/health;
            access_log off;
        }
    }
}
```

### Enhanced .dockerignore
```dockerignore
# Current .dockerignore is good, but here are additional optimizations:

# Development files
.git
.gitignore
README.md
CHANGELOG.md
TASKS.md
docs/

# IDE and editor files
.vscode/
.cursor/
*.swp
*.swo

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs and runtime data
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pids/
*.pid
*.seed
*.pid.lock

# Coverage and test reports
coverage/
.nyc_output/
test-results/

# Build artifacts (if not needed in container)
dist/
build/

# Environment files (use secrets instead)
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
```

## 🚀 Automation Scripts

### Build Script (scripts/docker-build.sh)
```bash
#!/bin/bash
# Docker build automation script

set -e

# Configuration
IMAGE_NAME="myapp"
REGISTRY="ghcr.io/your-username"
VERSION=${1:-latest}

echo "🐳 Building Docker image..."

# Build multi-platform image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag "${REGISTRY}/${IMAGE_NAME}:${VERSION}" \
  --tag "${REGISTRY}/${IMAGE_NAME}:latest" \
  --push \
  .

echo "✅ Build completed: ${REGISTRY}/${IMAGE_NAME}:${VERSION}"
```

### Development Script (scripts/dev-setup.sh)
```bash
#!/bin/bash
# Development environment setup

set -e

echo "🚀 Setting up development environment..."

# Create necessary directories
mkdir -p docker/ssl logs

# Generate self-signed SSL certificates for local development
if [ ! -f docker/ssl/cert.pem ]; then
  openssl req -x509 -newkey rsa:4096 -keyout docker/ssl/key.pem \
    -out docker/ssl/cert.pem -days 365 -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
fi

# Start development environment
docker-compose up -d

echo "✅ Development environment ready!"
echo "🌐 Application: http://localhost:3000"
echo "🗄️  Database: localhost:5432"
echo "🔴 Redis: localhost:6379"
```

## 📊 Docker Best Practices Implemented

### Security
- ✅ Non-root user in production
- ✅ Multi-stage builds (no dev dependencies in production)
- ✅ Health checks for container monitoring
- ✅ Minimal base images (Alpine Linux)
- ✅ No secrets in Dockerfile

### Performance
- ✅ Layer caching optimization
- ✅ .dockerignore to reduce build context
- ✅ Multi-platform builds (AMD64 + ARM64)
- ✅ Dependency caching in separate layers
- ✅ Production asset optimization

### Maintainability
- ✅ Clear stage naming in multi-stage builds
- ✅ Consistent file organization
- ✅ Environment-specific configurations
- ✅ Automation scripts for common tasks
- ✅ Comprehensive documentation

## 🔄 Integration with Coolify

### Coolify-Specific Optimizations
```yaml
# In your Coolify application settings:
Build Command: docker build --target production -t $IMAGE_NAME .
Health Check Path: /health
Port: 3000
Environment Variables: Set in Coolify dashboard

# Coolify will automatically:
- Pull from your repository
- Build using your Dockerfile
- Deploy to your server
- Monitor health checks
- Handle rolling updates
```

### GitHub Actions + Coolify Integration
```yaml
# The workflow builds images and triggers Coolify:
1. GitHub builds optimized images
2. Images pushed to GitHub Container Registry
3. GitHub triggers Coolify webhook
4. Coolify pulls pre-built image (faster deployment)
5. Coolify deploys using health checks
```

## 🎯 Recommendations for Your Setup

### Immediate Improvements (Low Effort, High Value)
1. ✅ Add health check script
2. ✅ Enhance .dockerignore
3. ✅ Add development automation script
4. ❌ Keep current Dockerfile (it's already well-optimized)

### Future Enhancements (When Scaling)
1. 🔄 Add Nginx reverse proxy for SSL termination
2. 🔄 Implement database migrations in container startup
3. 🔄 Add monitoring and logging aggregation
4. 🔄 Set up container orchestration (if moving beyond single server)

### For Multiple Projects
1. ✅ Create reusable Dockerfile template
2. ✅ Standardize health check endpoints
3. ✅ Use consistent port conventions
4. ✅ Document environment variable patterns

This configuration provides a solid foundation that works with your current Coolify setup while being ready for future scaling needs!
