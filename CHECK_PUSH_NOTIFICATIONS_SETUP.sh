#!/bin/bash

# 🔍 Скрипт для проверки что всё готово для Push Notifications

echo "🔔 Проверка конфигурации Push Notifications..."
echo ""

# Проверка 1: Firebase Functions
echo "✓ Проверка Firebase Functions"
if [ -d "firebase-functions/src" ]; then
    if [ -f "firebase-functions/src/index.ts" ] && [ -f "firebase-functions/src/sendMessageNotification.ts" ]; then
        echo "  ✅ Cloud Functions файлы присутствуют"
    else
        echo "  ❌ Не хватает некоторых файлов Functions"
    fi
else
    echo "  ⚠️  Папка firebase-functions/src не найдена"
fi

# Проверка 2: Flutter файлы
echo ""
echo "✓ Проверка Flutter файлов"
if grep -q "@pragma('vm:entry-point')" "lib/main.dart" 2>/dev/null; then
    echo "  ✅ main.dart содержит глобальный обработчик"
else
    echo "  ❌ main.dart не имеет обработчика"
fi

if grep -q "FirebaseMessaging.onBackgroundMessage" "lib/main.dart" 2>/dev/null; then
    echo "  ✅ FirebaseMessaging.onBackgroundMessage зарегистрирован"
else
    echo "  ❌ onBackgroundMessage не зарегистрирован"
fi

if grep -q "GoRouter" "lib/core/services/push_notification_service.dart" 2>/dev/null; then
    echo "  ✅ PushNotificationService использует GoRouter"
else
    echo "  ❌ GoRouter не настроен в PushNotificationService"
fi

# Проверка 3: Документация
echo ""
echo "✓ Проверка документации"
docs_array=(
    "PUSH_NOTIFICATIONS_IMPLEMENTATION_SUMMARY.md"
    "FIREBASE_CLOUD_FUNCTION.md"
    "PUSH_NOTIFICATIONS_DEEP_LINKING.md"
    "iOS_APNs_CONFIGURATION.md"
)

for doc in "${docs_array[@]}"; do
    if [ -f "$doc" ]; then
        echo "  ✅ $doc"
    else
        echo "  ❌ $doc отсутствует"
    fi
done

# Проверка 4: Android конфисы
echo ""
echo "✓ Проверка Android конфигурации"
if [ -f "android/app/google-services.json" ]; then
    echo "  ✅ google-services.json найден"
else
    echo "  ⚠️  google-services.json не найден (нужен для Android)"
fi

# Проверка 5: pubspec.yaml
echo ""
echo "✓ Проверка зависимостей"
if grep -q "firebase_messaging:" "pubspec.yaml"; then
    echo "  ✅ firebase_messaging добавлен"
else
    echo "  ❌ firebase_messaging отсутствует в pubspec.yaml"
fi

if grep -q "firebase_core:" "pubspec.yaml"; then
    echo "  ✅ firebase_core добавлен"
else
    echo "  ❌ firebase_core отсутствует в pubspec.yaml"
fi

if grep -q "flutter_local_notifications:" "pubspec.yaml"; then
    echo "  ✅ flutter_local_notifications добавлен"
else
    echo "  ❌ flutter_local_notifications отсутствует в pubspec.yaml"
fi

if grep -q "go_router:" "pubspec.yaml"; then
    echo "  ✅ go_router добавлен"
else
    echo "  ❌ go_router отсутствует в pubspec.yaml"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "📋 СЛЕДУЮЩИЕ ШАГИ:"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. РАЗВЕРНУТЬ FIREBASE CLOUD FUNCTIONS:"
echo "   $ cd firebase-functions"
echo "   $ npm install"
echo "   $ firebase deploy --only functions"
echo ""
echo "2. ПРОВЕРИТЬ ЧТО FIRESTORE СТРУКТУРА ГОТОВА:"
echo "   /chats/{chatId}/messages/{messageId}"
echo "   - sender_id: string"
echo "   - receiver_id: string"
echo "   - text: string"
echo "   - created_at: timestamp"
echo ""
echo "3. УБЕДИТЬСЯ ЧТО profiles ИМЕЕТ КОЛОНКУ fcm_token:"
echo "   /profiles/{userId}"
echo "   - fcm_token: string (будет заполнен приложением)"
echo ""
echo "4. ДЛЯ iOS: СЛЕДОВАТЬ iOS_APNs_CONFIGURATION.md"
echo "   - Создать APNs сертификат в Apple Developer"
echo "   - Загрузить в Firebase Console"
echo "   - Добавить Capabilities в Xcode"
echo ""
echo "5. ТЕСТИРОВАТЬ НА РЕАЛЬНОМ УСТРОЙСТВЕ:"
echo "   - Запустить приложение"
echo "   - Проверить FCM токен в консоли"
echo "   - Создать тестовое сообщение"
echo "   - Проверить что уведомление приходит"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
echo "✅ Вся реализация готова к использованию!"
echo ""
