#!/bin/bash

# Script to stop the application

echo "Stopping Full Stack Demo Application..."

# Stop backend
if [ -f backend.pid ]; then
    BACKEND_PID=$(cat backend.pid)
    if ps -p $BACKEND_PID > /dev/null; then
        echo "Stopping backend (PID: $BACKEND_PID)..."
        kill $BACKEND_PID
        rm backend.pid
        echo "✓ Backend stopped"
    else
        echo "Backend process not found"
        rm backend.pid
    fi
else
    echo "Backend PID file not found"
fi

# Stop frontend
if [ -f frontend.pid ]; then
    FRONTEND_PID=$(cat frontend.pid)
    if ps -p $FRONTEND_PID > /dev/null; then
        echo "Stopping frontend (PID: $FRONTEND_PID)..."
        kill $FRONTEND_PID
        rm frontend.pid
        echo "✓ Frontend stopped"
    else
        echo "Frontend process not found"
        rm frontend.pid
    fi
else
    echo "Frontend PID file not found"
fi

echo ""
echo "Application stopped successfully"
