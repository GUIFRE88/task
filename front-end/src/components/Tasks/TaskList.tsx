import React, { useEffect, useState } from 'react';
import axios from 'axios';
import {
  Box,
  Button,
  Heading,
  Spinner,
  Flex,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Text,
  useToast,
  useDisclosure,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalCloseButton,
  ModalBody,
  ModalFooter,
} from '@chakra-ui/react';
import { format } from 'date-fns';
import TaskForm from './TaskForm';

interface Task {
  id: number;
  url: string;
  status: '0' | '1' | '2' | '3';
  created_at: string;
}

const TaskList: React.FC = () => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const toast = useToast();
  const { isOpen, onOpen, onClose } = useDisclosure();
  const [loadingDelete, setLoadingDelete] = useState(false);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const statusLabels = {
    '0': 'Pending',
    '1': 'In Progress',
    '2': 'Completed',
    '3': 'Failed',
  };

  const token = localStorage.getItem('token');
  const userId = localStorage.getItem('user_id');

  const fetchTasks = async () => {
    setLoading(true);
    if (!token) {
      toast({
        title: 'You must be logged in to access this feature.',
        status: 'warning',
        duration: 2000,
        isClosable: true,
      });
      setLoading(false);
      setTimeout(() => {
        window.location.href = '/';
      }, 2000);
      return; 
    }

    try {
      const response = await axios.get('http://localhost:3000/tasks', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      setTasks(response.data);
    } catch (error) {
      console.error(error);
      toast({
        title: 'Error fetching tasks.',
        status: 'error',
        duration: 2000,
        isClosable: true,
      });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  const handleTaskAdded = () => {
    setEditingTask(null);
    fetchTasks(); 
    onClose(); 
  };

  const handleEditTask = (task: Task) => {
    setEditingTask(task);
    onOpen();
  };

  const handleLogOut = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user_id');

    toast({
      title: 'Log out successful!',
      status: 'success',
      duration: 1000,
      isClosable: true,
    });
    setTimeout(() => {
      window.location.href = '/login';
    }, 1000);
  };

  const handleDelete = async (taskId: number) => {
    setLoadingDelete(true); 

    try {
      await axios.delete(`http://localhost:3000/tasks/${taskId}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      setTasks((prevTasks) => prevTasks.filter((task) => task.id !== taskId));
      toast({
        title: 'Task deleted successfully!',
        status: 'success',
        duration: 2000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: 'Error deleting task.',
        status: 'error',
        duration: 2000,
        isClosable: true,
      });
    } finally {
      setLoadingDelete(false);
    }
  };

  return (
    <Flex height="100vh" alignItems="center" justifyContent="center" bg="gray.100">
      <Box width="80%" p="8" bg="white" borderRadius="md" boxShadow="lg">
        <Heading mb="6" textAlign="center">Task List</Heading>

        {loading ? (
          <Flex justifyContent="center">
            <Spinner size="lg" />
          </Flex>
        ) : tasks.length > 0 ? (
          <Table variant="striped" colorScheme="gray">
            <Thead>
              <Tr>
                <Th>ID</Th>
                <Th>URL</Th>
                <Th>Status</Th>
                <Th>Created At</Th>
                <Th></Th>
              </Tr>
            </Thead>
            <Tbody>
              {tasks.map((task) => (
                <Tr key={task.id}>
                  <Td>{task.id}</Td>
                  <Td>{task.url}</Td>
                  <Td>{statusLabels[task.status]}</Td>
                  <Td>{format(new Date(task.created_at), 'dd/MM/yyyy HH:mm')}</Td>
                  <Td>
                    <Button colorScheme='teal' variant='solid' size='sm' onClick={() => handleEditTask(task)} >
                      Update
                    </Button>
                    <Button marginLeft='10px' colorScheme='red' variant='solid' size='sm' onClick={() => handleDelete(task.id)} isLoading={loadingDelete}>
                      Delete
                    </Button>
                  </Td>
                </Tr>
              ))}
            </Tbody>
          </Table>
        ) : (
          <Text textAlign="center" color="gray.500">
            No tasks available.
          </Text>
        )}
        <Flex justifyContent="space-between" mt="6">
          <Button
            mt="6"
            colorScheme="blue"
            width="200px"
            onClick={() => {
              setEditingTask(null);
              onOpen();
            }}
          >
            Include Tasks
          </Button>
          <Button
            mt="6"
            colorScheme="red"
            variant={"outline"}
            width="200px"
            onClick={handleLogOut}
          >
            Log out
          </Button>
        </Flex>

        <Modal isOpen={isOpen} onClose={onClose} size="lg">
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>{editingTask ? 'Edit Task' : 'Include Task'}</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
              <TaskForm onTaskAdded={handleTaskAdded} task={editingTask} />
            </ModalBody>
            <ModalFooter>
              <Button onClick={onClose}>Close</Button>
            </ModalFooter>
          </ModalContent>
        </Modal>
      </Box>
    </Flex>
  );
};

export default TaskList;
