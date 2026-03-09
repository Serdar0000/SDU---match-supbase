import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/settings_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../features/moderation/presentation/bloc/moderation_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final l = S.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.settings,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ========== ЯЗЫК ==========
          _SectionHeader(title: l.settingsLanguage, icon: Icons.language),
          _LanguageTile(
            title: l.langRussian,
            flag: '🇷🇺',
            locale: const Locale('ru'),
          ),
          _LanguageTile(
            title: l.langKazakh,
            flag: '🇰🇿',
            locale: const Locale('kk'),
          ),
          _LanguageTile(
            title: l.langEnglish,
            flag: '🇺🇸',
            locale: const Locale('en'),
          ),

          const _Divider(),

          // ========== ТЕМА ==========
          _SectionHeader(title: l.settingsTheme, icon: Icons.palette_outlined),
          _ThemeTile(
            title: l.themeLight,
            icon: Icons.light_mode,
            mode: ThemeMode.light,
          ),
          _ThemeTile(
            title: l.themeDark,
            icon: Icons.dark_mode,
            mode: ThemeMode.dark,
          ),
          _ThemeTile(
            title: l.themeSystem,
            icon: Icons.settings_brightness,
            mode: ThemeMode.system,
          ),

          const _Divider(),

          // ========== УВЕДОМЛЕНИЯ ==========
          _SectionHeader(title: l.settingsNotifications, icon: Icons.notifications_outlined),
          _buildNotificationSwitch(context, l),

          const _Divider(),

          // ========== АККАУНТ ==========
          _SectionHeader(title: l.settingsAccount, icon: Icons.person_outline),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l.editProfile),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.editingInDev)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: Text(
              l.signOut,
              style: const TextStyle(color: Colors.orange),
            ),
            onTap: () => _handleSignOut(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              l.deleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _handleDeleteAccount(context, l),
          ),

          const _Divider(),

          // ========== О ПРИЛОЖЕНИИ ==========
          _SectionHeader(title: l.settingsAbout, icon: Icons.info_outline),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.appVersion),
            trailing: Text(
              '0.1.0',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsOfService),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: open terms
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(BuildContext context, S l) {
    return _NotificationSwitches();
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await Supabase.instance.client.auth.signOut();
    
    if (!mounted) return;
    context.go('/login');
  }

  Future<void> _handleDeleteAccount(BuildContext context, S l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteAccount),
        content: Text(l.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final bloc = context.read<ModerationBloc>();
      final router = GoRouter.of(context);
      
      // Слушаем состояние блока один раз (firstWhere закроет подписку)
      bloc.stream.firstWhere((state) {
        return state.maybeWhen(
          success: (message, blockedIds) => true,
          error: (message) => true,
          orElse: () => false,
        );
      }).then((_) {
        // После изменения состояния - проверяем что произошло
        final currentState = bloc.state;
        currentState.whenOrNull(
          success: (message, blockedIds) {
            // Успешно удалён - переходим на login
            if (mounted) {
              router.go('/login');
            }
          },
          error: (message) {
            // Ошибка удаления
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $message'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
        );
      });
      
      // Запускаем процесс удаления аккаунта
      bloc.add(ModerationEvent.deleteAccountRequested());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

// ============================================================
// Вспомогательные виджеты
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(),
    );
  }
}

/// Плитка выбора языка
class _LanguageTile extends StatelessWidget {
  final String title;
  final String flag;
  final Locale locale;

  const _LanguageTile({
    required this.title,
    required this.flag,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    final isSelected = settings.locale.languageCode == locale.languageCode;
    final theme = Theme.of(context);

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () => settings.setLocale(locale),
    );
  }
}

/// Плитка выбора темы
class _ThemeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode mode;

  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    final isSelected = settings.themeMode == mode;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
      onTap: () => settings.setThemeMode(mode),
    );
  }
}

/// Переключатели уведомлений
class _NotificationSwitches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context);
    final l = S.of(context)!;

    return Column(
      children: [
        SwitchListTile(
          title: Text(l.notifMatches),
          subtitle: Text(l.notifMatchesDesc),
          secondary: const Icon(Icons.favorite_border),
          value: settings.notifMatches,
          onChanged: (v) => settings.setNotifMatches(v),
        ),
        SwitchListTile(
          title: Text(l.notifMessages),
          subtitle: Text(l.notifMessagesDesc),
          secondary: const Icon(Icons.message_outlined),
          value: settings.notifMessages,
          onChanged: (v) => settings.setNotifMessages(v),
        ),
      ],
    );
  }
}

// ============================================================
// InheritedWidget для доступа к SettingsService из виджетов
// ============================================================
class SettingsProvider extends InheritedNotifier<SettingsService> {
  final SettingsService service;

  const SettingsProvider({
    super.key,
    required this.service,
    required super.child,
  }) : super(notifier: service);

  static SettingsService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<SettingsProvider>();
    return provider!.service;
  }
}
