# GitHub Actions Setup Guide

## Overview

This guide covers the manual setup steps needed to enable our GitHub Actions workflows for build & package functionality.

## 🔧 Required Manual Setup Steps

### 1. Repository Secrets Configuration

Navigate to your repository → Settings → Secrets and variables → Actions

**Required Secrets:**
```yaml
# Coolify Deployment (if using GitHub-triggered deployment)
COOLIFY_WEBHOOK_URL: "https://your-coolify-instance.com/webhooks/deploy/your-app-id"
COOLIFY_API_TOKEN: "your-coolify-api-token"  # Optional for advanced features

# Container Registry (Automatic with GitHub)
GITHUB_TOKEN: # Automatically provided by GitHub Actions

# Optional: Notifications
SLACK_WEBHOOK_URL: "https://hooks.slack.com/services/..."  # If re-enabling Slack
```

**How to get Coolify webhook URL:**
1. Go to your Coolify dashboard
2. Select your application
3. Go to "Webhooks" tab
4. Copy the deployment webhook URL
5. Add to GitHub repository secrets

### 2. GitHub Container Registry Setup

**Automatic Configuration:**
- GitHub automatically provides `GITHUB_TOKEN`
- Container registry is enabled by default
- Images stored at: `ghcr.io/your-username/your-repo`

**Manual Verification:**
1. Go to repository → Packages tab
2. After first workflow run, verify images appear
3. Images are tagged with branch name and commit SHA

### 3. Environment Protection (Optional for Single Dev)

**For Production Safety:**
1. Go to repository → Settings → Environments
2. Create "production" environment
3. Add protection rules:
   - Required reviewers: Add yourself
   - Wait timer: 0 minutes (for solo dev)
   - Deployment branches: Only `main`

**Benefits for Solo Dev:**
- Manual approval step before production
- Prevents accidental deployments
- Can be skipped if not needed

### 4. Branch Protection Rules (Optional)

**Recommended for Quality:**
1. Go to repository → Settings → Branches
2. Add rule for `main` branch:
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Status checks: `quality-checks`, `build-and-package`
   - ❌ Require pull request reviews (not needed for solo)

### 5. Workflow Permissions

**Automatic Setup:**
- Workflows have read/write permissions by default
- Can push to container registry
- Can create releases and tags

**Manual Verification:**
1. Go to repository → Settings → Actions → General
2. Verify "Workflow permissions" is set to "Read and write permissions"

## 🤖 Automated Features Already Configured

### Container Registry Management
```yaml
# Automatically handled:
- Image building for AMD64 + ARM64
- Tagging with branch and commit SHA
- Pushing to GitHub Container Registry
- Build caching for faster subsequent builds
- Multi-stage Docker optimization
```

### Quality Gates
```yaml
# Runs automatically on every push/PR:
- ESLint code linting
- Prettier formatting checks
- Jest test execution with coverage
- npm audit for security vulnerabilities
- Dependency review (PRs only)
```

### Deployment Triggers
```yaml
# Staging (dev branch):
- Automatic deployment after quality passes
- Health check validation
- Rollback on failure

# Production (main branch):
- Manual approval required (if environment protection enabled)
- Extended health checks
- Automatic release creation with changelog
```

## 🔄 Workflow Integration Options

### Option 1: GitHub + Coolify Hybrid (Recommended)
```yaml
Flow:
1. Developer pushes to dev/main
2. GitHub runs quality checks + builds images
3. GitHub triggers Coolify webhook on success
4. Coolify deploys using pre-built image
5. Health checks validate deployment

Benefits:
- Quality gates prevent bad deployments
- Pre-built images for faster deployment
- Coolify handles server management
- Best of both worlds
```

### Option 2: Pure Coolify (Current Setup)
```yaml
Flow:
1. Developer pushes to branch
2. Coolify detects changes
3. Coolify builds and deploys directly

Benefits:
- Simpler setup
- Real-time deployment
- Zero GitHub configuration needed

Limitations:
- No quality gates
- No pre-built images
- No deployment history in GitHub
```

### Option 3: Pure GitHub Actions (Advanced)
```yaml
Flow:
1. Developer pushes to branch
2. GitHub runs full CI/CD pipeline
3. GitHub deploys directly to server
4. GitHub manages entire process

Benefits:
- Complete control over deployment
- Rich deployment history
- Advanced automation possibilities

Limitations:
- More complex server setup
- Requires server access configuration
- More maintenance overhead
```

## 📦 Container Registry Benefits

### For Development
- **Consistent environments** across local, staging, production
- **Faster deployments** using pre-built images
- **Version tracking** with tagged images
- **Rollback capability** to previous image versions

### For Scaling
- **Multi-server deployment** using same images
- **Load balancer compatibility** with identical containers
- **Development team** can use same images locally
- **CI/CD flexibility** with portable containers

## 🎯 Recommended Setup for Your Use Case

**As a single developer with Coolify:**

### Minimal Setup (Start Here)
1. ✅ Keep existing Coolify auto-deployment
2. ✅ Add GitHub quality checks (prevent bad code)
3. ✅ Enable container registry (future-proofing)
4. ❌ Skip environment protection (not needed solo)
5. ❌ Skip branch protection (not needed solo)

### Enhanced Setup (When Ready)
1. ✅ Add GitHub → Coolify webhook integration
2. ✅ Enable environment protection for production
3. ✅ Add automated release creation
4. ✅ Set up deployment notifications

### Full Setup (Multi-Developer Future)
1. ✅ Enable branch protection rules
2. ✅ Require PR reviews
3. ✅ Add team environment approvals
4. ✅ Set up advanced monitoring

## 🚀 Quick Start Commands

**To enable workflows in new project:**
```bash
# 1. Copy workflow files from template
cp -r .github/ /path/to/new-project/

# 2. Update repository-specific values in workflows
# Edit .github/workflows/ci.yml:
# - Update image names
# - Update health check endpoints
# - Update notification settings

# 3. Add required secrets to new repository
# (Follow steps in section 1 above)

# 4. Push to trigger first workflow run
git push origin dev
```

**To test workflow locally:**
```bash
# Install act (GitHub Actions local runner)
# Windows (using chocolatey):
choco install act-cli

# Run workflow locally
act push -W .github/workflows/ci.yml
```

## 📋 Troubleshooting Common Issues

### Build Failures
- **Check Docker syntax** in Dockerfile
- **Verify package.json scripts** exist (test, lint, build)
- **Ensure Node.js version** matches in package.json and Dockerfile

### Permission Errors
- **Verify GITHUB_TOKEN** has packages:write permission
- **Check workflow permissions** in repository settings
- **Ensure secrets** are added to correct repository

### Deployment Failures
- **Verify Coolify webhook URL** is correct
- **Check application health endpoint** returns 200
- **Ensure environment variables** are set in Coolify

### Container Registry Issues
- **Check package visibility** (public vs private)
- **Verify image tags** are being created
- **Ensure cleanup policies** don't delete recent images

This setup gives you professional-grade CI/CD while maintaining the simplicity of your current Coolify workflow!
