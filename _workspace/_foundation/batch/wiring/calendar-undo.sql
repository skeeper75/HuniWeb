-- calendar-undo.sql — 캘린더 제본비 배선 롤백 (실 -fix.sql COMMIT 후 되돌리기용)
-- calendar-fix(108/109/110 배선)를 정확히 역순으로 되돌린다. 111/112는 미변경이므로 무관.
\set ON_ERROR_STOP on
BEGIN;

-- (5역) 110 base 공식 바인딩 제거 (fix가 신규 INSERT한 행)
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000110' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-07-01';

-- (4역) 108/109 공식 재바인딩 원복 (PRF_DGP_CAL_DESK → PRF_DGP_INNER)
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_DGP_INNER',
       note='탁상형캘린더(220) -- 용지+인쇄 base 공식 배선(스탠드비는 권위 미확보로 보류) 260701',
       upd_dt=now()
 WHERE prd_cd='PRD_000108' AND apply_bgn_ymd='2026-07-01';
UPDATE t_prd_product_price_formulas
   SET frm_cd='PRF_DGP_INNER',
       note='미니탁상형캘린더 -- 용지+인쇄 base 공식 배선(스탠드비는 권위 미확보로 보류) 260701',
       upd_dt=now()
 WHERE prd_cd='PRD_000109' AND apply_bgn_ymd='2026-07-01';

-- (3역) 108/109 제본 공정 등록 제거 (fix가 신규 INSERT한 행 — 원래 없었음)
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000108' AND proc_cd='PROC_000100';
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000109' AND proc_cd='PROC_000102';

-- (2역)(1역) 신규 공식 구성요소 + 공식 제거
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_CAL_DESK';
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_CAL_DESK';

COMMIT;
\echo '=== undo COMMIT 완료 ==='
