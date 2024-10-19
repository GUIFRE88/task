import React, { useEffect } from 'react';
import { createConsumer } from '@rails/actioncable';
import { useToast } from '@chakra-ui/react';

interface NotificationComponentProps {
  userId: number | string | null
}

const NotificationComponent: React.FC<NotificationComponentProps> = ({ userId }) => {
  const toast = useToast();

  useEffect(() => {
    const consumer = createConsumer('ws://localhost:3002/cable');

    const subscription = consumer.subscriptions.create(
      { channel: "NotificationChannel", user_id: userId },
      {
        connected() {
          console.log("Conected NotificationChannel");
        },
        received(data: any) {
          toast({
            title: "Scraping finished",
            description: data.message,
            status: "info",
            duration: 5000,
            isClosable: true,
            position: "top",
          });
        },
        disconnected() {
          console.log("Desconect NotificationChannel");
        }
      }
    );

    return () => {
      subscription.unsubscribe();
    };
  }, [userId, toast]);

  return null;
};

export default NotificationComponent;
