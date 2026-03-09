import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'supabase_service.dart';

class PushNotificationService {
  static GoRouter? _goRouter;
  
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Установить GoRouter для навигации при обработке уведомлений
  static void setGoRouter(GoRouter goRouter) {
    _goRouter = goRouter;
    debugPrint('✅ GoRouter set in PushNotificationService');
  }

  Future<void> init() async {
    // Запрос разрешений (обязательно для iOS и Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
    );

    debugPrint(
        '🔔 Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Получаем токен и сохраняем его в Supabase
      String? token = await _fcm.getToken();
      if (token != null) {
        debugPrint('💾 FCM Token obtained: ${token.substring(0, 20)}...');
        try {
          await GetIt.I<SupabaseService>().saveFcmToken(token);
          debugPrint('✅ FCM Token saved to Supabase');
        } catch (e) {
          debugPrint('❌ Error saving FCM token: $e');
        }
      }

      // Обновляем токен при изменении (например, переустановка приложения)
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('🔄 FCM Token refreshed: ${newToken.substring(0, 20)}...');
        GetIt.I<SupabaseService>().saveFcmToken(newToken);
      });

      // Настройка локальных уведомлений для Foreground
      await _setupLocalNotifications();

      // Слушаем уведомления в Foreground состоянии
      FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

      // Слушаем клики на уведомления когда приложение в Paused state
      FirebaseMessaging.onMessageOpenedApp
          .listen(_handleNotificationClick);
    } else {
      debugPrint('❌ Notification permission denied');
    }
  }

  /// Повторно сохраняет FCM-токен в Supabase.
  /// Вызывается сразу после входа пользователя, т.к. при первом
  /// запуске приложения пользователь ещё не авторизован.
  Future<void> refreshFcmToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await GetIt.I<SupabaseService>().saveFcmToken(token);
        debugPrint('✅ FCM Token re-saved after login');
      }
    } catch (e) {
      debugPrint('❌ Error re-saving FCM token: $e');
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Обработчик уведомлений в Foreground состоянии
  void _handleForegroundNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    debugPrint('📥 Foreground message received:');
    debugPrint('Title: ${notification?.title}');
    debugPrint('Body: ${notification?.body}');
    debugPrint('Data: ${message.data}');

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'Notifications for messages',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            tag: message.data['chat_id'] ?? 'message',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: _buildPayload(message.data),
      );
    }
  }

  /// Обработчик клика на уведомление (Paused state)
  void _handleNotificationClick(RemoteMessage message) {
    debugPrint('🔗 Notification clicked (Paused state):');
    debugPrint('Data: ${message.data}');

    _navigateToChat(message.data);
  }

  /// Обработчик клика на локальное уведомление (Foreground state)
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔗 Local notification tapped (Foreground state):');
    debugPrint('Payload: ${response.payload}');

    if (response.payload != null) {
      final data = _parsePayload(response.payload!);
      _navigateToChat(data);
    }
  }

  /// Построение payload для передачи в локальное уведомление
  String _buildPayload(Map<String, dynamic> data) {
    return [
      data['chat_id'] ?? '',
      data['sender_id'] ?? '',
      data['sender_name'] ?? '',
      data['message_body'] ?? '',
    ].join('|');
  }

  /// Парсинг payload из локального уведомления
  Map<String, dynamic> _parsePayload(String payload) {
    final parts = payload.split('|');
    return {
      'chat_id': parts.isNotEmpty ? parts[0] : '',
      'sender_id': parts.length > 1 ? parts[1] : '',
      'sender_name': parts.length > 2 ? parts[2] : '',
      'message_body': parts.length > 3 ? parts[3] : '',
    };
  }

  /// Навигация в конкретный чат на основе данных из уведомления
  void _navigateToChat(Map<String, dynamic> data) {
    final chatId = data['chat_id'] as String? ?? '';
    final senderId = data['sender_id'] as String? ?? '';

    if (chatId.isEmpty) {
      debugPrint('⚠️ Chat ID is empty, skipping navigation');
      return;
    }

    debugPrint('📱 Navigating to chat: $chatId from sender: $senderId');

    // Используем GoRouter для навигации
    if (_goRouter != null) {
      try {
        _goRouter!.push('/chat/$chatId');
        debugPrint('✅ Navigation to chat successful');
      } catch (e) {
        debugPrint('❌ Navigation error: $e');
      }
    } else {
      debugPrint('❌ GoRouter not initialized in PushNotificationService');
      debugPrint('💡 Make sure setGoRouter() was called in main.dart');
    }
  }

  /// Получить текущий FCM токен (для отладки)
  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  /// Включить/выключить уведомления
  Future<void> enableNotifications(bool enable) async {
    if (enable) {
      await _fcm.setAutoInitEnabled(true);
      debugPrint('✅ Notifications enabled');
    } else {
      await _fcm.setAutoInitEnabled(false);
      debugPrint('🔇 Notifications disabled');
    }
  }
}
