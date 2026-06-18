-- dryrun.sql — D-1 롤백전용 DRY-RUN (BEGIN ... ROLLBACK)
-- 2026-06-19 / hbd-load-executor
-- 변경을 트랜잭션 내에서 실행 → 영향 행수·사후검증 SELECT 확인 → ROLLBACK(무손상).
-- 멱등 입증은 별도 2-pass 실행으로 수행(이 스크립트 내 1차).

BEGIN;

-- (a) 멤버 바인딩 제거
WITH d AS (
  DELETE FROM t_prd_product_sizes
   WHERE prd_cd='PRD_000004' AND siz_cd='SIZ_000105' AND del_yn='N'
  RETURNING 1)
SELECT 'DEL t_prd_product_sizes (a)' AS step, COUNT(*) AS delta FROM d;

-- (b) 멤버 논리삭제
WITH u AS (
  UPDATE t_siz_sizes
     SET del_yn='Y', upd_dt=now()
   WHERE siz_cd='SIZ_000105' AND del_yn='N'
  RETURNING 1)
SELECT 'UPD t_siz_sizes del_yn (b)' AS step, COUNT(*) AS delta FROM u;

-- 사후검증 (트랜잭션 내 상태)
\echo '--- V1 t_siz_sizes 104/105 del_yn (expect 104=N,105=Y) ---'
SELECT siz_cd, del_yn FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000104','SIZ_000105') ORDER BY siz_cd;
\echo '--- V2 PRD_000004 active sizes (expect SIZ_000104 single, dflt_yn=Y) ---'
SELECT siz_cd, dflt_yn, del_yn FROM t_prd_product_sizes WHERE prd_cd='PRD_000004' AND del_yn='N' ORDER BY siz_cd;
\echo '--- V3 member refs (expect cp=0, prd_active=0) ---'
SELECT (SELECT COUNT(*) FROM t_prc_component_prices WHERE siz_cd='SIZ_000105') AS cp,
       (SELECT COUNT(*) FROM t_prd_product_sizes WHERE siz_cd='SIZ_000105' AND del_yn='N') AS prd_active;

ROLLBACK;
