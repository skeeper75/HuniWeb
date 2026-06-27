-- acryl-146-keyring-fix.sql — 146 아크릴키링 저청구 교정 (라이브 COMMIT)
-- 결함: 146→PRF_CLR_ACRYL(본체 COMP_ACRYL_CLEAR3T만) → 손님이 고리 골라도 가산 0 = 저청구(은색1100·금색1200 누락).
-- 교정: 신규 PRF_ACRYL_KEYRING(본체+고리 KEYRING comp 재사용) 신설 → 146 재바인딩. 단가 verbatim·기존 comp/단가행 미터치.
-- ★Step1(고리). 고리없음/구슬줄/볼체인(추가상품)은 옵션 미존재라 Step2(147~152 배치·채번결정 후).
BEGIN;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) VALUES
 ('PRF_ACRYL_KEYRING','아크릴키링 공식','본체 면적 + 고리 가산(146 저청구 교정)','Y');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) VALUES
 ('PRF_ACRYL_KEYRING','COMP_ACRYL_CLEAR3T',1,'N'),
 ('PRF_ACRYL_KEYRING','COMP_ACRYL_KEYRING',2,'Y');
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000146' AND frm_cd IN ('PRF_CLR_ACRYL','PRF_ACRYL_KEYRING');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000146','PRF_ACRYL_KEYRING','2026-06-28','아크릴키링 — 본체+고리(저청구 교정)');
COMMIT;
