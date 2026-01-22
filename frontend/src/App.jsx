import { useState, useEffect } from 'react';
import TaskForm from './components/TaskForm';
import TaskList from './components/TaskList';
import { taskService } from './services/taskService';
import './App.css';

function App() {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    try {
      setLoading(true);
      const response = await taskService.getAllTasks();
      setTasks(response.data);
      setError('');
    } catch (err) {
      setError('Failed to load tasks. Please make sure the backend is running.');
      console.error('Error loading tasks:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleTaskAdded = async (taskData) => {
    const response = await taskService.createTask(taskData);
    setTasks([...tasks, response.data]);
  };

  const handleToggle = async (id, completed) => {
    const task = tasks.find(t => t.id === id);
    await taskService.updateTask(id, { ...task, completed });
    setTasks(tasks.map(t => (t.id === id ? { ...t, completed } : t)));
  };

  const handleDelete = async (id) => {
    await taskService.deleteTask(id);
    setTasks(tasks.filter(t => t.id !== id));
  };

  return (
    <div className="app">
      <div className="container">
        <header className="app-header">
          <h1>Full Stack Task Manager</h1>
          <p className="subtitle">
            React + Vite Frontend | Spring Boot Backend
          </p>
        </header>

        {error && (
          <div className="error-banner">
            {error}
          </div>
        )}

        <TaskForm onTaskAdded={handleTaskAdded} />

        {loading ? (
          <div className="loading">Loading tasks...</div>
        ) : (
          <TaskList
            tasks={tasks}
            onToggle={handleToggle}
            onDelete={handleDelete}
          />
        )}
      </div>
    </div>
  );
}

export default App;
