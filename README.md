# 💙 SDU Match

Приложение для знакомств студентов SDU University. Свайпай, находи матчи и общайся!

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
flutter pub get
```

### 2. Настройка Supabase

**ВАЖНО**: Перед запуском приложения необходимо настроить Supabase!

Следуйте подробной инструкции в [SUPABASE_SETUP.md](SUPABASE_SETUP.md):
- ✅ Обновить API ключи в `.env`
- ✅ Настроить Redirect URLs
- ✅ Выполнить SQL скрипт для создания таблиц
- 📧 Настроить Email Verification (см. [EMAIL_VERIFICATION_SETUP.md](EMAIL_VERIFICATION_SETUP.md))

### 3. Запуск приложения

```bash
flutter run
```

## 📱 Возможности

- 🔐 **Авторизация**: Email/Password и Google Sign-In
- 👤 **Профили**: Создание и редактирование профиля
- 💫 **Свайпы**: Tinder-style карточки с профилями
- ⭐ **Супер-лайки**: Выделись среди других
- 💬 **Чаты**: Real-time сообщения с матчами
- 🌍 **i18n**: Поддержка русского и английского языков
- 🎨 **Темы**: Светлая и тёмная тема

## 🏗️ Архитектура

```
lib/
├── core/               # Общие модули
│   ├── di/            # Dependency Injection
│   ├── services/      # Сервисы (Supabase, Cloudinary)
│   ├── theme/         # Темы и стили
│   └── utils/         # Утилиты и роутинг
├── features/          # Фичи приложения
│   ├── auth/          # Авторизация
│   ├── onboarding/    # Онбординг
│   ├── swipe/         # Свайпы
│   ├── matches/       # Матчи и чаты
│   ├── profile/       # Профиль
│   └── settings/      # Настройки
└── l10n/             # Локализация
```

### Слои архитектуры

Используется **Clean Architecture** с BLoC:
- **Domain**: Entities, Use Cases
- **Data**: Repositories, Data Sources
- **Presentation**: Pages, Widgets, BLoC

## 🛠️ Технологии

- **Flutter**: 3.8.1
- **State Management**: BLoC
- **Backend**: Supabase (PostgreSQL + Real-time)
- **Routing**: GoRouter
- **DI**: GetIt
- **Image Upload**: Cloudinary
- **Auth**: Supabase Auth + Google Sign-In
- **Database**: Drift (локальный кэш)

## 📚 Документация

- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Настройка Supabase
- [EMAIL_VERIFICATION_SETUP.md](EMAIL_VERIFICATION_SETUP.md) - Настройка подтверждения email
- [EMAIL_NOTIFICATIONS_SETUP.md](EMAIL_NOTIFICATIONS_SETUP.md) - Email уведомления
- [ONBOARDING_ARCHITECTURE.md](ONBOARDING_ARCHITECTURE.md) - Архитектура онбординга
- [UI_UX_PLAN.md](UI_UX_PLAN.md) - UI/UX дизайн

## 🗄️ База данных

### Основные таблицы

```sql
profiles       -- Профили пользователей
swipes         -- История свайпов
matches        -- Подтверждённые матчи
messages       -- Сообщения
notifications  -- Уведомления
```

SQL скрипт для создания таблиц: [supabase_setup.sql](supabase_setup.sql)

## 🔐 Переменные окружения

Создайте файл `.env` на основе [.env.example](.env.example):

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key

# Cloudinary (для загрузки фото)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_UPLOAD_PRESET=your_preset
CLOUDINARY_API_KEY=your_api_key

# Resend (для email уведомлений)
RESEND_API_KEY=your_resend_key
```

## 🧪 Тестирование

```bash
# Запуск тестов
flutter test

# Анализ кода
flutter analyze
```

## 📦 Сборка

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 🐛 Решение проблем

### "Invalid API key"
Обновите `SUPABASE_ANON_KEY` в файле `.env`

### "Deep link not working"
Проверьте настройки Redirect URLs в Supabase Dashboard

### "Cannot load profiles"
Убедитесь что SQL скрипт выполнен и таблицы созданы

Больше информации в [SUPABASE_SETUP.md](SUPABASE_SETUP.md)

## 👥 Команда

Разработано для SDU University

## 📄 Лицензия

Этот проект создан в образовательных целях.

