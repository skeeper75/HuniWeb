-- foil-pilot-namecard031-undo.sql — 파일럿 적재 되돌리기 (COMMIT 후 회수용)
-- FK 역순 삭제: ⑤ 바인딩 → ④ formula_components → ③ formula → ② component_prices → ① components.
-- 다른 데이터 미영향: 신규 코드/행만 삭제. 기존 2026-06-01 PRD_000031 바인딩·형제 032/033·명함박 미터치.
-- [HARD] 인간 승인 후에만 COMMIT. 기본 ROLLBACK.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

-- ⑤ 재바인딩 행 제거(기존 2026-06-01 행 보존 → 엔진 자동 복귀)
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000031' AND apply_bgn_ymd='2026-07-01' AND frm_cd='PRF_NAMECARD_FIXED_FOIL';

-- ④ 분기 공식 구성요소
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL';

-- ③ 분기 공식
DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_NAMECARD_FIXED_FOIL';

-- ② 박 단가행 (소형 3 comp)
DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_FOIL_SETUP_SMALL','COMP_FOIL_PROC_SMALL_STD','COMP_FOIL_PROC_SMALL_SPECIAL');

-- ① 박 comp 3종 (component_prices CASCADE 되나 위에서 명시 삭제)
DELETE FROM t_prc_price_components
 WHERE comp_cd IN ('COMP_FOIL_SETUP_SMALL','COMP_FOIL_PROC_SMALL_STD','COMP_FOIL_PROC_SMALL_SPECIAL');

-- COMMIT;   -- ← 인간 승인 후 주석 해제
ROLLBACK;
