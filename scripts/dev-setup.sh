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
