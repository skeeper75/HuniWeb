-- acryl-pilot-147-addon-template-undo.sql — 147 파일럿 역연산 (인간 승인 후만)
-- 원복: addon 템플릿/링크/단가 제거 + 바인딩 PRF_CLR_ACRYL→PRF_ACRYL_MAGNET + 마그넷 옵션그룹 복원.
BEGIN;
-- addon 제거
DELETE FROM t_prd_product_addons WHERE prd_cd='PRD_000147' AND tmpl_cd='TMPL-000014';
DELETE FROM t_prd_template_prices WHERE tmpl_cd='TMPL-000014';
DELETE FROM t_prd_templates WHERE tmpl_cd='TMPL-000014';
-- 바인딩 원복
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_CLR_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000147','PRF_ACRYL_MAGNET','2026-06-28','addon — 본체+가공 가산'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_ACRYL_MAGNET');
-- 마그넷 옵션그룹 복원
INSERT INTO t_prd_product_option_groups (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000147','OPT_000074','자석부착','SEL_TYPE.01',0,1,'N',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups WHERE prd_cd='PRD_000147' AND opt_grp_cd='OPT_000074');
INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
SELECT 'PRD_000147','OPV_000465','OPT_000074','자석부착','N',1,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465');
INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn)
SELECT 'PRD_000147','OPV_000465',1,'OPT_REF_DIM.03','MAT_000050','USAGE.07',NULL,'Y','N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465' AND item_seq=1);
COMMIT;
