-- ==========================================
-- SUPABASE SETUP SCRIPT для SDU Match
-- ==========================================
-- Скопируйте и выполните в Supabase SQL Editor
-- (Dashboard → SQL Editor → New Query)

-- ==========================================
-- 1. СОЗДАНИЕ ТАБЛИЦ
-- ==========================================

-- Таблица профилей пользователей
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  bio TEXT,
  age INTEGER,
  gender TEXT,
  major TEXT,
  interests TEXT[] DEFAULT '{}',
  photos TEXT[] DEFAULT '{}',
  stars_given INTEGER DEFAULT 0, -- Количество супер-лайков, которые пользователь раздал
  email_notifications BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Таблица свайпов
CREATE TABLE IF NOT EXISTS swipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  to_user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  action TEXT NOT NULL CHECK (action IN ('like', 'pass')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(from_user_id, to_user_id)
);

-- Таблица матчей
CREATE TABLE IF NOT EXISTS matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  user2_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  last_message TEXT DEFAULT '',
  last_message_time TIMESTAMPTZ DEFAULT NOW(),
  unread_count_user1 INTEGER DEFAULT 0,
  unread_count_user2 INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (user1_id < user2_id), -- Гарантируем уникальность пары
  UNIQUE(user1_id, user2_id)
);

-- Таблица сообщений
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 2. ИНДЕКСЫ ДЛЯ ПРОИЗВОДИТЕЛЬНОСТИ
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_gender ON profiles(gender);

CREATE INDEX IF NOT EXISTS idx_swipes_from_user ON swipes(from_user_id);
CREATE INDEX IF NOT EXISTS idx_swipes_to_user ON swipes(to_user_id);
CREATE INDEX IF NOT EXISTS idx_swipes_action ON swipes(action);

CREATE INDEX IF NOT EXISTS idx_matches_user1 ON matches(user1_id);
CREATE INDEX IF NOT EXISTS idx_matches_user2 ON matches(user2_id);
CREATE INDEX IF NOT EXISTS idx_matches_last_message_time ON matches(last_message_time DESC);

CREATE INDEX IF NOT EXISTS idx_messages_match ON messages(match_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(created_at DESC);

-- ==========================================
-- 3. ROW LEVEL SECURITY (RLS)
-- ==========================================

-- Включаем RLS для всех таблиц
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- ПОЛИТИКИ ДЛЯ PROFILES
-- ==========================================

-- Все могут читать все профили (для свайпов)
CREATE POLICY "Публичный доступ на чтение профилей" 
  ON profiles FOR SELECT 
  USING (true);

-- Пользователь может создать только свой профиль
CREATE POLICY "Пользователь создаёт свой профиль" 
  ON profiles FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- Пользователь может обновлять только свой профиль
CREATE POLICY "Пользователь обновляет свой профиль" 
  ON profiles FOR UPDATE 
  USING (auth.uid() = id);

-- Пользователь может удалить свой профиль
CREATE POLICY "Пользователь удаляет свой профиль" 
  ON profiles FOR DELETE 
  USING (auth.uid() = id);

-- ==========================================
-- ПОЛИТИКИ ДЛЯ SWIPES
-- ==========================================

-- Пользователь может читать свои свайпы
CREATE POLICY "Пользователь читает свои свайпы" 
  ON swipes FOR SELECT 
  USING (auth.uid() = from_user_id);

-- Пользователь может создавать свайпы (от своего имени)
CREATE POLICY "Пользователь создаёт свайпы" 
  ON swipes FOR INSERT 
  WITH CHECK (auth.uid() = from_user_id);

-- ==========================================
-- ПОЛИТИКИ ДЛЯ MATCHES
-- ==========================================

-- Участники матча могут его читать
CREATE POLICY "Участники читают матч" 
  ON matches FOR SELECT 
  USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Любой авторизованный пользователь может создать матч
-- (проверка взаимного лайка происходит в коде)
CREATE POLICY "Создание матча при взаимном лайке" 
  ON matches FOR INSERT 
  WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

-- Участники могут обновлять счётчики непрочитанных и последнее сообщение
CREATE POLICY "Участники обновляют матч" 
  ON matches FOR UPDATE 
  USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- ==========================================
-- ПОЛИТИКИ ДЛЯ MESSAGES
-- ==========================================

-- Участники матча могут читать сообщения
CREATE POLICY "Участники матча читают сообщения" 
  ON messages FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM matches 
      WHERE id = match_id 
      AND (user1_id = auth.uid() OR user2_id = auth.uid())
    )
  );

-- Участники матча могут отправлять сообщения
CREATE POLICY "Участники отправляют сообщения" 
  ON messages FOR INSERT 
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM matches 
      WHERE id = match_id 
      AND (user1_id = auth.uid() OR user2_id = auth.uid())
    )
  );

-- Участники могут обновлять статус прочтения
CREATE POLICY "Участники обновляют статус прочтения" 
  ON messages FOR UPDATE 
  USING (
    EXISTS (
      SELECT 1 FROM matches 
      WHERE id = match_id 
      AND (user1_id = auth.uid() OR user2_id = auth.uid())
    )
  );

-- ==========================================
-- 4. ФУНКЦИИ И ТРИГГЕРЫ
-- ==========================================

-- Функция для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для profiles
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- 5. REALTIME (для чата)
-- ==========================================

-- Включаем Realtime для сообщений и матчей
-- (выполните в Dashboard → Database → Replication)
-- Или выполните:

ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE matches;

-- ==========================================
-- 6. ТАБЛИЦА УВЕДОМЛЕНИЙ
-- ==========================================

CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  data JSONB DEFAULT '{}'::jsonb,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- Включаем Realtime для уведомлений
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- ==========================================
-- 7. ТРИГГЕРЫ ДЛЯ EMAIL УВЕДОМЛЕНИЙ
-- ==========================================

-- Триггер: Новый матч
CREATE OR REPLACE FUNCTION notify_new_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user1_profile RECORD;
  user2_profile RECORD;
BEGIN
  -- Получаем профили пользователей
  SELECT * INTO user1_profile FROM profiles WHERE id = NEW.user1_id;
  SELECT * INTO user2_profile FROM profiles WHERE id = NEW.user2_id;

  -- Создаём уведомления для обоих пользователей
  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (
    NEW.user1_id,
    'new_match',
    'Новый матч! 🎉',
    'У вас новый матч с ' || COALESCE(user2_profile.name, 'пользователем'),
    jsonb_build_object('matchId', NEW.id, 'partnerId', NEW.user2_id)
  );

  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (
    NEW.user2_id,
    'new_match',
    'Новый матч! 🎉',
    'У вас новый матч с ' || COALESCE(user1_profile.name, 'пользователем'),
    jsonb_build_object('matchId', NEW.id, 'partnerId', NEW.user1_id)
  );

  -- Отправляем email если включены уведомления
  IF user1_profile.email_notifications THEN
    PERFORM send_email_notification(
      user1_profile.email,
      'Новый матч в SDU Match!',
      'У вас новый матч с ' || COALESCE(user2_profile.name, 'пользователем') || '. Откройте приложение чтобы начать общение!'
    );
  END IF;

  IF user2_profile.email_notifications THEN
    PERFORM send_email_notification(
      user2_profile.email,
      'Новый матч в SDU Match!',
      'У вас новый матч с ' || COALESCE(user1_profile.name, 'пользователем') || '. Откройте приложение чтобы начать общение!'
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_match_created ON matches;
CREATE TRIGGER on_match_created
  AFTER INSERT ON matches
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_match();

-- Триггер: Новое сообщение
CREATE OR REPLACE FUNCTION notify_new_message()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  match_record RECORD;
  receiver_id UUID;
  receiver_profile RECORD;
  sender_profile RECORD;
BEGIN
  -- Получаем информацию о матче
  SELECT * INTO match_record FROM matches WHERE id = NEW.match_id;
  
  -- Определяем получателя
  IF match_record.user1_id = NEW.sender_id THEN
    receiver_id := match_record.user2_id;
  ELSE
    receiver_id := match_record.user1_id;
  END IF;

  -- Получаем профили
  SELECT * INTO receiver_profile FROM profiles WHERE id = receiver_id;
  SELECT * INTO sender_profile FROM profiles WHERE id = NEW.sender_id;

  -- Создаём уведомление
  INSERT INTO notifications (user_id, type, title, message, data)
  VALUES (
    receiver_id,
    'new_message',
    COALESCE(sender_profile.name, 'Новое сообщение'),
    LEFT(NEW.text, 100),
    jsonb_build_object('matchId', NEW.match_id, 'senderId', NEW.sender_id)
  );

  -- Отправляем email если включены уведомления
  IF receiver_profile.email_notifications THEN
    PERFORM send_email_notification(
      receiver_profile.email,
      'Новое сообщение от ' || COALESCE(sender_profile.name, 'пользователя'),
      LEFT(NEW.text, 200)
    );
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_message_created ON messages;
CREATE TRIGGER on_message_created
  AFTER INSERT ON messages
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_message();

-- ==========================================
-- 8. ФУНКЦИЯ ОТПРАВКИ EMAIL (заглушка)
-- ==========================================
-- Эта функция должна быть реализована через Edge Function
-- См. supabase/functions/send-email/index.ts

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
  -- Вызов Edge Function через HTTP (требуется pg_net расширение)
  -- Или используйте Supabase Email Templates
  
  -- Пример с pg_net (если доступно):
  -- PERFORM net.http_post(
  --   url := current_setting('app.settings.supabase_url') || '/functions/v1/send-email',
  --   headers := jsonb_build_object(
  --     'Content-Type', 'application/json',
  --     'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key')
  --   ),
  --   body := jsonb_build_object(
  --     'to', recipient_email,
  --     'subject', subject,
  --     'body', body
  --   )
  -- );

  -- Для начала просто логируем
  RAISE NOTICE 'Email to %: % - %', recipient_email, subject, body;
END;
$$;

-- ==========================================
-- ГОТОВО! 
-- ==========================================
-- Теперь можно использовать Supabase в приложении
-- Email уведомления настраиваются через Edge Function (см. документацию)
