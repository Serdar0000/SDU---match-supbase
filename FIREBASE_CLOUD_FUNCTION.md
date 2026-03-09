# Firebase Cloud Function для отправки Push-уведомлений при новом сообщении

## Архитектура потока

```
Пользователь отправляет сообщение
        ↓
Новый документ создаётся в Firestore: /chats/{chatId}/messages/{messageId}
        ↓
Срабатывает Cloud Function триггер (onDocumentCreated)
        ↓
Функция получает ID получателя из документа чата
        ↓
Функция получает FCM токен получателя из Firestore (collection: profiles)
        ↓
Функция отправляет уведомление через Firebase Admin SDK (Cloud Messaging API v1)
        ↓
Уведомление приходит в FCM на устройство получателя
        ↓
Flutter приложение получает уведомление в onBackgroundMessage (Terminated)
        или в onMessage (Foreground)
        или в onMessageOpenedApp (Paused)
```

## Установка Firebase CLI и инициализация проекта

```bash
# Установить Firebase CLI (если не установлен)
npm install -g firebase-tools

# Войти в Firebase
firebase login

# Инициализировать проект в папке функций
cd sdu_match
firebase init functions

# При выборе опций:
# - Выбрать язык: TypeScript
# - Выбрать проект: ваш Firebase проект
# - Установить Eslint: Y (опционально)
```

## Структура проекта функций

```
firebase/
├── functions/
│   ├── src/
│   │   ├── index.ts (главный файл)
│   │   ├── sendMessageNotification.ts (функция для отправки уведомления)
│   │   └── types.ts (типы TypeScript)
│  ├── package.json
│   ├── tsconfig.json
│   └── .eslintrc.js
├── .firebaserc
└── firebase.json
```

## 1. Основной файл функции: `functions/src/index.ts`

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sendMessageNotification } from './sendMessageNotification';

// Инициализация Firebase Admin SDK
admin.initializeApp();

/**
 * Cloud Function: Отправляет push-уведомление при создании нового сообщения
 * Триггер: onDocumentCreated для коллекции messages в каждом чате
 * 
 * Структура Firestore:
 * /chats/{chatId}/messages/{messageId}
 *   - sender_id: string (ID отправителя)
 *   - receiver_id: string (ID получателя)
 *   - text: string (текст сообщения)
 *   - created_at: Timestamp
 * 
 * /profiles/{userId}
 *   - fcm_token: string (FCM токен для отправки уведомлений)
 *   - display_name: string (имя пользователя)
 */
exports.onNewMessage = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    try {
      const messageData = snap.data();
      const { chatId } = context.params;

      console.log(`📨 New message created in chat: ${chatId}`);
      console.log(`Message data:`, messageData);

      // Отправляем уведомление получателю
      await sendMessageNotification(messageData, chatId);

      console.log('✅ Notification sent successfully');
      return { success: true };
    } catch (error) {
      console.error('❌ Error in onNewMessage:', error);
      // Логируем ошибку, но не прерываем функцию
      return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
    }
  });
```

## 2. Функция отправки уведомления: `functions/src/sendMessageNotification.ts`

```typescript
import * as admin from 'firebase-admin';

interface MessageData {
  sender_id: string;
  receiver_id: string;
  text: string;
  created_at: FirebaseFirestore.Timestamp;
  image_url?: string; // опционально для картинок
  [key: string]: any;
}

/**
 * Отправляет push-уведомление получателю о новом сообщении
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

  // Получаем данные отправителя
  let senderName = 'Новое сообщение';
  try {
    const senderDoc = await db.collection('profiles').doc(senderId).get();
    if (senderDoc.exists) {
      senderName = senderDoc.data()?.display_name || 'Новое сообщение';
    }
  } catch (error) {
    console.warn(`Failed to get sender name: ${error}`);
  }

  // Получаем FCM токен получателя
  const receiverDoc = await db.collection('profiles').doc(receiverId).get();
  if (!receiverDoc.exists) {
    console.warn(`Receiver profile not found: ${receiverId}`);
    return;
  }

  const receiverData = receiverDoc.data();
  const fcmToken = receiverData?.fcm_token;

  if (!fcmToken) {
    console.warn(`No FCM token for receiver: ${receiverId}`);
    return;
  }

  console.log(`📱 Sending notification to receiver: ${receiverId}`);
  console.log(`FCM Token: ${fcmToken.substring(0, 20)}...`);

  // Формируем payload для уведомления
  const payload = {
    notification: {
      title: senderName,
      body: messageData.text.substring(0, 150), // Первые 150 символов
      imageUrl: messageData.image_url, // Если есть картинка
    },
    data: {
      chat_id: chatId,
      sender_id: senderId,
      sender_name: senderName,
      message_body: messageData.text,
      timestamp: messageData.created_at.toMillis().toString(),
      click_action: 'FLUTTER_NOTIFICATION_CLICK', // Для iOS
    },
    webpush: {
      fcmOptions: {
        link: `https://yourapp.com/chat/${chatId}`, // Для web
      },
    },
  };

  // Отправляем уведомление
  try {
    const response = await admin.messaging().send(payload as admin.messaging.Message & { token: string } || {
      ...payload,
      token: fcmToken,
    });

    console.log('✅ Notification sent successfully:', response);
  } catch (error) {
    console.error('❌ Error sending notification:', error);
    
    if (error instanceof Error && error.message.includes('registration token is invalid')) {
      console.log('🗑️ Removing invalid FCM token for receiver:', receiverId);
      // Удаляем невалидный токен из БД
      await db.collection('profiles').doc(receiverId).update({
        fcm_token: admin.firestore.FieldValue.delete(),
      });
    }
    
    throw error;
  }
}
```

## 3. Типы TypeScript: `functions/src/types.ts`

```typescript
export interface ChatMessage {
  sender_id: string;
  receiver_id: string;
  text: string;
  created_at: FirebaseFirestore.Timestamp;
  image_url?: string;
  read: boolean;
}

export interface UserProfile {
  id: string;
  display_name: string;
  fcm_token: string;
  avatar_url?: string;
  email: string;
}

export interface NotificationPayload {
  title: string;
  body: string;
  imageUrl?: string;
}
```

## 4. Package.json с зависимостями

```json
{
  "name": "functions",
  "description": "Cloud Functions for SDU Match",
  "type": "module",
  "engines": {
    "node": "20"
  },
  "scripts": {
    "build": "tsc",
    "start": "npm run build && firebase emulator:start --only functions",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log"
  },
  "main": "lib/index.js",
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

## 5. Развёртывание функции

```bash
# Установить зависимости
cd firebase/functions
npm install

# Проверить, что всё работает локально
npm start

# Развернуть функцию в Firebase
firebase deploy --only functions

# Просмотреть логи
firebase functions:log
```

## 6. Проверка в Firebase Console

1. Перейти в **Firebase Console** → ваш проект
2. Раздел **Cloud Functions**
3. Проверить статус функции `onNewMessage`
4. Вкладка **Logs** для просмотра ошибок

## Альтернатива: Supabase Edge Function

Если вы хотите использовать Supabase Edge Function вместо Firebase Cloud Function, вот версия на Deno/TypeScript:

### `supabase/functions/notify-on-message/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { JWT } from "https://esm.sh/google-auth-library@9";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FIREBASE_SERVICE_ACCOUNT = JSON.parse(
  Deno.env.get("FIREBASE_SERVICE_ACCOUNT") || "{}"
);

serve(async (req) => {
  try {
    // Парсим данные из Firestore триггера
    const { message, chat_id } = await req.json();

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Получаем FCM токен получателя
    const { data: receiverProfile, error } = await supabase
      .from("profiles")
      .select("fcm_token, display_name")
      .eq("id", message.receiver_id)
      .single();

    if (error || !receiverProfile?.fcm_token) {
      console.error("FCM Token not found for user:", message.receiver_id);
      return new Response(
        JSON.stringify({ error: "No FCM token found" }),
        { status: 404 }
      );
    }

    // Получаем имя отправителя
    const { data: senderProfile } = await supabase
      .from("profiles")
      .select("display_name")
      .eq("id", message.sender_id)
      .single();

    const accessToken = await getGoogleAccessToken();

    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${FIREBASE_SERVICE_ACCOUNT.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: receiverProfile.fcm_token,
            notification: {
              title: senderProfile?.display_name || "New Message",
              body: message.text.substring(0, 150),
            },
            data: {
              chat_id: chat_id,
              sender_id: message.sender_id,
              sender_name: senderProfile?.display_name || "Unknown",
              message_body: message.text,
              timestamp: Date.now().toString(),
            },
          },
        }),
      }
    );

    const result = await response.json();
    console.log("FCM Result:", result);

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error in notify-on-message:", err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
    });
  }
});

async function getGoogleAccessToken() {
  const client = new JWT({
    email: FIREBASE_SERVICE_ACCOUNT.client_email,
    key: FIREBASE_SERVICE_ACCOUNT.private_key,
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });
  const res = await client.getAccessToken();
  return res.token;
}
```

Разверните в Supabase:

```bash
supabase functions deploy notify-on-message
```

## Важные замечания

### Почему нельзя использовать старый Firebase Cloud Messaging API?

- **Deprecated Server Key**: Старый `Server Key` (Desktop) больше не поддерживается
- **OAuth2 обязателен**: Все отправки должны использовать `Bearer $ACCESS_TOKEN`
- **Service Account**: Используйте JSON с приватным ключом для получения токена

### Безопасность

1. **FCM токены нельзя хранить в открытом виде** → Используйте Firestore Rules
2. **Service Account JSON → НИКОГДА не коммитьте в Git** → Используйте переменные окружения
3. **Правила Firestore** должны запретить чтение/запись непроверенных пользователей

### Оптимизация

- Используйте **batching** если отправляете много уведомлений одновременно
- **Exponential backoff** для повторных попыток при ошибке
- **Rate limiting** в Firestore Rules чтобы избежать spam
