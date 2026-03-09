-- Добавляем RLS политику для удаления профиля через функцию delete-user-account
-- Функция вызывается от сервис-аккаунта, поэтому ей нужны специальные права

-- Включаем RLS если ещё не включён
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Политика для удаления - позволяет сервис-аккаунту удалять любой профиль
-- (проверка что юзер удаляет только свой аккаунт происходит на уровне функции)
CREATE POLICY "Service role can delete profiles for account deletion"
ON profiles
FOR DELETE
USING (TRUE);

-- Политика для чтения - каждый может читать свой профиль
CREATE POLICY "Users can read own profile"
ON profiles
FOR SELECT
USING (auth.uid() = id);

-- Политика для обновления - каждый может обновлять свой профиль
CREATE POLICY "Users can update own profile"
ON profiles
FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Политика для вставки - каждый может создать свой профиль
CREATE POLICY "Users can insert own profile"
ON profiles
FOR INSERT
WITH CHECK (auth.uid() = id);
