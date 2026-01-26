#!/bin/bash

# SonarQube Setup Script
# This script sets up SonarQube locally and creates necessary tokens

set -e

SONARQUBE_HOST="http://localhost:9000"
SONARQUBE_USER="admin"
SONARQUBE_PASS="admin"
NEW_PASSWORD="Admin@123456"

echo "🚀 Setting up SonarQube..."

# Wait for SonarQube to be ready
echo "⏳ Waiting for SonarQube to start..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s -f "${SONARQUBE_HOST}/api/system/status" > /dev/null 2>&1; then
        echo "✅ SonarQube is ready!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   Attempt ${RETRY_COUNT}/${MAX_RETRIES}..."
    sleep 5
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ SonarQube failed to start. Please check docker logs."
    exit 1
fi

# Wait a bit more for full initialization
sleep 10

echo ""
echo "🔐 Changing default admin password..."

# Try to change password (will fail if already changed)
CHANGE_PASSWORD_RESPONSE=$(curl -s -u "${SONARQUBE_USER}:${SONARQUBE_PASS}" \
    -X POST "${SONARQUBE_HOST}/api/users/change_password" \
    -d "login=${SONARQUBE_USER}" \
    -d "password=${NEW_PASSWORD}" \
    -d "previousPassword=${SONARQUBE_PASS}" || echo "Password already changed")

if [[ "$CHANGE_PASSWORD_RESPONSE" == *"Password already changed"* ]]; then
    echo "   Password already changed, using new password"
    SONARQUBE_PASS="${NEW_PASSWORD}"
else
    echo "   Password changed successfully"
    SONARQUBE_PASS="${NEW_PASSWORD}"
fi

echo ""
echo "📝 Creating projects..."

# Create Backend Project
curl -s -u "${SONARQUBE_USER}:${SONARQUBE_PASS}" \
    -X POST "${SONARQUBE_HOST}/api/projects/create" \
    -d "name=full-stack-demo-backend" \
    -d "project=alyasilpiah_full-stack-demo-backend" > /dev/null || echo "   Backend project may already exist"

# Create Frontend Project
curl -s -u "${SONARQUBE_USER}:${SONARQUBE_PASS}" \
    -X POST "${SONARQUBE_HOST}/api/projects/create" \
    -d "name=full-stack-demo-frontend" \
    -d "project=alyasilpiah_full-stack-demo-frontend" > /dev/null || echo "   Frontend project may already exist"

echo "✅ Projects created"

echo ""
echo "🔑 Generating authentication tokens..."

# Generate token for backend
BACKEND_TOKEN_NAME="backend-ci-token"
BACKEND_TOKEN_RESPONSE=$(curl -s -u "${SONARQUBE_USER}:${SONARQUBE_PASS}" \
    -X POST "${SONARQUBE_HOST}/api/user_tokens/generate" \
    -d "name=${BACKEND_TOKEN_NAME}")

BACKEND_TOKEN=$(echo $BACKEND_TOKEN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# Generate token for frontend
FRONTEND_TOKEN_NAME="frontend-ci-token"
FRONTEND_TOKEN_RESPONSE=$(curl -s -u "${SONARQUBE_USER}:${SONARQUBE_PASS}" \
    -X POST "${SONARQUBE_HOST}/api/user_tokens/generate" \
    -d "name=${FRONTEND_TOKEN_NAME}")

FRONTEND_TOKEN=$(echo $FRONTEND_TOKEN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ SonarQube Setup Complete!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📌 SonarQube URL: ${SONARQUBE_HOST}"
echo "📌 Username: ${SONARQUBE_USER}"
echo "📌 Password: ${SONARQUBE_PASS}"
echo ""
echo "🔑 SONAR_TOKEN (use this for GitHub Actions):"
echo "   ${BACKEND_TOKEN}"
echo ""
echo "📝 Add this to your GitHub repository secrets:"
echo "   - Secret name: SONAR_TOKEN"
echo "   - Secret value: ${BACKEND_TOKEN}"
echo "   - Secret name: SONAR_HOST_URL"
echo "   - Secret value: ${SONARQUBE_HOST}"
echo ""
echo "🚀 To run analysis locally:"
echo ""
echo "   Backend:"
echo "   cd backend"
echo "   mvn clean verify sonar:sonar \\"
echo "     -Dsonar.projectKey=alyasilpiah_full-stack-demo-backend \\"
echo "     -Dsonar.host.url=${SONARQUBE_HOST} \\"
echo "     -Dsonar.login=${BACKEND_TOKEN}"
echo ""
echo "   Frontend:"
echo "   cd frontend"
echo "   npm install -g sonarqube-scanner"
echo "   sonar-scanner \\"
echo "     -Dsonar.projectKey=alyasilpiah_full-stack-demo-frontend \\"
echo "     -Dsonar.sources=src \\"
echo "     -Dsonar.host.url=${SONARQUBE_HOST} \\"
echo "     -Dsonar.login=${FRONTEND_TOKEN}"
echo ""
echo "════════════════════════════════════════════════════════════════"
