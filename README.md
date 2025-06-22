# Project Template Base

A standardized project template repository for consistent project setup across all development projects.

## 🚀 Quick Start

1. **Use this template** to create a new repository on GitHub
2. **Clone** your new repository locally
3. **Run the setup script** (if applicable)
4. **Update project-specific information** in this README and other config files
5. **Delete or modify** template-specific content as needed

## 📁 Project Structure

```
project-root/
├── .github/                    # GitHub workflows and templates
│   ├── workflows/
│   │   ├── ci.yml             # Continuous Integration
│   │   └── deploy-staging.yml # Auto-deploy to staging
│   ├── pull_request_template.md
│   └── issue_template.md
├── .cursor/                    # Cursor AI rules and configuration
│   └── rules/
│       └── project-rules.md   # Project-specific Cursor rules
├── .vscode/                    # VS Code settings
│   └── settings.json
├── docs/                       # Documentation
│   ├── DEPLOYMENT.md
│   ├── DEVELOPMENT.md
│   └── API.md
├── src/                        # Source code
│   ├── components/            # Reusable components
│   ├── pages/                 # Page components/views
│   ├── styles/                # Stylesheets
│   ├── utils/                 # Utility functions
│   └── assets/                # Static assets
├── public/                     # Public static files
├── tests/                      # Test files
├── Dockerfile                 # Docker configuration
├── docker-compose.yml         # Development environment
├── .dockerignore              # Docker ignore rules
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore rules
├── .gitattributes             # Git attributes (CRLF fixes)
├── .cursorignore              # Cursor ignore rules
├── .dockerignore              # Docker ignore rules
├── package.json               # Dependencies and scripts
├── CHANGELOG.md               # Change log
├── TASKS.md                   # Action items and task list
└── README.md                  # This file
```

## 🔧 Development Workflow

### Branch Strategy
- **`main`**: Production-ready code (protected, no direct commits after initial setup)
- **`dev`**: Development integration branch (auto-deploys to staging)
- **`feature/*`**: New features (`feature/user-authentication`)
- **`fix/*`**: Bug fixes (`fix/login-error`)
- **`docs/*`**: Documentation updates (`docs/api-guide`)
- **`refactor/*`**: Code refactoring (`refactor/user-service`)

### Commit Message Format
Use semantic prefixes for all commits:
- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `refactor:` Code refactoring
- `test:` Test updates
- `chore:` Maintenance tasks

**Example**: `feat: add user authentication system`

### Development Process
1. Create feature branch from `dev`
2. Make changes and commit with semantic prefixes
3. Update CHANGELOG.md and TASKS.md
4. Test thoroughly (staging environment if needed)
5. Create PR to `dev` branch
6. After review and merge, delete feature branch
7. Changes auto-deploy to staging from `dev`
8. When ready for production, merge `dev` to `main`

## 🐳 Docker Setup

### Development
```bash
docker-compose up -d
```

### Production Build
```bash
docker build -t project-name .
```

## 🌍 Multi-Workstation Setup

### Git Configuration
```bash
# Set global defaults
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Per-project overrides (if needed)
git config user.name "Work Name"
git config user.email "work.email@company.com"
```

### SSH Keys
Configure `~/.ssh/config` for multiple accounts:
```
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_work
```

## 📋 Task Management

See [TASKS.md](TASKS.md) for current action items and project tasks.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and changes.

## 🚀 Deployment

- **Staging**: Auto-deploys from `dev` branch
- **Production**: Manual deployment from `main` branch
- **Platform**: Coolify-managed server with Docker

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for detailed deployment instructions.

## 🤖 Cursor AI Integration

This project includes standardized Cursor AI rules in `.cursor/rules/project-rules.md` for:
- Consistent coding standards
- Automated changelog updates
- Commit message assistance
- Code review guidance

## 📄 License

[Specify your license here]

## 👥 Contributors

[Add contributor information]

---

**Note**: This is a template repository. Update this README with project-specific information after creating your new project.
