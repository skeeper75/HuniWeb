-- UNDO: PRF_BIND_SUM 제본 배선 교정 복원 (260626)
BEGIN;
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_BIND_SUM', upd_dt=now()
 WHERE prd_cd IN ('PRD_000069','PRD_000070','PRD_000071')
   AND frm_cd IN ('PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING');
DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING');
DELETE FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_BIND_MUSEON','PRF_BIND_PUR','PRF_BIND_TWINRING');
-- 검증 후 COMMIT;
