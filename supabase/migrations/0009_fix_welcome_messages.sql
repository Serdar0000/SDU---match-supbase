-- ============================================================
-- FIX: Welcome messages — send greeting from BOTH matched users
--
-- Previously insert_welcome_message tried to insert with
-- sender_id = NULL which violates the NOT NULL constraint on
-- messages.sender_id.  This migration replaces it so that:
--   • User1 auto-sends "Привет! 👋"
--   • User2 auto-sends "Хеллоу! 🎉" (1 second later so ordering
--     is deterministic in the chat feed)
--
-- Both inserts are wrapped in individual BEGIN/EXCEPTION blocks
-- so a failure of one never blocks the other or the match itself.
-- ============================================================

CREATE OR REPLACE FUNCTION public.insert_welcome_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Message from user1
  BEGIN
    INSERT INTO messages (match_id, sender_id, text, is_read, created_at)
    VALUES (
      NEW.id,
      NEW.user1_id,
      'Привет! 👋',
      FALSE,
      NOW()
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'insert_welcome_message (user1 msg) failed: %', SQLERRM;
  END;

  -- Message from user2 (1 second later so it appears second in the chat)
  BEGIN
    INSERT INTO messages (match_id, sender_id, text, is_read, created_at)
    VALUES (
      NEW.id,
      NEW.user2_id,
      'Хеллоу! 🎉',
      FALSE,
      NOW() + interval '1 second'
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'insert_welcome_message (user2 msg) failed: %', SQLERRM;
  END;

  -- Update match's last_message snapshot
  BEGIN
    UPDATE matches
    SET last_message      = 'Хеллоу! 🎉',
        last_message_time = NOW() + interval '1 second',
        unread_count_user1 = 1,
        unread_count_user2 = 0
    WHERE id = NEW.id;
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'insert_welcome_message (update matches) failed: %', SQLERRM;
  END;

  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING 'insert_welcome_message outer failed: %', SQLERRM;
  RETURN NEW;
END;
$$;

-- Re-register trigger (idempotent)
DROP TRIGGER IF EXISTS trigger_welcome_message ON public.matches;
CREATE TRIGGER trigger_welcome_message
  AFTER INSERT ON public.matches
  FOR EACH ROW
  EXECUTE FUNCTION public.insert_welcome_message();
