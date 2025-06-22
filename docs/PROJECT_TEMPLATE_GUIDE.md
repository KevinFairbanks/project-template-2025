# Project Template Guide

## 🎯 Overview

This is a comprehensive project template designed for modern web development with professional-grade automation, quality gates, and deployment strategies. It's optimized for single developers but scales seamlessly to team environments.

## ✨ Key Features

### 🤖 AI-Powered Development
- **Cursor AI Integration** with permission-based operations
- **Intelligent memory system** for cross-session continuity
- **Automated documentation** updates (CHANGELOG.md, TASKS.md)
- **Code quality suggestions** and security scanning
- **BugBot integration** for automated PR reviews

### 🚀 CI/CD Pipeline
- **Quality gates** prevent bad code deployment
- **Multi-platform Docker builds** (AMD64 + ARM64)
- **Automated testing** with Jest
- **Security scanning** with Trivy
- **Coolify integration** for seamless deployment

### 📋 Project Management
- **GitHub issue templates** (Bug, Feature, Documentation)
- **Discussion templates** for community engagement
- **Automated project boards** with task tracking
- **Semantic commit messages** with automatic categorization
- **Automated contributors** list management

### 🔒 Security & Best Practices
- **Multi-stage Docker builds** for production optimization
- **Environment variable management** with .env templates
- **Security scanning** in CI/CD pipeline
- **Proprietary license** template for commercial projects
- **Branch protection** and deployment approval workflows

## 📁 Template Structure

```
project-root/
├── .cursor/                    # Cursor AI configuration
│   ├── rules/                  # Project and advanced rules
│   ├── memories/               # AI memory context
│   └── settings.json           # AI behavior settings
├── .github/                    # GitHub automation
│   ├── workflows/              # CI/CD and automation
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   ├── DISCUSSION_TEMPLATE/    # Discussion templates
│   └── actions/                # Custom actions
├── .vscode/                    # VS Code workspace settings
├── docs/                       # Comprehensive documentation
├── docker/                     # Docker configuration files
├── scripts/                    # Automation scripts
├── src/                        # Source code
└── Configuration files         # .gitignore, .dockerignore, etc.
```

## 🚀 Quick Start

### 1. Initial Setup
```bash
# Clone this template
git clone <template-repo-url> your-new-project
cd your-new-project

# Update project-specific information
# Edit package.json, README.md, LICENSE, etc.

# Install dependencies
npm install

# Start development
npm run dev
```

### 2. Cursor AI Setup
```bash
# Cursor will automatically detect:
- .cursor/rules/project-rules.md (workflow rules)
- .cursor/rules/advanced-rules.md (AI enhancement rules)
- .cursor/memories/ (project context)
- .cursor/settings.json (AI behavior)

# Enable features in Cursor:
1. Go to Cursor Settings
2. Enable "Memories" feature
3. Enable "BugBot" (monitor costs)
4. Connect GitHub account(s)
```

### 3. GitHub Repository Setup
```bash
# Create new repository on GitHub
# Add repository secrets (see docs/GITHUB_SETUP.md):
COOLIFY_STAGING_WEBHOOK
COOLIFY_PRODUCTION_WEBHOOK
STAGING_URL
PRODUCTION_URL

# Push initial code
git remote add origin <your-repo-url>
git push -u origin main
```

### 4. Coolify Deployment
```bash
# Follow docs/COOLIFY_SETUP.md for:
- Application configuration
- Database setup
- Environment variables
- Health check endpoints
- Webhook integration
```

## 🎯 Development Workflow

### Daily Development
1. **Create feature branch** from `dev`
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/your-feature-name
   ```

2. **Develop with AI assistance**
   - Cursor AI provides intelligent suggestions
   - Automatic code quality checks
   - Security vulnerability detection
   - Performance optimization hints

3. **Commit with semantic messages**
   ```bash
   git add .
   git commit -m "feat: add user authentication system"
   # Cursor AI will ask for permission and update docs
   ```

4. **Test and deploy to staging**
   ```bash
   git push origin feature/your-feature-name
   # Create PR to dev branch
   # Automatic deployment to staging after merge
   ```

5. **Production deployment**
   ```bash
   # Merge dev to main (with approval)
   # Automatic production deployment with health checks
   ```

### AI-Powered Features

#### Automatic Documentation
- **CHANGELOG.md** updated based on commit types
- **TASKS.md** tracks progress and completion
- **README.md** updated when features change
- **API documentation** maintained automatically

#### Code Quality
- **ESLint/Prettier** formatting
- **Security vulnerability** detection
- **Performance bottleneck** identification
- **Test coverage** recommendations

#### Project Management
- **Issue linking** to commits
- **PR descriptions** auto-generated
- **Project board** automation
- **Task completion** tracking

## 🔧 Configuration Options

### Single Developer Setup (Default)
```yaml
Features Enabled:
- ✅ Quality gates and testing
- ✅ Docker builds and container registry
- ✅ Coolify deployment integration
- ✅ AI-powered development assistance
- ❌ Environment protection (optional)
- ❌ Branch protection (optional)
- ❌ Required PR reviews (not needed)
```

### Team Development Setup
```yaml
Additional Features:
- ✅ Branch protection rules
- ✅ Required PR reviews
- ✅ Environment protection
- ✅ Multi-developer project boards
- ✅ Advanced notification systems
```

### Enterprise Setup
```yaml
Enhanced Security:
- ✅ Advanced security scanning
- ✅ Compliance reporting
- ✅ Audit trails
- ✅ Multi-environment deployments
- ✅ Advanced monitoring
```

## 📚 Documentation Structure

### Core Documentation
- **README.md** - Project overview and setup
- **CHANGELOG.md** - Version history and changes
- **TASKS.md** - Project task tracking
- **PROJECT_SETUP_GUIDE.md** - Initial setup instructions

### Technical Documentation
- **docs/DEVELOPMENT.md** - Development environment setup
- **docs/DEPLOYMENT.md** - Deployment procedures
- **docs/WORKFLOWS.md** - GitHub Actions explanation
- **docs/DOCKER_CONFIGURATION.md** - Container optimization
- **docs/COOLIFY_SETUP.md** - Deployment platform setup
- **docs/GITHUB_SETUP.md** - Repository configuration

### Template Documentation
- **docs/PROJECT_TEMPLATE_GUIDE.md** - This comprehensive guide

## 🎨 Customization

### Branding and Identity
```bash
# Update these files for your project:
- package.json (name, description, author)
- README.md (project title, description)
- LICENSE (company name, contact info)
- docs/ (project-specific documentation)
```

### ⚠️ Important: .gitignore Configuration for New Projects

**Template Repository Setup:**
- `.vscode/` is NOT ignored (contains project settings)
- This allows VS Code settings to be shared with the template

**When Creating New Projects:**
```bash
# Add this line back to .gitignore for individual projects:
.vscode/

# This prevents sharing personal VS Code settings across team members
# Each developer can have their own local .vscode/ preferences
```

**Important Configuration Files:**
- **`.vscode/`** - Add to `.gitignore` for individual projects (personal settings)
- **`.dockerignore`** - Should ALWAYS be tracked (project configuration)
- **`.env.example`** - Should be tracked (template for environment variables)
- **`.env`** - Should NEVER be tracked (contains secrets)

**Why This Matters:**
- **Template repos** SHOULD include `.vscode/` settings for consistency
- **Individual projects** SHOULD ignore `.vscode/` for developer flexibility
- **Teams** can choose to share `.vscode/` or keep it personal
- **Docker files** like `.dockerignore` are project configuration and should be shared

### Technology Stack
```bash
# Current stack (easily customizable):
- Node.js 22 (LTS)
- Express.js 5.x
- PostgreSQL with Redis
- Jest for testing
- Docker for containerization
- Coolify for deployment

# To change stack:
1. Update package.json dependencies
2. Modify Dockerfile
3. Update .cursor/memories/project-context.md
4. Adjust CI/CD workflows
```

### AI Behavior
```bash
# Customize in .cursor/settings.json:
- AI model selection
- Temperature (creativity vs consistency)
- Max tokens (response length)
- System prompt (AI personality)
- Feature toggles (permissions, suggestions, etc.)
```

## 🔍 Troubleshooting

### Common Issues

#### Cursor AI Not Working
```bash
# Check:
1. Cursor subscription active
2. GitHub account connected
3. Project rules loaded (.cursor/rules/)
4. Memories enabled in settings
```

#### GitHub Actions Failing
```bash
# Check:
1. Repository secrets configured
2. Workflow permissions enabled
3. Package.json scripts exist
4. Docker syntax valid
```

#### Deployment Issues
```bash
# Check:
1. Coolify webhook URLs correct
2. Environment variables set
3. Health check endpoint responding
4. Docker image builds successfully
```

### Getting Help
- **GitHub Discussions** - Community support
- **Issue Templates** - Bug reports and feature requests
- **Documentation** - Comprehensive guides
- **Security Advisories** - Private vulnerability reporting

## 🚀 Scaling Considerations

### From Solo to Team
1. **Enable branch protection** rules
2. **Add environment protection** for production
3. **Set up PR review** requirements
4. **Configure team notifications**
5. **Expand project board** automation

### From Startup to Enterprise
1. **Add compliance** scanning (SBOM, audits)
2. **Implement advanced** monitoring
3. **Set up multi-environment** deployments
4. **Add performance** testing
5. **Enhance security** measures

## 🎯 Best Practices

### Development
- **Follow semantic commit** messages
- **Keep branches small** and focused
- **Test on staging** before production
- **Update documentation** with changes
- **Use AI suggestions** for code quality

### Security
- **Rotate secrets** regularly
- **Keep dependencies** updated
- **Monitor security** advisories
- **Use environment variables** for configuration
- **Enable security** scanning

### Performance
- **Monitor application** metrics
- **Optimize Docker** images
- **Use caching** strategies
- **Profile database** queries
- **Implement health** checks

## 📈 Success Metrics

### Development Velocity
- **Faster feature delivery** with AI assistance
- **Reduced bugs** through quality gates
- **Improved code quality** with automated reviews
- **Better documentation** through automation

### Operational Excellence
- **Zero-downtime deployments** with health checks
- **Faster rollbacks** with container images
- **Better monitoring** with comprehensive logging
- **Reduced manual errors** through automation

### Team Productivity
- **Consistent development** environment
- **Streamlined workflows** with automation
- **Better collaboration** through templates
- **Knowledge sharing** through documentation

This template provides a solid foundation for modern web development that grows with your project and team needs!

## 🔗 Related Resources

- [Cursor AI Documentation](https://docs.cursor.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/best-practices/)
- [Coolify Documentation](https://coolify.io/docs)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
