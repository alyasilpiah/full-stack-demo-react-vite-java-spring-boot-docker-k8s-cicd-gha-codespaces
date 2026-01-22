#!/bin/bash

# Script to build Docker images

set -e

echo "Building backend Docker image..."
cd backend
docker build -t fullstack-backend:latest .
echo "✓ Backend image built successfully"

cd ..

echo "Building frontend Docker image..."
cd frontend
docker build -t fullstack-frontend:latest .
echo "✓ Frontend image built successfully"

cd ..

echo ""
echo "All Docker images built successfully!"
echo ""
echo "Available images:"
docker images | grep fullstack
