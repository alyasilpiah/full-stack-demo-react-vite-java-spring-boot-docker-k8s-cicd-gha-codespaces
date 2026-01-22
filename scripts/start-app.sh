#!/bin/bash

# Script to start the application locally

echo "Starting Full Stack Demo Application..."
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check Java
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed"
    exit 1
fi

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven is not installed"
    exit 1
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed"
    exit 1
fi

echo "✓ All prerequisites met"
echo ""

# Build backend
echo "Building backend..."
cd backend
mvn clean install -DskipTests
echo "✓ Backend built successfully"
echo ""

# Install frontend dependencies
echo "Installing frontend dependencies..."
cd ../frontend
if [ ! -d "node_modules" ]; then
    npm install
fi
echo "✓ Frontend dependencies installed"
echo ""

# Start backend in background
echo "Starting backend server..."
cd ../backend
mvn spring-boot:run > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid
echo "✓ Backend started (PID: $BACKEND_PID)"
echo "  Logs: backend.log"
echo ""

# Wait for backend to start
echo "Waiting for backend to be ready..."
BACKEND_READY=false
for i in {1..30}; do
    if curl -s http://localhost:8080/api/tasks > /dev/null 2>&1; then
        echo "✓ Backend is ready"
        BACKEND_READY=true
        break
    fi
    sleep 2
done

if [ "$BACKEND_READY" = false ]; then
    echo "✗ Error: Backend failed to start within 60 seconds"
    echo "Check backend.log for errors"
    cat ../backend.log
    exit 1
fi

# Start frontend
echo "Starting frontend development server..."
cd ../frontend
npm run dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../frontend.pid
echo "✓ Frontend started (PID: $FRONTEND_PID)"
echo "  Logs: frontend.log"
echo ""

echo "========================================"
echo "Application is running!"
echo "========================================"
echo ""
echo "Frontend: http://localhost:5173"
echo "Backend API: http://localhost:8080/api/tasks"
echo "H2 Console: http://localhost:8080/h2-console"
echo ""
echo "To stop the application, run:"
echo "  ./scripts/stop-app.sh"
echo ""
echo "Press Ctrl+C to view logs (app will continue running)"
echo ""

# Show logs
tail -f ../backend.log ../frontend.log
