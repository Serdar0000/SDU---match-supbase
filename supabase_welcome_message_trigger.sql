-- ==========================================
-- WELCOME MESSAGE TRIGGER FOR NEW MATCHES (Fixed & Improved)
-- ==========================================

-- STEP 1: Add is_system column to messages table (if not exists)
ALTER TABLE messages ADD COLUMN IF NOT EXISTS is_system BOOLEAN DEFAULT FALSE;

-- STEP 2: Create function to insert welcome message
CREATE OR REPLACE FUNCTION insert_welcome_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Insert welcome message as SYSTEM message (sender_id = NULL)
  INSERT INTO messages (match_id, sender_id, text, is_read, is_system, created_at)
  VALUES (
    NEW.id,
    NULL,  -- System message has no sender
    '👋 You matched! Start the conversation by sending a message.',
    FALSE,
    TRUE,  -- Mark as system message
    NOW()
  );

  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Log error but don't fail the match creation
  RAISE WARNING 'Failed to insert welcome message: %', SQLERRM;
  RETURN NEW;
END;
$$;

-- STEP 3: Create trigger
DROP TRIGGER IF EXISTS trigger_welcome_message ON matches;
CREATE TRIGGER trigger_welcome_message
  AFTER INSERT ON matches
  FOR EACH ROW
  EXECUTE FUNCTION insert_welcome_message();

-- ==========================================
-- UPDATE RLS POLICY FOR MESSAGES (if needed)
-- ==========================================
-- The SELECT policy already allows reading messages in your match
-- because it checks: auth.uid() IN (SELECT user1_id/user2_id FROM matches)
-- System messages (sender_id = NULL) will be visible to both users? ✅

-- If you want to be explicit, update the SELECT policy:
-- DROP POLICY IF EXISTS "Пользователи могут читать сообщения своего матча" ON messages;
-- CREATE POLICY "Пользователи могут читать сообщения своего матча"
--   ON messages FOR SELECT
--   USING (
--     auth.uid() IN (
--       SELECT user1_id FROM matches WHERE id = messages.match_id
--       UNION ALL
--       SELECT user2_id FROM matches WHERE id = messages.match_id
--     )
--     OR is_system = TRUE  -- System messages visible to both
--   );

-- ==========================================
-- MIGRATION NOTES
-- ==========================================
-- 1. Run this migration BEFORE deploying Flutter code
-- 2. Existing matches won't have welcome messages
-- 3. To backfill welcome messages for existing matches, run:
--
-- INSERT INTO messages (match_id, sender_id, text, is_read, is_system, created_at)
-- SELECT id, NULL, '👋 You matched!', FALSE, TRUE, created_at
-- FROM matches m
-- WHERE NOT EXISTS (
--   SELECT 1 FROM messages msg 
--   WHERE msg.match_id = m.id AND msg.is_system = TRUE
-- );
