# 📌 Push Notifications - Quick Reference Card

## 🎯 Ответы на ваши вопросы

### ❓ На что нужно обратить внимание?

#### 1. Почему обработчик должен быть глобальным?

```dart
@pragma('vm:entry-point')  // ← ОБЯЗАТЕЛЬНО!
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Вызывается в ОТДЕЛЬНОМ ISOLATE, не имея доступа к BuildContext
  // Если приложение Terminated, этот код работает отдельно от main app
  // Если сделать это методом класса или локально - Firebase не найдёт её
}
```

**Почему именно top-level:**
- Flutter требует статического входного оборота (__entry point__)
- Нет доступа к виджетам, состоянию, контексту
- Регистрируется ДО инициализации приложения
- Компилятор трохи её удалить нельзя → `@pragma('vm:entry-point')`

---

#### 2. Когда какой обработчик срабатывает?

```dart
// FOREGROUND: Приложение активно на экране
FirebaseMessaging.onMessage.listen((message) {
  // Показать локальное уведомление
  _showLocalNotification(message);
});

// PAUSED: Приложение в фоне (процесс жив)
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  // Пользователь кликнул на уведомление
  _handleNotificationClick(message);
});

// TERMINATED: Приложение закрыто (процесс убит)
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// ↑ Регистрируется в main(), вызывается при клике на уведомление
```

---

#### 3. Как работает Deep Linking?

```
Уведомление приходит с данными:
{
  "chat_id": "abc123",  ← Выкладываем отсюда
  "sender_id": "user456"
}
    ↓
Парсим в handleNotificationClick():
  final chatId = message.data['chat_id'];
    ↓
Используем GoRouter для навигации:
  GoRouter.of(context).push('/chat/$chatId');
    ↓
ChatPage открывается с chat_id
```

---

### ✅ Что уже сделано

```
✅ main.dart - добавлен @pragma('vm:entry-point') обработчик
✅ PushNotificationService - все три состояния обработаны
✅ Firebase Cloud Function - готов к деплою
✅ Payload структура - with chat_id for deep linking
✅ iOS docs - полный гайд для APNs
✅ Android - всё работает из коробки (почти)
```

---

### 🚀 Что делать дальше

#### ДЛЯ НЕМЕДЛЕННОГО ЗАПУСКА:

```bash
# 1. Развернуть Cloud Function
cd firebase-functions
npm install
firebase deploy --only functions

# 2. Проверить Firestore структура:
#    /chats/{chatId}/messages/{messageId}
#    /profiles/{userId}.fcm_token

# 3. Запустить на реальном устройстве
flutter run -d <device>

# 4. Проверить в консоли
# 💾 FCM Token obtained: ...
# ✅ FCM Token saved to Supabase
```

#### ЕСЛИ iOS:

```bash
# 1. Открыть проект в Xcode
open ios/Runner.xcworkspace

# 2. Добавить Capabilities:
# - Push Notifications
# - Background Modes > Remote Notification

# 3. Загрузить APNs сертификат в Firebase Console
# (см. iOS_APNs_CONFIGURATION.md)

# 4. Вкладыш: ios/Runner/Info.plist
<key>FirebaseAppDelegateProxyEnabled</key>
<true/>
```

---

### 🔍 Отладка

#### Проверить что FCM токен получен
```dart
// Где-нибудь в коде
final pushService = PushNotificationService();
final token = await pushService.getToken();
print('FCM Token: $token');
```

#### Проверить логи Firebase Functions
```bash
firebase functions:log --tail
```

#### Если уведомление не приходит
1. ✅ Проверить permission дан (alert, sound, badge)
2. ✅ Проверить FCM токен сохранён в profiles
3. ✅ Проверить Cloud Function развёрнут
4. ✅ Проверить Firestore правила позволяют читать/писать
5. ✅ Проверить что используется РЕАЛЬНОЕ устройство (не эмулятор)
6. ✅ Очистить кэш: `flutter clean`

---

### 📊 Структура данных

#### Что отправляет Cloud Function:
```typescript
{
  message: {
    token: fcmToken,           // Токен получателя
    notification: {
      title: "Alice",          // Отправитель
      body: "Hello!"           // Сообщение (первые 150 символов)
    },
    data: {
      chat_id: "abc123",       // ← Для навигации!
      sender_id: "user456",
      sender_name: "Alice",
      message_body: "Hello!",
      timestamp: "1709876543000"
    }
  }
}
```

#### Где сохранять данные:
```
Firestore:
├── profiles/{userId}
│   ├── display_name: "Alice"
│   ├── fcm_token: "ExponentPushToken[...]"  ← Обновляется приложением
│   └── ...
├── chats/{chatId}
│   ├── participants: ["user1", "user2"]
│   └── messages/{messageId}
│       ├── sender_id: "user1"
│       ├── receiver_id: "user2"
│       ├── text: "Hello!"
│       ├── created_at: Timestamp
│       └── ...
└── ...
```

---

### 🎓 Почему Firebase Admin SDK, а не REST API?

**Преимущества Admin SDK:**
- ✅ Автоматическая обработка ошибок
- ✅ Retry логика встроена
- ✅ Типизация (TypeScript)
- ✅ OAuth2 токены генерируются автоматически
- ✅ Service Account управляется Firebase

**Если REST API:**
```bash
# Нужно самому генерировать OAuth2 токены
curl -X POST "https://oauth2.googleapis.com/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=..."
# Потом использовать токен для каждого запроса
```

**Вывод:** Admin SDK проще и надёжнее 👍

---

### 📚 Расширенные возможности (опционально)

#### Отправить уведомление нескольким пользователям
```typescript
// Cloud Function может отправить в топик вместо конкретного токена
const message = {
  notification: { title, body },
  data: payload,
  topic: 'chat_abc123'  // Все в чате подписаны на этот топик
};
await admin.messaging().send(message);
```

#### Планированные уведомления
```typescript
// Отправить уведомление через 1 час
setTimeout(() => {
  sendMessageNotification(messageData, chatId);
}, 60 * 60 * 1000);
```

#### Много-язычные уведомления
```typescript
const messages = {
  'ru': { title: 'Новое сообщение', body: '...' },
  'en': { title: 'New message', body: '...' }
};
// Получить язык пользователя из profiles.language
```

---

## 🎉 Вы готовы!

1. ✅ Код написан
2. ✅ Functions готовы
3. ✅ Документация подробная
4. ✅ Примеры есть

**Остаётся:**
1. Развернуть Functions
2. Настроить iOS (если нужен iOS)
3. Тестировать на реальном устройстве

**Удачи!** 🚀
