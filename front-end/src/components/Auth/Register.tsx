import React, { useState } from 'react';
import axios from 'axios';
import { Box, Button, FormControl, FormLabel, Input, Heading, VStack, useToast, Flex } from '@chakra-ui/react';

const Register: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const [passwordConfirmation, setPasswordConfirmation] = useState<string>('');
  const toast = useToast();

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (password !== passwordConfirmation) {
      toast({
        title: 'Passwords do not match.',
        status: 'error',
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      await axios.post('http://0.0.0.0:3001/signup', {
        email,
        password,
        password_confirmation: passwordConfirmation,
      });
      toast({
        title: 'User registered successfully!',
        status: 'success',
        duration: 2000,
        isClosable: true,
      });
      setTimeout(() => {
        window.location.href = '/login';
      }, 2000);
    } catch (error) {
      console.error(error);
      toast({
        title: 'Error registering user.',
        status: 'error',
        duration: 2000,
        isClosable: true,
      });
    }
  };

  const handleToGoBack = () =>{
    window.location.href = '/';
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
        <Heading mb="6" textAlign="center">Register</Heading>
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

            <FormControl id="passwordConfirmation" isRequired>
              <FormLabel>Confirm Password</FormLabel>
              <Input
                type="password"
                placeholder="Confirm your password"
                value={passwordConfirmation}
                onChange={(e) => setPasswordConfirmation(e.target.value)}
              />
            </FormControl>

            <Button type="submit" colorScheme="blue" width="full">
              Register
            </Button>
            <Button colorScheme="blue" variant="outline" width="full" onClick={handleToGoBack}>
                Go back
            </Button>
          </VStack>
        </form>
      </Box>
    </Flex>
  );
};

export default Register;
