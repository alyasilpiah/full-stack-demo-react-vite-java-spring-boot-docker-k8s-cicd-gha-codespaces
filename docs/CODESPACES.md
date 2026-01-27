# GitHub Codespaces Guide

## Quick Start with GitHub Codespaces

GitHub Codespaces provides a complete development environment in the cloud. This project is fully configured to work seamlessly with Codespaces.

## Creating a Codespace

### Method 1: From GitHub Repository
1. Navigate to the repository on GitHub
2. Click the **Code** button
3. Select the **Codespaces** tab
4. Click **Create codespace on main**

### Method 2: From VS Code
1. Install "GitHub Codespaces" extension
2. Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P)
3. Type "Codespaces: Create New Codespace"
4. Select this repository

## Codespace Configuration

### Included Tools

The Codespace comes pre-configured with:

#### Development Tools
- **Java 17** with Maven
- **Node.js 20** with npm
- **Docker** (Docker-in-Docker)
- **kubectl** for Kubernetes
- **Minikube** for local K8s cluster
- **Helm** for K8s package management

#### VS Code Extensions
- Java Extension Pack
- Spring Boot Dashboard
- Spring Boot Tools
- Prettier (Code Formatter)
- ESLint (JavaScript Linter)
- Docker
- Kubernetes Tools
- GitHub Actions

### Port Forwarding

Ports are automatically forwarded:
- **5173**: Vite Development Server (Frontend)
- **8080**: Spring Boot Backend API
- **8000**: Frontend Docker (Nginx)

## First Time Setup

When you create a new Codespace:

1. **Automatic Setup** runs:
   ```bash
   cd backend && mvn clean install -DskipTests
   cd ../frontend && npm install
   ```

2. **Wait for completion** (2-3 minutes)

3. **Check setup status** in the terminal

## Running the Application

### Option 1: Separate Terminals

#### Terminal 1: Backend
```bash
cd backend
mvn spring-boot:run
```

Wait for "Started FullStackApplication" message.

#### Terminal 2: Frontend
```bash
cd frontend
npm run dev
```

### Option 2: Background Processes

```bash
# Start backend in background
cd backend
nohup mvn spring-boot:run > backend.log 2>&1 &

# Start frontend
cd frontend
npm run dev
```

## Accessing the Application

### Automatic Port Forwarding
- GitHub automatically detects and forwards ports
- Click the **Ports** tab in the terminal panel
- Click the globe icon next to port to open in browser

### Manual Access
1. Go to **Ports** tab
2. Find port 5173 (Frontend) or 8080 (Backend)
3. Click the local address or globe icon

## Development Workflow

### Backend Development

```bash
# Run tests
cd backend
mvn test

# Build
mvn clean package

# Run with hot reload
mvn spring-boot:run
```

### Frontend Development

```bash
# Start dev server with HMR
cd frontend
npm run dev

# Lint code
npm run lint

# Build for production
npm run build
```

### Docker in Codespace

```bash
# Build images
docker build -t backend ./backend
docker build -t frontend ./frontend

# Run with Docker Compose
docker compose up --build
```

### Kubernetes in Codespace

```bash
# Start Minikube
minikube start

# Build images for Minikube
eval $(minikube docker-env)
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend

# Deploy
kubectl apply -f k8s/

# Access services
minikube service frontend-service
```

## Tips and Tricks

### Terminal Management
- **Split Terminal**: Click split icon or Ctrl+Shift+5
- **New Terminal**: Click + icon or Ctrl+Shift+`
- **Rename Terminal**: Right-click → Rename

### File Navigation
- **Quick Open**: Ctrl+P / Cmd+P
- **Search Files**: Ctrl+Shift+F / Cmd+Shift+F
- **File Explorer**: Ctrl+Shift+E / Cmd+Shift+E

### Git Operations
```bash
# Check status
git status

# Create branch
git checkout -b feature/my-feature

# Commit changes
git add .
git commit -m "Your message"

# Push changes
git push origin feature/my-feature
```

### Debugging

#### Backend Debugging
1. Open `FullStackApplication.java`
2. Click left margin to set breakpoint
3. Press F5 or click Debug
4. Select "Java" configuration

#### Frontend Debugging
1. Set breakpoints in browser DevTools
2. Use `console.log()` for quick debugging
3. Check Network tab for API calls

## Performance Optimization

### For Better Performance
- Close unused browser tabs
- Stop services when not needed
- Use `mvn -o` for offline Maven builds
- Clear browser cache regularly

### Resource Monitoring
```bash
# Check CPU and memory
top

# Check disk usage
df -h

# Check Docker resources
docker stats
```

## Common Issues and Solutions

### Backend Won't Start
```bash
# Check if port is in use
lsof -i :8080

# Kill process if needed
kill -9 <PID>

# Clean and rebuild
cd backend
mvn clean install
```

### Frontend Build Fails
```bash
# Clear node_modules
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### Docker Issues
```bash
# Restart Docker
sudo systemctl restart docker

# Clean Docker
docker system prune -a
```

### Port Not Forwarding
1. Go to **Ports** tab
2. Right-click port → **Forward Port**
3. Set port number and visibility

## Environment Variables

### Backend Variables
```bash
# In terminal or .env file
export SPRING_PROFILES_ACTIVE=dev
export SERVER_PORT=8080
```

### Frontend Variables
```bash
# Create .env.local
VITE_API_URL=/api
```

## Codespace Settings

### Customize Settings
1. Click gear icon (⚙️)
2. Select **Settings**
3. Configure editor preferences

### Sync Settings
- Settings sync automatically with your GitHub account
- Includes extensions, keybindings, and preferences

## Collaboration

### Live Share
1. Install "Live Share" extension
2. Click "Share" in status bar
3. Share link with collaborators

### Pair Programming
- Share your Codespace URL
- Set port visibility to "Public"
- Collaborate in real-time

## Stopping and Resuming

### Stop Codespace
- Automatically stops after 30 minutes of inactivity
- Manually: Click Codespace name → **Stop Codespace**

### Resume Codespace
- Go to github.com/codespaces
- Click your Codespace
- All your work is preserved

### Delete Codespace
- When you're done with the Codespace
- Go to github.com/codespaces
- Click "..." → **Delete**

## Cost Management

### Free Tier
- 60 hours/month for 2-core machines
- 120 hours/month for 4-core machines

### Best Practices
- Stop Codespace when not in use
- Use smallest machine size needed
- Delete unused Codespaces
- Set shorter timeout period

### Check Usage
- Visit github.com/settings/billing
- View Codespaces usage
- Set spending limits

## Advanced Features

### Prebuilds
Prebuilds speed up Codespace creation:
1. Go to repository settings
2. Enable Codespaces prebuilds
3. Configure prebuild triggers

### Dotfiles
Personalize your Codespace:
1. Create a dotfiles repository
2. Add your configs (.bashrc, .vimrc, etc.)
3. Link in Codespaces settings

### Secrets
Store sensitive data:
1. Go to github.com/settings/codespaces
2. Add secrets
3. Access via environment variables

## Keyboard Shortcuts

### General
- `Ctrl/Cmd + P`: Quick Open
- `Ctrl/Cmd + Shift + P`: Command Palette
- `Ctrl/Cmd + B`: Toggle Sidebar
- `Ctrl/Cmd + J`: Toggle Terminal

### Editing
- `Ctrl/Cmd + D`: Select Next Occurrence
- `Alt + Up/Down`: Move Line
- `Ctrl/Cmd + /`: Toggle Comment
- `Ctrl/Cmd + Shift + K`: Delete Line

### Terminal
- `Ctrl + `` : Toggle Terminal
- `Ctrl/Cmd + Shift + `` : New Terminal
- `Ctrl/Cmd + Shift + 5`: Split Terminal

## Troubleshooting

### Codespace Won't Start
1. Try creating a new Codespace
2. Check GitHub Status page
3. Contact GitHub Support

### Performance Issues
1. Stop unnecessary processes
2. Restart Codespace
3. Upgrade machine size

### File Sync Issues
1. Check git status
2. Pull latest changes
3. Resolve conflicts

### Extension Issues
1. Reload window
2. Reinstall extension
3. Check extension logs

## Resources

- [GitHub Codespaces Docs](https://docs.github.com/en/codespaces)
- [VS Code in Browser](https://code.visualstudio.com/docs/remote/codespaces)
- [Codespaces Quickstart](https://docs.github.com/en/codespaces/getting-started/quickstart)

## Support

If you encounter issues:
1. Check terminal for error messages
2. Review logs in Output panel
3. Search GitHub Community
4. Open an issue in this repository

## Best Practices

1. **Save Regularly**: Changes are auto-saved
2. **Commit Often**: Preserve your work
3. **Stop When Done**: Save resources
4. **Use Branches**: Protect main branch
5. **Clean Up**: Delete old Codespaces
6. **Document Changes**: Write clear commit messages
7. **Test Locally**: Verify before pushing

## Learning Path

### Beginner
1. Create your first Codespace
2. Run the application
3. Make simple changes
4. Commit and push

### Intermediate
1. Set up debugging
2. Work with Docker
3. Use multiple terminals
4. Configure environment variables

### Advanced
1. Deploy to Kubernetes
2. Set up CI/CD workflows
3. Customize dotfiles
4. Create prebuilds

---

Happy Coding in the Cloud! 🚀
