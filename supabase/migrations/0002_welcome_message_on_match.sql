-- ==========================================
-- WELCOME MESSAGE TRIGGER FOR NEW MATCHES
-- ==========================================
-- Purpose: Automatically insert a welcome system message 
-- when a new match is created.

-- Function: Insert welcome message on new match
CREATE OR REPLACE FUNCTION insert_welcome_message()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Insert welcome message from system (NULL sender_id for system messages)
  -- We use a special system UUID as sender
  INSERT INTO messages (match_id, sender_id, text, is_read, created_at)
  VALUES (
    NEW.id,
    NEW.user1_id,  -- System message attributed to user1 for now
    'Hello! You have a new match! 👋 Start the conversation by sending a message.',
    FALSE,
    NOW()
  );

  RETURN NEW;
END;
$$;

-- Trigger: Call the function when a new match is created
DROP TRIGGER IF EXISTS trigger_welcome_message ON matches;
CREATE TRIGGER trigger_welcome_message
  AFTER INSERT ON matches
  FOR EACH ROW
  EXECUTE FUNCTION insert_welcome_message();

-- ==========================================
-- Alternative: If you want a cleaner approach without sender attribution,
-- add a "system" Boolean column to messages table:
-- ALTER TABLE messages ADD COLUMN IF NOT EXISTS is_system BOOLEAN DEFAULT FALSE;
-- 
-- Then update the function to:
-- INSERT INTO messages (match_id, sender_id, text, is_read, is_system, created_at)
-- VALUES (NEW.id, NULL, 'Welcome message...', FALSE, TRUE, NOW());
-- ==========================================
