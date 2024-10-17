import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Box, Button, FormControl, FormLabel, Input, Heading, VStack, useToast, Flex } from '@chakra-ui/react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';

const Login: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const toast = useToast();
  const { token, setToken, setUserId } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3001/login', { email, password });
      setToken(response.data.token)
      setUserId(response.data.user_id)
      toast({
        title: 'Login successful!',
        status: 'success',
        duration: 3000,
        isClosable: true,
      });
      navigate('/tasks');
    } catch (error) {
      console.error(error);
      toast({
        title: 'Error logging in.',
        status: 'error',
        duration: 3000,
        isClosable: true,
      });
    }
  };

  const handleToRegister = () =>{
    window.location.href = '/register';
  }

  return (
    <Flex height="100vh" alignItems="center" justifyContent="center">
      <Box
        width="400px"
        p="8"
        boxShadow="lg"
        borderRadius="md"
        bg="white"
      >
        <Heading mb="6" textAlign="center">Login</Heading>
        <form onSubmit={handleSubmit}>
          <VStack spacing="4">
            <FormControl id="email" isRequired>
              <FormLabel>Email</FormLabel>
              <Input
                type="email"
                placeholder="Enter your email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </FormControl>

            <FormControl id="password" isRequired>
              <FormLabel>Password</FormLabel>
              <Input
                type="password"
                placeholder="Enter your password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </FormControl>

            <Button type="submit" colorScheme="blue" width="full">
                Login
            </Button>
            <Button colorScheme="blue" variant="outline" width="full" onClick={handleToRegister}>
                Register
            </Button>
          </VStack>
        </form>
      </Box>
    </Flex>
  );
};

export default Login;
