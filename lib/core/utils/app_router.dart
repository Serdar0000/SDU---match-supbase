import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sdu_match/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:sdu_match/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../../core/services/supabase_service.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/swipe/presentation/pages/main_wrapper_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/swipe/presentation/pages/swipe_page.dart';
import '../../features/matches/presentation/pages/matches_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/swipe/domain/entities/user_profile.dart';

class AppRouter {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String profile = '/profile';
  static const String matches = '/matches';
  static const String settings = '/settings';
  static const String chat = '/chat/:matchId';
  static const String editProfile = '/profile/edit';
  
  static final _supabaseService = SupabaseService();

  static final GoRouter router = GoRouter(
    // 🚧 DEV MODE: Начинаем с онбординга, иначе с home
    initialLocation: AppConfig.DEV_MODE ? onboarding : home,
    redirect: (context, state) async {
      // 🚧 DEV MODE: Пропускаем все проверки авторизации
      if (AppConfig.DEV_MODE) {
        return null;
      }
      
      final user = Supabase.instance.client.auth.currentUser;
      final isOnLoginPage = state.matchedLocation == login;
      final isOnOnboarding = state.matchedLocation == onboarding;

      // Не авторизован → на логин
      if (user == null) {
        return isOnLoginPage ? null : login;
      }

      // Авторизован, но на логине → проверяем профиль
      if (isOnLoginPage) {
        final hasProfile = await _supabaseService.hasProfile(user.id);
        return hasProfile ? home : onboarding;
      }

      // На онбординге — пропускаем (чтобы не зациклиться)
      if (isOnOnboarding) return null;

      // Любой другой роут — проверяем наличие профиля
      final hasProfile = await _supabaseService.hasProfile(user.id);
      if (!hasProfile) return onboarding;

      return null;
    },
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => BlocProvider(
          create: (context) => OnboardingBloc()..add(const OnboardingEvent.started()),
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/chat/:matchId',
        name: 'chat',
        builder: (context, state) {
          final matchId = state.pathParameters['matchId']!;
          final profile = state.extra as UserProfile?;
          return ChatPage(matchId: matchId, otherProfile: profile);
        },
      ),
      
      // StatefulShellRoute для BottomNavigationBar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: [
          // Ветка 1: Профиль
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'editProfile',
                    builder: (context, state) {
                      final p = state.extra as UserProfile;
                      return EditProfilePage(initialProfile: p);
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Ветка 2: Главная (Свайпы)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                builder: (context, state) => const SwipePage(),
              ),
            ],
          ),
          
          // Ветка 3: Чаты/Матчи
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: matches,
                name: 'matches',
                builder: (context, state) => const MatchesPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
