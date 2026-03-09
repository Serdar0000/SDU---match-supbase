-- ============================================================
-- FIX: Match detection broken due to RLS on swipes table
--
-- Root cause:
--   RLS SELECT policy on swipes only allows users to see rows
--   where from_user_id = auth.uid(). When _checkForMatch queries
--   the REVERSE swipe (from the other user), RLS hides it → null.
--
-- Fix:
--   Move swipe insert + match check into a single SECURITY DEFINER
--   function that bypasses RLS internally.
-- ============================================================

CREATE OR REPLACE FUNCTION public.save_swipe_and_check_match(
  p_from_uid UUID,
  p_to_uid   UUID,
  p_action   TEXT
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_match_id     UUID;
  v_reverse_ok   BOOLEAN;
  v_user1        UUID;
  v_user2        UUID;
BEGIN
  -- Security: caller must be the swiper
  IF auth.uid() IS DISTINCT FROM p_from_uid THEN
    RAISE EXCEPTION 'Not authorised';
  END IF;

  -- Insert (or skip if duplicate)
  INSERT INTO swipes (from_user_id, to_user_id, action, created_at)
  VALUES (p_from_uid, p_to_uid, p_action, NOW())
  ON CONFLICT (from_user_id, to_user_id) DO UPDATE
    SET action = EXCLUDED.action, created_at = EXCLUDED.created_at;

  -- Only check mutual like for 'like' action
  IF p_action <> 'like' THEN
    RETURN NULL;
  END IF;

  -- Check if the other user already liked us (SECURITY DEFINER bypasses RLS)
  SELECT EXISTS (
    SELECT 1 FROM swipes
    WHERE from_user_id = p_to_uid
      AND to_user_id   = p_from_uid
      AND action       = 'like'
  ) INTO v_reverse_ok;

  IF NOT v_reverse_ok THEN
    RETURN NULL;
  END IF;

  -- Deterministic ordering to avoid duplicate matches
  IF p_from_uid < p_to_uid THEN
    v_user1 := p_from_uid;
    v_user2 := p_to_uid;
  ELSE
    v_user1 := p_to_uid;
    v_user2 := p_from_uid;
  END IF;

  -- Return existing match if already created (idempotent)
  SELECT id INTO v_match_id
  FROM matches
  WHERE user1_id = v_user1 AND user2_id = v_user2;

  IF v_match_id IS NOT NULL THEN
    RETURN v_match_id;
  END IF;

  -- Create the match
  INSERT INTO matches (
    user1_id, user2_id,
    last_message, last_message_time,
    unread_count_user1, unread_count_user2,
    created_at
  )
  VALUES (
    v_user1, v_user2,
    '',
    NOW(),
    -- Mark as unread for the person who did NOT just swipe
    CASE WHEN p_from_uid = v_user1 THEN 0 ELSE 1 END,
    CASE WHEN p_from_uid = v_user2 THEN 0 ELSE 1 END,
    NOW()
  )
  RETURNING id INTO v_match_id;

  RETURN v_match_id;
END;
$$;

-- Allow authenticated users to call this function
GRANT EXECUTE ON FUNCTION public.save_swipe_and_check_match(UUID, UUID, TEXT) TO authenticated;

-- Also ensure the swipes table has a unique constraint so ON CONFLICT works
-- (only adds if it doesn't already exist – safe to run multiple times)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'swipes_from_to_unique'
  ) THEN
    ALTER TABLE swipes
      ADD CONSTRAINT swipes_from_to_unique UNIQUE (from_user_id, to_user_id);
  END IF;
END;
$$;
