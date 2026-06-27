-- acryl-bind-safe6-fix.sql — 아크릴 검증완료 안전 6상품 공식 바인딩 (라이브 COMMIT)
-- 출처: §18 validator 독립 골든검증 GO(저청구 0·신규mint 0). R3 면적격자 완전화 후.
-- 157 임시 BYSIZ 폐기→면적전환. 158·159·161·162→PRF_CLR_ACRYL. 164→PRF_COROTTO_ACRYL(고아 formula 해소).
-- 코드 환원(_reduce_siz_dims) 운영배포 확정 전제. ★addon 7상품·163·BLOCKED는 제외(저청구/견적불가).
BEGIN;
-- 157 임시 BYSIZ 데이터모델 폐기
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000157' AND frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_component_prices       WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
DELETE FROM t_prc_formula_components      WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_formulas          WHERE frm_cd='PRF_ACRYL_BYSIZ';
DELETE FROM t_prc_price_components        WHERE comp_cd='COMP_ACRYL_3T_BYSIZ';
-- 멱등: 기존 동일 바인딩 제거 후 삽입
DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000157','PRD_000158','PRD_000159','PRD_000161','PRD_000162') AND frm_cd='PRF_CLR_ACRYL';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000164' AND frm_cd='PRF_COROTTO_ACRYL';
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note) VALUES
 ('PRD_000157','PRF_CLR_ACRYL','2026-06-28','아크릴네임택 — 면적공식(BYSIZ폐기·환원배포)'),
 ('PRD_000158','PRF_CLR_ACRYL','2026-06-28','아크릴 포카키링 — 면적공식'),
 ('PRD_000159','PRF_CLR_ACRYL','2026-06-28','아크릴 코스터 — 면적공식'),
 ('PRD_000161','PRF_CLR_ACRYL','2026-06-28','판아크릴 — 면적공식'),
 ('PRD_000162','PRF_CLR_ACRYL','2026-06-28','아크릴포카스탠드 — 면적공식'),
 ('PRD_000164','PRF_COROTTO_ACRYL','2026-06-28','아크릴코롯토 — 코롯토공식(고아 formula 해소)');
COMMIT;
