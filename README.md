# Full Stack Demo: React + Vite + Spring Boot + Docker + Kubernetes + CI/CD

[![Backend CI/CD](https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces/actions/workflows/backend-ci.yml)
[![Frontend CI/CD](https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces/actions/workflows/frontend-ci.yml/badge.svg)](https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces/actions/workflows/frontend-ci.yml)

A complete demonstration repository showcasing modern full-stack development with:
- **Backend**: Java Spring Boot 3.2 with REST API
- **Frontend**: React 18 + Vite 5
- **Database**: H2 (in-memory for demo)
- **Containerization**: Docker & Docker Compose
- **Orchestration**: Kubernetes with Minikube
- **CI/CD**: GitHub Actions with manual dispatch support
- **Code Quality**: SonarQube (local and cloud)
- **Development**: GitHub Codespaces ready with CORS support

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Development](#development)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [GitHub Codespaces](#github-codespaces)
- [CI/CD Pipeline](#cicd-pipeline)
- [SonarQube Setup](#sonarqube-setup)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Contributing](#contributing)
- [Additional Documentation](#additional-documentation)

## ✨ Features

### Backend (Spring Boot)
- RESTful API with CRUD operations
- Spring Data JPA for database operations
- H2 in-memory database
- Input validation
- CORS configuration for GitHub Codespaces
- Comprehensive unit tests
- JaCoCo code coverage
- Maven build system

### Frontend (React + Vite)
- Modern React with Hooks
- Vite for fast development and builds
- Vite proxy for CORS-free development
- Axios for API communication
- Responsive UI design
- Task management interface
- Environment-based configuration

### DevOps
- Multi-stage Docker builds
- Docker Compose for local development (includes SonarQube)
- Kubernetes manifests for production
- GitHub Actions CI/CD pipelines with manual dispatch
- SonarQube integration (local and cloud support)
- Automated testing

## 🏗️ Architecture

```
┌─────────────────┐      ┌─────────────────┐
│  React Frontend │─────▶│  Spring Boot    │
│  (Vite + Nginx) │      │  Backend API    │
│  Port: 80       │◀─────│  Port: 8080     │
└─────────────────┘      └─────────────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │  H2 Database    │
                         │  (In-Memory)    │
                         └─────────────────┘
```

## 📦 Prerequisites

### For Local Development
- **Java**: JDK 17 or higher
- **Maven**: 3.8 or higher
- **Node.js**: 20.x or higher
- **npm**: 10.x or higher

### For Docker Deployment
- **Docker**: 20.x or higher
- **Docker Compose**: 2.x or higher

### For Kubernetes Deployment
- **kubectl**: Latest version
- **Minikube**: Latest version (for local K8s cluster)

### For GitHub Codespaces
- GitHub account with Codespaces access

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces.git
cd full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces

# Build and start services
docker-compose up --build

# Access the application
# Frontend: http://localhost:8090
# Backend API: http://localhost:8080/api/tasks
# Health: http://localhost:8080/api/health/status
```

### Option 2: Manual Setup

#### Backend
```bash
cd backend
mvn clean install
mvn spring-boot:run
# Backend runs on http://localhost:8080
```

#### Frontend
```bash
cd frontend
npm install
npm run dev
# Frontend runs on http://localhost:5173
```

## 💻 Development

### Backend Development

```bash
cd backend

# Run tests
mvn test

# Run with coverage
mvn clean test jacoco:report

# Build
mvn clean package

# Run locally
mvn spring-boot:run
```

### Frontend Development

```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint
npm run lint
```

## 🐳 Docker Deployment

### Build Individual Images

```bash
# Backend
docker build -t fullstack-backend:latest ./backend

# Frontend
docker build -t fullstack-frontend:latest ./frontend
```

### Using Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and start
docker-compose up --build
```

## ☸️ Kubernetes Deployment

### Setup Minikube

```bash
# Start Minikube
minikube start

# Enable metrics
minikube addons enable metrics-server

# Build images in Minikube's Docker environment
eval $(minikube docker-env)
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend
```

### Deploy to Kubernetes

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Apply configurations
kubectl apply -f k8s/configmap.yaml

# Deploy backend
kubectl apply -f k8s/backend-deployment.yaml

# Deploy frontend
kubectl apply -f k8s/frontend-deployment.yaml

# Check status
kubectl get pods
kubectl get services

# Access the application
minikube service frontend-service
```

### Useful Kubernetes Commands

```bash
# View pods
kubectl get pods

# View services
kubectl get services

# View logs
kubectl logs -f <pod-name>

# Scale deployment
kubectl scale deployment backend-deployment --replicas=3

# Delete resources
kubectl delete -f k8s/
```

## 🚀 GitHub Codespaces

This repository is fully configured for GitHub Codespaces. Simply:

1. Click the **Code** button on GitHub
2. Select **Codespaces** tab
3. Click **Create codespace on main**

The environment will automatically:
- Install Java 17 and Maven
- Install Node.js 20 and npm
- Setup Docker and Kubernetes tools
- Install VS Code extensions
- Build backend and install frontend dependencies

### Running in Codespaces

```bash
# Terminal 1: Start Backend
cd backend
mvn spring-boot:run

# Terminal 2: Start Frontend
cd frontend
npm run dev
```

Codespaces will automatically forward ports 8080 and 5173.

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows

1. **Backend CI/CD** (`.github/workflows/backend-ci.yml`)
   - Builds Maven project
   - Runs unit tests
   - Generates code coverage
   - Performs SonarQube analysis (if token provided)
   - Builds Docker image
   - **Manual dispatch enabled** - Run workflows manually from GitHub Actions tab

2. **Frontend CI/CD** (`.github/workflows/frontend-ci.yml`)
   - Installs dependencies
   - Runs linting
   - Builds production bundle
   - Performs SonarQube analysis (if token provided)
   - Builds Docker image
   - **Manual dispatch enabled** - Run workflows manually from GitHub Actions tab

3. **Integration Tests** (`.github/workflows/integration-test.yml`)
   - Tests backend API
   - Builds with Docker Compose
   - Tests full stack integration
   - **Manual dispatch enabled** - Run workflows manually from GitHub Actions tab

### Manual Workflow Dispatch

All workflows now support manual triggering:

1. Go to **Actions** tab in your GitHub repository
2. Select the workflow you want to run
3. Click **Run workflow** button
4. Choose the branch
5. Click **Run workflow**

### Setting up SonarQube

The workflows support both local SonarQube and SonarCloud:

- If `SONAR_TOKEN` is not set, SonarQube analysis is gracefully skipped
- No workflow failures if token is missing
- Perfect for local development and testing

For production setup, see [SonarQube Setup](#sonarqube-setup) section below.

## 🔍 SonarQube Setup

### Local SonarQube Instance

1. **Start SonarQube**:
```bash
docker-compose up -d sonarqube
```

2. **Run Setup Script**:
```bash
./scripts/setup-sonarqube.sh
```

This will:
- Configure SonarQube admin account
- Create projects for backend and frontend
- Generate authentication tokens
- Display all necessary configuration

3. **Access SonarQube**:
- URL: http://localhost:9000
- Username: `admin`
- Password: `Admin@123456` (set by `./scripts/setup-sonarqube.sh`)

### GitHub Actions Integration (Optional)

If you want to use SonarQube in CI/CD:

1. Add GitHub Secrets (Settings > Secrets and variables > Actions):
   - `SONAR_TOKEN`: Token from setup script
   - `SONAR_HOST_URL`: http://your-sonarqube-server:9000

2. Workflows will automatically use these secrets when available
3. If not set, SonarQube analysis is skipped (no failures)

### Local Code Analysis

**Backend**:
```bash
cd backend
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=alyasilpiah_full-stack-demo-backend \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_TOKEN
```

**Frontend**:
```bash
cd frontend
sonar-scanner \
  -Dsonar.projectKey=alyasilpiah_full-stack-demo-frontend \
  -Dsonar.sources=src \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_TOKEN
```

For detailed instructions, see [docs/SONARQUBE.md](docs/SONARQUBE.md)

## 📚 API Documentation

### Task API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | Get all tasks (seeded by default) |
| GET | `/api/tasks?completed=true` | Get completed tasks |
| GET | `/api/tasks/{id}` | Get task by ID |
| POST | `/api/tasks` | Create new task |
| PUT | `/api/tasks/{id}` | Update task |
| DELETE | `/api/tasks/{id}` | Delete task |
| GET | `/api/health/status` | Health status |

### Request/Response Examples

#### Create Task
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Sample Task",
    "description": "Task description",
    "completed": false
  }'
```

#### Get All Tasks
```bash
curl http://localhost:8080/api/tasks
```

## 📁 Project Structure

```
.
├── backend/                    # Spring Boot Backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/demo/fullstack/
│   │   │   │   ├── controller/    # REST Controllers
│   │   │   │   ├── model/         # Entity Models
│   │   │   │   ├── repository/    # Data Repositories
│   │   │   │   ├── service/       # Business Logic
│   │   │   │   └── config/        # Configuration
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/                  # Unit Tests
│   ├── Dockerfile
│   └── pom.xml
│
├── frontend/                   # React Frontend
│   ├── src/
│   │   ├── components/        # React Components
│   │   ├── services/          # API Services
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
│
├── k8s/                       # Kubernetes Manifests
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── backend-deployment.yaml
│   └── frontend-deployment.yaml
│
├── .devcontainer/             # GitHub Codespaces Config
│   └── devcontainer.json
│
├── .github/
│   └── workflows/             # CI/CD Pipelines
│       ├── backend-ci.yml
│       ├── frontend-ci.yml
│       └── integration-test.yml
│
├── docker-compose.yml         # Docker Compose Config
└── README.md
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=TaskServiceTest

# Run with coverage report
mvn clean test jacoco:report

# View coverage report
open target/site/jacoco/index.html
```

### Frontend Tests

```bash
cd frontend

# Run tests (when configured)
npm test

# Lint check
npm run lint
```

## 📖 Learning Resources

This repository demonstrates:

1. **Monorepo Structure**: Backend and frontend in one repository
2. **RESTful API Design**: Best practices for REST APIs
3. **React Hooks**: Modern React patterns
4. **Spring Boot**: Enterprise Java development
5. **Docker Multi-stage Builds**: Optimized containerization
6. **Kubernetes Basics**: Container orchestration
7. **CI/CD with GitHub Actions**: Automated pipelines
8. **Infrastructure as Code**: Declarative configurations

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📚 Additional Documentation

Comprehensive guides available in the `docs/` folder:

- **[SONARQUBE.md](docs/SONARQUBE.md)** - Complete SonarQube setup and usage guide
- **[ENVIRONMENT.md](docs/ENVIRONMENT.md)** - Environment variables and configuration
- **[BACKEND.md](docs/BACKEND.md)** - Backend development guide
- **[FRONTEND.md](docs/FRONTEND.md)** - Frontend development guide
- **[DEPLOYMENT.md](docs/DEPLOYMENT.md)** - Deployment instructions
- **[CODESPACES.md](docs/CODESPACES.md)** - GitHub Codespaces setup
- **[QUICKSTART.md](docs/QUICKSTART.md)** - Quick start guide
- **[SUMMARY.md](docs/SUMMARY.md)** - Project summary

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Alya Silpiah** - [GitHub Profile](https://github.com/alyasilpiah)

## 🙏 Acknowledgments

- Spring Boot Team
- React Team
- Vite Team
- Kubernetes Community
- Docker Community

---

**Note**: This is a demonstration project for educational purposes. For production use, consider:
- Using a persistent database (PostgreSQL, MySQL, etc.)
- Implementing authentication and authorization
- Adding rate limiting and security headers
- Setting up proper logging and monitoring
- Implementing proper error handling
- Adding API documentation (Swagger/OpenAPI)
- Setting up HTTPS/TLS certificates
- Configuring proper SonarQube quality gates

## 🔧 Key Improvements in This Version

### ✅ Workflow Enhancements
- Added `workflow_dispatch` to all workflows for manual execution
- SonarQube analysis gracefully skips if token not provided
- Improved error handling and continue-on-error flags
- Support for local SonarQube instances

### ✅ CORS Configuration
- Enhanced backend CORS for GitHub Codespaces support
- Automatic support for `*.githubpreview.dev` and `*.app.github.dev`
- Configurable via environment variables
- Support for credentials and preflight requests

### ✅ Development Experience
- Vite proxy configured for seamless API calls
- Host binding enabled for Codespaces
- Proper port forwarding configuration
- Environment-specific configurations

### ✅ SonarQube Integration
- Local SonarQube instance in docker-compose
- Automated setup script with token generation
- Flexible configuration for local and cloud instances
- Comprehensive documentation

For complete setup instructions, see [docs/SONARQUBE.md](docs/SONARQUBE.md) and [docs/ENVIRONMENT.md](docs/ENVIRONMENT.md).
