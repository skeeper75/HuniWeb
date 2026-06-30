-- foil-prop-load.sql — 박류 동형 전파 적재본 (6상품·대형 comp + 펄명함 소형 재사용)
-- 생성: gen_foil_prop.py (결정론·재현가능·단가 verbatim from price-foil-large-l1.csv·날조 0)
-- 권위: engine-design-foil.md REV4 + golden-cases-foil.md + 검증가 offgrid-flatten-validation-foil.md(GO)
-- 범위: 대형 comp 3종 + 6상품 등록 박색상(037~044) 대형 단가행 + 6 분기 공식 바인딩.
--       파일럿(PRD_000031 소형 3 comp + PRF_NAMECARD_FIXED_FOIL)·명함박(PRD_000037)은 미터치.
--       펄명함034는 소형이라 기존 라이브 COMP_FOIL_*SMALL* (파일럿 적재분) 재사용 — 신규 단가행 0.
-- FK 위상순서: ① price_components(대형 3) → ② component_prices(7168·proc_cd 부모 실재)
--              → ③ price_formulas(분기 3종) → ④ formula_components(base 클론+박) → ⑤ product_price_formulas(rebind 6)
-- 멱등: 전부 NOT EXISTS NULL-safe 가드(nat_key UNIQUE가 NULLS DISTINCT라 ON CONFLICT 불가→NOT EXISTS).
--       재실행 시 0행 영향(NO-OP). comp_price_id=IDENTITY BY DEFAULT(미지정·자동채번). reg_dt=now() DEFAULT.
-- 코드 선적재: PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 전부 라이브 실재 → 코드행 선적재 불요.
-- 분기 공식: 공유 base(PRF_DGP_E 027/029·PRF_DGP_A 10상품 등)에 박 직접합산하면 형제에 박 노출 →
--            클론 base_FOIL 만들어 해당 상품만 재바인딩(형제 미영향·Q-FOIL-FRM1 파일럿 패턴).
--            proc_cd 게이트(동판비·박가공비 단가행 전부 proc_cd 충전)로 박 미선택 주문은 박 comp no_match→0.
-- [HARD] 인간 승인 전 COMMIT 금지. 이 파일은 COMMIT 을 주석처리해 둠 — dryrun 은 별 파일(ROLLBACK).
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

\i foil-prop-body.sql

-- 사후검증(승인 실행 시):
--   SELECT comp_cd, count(*) FROM t_prc_component_prices
--    WHERE comp_cd LIKE 'COMP_FOIL_%LARGE%' GROUP BY comp_cd ORDER BY comp_cd;
--   -- 기대: SETUP_LARGE 512 · PROC_LARGE_STD 3328 · PROC_LARGE_SPECIAL 3328
--   SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas
--    WHERE prd_cd IN ('PRD_000027','PRD_000029','PRD_000034','PRD_000042','PRD_000069','PRD_000070')
--    ORDER BY prd_cd, apply_bgn_ymd;  -- 2026-07-01 행 = *_FOIL 분기 공식

-- COMMIT;   -- ← [HARD] 인간 승인 후에만 주석 해제. 그 전엔 아래 ROLLBACK 으로 종료.
ROLLBACK;
