-- 031 프리미엄 교정 원복 (2026-06-30)
BEGIN;
-- 바인딩 원복
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000031' AND frm_cd IN ('PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL');
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note) VALUES
  ('PRD_000031','PRF_NAMECARD_FIXED','2026-06-01','프리미엄명함→면/소재/수량'),
  ('PRD_000031','PRF_NAMECARD_FIXED_FOIL','2026-07-01','박 분기 공식으로 재바인딩(파일럿·인간승인 후 COMMIT)');
-- 자재 원복
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, dflt_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000099';
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000119';
UPDATE t_prd_product_materials SET dflt_yn='N', upd_dt=now() WHERE prd_cd='PRD_000031' AND mat_cd='MAT_000101';
-- 단가행 원복 (28 mat_cd행 삭제→grade-only 4행 복원)
DELETE FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_PREMIUM%' AND mat_cd IS NOT NULL;
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,min_qty,unit_price) VALUES
  (3330,'COMP_NAMECARD_PREMIUM_S1_MGA','2026-06-01',100,4500),(3331,'COMP_NAMECARD_PREMIUM_S1_MGB','2026-06-01',100,5000),
  (3332,'COMP_NAMECARD_PREMIUM_S2_MGA','2026-06-01',100,5500),(3333,'COMP_NAMECARD_PREMIUM_S2_MGB','2026-06-01',100,6500);
UPDATE t_prc_price_components SET use_dims='["min_qty"]' WHERE comp_cd LIKE 'COMP_NAMECARD_PREMIUM%';
-- 공식 제거
DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL');
DELETE FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_NAMECARD_PREMIUM','PRF_NAMECARD_PREMIUM_FOIL');
COMMIT;
