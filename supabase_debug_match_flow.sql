-- ==========================================
-- DEBUG SCRIPT: Check Match Flow
-- ==========================================
-- Run this in Supabase SQL Editor to debug

-- 1. Check if matches table exists and has correct structure
SELECT column_name, data_type FROM information_schema.columns 
WHERE table_name = 'matches';

-- 2. Check if messages table exists and has correct columns
SELECT column_name, data_type FROM information_schema.columns 
WHERE table_name = 'messages';

-- 3. Check recent messages (should have auto-created welcome messages)
SELECT id, match_id, sender_id, text, created_at, is_read
FROM messages 
ORDER BY created_at DESC 
LIMIT 10;

-- 4. Check recent matches
SELECT id, user1_id, user2_id, last_message, last_message_time, created_at
FROM matches
ORDER BY created_at DESC
LIMIT 10;

-- 5. Check recent swipes (to verify match logic)
SELECT id, from_user_id, to_user_id, action, created_at
FROM swipes
ORDER BY created_at DESC
LIMIT 20;

-- 6. Verify trigger exists
SELECT trigger_name, event_manipulation, event_object_table, action_statement
FROM information_schema.triggers
WHERE trigger_name = 'on_match_created';

-- 7. Test manual message creation (to verify timestamp format)
-- UNCOMMENT THIS TO TEST:
-- INSERT INTO public.messages (match_id, sender_id, text, is_read, created_at)
-- VALUES (
--   (SELECT id FROM matches ORDER BY created_at DESC LIMIT 1),
--   (SELECT user1_id FROM matches ORDER BY created_at DESC LIMIT 1),
--   'TEST MESSAGE - THIS IS A TEST',
--   FALSE,
--   NOW() AT TIME ZONE 'UTC'
-- );
