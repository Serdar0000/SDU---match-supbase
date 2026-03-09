import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendMessageNotification } from './sendMessageNotification';

// Инициализация Firebase Admin SDK
admin.initializeApp();

/**
 * Cloud Function: Отправляет push-уведомление при создании нового сообщения
 * Триггер: onDocumentCreated для коллекции messages в каждом чате
 * 
 * Firestore Structure:
 * /chats/{chatId}/messages/{messageId}
 *   - sender_id: string
 *   - receiver_id: string
 *   - text: string
 *   - created_at: Timestamp
 */
exports.onNewMessage = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap: { data: () => any; }, context: { params: { chatId: any; }; }) => {
    try {
      const messageData = snap.data();
      const { chatId } = context.params;

      functions.logger.log(`📨 New message created in chat: ${chatId}`);
      functions.logger.log('Message data:', messageData);

      await sendMessageNotification(messageData, chatId);

      functions.logger.log('✅ Notification sent successfully');
      return { success: true };
    } catch (error) {
      functions.logger.error('❌ Error in onNewMessage:', error);
      return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
    }
  });

/**
 * Alternative: Trigger on Supabase message creation via HTTP
 * This function receives a webhook from Supabase when a new message is created
 */
exports.handleSupabaseWebhook = functions.https.onRequest(async (req: { method: string; body: { record: any; type: any; table: any; }; }, res: { status: (arg0: number) => { (): any; new(): any; send: { (arg0: string): void; new(): any; }; json: { (arg0: { error: string; }): void; new(): any; }; }; json: (arg0: { success: boolean; message: string; }) => void; }) => {
  try {
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    const { record, type, table } = req.body;

    if (table !== 'messages' || type !== 'INSERT') {
      res.status(200).send('OK');
      return;
    }

    const messageData = {
      sender_id: record.sender_id,
      receiver_id: record.receiver_id,
      text: record.text,
      created_at: record.created_at,
      image_url: record.image_url,
    };

    const chatId = record.chat_id;
    await sendMessageNotification(messageData, chatId);

    res.json({ success: true, message: 'Notification sent' });
  } catch (error) {
    functions.logger.error('Error in webhook:', error);
    res.status(500).json({ error: error instanceof Error ? error.message : 'Unknown error' });
  }
});
