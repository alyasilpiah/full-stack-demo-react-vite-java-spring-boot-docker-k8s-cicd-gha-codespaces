# SonarQube Local Setup Guide

This guide explains how to set up and use SonarQube locally for code quality analysis.

## Quick Start

### 1. Start SonarQube with Docker Compose

```bash
# Start all services including SonarQube
docker-compose up -d sonarqube

# Or start all services
docker-compose up -d
```

### 2. Run Setup Script

Wait for SonarQube to fully start (about 1-2 minutes), then run:

```bash
./scripts/setup-sonarqube.sh
```

This script will:
- Wait for SonarQube to be ready
- Change the default admin password (to `Admin@123456`)
- Create projects for backend and frontend
- Generate authentication tokens
- Display setup information

### 3. Access SonarQube

- **URL**: http://localhost:9000
- **Username**: admin
- **Password**: Admin@123456 (changed from default 'admin', set by `./scripts/setup-sonarqube.sh`)

## GitHub Actions Integration

### For Local SonarQube (Development/Testing)

1. The workflow will skip SonarQube analysis if `SONAR_TOKEN` is not set
2. This is normal for local development and won't cause the workflow to fail

### For Production (Optional)

If you want to use SonarQube in GitHub Actions:

1. Expose your local SonarQube instance or use SonarCloud
2. Add GitHub Secrets:
   - `SONAR_TOKEN`: Token from setup script output
   - `SONAR_HOST_URL`: Your SonarQube URL (e.g., http://your-server:9000)

### Manual Workflow Dispatch

Both workflows now support manual triggering:

1. Go to **Actions** tab in GitHub
2. Select workflow (Backend CI/CD or Frontend CI/CD)
3. Click **Run workflow** button
4. Choose branch and click **Run workflow**

## Local Code Analysis

### Backend Analysis

```bash
cd backend
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=alyasilpiah_full-stack-demo-backend \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_BACKEND_TOKEN
```

### Frontend Analysis

```bash
cd frontend
npm install -g sonarqube-scanner
sonar-scanner \
  -Dsonar.projectKey=alyasilpiah_full-stack-demo-frontend \
  -Dsonar.sources=src \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_FRONTEND_TOKEN
```

## CORS Configuration for GitHub Codespaces

The backend is now configured to work properly in GitHub Codespaces:

### Backend CORS Settings

- Configured in `WebConfig.java` to support:
  - `https://*.githubpreview.dev` (Codespaces preview URLs)
  - `https://*.app.github.dev` (Codespaces app URLs)
  - Local development origins

### Frontend Development Server

The Vite config now includes:
- Host binding for Codespaces
- API proxy to avoid CORS issues
- Proper port configuration

### Running in Codespaces

```bash
# Terminal 1: Start backend
cd backend
mvn spring-boot:run

# Terminal 2: Start frontend
cd frontend
npm install
npm run dev
```

The Codespaces will automatically forward ports and provide URLs for both services.

## Docker Compose Services

### Services Included

```yaml
services:
  backend:        # Spring Boot API (port 8080)
  frontend:       # React Vite App (port 8000)
  sonarqube:      # Code Quality Analysis (port 9000)
```

### Managing Services

```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d sonarqube

# View logs
docker-compose logs -f sonarqube

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Troubleshooting

### SonarQube Won't Start

```bash
# Check logs
docker-compose logs sonarqube

# Increase Docker memory (SonarQube needs ~2GB)
# In Docker Desktop: Settings > Resources > Memory

# Reset SonarQube
docker-compose down -v
docker-compose up -d sonarqube
```

### Token Issues

If you need to regenerate tokens:

1. Login to SonarQube: http://localhost:9000
2. Go to: User Icon > My Account > Security
3. Generate new token
4. Update your secrets/environment variables

### CORS Issues in Codespaces

If you still experience CORS issues:

1. Check the backend logs for CORS-related errors
2. Verify the Codespaces URL is being allowed
3. Add specific URL to `application.properties`:
   ```properties
   cors.allowed.origins=https://your-codespace-url.app.github.dev
   ```

### Workflow Not Working

1. Check workflow logs in GitHub Actions tab
2. Verify all paths in workflow files are correct
3. Ensure required secrets are set (if using external SonarQube)
4. Use manual dispatch to test workflows

## Best Practices

1. **Local Development**: Use local SonarQube for quick feedback
2. **CI/CD**: Configure `SONAR_TOKEN` only for production/main branches
3. **Code Quality**: Review SonarQube dashboard regularly
4. **Secrets Management**: Never commit tokens to repository
5. **Codespaces**: Use environment variables for dynamic URLs

## Additional Resources

- [SonarQube Documentation](https://docs.sonarqube.org/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [GitHub Codespaces Documentation](https://docs.github.com/codespaces)
- [Spring Boot CORS Documentation](https://spring.io/guides/gs/rest-service-cors/)
