import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Input, Button, FormLabel, FormControl } from '@chakra-ui/react';

interface Task {
  id?: number;
  url: string;
  status: string; 
}

interface TaskFormProps {
  onTaskAdded: () => void;
  task?: Task | null;
}

const TaskForm: React.FC<TaskFormProps> = ({ onTaskAdded, task }) => {
  const [url, setUrl] = useState<string>('');
  const [status, setStatus] = useState<string>('0');

  useEffect(() => {
    if (task) {
      setUrl(task.url);
      setStatus(task.status);
    }
  }, [task]);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      if (task) {
        await axios.put(`http://localhost:3000/tasks/${task.id}`, { url, status }, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
      } else {
        await axios.post('http://localhost:3000/tasks', { url, status }, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
      }
      onTaskAdded();
      setUrl('');
      setStatus('0');
    } catch (error) {
      console.error(error);
      alert('Error creating or updating task.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormControl>
        <FormLabel>Add Task URL</FormLabel>
        <Input
          type="text"
          placeholder="Task URL"
          value={url}
          onChange={(e) => setUrl(e.target.value)}
          required
        />
      </FormControl>
      <Button mt="4" colorScheme="blue" type="submit">
        {task ? 'Update Task' : 'Add Task'}
      </Button>
    </form>
  );
};

export default TaskForm;
