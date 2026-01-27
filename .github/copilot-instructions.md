# GitHub Copilot Instructions

This repository is a full-stack demonstration project combining React + Vite frontend with Java Spring Boot backend, containerized with Docker, orchestrated with Kubernetes, and automated with GitHub Actions CI/CD.

## Project Overview

### Architecture
- **Backend**: Java Spring Boot 3.2 with REST API, Spring Data JPA, H2 in-memory database
- **Frontend**: React 18 + Vite 5 with Axios for API communication
- **Database**: H2 (in-memory for demo purposes)
- **Containerization**: Docker with multi-stage builds, Docker Compose
- **Orchestration**: Kubernetes with Minikube
- **CI/CD**: GitHub Actions with manual dispatch support
- **Code Quality**: SonarQube integration, JaCoCo for code coverage

### Repository Structure
```
.
├── backend/                    # Spring Boot Backend (Java 17, Maven)
│   ├── src/main/java/com/demo/fullstack/
│   │   ├── controller/        # REST API Controllers
│   │   ├── model/             # JPA Entity Models
│   │   ├── repository/        # Spring Data JPA Repositories
│   │   ├── service/           # Business Logic Services
│   │   └── config/            # Configuration Classes (CORS, etc.)
│   ├── src/test/              # Unit Tests (JUnit 5, Mockito)
│   ├── pom.xml                # Maven dependencies
│   └── Dockerfile             # Multi-stage Docker build
│
├── frontend/                   # React Frontend (Node.js 20, npm)
│   ├── src/
│   │   ├── components/        # React Components
│   │   ├── services/          # API Service Layer (Axios)
│   │   ├── App.jsx            # Main App Component
│   │   └── main.jsx           # Entry Point
│   ├── package.json           # npm dependencies
│   ├── vite.config.js         # Vite configuration with proxy
│   ├── eslint.config.js       # ESLint configuration
│   ├── nginx.conf             # Nginx config for production
│   └── Dockerfile             # Multi-stage Docker build
│
├── k8s/                       # Kubernetes Manifests
├── .github/workflows/         # CI/CD Pipelines
├── docs/                      # Documentation
└── docker-compose.yml         # Local development setup
```

## Development Setup

### Backend Development (Java Spring Boot)

**Prerequisites**: JDK 17+, Maven 3.8+

**Build & Run**:
```bash
cd backend
mvn clean install          # Build and install dependencies
mvn spring-boot:run        # Run application (http://localhost:8080)
```

**Testing**:
```bash
mvn test                   # Run all tests
mvn test -Dtest=ClassName  # Run specific test
mvn clean test jacoco:report  # Generate coverage report (target/site/jacoco/index.html)
```

**Key Dependencies**:
- Spring Boot 3.2.1
- Spring Data JPA
- H2 Database
- Spring Boot Validation
- Lombok (for reducing boilerplate)

**Code Style**:
- Follow standard Java naming conventions (camelCase for methods/variables, PascalCase for classes)
- Use constructor injection for dependencies (preferred over field injection)
- Keep controllers thin, business logic in services
- Use DTOs for API request/response when needed
- Write comprehensive unit tests with Mockito for services

### Frontend Development (React + Vite)

**Prerequisites**: Node.js 20+, npm 10+

**Build & Run**:
```bash
cd frontend
npm install                # Install dependencies
npm run dev               # Start dev server (http://localhost:5173)
npm run build             # Build for production
npm run preview           # Preview production build
```

**Linting**:
```bash
npm run lint              # Run ESLint
```

**Key Dependencies**:
- React 19.2.0
- Axios 1.13.2
- Vite 7.2.4
- ESLint with React hooks plugin

**Code Style**:
- Use functional components with hooks (no class components)
- Follow React naming conventions (PascalCase for components, camelCase for functions/variables)
- Keep components focused and reusable
- Use PropTypes for type checking
- Organize imports: React, third-party, local
- Use arrow functions for component definitions
- Handle errors gracefully in API calls

**Vite Configuration**:
- Proxy configured for API calls: `/api` → `http://localhost:8080/api`
- Host binding enabled for GitHub Codespaces compatibility

## API Conventions

### Backend REST API
- Base URL: `/api`
- Endpoints follow RESTful conventions:
  - GET `/api/tasks` - List all tasks
  - GET `/api/tasks/{id}` - Get single task
  - POST `/api/tasks` - Create task
  - PUT `/api/tasks/{id}` - Update task
  - DELETE `/api/tasks/{id}` - Delete task
- Use `@RestController` and `@RequestMapping`
- Return appropriate HTTP status codes
- Use `@Valid` for request validation
- Handle exceptions with `@ControllerAdvice`

### CORS Configuration
- Backend configured for GitHub Codespaces: `*.githubpreview.dev`, `*.app.github.dev`
- Allows credentials and common headers
- Configurable via environment variables

## Testing Standards

### Backend Tests
- Use JUnit 5 and Mockito
- Test files in `src/test/java` mirror `src/main/java` structure
- Name tests descriptively: `methodName_condition_expectedResult`
- Mock external dependencies (repositories, services)
- Aim for high code coverage (target: 80%+)
- Example test structure:
  ```java
  @Test
  void createTask_validInput_returnsCreatedTask() {
      // Arrange
      // Act
      // Assert
  }
  ```

### Frontend Tests
- ESLint configured for code quality
- Follow React best practices
- Test component behavior, not implementation details

## Docker & Deployment

### Docker Commands
```bash
# Build individual images
docker build -t fullstack-backend:latest ./backend
docker build -t fullstack-frontend:latest ./frontend

# Using Docker Compose (includes SonarQube)
docker compose up --build    # Build and start all services
docker compose down          # Stop services
```

### Kubernetes
```bash
# Local deployment with Minikube
kubectl apply -f k8s/        # Deploy all manifests
kubectl get pods             # Check pod status
kubectl logs -f <pod-name>   # View logs
```

## CI/CD Workflows

All workflows support manual dispatch via GitHub Actions UI.

### Backend CI (`backend-ci.yml`)
- Triggers: Push/PR to `main`/`develop` with changes in `backend/**`
- Steps: Build with Maven → Run tests → Generate JaCoCo coverage → SonarQube analysis → Build Docker image
- Artifacts: Docker image (on main branch)

### Frontend CI (`frontend-ci.yml`)
- Triggers: Push/PR to `main`/`develop` with changes in `frontend/**`
- Steps: Install dependencies → Lint → Build → SonarQube analysis → Build Docker image
- Artifacts: Docker image (on main branch)

### Integration Tests (`integration-test.yml`)
- Tests full stack with Docker Compose
- Validates backend API and frontend build

**Important**: SonarQube analysis is optional and skips gracefully if `SONAR_TOKEN` not configured.

## Common Tasks for Copilot

### Adding New Backend Endpoint
1. Create/update model in `backend/src/main/java/com/demo/fullstack/model/`
2. Add repository interface in `repository/` (extends JpaRepository)
3. Implement business logic in `service/`
4. Create controller endpoint in `controller/`
5. Add validation annotations (`@NotNull`, `@Size`, etc.)
6. Write unit tests in `src/test/`
7. Test with: `mvn test`

### Adding New Frontend Component
1. Create component in `frontend/src/components/`
2. Use functional component with hooks
3. Add PropTypes for props validation
4. Import and use in parent component
5. Style with CSS (component-specific or App.css)
6. Test with: `npm run dev` and verify in browser
7. Lint with: `npm run lint`

### Updating Dependencies
- **Backend**: Update `pom.xml`, run `mvn clean install`
- **Frontend**: Update `package.json`, run `npm install`
- Always test after updates: `mvn test` / `npm run build`

### Adding New Environment Variables
- **Backend**: Add to `application.properties` with sensible defaults
- **Frontend**: Add to `vite.config.js` or use `.env` files (prefix with `VITE_`)
- Document in `docs/ENVIRONMENT.md`
- Update Docker Compose and Kubernetes manifests if needed

## Best Practices

### General
- Make minimal, focused changes
- Follow existing code patterns and conventions
- Write clear, descriptive commit messages
- Update documentation when adding features
- Don't commit secrets or sensitive data
- Use `.gitignore` to exclude build artifacts

### Code Quality
- Run tests before committing
- Maintain or improve code coverage
- Fix linting errors before committing
- Use meaningful variable and method names
- Add comments only when necessary to explain "why", not "what"

### Security
- Validate all user inputs
- Use parameterized queries (JPA handles this)
- Don't log sensitive information
- Keep dependencies updated
- Follow OWASP guidelines for web applications

## GitHub Codespaces

This repository is Codespaces-ready with:
- Auto-setup of Java 17, Maven, Node.js 20
- Pre-installed VS Code extensions
- Configured port forwarding (8080, 5173)
- CORS enabled for Codespaces URLs

**Running in Codespaces**:
```bash
# Terminal 1: Backend
cd backend && mvn spring-boot:run

# Terminal 2: Frontend  
cd frontend && npm run dev
```

## Troubleshooting

### Backend Issues
- **Build fails**: Run `mvn clean install -U` to force update dependencies
- **Tests fail**: Check H2 database configuration, ensure ports are available
- **Port 8080 in use**: Change port in `application.properties` or kill existing process

### Frontend Issues
- **npm install fails**: Delete `node_modules` and `package-lock.json`, retry
- **Build errors**: Check Node.js version (requires 20+)
- **API calls fail**: Verify backend is running, check proxy config in `vite.config.js`
- **CORS errors**: Ensure backend CORS configuration includes your origin

## Additional Resources

See `docs/` folder for comprehensive guides:
- `BACKEND.md` - Detailed backend development guide
- `FRONTEND.md` - Detailed frontend development guide
- `DEPLOYMENT.md` - Deployment instructions
- `SONARQUBE.md` - SonarQube setup and usage
- `CODESPACES.md` - GitHub Codespaces configuration
- `ENVIRONMENT.md` - Environment variables reference

## Notes for Copilot

- This is a **demonstration project** for educational purposes
- Uses in-memory H2 database (data is not persisted)
- Production deployment would require: persistent database, authentication, security headers, rate limiting, proper logging/monitoring
- When suggesting changes, consider impact on both frontend and backend
- Respect the monorepo structure - changes should be isolated to relevant directory
- Always verify changes work with existing CI/CD pipelines
