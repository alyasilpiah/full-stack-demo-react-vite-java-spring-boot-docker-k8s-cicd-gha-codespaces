# Deployment Guide

Complete guide for deploying the Full Stack Demo application to various environments.

## Table of Contents
- [Local Development](#local-development)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Cloud Deployment](#cloud-deployment)
- [CI/CD Setup](#cicd-setup)

## Local Development

### Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 20+
- npm 10+

### Backend Setup
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend runs on `http://localhost:8080`

### Frontend Setup
```bash
cd frontend
npm install
npm run dev
```

Frontend runs on `http://localhost:5173`

## Docker Deployment

### Using Docker Compose (Recommended)

#### Step 1: Build and Start
```bash
docker compose up --build -d
```

#### Step 2: Verify Services
```bash
docker compose ps
docker compose logs -f
```

#### Step 3: Access Application
- Frontend: http://localhost:8000
- Backend API: http://localhost:8080

#### Stop Services
```bash
docker compose down
```

#### Cleanup
```bash
docker compose down -v
docker system prune -a
```

### Individual Docker Containers

#### Build Images
```bash
# Backend
cd backend
docker build -t fullstack-backend:latest .

# Frontend
cd frontend
docker build -t fullstack-frontend:latest .
```

#### Run Containers
```bash
# Create network
docker network create fullstack-network

# Run backend
docker run -d \
  --name backend \
  --network fullstack-network \
  -p 8080:8080 \
  fullstack-backend:latest

# Run frontend
docker run -d \
  --name frontend \
  --network fullstack-network \
  -p 8000:8000 \
  fullstack-frontend:latest
```

## Kubernetes Deployment

### Prerequisites
- kubectl installed
- Minikube (for local) or cloud K8s cluster
- Docker images built

### Local Kubernetes with Minikube

#### Step 1: Start Minikube
```bash
minikube start --cpus=4 --memory=8192
minikube addons enable ingress
minikube addons enable metrics-server
```

#### Step 2: Build Images in Minikube
```bash
# Point Docker to Minikube's Docker daemon
eval $(minikube docker-env)

# Build images
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend
```

#### Step 3: Deploy to Kubernetes
```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Apply ConfigMap
kubectl apply -f k8s/configmap.yaml

# Deploy Backend
kubectl apply -f k8s/backend-deployment.yaml

# Deploy Frontend
kubectl apply -f k8s/frontend-deployment.yaml
```

#### Step 4: Verify Deployment
```bash
# Check pods
kubectl get pods

# Check services
kubectl get services

# Check deployments
kubectl get deployments

# View logs
kubectl logs -f deployment/backend-deployment
kubectl logs -f deployment/frontend-deployment
```

#### Step 5: Access Application
```bash
# Get frontend service URL
minikube service frontend-service

# Or use port forwarding
kubectl port-forward service/frontend-service 8081:80
kubectl port-forward service/backend-service 8080:8080
```

#### Useful Commands
```bash
# Scale deployment
kubectl scale deployment backend-deployment --replicas=3

# Update deployment
kubectl set image deployment/backend-deployment backend=fullstack-backend:v2

# Rollback deployment
kubectl rollout undo deployment/backend-deployment

# View deployment history
kubectl rollout history deployment/backend-deployment

# Delete all resources
kubectl delete -f k8s/
```

### Production Kubernetes

#### Using Helm (Recommended)

Create Helm chart structure:
```bash
helm create fullstack-demo
```

#### Deploy with Helm
```bash
# Install
helm install fullstack-demo ./helm/fullstack-demo

# Upgrade
helm upgrade fullstack-demo ./helm/fullstack-demo

# Uninstall
helm uninstall fullstack-demo
```

## Cloud Deployment

### AWS (EKS)

#### Prerequisites
- AWS CLI configured
- eksctl installed
- kubectl installed

#### Create EKS Cluster
```bash
eksctl create cluster \
  --name fullstack-demo \
  --region us-east-1 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3
```

#### Push Images to ECR
```bash
# Create repositories
aws ecr create-repository --repository-name fullstack-backend
aws ecr create-repository --repository-name fullstack-frontend

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Tag images
docker tag fullstack-backend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/fullstack-backend:latest
docker tag fullstack-frontend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/fullstack-frontend:latest

# Push images
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/fullstack-backend:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/fullstack-frontend:latest
```

#### Deploy to EKS
```bash
# Update kubeconfig
aws eks update-kubeconfig --name fullstack-demo --region us-east-1

# Deploy
kubectl apply -f k8s/
```

### Google Cloud (GKE)

#### Create GKE Cluster
```bash
gcloud container clusters create fullstack-demo \
  --num-nodes=3 \
  --machine-type=n1-standard-2 \
  --zone=us-central1-a
```

#### Push to GCR
```bash
# Tag images
docker tag fullstack-backend:latest gcr.io/<project-id>/fullstack-backend:latest
docker tag fullstack-frontend:latest gcr.io/<project-id>/fullstack-frontend:latest

# Push images
docker push gcr.io/<project-id>/fullstack-backend:latest
docker push gcr.io/<project-id>/fullstack-frontend:latest
```

#### Deploy to GKE
```bash
# Get credentials
gcloud container clusters get-credentials fullstack-demo --zone=us-central1-a

# Deploy
kubectl apply -f k8s/
```

### Azure (AKS)

#### Create AKS Cluster
```bash
az aks create \
  --resource-group fullstack-demo-rg \
  --name fullstack-demo \
  --node-count 3 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

#### Push to ACR
```bash
# Create registry
az acr create --resource-group fullstack-demo-rg --name fullstackdemoacr --sku Basic

# Login to ACR
az acr login --name fullstackdemoacr

# Tag and push
docker tag fullstack-backend:latest fullstackdemoacr.azurecr.io/fullstack-backend:latest
docker push fullstackdemoacr.azurecr.io/fullstack-backend:latest
```

## CI/CD Setup

### GitHub Actions

Workflows are already configured in `.github/workflows/`

#### Required Secrets

Add these secrets in GitHub repository settings:

1. **DOCKER_USERNAME**: Docker Hub username
2. **DOCKER_PASSWORD**: Docker Hub password/token
3. **SONAR_TOKEN**: SonarCloud token
4. **KUBE_CONFIG**: Kubernetes config (for deployment)

#### Workflow Triggers

- **Push to main**: Full build, test, and deploy
- **Pull Request**: Build and test only
- **Manual**: workflow_dispatch event

### GitLab CI/CD

Create `.gitlab-ci.yml`:
```yaml
stages:
  - build
  - test
  - deploy

build-backend:
  stage: build
  script:
    - cd backend
    - mvn clean package

test-backend:
  stage: test
  script:
    - cd backend
    - mvn test

deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/
  only:
    - main
```

## Monitoring and Logging

### Prometheus + Grafana

```bash
# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack

# Access Grafana
kubectl port-forward svc/prometheus-grafana 8000:80
```

### ELK Stack

```bash
# Install Elasticsearch
kubectl apply -f https://download.elastic.co/downloads/eck/2.10.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.10.0/operator.yaml

# Deploy Elasticsearch and Kibana
kubectl apply -f elk/elasticsearch.yaml
kubectl apply -f elk/kibana.yaml
```

## Database Migration

For production, replace H2 with a persistent database:

### PostgreSQL

Update `application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/fullstack
spring.datasource.username=postgres
spring.datasource.password=password
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

### MySQL

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/fullstack
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
```

## Security Considerations

### Production Checklist

- [ ] Use HTTPS/TLS certificates
- [ ] Implement authentication (JWT, OAuth2)
- [ ] Add rate limiting
- [ ] Enable CORS properly
- [ ] Use secrets management (Vault, AWS Secrets Manager)
- [ ] Implement network policies
- [ ] Use persistent storage
- [ ] Set resource limits
- [ ] Enable Pod Security Policies
- [ ] Regular security updates

### Secrets Management

```bash
# Create Kubernetes secrets
kubectl create secret generic app-secrets \
  --from-literal=db-password=secretpassword \
  --from-literal=api-key=secretkey

# Use in deployment
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: app-secrets
        key: db-password
```

## Backup and Recovery

### Database Backup

```bash
# PostgreSQL
kubectl exec -it <postgres-pod> -- pg_dump -U postgres fullstack > backup.sql

# MySQL
kubectl exec -it <mysql-pod> -- mysqldump -u root -p fullstack > backup.sql
```

### Kubernetes State Backup

```bash
# Backup using Velero
velero backup create fullstack-backup --include-namespaces fullstack-demo

# Restore
velero restore create --from-backup fullstack-backup
```

## Troubleshooting

### Common Issues

#### Pods Not Starting
```bash
# Check pod status
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

#### Service Not Accessible
```bash
# Check service
kubectl describe service <service-name>

# Check endpoints
kubectl get endpoints

# Test from another pod
kubectl run -it --rm debug --image=busybox --restart=Never -- wget -O- http://backend-service:8080/api/tasks
```

#### Image Pull Errors
```bash
# Check image pull secrets
kubectl get secrets

# Create docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<username> \
  --docker-password=<password>
```

## Performance Tuning

### Backend Optimization
- Increase JVM heap size
- Enable G1GC garbage collector
- Use connection pooling
- Implement caching (Redis)

### Frontend Optimization
- Enable Nginx gzip compression
- Use CDN for static assets
- Implement browser caching
- Code splitting

### Kubernetes Optimization
- Set proper resource limits
- Use Horizontal Pod Autoscaler
- Implement readiness/liveness probes
- Use node affinity/anti-affinity

## Cost Optimization

### Cloud Cost Savings
- Use spot instances for non-production
- Right-size your resources
- Enable cluster autoscaling
- Use reserved instances for production
- Implement resource quotas

### Monitoring Costs
```bash
# Set resource quotas
kubectl create quota compute-quota \
  --hard=requests.cpu=4,requests.memory=8Gi
```

## Support and Documentation

- **GitHub Issues**: Report bugs and request features
- **Documentation**: Check docs/ folder
- **Community**: Join discussions
- **Updates**: Watch repository for updates

---

For questions or issues, please open an issue on GitHub.
