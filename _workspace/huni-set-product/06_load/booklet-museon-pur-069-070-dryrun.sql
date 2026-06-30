-- ================================================================
-- 069 무선·070 PUR 완전 동작화 — 롤백전용 DRY-RUN (멱등·제약위반·카운트 실증)
-- 생성: hsp-load-executor 2026-07-01 · BEGIN…ROLLBACK (COMMIT 0·DB 미적재)
-- 검증: ① 1회차 적재 후 카운트 ② 2회차 재적재 delta 0(멱등) ③ ROLLBACK 후 baseline 복귀
-- ON_ERROR_STOP=1로 실행 → 제약위반 시 즉시 중단(EXIT≠0)
-- ================================================================
BEGIN;

-- ── 1회차 적재 (069 + 070) ──
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-museon-069-load.sql
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-pur-070-load.sql

-- ── 1회차 후 카운트 (기대: products 289-292=4·069셋트2·070셋트2·표지자재 each 7·내지자재 each 6) ──
\echo '=== [1회차] 신규 반제품 289-292 (기대 4) ==='
SELECT count(*) AS products_289_292 FROM t_prd_products WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
\echo '=== [1회차] 069 셋트행 (기대 2) ==='
SELECT count(*) AS sets_069 FROM t_prd_product_sets WHERE prd_cd='PRD_000069' AND del_yn='N';
\echo '=== [1회차] 070 셋트행 (기대 2) ==='
SELECT count(*) AS sets_070 FROM t_prd_product_sets WHERE prd_cd='PRD_000070' AND del_yn='N';
\echo '=== [1회차] 표지 자재 290/292 (기대 each 7) ==='
SELECT prd_cd, count(*) FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn='N' GROUP BY prd_cd ORDER BY prd_cd;
\echo '=== [1회차] 내지 자재 289/291 (기대 each 6) ==='
SELECT prd_cd, count(*) FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000289','PRD_000291') AND del_yn='N' GROUP BY prd_cd ORDER BY prd_cd;
\echo '=== [1회차] 공식 바인딩 289/291=INNER·290/292=COVER ==='
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292') ORDER BY prd_cd;

-- ── 2회차 재적재 (멱등 검증·delta 0이어야) ──
\echo '=== [2회차 멱등 재적재] — INSERT 0, UPDATE WHERE-가드로 0행 갱신 기대 ==='
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-museon-069-load.sql
\i /Users/innojini/Dev/HuniWeb/_workspace/huni-set-product/06_load/booklet-pur-070-load.sql

\echo '=== [2회차 후] 카운트 불변 확인 (289-292=4·069셋트2·070셋트2) ==='
SELECT count(*) AS products_289_292 FROM t_prd_products WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
SELECT count(*) AS sets_069 FROM t_prd_product_sets WHERE prd_cd='PRD_000069' AND del_yn='N';
SELECT count(*) AS sets_070 FROM t_prd_product_sets WHERE prd_cd='PRD_000070' AND del_yn='N';

-- ── FK 고아 검사 (셋트행 sub_prd_cd가 모두 실재해야) ──
\echo '=== FK 고아 검사 (기대 0) ==='
SELECT count(*) AS orphan FROM t_prd_product_sets s
WHERE s.prd_cd IN ('PRD_000069','PRD_000070') AND s.del_yn='N'
  AND NOT EXISTS (SELECT 1 FROM t_prd_products p WHERE p.prd_cd=s.sub_prd_cd);

ROLLBACK;

-- ── ROLLBACK 후 baseline 복귀 확인 (289-292=0·069/070 셋트=0) ──
\echo '=== [ROLLBACK 후] baseline 복귀 (289-292=0·069셋트0·070셋트0) ==='
SELECT count(*) AS products_289_292 FROM t_prd_products WHERE prd_cd IN ('PRD_000289','PRD_000290','PRD_000291','PRD_000292');
SELECT count(*) AS sets_069 FROM t_prd_product_sets WHERE prd_cd='PRD_000069';
SELECT count(*) AS sets_070 FROM t_prd_product_sets WHERE prd_cd='PRD_000070';
