#!/bin/sh
# Health check for Docker container

# Check if the application is responding
curl -f http://localhost:3000/health || exit 1

# Optional: Check database connection
# node -e "require('./src/utils/db-check.js')" || exit 1

echo "Health check passed"
exit 0
