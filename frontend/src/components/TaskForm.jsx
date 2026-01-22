import { useState } from 'react';
import PropTypes from 'prop-types';
import './TaskForm.css';

function TaskForm({ onTaskAdded }) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!title.trim()) {
      setError('Title is required');
      return;
    }

    try {
      await onTaskAdded({ title, description, completed: false });
      setTitle('');
      setDescription('');
      setError('');
    } catch (err) {
      setError('Failed to create task');
      console.error('Error creating task:', err);
    }
  };

  return (
    <div className="task-form">
      <h2>Add New Task</h2>
      {error && <div className="error-message">{error}</div>}
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <input
            type="text"
            placeholder="Task title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="form-input"
          />
        </div>
        <div className="form-group">
          <textarea
            placeholder="Task description (optional)"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="form-textarea"
            rows="3"
          />
        </div>
        <button type="submit" className="btn-primary">Add Task</button>
      </form>
    </div>
  );
}

TaskForm.propTypes = {
  onTaskAdded: PropTypes.func.isRequired,
};

export default TaskForm;
