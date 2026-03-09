-- Создаём таблицу profiles для хранения профилей пользователей
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL,
  name text NOT NULL,
  age integer,
  gender text DEFAULT 'other',
  major text,
  interests text[] DEFAULT '{}',
  photos text[] DEFAULT '{}',
  bio text,
  stars_given integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- RLS политики для безопасного доступа
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first (idempotent)
DROP POLICY IF EXISTS "Users can read own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Service role can delete profiles" ON profiles;
DROP POLICY IF EXISTS "Service role can delete profiles for account deletion" ON profiles;
DROP POLICY IF EXISTS "Публичный доступ на чтение профилей" ON profiles;
DROP POLICY IF EXISTS "Пользователь создаёт свой профиль" ON profiles;
DROP POLICY IF EXISTS "Пользователь обновляет свой профиль" ON profiles;
DROP POLICY IF EXISTS "Пользователь удаляет свой профиль" ON profiles;

-- Все могут читать профили (для свайпов)
CREATE POLICY "Users can read own profile"
  ON profiles
  FOR SELECT
  USING (true);

-- Пользователи могут обновлять свой профиль
CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Пользователи могут создавать свой профиль
CREATE POLICY "Users can insert own profile"
  ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Service role может удалять профиль (для функции delete_user_account)
CREATE POLICY "Service role can delete profiles"
  ON profiles
  FOR DELETE
  USING (true);
