// src/components/Tasks/TaskForm.tsx
import React, { useState } from 'react';
import axios from 'axios';
import { Input, Button, FormLabel, FormControl } from '@chakra-ui/react';

interface TaskFormProps {
  onTaskAdded: () => void;
}

const TaskForm: React.FC<TaskFormProps> = ({ onTaskAdded }) => {
  const [url, setUrl] = useState<string>('');
  const [status, setStatus] = useState<string>('0');

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      await axios.post('http://localhost:3000/tasks', { url, status }, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      onTaskAdded();
      setUrl('');
    } catch (error) {
      console.error(error);
      alert('Error creating task.');
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
        Add Task
      </Button>
    </form>
  );
};

export default TaskForm;
