# Deployment Guide

This guide covers deployment procedures for staging and production environments using Coolify and Docker.

## 🌍 Environments

### Staging
- **URL**: [Your staging URL]
- **Branch**: `dev` (auto-deploys)
- **Purpose**: Testing and validation
- **Database**: Staging database (isolated)

### Production
- **URL**: [Your production URL]
- **Branch**: `main` (manual deployment)
- **Purpose**: Live application
- **Database**: Production database

## 🐳 Docker Deployment

### Prerequisites
- Docker and Docker Compose installed
- Access to the deployment server
- Environment variables configured

### Build Process
```bash
# Build production image
docker build -t project-name:latest .

# Tag for registry
docker tag project-name:latest registry.example.com/project-name:latest

# Push to registry
docker push registry.example.com/project-name:latest
```

## 🚀 Coolify Deployment

### Initial Setup
1. **Create new project in Coolify**
   - Connect your Git repository
   - Select the appropriate branch (`dev` for staging, `main` for production)

2. **Configure build settings**
   ```dockerfile
   # Coolify will use your Dockerfile automatically
   # Ensure your Dockerfile is optimized for production
   ```

3. **Set environment variables**
   - Copy from `.env.example`
   - Configure production-specific values
   - Ensure all secrets are properly set

4. **Configure domains**
   - Set up custom domain
   - Configure SSL certificates
   - Set up redirects if needed

### Auto-Deployment Setup
```yaml
# In your repository, Coolify will automatically:
# 1. Detect changes to the connected branch
# 2. Build new Docker image
# 3. Deploy with zero downtime
# 4. Run health checks
# 5. Rollback if deployment fails
```

### Manual Deployment
```bash
# Through Coolify dashboard:
# 1. Go to your project
# 2. Click "Deploy" button
# 3. Monitor deployment logs
# 4. Verify deployment success
```

## 📋 Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing
- [ ] Code review completed
- [ ] No linting errors
- [ ] Documentation updated
- [ ] CHANGELOG.md updated

### Environment Setup
- [ ] Environment variables configured
- [ ] Database migrations ready
- [ ] External API keys validated
- [ ] SSL certificates configured

### Testing
- [ ] Local testing completed
- [ ] Staging environment tested
- [ ] Performance testing done
- [ ] Security scan completed

## 🔄 Deployment Process

### Staging Deployment (Automatic)
1. **Push to dev branch**
   ```bash
   git checkout dev
   git pull origin dev
   git merge feature/your-feature
   git push origin dev
   ```

2. **Monitor deployment**
   - Check GitHub Actions for CI/CD status
   - Monitor Coolify deployment logs
   - Verify staging site functionality

3. **Test on staging**
   - Functional testing
   - Performance testing
   - User acceptance testing

### Production Deployment (Manual)
1. **Prepare for production**
   ```bash
   git checkout main
   git pull origin main
   git merge dev
   ```

2. **Final checks**
   - Run full test suite
   - Verify all environment variables
   - Check database migration status
   - Backup current production data

3. **Deploy to production**
   ```bash
   git push origin main
   ```

4. **Post-deployment verification**
   - Health check endpoints
   - Critical functionality testing
   - Monitor error logs
   - Performance metrics

## 🔧 Environment Variables

### Required for All Environments
```bash
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
```

### Production-Specific
```bash
# Security
SECURE_COOKIES=true
TRUST_PROXY=true

# Monitoring
SENTRY_DSN=your-sentry-dsn
LOG_LEVEL=info

# Performance
REDIS_URL=redis://...
CDN_URL=https://cdn.example.com
```

### Staging-Specific
```bash
# Debugging
DEBUG=app:*
LOG_LEVEL=debug

# Testing
ENABLE_TEST_ROUTES=true
MOCK_EXTERNAL_APIS=true
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints
```bash
# Application health
GET /health

# Database connectivity
GET /health/db

# External services
GET /health/external
```

### Monitoring Setup
```bash
# Application metrics
- Response times
- Error rates
- Memory usage
- CPU usage

# Business metrics
- User registrations
- API usage
- Feature adoption
```

## 🔄 Rollback Procedures

### Automatic Rollback
Coolify can automatically rollback if:
- Health checks fail
- Deployment timeout occurs
- Critical errors detected

### Manual Rollback
```bash
# Through Coolify dashboard:
# 1. Go to deployment history
# 2. Select previous successful deployment
# 3. Click "Rollback" button
# 4. Monitor rollback process
```

### Emergency Rollback
```bash
# Direct database rollback (if needed)
# 1. Stop application
# 2. Restore database backup
# 3. Deploy previous version
# 4. Verify functionality
```

## 🔒 Security Considerations

### SSL/TLS
- Use HTTPS in production
- Configure proper SSL certificates
- Enable HSTS headers
- Secure cookie settings

### Environment Security
- Never commit secrets to git
- Use environment variables for sensitive data
- Regularly rotate API keys
- Implement proper access controls

### Docker Security
- Use non-root user in containers
- Scan images for vulnerabilities
- Keep base images updated
- Limit container permissions

## 📈 Performance Optimization

### Docker Optimization
```dockerfile
# Multi-stage builds
# Minimize image size
# Use appropriate base images
# Cache dependencies effectively
```

### Application Optimization
- Enable compression
- Implement caching
- Optimize database queries
- Use CDN for static assets

## 🐛 Troubleshooting

### Common Issues

#### Deployment Fails
```bash
# Check logs
docker logs container-name

# Check resource usage
docker stats

# Verify environment variables
docker exec container-name env
```

#### Application Not Starting
```bash
# Check port binding
netstat -tulpn | grep :3000

# Check file permissions
ls -la /app

# Check dependencies
npm list
```

#### Database Connection Issues
```bash
# Test database connectivity
docker exec container-name pg_isready -h db-host

# Check database logs
docker logs postgres-container
```

### Log Analysis
```bash
# Application logs
docker logs -f container-name

# System logs
journalctl -u docker

# Coolify logs
# Available in Coolify dashboard
```

## 📞 Support & Escalation

### Emergency Contacts
- **Primary**: [Your contact]
- **Secondary**: [Backup contact]
- **On-call**: [Emergency contact]

### Escalation Process
1. Check application logs
2. Review monitoring dashboards
3. Attempt standard troubleshooting
4. Contact team lead if issue persists
5. Escalate to infrastructure team if needed

### Documentation
- Keep deployment logs
- Document any issues and resolutions
- Update runbooks based on learnings
- Share knowledge with team 