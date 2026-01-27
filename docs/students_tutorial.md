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

### Expected output

```
CONTAINER ID   IMAGE                      COMMAND                  STATUS        PORTS
abc123...      fullstack-backend:latest   "java -jar ..."          Up 2 minutes   8080/tcp
def456...      fullstack-frontend:latest  "nginx -g ..."           Up 2 minutes   0.0.0.0:8000->8000/tcp
```

### Access the app (Docker Compose)

- Frontend: Open the **Ports** tab → click port **8000**
- Backend API: `http://localhost:8080/api/tasks`
- Health check: `http://localhost:8080/api/health/status`

### Test the frontend

1. Click the port **8000** link to open frontend in Codespaces
2. Type a task name and click **Add Task**
3. Verify the task appears in the list
4. Try editing and deleting tasks

✅ **Docker Compose uses `localhost` (no CORS issues)**

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

### Verify pods are running

```bash
kubectl get pods -n fullstack
```

### Expected output

```
NAME                                    READY   STATUS    RESTARTS   AGE
backend-deployment-abc123...            1/1     Running   0          2m
frontend-deployment-def456...           1/1     Running   0          2m
```

### Check services

```bash
kubectl get svc -n fullstack
```

### Expected output

```
NAME                TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)
backend-service     ClusterIP  10.96.123.45    <none>        8080/TCP
frontend-service    NodePort   10.96.234.56    <none>        8000:30080/TCP
```

## Step 5A: Access Minikube Dashboard (Kubernetes UI)

The Minikube dashboard provides a web-based UI to monitor and manage your Kubernetes cluster. This is especially useful for visualizing pods, services, deployments, and logs.

### Enable the Dashboard Addon

First, enable the dashboard addon if it's not already enabled:

```bash
minikube addons enable dashboard
```

### Start the Dashboard

Start the Kubernetes dashboard with the following command:

```bash
minikube dashboard --url
```

This command will:
- Start the dashboard service
- Output a URL like: `http://127.0.0.1:XXXXX/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/`

> **Note**: The dashboard runs on a random port (e.g., `42523`, `35789`). Keep the terminal running - don't close it!

### Access Dashboard in GitHub Codespaces

Since the dashboard runs on `localhost` inside your Codespace, you need to forward the port to access it from your browser.

#### Method 1: Automatic Port Forwarding (Recommended)

1. When you run `minikube dashboard --url`, note the port number from the URL (e.g., if URL is `http://127.0.0.1:42523/...`, the port is `42523`)
2. GitHub Codespaces will automatically detect the port
3. Go to the **Ports** tab in VS Code (bottom panel)
4. Find the port number used by the dashboard
5. Click the **globe icon** 🌐 or copy the **Forwarded Address** to open it in your browser

#### Method 2: Manual Port Forwarding

If automatic detection doesn't work:

1. In the **Ports** tab, click **Add Port**
2. Enter the port number shown in the dashboard URL
3. Set visibility to **Private** (default)
4. Click the globe icon to open in browser

#### Method 3: Using kubectl Port Forward

Alternatively, you can use `kubectl` to create a more predictable port forward:

```bash
# Forward dashboard to port 8001 (or any free port)
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8001:80
```

Then access via the Codespace forwarded URL for port `8001`.

### Accessing the Dashboard URL

Once port forwarding is set up, you'll access the dashboard using your Codespace's URL:

**Example URL format:**
```
https://vigilant-space-barnacle-xxxxx-42523.app.github.dev/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

Replace `xxxxx-42523` with your actual Codespace identifier and port number.

### What You'll See in the Dashboard

The Kubernetes dashboard provides several views:

#### 1. **Cluster Overview**
   - Total resources (nodes, namespaces, deployments, pods)
   - Resource usage graphs (CPU, memory)

#### 2. **Namespace View** (Select "fullstack" namespace)
   - Workloads:
     - **Deployments**: `backend-deployment`, `frontend-deployment`
     - **Pods**: Running instances with status (Running, Pending, Error)
     - **Replica Sets**: Ensures desired number of pods
   
#### 3. **Service Details**
   - **Services** tab shows:
     - `backend-service` (ClusterIP) - Internal communication
     - `frontend-service` (NodePort) - External access via port 30080
   - Click any service to see:
     - Cluster IP address
     - Ports and target ports
     - Endpoints (pod IPs)
     - Labels and selectors

#### 4. **Pod Details**
   - Click any pod to see:
     - Container status and restart count
     - Logs (view container logs directly)
     - Events (deployment history, errors)
     - Resource usage (CPU, memory)
     - Environment variables and volumes

#### 5. **Config and Storage**
   - **ConfigMaps**: View `app-config` with environment variables
   - **Secrets**: Kubernetes secrets (if any)
   - **Persistent Volumes**: Storage resources

### Useful Dashboard Features

#### View Pod Logs
1. Navigate to **Workloads** → **Pods**
2. Select namespace: `fullstack`
3. Click on a pod name (e.g., `backend-deployment-abc123...`)
4. Click **Logs** button (top-right)
5. View real-time logs from your application

#### Restart a Deployment
1. Go to **Workloads** → **Deployments**
2. Select `backend-deployment` or `frontend-deployment`
3. Click menu (⋮) → **Restart**

#### Check Resource Usage
1. Go to **Cluster** → **Nodes**
2. See CPU and memory usage for the Minikube node
3. Drill down to see per-pod resource consumption

### Troubleshooting Dashboard Access

#### Dashboard won't start
```bash
# Check if dashboard addon is enabled
minikube addons list | grep dashboard

# Enable if needed
minikube addons enable dashboard

# Check dashboard pods
kubectl get pods -n kubernetes-dashboard
```

#### Port forwarding not working
```bash
# List all forwarded ports
kubectl port-forward -h

# Kill any existing port-forward processes
pkill -f "port-forward"

# Try with a different port
minikube dashboard --url
# Then forward the new port in Codespaces
```

#### Can't access via Codespace URL
1. Verify the port is forwarded in the **Ports** tab
2. Check port visibility is set correctly (Private/Public)
3. Ensure you're using the correct Codespace URL with the right port
4. Try refreshing the browser or opening in incognito mode

#### Dashboard shows "Forbidden" error
```bash
# Check dashboard service account permissions
kubectl get serviceaccount -n kubernetes-dashboard
kubectl get clusterrolebinding -n kubernetes-dashboard

# Restart dashboard
minikube dashboard --url
```

### Keep Dashboard Running

> **Important**: The `minikube dashboard --url` command must remain running in your terminal. If you close that terminal, the dashboard will stop.

**Best practice**: Run the dashboard in a separate terminal tab so you can continue working in other terminals.

```bash
# Terminal 1: Dashboard (keep running)
minikube dashboard --url

# Terminal 2: Your regular kubectl commands
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

## Step 7A: Accessing Frontend via Kubernetes (In Codespaces)

Once deployed to Minikube, you can access the frontend directly in Codespaces using port forwarding:

### Port forward to frontend

```bash
kubectl port-forward svc/frontend-service 8000:8000 -n fullstack
```

### Access in Codespaces

Open the **Ports** tab in your Codespace and click the URL for port **8000**.

> The frontend now connects to the backend through the nginx proxy inside the pod, which routes `/api` requests to the backend service.

### Expected behavior

✅ GET `/api/tasks` - Retrieves task list  
✅ POST `/api/tasks` - Creates new task  
✅ PUT `/api/tasks/{id}` - Updates task  
✅ DELETE `/api/tasks/{id}` - Deletes task  

If you see **403 Forbidden** errors, ensure the CORS configuration is correct:

- **Backend**: `application.properties` uses `cors.allowed.origin.patterns`
- **Frontend**: `nginx.conf` handles `OPTIONS` preflight requests
- **WebConfig.java**: Uses `.allowedOriginPatterns()` with wildcard support

### Example task creation flow

1. Open frontend at `https://vigilant-barnacle-xxxx-8000.app.github.dev` (your Codespace URL)
2. Type task name: "Learn Kubernetes"
3. Click **Add Task**
4. Browser sends `OPTIONS` request (preflight) → nginx responds ✅
5. Browser sends `POST` request → backend creates task ✅
6. Task appears in list

---

## Step 8: Clean Up (Optional)

### Delete all Kubernetes resources

```bash
kubectl delete -f k8s/
```

### Expected output

```bash
deployment.apps "backend-deployment" deleted from fullstack namespace
service "backend-service" deleted from fullstack namespace
configmap "app-config" deleted from fullstack namespace
deployment.apps "frontend-deployment" deleted from fullstack namespace
service "frontend-service" deleted from fullstack namespace
namespace "fullstack" deleted
```

### Stop Docker Compose and Minikube

```bash
docker compose down
minikube stop
```

---

## Debugging Backend Service

### Check if backend pod is running

```bash
kubectl get pods -n fullstack -l app=backend
```

### Port-forward to backend directly (for testing)

```bash
kubectl port-forward svc/backend-service 8080:8080 -n fullstack
```

Then test the API from your terminal:

```bash
# Test GET request
curl http://localhost:8080/api/tasks

# Test health check
curl http://localhost:8080/api/health/status
```

### Execute commands inside backend pod

Get the backend pod name:

```bash
kubectl get pods -n fullstack -l app=backend -o jsonpath='{.items[0].metadata.name}'
```

Then execute commands:

```bash
# Example pod name: backend-deployment-abc123def
BACKEND_POD=$(kubectl get pods -n fullstack -l app=backend -o jsonpath='{.items[0].metadata.name}')

# Check logs
kubectl logs -n fullstack $BACKEND_POD

# Follow logs (tail -f style)
kubectl logs -n fullstack $BACKEND_POD -f

# Check Java version inside pod
kubectl exec -it -n fullstack $BACKEND_POD -- java -version

# Check if Spring Boot is listening on port 8080
kubectl exec -n fullstack $BACKEND_POD -- netstat -tlnp | grep 8080

# Test API from inside pod
kubectl exec -n fullstack $BACKEND_POD -- curl -s http://localhost:8080/api/tasks | jq
```

### Expose backend service to localhost

Option 1: Use NodePort (temporary):

```bash
kubectl expose service backend-service -n fullstack --type=NodePort --name=backend-exposed --port=8080
kubectl port-forward svc/backend-exposed 8080:8080 -n fullstack
```

Option 2: Direct service access from frontend pod:

```bash
# Get frontend pod name
FRONTEND_POD=$(kubectl get pods -n fullstack -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Test backend connectivity from frontend pod
kubectl exec -it -n fullstack $FRONTEND_POD -- curl -s http://backend-service:8080/api/tasks | jq
```

### Verify DNS resolution inside frontend pod

```bash
FRONTEND_POD=$(kubectl get pods -n fullstack -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Resolve backend-service hostname
kubectl exec -n fullstack $FRONTEND_POD -- nslookup backend-service

# Ping backend service
kubectl exec -n fullstack $FRONTEND_POD -- ping -c 3 backend-service
```

### Check backend service endpoints

```bash
kubectl get endpoints -n fullstack backend-service

# Detailed view
kubectl describe svc backend-service -n fullstack
```

### Check nginx configuration in frontend pod

```bash
FRONTEND_POD=$(kubectl get pods -n fullstack -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# View nginx config
kubectl exec -n fullstack $FRONTEND_POD -- cat /etc/nginx/conf.d/default.conf

# Test nginx connectivity to backend
kubectl exec -n fullstack $FRONTEND_POD -- curl -v http://backend-service:8080/api/tasks
```

---

## Troubleshooting

### Frontend shows "Cannot reach backend"

**Cause**: CORS mismatch or proxy misconfiguration

**Debugging steps**:
1. Verify backend is running: `kubectl get pods -n fullstack -l app=backend`
2. Port-forward and test directly: `kubectl port-forward svc/backend-service 8080:8080 -n fullstack`
3. Check backend logs: `kubectl logs -n fullstack deployment/backend`
4. Test from frontend pod: `kubectl exec -it -n fullstack <frontend-pod> -- curl http://backend-service:8080/api/tasks`
5. Verify nginx proxy config: `kubectl exec -it -n fullstack <frontend-pod> -- cat /etc/nginx/conf.d/default.conf`

### POST requests return 403 Forbidden

**Cause**: OPTIONS preflight request rejected

**Fix**:
1. Ensure `nginx.conf` includes OPTIONS handler
2. Restart frontend: `kubectl rollout restart deployment frontend -n fullstack`
3. Check nginx logs: `kubectl logs -n fullstack deployment/frontend`

### Port forwarding not working

**Solution**:
```bash
# Stop existing port-forward
pkill port-forward

# Try again
kubectl port-forward svc/frontend-service 8000:8000 -n fullstack
```

### Services not accessible

**Solution**:
```bash
# Check services exist
kubectl get svc -n fullstack

# Check endpoints
kubectl get endpoints -n fullstack

# Describe service for details
kubectl describe svc frontend-service -n fullstack
```