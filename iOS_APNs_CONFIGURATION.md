# iOS Configuration для Push-уведомлений и APNs

## Обзор процесса

iOS использует **Apple Push Notification service (APNs)** для доставки уведомлений. Firebase использует APNs как транспорт для iOS.

```
Приложение (Flutter)
        ↓
Firebase Cloud Messaging
        ↓
APNs (Apple Push Notification service)
        ↓
iOS Device
```

## Шаг 1: Создание Certificate в Apple Developer

### 1.1 Перейти в Apple Developer

1. Перейти на [https://developer.apple.com](https://developer.apple.com)
2. Войти в свой аккаунт Apple Developer
3. Перейти в **Certificates, Identifiers & Profiles** → **Certificates**

### 1.2 Создать новый сертификат для Push Notifications

1. Нажать **+** для создания нового сертификата
2. Выбрать **Apple Push Notification service SSL (Sandbox & Production)**
3. Нажать **Continue**
4. Выбрать Bundle ID вашего приложения (например: `com.sdu.match`)
   - Если его нет, создайте в **Identifiers** → **App IDs**
5. Нажать **Continue**
6. Выбрать CSR файл (Certificate Signing Request)
   - Если нет CSR, нужно создать его:
     - Открыть **Keychain Access** на Mac
     - **Keychain Access** → **Certificate Assistant** → **Request a Certificate from a Certificate Authority**
     - Заполнить email и common name
     - Выбрать *Saved to disk*
     - Сохранить файл
7. Нажать **Continue** и скачать сертификат (файл `.cer`)
8. Дважды щёлкнуть на файле `.cer` чтобы добавить его в Keychain

### 1.3 Экспортировать сертификат в формат .p8

> **Важно**: Firebase требует формат `.p8` (private key), а не `.cer` файл

1. Открыть **Keychain Access** на Mac
2. Найти сертификат Push Notification
3. Кликнуть правой кнопкой → **Export**
4. Сохранить в формате **Personal Information Exchange (.p12)**
5. Установить пароль (запомнить его)
6. Выполнить в терминале:
   ```bash
   openssl pkcs12 -in Certificates.p12 -nocerts -nodes -out key.pem
   ```
7. Файл `key.pem` готов для Firebase

## Шаг 2: Загрузить сертификат в Firebase Console

### 2.1 Перейти в Firebase Console

1. Открыть [Firebase Console](https://console.firebase.google.com)
2. Выбрать ваш проект
3. Перейти в **Project Settings** (иконка шестарика)
4. Вкладка **Cloud Messaging**

### 2.2 Загрузить APNs сертификат

1. В разделе **APNs certificates** нажать **Upload**
2. Выбрать файл `.p8` (или `.key`)
3. Ввести:
   - **Key ID** (можно найти в Apple Developer → Certificates)
   - **Team ID** (ваш Apple Team ID)
4. Нажать **Upload**

Если используете `.p12`:
1. Нажать на трёхточку → **Edit**
2. Загрузить сертификат `.p12`
3. Ввести пароль, установленный при экспорте

## Шаг 3: Настроить Xcode Capabilities

### 3.1 Открыть проект в Xcode

```bash
cd ios
open Runner.xcworkspace  # ВАЖНО: .xcworkspace, а не .xcodeproj!
```

### 3.2 Добавить Push Notifications Capability

1. Выбрать **Runner** в левой панели
2. Выбрать **Signing & Capabilities**
3. Нажать **+ Capability**
4. Поиск и выбрать **Push Notifications**
5. Убедиться, что **Development Team** установлена правильно

### 3.3 Добавить Background Modes Capability

1. Нажать снова **+ Capability**
2. Выбрать **Background Modes**
3. Установить галочки:
   - ✅ **Remote Notification** (для фоновых уведомлений)
   - ✅ **Background Fetch** (для получения данных)
   - ✅ **VoIP** (опционально для звонков)

**Результат в Info.plist:**

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>fetch</string>
</array>
```

## Шаг 4: Настроить Info.plist

### 4.1 Открыть ios/Runner/Info.plist

Добавить эти ключи:

```xml
<!-- Push Notifications -->
<key>FirebaseAppDelegateProxyEnabled</key>
<true/>

<key>FirebaseDeepLinkingEnabled</key>
<true/>

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
```

### 4.2 Если не используется SwiftUI Delegate

**ios/Runner/GeneratedPluginRegistrant.swift** должен содержать:

```swift
import Firebase

// Firebase уже инициализируется через plugin registry
// Провайдер flutter_local_notifications должен быть зарегистрирован
```

## Шаг 5: Настроить iOS Runner (AppDelegate)

### 5.1 Если используется Swift (ios/Runner/GeneratedPluginRegistrant.swift)

Обычно Firebase плагин уже настроен. Но убедитесь, что в **ios/Runner/Info.plist** присутствует:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<true/>
```

Это автоматически:
- Регистрирует обработчик APNs
- Перехватывает пуш-уведомления
- Передаёт их в Flutter через native channel

### 5.2 Если нужна ручная настройка (ios/Runner/GeneratedPluginRegistrant.h)

```swift
// ios/Runner/GeneratedPluginRegistrant.swift

import UIKit
import Firebase

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  // Firebase инициализируется автоматически благодаря FirebaseAppDelegateProxyEnabled
  
  // Регистрируем обработчик UNUserNotificationCenter для локальных уведомлений
  UNUserNotificationCenter.current().delegate = self
  
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

// Обработчик уведомлений в Foreground
@available(iOS 10.0, *)
func userNotificationCenter(
  _ center: UNUserNotificationCenter,
  willPresent notification: UNNotification,
  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
) {
  // Показываем alert даже когда приложение в фокусе
  completionHandler([.banner, .badge, .sound])
}
```

## Шаг 6: Тестирование APNs

### 6.1 Проверить сертификат в Terminal

```bash
# Проверить, что сертификат валиден
openssl s_client -connect api.sandbox.push.apple.com:2195 -cert Certificates.pem -key key.pem

# Должно вывести: "Verify return code: 0 (ok)"
```

### 6.2 Проверить в Xcode

1. **Xcode** → **Window** → **Devices and Simulators**
2. Выбрать ваше устройство
3. Нажать **Install App**
4. Выбрать ваше приложение (`.app` файл)
5. Если установилось успешно, добавить логирование в код

### 6.3 Добавить логирование в ios/Runner/GeneratedPluginRegistrant.swift

```swift
// После инициализации Firebase
UNUserNotificationCenter.current().getNotificationSettings { settings in
    print("Notification Settings: \(settings)")
    print("Authorization Status: \(settings.authorizationStatus.rawValue)")
}
```

## Шаг 7: Проверить в Firebase Console

### 7.1 Отправить тестовое уведомление

1. **Firebase Console** → **Cloud Messaging**
2. Нажать **Send your first message**
3. Заполнить:
   - Title: "Тест"
   - Body: "Тестовое уведомление"
4. Нажать **Next**
5. Выбрать **Send to specific topics** или **Send to a single device**
6. Если по device: ввести FCM токен (логируется в консоль Flutter)
7. Нажать **Send**

### 7.2 Проверить логи

В Flutter console должны быть логи:
```
✅ Notification permission status: AuthorizationStatus.authorized
💾 FCM Token obtained: ...
✅ FCM Token saved to Supabase
```

## Настройка для Production

### Для App Store (Production сертификат)

1. Создать **новый** сертификат в Apple Developer:
   - **Apple Push Notification service SSL (Production)**
   - Выполнить те же шаги что для Sandbox
   - Экспортировать в `.p8`

2. В Firebase Console:
   - Загрузить **отдельно** production сертификат
   - Обычно система автоматически использует нужный

### Для TestFlight

- Используется **Production** сертификат APNs
- Но отправляет через **Sandbox** серверы Apple
- Firebase обычно справляется автоматически

## Troubleshooting

### Проблема: APNs не отправляет уведомления

**Решение:**
1. Проверить сертификат в Firebase Console - дата истечения
2. Проверить Bundle ID совпадает с сертификатом
3. Проверить, что приложение установлено на реальное устройство (не симулятор)
4. Симулятор может не получать APNs уведомления

### Проблема: Permission denied при экспорте сертификата

**Решение:**
```bash
sudo openssl pkcs12 -in Certificates.p12 -nocerts -nodes -out key.pem
```

### Проблема: "FirebaseAppDelegateProxyEnabled is disabled"

**Решение:**
1. Открыть **ios/Runner/Info.plist**
2. Добавить:
   ```xml
   <key>FirebaseAppDelegateProxyEnabled</key>
   <true/>
   ```
3. Очистить build: `flutter clean` и заново собрать

### Проблема: Уведомления не приходят в Terminated state

**Проверить:**
1. ✅ Background Modes → Remote Notification включено
2. ✅ FirebaseAppDelegateProxyEnabled установлено в true
3. ✅ onBackgroundMessage зарегистрирован в main.dart
4. ✅ Устройство подключено по сети (WiFi или cellular)
5. ✅ Device Token обновлён после переустановки

### Проблема: "Invalid APNs certificate in Firebase Console"

**Решение:**
1. Проверить формат файла:
   - Должен быть `.p8` или `.p12`
   - НЕ `.cer` файл
2. Переэкспортировать с правильными параметрами
3. Убедиться что сертификат не истёк

## Итоговая checklist для iOS

- ✅ APNs сертификат создан в Apple Developer
- ✅ Сертификат загружен в Firebase Console
- ✅ Xcode: Push Notifications capability добавлена
- ✅ Xcode: Background Modes → Remote Notification включено
- ✅ ios/Runner/Info.plist содержит FirebaseAppDelegateProxyEnabled = true
- ✅ main.dart содержит FirebaseMessaging.onBackgroundMessage регистрацию
- ✅ PushNotificationService содержит обработчики onMessage и onMessageOpenedApp
- ✅ iOS приложение установлено на реальное устройство (НЕ симулятор)
- ✅ FCM токен получен и сохранён в базе
- ✅ Тестовое уведомление отправлено через Firebase Console

## Дополнительные ресурсы

- [Firebase iOS Setup](https://firebase.google.com/docs/cloud-messaging/ios/certs)
- [Apple APNs Provider API](https://developer.apple.com/documentation/usernotifications)
- [Flutter Firebase Messaging](https://firebase.flutter.dev/docs/messaging/overview/)
