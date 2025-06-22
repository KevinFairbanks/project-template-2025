# GitHub Workflows Documentation

## Overview

This project uses GitHub Actions for automated CI/CD workflows. Here's a comprehensive breakdown of our automation strategy.

## Workflow Files

### 1. CI/CD Pipeline (`.github/workflows/ci.yml`)

**Triggers:**
- Push to `dev` or `main` branches
- Pull requests to `dev` or `main` branches

**Stages:**

#### Stage 1: Quality Assurance
```yaml
Duration: ~3-5 minutes
Runs: On every push/PR
Jobs: ESLint, Prettier, Tests, Security Audit
Failure Impact: Blocks all subsequent stages
```

**What it does:**
- Lints code with ESLint
- Checks formatting with Prettier
- Runs Jest tests with coverage
- Audits npm dependencies for vulnerabilities
- Reviews new dependencies (PRs only)

#### Stage 2: Build & Package
```yaml
Duration: ~5-10 minutes
Runs: After quality passes
Artifacts: Docker images in GitHub Container Registry
Platforms: AMD64 + ARM64
```

**What it does:**
- Builds Docker images using multi-stage process
- Tags images with branch name and commit SHA
- Pushes to GitHub Container Registry
- Uses build caching for faster subsequent builds

**Coolify Integration:**
- **No interference** - This creates reusable images
- **Coolify benefits** - Can use pre-built images
- **Flexibility** - Images work anywhere (local, staging, prod)

#### Stage 3: Security Scanning
```yaml
Duration: ~2-3 minutes
Scanner: Trivy (aquasecurity)
Output: GitHub Security tab
```

**What it does:**
- Scans Docker images for vulnerabilities
- Uploads findings to GitHub Security dashboard
- **SBOM Generation** - Creates Software Bill of Materials
- **When/Why SBOM**: Legal compliance, supply chain security

#### Stage 4a: Staging Deployment (dev branch only)
```yaml
Trigger: Automatic on dev push
Method: Coolify webhook
Health Check: /health endpoint
Notifications: Optional Slack integration
```

#### Stage 4b: Production Deployment (main branch only)
```yaml
Trigger: Manual approval required
Method: Coolify webhook
Environment Protection: GitHub environments
Post-Deploy: Extended health checks + release creation
```

### 2. Contributors Update (`.github/workflows/contributors.yml`)

**Triggers:**
- Push to main branch
- Weekly schedule (Sundays)
- Manual trigger

**What it does:**
- Automatically updates contributor list in README.md
- Commits changes with semantic commit message
- Updates CHANGELOG.md when contributors change

## GitHub vs Coolify Deployment

### Current Recommendation: **Hybrid Approach**

**Keep Coolify's built-in watching for:**
- ✅ Simplicity - Zero configuration
- ✅ Real-time deployment
- ✅ Coolify-optimized process

**Add GitHub Actions for:**
- ✅ Quality gates - Only deploy if tests pass
- ✅ Security scanning - Vulnerability checks
- ✅ Environment management - Staging vs production
- ✅ Release automation - Version tagging

**Hybrid Configuration:**
```yaml
# Option 1: GitHub triggers Coolify (Recommended)
1. GitHub runs quality/security checks
2. GitHub calls Coolify webhook on success
3. Coolify handles actual deployment

# Option 2: Pure GitHub (Advanced)
1. GitHub builds and tests
2. GitHub deploys directly to server
3. More complex but more control
```

### Environment Protection Rules

**For Single Developer (You):**
- **Staging**: No protection needed (auto-deploy)
- **Production**: Optional manual approval for safety

**For Multi-Developer Teams:**
- **Branch protection**: Require PR reviews
- **Environment protection**: Require approvals
- **Status checks**: All CI must pass

## Code Coverage (Codecov)

**What is Codecov?**
- Service that tracks test coverage over time
- Shows which code lines are tested
- Provides PR comments with coverage changes
- Helps maintain code quality

**Benefits:**
- Visual coverage reports
- Trend tracking over time
- Integration with GitHub PRs
- Team accountability for testing

**Setup (Optional):**
1. Sign up at codecov.io
2. Connect GitHub repository
3. Add `CODECOV_TOKEN` to repository secrets
4. Coverage reports upload automatically

## Notification Options

**Current**: Comments out Slack (since you switched to ClickUp)

**Alternatives for Notifications:**
- **GitHub Issues** - Create issues for failed deployments
- **Email** - Built-in GitHub notifications
- **Microsoft Teams** - If using Office 365
- **Discord** - For informal teams
- **ClickUp API** - Custom integration (future consideration)

## Single Developer Workflow

**Simplified for Solo Development:**

```yaml
# Recommended minimal setup:
1. Keep quality checks (essential)
2. Keep Docker builds (useful)
3. Skip environment protection (unnecessary)
4. Optional: Keep security scanning (good practice)
5. Use Coolify's built-in deployment watching

# Branch strategy for solo:
main (production) ← dev (staging) ← feature branches
```

**Documentation Notes:**
- Environment protection explanations in docs
- Branch protection guidelines
- Scaling considerations for team growth

## Updated Workflow Insights

**Changes based on your feedback:**

1. **Build & Package**: Creates reusable Docker images that **enhance** Coolify
2. **SBOM**: Generated for compliance and security tracking
3. **Deployment**: Recommend keeping Coolify's watching with GitHub quality gates
4. **Notifications**: Removed Slack, documented alternatives
5. **Single Dev**: Simplified recommendations in documentation

**Files to Create Next:**
- Environment protection documentation
- Branch protection guidelines
- Scaling considerations
- ClickUp integration possibilities

Would you like me to proceed with the remaining next steps (GitHub templates, enhanced Cursor AI configs, Docker optimizations, and Coolify-specific setup)?
