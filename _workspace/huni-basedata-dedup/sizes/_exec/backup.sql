-- backup.sql — D-1 (SIZ_000105 → SIZ_000104) physical backup
-- 2026-06-19 / hbd-load-executor
-- 영향 테이블의 영향 행만 타임스탬프 백업 테이블로 복제(undo 안전망).
-- 멱등: 백업 테이블 존재 시 재실행하지 않도록 IF NOT EXISTS 가드.

CREATE TABLE IF NOT EXISTS bak_siz_basedata_dedup_20260619_0800 AS
  SELECT * FROM t_siz_sizes
   WHERE siz_cd IN ('SIZ_000104','SIZ_000105');

CREATE TABLE IF NOT EXISTS bak_prdsiz_basedata_dedup_20260619_0800 AS
  SELECT * FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000004' AND siz_cd IN ('SIZ_000104','SIZ_000105');

-- 백업 행수 확인
SELECT 'bak_siz_basedata_dedup_20260619_0800' AS bak, COUNT(*) AS rows
  FROM bak_siz_basedata_dedup_20260619_0800
UNION ALL
SELECT 'bak_prdsiz_basedata_dedup_20260619_0800', COUNT(*)
  FROM bak_prdsiz_basedata_dedup_20260619_0800;
