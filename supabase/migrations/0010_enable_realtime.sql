-- ============================================================
-- Ensure Realtime replication is enabled for matches/messages
-- (idempotent — safe to run even if already added)
-- ============================================================

-- Full replica identity so Realtime can diff old vs new row
ALTER TABLE matches  REPLICA IDENTITY FULL;
ALTER TABLE messages REPLICA IDENTITY FULL;

-- Add tables to the realtime publication only if not already there
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'matches'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE matches;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'messages'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE messages;
  END IF;
END;
$$;
