# Frontend Documentation

## React + Vite Task Management UI

A modern, responsive frontend built with React 18 and Vite 5.

## Technology Stack

- **React**: 18.x
- **Vite**: 5.x
- **Axios**: HTTP client
- **JavaScript**: ES6+
- **CSS3**: Modern styling
- **PropTypes**: Runtime type checking

## Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── TaskForm.jsx         # Form for creating tasks
│   │   ├── TaskForm.css
│   │   ├── TaskItem.jsx         # Individual task display
│   │   ├── TaskItem.css
│   │   ├── TaskList.jsx         # List of tasks
│   │   └── TaskList.css
│   ├── services/
│   │   └── taskService.js       # API communication
│   ├── App.jsx                  # Main application component
│   ├── App.css
│   └── main.jsx                 # Application entry point
├── public/
├── index.html
├── vite.config.js
├── package.json
├── Dockerfile
└── nginx.conf
```

## Components

### App Component
Main application component that manages application state and coordinates child components.

**Features:**
- Fetches tasks on mount
- Manages task list state
- Handles task operations (create, update, delete)
- Error handling and loading states

### TaskForm Component
Form component for creating new tasks.

**Props:**
- `onTaskAdded`: Callback function when task is created

**Features:**
- Controlled form inputs
- Input validation
- Error display

### TaskList Component
Displays list of tasks.

**Props:**
- `tasks`: Array of task objects
- `onToggle`: Callback for toggling task completion
- `onDelete`: Callback for deleting task

**Features:**
- Empty state handling
- Task list rendering

### TaskItem Component
Individual task display component.

**Props:**
- `task`: Task object
- `onToggle`: Completion toggle callback
- `onDelete`: Delete callback

**Features:**
- Checkbox for completion
- Delete button
- Completed state styling

## API Service

### taskService.js

Handles all API communications with the backend.

```javascript
import { taskService } from './services/taskService';

// Get all tasks
const tasks = await taskService.getAllTasks();

// Get task by ID
const task = await taskService.getTaskById(id);

// Create task
const newTask = await taskService.createTask(taskData);

// Update task
const updated = await taskService.updateTask(id, taskData);

// Delete task
await taskService.deleteTask(id);

// Get by completion status
const completed = await taskService.getTasksByCompleted(true);
```

## Environment Configuration

### Development
Create `.env` file:
```
VITE_API_URL=/api
```

### Production
Set environment variable:
```
VITE_API_URL=https://your-api-domain.com/api
```

## Development

### Install Dependencies
```bash
npm install
```

### Start Development Server
```bash
npm run dev
```
Application runs on `http://localhost:5173`

### Build for Production
```bash
npm run build
```
Build output in `dist/` directory

### Preview Production Build
```bash
npm run preview
```

### Linting
```bash
npm run lint
```

## Styling

The application uses custom CSS with:
- CSS3 variables for theming
- Flexbox for layouts
- Responsive design
- Gradient backgrounds
- Modern shadows and transitions

### Color Scheme
- Primary: Purple gradient (#667eea to #764ba2)
- Success: Green (#4CAF50)
- Error: Red (#f44336)
- Text: Dark gray (#333)
- Background: White with shadows

## Docker Deployment

### Development Build
```bash
docker build -t fullstack-frontend:dev .
docker run -p 3000:80 fullstack-frontend:dev
```

### Production Build
```bash
docker build -t fullstack-frontend:latest .
docker run -p 80:80 fullstack-frontend:latest
```

The Docker image:
1. Builds the application with Vite
2. Serves static files with Nginx
3. Includes reverse proxy configuration for API

## Nginx Configuration

The production build uses Nginx with:
- Static file serving
- SPA routing support
- API proxy to backend
- Gzip compression

```nginx
location / {
    try_files $uri $uri/ /index.html;
}

location /api {
    proxy_pass http://backend:8080;
}
```

## State Management

Currently using React's built-in state with `useState` and `useEffect`.

For larger applications, consider:
- Redux or Redux Toolkit
- Zustand
- Recoil
- Context API with useReducer

## Error Handling

The application handles:
- Network errors
- API errors
- Form validation errors
- Loading states

## Best Practices Implemented

1. **Component Structure**: Separate components by responsibility
2. **PropTypes**: Runtime type checking for props
3. **CSS Modules**: Component-scoped styling
4. **Environment Variables**: Configuration via `.env`
5. **Error Boundaries**: Graceful error handling
6. **Loading States**: User feedback during async operations
7. **Accessibility**: Semantic HTML and ARIA labels

## Performance Optimization

- **Vite**: Lightning-fast HMR
- **Code Splitting**: Automatic via Vite
- **Asset Optimization**: Image and CSS optimization
- **Production Build**: Minified and optimized bundle
- **Nginx**: Static file serving with caching

## Testing (Future Enhancement)

### Setup Jest and React Testing Library
```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom jest
```

### Example Test
```javascript
import { render, screen } from '@testing-library/react';
import TaskItem from './TaskItem';

test('renders task title', () => {
  const task = { id: 1, title: 'Test', completed: false };
  render(<TaskItem task={task} onToggle={() => {}} onDelete={() => {}} />);
  expect(screen.getByText('Test')).toBeInTheDocument();
});
```

## Common Issues

### CORS Errors
- Ensure backend has CORS configured
- Check API URL in `.env`
- Verify backend is running

### Build Errors
```bash
# Clear cache
rm -rf node_modules package-lock.json
npm install

# Clear Vite cache
rm -rf node_modules/.vite
```

### Port Conflicts
```bash
# Change port in vite.config.js
export default defineConfig({
  server: {
    port: 3000
  }
})
```

## Browser Support

- Chrome (last 2 versions)
- Firefox (last 2 versions)
- Safari (last 2 versions)
- Edge (last 2 versions)

## Accessibility Features

- Semantic HTML elements
- ARIA labels on buttons
- Keyboard navigation support
- Focus indicators
- Color contrast compliance

## Future Enhancements

1. **Authentication**: User login/registration
2. **Routing**: React Router for multiple pages
3. **State Management**: Redux or Context API
4. **Testing**: Unit and integration tests
5. **TypeScript**: Type safety
6. **PWA**: Offline support
7. **Internationalization**: Multi-language support
8. **Dark Mode**: Theme switching
9. **Animations**: Smooth transitions
10. **Websockets**: Real-time updates

## Useful Commands

```bash
# Development
npm run dev           # Start dev server
npm run build         # Build for production
npm run preview       # Preview production build
npm run lint          # Lint code

# Dependencies
npm install           # Install dependencies
npm update            # Update dependencies
npm audit             # Security audit
npm audit fix         # Fix vulnerabilities

# Clean
rm -rf node_modules   # Remove dependencies
rm -rf dist           # Remove build output
```

## API Integration Example

```javascript
// Fetch and display tasks
useEffect(() => {
  const fetchTasks = async () => {
    try {
      const response = await taskService.getAllTasks();
      setTasks(response.data);
    } catch (error) {
      console.error('Error:', error);
      setError('Failed to load tasks');
    }
  };
  fetchTasks();
}, []);

// Create task
const handleCreate = async (taskData) => {
  try {
    const response = await taskService.createTask(taskData);
    setTasks([...tasks, response.data]);
  } catch (error) {
    console.error('Error:', error);
  }
};
```

## Debugging

### React DevTools
Install React DevTools browser extension for:
- Component tree inspection
- Props and state viewing
- Performance profiling

### Vite DevTools
- Fast refresh for instant updates
- Detailed error overlay
- Source maps for debugging

### Network Debugging
```javascript
// Log all API calls
api.interceptors.request.use(request => {
  console.log('Starting Request', request);
  return request;
});

api.interceptors.response.use(response => {
  console.log('Response:', response);
  return response;
});
```
