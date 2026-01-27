# Student Tutorial: Fork, Codespaces, Docker Compose & Minikube

This tutorial walks you through forking the repository, creating your own Codespace, running the stack with Docker Compose, deploying to Minikube, and accessing the frontend from outside Codespaces.

## 1) Fork the Repository

1. Open the repository in GitHub.
2. Click **Fork** (top-right) and create a fork under your account.
3. Wait for the fork to finish, then open **your fork**.

## 2) Create a Codespace

1. In your fork, click **Code** → **Codespaces** → **Create codespace on main**.
2. Wait for the Codespace to finish setting up.

> Tip: The first build installs Java, Maven, Node, and dependencies.

## 3) Configure GitHub Actions Secrets (Required for SonarQube)

Your fork does not have access to the original repository secrets. Add your own:

1. In your fork, go to **Settings** → **Secrets and variables** → **Actions**.
2. Click **New repository secret**.
3. Add:
   - `SONAR_TOKEN`: your token from SonarQube (required for analysis)
   - `SONAR_HOST_URL`: your SonarQube server URL (example: `http://localhost:9000`)

If you skip this, the SonarQube steps will be skipped in workflows.

## 4) Run with Docker Compose (Codespaces or Local)

From the repository root:

```bash
docker compose up -d --build
```

### Verify services

```bash
docker compose ps
```

### Access the app

- Frontend (Docker): **http://localhost:8000**
- Backend API: **http://localhost:8080/api/tasks**
- Health endpoint: **http://localhost:8080/api/health/status**

If you are in Codespaces, use the **Ports** tab to open the forwarded URL for port **8000**.

## 5) Deploy to Minikube (Kubernetes)

### Start Minikube

```bash
minikube start
```

### Build images inside Minikube

```bash
eval $(minikube docker-env)
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend
```

### Deploy manifests

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
```

### Verify pods

```bash
kubectl get pods -n fullstack
```

## 6) Access the Minikube Deployment

The frontend service is a NodePort (30080).

### Option A: Use minikube service (recommended)

```bash
minikube service frontend-service -n fullstack
```

This opens the frontend in your browser.

### Option B: Access via Minikube IP

```bash
minikube ip
```

Open:

```
http://<MINIKUBE_IP>:30080
```

### Confirm the frontend

You should see the task UI. Create a task and verify it appears in the list.

## 7) Clean Up

```bash
kubectl delete -f k8s/
docker compose down
minikube stop
```
