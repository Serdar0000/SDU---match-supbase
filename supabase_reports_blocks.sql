-- ==========================================
-- REPORT AND BLOCK SYSTEM
-- ==========================================

-- Таблица для жалоб (reports)
CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reported_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  details TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Таблица для блокировок (blocks)
CREATE TABLE IF NOT EXISTS blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blocker_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  blocked_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(blocker_id, blocked_id)
);

-- Индексы
CREATE INDEX IF NOT EXISTS idx_reports_reported ON reports(reported_id);
CREATE INDEX IF NOT EXISTS idx_blocks_blocker ON blocks(blocker_id);
CREATE INDEX IF NOT EXISTS idx_blocks_blocked ON blocks(blocked_id);

-- RLS
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks ENABLE ROW LEVEL SECURITY;

-- Политики для reports
CREATE POLICY "Пользователи могут создавать жалобы" 
  ON reports FOR INSERT 
  WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Пользователи видят свои поданные жалобы" 
  ON reports FOR SELECT 
  USING (auth.uid() = reporter_id);

-- Политики для blocks
CREATE POLICY "Пользователи могут управлять своими блокировками" 
  ON blocks FOR ALL 
  USING (auth.uid() = blocker_id)
  WITH CHECK (auth.uid() = blocker_id);

-- Функция для фильтрации заблокированных пользователей в свайпах
-- Можно использовать в SELECT запросах: 
-- WHERE profiles.id NOT IN (SELECT blocked_id FROM blocks WHERE blocker_id = auth.uid())
-- AND profiles.id NOT IN (SELECT blocker_id FROM blocks WHERE blocked_id = auth.uid())
