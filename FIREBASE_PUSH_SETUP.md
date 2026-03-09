# Как настроить Firebase Push в Supabase (вместо SendGrid)

Так как мы переходим с Email (SendGrid) на Firebase Push для уведомлений о матчах и сообщениях, вот пошаговый гайд:

## 1. Firebase Console
1. Создайте проект в [Firebase Console](https://console.firebase.google.com/).
2. Добавьте Android приложение (ID: `com.sdu.match`).
3. Скачайте `google-services.json` и положите в `android/app/`.
4. В настройках проекта → Cloud Messaging получите **Server Key** (или создайте Service Account JSON).

## 2. Supabase SQL
Добавьте колонку для FCM токена и обновите триггеры (замените `send_email_notification` на вызов Edge Function для Firebase).

```sql
-- Добавляем колонку для токена
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS fcm_token TEXT;

-- Здесь нужно реализовать вызов Edge Function, которая отправит FCM
-- Вместо send_email_notification(email, subject, body)
-- Используйте net.http_post на вашу Edge Function
```

## 3. Edge Function (notify-fcm)
Создайте функцию в Supabase, которая принимает `userId`, `title`, `body` и отправляет пуш через Firebase Admin SDK или REST API.

```bash
supabase functions new notify-fcm
```

Внутри функции используйте `service_role` ключ для получения `fcm_token` из таблицы `profiles` и отправки уведомления.

## 4. Обновление триггеров
В файле `supabase_setup.sql` (или через SQL Editor) замените вызовы:
```sql
-- БЫЛО
PERFORM send_email_notification(user_profile.email, ...);

-- СТАЛО (пример)
PERFORM net.http_post(
  url := 'https://your-project.supabase.co/functions/v1/notify-fcm',
  headers := jsonb_build_object(
    'Content-Type', 'application/json', 
    'Authorization', 'Bearer ' || 'YOUR_SUPABASE_ANON_KEY'
  ),
  body := jsonb_build_object(
    'user_id', user_id, 
    'title', 'Новый матч!', 
    'body', 'Посмотрите, кто вам подошел!'
  )
);
```

## 5. Как получить OAuth2 токен для Firebase API v1 в Edge Function
Так как старый Server Key (Cloud Messaging Desktop) устарел, Firebase требует OAuth2.
1. В Edge Function используйте библиотеку `google-auth-library` или загрузите Service Account JSON в переменную `FIREBASE_SERVICE_ACCOUNT`.
2. Функция `notify-fcm` уже имеет шаблон для получения токена.
