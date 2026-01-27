#!/bin/bash

# Quick Start Script for Full Stack Demo with SonarQube
# This script helps you get started quickly with all services

set -e

echo "🚀 Full Stack Demo - Quick Start"
echo "================================"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Function to wait for service
wait_for_service() {
    local url=$1
    local service_name=$2
    local max_attempts=30
    local attempt=0

    echo "⏳ Waiting for $service_name to be ready..."
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s -f "$url" > /dev/null 2>&1; then
            echo "✅ $service_name is ready!"
            return 0
        fi
        attempt=$((attempt + 1))
        echo "   Attempt $attempt/$max_attempts..."
        sleep 2
    done
    
    echo "⚠️  $service_name did not start in time"
    return 1
}

# Parse command line arguments
START_SONARQUBE=false
RUN_SETUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --with-sonarqube     Not supported (SonarQube not in docker-compose.yml)"
            echo "  --setup-sonarqube    Not supported (SonarQube not in docker-compose.yml)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                          # Start backend and frontend only"
            echo "  $0 --with-sonarqube        # Not supported (SonarQube not in docker-compose.yml)"
            echo "  $0 --setup-sonarqube       # Not supported (SonarQube not in docker-compose.yml)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Determine which services to start
if [ "$START_SONARQUBE" = true ]; then
    echo "⚠️  SonarQube is not defined in docker-compose.yml. Use docker compose up -d once you add it."
    START_SONARQUBE=false
fi

SERVICES="backend-service frontend"
echo "📦 Starting application services (backend-service, frontend)..."

echo ""

# Build and start services
echo "🔨 Building and starting services..."
docker compose up -d $SERVICES

echo ""

# Wait for backend
if wait_for_service "http://localhost:8080/api/health/status" "Backend API"; then
    echo "   Backend API: http://localhost:8080/api/tasks"
    echo "   Backend Health: http://localhost:8080/api/health/status"
fi

echo ""

# Wait for frontend
if wait_for_service "http://localhost:8000" "Frontend"; then
    echo "   Frontend UI: http://localhost:8000"
fi

echo ""

# Handle SonarQube if requested
if [ "$START_SONARQUBE" = true ]; then
    echo "🔍 SonarQube is starting..."
    echo "   This may take 1-2 minutes for first-time setup"
    echo ""
    
    if wait_for_service "http://localhost:9000" "SonarQube"; then
        echo "   SonarQube UI: http://localhost:9000"
        echo ""
        
        if [ "$RUN_SETUP" = true ]; then
            echo "🔧 Running SonarQube setup..."
            echo ""
            ./scripts/setup-sonarqube.sh
        else
            echo "💡 To configure SonarQube, run:"
            echo "   ./scripts/setup-sonarqube.sh"
        fi
    fi
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ Services are running!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📱 Access Points:"
echo "   • Frontend:  http://localhost:8000"
echo "   • Backend:   http://localhost:8080/api/tasks"
echo "   • Health:    http://localhost:8080/api/health/status"
echo "   • H2 Console: http://localhost:8080/h2-console"

if [ "$START_SONARQUBE" = true ]; then
    echo "   • SonarQube: http://localhost:9000"
fi

echo ""
echo "📋 Useful Commands:"
echo "   • View logs:    docker compose logs -f"
echo "   • Stop all:     docker compose down"
echo "   • Restart:      docker compose restart"
echo ""
echo "📚 Documentation:"
echo "   • Main README:      README.md"
echo "   • SonarQube Guide:  docs/SONARQUBE.md"
echo "   • Environment Vars: docs/ENVIRONMENT.md"
echo ""
echo "════════════════════════════════════════════════════════════════"
