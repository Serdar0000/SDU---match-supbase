# 🚀 Полная настройка Supabase для SDU Match

## ✅ Что уже настроено

### 1. Flutter приложение
- ✅ Установлен `supabase_flutter: ^2.9.4`
- ✅ Инициализация в `main.dart`
- ✅ Сервисы: `SupabaseService` и `SupabaseChatService`
- ✅ Deep linking для Android и iOS
- ✅ Файл `.env` с переменными окружения

### 2. Платформенные настройки
- ✅ **Android**: Intent filters для `com.example.sdu_match://login-callback`
- ✅ **iOS**: CFBundleURLTypes для `com.example.sdu_match://`

### 3. Структура БД
- ✅ SQL скрипт создан: `supabase_setup.sql`
- ✅ Таблицы: profiles, swipes, matches, messages, notifications

---

## 🔧 Что нужно сделать

### Шаг 1: Проверить/обновить API ключи

Откройте файл `.env` и убедитесь что у вас правильные ключи:

```env
SUPABASE_URL=https://bomhoafsiolfhfxcdiwt.supabase.co
SUPABASE_ANON_KEY=ВАШ_РЕАЛЬНЫЙ_КЛЮЧ_ЗДЕСЬ
```

**Где взять правильный ключ:**
1. Откройте [Supabase Dashboard](https://supabase.com/dashboard)
2. Выберите проект `bomhoafsiolfhfxcdiwt`
3. Settings → API → Project API keys
4. Скопируйте **anon/public** ключ (начинается с `eyJ...`)

⚠️ **ВАЖНО**: Текущий ключ в `.env` выглядит неполным. Обновите его!

---

### Шаг 2: Настроить Redirect URLs в Supabase

Для корректной работы авторизации и email verification добавьте redirect URLs:

1. Откройте [Authentication → URL Configuration](https://supabase.com/dashboard/project/bomhoafsiolfhfxcdiwt/auth/url-configuration)
2. В **Redirect URLs** добавьте (каждый на новой строке):
   ```
   com.example.sdu_match://login-callback
   com.example.sdu_match://email-callback
   http://localhost
   ```

3. В **Site URL** укажите:
   ```
   com.example.sdu_match://
   ```

4. Нажмите **Save**

📧 **Email Verification**: Подробная настройка email подтверждения в [EMAIL_VERIFICATION_SETUP.md](EMAIL_VERIFICATION_SETUP.md)

---

### Шаг 3: Выполнить SQL скрипт

Если еще не создали таблицы в базе данных:

1. Откройте [SQL Editor](https://supabase.com/dashboard/project/bomhoafsiolfhfxcdiwt/sql/new)
2. Скопируйте весь код из файла `supabase_setup.sql`
3. Нажмите **Run** (или F5)
4. Убедитесь что все таблицы созданы без ошибок

---

### Шаг 4: Настроить Storage для фото (опционально)

Если хотите хранить фото в Supabase (вместо Cloudinary):

1. Откройте [Storage](https://supabase.com/dashboard/project/bomhoafsiolfhfxcdiwt/storage/buckets)
2. Создайте bucket `avatars`
3. Настройте политики доступа:
   - **Public**: чтение для всех
   - **Authenticated**: загрузка для авторизованных

---

## 📱 Проверка работы

### 1. Запуск приложения

```bash
flutter pub get
flutter run
```

### 2. Проверка подключения

Приложение автоматически инициализирует Supabase при старте. Проверьте логи:

```dart
// Должно быть в консоли
✓ Supabase initialized
```

### 3. Тест авторизации

1. Откройте страницу логина
2. Попробуйте войти через Email или Google
3. После успешной авторизации должен произойти редирект обратно в приложение

---

## 🔍 Текущая архитектура

### Сервисы

#### `SupabaseService` - основной сервис
- `saveUserProfile()` - сохранение профиля
- `getUserProfile()` - получение профиля по ID
- `getProfilesToSwipe()` - получение профилей для свайпа
- `saveSwipe()` - сохранение свайпа и проверка матча
- `getMatches()` - получение списка матчей

#### `SupabaseChatService` - сервис чата
- `sendMessage()` - отправка сообщения
- `getMessages()` - получение истории чата
- `subscribeToMessages()` - real-time подписка на новые сообщения

### Используемые таблицы

```sql
profiles          -- Профили пользователей
swipes            -- История свайпов
matches           -- Подтверждённые матчи
messages          -- Сообщения в чате
notifications     -- Push-уведомления
```

---

## 🐛 Возможные проблемы

### 1. "Invalid API key"
**Решение**: Обновите `SUPABASE_ANON_KEY` в `.env` на правильный ключ из Supabase Dashboard

### 2. "Deep link not working"
**Решение**: 
- Убедитесь что Redirect URLs настроены в Supabase Dashboard
- Проверьте что в Android/iOS правильно настроены scheme (`com.example.sdu_match`)

### 3. "Row Level Security policy violation"
**Решение**: Выполните `supabase_setup.sql` - там настроены все RLS политики

### 4. "Cannot connect to Supabase"
**Решение**: 
- Проверьте интернет соединение
- Убедитесь что `SUPABASE_URL` правильный
- Проверьте статус проекта в Supabase Dashboard

---

## 📚 Дополнительно

### Логи и отладка

Для отладки Supabase запросов добавьте в код:

```dart
Supabase.instance.client
  .from('profiles')
  .select()
  .then((data) => print('Data: $data'))
  .catchError((error) => print('Error: $error'));
```

### Real-time подписки

Для real-time обновлений используйте:

```dart
final subscription = Supabase.instance.client
  .from('messages')
  .stream(primaryKey: ['id'])
  .eq('match_id', matchId)
  .listen((data) {
    print('New message: $data');
  });
```

### Документация
- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

## ✨ Готово!

После выполнения всех шагов Supabase будет полностью подключен и готов к работе! 🎉

Для тестирования создайте несколько тестовых пользователей и попробуйте:
- ✅ Регистрация/Логин
- ✅ Создание профиля
- ✅ Свайпы
- ✅ Матчи
- ✅ Чат

**Вопросы?** Проверьте [EMAIL_NOTIFICATIONS_SETUP.md](EMAIL_NOTIFICATIONS_SETUP.md) для настройки email уведомлений.
