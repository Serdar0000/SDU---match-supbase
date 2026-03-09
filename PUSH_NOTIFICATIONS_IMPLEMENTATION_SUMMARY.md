# 🔔 Push Notifications Implementation Guide - SDU Match

## Краткое резюме

Я подготовил **полную реализацию push-уведомлений** для вашего Flutter приложения:

1. ✅ **Flutter код** обновлен для обработки всех состояний (Foreground, Paused, Terminated)
2. ✅ **Firebase Cloud Functions** готов для отправки уведомлений при новых сообщениях
3. ✅ **Deep Linking** настроен - клик на уведомление открывает конкретный чат
4. ✅ **iOS APNs** полный гайд для работы на iOS
5. ✅ **Firestore триггер** автоматически отправляет уведомления получателю

---

## 📋 Файлы которые обновлены/созданы

### Flutter код

| Файл | Описание | Статус |
|------|---------|--------|
| [lib/main.dart](lib/main.dart#L17) | Глобальный обработчик фоновых уведомлений | ✅ Обновлён |
| [lib/core/services/push_notification_service.dart](lib/core/services/push_notification_service.dart) | Сервис для обработки всех состояний | ✅ Обновлён |

### Документация

| Файл | Описание |
|------|---------|
| [FIREBASE_CLOUD_FUNCTION.md](FIREBASE_CLOUD_FUNCTION.md) | Полный гайд Firebase Cloud Functions |
| [PUSH_NOTIFICATIONS_DEEP_LINKING.md](PUSH_NOTIFICATIONS_DEEP_LINKING.md) | Payload структура и навигация |
| [iOS_APNs_CONFIGURATION.md](iOS_APNs_CONFIGURATION.md) | iOS настройка шаг за шагом |

### Firebase Functions

| Файл | Назначение |
|------|-----------|
| [firebase-functions/src/index.ts](firebase-functions/src/index.ts) | Главная функция с Firestore триггером |
| [firebase-functions/src/sendMessageNotification.ts](firebase-functions/src/sendMessageNotification.ts) | Логика отправки уведомлений |
| [firebase-functions/package.json](firebase-functions/package.json) | Зависимости Node.js |
| [firebase-functions/tsconfig.json](firebase-functions/tsconfig.json) | TypeScript конфиг |

---

## 🚀 Как это работает

### Архитектура потока

```
Пользователь отправляет сообщение в Firestore
           ↓
Cloud Function: onNewMessage срабатывает
           ↓
Получаем FCM токен получателя из profiles/{userId}
           ↓
Отправляем через Firebase Admin SDK (OAuth2)
           ↓
Firebase Cloud Messaging доставляет в FCM
           ↓
На устройстве обрабатывается в зависимости от состояния:
           ↓
┌─────────────────────────────────────────┐
│   СОСТОЯНИЕ     │     ОБРАБОТЧИК        │
├─────────────────────────────────────────┤
│ Foreground      → onMessage              │
│ Paused          → onMessageOpenedApp     │
│ Terminated      → onBackgroundMessage    │
└─────────────────────────────────────────┘
           ↓
Deep linking через GoRouter
           ↓
ChatPage открывается с данными отправителя
```

### Логика в коде

**main.dart** (глобальный обработчик):
```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Вызывается в отдельном isolate когда приложение Terminated
  // ОБЯЗАТЕЛЬНО top-level функция, так как нет доступа к состоянию приложения
  await Firebase.initializeApp();
  // Логирование данных
}
```

**PushNotificationService** (обробка всех состояний):
- `_handleForegroundNotification()` - показывает локальное уведомление
- `_handleNotificationClick()` - обработка клика в Paused state
- `_onNotificationTapped()` - обработка клика на локальное уведомление
- `_navigateToChat()` - deep linking в конкретный чат

---

## 🔧 Пошаговая инструкция внедрения

### Шаг 1: Проверить Firebase Cloud Function готов

```bash
# 1. Перейти в папку функций
cd firebase-functions

# 2. Установить зависимости
npm install

# 3. Тестировать локально (опционально)
npm start

# 4. Развернуть в Firebase
npm run deploy
```

**Результат:**
- Функция `onNewMessage` срабатывает при создании документа в `/chats/{chatId}/messages/{messageId}`
- Автоматически отправляет уведомление получателю

### Шаг 2: Убедиться что код Flutter обновлён

✅ Уже обновлены:
- `lib/main.dart` - регистрация `onBackgroundMessage`
- `lib/core/services/push_notification_service.dart` - все обработчики

**Что нужно проверить:**
1. Импорты `firebase_messaging` и `go_router` присутствуют
2. `PushNotificationService.setGoRouter()` вызывается в main.dart
3. GoRouter настроен с маршрутом `/chat/:chatId`

### Шаг 3: Настроить Android

**android/app/build.gradle.kts:**
```kotlin
android {
    defaultConfig {
        // Уже заполнено в вашем проекте
        applicationId = "com.sdu.match"
    }
}
```

**Тестирование:**
```bash
flutter run -d <android-device-id>
# Проверить в логах что FCM токен получен
```

### Шаг 4: Настроить iOS (⚠️ Важно!)

1. **Создать APNs сертификат в Apple Developer**
   - Перейти на https://developer.apple.com
   - Certificates → Create new → Apple Push Notification service SSL (Sandbox & Production)
   - Скачать файл

2. **Загрузить в Firebase Console**
   - Firebase Console → Project Settings → Cloud Messaging
   - APNs certificates → Upload
   - Выбрать файл `.p8` или `.p12`

3. **Настроить Xcode**
   - `open ios/Runner.xcworkspace`
   - Runner → Signing & Capabilities
   - Add Capability → Push Notifications
   - Add Capability → Background Modes → Remote Notification

4. **Добавить в ios/Runner/Info.plist**
   ```xml
   <key>FirebaseAppDelegateProxyEnabled</key>
   <true/>
   ```

5. **Тестирование**
   ```bash
   flutter run -d <ios-device-id>
   # Проверить что FCM токен получен
   ```

### Шаг 5: Проверить Firestore Rules

Убедиться что приложение может читать/писать в нужные коллекции:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Профили - только свой профиль доступен
    match /profiles/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
    
    // Сообщения - участники чата могут читать
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if isParticipant(chatId);
    }
  }
  
  function isParticipant(chatId) {
    return request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
  }
}
```

---

## 🧪 Тестирование

### Тест 1: Приложение в Foreground

1. Запустить приложение
2. Отправить тестовое уведомление через Firebase Console
3. ✅ Должно появиться локальное уведомление

**Ожидаемый результат:**
- Видно название отправителя
- Видно текст сообщения
- Звук и вибрация работают

### Тест 2: Приложение в Paused (свёрнуто)

1. Запустить приложение и перейти домой (App Switcher)
2. Отправить уведомление
3. Кликнуть на уведомление в шторке
4. ✅ Должно открыться приложение и перейти в чат

**Ожидаемый результат:**
- `onMessageOpenedApp` вызовется
- Deep linking срабатит
- Откроется ChatPage с chatId из уведомления

### Тест 3: Приложение в Terminated (полностью закрыто)

1. Запустить приложение
2. Полностью закрыть (iOS: свайп вверх, Android: Back)
3. Отправить уведомление
4. Кликнуть на уведомление в шторке
5. ✅ Должно запуститься приложение и перейти в чат

**Ожидаемый результат:**
- `onBackgroundMessage` вызовется (видно в логах)
- Приложение запустится
- Deep linking срабатит
- Откроется ChatPage

### Отладка: Проверить FCM токен

```dart
// В какой-то странице добавить:
final pushService = PushNotificationService();
final token = await pushService.getToken();
debugPrint('FCM Token: $token');

// Сохранённый токен должен быть в Firestore
// profiles/{userId}.fcm_token
```

### Отладка: Проверить Firebase Logs

```bash
# Просмотреть логи functions
firebase functions:log

# Или в Firebase Console:
# Cloud Functions → onNewMessage → Logs
```

---

## 📊 Payload структура

### Что отправляет Firebase Cloud Function:

```json
{
  "message": {
    "token": "FCM_TOKEN_RECEIVER",
    "notification": {
      "title": "Имя отправителя",
      "body": "Текст сообщения"
    },
    "data": {
      "chat_id": "abc123def456",
      "sender_id": "user123",
      "sender_name": "Alice",
      "message_body": "Полный текст сообщения",
      "timestamp": "1709876543000"
    }
  }
}
```

### Как мы это парсим:

```dart
// Из data достаём chat_id для навигации
final chatId = message.data['chat_id'];
// Используем GoRouter для перехода
GoRouter.of(context).push('/chat/$chatId');
```

---

## 🚨 Частые проблемы и решения

### ❌ "FCM Token not saved"
- Проверить что `SupabaseService.saveFcmToken()` работает
- Проверить что таблица `profiles` имеет колонку `fcm_token`
- Проверить Firestore Rules доступны для записи

### ❌ "No FCM token for receiver"
- Получатель не запускал приложение с разрешением на уведомления
- Токен истёк (обновляется автоматически при каждом запуске)
- Профиль получателя не существует в базе

### ❌ "Notification не приходит"
- Android: проверить что разрешения даны
- iOS: проверить что APNs сертификат загружен в Firebase
- Проверить что приложение установлено на реальное устройство (НЕ симулятор)

### ❌ "onBackgroundMessage не вызывается"
- Функция ДОЛЖНА быть `@pragma('vm:entry-point')` и `top-level`
- Она регистрируется ДО инициализации приложения
- Требует реального устройства (НЕ эмулятор)
- Требует подключение по сети

---

## 📚 Что почитать дальше

1. **[PUSH_NOTIFICATIONS_DEEP_LINKING.md](PUSH_NOTIFICATIONS_DEEP_LINKING.md)** - для понимания payload структуры
2. **[FIREBASE_CLOUD_FUNCTION.md](FIREBASE_CLOUD_FUNCTION.md)** - для деплоя функций
3. **[iOS_APNs_CONFIGURATION.md](iOS_APNs_CONFIGURATION.md)** - для iOS настроек

---

## ✅ Финальная Checklist

- [ ] Firebase Cloud Function развёрнут (`firebase deploy --only functions`)
- [ ] `lib/main.dart` обновлён с `@pragma('vm:entry-point')` обработчиком
- [ ] `PushNotificationService` инициализирован в main()
- [ ] `PushNotificationService.setGoRouter()` вызывается в app widget
- [ ] Android: приложение установлено на реальное устройство
- [ ] iOS: APNs сертификат загружен в Firebase
- [ ] iOS: Xcode Push Notifications capability добавлена
- [ ] iOS: Background Modes → Remote Notification включено
- [ ] iOS: `ios/Runner/Info.plist` содержит `FirebaseAppDelegateProxyEnabled = true`
- [ ] FCM токен получен и сохранён в profiles/{userId}.fcm_token
- [ ] Тестовое уведомление отправлено и получено в app

---

## 🎯 Следующие шаги

1. **Развернуть Cloud Functions:**
   ```bash
   cd firebase-functions
   npm install
   firebase deploy --only functions
   ```

2. **Протестировать на реальном устройстве:**
   - iOS или Android
   - Запустить приложение
   - Проверить что FCM токен в логах

3. **Отправить тестовое уведомление:**
   - Через Firebase Console
   - Или создав сообщение в Firestore

4. **Проверить все три состояния:**
   - Foreground
   - Paused
   - Terminated

Удачи! 🚀
