# Отладка: MatchOverlay не показывается

## ✅ Проверить перед тестированием:

### 1. **Структура БД**
```sql
-- Проверить таблицы
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- Проверить структуру messages
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'messages';

-- Должно быть: id, match_id, sender_id, text (или content), is_read, created_at
```

### 2. **Проверить триггер**
```sql
-- Убедиться что триггер существует
SELECT trigger_name, event_manipulation FROM information_schema.triggers 
WHERE trigger_name LIKE '%match%';

-- Проверить что функция trigger_welcome_message существует
SELECT routine_name FROM information_schema.routines 
WHERE routine_name = 'insert_welcome_message' OR routine_name = 'handle_new_match';
```

### 3. **Логи консоли при тестировании**
Поищите эти логи:
- `🔄 [SwipeBloc] LoadInfos: Loading profiles` - блок загрузил профили
- `👉 [SwipeBloc] SwipeRight: Liking ...` - начал сохранять лайк
- `✅ [SwipeBloc] Swipe saved. matchId: ...` - лайк сохранён
- `🎉 [SwipeBloc] MATCH FOUND!` - **найден матч!** (это критично)
- Если этот последний лог не появляется - проверить логику `_checkForMatch` в `SupabaseService`

### 4. **Критические моменты**

#### Проблема: MatchOverlay не показывается
**Причины:**
1. `_checkForMatch` возвращает `null` (контрматча нет)
2. `SwipeMatchState` не эмитится
3. BlocListener не срабатывает
4. MatchOverlay скрыт под другим виджетом

**Решение:**
- Проверьте логи "🎉 [SwipeBloc] MATCH FOUND!"
- Если этого логи нет - значит `matchId` равен `null`, проблема в `_checkForMatch`
- Если логи есть, но оверлей не показывается - проблема в UI слое

#### Проблема: Сообщение не создаётся
**Причины:**
1. Триггер не обрабатывает `text` колонку (используется `content`)
2. Триггер не срабатывает (нет INSERT в matches)
3. Ошибка в SQL синтаксисе
4. RLS политика блокирует вставку

**Решение:**
```sql
-- Проверить последние сообщения
SELECT id, match_id, sender_id, text, created_at FROM messages 
ORDER BY created_at DESC LIMIT 10;

-- Если пусто - значит триггер не срабатывает
-- Проверьте логи Supabase: Data → messages
```

### 5. **Быстрая проверка валидности**

```sql
-- 1. Создайте тестовый матч вручную
INSERT INTO matches (user1_id, user2_id, last_message, last_message_time, created_at)
VALUES (
  'user1_uuid',
  'user2_uuid',
  '',
  NOW() AT TIME ZONE 'UTC',
  NOW() AT TIME ZONE 'UTC'
);

-- 2. Проверьте создалось ли сообщение?
SELECT * FROM messages ORDER BY created_at DESC LIMIT 1;

-- Если сообщение не создалось - триггер не работает
-- Если создалось - триггер работает, проблема в коде
```

## 🔧 Если ничего не работает:

1. **Проверьте DI контейнер** - SwipeBloc зарегистрирован?
   ```dart
   // lib/core/di/injection.dart
   sl.registerFactory<SwipeBloc>(...);
   ```

2. **Проверьте BlocProvider** - SwipePage оборнута?
   ```dart
   BlocProvider(
     create: (_) => sl<SwipeBloc>(),
     child: SwipePage(),
   )
   ```

3. **Очистите данные** - flutter clean && flutter pub get
