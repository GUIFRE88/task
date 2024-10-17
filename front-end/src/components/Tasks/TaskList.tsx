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
  const toast = useToast()
  const { isOpen, onOpen, onClose } = useDisclosure()

  const statusLabels = {
    '0': 'Pending',
    '1': 'In Progress',
    '2': 'Completed',
    '3': 'Failed',
  };

  const fetchTasks = async () => {
    setLoading(true);
    const token = localStorage.getItem('token');

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
    fetchTasks(); 
    onClose(); 
  };

  const handleLogOut = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user_id');

    toast({
      title: 'Log out successful!',
      status: 'success',
      duration: 2000,
      isClosable: true,
    });
    setTimeout(() => {
      window.location.href = '/login';
    }, 2000);
  }

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
              </Tr>
            </Thead>
            <Tbody>
              {tasks.map((task) => (
                <Tr key={task.id}>
                  <Td>{task.id}</Td>
                  <Td>{task.url}</Td>
                  <Td>{statusLabels[task.status]}</Td>
                  <Td>{format(new Date(task.created_at), 'dd/MM/yyyy HH:mm')}</Td>
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
            onClick={onOpen} 
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
        <Modal isOpen={isOpen} onClose={onClose}>
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>Add Task</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
              <TaskForm onTaskAdded={handleTaskAdded} />
            </ModalBody>
            <ModalFooter>
              <Button colorScheme="blue" variant="outline" onClick={onClose}>
                Close
              </Button>
            </ModalFooter>
          </ModalContent>
        </Modal>
      </Box>
    </Flex>
  );
};

export default TaskList;
