-- Migration: Ensure `stars_given` has default 0 and existing NULLs set to 0
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor → New Query)

BEGIN;

-- Add the column if it doesn't exist, with default 0
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS stars_given INTEGER DEFAULT 0;

-- Ensure the column has a default (safe even if just added)
ALTER TABLE public.profiles
  ALTER COLUMN stars_given SET DEFAULT 0;

-- Update existing rows in case some records have NULL
UPDATE public.profiles
SET stars_given = 0
WHERE stars_given IS NULL;

COMMIT;

-- End migration
