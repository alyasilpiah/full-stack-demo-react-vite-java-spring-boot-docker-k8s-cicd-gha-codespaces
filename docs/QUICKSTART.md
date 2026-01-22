# Quick Start Guide

Get the Full Stack Demo up and running in minutes!

## Option 1: Docker Compose (Easiest)

Perfect for quickly running the complete application with both frontend and backend.

```bash
# Clone the repository
git clone https://github.com/alyasilpiah/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces.git
cd full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces

# Start with Docker Compose
docker-compose up --build

# Access the application
# Frontend: http://localhost
# Backend API: http://localhost:8080/api/tasks
```

To stop:
```bash
docker-compose down
```

## Option 2: Helper Scripts (Recommended for Development)

Use the provided scripts for easy local development.

### Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 20+
- npm 10+

### Start Application
```bash
./scripts/start-app.sh
```

This script will:
1. Check prerequisites
2. Build the backend
3. Install frontend dependencies
4. Start backend on port 8080
5. Start frontend on port 5173
6. Display application URLs

### Stop Application
```bash
./scripts/stop-app.sh
```

## Option 3: Manual Setup

### Terminal 1: Backend
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend will be available at: http://localhost:8080

### Terminal 2: Frontend
```bash
cd frontend
npm install
npm run dev
```

Frontend will be available at: http://localhost:5173

## Option 4: GitHub Codespaces (No Local Setup Required!)

1. Go to the GitHub repository
2. Click **Code** → **Codespaces**
3. Click **Create codespace on main**
4. Wait for the environment to setup (2-3 minutes)
5. In the terminal:
   ```bash
   # Terminal 1: Backend
   cd backend
   mvn spring-boot:run
   
   # Terminal 2: Frontend (open new terminal)
   cd frontend
   npm run dev
   ```

Ports will be automatically forwarded. Click the **Ports** tab to access the application.

## Accessing the Application

Once running, you can access:

- **Frontend**: http://localhost:5173 (or http://localhost if using Docker Compose)
- **Backend API**: http://localhost:8080/api/tasks
- **H2 Console**: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:testdb`
  - Username: `sa`
  - Password: (leave empty)

## First Steps

### Try the API

Create a task:
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Task",
    "description": "Testing the API",
    "completed": false
  }'
```

Get all tasks:
```bash
curl http://localhost:8080/api/tasks
```

### Use the Frontend

1. Open http://localhost:5173 in your browser
2. Enter a task title and description
3. Click "Add Task"
4. Check/uncheck tasks to mark as complete
5. Delete tasks using the delete button

## Kubernetes Deployment

### With Helper Script

```bash
# Make sure Minikube is installed
minikube start

# Deploy everything
./scripts/deploy-k8s.sh

# Access the application
minikube service frontend-service
```

### Manual Deployment

```bash
# Start Minikube
minikube start

# Build images for Minikube
eval $(minikube docker-env)
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend

# Deploy
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

# Access
minikube service frontend-service
```

## Building Docker Images

### Using Helper Script

```bash
./scripts/build-images.sh
```

### Manual Build

```bash
# Backend
docker build -t fullstack-backend:latest ./backend

# Frontend
docker build -t fullstack-frontend:latest ./frontend
```

## Common Issues

### Port Already in Use

If port 8080 or 5173 is already in use:

```bash
# Find and kill the process
lsof -i :8080
kill -9 <PID>

# Or change ports
# Backend: Edit backend/src/main/resources/application.properties
# Frontend: Edit frontend/vite.config.js
```

### Maven Build Fails

```bash
cd backend
mvn clean install -U
```

### Node Modules Issues

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### Docker Issues

```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

## Running Tests

### Backend Tests
```bash
cd backend
mvn test
```

### Frontend Build Test
```bash
cd frontend
npm run build
```

## What's Next?

1. **Explore the Code**: Check out the well-documented source code
2. **Read Documentation**: See `docs/` folder for detailed guides
3. **Modify and Experiment**: Make changes and see them live
4. **Deploy to Cloud**: Try deploying to AWS, GCP, or Azure
5. **Add Features**: Extend the application with your own ideas

## Need Help?

- **Documentation**: Check the `docs/` folder
- **Issues**: Open an issue on GitHub
- **Backend Guide**: `docs/BACKEND.md`
- **Frontend Guide**: `docs/FRONTEND.md`
- **Deployment Guide**: `docs/DEPLOYMENT.md`
- **Codespaces Guide**: `docs/CODESPACES.md`

## Tips for Learning

- Start with Docker Compose for the easiest experience
- Use helper scripts for development
- Explore the codebase in your IDE
- Try modifying the UI or API
- Deploy to Kubernetes to learn orchestration
- Review the CI/CD workflows in `.github/workflows/`

---

Happy Coding! 🚀
