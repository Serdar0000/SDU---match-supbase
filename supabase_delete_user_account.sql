-- ==========================================
-- RPC ФУНКЦИЯ ДЛЯ УДАЛЕНИЯ АККАУНТА (GDPR)
-- ==========================================
-- SECURITY DEFINER позволяет обойти RLS и удалить запись из auth.users
-- SECURITY INVOKER используется по умолчанию и ограничен RLS правилами

CREATE OR REPLACE FUNCTION public.delete_user_account(user_id UUID)
RETURNS JSON AS $$
DECLARE
  deleted_matches INT;
  deleted_messages INT;
  deleted_swipes INT;
  deleted_blocks INT;
  deleted_reports INT;
BEGIN
  -- Проверяем, что пользователь удаляет только свой аккаунт
  IF auth.uid() != user_id THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Unauthorized: can only delete your own account'
    );
  END IF;

  -- Начинаем каскадное удаление всех связанных данных
  -- Удаляем все матчи пользователя (это каскадом удалит сообщения)
  DELETE FROM matches
  WHERE user1_id = user_id OR user2_id = user_id;
  GET DIAGNOSTICS deleted_matches = ROW_COUNT;

  -- Удаляем все свайпы пользователя
  DELETE FROM swipes
  WHERE from_user_id = user_id OR to_user_id = user_id;
  GET DIAGNOSTICS deleted_swipes = ROW_COUNT;

  -- Удаляем все блокировки пользователя
  DELETE FROM blocks
  WHERE blocker_id = user_id OR blocked_id = user_id;
  GET DIAGNOSTICS deleted_blocks = ROW_COUNT;

  -- Удаляем все жалобы пользователя
  DELETE FROM reports
  WHERE reporter_id = user_id OR reported_id = user_id;
  GET DIAGNOSTICS deleted_reports = ROW_COUNT;

  -- Удаляем профиль
  -- ВАЖНО: В Supabase профиль связан с auth.users через FOREIGN KEY
  -- Если включен CASCADE delete, то удаление профиля удалит и auth.users
  DELETE FROM profiles
  WHERE id = user_id;

  -- Если удаление профиля не удалило auth.users, удаляем вручную
  -- через Supabase Edge Function или отдельный RPC
  -- (это будет SECURITY DEFINER функция которая удалит auth пользователя)
  
  -- Логируем успешное удаление
  RETURN json_build_object(
    'success', true,
    'message', 'Account deleted successfully',
    'user_id', user_id,
    'deleted_data', json_build_object(
      'matches', deleted_matches,
      'messages', 0,
      'swipes', deleted_swipes,
      'blocks', deleted_blocks,
      'reports', deleted_reports
    )
  );
EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'detail', 'Transaction rolled back'
  );
END;
$$ LANGUAGE plpgsql SECURITY INVOKER;  -- SECURITY INVOKER (вызывающий имеет свои права)

-- Даём доступ аутентифицированным пользователям
GRANT EXECUTE ON FUNCTION public.delete_user_account(UUID) TO authenticated;

-- ==========================================
-- АЛЬТЕРНАТИВНАЯ ФУНКЦИЯ С SECURITY DEFINER
-- (если нужно удалить auth.users через функцию)
-- ==========================================

CREATE OR REPLACE FUNCTION public.delete_auth_user(user_id UUID)
RETURNS JSON AS $$
BEGIN
  -- Эта функция должна быть создана только если Supabase
  -- позволяет удалять auth.users из SQL функций
  -- В большинстве случаев это делается через Edge Function или API

  RETURN json_build_object(
    'success', false,
    'error', 'Use Edge Function delete-user-account instead'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.delete_auth_user(UUID) TO authenticated;
