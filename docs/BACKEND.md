# Backend Documentation

## Spring Boot Task Management API

This backend provides a RESTful API for managing tasks using Spring Boot 3.2 and Java 17.

## Technology Stack

- **Java**: 17
- **Spring Boot**: 3.2.1
- **Spring Data JPA**: Database access
- **H2 Database**: In-memory database
- **Maven**: Build tool
- **Lombok**: Reduce boilerplate code
- **JUnit 5**: Testing framework
- **Mockito**: Mocking framework
- **JaCoCo**: Code coverage

## Project Structure

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/demo/fullstack/
│   │   │   ├── FullStackApplication.java     # Main application class
│   │   │   ├── controller/
│   │   │   │   └── TaskController.java       # REST API endpoints
│   │   │   ├── model/
│   │   │   │   └── Task.java                 # Task entity
│   │   │   ├── repository/
│   │   │   │   └── TaskRepository.java       # Data access
│   │   │   ├── service/
│   │   │   │   └── TaskService.java          # Business logic
│   │   │   └── config/
│   │   │       └── WebConfig.java            # CORS configuration
│   │   └── resources/
│   │       └── application.properties        # Application configuration
│   └── test/
│       └── java/com/demo/fullstack/
│           ├── controller/
│           │   └── TaskControllerTest.java
│           └── service/
│               └── TaskServiceTest.java
└── pom.xml
```

## API Endpoints

### Get All Tasks
```
GET /api/tasks
```
Response:
```json
[
  {
    "id": 1,
    "title": "Task 1",
    "description": "Description 1",
    "completed": false,
    "createdAt": "2024-01-01T10:00:00",
    "updatedAt": "2024-01-01T10:00:00"
  }
]
```

### Get Tasks by Status
```
GET /api/tasks?completed=true
```

### Get Task by ID
```
GET /api/tasks/{id}
```

### Create Task
```
POST /api/tasks
Content-Type: application/json

{
  "title": "New Task",
  "description": "Task description",
  "completed": false
}
```

### Update Task
```
PUT /api/tasks/{id}
Content-Type: application/json

{
  "title": "Updated Task",
  "description": "Updated description",
  "completed": true
}
```

### Delete Task
```
DELETE /api/tasks/{id}
```

## Configuration

### Application Properties

The application uses the following default configuration:

```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.username=sa
spring.datasource.password=

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false

# H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

### H2 Console Access

Access the H2 database console at: `http://localhost:8080/h2-console`

- **JDBC URL**: `jdbc:h2:mem:testdb`
- **Username**: `sa`
- **Password**: (empty)

## Building and Running

### Development Mode

```bash
# Install dependencies and build
mvn clean install

# Run the application
mvn spring-boot:run

# The API will be available at http://localhost:8080
```

### Production Build

```bash
# Build JAR file
mvn clean package

# Run JAR
java -jar target/fullstack-backend-1.0.0.jar
```

## Testing

### Run All Tests

```bash
mvn test
```

### Run Specific Test

```bash
mvn test -Dtest=TaskServiceTest
```

### Generate Coverage Report

```bash
mvn clean test jacoco:report
```

View the report at `target/site/jacoco/index.html`

## Code Quality

### SonarQube Analysis

```bash
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=your-project-key \
  -Dsonar.organization=your-org \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.login=your-token
```

## Docker

### Build Image

```bash
docker build -t fullstack-backend:latest .
```

### Run Container

```bash
docker run -p 8080:8080 fullstack-backend:latest
```

## Dependencies

### Core Dependencies
- `spring-boot-starter-web`: REST API
- `spring-boot-starter-data-jpa`: Database access
- `spring-boot-starter-validation`: Input validation
- `h2`: In-memory database

### Development Dependencies
- `spring-boot-devtools`: Hot reload
- `lombok`: Code generation

### Test Dependencies
- `spring-boot-starter-test`: Testing framework
- `junit-jupiter`: JUnit 5
- `mockito`: Mocking

## Best Practices

1. **Controller Layer**: Handle HTTP requests and responses
2. **Service Layer**: Implement business logic
3. **Repository Layer**: Database access
4. **Entity Layer**: Domain models with JPA annotations
5. **DTO Pattern**: Separate API models from entities (future enhancement)
6. **Exception Handling**: Global exception handler (future enhancement)
7. **Validation**: Use Bean Validation annotations
8. **Testing**: Unit tests for service and controller layers

## Common Issues and Solutions

### Port Already in Use

```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>
```

### Maven Build Issues

```bash
# Clean and rebuild
mvn clean install -U

# Skip tests if needed
mvn clean install -DskipTests
```

## API Testing with cURL

```bash
# Create a task
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Test","completed":false}'

# Get all tasks
curl http://localhost:8080/api/tasks

# Get specific task
curl http://localhost:8080/api/tasks/1

# Update task
curl -X PUT http://localhost:8080/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated","description":"Updated","completed":true}'

# Delete task
curl -X DELETE http://localhost:8080/api/tasks/1
```

## Performance Considerations

- H2 is for development only; use PostgreSQL/MySQL in production
- Implement caching for frequently accessed data
- Use connection pooling for database connections
- Implement pagination for large datasets
- Add database indexes for frequently queried fields

## Security Enhancements (Future)

- Implement Spring Security
- Add JWT authentication
- Implement rate limiting
- Add input sanitization
- Use HTTPS in production
- Implement CSRF protection
