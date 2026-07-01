-- =============================================================================
-- photocard-undo.sql  — 포토카드 제작방식/BULK 배선 롤백(향후 실 COMMIT본 되돌림용)
-- 대상: photocard-fix.sql(승인 후 생성될 COMMIT본)이 넣은 변경 원복.
-- 백업: photocard-backup-260701.csv (원본 opt_cd=NULL · use_dims 원값).
-- =============================================================================
BEGIN;

-- 배선 제거
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_PHOTOCARD_NORMAL' AND comp_cd='COMP_PHOTOCARD_BULK';

-- use_dims 원복
UPDATE t_prc_price_components SET use_dims='["siz_cd", "bdl_qty", "min_qty"]', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_SET';
UPDATE t_prc_price_components SET use_dims='["min_qty"]', upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_BULK';

-- 판별차원 원복 (opt_cd → NULL · 단가값 불변)
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_SET'  AND opt_cd='OPV_000495';
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_PHOTOCARD_BULK' AND opt_cd='OPV_000496';

-- 옵션값·옵션그룹 제거 (물리 DELETE — 신규 mint분이라 안전)
DELETE FROM t_prd_product_options       WHERE opt_grp_cd='OPT_000084';
DELETE FROM t_prd_product_option_groups WHERE opt_grp_cd='OPT_000084';

-- COMMIT;  -- 원복 확인 후 수동 전환
ROLLBACK;   -- 기본 dryrun 안전판
-- =============================================================================
