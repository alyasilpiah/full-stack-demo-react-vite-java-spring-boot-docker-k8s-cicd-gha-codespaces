# Students Tutorial: Forking, Codespaces, Docker Compose, and Minikube

This tutorial is designed for students. It explains how to fork the repository, create your own Codespace, run the app with Docker Compose, deploy to Minikube, and access the frontend from outside Codespaces.

## Step 1: Create a Fork of the Repository

**Repository to fork:**  
`<your-org-or-user>/full-stack-demo-react-vite-java-spring-boot-docker-k8s-cicd-gha-codespaces`

### What is a fork?
A fork is your own copy of a GitHub repository. It lets you experiment or make changes without affecting the original project. This is useful for assignments, labs, and learning.

### Why use a fork?
- You get your own workspace to practice safely.
- You can run GitHub Actions with your own secrets.
- You can create your own branches, commits, and pull requests.

### How to fork
1. Open the repository on GitHub.
2. Click **Fork** (top-right).
3. Select your GitHub account.
4. Wait for your fork to appear under your account.

## Step 2: Create Your Codespace

1. Open your **forked repository**.
2. Click **Code** → **Codespaces** → **Create codespace on main**.
3. Wait for the environment to finish setup.

> Codespaces automatically installs Java, Maven, Node, Docker, and Kubernetes tools.

## Step 3: Add GitHub Actions Secrets (SONAR_TOKEN)

Your fork does **not** have access to secrets from the original repo, so you must add your own.

1. In your fork, go to **Settings** → **Secrets and variables** → **Actions**.
2. Click **New repository secret**.
3. Add:
   - `SONAR_TOKEN` (from your SonarQube server)
   - `SONAR_HOST_URL` (for example: `http://localhost:9000`)

If you don’t set these, SonarQube steps are skipped in the workflows.

## Step 4: Run the App with Docker Compose

From the repo root in your Codespace:

```bash
docker compose up -d --build
```

### Check services

```bash
docker compose ps
```

### Access the app

- Frontend: **http://localhost:8000**
- Backend API: **http://localhost:8080/api/tasks**
- Health check: **http://localhost:8080/api/health/status**

In Codespaces, open the **Ports** tab and click the URL for port **8000**.

## Step 5: Deploy to Minikube (Kubernetes)

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

### Apply Kubernetes manifests

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

## Step 6: Access the Frontend Outside Codespaces

The frontend service uses NodePort **30080**.

### Option A: Use minikube service

```bash
minikube service frontend-service -n fullstack
```

### Option B: Use the Minikube IP

```bash
minikube ip
```

Open:

```
http://<MINIKUBE_IP>:30080
```

### Confirm the frontend works

Create a task in the UI and verify it shows in the list.

## Step 7: Clean Up (Optional)

```bash
kubectl delete -f k8s/
docker compose down
minikube stop
```