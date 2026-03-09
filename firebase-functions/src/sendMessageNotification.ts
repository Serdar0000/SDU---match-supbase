import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

interface MessageData {
  sender_id: string;
  receiver_id: string;
  text: string;
  created_at: any;
  image_url?: string;
  [key: string]: any;
}

/**
 * Отправляет push-уведомление получателю о новом сообщении
 * 
 * Процесс:
 * 1. Получаем данные отправителя (имя, аватар)
 * 2. Получаем FCM токен получателя
 * 3. Формируем payload с данными для deep linking
 * 4. Отправляем уведомление через Firebase Admin SDK
 * 5. Если токен невалиден, удаляем его из БД
 * 
 * @param messageData - данные сообщения из Firestore
 * @param chatId - ID чата
 */
export async function sendMessageNotification(
  messageData: MessageData,
  chatId: string
): Promise<void> {
  const db = admin.firestore();
  const receiverId = messageData.receiver_id;
  const senderId = messageData.sender_id;

  // Шаг 1: Получаем имя отправителя
  let senderName = 'Новое сообщение';
  try {
    const senderDoc = await db.collection('profiles').doc(senderId).get();
    if (senderDoc.exists) {
      const senderData = senderDoc.data();
      senderName = senderData?.display_name || 'Новое сообщение';
    }
  } catch (error) {
    functions.logger.warn(`Failed to get sender name: ${error}`);
  }

  // Шаг 2: Получаем FCM токен получателя
  let receiverDoc;
  try {
    receiverDoc = await db.collection('profiles').doc(receiverId).get();
  } catch (error) {
    functions.logger.error(`Failed to fetch receiver profile: ${error}`);
    throw error;
  }

  if (!receiverDoc.exists) {
    functions.logger.warn(`Receiver profile not found: ${receiverId}`);
    return;
  }

  const receiverData = receiverDoc.data();
  const fcmToken = receiverData?.fcm_token;

  if (!fcmToken) {
    functions.logger.warn(`No FCM token for receiver: ${receiverId}`);
    return;
  }

  functions.logger.log(`📱 Sending notification to receiver: ${receiverId}`);
  functions.logger.log(`FCM Token (first 20 chars): ${fcmToken.substring(0, 20)}...`);

  // Шаг 3: Формируем payload
  // ВАЖНО: Данные должны быть строковыми значениями (Firebase ограничение)
  const truncatedMessage = messageData.text.substring(0, 150);
  
  const payload: admin.messaging.Message = {
    notification: {
      title: senderName,
      body: truncatedMessage,
      imageUrl: messageData.image_url,
    },
    data: {
      chat_id: chatId,
      sender_id: senderId,
      sender_name: senderName,
      message_body: messageData.text,
      timestamp: Date.now().toString(),
      notification_type: 'message', // Для дополнительной обработки
    },
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        tag: chatId, // Группирует уведомления от одного чата
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
          'mutable-content': true, // Для расширенного контента
          'custom-data': {
            'gcm.n.e': '1', // Включает звук
          },
        },
      },
      headers: {
        'apns-priority': '10', // Высокий приоритет
      },
    },
    webpush: {
      fcmOptions: {
        link: `https://app.example.com/chat/${chatId}`,
      },
      notification: {
        title: senderName,
        body: truncatedMessage,
        icon: 'https://app.example.com/icon-192x192.png', // Иконка для web
      },
    },
    token: fcmToken,
  };

  // Шаг 4: Отправляем уведомление
  try {
    const response = await admin.messaging().send(payload);
    functions.logger.log('✅ Notification sent successfully:', response);
  } catch (error) {
    functions.logger.error('❌ Error sending notification:', error);

    // Шаг 5: Обработка ошибок с FCM токеном
    if (error instanceof Error) {
      const errorMsg = error.message.toLowerCase();
      
      // Если токен невалиден/отозван, удаляем его
      if (
        errorMsg.includes('registration token is invalid') ||
        errorMsg.includes('mismatched sender id') ||
        errorMsg.includes('unregistered')
      ) {
        functions.logger.log(`🗑️ Removing invalid FCM token for receiver: ${receiverId}`);
        try {
          await db.collection('profiles').doc(receiverId).update({
            fcm_token: admin.firestore.FieldValue.delete(),
          });
        } catch (updateError) {
          functions.logger.error(`Failed to delete invalid token: ${updateError}`);
        }
      }
    }

    throw error;
  }
}

/**
 * Отправляет уведомление нескольким получателям (для массовых операций)
 * @param messageIds - массив ID сообщений
 */
export async function sendBulkNotifications(messageIds: string[]): Promise<void> {
  const db = admin.firestore();
  const promises = [];

  for (const messageId of messageIds) {
    const messageDoc = await db.collection('messages').doc(messageId).get();
    if (messageDoc.exists) {
      const messageData = messageDoc.data() as MessageData;
      const chatId = messageData.chat_id || messageId;
      promises.push(sendMessageNotification(messageData, chatId));
    }
  }

  await Promise.allSettled(promises);
}
