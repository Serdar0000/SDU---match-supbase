# Структура Payload и Deep Linking для Push-уведомлений

## Поток уведомления от сервера к приложению

```
1. Сервер (Cloud Function) отправляет:
   {
     "message": {
       "token": "FCM_TOKEN",
       "notification": {
         "title": "Имя пользователя",
         "body": "Текст сообщения"
       },
       "data": {
         "chat_id": "abc123",
         "sender_id": "user456",
         "sender_name": "Алиса",
         "message_body": "Привет!",
         "timestamp": "1709876543000"
       }
     }
   }

2. Firebase Cloud Messaging отправляет уведомление в FCM
3. FCM доставляет на устройство
4. Flutter приложение обрабатывает разными способами:
   - Terminated → onBackgroundMessage (в main.dart)
   - Foreground → onMessage (в PushNotificationService)
   - Paused → onMessageOpenedApp (в PushNotificationService)
```

## Payload структура

### Notification (видимая часть уведомления)

```dart
{
  "title": "Алиса",           // Имя отправителя
  "body": "Привет!",          // Первые 150 символов сообщения
  "imageUrl": "https://..."   // URL аватара отправителя (опционально)
}
```

> **Примечание**: Notification НЕ используется для deep linking. Это просто видимая часть.

### Data (скрытая часть, используется для навигации)

```dart
{
  "chat_id": "abc123",              // Идентификатор чата (ОБЯЗАТЕЛЬНО)
  "sender_id": "user456",           // ID отправителя
  "sender_name": "Алиса",           // Имя для UI
  "message_body": "Привет!",        // Полное сообщение
  "timestamp": "1709876543000",     // Время отправки
  "notification_type": "message",   // Тип уведомления (для масштабирования)
  "image_url": "https://..."        // URL прикреплённого изображения
}
```

## Как работает навигация при клике

### Состояние Foreground (приложение активно)
```
1. Приложение в фокусе
2. Уведомление приходит в onMessage
3. PushNotificationService показывает локальное уведомление
4. Пользователь кликает → _onNotificationTapped
5. Парсим payload из локального уведомления
6. Вызываем _navigateToChat(data)
7. Используем GoRouter.push('/chat/{chatId}')
```

### Состояние Paused (приложение свёрнуто)
```
1. Приложение в фоне (процесс живой)
2. Уведомление приходит в onMessageOpenedApp
3. Пользователь кликает на уведомление нативно
4. _handleNotificationClick вызывается с RemoteMessage
5. Извлекаём chat_id из message.data
6. Вызываем _navigateToChat(message.data)
7. Используем GoRouter.push('/chat/{chatId}')
```

### Состояние Terminated (приложение полностью закрыто)
```
1. Приложение закрыто (процесс завершён)
2. Пользователь кликает на уведомление в шторке
3. Срабатывает onBackgroundMessage (в отдельном isolate)
4. Логируем данные уведомления
5. При запуске приложения → checkForInitialMessage()
6. Если уведомление было, параметры передаются в main app
7. Приложение переходит в чат при инициализации
```

## Реализация Deep Linking

### 1. Добавить обработчик инициального уведомления в main.dart

```dart
// В _AppWithSettingsState добавить:

@override
void initState() {
  super.initState();
  _checkInitialNotification();
}

/// Проверяем, был ли клик на уведомление до запуска приложения
Future<void> _checkInitialNotification() async {
  try {
    // Получаем уведомление, которое запустило приложение
    RemoteMessage? initialMessage = 
      await FirebaseMessaging.instance.getInitialMessage();
    
    if (initialMessage != null) {
      _navigateFromNotification(initialMessage.data);
    }
  } catch (e) {
    debugPrint('Error checking initial notification: $e');
  }
}

/// Навигируем на основе данных уведомления
void _navigateFromNotification(Map<String, dynamic> data) {
  debugPrint('🔗 Processing initial notification data: $data');
  
  final chatId = data['chat_id'] as String? ?? '';
  final senderId = data['sender_id'] as String? ?? '';
  
  if (chatId.isEmpty) {
    debugPrint('⚠️ Invalid chat ID in notification');
    return;
  }
  
  // Используем addPostFrameCallback чтобы гарантировать,
  // что дерево UI полностью построено
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && context.mounted) {
      try {
        GoRouter.of(context).push('/chat/$chatId');
        debugPrint('✅ Navigated to chat: $chatId');
      } catch (e) {
        debugPrint('❌ Navigation error: $e');
      }
    }
  });
}
```

### 2. Настроить GoRouter для интеграции с push уведомлениями

```dart
// В app_router.dart

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        
        // Можно также получить дополнительные параметры
        final senderId = state.uri.queryParameters['sender_id'];
        final senderName = state.uri.queryParameters['sender_name'];
        
        return ChatPage(
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
        );
      },
    ),
  ],
);
```

### 3. Android-специфичная настройка (android/app/build.gradle.kts)

```kotlin
// Добавить в android block:
android {
    ...
    defaultConfig {
        ...
        // Для Firebase Dynamic Links и Deep Linking
        manifestPlaceholders["firebaseDomain"] = "your-app.firebaseapp.com"
    }
}
```

### 4. iOS-специфичная настройка (ios/Runner/Info.plist)

```xml
<dict>
    ...
    <!-- URL Schemes для Deep Linking -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>sduconnect</string>
            </array>
        </dict>
    </array>
    ...
</dict>
```

## Полный пример обработки уведомлений

### main.dart

```dart
// Глобальный обработчик для Terminated state
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  debugPrint('🔔 Background message received in Terminated state');
  debugPrint('Chat ID: ${message.data['chat_id']}');
  debugPrint('Sender: ${message.data['sender_name']}');
  
  // Здесь можно сохранить данные в локальное хранилище
  // и обработать их при запуске приложения
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // ОБЯЗАТЕЛЬНО регистрируем обработчик ДО инициализации приложения
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // ... остальная инициализация
  
  runApp(const MyApp());
}
```

### push_notification_service.dart

```dart
class PushNotificationService {
  static GoRouter? _goRouter;

  static void setGoRouter(GoRouter router) {
    _goRouter = router;
  }

  Future<void> init() async {
    // Запрос разрешений
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    // Paused state (приложение в фоне)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);
  }

  void _handleForegroundNotification(RemoteMessage message) {
    // Показываем локальное уведомление
    _localNotifications.show(
      notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(...),
    );
  }

  void _handleNotificationClick(RemoteMessage message) {
    _navigateToChat(message.data);
  }

  void _navigateToChat(Map<String, dynamic> data) {
    final chatId = data['chat_id'] as String? ?? '';
    if (chatId.isNotEmpty && _goRouter != null) {
      _goRouter!.push('/chat/$chatId');
    }
  }
}
```

## Схема информационного потока

```
┌─────────────────────────────────────────────────────────────────┐
│                    Пользователь отправляет сообщение            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Cloud Function: onNewMessage срабатывает                        │
│  - Получает sender_id и receiver_id                              │
│  - Получает FCM токен из profiles/{receiver_id}                 │
│  - Формирует payload с chat_id, sender_name, text               │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Firebase Cloud Messaging отправляет уведомление                │
│  - Все data поля → зашифрованы и защищены                       │
│  - notification → видимо в шторке                               │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────┴──────────┐
                    ↓                    ↓
         ┌─────────────────┐   ┌──────────────────┐
         │  APP TERMINATED │   │  APP IN MEMORY   │
         └─────────────────┘   │  (Paused/Running)│
                ↓              └──────────────────┘
                │                      ↓
         Пользователь            Автоматически
         кликает на               обработано
         уведомление             onMessageOpenedApp
                ↓                      ↓
         Запускается          _handleNotificationClick
         приложение               вызывается
                ↓                      ↓
         checkInitialMessage   Извлекаем chat_id
         вызывается               из message.data
                ↓                      ↓
         Получаем chat_id      Вызываем
         из getInitialMessage  _navigateToChat()
                ↓                      ↓
         Если непусто,       GoRouter.push(
         вызываем              '/chat/{chatId}'
         GoRouter.push()           )
                ↓                      ↓
              ┌──────────────────────────┐
              │  ChatPage открывается    │
              │  Отправитель: Алиса      │
              │  Сообщение: "Привет!"    │
              └──────────────────────────┘
```

## Отладка

### Проверить, что FCM токен сохранён

```dart
final pushService = PushNotificationService();
final token = await pushService.getToken();
debugPrint('FCM Token: $token');
```

### Проверить Firestore Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Пользователи могут читать свой профиль
    match /profiles/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
    
    // Сообщения читаемы участниками чата
    match /chats/{chatId}/messages/{messageId} {
      allow read: if isParticipant(chatId);
      allow create: if isParticipant(chatId) && isAuthor();
    }
  }
}

function isParticipant(chatId) {
  return get(/databases/$(database)/documents/chats/$(chatId)).data.participant_ids[request.auth.uid] != null;
}

function isAuthor() {
  return request.resource.data.sender_id == request.auth.uid;
}
```

### Тестирование в Firebase Console

1. Firebase Console → Cloud Messaging
2. Send test message
3. Выбрать FCM токен
4. Заполнить notification и data
5. Отправить и проверить логи
