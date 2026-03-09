-- Trigger function to send a welcome message when a match is created
CREATE OR REPLACE FUNCTION public.handle_new_match()
RETURNS TRIGGER AS $$
BEGIN
  -- Insert a welcome message into the messages table
  -- We use NOW() for timestamp to ensure proper DB timezone handling
  INSERT INTO public.messages (match_id, sender_id, text, is_read, created_at)
  VALUES (
    NEW.id,
    NEW.user1_id, -- sender is user1
    'Hello! You have a new match! 👋 Start the conversation by sending a message.',
    FALSE,
    NOW() AT TIME ZONE 'UTC'
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger definition (drop if exists to avoid conflicts)
DROP TRIGGER IF EXISTS on_match_created ON public.matches;

CREATE TRIGGER on_match_created
  AFTER INSERT ON public.matches
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_match();
