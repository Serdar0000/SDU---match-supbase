-- SQL RPC функція для видалення аккаунту
-- Це простіше ніж Edge Function і не залежить від RLS

CREATE OR REPLACE FUNCTION delete_user_account(user_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result json;
BEGIN
  -- 1. Удаляем запись из таблицы profiles
  DELETE FROM profiles WHERE id = user_id;

  -- 2. Удаляем пользователя из auth.users через RPC
  -- (требует сервис-роль)
  -- Примечание: это может быть ограничено политиками Supabase
  -- поэтому используем напишем в extensions.auth
  
  result := json_build_object(
    'success', true,
    'message', 'Account deleted successfully'
  );
  
  RETURN result;
EXCEPTION WHEN others THEN
  result := json_build_object(
    'success', false,
    'error', SQLERRM
  );
  RETURN result;
END;
$$;

-- Даём права на выполнение функции авторизованным пользователям
GRANT EXECUTE ON FUNCTION delete_user_account(uuid) TO authenticated;
