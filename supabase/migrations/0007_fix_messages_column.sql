-- ============================================================
-- FIX: messages table column naming inconsistency
--
-- Root cause:
--   The messages table may have been created with a 'content'
--   column (e.g. from the Supabase dashboard or an older setup
--   script), while all trigger functions and Flutter code expect
--   a 'text' column.  When a match is created, the
--   insert_welcome_message trigger fires and tries:
--     INSERT INTO messages (..., text, ...) VALUES (...)
--   which fails with:
--     ERROR 42703: column "content" of relation "messages" does not exist
--   causing the entire save_swipe_and_check_match RPC to roll back.
--
-- Fix:
--   1. Rename 'content' -> 'text' if it exists without 'text'.
--   2. Add 'text' if neither column exists yet.
--   3. Re-deploy all trigger functions so they consistently use
--      the 'text' column, regardless of what was previously deployed.
-- ============================================================

-- ── Step 1: Normalise the column name ──────────────────────
DO $$
BEGIN
  -- Case A: table has 'content' but NOT 'text' → rename
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'messages'
      AND column_name  = 'content'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'messages'
      AND column_name  = 'text'
  ) THEN
    ALTER TABLE public.messages RENAME COLUMN content TO text;
    RAISE NOTICE 'Renamed messages.content → messages.text';

  -- Case B: table has neither column → add 'text'
  ELSIF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'messages'
      AND column_name  = 'text'
  ) THEN
    ALTER TABLE public.messages ADD COLUMN text TEXT NOT NULL DEFAULT '';
    RAISE NOTICE 'Added messages.text column';

  ELSE
    RAISE NOTICE 'messages.text already exists – nothing to rename';
  END IF;
END;
$$;

-- ── Step 2: Add is_system column if missing (used by welcome msg) ──
ALTER TABLE public.messages
  ADD COLUMN IF NOT EXISTS is_system BOOLEAN DEFAULT FALSE;

-- ── Step 3: Re-deploy insert_welcome_message with 'text' column ────
CREATE OR REPLACE FUNCTION public.insert_welcome_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO messages (match_id, sender_id, text, is_read, is_system, created_at)
  VALUES (
    NEW.id,
    NULL,   -- system message: no sender
    '👋 You matched! Start the conversation by saying hi!',
    FALSE,
    TRUE,
    NOW()
  );
  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Never fail a match just because the welcome message failed
  RAISE WARNING 'insert_welcome_message failed: %', SQLERRM;
  RETURN NEW;
END;
$$;

-- Re-register the trigger (idempotent)
DROP TRIGGER IF EXISTS trigger_welcome_message ON public.matches;
CREATE TRIGGER trigger_welcome_message
  AFTER INSERT ON public.matches
  FOR EACH ROW
  EXECUTE FUNCTION public.insert_welcome_message();

-- ── Step 4: Re-deploy notify_new_message with 'text' column ────────
CREATE OR REPLACE FUNCTION public.notify_new_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  match_record   RECORD;
  receiver_id    UUID;
  sender_profile RECORD;
BEGIN
  SELECT * INTO match_record FROM matches WHERE id = NEW.match_id;

  IF match_record IS NULL THEN
    RETURN NEW;
  END IF;

  -- Skip notification for system messages
  IF NEW.is_system IS TRUE OR NEW.sender_id IS NULL THEN
    RETURN NEW;
  END IF;

  receiver_id := CASE
    WHEN match_record.user1_id = NEW.sender_id THEN match_record.user2_id
    ELSE match_record.user1_id
  END;

  SELECT * INTO sender_profile FROM profiles WHERE id = NEW.sender_id;

  -- Update match's last-message snapshot
  UPDATE matches
  SET last_message      = LEFT(NEW.text, 200),
      last_message_time = NEW.created_at
  WHERE id = NEW.match_id;

  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING 'notify_new_message failed: %', SQLERRM;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_message_created ON public.messages;
CREATE TRIGGER on_message_created
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_new_message();
