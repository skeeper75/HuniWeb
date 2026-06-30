-- foil-pilot-namecard031-load.sql — 프리미엄명함 PRD_000031 (소형) 박류 파일럿 적재본
-- 생성: gen_foil_pilot.py (결정론·재현가능·단가 verbatim from price-foil-small-l1.csv·날조 0)
-- 권위: engine-design-foil.md REV4 + golden-cases-foil.md + webadmin-dim-editor-foil-fit.md
-- 범위: 소형 comp 3종 + PRD_000031 박색상(037~044) 단가행 + 분기 공식 바인딩만.
--       대형 comp·다른 6상품·명함박(PRD_000037/PRF_NAMECARD_FOIL)은 미터치.
-- FK 위상순서: ① price_components → ② component_prices(comp_cd·proc_cd 부모 실재)
--              → ③ price_formulas → ④ formula_components → ⑤ product_price_formulas(rebind)
-- 멱등: 전부 NOT EXISTS NULL-safe 가드(nat_key UNIQUE가 NULLS DISTINCT라 ON CONFLICT 불가→NOT EXISTS).
--       재실행 시 0행 영향(NO-OP). comp_price_id=IDENTITY BY DEFAULT(미지정·자동채번).
-- 코드 선적재: PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 전부 라이브 실재 → 코드행 선적재 불요.
-- 분기 공식: PRF_NAMECARD_FIXED(031·032·033 공유)에 박 직접합산하면 032/033에 박 노출 →
--            클론 PRF_NAMECARD_FIXED_FOIL 만들어 PRD_000031만 재바인딩(형제 미영향·Q-FOIL-FRM1).
--            proc_cd 게이트로 박 미선택 주문은 박 comp no_match→0(silent 합산 0).
-- [HARD] 인간 승인 전 COMMIT 금지. 이 파일은 COMMIT 을 주석처리해 둠 — dryrun 은 별 파일(ROLLBACK).
SET client_min_messages = warning;
BEGIN;


\i foil-pilot-namecard031-body.sql

-- 사후검증(승인 실행 시):
--   SELECT comp_cd, count(*) FROM t_prc_component_prices
--    WHERE comp_cd LIKE 'COMP_FOIL_%SMALL%' GROUP BY comp_cd ORDER BY comp_cd;
--   -- 기대: SETUP_SMALL 8 · PROC_SMALL_STD 1620 · PROC_SMALL_SPECIAL 540
--   SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
--    WHERE prd_cd='PRD_000031' ORDER BY apply_bgn_ymd;  -- 2026-07-01 행 = PRF_NAMECARD_FIXED_FOIL

-- COMMIT;   -- ← [HARD] 인간 승인 후에만 주석 해제. 그 전엔 아래 ROLLBACK 으로 종료.
ROLLBACK;
