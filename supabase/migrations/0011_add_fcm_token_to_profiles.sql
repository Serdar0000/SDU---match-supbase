-- ============================================================
-- Add fcm_token column to profiles table.
--
-- Without this column saveFcmToken() silently fails, the Edge
-- Function finds no token, and push notifications are never
-- delivered on match events.
-- ============================================================

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS fcm_token TEXT;
