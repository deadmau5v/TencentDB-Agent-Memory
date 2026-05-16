#!/bin/bash

# Docker Build Verification Script
# This script verifies that the Docker build process works correctly

set -e

echo "🧪 Testing Docker Build for Hermes Memory Plugin"
echo "================================================"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

echo "✅ Docker is available"

# Check if Dockerfile exists
if [ ! -f "docker/opensource/Dockerfile.hermes" ]; then
    echo "❌ Dockerfile not found at docker/opensource/Dockerfile.hermes"
    exit 1
fi

echo "✅ Dockerfile found"

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -f docker/opensource/Dockerfile.hermes -t hermes-memory-test .

echo "✅ Docker image built successfully"

# Verify the image was created
if ! docker image inspect hermes-memory-test &> /dev/null; then
    echo "❌ Failed to create Docker image"
    exit 1
fi

echo "✅ Docker image created successfully"

# Test basic functionality
echo "🧪 Testing basic functionality..."

# Test 1: Check if required files are present
echo "📁 Testing file structure..."
docker run --rm hermes-memory-test ls -la /opt/tdai-gateway/node_modules/@tencentdb-agent-memory/memory-tencentdb/hermes-plugin/memory/memory_tencentdb/plugin.yaml

echo "✅ Plugin files present"

# Test 2: Check if Node.js is available
echo "🟢 Testing Node.js installation..."
docker run --rm hermes-memory-test node --version

echo "✅ Node.js available"

# Test 3: Check if Python is available
echo "🐍 Testing Python installation..."
docker run --rm hermes-memory-test python3 --version

echo "✅ Python available"

# Test 4: Check if healthcheck dependencies are available
echo "🏥 Testing healthcheck dependencies..."
docker run --rm hermes-memory-test curl --version

echo "✅ Healthcheck dependencies available"

# Clean up
echo "🧹 Cleaning up..."
docker rmi hermes-memory-test

echo ""
echo "🎉 All tests passed! Docker build is working correctly."
echo ""
echo "Next steps:"
echo "1. Push your changes to trigger the CI/CD pipeline"
echo "2. Check GitHub Actions for automated builds"
echo "3. Use the pre-built images from GitHub Container Registry"

# Display usage example
echo ""
echo "Usage example:"
echo "docker run -it -p 8420:8420 -e MODEL_API_KEY=your_key hermes-memory"