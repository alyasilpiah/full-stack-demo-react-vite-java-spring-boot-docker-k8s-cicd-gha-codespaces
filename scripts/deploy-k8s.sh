#!/bin/bash

# Script to deploy to Kubernetes

set -e

echo "Starting Kubernetes deployment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if Minikube is running
if command -v minikube &> /dev/null; then
    if ! minikube status &> /dev/null; then
        echo "Starting Minikube..."
        minikube start
    fi
    
    # Build images in Minikube's Docker environment
    echo "Building images for Minikube..."
    eval $(minikube docker-env)
    
    docker build -t fullstack-backend:latest ./backend
    docker build -t fullstack-frontend:latest ./frontend
fi

# Create namespace
echo "Creating namespace..."
kubectl apply -f k8s/namespace.yaml

# Apply ConfigMap
echo "Applying ConfigMap..."
kubectl apply -f k8s/configmap.yaml

# Deploy backend
echo "Deploying backend..."
kubectl apply -f k8s/backend-deployment.yaml

# Deploy frontend
echo "Deploying frontend..."
kubectl apply -f k8s/frontend-deployment.yaml

echo ""
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=backend --timeout=120s || true
kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s || true

echo ""
echo "Deployment complete!"
echo ""
echo "Checking status:"
kubectl get pods
echo ""
kubectl get services
echo ""

if command -v minikube &> /dev/null; then
    echo "To access the application, run:"
    echo "  minikube service frontend-service"
fi
