import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _keyLocale = 'app_locale';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotifMatches = 'notif_matches';
  static const String _keyNotifMessages = 'notif_messages';

  late SharedPreferences _prefs;

  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.system;
  bool _notifMatches = true;
  bool _notifMessages = true;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get notifMatches => _notifMatches;
  bool get notifMessages => _notifMessages;

  /// Инициализация — вызвать перед runApp
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final localeCode = _prefs.getString(_keyLocale) ?? 'ru';
    _locale = Locale(localeCode);

    final themeModeIndex = _prefs.getInt(_keyThemeMode) ?? 0; // 0 = system
    _themeMode = ThemeMode.values[themeModeIndex];

    _notifMatches = _prefs.getBool(_keyNotifMatches) ?? true;
    _notifMessages = _prefs.getBool(_keyNotifMessages) ?? true;
  }

  // ---- Язык ----
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setString(_keyLocale, locale.languageCode);
    notifyListeners();
  }

  // ---- Тема ----
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setInt(_keyThemeMode, mode.index);
    notifyListeners();
  }

  // ---- Уведомления ----
  Future<void> setNotifMatches(bool value) async {
    _notifMatches = value;
    await _prefs.setBool(_keyNotifMatches, value);
    notifyListeners();
  }

  Future<void> setNotifMessages(bool value) async {
    _notifMessages = value;
    await _prefs.setBool(_keyNotifMessages, value);
    notifyListeners();
  }
}
