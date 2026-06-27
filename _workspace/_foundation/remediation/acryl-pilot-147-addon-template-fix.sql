-- acryl-pilot-147-addon-template-fix.sql — addon 모델 교정 파일럿: 147 마그넷 (라이브 COMMIT 후보)
-- 목적: 깨진 가산형(opt_cd comp+OPT_REF_DIM.03)을 엔진 정식 addon 템플릿으로 교정·라이브 실증.
-- 결함(FINDING-addon-optcd-model-broken.md): 마그넷 옵션그룹(OPT_000074)의 자재참조가 본체 mat_cd 가림 → 본체 0원.
-- 교정 3단계:
--   ① 147 바인딩 PRF_ACRYL_MAGNET → PRF_CLR_ACRYL(본체 면적격자만·159 코스터 동형 정상).
--   ② 마그넷 옵션그룹/옵션/아이템 제거 → 본체 자재(MAT_043) 드롭다운 복원(covered 해소).
--   ③ 마그넷 = addon 템플릿(flat 단가 800)+링크. evaluate_price(target=tmpl)가 unit_price×qty로 개별 평가·합산(pricing.py:436-441).
-- 권위: 가격표 B04b 마그넷 자석부착=800. 채번 TMPL-000014(라이브 MAX TMPL-000013+1).
-- ★COMP_ACRYL_MAGNET/PRF_ACRYL_MAGNET 잔재는 미터치(고아·무해)=별 정리 트랙. ★실 COMMIT은 인간 승인 후·라이브 시뮬레이터 실증 후 전파.
\set ON_ERROR_STOP on
BEGIN;

-- ① 본체 바인딩 교체 (가산형 공식 → 공유 면적격자 공식)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_ACRYL_MAGNET';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000147','PRF_CLR_ACRYL','2026-06-28','본체 면적격자(마그넷은 addon 템플릿)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000147' AND frm_cd='PRF_CLR_ACRYL');

-- ② 마그넷 옵션그룹 제거 (본체 자재 covered 해소) — 옵션아이템→옵션→그룹 순
DELETE FROM t_prd_product_option_items  WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465';
DELETE FROM t_prd_product_options       WHERE prd_cd='PRD_000147' AND opt_cd='OPV_000465';
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000147' AND opt_grp_cd='OPT_000074';

-- ③ 마그넷 addon 템플릿 + flat 단가 + 링크
INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, del_yn, reg_dt, note)
SELECT 'TMPL-000014','PRD_000147','자석부착(네오디움12mm)',1,'Y','N',now(),'아크릴마그넷 addon(가격표 B04b 800)'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_templates WHERE tmpl_cd='TMPL-000014');

INSERT INTO t_prd_template_prices (tmpl_cd, apply_ymd, unit_price, reg_dt)
SELECT 'TMPL-000014','2026-06-28',800::numeric, now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_template_prices WHERE tmpl_cd='TMPL-000014' AND apply_ymd='2026-06-28');

INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, reg_dt)
SELECT 'PRD_000147','TMPL-000014',1, now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_addons WHERE prd_cd='PRD_000147' AND tmpl_cd='TMPL-000014');

COMMIT;
