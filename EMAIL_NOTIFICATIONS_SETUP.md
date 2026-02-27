# Email-уведомления через Supabase для SDU Match

Простая система уведомлений: **in-app уведомления** + **email** через Supabase.

## Как это работает

1. **In-app уведомления** - сохраняются в таблице `notifications`, показываются в приложении через Realtime
2. **Email** - отправляются автоматически при новых матчах/сообщениях (опционально)

## ✅ Преимущества

- ✅ **Бесплатно** - нет платных сервисов (Firebase, OneSignal)
- ✅ **Просто** - всё в Supabase
- ✅ **Realtime** - уведомления приходят мгновенно в приложение
- ✅ **Email опционально** - пользователь может отключить

---

## Шаг 1: Выполните SQL скрипт

1. Откройте [Supabase SQL Editor](https://bomhoafsiolfhfxcdiwt.supabase.co/project/_/sql)
2. Вставьте содержимое [supabase_setup.sql](supabase_setup.sql)
3. Нажмите **Run**

Это создаст:
- Таблицу `notifications`
- Триггеры для автосоздания уведомлений
- Функции для отправки email

---

## Шаг 2: Настройка Email (опционально)

Если хотите отправлять email-уведомления, выберите один из вариантов:

### Вариант 1: Resend (Рекомендуется)

**Бесплатно:** 100 emails/день, 3,000/месяц

1. Регистрация: https://resend.com/signup
2. Добавьте домен или используйте тестовый
3. Получите API Key: Dashboard → API Keys → Create
4. Добавьте в Supabase Secrets:
   ```bash
   supabase secrets set RESEND_API_KEY=re_xxxxxxxxxx
   ```

### Вариант 2: SendGrid

**Бесплатно:** 100 emails/день

1. Регистрация: https://signup.sendgrid.com/
2. Settings → API Keys → Create API Key
3. Добавьте в Supabase Secrets:
   ```bash
   supabase secrets set SENDGRID_API_KEY=SG.xxxxxxxxxx
   ```

### Вариант 3: Без Email (только in-app)

Если не нужны email - ничего не делайте! Уведомления будут показываться только в приложении.

---

## Шаг 3: Деплой Edge Function (если настроили Email)

```bash
# Установите Supabase CLI
npm install -g supabase

# Логин
supabase login

# Деплой функции
supabase functions deploy send-email --project-ref bomhoafsiolfhfxcdiwt
```

---

## Шаг 4: Включите pg_net расширение

Для автоматической отправки email из триггеров:

1. Supabase Dashboard → Database → Extensions
2. Найдите `pg_net`
3. Нажмите **Enable**

Затем обновите функцию `send_email_notification` в SQL:

```sql
CREATE OR REPLACE FUNCTION send_email_notification(
  recipient_email TEXT,
  subject TEXT,
  body TEXT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  PERFORM net.http_post(
    url := 'https://bomhoafsiolfhfxcdiwt.supabase.co/functions/v1/send-email',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ВАШ_SERVICE_ROLE_KEY'
    ),
    body := jsonb_build_object(
      'to', recipient_email,
      'subject', subject,
      'body', body
    )
  );
END;
$$;
```

**SERVICE_ROLE_KEY:** Dashboard → Settings → API → service_role key

---

## Как работают уведомления в приложении

### 1. Автоматическое создание

При новом матче или сообщении автоматически создаётся запись в `notifications` через триггеры.

### 2. Показ в приложении

```dart
// Получить непрочитанные уведомления
final notifications = await NotificationService().getUnreadNotifications();

// Stream для счётчика
Stream<int> unreadCount = NotificationService().getUnreadCountStream();

// Отметить как прочитанное
await NotificationService().markAsRead(notificationId);
```

### 3. Realtime обновления

Уведомления приходят в реальном времени благодаря Supabase Realtime.

---

## Пример: Показ уведомлений в UI

```dart
class NotificationsPage extends StatelessWidget {
  final NotificationService _service = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уведомления'),
        actions: [
          // Счётчик непрочитанных
          StreamBuilder<int>(
            stream: _service.getUnreadCountStream(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              if (count == 0) return SizedBox.shrink();
              return Badge(
                label: Text('$count'),
                child: Icon(Icons.notifications),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _service.getUnreadNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          
          final notifications = snapshot.data!;
          
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return ListTile(
                title: Text(notif['title']),
                subtitle: Text(notif['message']),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _service.markAsRead(notif['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Настройка email в профиле пользователя

```dart
// Включить/отключить email уведомления
await supabase
  .from('profiles')
  .update({'email_notifications': true})  // или false
  .eq('id', userId);
```

---

## Тестирование

### 1. Создайте тестовое уведомление

```sql
INSERT INTO notifications (user_id, type, title, message, data)
VALUES (
  'ваш_user_id',
  'test',
  'Тест',
  'Тестовое уведомление',
  '{"test": true}'::jsonb
);
```

### 2. Проверьте в приложении

Уведомление должно появиться мгновенно.

### 3. Тестовый email

```sql
SELECT send_email_notification(
  'your@email.com',
  'Test Subject',
  'Test Body'
);
```

Проверьте логи Edge Function:
```bash
supabase functions logs send-email
```

---

## Структура таблицы notifications

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,           -- Кому
  type TEXT NOT NULL,               -- 'new_match', 'new_message'
  title TEXT NOT NULL,              -- Заголовок
  message TEXT NOT NULL,            -- Текст
  data JSONB,                       -- Дополнительные данные (matchId, etc)
  is_read BOOLEAN DEFAULT false,   -- Прочитано?
  created_at TIMESTAMPTZ            -- Когда создано
);
```

---

## Типы уведомлений

| Type | Когда | Title | Data |
|------|-------|-------|------|
| `new_match` | Новый матч | "Новый матч! 🎉" | `{"matchId": "...", "partnerId": "..."}` |
| `new_message` | Новое сообщение | "Новое сообщение от Имя" | `{"matchId": "...", "senderId": "..."}` |

---

## Troubleshooting

### Уведомления не создаются

1. Проверьте триггеры:
   ```sql
   SELECT * FROM pg_trigger WHERE tgname LIKE 'on_%';
   ```

2. Проверьте логи:
   ```sql
   SELECT * FROM notifications ORDER BY created_at DESC LIMIT 10;
   ```

### Email не отправляются

1. Проверьте Edge Function деплойнута:
   ```bash
   supabase functions list
   ```

2. Проверьте секреты:
   ```bash
   supabase secrets list
   ```

3. Проверьте логи:
   ```bash
   supabase functions logs send-email
   ```

4. Проверьте pg_net включён:
   ```sql
   SELECT * FROM pg_extension WHERE extname = 'pg_net';
   ```

### Realtime не работает

1. Dashboard → Database → Replication
2. Включите таблицу `notifications`

---

## Бесплатные лимиты

| Сервис | Бесплатно |
|--------|-----------|
| Supabase | 500 MB database, 2 GB bandwidth |
| Resend | 100 emails/день, 3,000/месяц |
| SendGrid | 100 emails/день |

Для SDU Match этого более чем достаточно!

---

## Полезные ссылки

- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Resend Docs](https://resend.com/docs)
- [SendGrid Docs](https://docs.sendgrid.com/)
