-- ============================================================
-- FIX: notify_new_match trigger function crashes on match creation
--
-- Root cause:
--   The live notify_new_match() function (deployed manually via
--   supabase_setup.sql) attempts to INSERT INTO messages using a
--   column name that doesn't match the current schema.  Because
--   this function has NO exception handler, any column-name error
--   rolls back the entire save_swipe_and_check_match RPC call,
--   so the match is never committed and the overlay never appears.
--
--   Additionally, notify_new_match inserts a welcome message AND
--   insert_welcome_message (trigger_welcome_message) also inserts
--   one, causing duplicate welcome messages on every match.
--
-- Fix:
--   1. Replace notify_new_match with a minimal, safe version:
--        - Removes the duplicate "welcome message" INSERT (handled
--          exclusively by insert_welcome_message / trigger_welcome_message).
--        - Wraps all side-effect work in EXCEPTION WHEN OTHERS so
--          a notification failure NEVER blocks match creation.
--   2. Recreate on_match_created trigger (idempotent).
-- ============================================================

CREATE OR REPLACE FUNCTION public.notify_new_match()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  user1_profile RECORD;
  user2_profile RECORD;
BEGIN
  -- Fetch both profiles (safe: no-op if not found)
  SELECT * INTO user1_profile FROM profiles WHERE id = NEW.user1_id;
  SELECT * INTO user2_profile FROM profiles WHERE id = NEW.user2_id;

  -- Insert in-app notifications for both users
  BEGIN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      NEW.user1_id,
      'new_match',
      'Новый матч! 🎉',
      'У вас новый матч с ' || COALESCE(user2_profile.name, 'пользователем'),
      jsonb_build_object('matchId', NEW.id, 'partnerId', NEW.user2_id)
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'notify_new_match: notifications insert (user1) failed: %', SQLERRM;
  END;

  BEGIN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      NEW.user2_id,
      'new_match',
      'Новый матч! 🎉',
      'У вас новый матч с ' || COALESCE(user1_profile.name, 'пользователем'),
      jsonb_build_object('matchId', NEW.id, 'partnerId', NEW.user1_id)
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'notify_new_match: notifications insert (user2) failed: %', SQLERRM;
  END;

  -- NOTE: Welcome message is inserted by the separate trigger_welcome_message
  -- (insert_welcome_message function). DO NOT insert here to avoid duplicates.

  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Never let this trigger block match creation
  RAISE WARNING 'notify_new_match failed entirely: %', SQLERRM;
  RETURN NEW;
END;
$$;

-- Recreate trigger (idempotent)
DROP TRIGGER IF EXISTS on_match_created ON public.matches;
CREATE TRIGGER on_match_created
  AFTER INSERT ON public.matches
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_match();
