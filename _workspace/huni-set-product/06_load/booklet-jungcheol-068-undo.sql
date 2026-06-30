-- ================================================================
-- booklet-jungcheol-068 UNDO (역연산·백업 스냅샷으로 baseline 복원)
-- 생성: hsp-load-executor 2026-07-01 · 대응 COMMIT = booklet-jungcheol-068-apply.sql
-- 전제: bak_*_setbuild_20260701_0134 백업 테이블 10종 존재(booklet-jungcheol-068-backup-20260701_0134.sql 로 생성).
-- 방식: 적재가 신규 mint(287/288·PRF_BOOK_COVER·셋트행 2)이므로 baseline=대부분 0행.
--       → 적재분 물리 제거 후 백업 스냅샷(068 부모공식 PRF_BIND_SUM·068 products 행)으로 원복.
--       ★068 부모공식 PRF_BIND_SUM·068 products 행은 적재 전부터 존재(백업에 보존) → DELETE 금지·UPDATE 미발생.
-- 주의: 실행 전 백업 테이블 행수가 baseline 과 일치하는지 확인할 것.
-- ================================================================
BEGIN;

-- [1] 068 셋트행 2건 제거 (적재로 신규 추가된 표지288+내지287 — baseline=0행)
DELETE FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND sub_prd_cd IN ('PRD_000287','PRD_000288');

-- [2] 287/288 공식 바인딩 제거 (288→COVER·287→INNER — baseline=0행)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000287','PRD_000288');

-- [3] 287/288 차원 제거 (사이즈·인쇄옵션·자재·판형·공정 — baseline=0행)
DELETE FROM t_prd_product_processes   WHERE prd_cd IN ('PRD_000287','PRD_000288');
DELETE FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000287','PRD_000288');
DELETE FROM t_prd_product_materials   WHERE prd_cd IN ('PRD_000287','PRD_000288');
DELETE FROM t_prd_product_print_options WHERE prd_cd IN ('PRD_000287','PRD_000288');
DELETE FROM t_prd_product_sizes       WHERE prd_cd IN ('PRD_000287','PRD_000288');

-- [4] 287/288 반제품 제거 (baseline=0행)
DELETE FROM t_prd_products WHERE prd_cd IN ('PRD_000287','PRD_000288');

-- [5] PRF_BOOK_COVER 신규공식 + formula_components 제거 (baseline=0행)
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_BOOK_COVER';

-- [6] 068 부모공식 PRF_BIND_SUM note 가 적재로 갱신됐을 수 있음 → 백업 스냅샷으로 원복
--     (적재 위상4 가 note 를 UPDATE 했을 경우 baseline note 로 복원)
UPDATE t_prd_product_price_formulas t
SET frm_cd = b.frm_cd, note = b.note, upd_dt = b.upd_dt
FROM bak_t_prd_product_price_formulas_setbuild_20260701_0134 b
WHERE t.prd_cd = b.prd_cd AND t.apply_bgn_ymd = b.apply_bgn_ymd
  AND t.prd_cd = 'PRD_000068';

-- 검증
SELECT 'sets' k, count(*) v FROM t_prd_product_sets WHERE prd_cd='PRD_000068' AND sub_prd_cd IN ('PRD_000287','PRD_000288')
UNION ALL SELECT '287_288', count(*) FROM t_prd_products WHERE prd_cd IN ('PRD_000287','PRD_000288')
UNION ALL SELECT 'cover_formula', count(*) FROM t_prc_price_formulas WHERE frm_cd='PRF_BOOK_COVER';

COMMIT;
-- 실행 후 위 3행 모두 0 이어야 baseline 복귀 완료.
