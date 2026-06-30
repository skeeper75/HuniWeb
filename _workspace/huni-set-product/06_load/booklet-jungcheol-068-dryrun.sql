-- ================================================================
-- booklet-jungcheol-068 DRY-RUN (롤백전용·멱등 2회 실증)
-- 생성: hsp-load-executor 2026-07-01
-- 입증: 제약위반 0 · 복합PK 충돌 0 · 1회차 INSERT 카운트 · 2회차 delta 0 · ROLLBACK 후 baseline 복귀.
-- 적재본 = booklet-jungcheol-068-full-load.sql (BEGIN/COMMIT 미내장 — 본 DRY-RUN 이 트랜잭션 래핑).
-- ================================================================
BEGIN;

-- ── 1회차 적재 ──────────────────────────────────────────────
\i booklet-jungcheol-068-full-load.sql

-- 1회차 후 상태
SELECT '--- 1회차 후 ---' AS marker;
SELECT 'set_rows' k, count(*) v FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND del_yn='N'
UNION ALL SELECT 'prd_287_288', count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000287','PRD_000288')
UNION ALL SELECT 'fc_cover', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER'
UNION ALL SELECT 'cover_formula', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_BOOK_COVER'
UNION ALL SELECT 'mat_288', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000288' AND del_yn='N'
UNION ALL SELECT 'siz_288', count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000288' AND del_yn='N'
ORDER BY k;

-- ── 2회차 적재 (멱등 실증) ──────────────────────────────────
\i booklet-jungcheol-068-full-load.sql

-- 2회차 후 상태 (1회차와 동일해야 = delta 0)
SELECT '--- 2회차 후 (delta 0 기대) ---' AS marker;
SELECT 'set_rows' k, count(*) v FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND del_yn='N'
UNION ALL SELECT 'prd_287_288', count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000287','PRD_000288')
UNION ALL SELECT 'fc_cover', count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER'
UNION ALL SELECT 'cover_formula', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_BOOK_COVER'
UNION ALL SELECT 'mat_288', count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000288' AND del_yn='N'
UNION ALL SELECT 'siz_288', count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000288' AND del_yn='N'
ORDER BY k;

-- 068 셋트행 상세 (표지288 seq1 + 내지287 seq2)
SELECT '--- 068 셋트행 상세 ---' AS marker;
SELECT prd_cd, sub_prd_cd, sub_prd_qty, min_cnt, max_cnt, cnt_incr, disp_seq
FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND del_yn='N' ORDER BY disp_seq;

-- PRF_BOOK_COVER 비목 3개 (S8 오염 가드 — 인쇄+코팅+용지만)
SELECT '--- PRF_BOOK_COVER 비목 (3개·S8) ---' AS marker;
SELECT frm_cd, comp_cd, disp_seq, addtn_yn FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER' ORDER BY disp_seq;

-- 공식 바인딩 (287→INNER·288→COVER·068→BIND_SUM)
SELECT '--- 공식 바인딩 ---' AS marker;
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000068','PRD_000287','PRD_000288') ORDER BY prd_cd;

ROLLBACK;
SELECT '=== ROLLBACK 완료 — baseline 복귀 ===' AS marker;
