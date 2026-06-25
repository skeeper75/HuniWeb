-- ============================================================
-- dryrun.sql — 좀비 부활 롤백전용 DRY-RUN (R1 멱등 + R5 제약위반0 실증)
-- BEGIN ... UPDATE x2(1차) ... UPDATE x2(2차=멱등) ... ROLLBACK
-- 기대: 1차 UPDATE 2행 / 2차 UPDATE 0행(멱등) / 제약위반 0 / 롤백 후 라이브 무변경
-- 멱등 가드: WHERE del_yn='Y' (이미 N이면 0행). 물리 DELETE 없음.
-- 감사컬럼 upd_dt 는 BEFORE UPDATE 트리거 trg_t_mat_materials_upd_dt 가 자동 갱신 → 수동 미설정(최소변경).
-- ============================================================

\echo '=== DRY-RUN 시작 (ROLLBACK 보장) ==='
BEGIN;

\echo '--- 1차 UPDATE (기대 UPDATE 2) ---'
UPDATE t_mat_materials
SET del_yn = 'N'
WHERE mat_cd IN ('MAT_000159','MAT_000119')
  AND del_yn = 'Y';

\echo '--- 1차 직후 상태 (둘 다 del_yn=N 기대) ---'
SELECT mat_cd, del_yn FROM t_mat_materials WHERE mat_cd IN ('MAT_000159','MAT_000119') ORDER BY mat_cd;

\echo '--- 2차 UPDATE (멱등: 기대 UPDATE 0) ---'
UPDATE t_mat_materials
SET del_yn = 'N'
WHERE mat_cd IN ('MAT_000159','MAT_000119')
  AND del_yn = 'Y';

\echo '--- 단가행 불변 확인 (지문) ---'
SELECT mat_cd, count(*) rows,
       md5(string_agg(comp_price_id::text||':'||coalesce(unit_price::text,'NULL'), ',' ORDER BY comp_price_id)) fingerprint
FROM t_prc_component_prices WHERE mat_cd IN ('MAT_000159','MAT_000119') GROUP BY mat_cd ORDER BY mat_cd;

\echo '--- 배선 불변 확인 ---'
SELECT mat_cd, count(*) pm_rows FROM t_prd_product_materials
WHERE mat_cd IN ('MAT_000159','MAT_000119') AND del_yn='N' GROUP BY mat_cd ORDER BY mat_cd;

\echo '=== ROLLBACK (라이브 무변경) ==='
ROLLBACK;

\echo '--- 롤백 후 라이브 재확인 (둘 다 del_yn=Y 여야 함) ---'
SELECT mat_cd, del_yn FROM t_mat_materials WHERE mat_cd IN ('MAT_000159','MAT_000119') ORDER BY mat_cd;
