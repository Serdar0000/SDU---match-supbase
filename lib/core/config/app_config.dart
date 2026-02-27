/// Конфигурация приложения
class AppConfig {
  // 🚧 DEV MODE: Включить для тестирования без Supabase
  static const bool DEV_MODE = false;
  
  // Мок ID пользователя для DEV_MODE
  static const String DEV_USER_ID = 'dev-user-001';
  static const String DEV_USER_EMAIL = 'dev@test.com';
}
