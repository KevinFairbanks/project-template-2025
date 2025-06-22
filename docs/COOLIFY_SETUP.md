# Coolify Setup & Integration Guide

## 🚀 Overview

This guide covers setting up Coolify for deployment and integrating it with our GitHub Actions workflow for the best of both worlds.

## 🔧 Initial Coolify Setup

### 1. Application Configuration

**Basic Settings:**
```yaml
Name: your-project-name
Repository: https://github.com/your-username/your-repo
Branch: main (for production) / dev (for staging)
Build Command: docker build --target production -t $IMAGE_NAME .
Start Command: npm start
Port: 3000
```

**Environment Variables:**
```env
NODE_ENV=production
DATABASE_URL=postgresql://user:pass@host:5432/dbname
REDIS_URL=redis://redis:6379
JWT_SECRET=your-jwt-secret-here
```

### 2. Health Check Configuration

**Health Check Path:** `/health`

**Health Check Endpoint (add to your app):**
```javascript
// src/routes/health.js
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
    environment: process.env.NODE_ENV,
    uptime: process.uptime()
  });
});
```

### 3. Database Setup

**PostgreSQL Configuration:**
```yaml
Service: PostgreSQL 16
Database Name: your_app_db
Username: your_app_user
Password: [Generate strong password]
Port: 5432
```

**Redis Configuration:**
```yaml
Service: Redis 7
Port: 6379
Password: [Optional but recommended]
```

## 🔄 GitHub Actions Integration

### Option 1: Hybrid Approach (Recommended)

**Benefits:**
- ✅ Quality gates prevent bad deployments
- ✅ Pre-built Docker images for faster deployment
- ✅ Coolify handles server management
- ✅ GitHub provides deployment history

**Setup Steps:**

#### 1. Get Coolify Webhook URLs
```bash
# In Coolify dashboard:
1. Go to your application
2. Navigate to "Webhooks" tab
3. Copy the deployment webhook URL
4. Format: https://your-coolify-instance.com/webhooks/deploy/[app-id]
```

#### 2. Add GitHub Secrets
```yaml
# Repository Settings → Secrets and variables → Actions
COOLIFY_STAGING_WEBHOOK: "https://coolify.example.com/webhooks/deploy/staging-app-id"
COOLIFY_PRODUCTION_WEBHOOK: "https://coolify.example.com/webhooks/deploy/production-app-id"
STAGING_URL: "https://staging.yourapp.com"
PRODUCTION_URL: "https://yourapp.com"
```

#### 3. Workflow Configuration
Our CI/CD workflow (`.github/workflows/ci.yml`) is already configured to:
- Build and test code
- Create Docker images
- Trigger Coolify deployments via webhooks
- Perform health checks

### Option 2: Pure Coolify (Current/Fallback)

**Keep this as backup if GitHub Actions fail:**
```yaml
# Coolify watches repository directly
Auto-deploy: Enabled
Branch: main (production) / dev (staging)
Build on push: Enabled
```

## 🐳 Docker Optimization for Coolify

### Multi-Stage Dockerfile (Already Implemented)
```dockerfile
# Our current Dockerfile is optimized for Coolify:
- Multi-stage builds for smaller production images
- Alpine Linux for security and size
- Non-root user for security
- Health check integration
```

### Coolify-Specific Optimizations
```yaml
# In Coolify application settings:
Build Command: docker build --target production -t $IMAGE_NAME .
Health Check Command: curl -f http://localhost:3000/health || exit 1
Health Check Interval: 30s
Health Check Timeout: 10s
Health Check Retries: 3
```

## 📊 Monitoring & Logging

### Application Logs
```javascript
// Enhanced logging for Coolify
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ]
});

module.exports = logger;
```

### Health Monitoring
```javascript
// Enhanced health check with dependencies
app.get('/health', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version,
    environment: process.env.NODE_ENV,
    uptime: process.uptime(),
    dependencies: {}
  };

  try {
    // Check database connection
    await db.raw('SELECT 1');
    health.dependencies.database = 'healthy';
  } catch (error) {
    health.dependencies.database = 'unhealthy';
    health.status = 'degraded';
  }

  try {
    // Check Redis connection
    await redis.ping();
    health.dependencies.redis = 'healthy';
  } catch (error) {
    health.dependencies.redis = 'unhealthy';
    health.status = 'degraded';
  }

  const statusCode = health.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(health);
});
```

## 🔒 Security Configuration

### Environment Variables Security
```yaml
# In Coolify, set these as secrets (encrypted):
JWT_SECRET: [Generate 256-bit key]
DATABASE_PASSWORD: [Strong password]
REDIS_PASSWORD: [Strong password]
API_KEYS: [Third-party API keys]

# Regular environment variables:
NODE_ENV: production
PORT: 3000
LOG_LEVEL: info
```

### SSL/TLS Configuration
```yaml
# Coolify automatically handles:
- SSL certificate generation (Let's Encrypt)
- HTTPS redirection
- Certificate renewal

# Custom domain setup:
1. Point your domain to Coolify server IP
2. Add domain in Coolify dashboard
3. Enable SSL (automatic)
```

## 🚀 Deployment Strategies

### Rolling Deployment (Default)
```yaml
# Coolify default behavior:
- Builds new container
- Starts new container
- Health checks new container
- Stops old container when healthy
- Zero-downtime deployment
```

### Blue-Green Deployment (Advanced)
```yaml
# For critical applications:
1. Deploy to staging environment first
2. Run comprehensive tests
3. Manual approval for production
4. Instant rollback capability
```

## 📈 Scaling Configuration

### Horizontal Scaling
```yaml
# In Coolify Pro (when available):
Instances: 2-5 (based on load)
Load Balancer: Enabled
Session Affinity: Disabled (use Redis for sessions)
```

### Resource Limits
```yaml
# Container resource limits:
Memory Limit: 512MB (adjust based on needs)
CPU Limit: 0.5 cores (adjust based on needs)
Disk Space: 1GB (for logs and temp files)
```

## 🔧 Troubleshooting

### Common Issues

#### Deployment Failures
```bash
# Check Coolify logs:
1. Go to application in Coolify dashboard
2. Check "Logs" tab for build/deployment errors
3. Common issues:
   - Docker build failures
   - Missing environment variables
   - Health check failures
   - Port conflicts
```

#### Health Check Failures
```bash
# Debug health check:
1. Check if /health endpoint is accessible
2. Verify health check logic
3. Check dependencies (database, Redis)
4. Review application logs
```

#### Performance Issues
```bash
# Monitor resource usage:
1. Check memory/CPU usage in Coolify
2. Review application logs for errors
3. Monitor database performance
4. Check Redis performance
```

### Rollback Procedures
```yaml
# Automatic rollback:
- Health checks fail → automatic rollback
- Manual rollback via Coolify dashboard
- GitHub Actions can trigger rollback

# Manual rollback steps:
1. Go to Coolify dashboard
2. Select application
3. Go to "Deployments" tab
4. Click "Rollback" on previous successful deployment
```

## 📋 Maintenance Tasks

### Regular Maintenance
```yaml
Weekly:
- Review application logs
- Check resource usage
- Verify backup integrity
- Update dependencies (if needed)

Monthly:
- Review security updates
- Optimize database performance
- Clean up old Docker images
- Review and update documentation
```

### Backup Strategy
```yaml
Database Backups:
- Automated daily backups via Coolify
- Retention: 30 days
- Test restore procedures monthly

Code Backups:
- GitHub repository (primary)
- Container images in GitHub registry
- Configuration in this repository
```

## 🎯 Best Practices

### Development Workflow
1. **Develop locally** with Docker Compose
2. **Push to dev branch** → auto-deploy to staging
3. **Test on staging** environment
4. **Create PR** to main branch
5. **Merge to main** → deploy to production (with approval)

### Monitoring
- **Set up alerts** for deployment failures
- **Monitor application metrics** (response time, error rate)
- **Track resource usage** trends
- **Review logs** regularly for issues

### Security
- **Rotate secrets** regularly
- **Keep dependencies** updated
- **Monitor security** advisories
- **Use least privilege** access

This setup provides a robust, scalable deployment strategy that grows with your project needs!
