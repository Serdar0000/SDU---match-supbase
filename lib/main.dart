import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/di/injection.dart' as di;
import 'core/services/settings_service.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  runApp(MainApp(settingsService: settingsService));
}

class MainApp extends StatefulWidget {
  final SettingsService settingsService;

  const MainApp({super.key, required this.settingsService});

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
      child: _AppWithSettings(settingsService: widget.settingsService),
    );
  }
}

class _AppWithSettings extends StatelessWidget {
  final SettingsService settingsService;

  const _AppWithSettings({required this.settingsService});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
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
