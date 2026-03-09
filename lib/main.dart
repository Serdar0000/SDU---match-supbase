import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/di/injection.dart' as di;
import 'core/services/settings_service.dart';
import 'core/services/push_notification_service.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/moderation/presentation/bloc/moderation_bloc.dart';
import 'l10n/generated/app_localizations.dart';

/// Глобальный обработчик для фоновых сообщений (Terminated state)
/// ВАЖНО: Эта функция ДОЛЖНА быть top-level, так как вызывается в отдельном isolate
/// вне контекста приложения, даже когда оно полностью закрыто
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Инициализируем Firebase в контексте фонового isolate
  await Firebase.initializeApp();
  
  // Логируем полученное сообщение
  debugPrint('🔔 Background message received:');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
  
  // Данные для обработки (например, чат, пользователь)
  // Используются позже при клике на уведомление
  final chatId = message.data['chat_id'];
  final senderId = message.data['sender_id'];
  
  debugPrint('✅ Background message processed - Chat: $chatId, Sender: $senderId');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Регистрируем глобальный обработчик для фоновых сообщений (Terminated state)
  // Это ОБЯЗАТЕЛЬНО сделать ДО инициализации Supabase и других сервисов
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Загружаем переменные окружения
  await dotenv.load(fileName: '.env');
  
  // Инициализация Supabase с deep linking
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Инициализация Google Sign-In (обязательно для v7.x)
  await GoogleSignIn.instance.initialize();
  
  // Инициализация настроек (язык, тема)
  final settingsService = SettingsService();
  await settingsService.init();

  await di.init(); // Инициализация GetIt
  
  // Регистрация и инициализация Push Notifications
  final pushService = PushNotificationService();
  await pushService.init();

  runApp(MainApp(settingsService: settingsService, pushService: pushService));
}

class MainApp extends StatefulWidget {
  final SettingsService settingsService;
  final PushNotificationService pushService;

  const MainApp(
      {super.key,
      required this.settingsService,
      required this.pushService});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    // Слушаем изменения состояния авторизации (включая email verification)
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      
      // Когда email подтвержден через deep link
      if (event == AuthChangeEvent.signedIn) {
        debugPrint('✅ User signed in: ${data.session?.user.email}');
        // Сохраняем FCM-токен — при первом запуске пользователь ещё не был
        // авторизован, поэтому повторяем сохранение сразу после входа.
        widget.pushService.refreshFcmToken();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        debugPrint('🔄 Token refreshed');
      } else if (event == AuthChangeEvent.userUpdated) {
        debugPrint('👤 User updated');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsProvider(
      service: widget.settingsService,
      child: BlocProvider<ModerationBloc>(
        create: (context) => di.sl<ModerationBloc>()
          ..add(const ModerationEvent.blockedIdsRequested()),
        child: _AppWithSettings(
            settingsService: widget.settingsService,
            pushService: widget.pushService),
      ),
    );
  }
}

class _AppWithSettings extends StatefulWidget {
  final SettingsService settingsService;
  final PushNotificationService pushService;

  const _AppWithSettings(
      {required this.settingsService, required this.pushService});

  @override
  State<_AppWithSettings> createState() => _AppWithSettingsState();
}

class _AppWithSettingsState extends State<_AppWithSettings> {
  @override
  void didUpdateWidget(_AppWithSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем navigator в PushNotificationService при изменении контекста
    if (mounted) {
      _updatePushNavigator();
    }
  }

  void _updatePushNavigator() {
    // Обновляем навигатор в PushNotificationService для deep linking
    // Используется для обработки клика на уведомление
    if (!mounted) return;
    try {
      // Используем AppRouter.router напрямую вместо GoRouter.of(context)
      PushNotificationService.setGoRouter(AppRouter.router);
    } catch (e) {
      debugPrint('Error updating push navigator: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    
    // Обновляем navigator при создании widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePushNavigator();
    });
    
    return MaterialApp.router(
      title: 'SDU Match',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
