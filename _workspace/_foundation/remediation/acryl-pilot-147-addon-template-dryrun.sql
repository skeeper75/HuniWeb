-- acryl-pilot-147-addon-template-dryrun.sql — DRY-RUN (ROLLBACK·구조 검증). 라이브 실증은 COMMIT 후 시뮬레이터.
\set ON_ERROR_STOP on
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_ACRYL_MAGNET';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000147','PRF_CLR_ACRYL','2026-06-28','본체 면적격자(마그넷은 addon 템플릿)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_CLR_ACRYL');
DELETE FROM t_prd_product_option_items  WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465';
DELETE FROM t_prd_product_options       WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465';
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000147' AND opt_grp_cd='OPT_000074';
INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, del_yn, reg_dt, note)
SELECT 'TMPL-000014','PRD_000147','자석부착(네오디움12mm)',1,'Y','N',now(),'아크릴마그넷 addon(가격표 B04b 800)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_templates WHERE tmpl_cd='TMPL-000014');
INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, reg_dt)
SELECT 'TMPL-000014','2026-06-28',800::numeric, now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_template_prices WHERE tmpl_cd='TMPL-000014' AND apply_ymd='2026-06-28');
INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, reg_dt)
SELECT 'PRD_000147','TMPL-000014',1, now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_addons WHERE prd_cd='PRD_000147' AND tmpl_cd='TMPL-000014');

\echo '== 구조 검증 =='
SELECT 'bind' k, frm_cd v FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147'
UNION ALL SELECT 'optgrp_remain', COALESCE(MIN(opt_grp_cd),'(none)') FROM t_prd_product_option_groups WHERE prd_cd='PRD_000147'
UNION ALL SELECT 'tmpl', tmpl_cd FROM t_prd_templates WHERE tmpl_cd='TMPL-000014'
UNION ALL SELECT 'tmpl_price', unit_price::text FROM t_prd_template_prices WHERE tmpl_cd='TMPL-000014'
UNION ALL SELECT 'addon_link', tmpl_cd FROM t_prd_product_addons WHERE prd_cd='PRD_000147';
\echo '== 본체 자재 covered 해소: 147 옵션그룹 0 (자재 드롭다운 복원) =='
SELECT COUNT(*) AS optgrp_count FROM t_prd_product_option_groups WHERE prd_cd='PRD_000147';
ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 미변경 (실증은 COMMIT 후 시뮬레이터) =='
