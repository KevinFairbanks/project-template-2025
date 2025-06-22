# Project Memory Context

## Architecture Decisions
- Using Express.js 5.x for backend API
- PostgreSQL as primary database
- Redis for caching and sessions
- Docker for containerization
- Coolify for deployment

## Technology Stack
- **Runtime**: Node.js 22.x (LTS)
- **Framework**: Express 5.x
- **Database**: PostgreSQL with connection pooling
- **Cache**: Redis for session management
- **Testing**: Jest for unit/integration tests
- **Linting**: ESLint 9.x with Prettier 3.x
- **Deployment**: Docker multi-stage builds

## Code Patterns
- Use semantic commit messages (feat:, fix:, docs:, etc.)
- Always update CHANGELOG.md and TASKS.md before commits
- Prefer async/await over callbacks
- Use middleware for common functionality
- Keep routes thin, business logic in services
- Use environment variables for configuration

## Git Workflow
- Never commit directly to master branch
- Create feature branches from dev
- Auto-deploy dev branch to staging
- Manual approval required for production
- Delete feature branches after merge

## Testing Strategy
- Unit tests for all business logic
- Integration tests for API endpoints
- Use staging environment for end-to-end testing
- Require test coverage above 80%

## Security Practices
- Use Helmet.js for security headers
- Validate all input with middleware
- Use environment variables for secrets
- Regular dependency audits
- Container security scanning

## Performance Guidelines
- Use compression middleware
- Implement proper caching strategies
- Optimize Docker image layers
- Monitor application metrics
- Use connection pooling for database

## Documentation Standards
- Keep README.md current with setup instructions
- Document API endpoints with examples
- Update CHANGELOG.md with all changes
- Maintain TASKS.md for project tracking
