# Development Guide

This guide covers the development setup, workflow, and best practices for this project.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm 8+
- Docker and Docker Compose
- Git

### Initial Setup
1. Clone the repository
2. Copy environment variables: `cp .env.example .env`
3. Install dependencies: `npm install`
4. Start development server: `npm run dev`

### Docker Development
```bash
# Start all services
npm run docker:dev

# View logs
npm run docker:logs

# Stop services
npm run docker:down
```

## 📁 Project Structure

```
src/
├── components/          # Reusable UI components
├── pages/              # Page components/views
├── styles/             # Stylesheets (CSS/SCSS)
├── utils/              # Utility functions
├── assets/             # Static assets
├── services/           # API services
├── hooks/              # Custom hooks (React)
├── contexts/           # React contexts
└── index.js            # Main entry point

public/                 # Public static files
tests/                  # Test files
docs/                   # Documentation
docker/                 # Docker configurations
```

## 🔧 Development Commands

### Core Commands
```bash
npm run dev             # Start development server
npm run build           # Build for production
npm start               # Start production server
npm test                # Run tests
npm run test:watch      # Run tests in watch mode
npm run test:coverage   # Run tests with coverage
```

### Code Quality
```bash
npm run lint            # Run ESLint
npm run lint:fix        # Fix ESLint issues
npm run format          # Format code with Prettier
```

### Docker Commands
```bash
npm run docker:build   # Build Docker image
npm run docker:run     # Run Docker container
npm run docker:dev     # Start development environment
npm run docker:down    # Stop development environment
npm run docker:logs    # View application logs
```

## 🌳 Git Workflow

### Branch Strategy
- `main` - Production-ready code (protected)
- `dev` - Development integration (auto-deploys to staging)
- `feature/*` - New features
- `fix/*` - Bug fixes
- `docs/*` - Documentation updates

### Development Process
1. **Create feature branch from dev**
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

3. **Update documentation**
   - Update `CHANGELOG.md` with changes
   - Update `TASKS.md` with task progress

4. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   # Create PR to dev branch on GitHub
   ```

5. **After merge, clean up**
   ```bash
   git checkout dev
   git pull origin dev
   git branch -d feature/your-feature-name
   ```

### Commit Message Format
Use semantic prefixes:
- `feat:` - New features
- `fix:` - Bug fixes  
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test updates
- `chore:` - Maintenance tasks

## 🧪 Testing

### Running Tests
```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run with coverage
npm run test:coverage

# Run specific test file
npm test -- --testNamePattern="your-test-name"
```

### Test Structure
```
tests/
├── unit/               # Unit tests
├── integration/        # Integration tests
├── e2e/               # End-to-end tests
└── __mocks__/         # Mock files
```

## 🔒 Environment Variables

### Required Variables
Copy `.env.example` to `.env` and update:

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/mydb

# Authentication
JWT_SECRET=your-secret-key

# APIs
API_KEY=your-api-key
```

### Environment-Specific Files
- `.env` - Local development (not in git)
- `.env.example` - Template (in git)
- `.env.test` - Test environment
- `.env.production` - Production (server only)

## 🐛 Debugging

### VS Code Debug Configuration
```json
{
  "name": "Launch Program",
  "program": "${workspaceFolder}/src/index.js",
  "request": "launch",
  "skipFiles": ["<node_internals>/**"],
  "type": "pwa-node",
  "env": {
    "NODE_ENV": "development"
  }
}
```

### Debug Commands
```bash
# Debug with Node.js inspector
node --inspect src/index.js

# Debug tests
npm run test:debug
```

## 🚀 Deployment

### Staging
- Auto-deploys from `dev` branch
- Available at: [staging-url]
- Use for testing before production

### Production
- Manual deployment from `main` branch
- Requires approval and testing
- Available at: [production-url]

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

## 🔧 Common Issues

### Node Modules Issues
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Docker Issues
```bash
# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Git Issues
```bash
# Reset to clean state
git stash
git checkout dev
git pull origin dev
```

## 📚 Additional Resources

- [Project README](../README.md)
- [Deployment Guide](DEPLOYMENT.md)
- [API Documentation](API.md)
- [Contributing Guidelines](../CONTRIBUTING.md)

## 🤝 Getting Help

1. Check this documentation
2. Look at existing code examples
3. Check the issue tracker
4. Ask in team chat
5. Create a detailed issue with reproduction steps 