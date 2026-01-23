# Environment Variables Reference

This document lists all environment variables used in the Full Stack Demo application.

## Backend Configuration

### application.properties

```properties
# CORS Configuration
cors.allowed.origins=*,https://*.githubpreview.dev,https://*.app.github.dev
```

### Docker Environment Variables

```bash
# In docker-compose.yml or .env file
SPRING_PROFILES_ACTIVE=prod
```

## Frontend Configuration

### Development (.env.development)

Create `frontend/.env.development`:

```env
VITE_API_URL=http://localhost:8080/api
```

### Production (.env.production)

Create `frontend/.env.production`:

```env
VITE_API_URL=/api
```

### GitHub Codespaces

For GitHub Codespaces, the backend URL will be automatically provided by Codespaces port forwarding. No manual configuration needed if using the proxy in `vite.config.js`.

## GitHub Actions Secrets

### Required for SonarQube Integration

Set these in GitHub Repository Settings > Secrets and variables > Actions:

```
SONAR_TOKEN=your_sonarqube_token
SONAR_HOST_URL=http://your-sonarqube-server:9000
```

**Note**: If `SONAR_TOKEN` is not set, the SonarQube analysis will be skipped gracefully.

### Optional Secrets

```
CODECOV_TOKEN=your_codecov_token  # For code coverage reporting
```

## Local Development

### Backend

No environment variables required for local development. Uses H2 in-memory database by default.

### Frontend

```bash
cd frontend
npm install
npm run dev
# Runs on http://localhost:5173
# Proxies /api requests to http://localhost:8080
```

### SonarQube

```bash
# Start SonarQube
docker-compose up -d sonarqube

# Run setup script to get tokens
./scripts/setup-sonarqube.sh

# Use displayed token for analysis
```

## GitHub Codespaces Specific

### Automatic Port Forwarding

GitHub Codespaces automatically forwards:
- Port 8080 (Backend API)
- Port 5173 (Frontend Dev Server)
- Port 9000 (SonarQube)

### CORS Handling

The backend is pre-configured to accept requests from:
- `*.githubpreview.dev`
- `*.app.github.dev`

No additional configuration needed.

### Environment Variable Override

If you need to override the CORS settings in Codespaces:

```bash
export CORS_ALLOWED_ORIGINS="https://your-specific-codespace-url.app.github.dev"
cd backend
mvn spring-boot:run
```

## Docker Compose

### Default Ports

```yaml
backend:    8080 -> 8080
frontend:   80 -> 8090
sonarqube:  9000 -> 9000
```

### Override Configuration

Create `docker-compose.override.yml`:

```yaml
version: '3.8'

services:
  backend:
    environment:
      - CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173
    ports:
      - "8081:8080"
```

## Kubernetes Deployment

For K8s deployment, environment variables are configured in:
- `k8s/configmap.yaml` - Non-sensitive configuration
- K8s Secrets - Sensitive data (create manually)

Example ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  SPRING_PROFILES_ACTIVE: "prod"
  CORS_ALLOWED_ORIGINS: "*"
```

## Best Practices

1. **Never commit sensitive values** to version control
2. **Use .env files** for local development (add to .gitignore)
3. **Use GitHub Secrets** for CI/CD workflows
4. **Use ConfigMaps/Secrets** for Kubernetes deployments
5. **Document all required variables** in this file

## Troubleshooting

### CORS Errors

If you see CORS errors:
1. Check backend logs for CORS configuration
2. Verify the frontend URL is in allowed origins
3. Update `cors.allowed.origins` in `application.properties`

### API Connection Issues

If frontend can't connect to backend:
1. Verify backend is running: `curl http://localhost:8080/api/tasks`
2. Check VITE_API_URL in frontend
3. Check Vite proxy configuration in `vite.config.js`

### SonarQube Token Issues

If SonarQube analysis fails:
1. Verify SONAR_TOKEN is set correctly
2. Check SONAR_HOST_URL is accessible
3. Verify token hasn't expired in SonarQube admin panel
