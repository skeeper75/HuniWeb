-- foil-prop-undo.sql — 박 동형전파 적재 되돌리기 (COMMIT 후 회수용)
-- FK 역순: ⑤ 바인딩 → ④ formula_components → ③ formula → ② component_prices → ① components.
-- 다른 데이터 미영향: 신규 comp/공식/바인딩만 삭제. 기존 base 바인딩(2026-06-01/06-27)·형제 상품·명함박·파일럿(031 소형) 미터치.
-- [HARD] 인간 승인 후에만 COMMIT. 기본 ROLLBACK.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

-- ⑤ 재바인딩 행 제거 (6상품의 2026-07-01 행만)
DELETE FROM t_prd_product_price_formulas
 WHERE FALSE OR (prd_cd='PRD_000034' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_NAMECARD_PEARL_FOIL')
 OR (prd_cd='PRD_000029' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_DGP_E_FOIL')
 OR (prd_cd='PRD_000027' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_DGP_E_FOIL')
 OR (prd_cd='PRD_000042' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_DGP_A_FOIL')
 OR (prd_cd='PRD_000069' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_BIND_MUSEON_FOIL')
 OR (prd_cd='PRD_000070' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_BIND_PUR_FOIL');

-- ④ 분기 공식 구성요소
DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_BIND_MUSEON_FOIL', 'PRF_BIND_PUR_FOIL', 'PRF_DGP_A_FOIL', 'PRF_DGP_E_FOIL', 'PRF_NAMECARD_PEARL_FOIL');

-- ③ 분기 공식
DELETE FROM t_prc_price_formulas WHERE frm_cd IN ('PRF_BIND_MUSEON_FOIL', 'PRF_BIND_PUR_FOIL', 'PRF_DGP_A_FOIL', 'PRF_DGP_E_FOIL', 'PRF_NAMECARD_PEARL_FOIL');

-- ② 대형 박 단가행 (소형 comp는 파일럿 소유라 미터치)
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_FOIL_SETUP_LARGE','COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL');

-- ① 대형 박 comp 3종
DELETE FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_FOIL_SETUP_LARGE','COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL');

-- COMMIT;   -- ← 인간 승인 후 주석 해제
ROLLBACK;
