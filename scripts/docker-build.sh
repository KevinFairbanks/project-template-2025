#!/bin/bash
# Docker build automation script

set -e

# Configuration
IMAGE_NAME="myapp"
REGISTRY="ghcr.io/your-username"
VERSION=${1:-latest}

echo "🐳 Building Docker image..."

# Build multi-platform image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag "${REGISTRY}/${IMAGE_NAME}:${VERSION}" \
  --tag "${REGISTRY}/${IMAGE_NAME}:latest" \
  --push \
  .

echo "✅ Build completed: ${REGISTRY}/${IMAGE_NAME}:${VERSION}"
