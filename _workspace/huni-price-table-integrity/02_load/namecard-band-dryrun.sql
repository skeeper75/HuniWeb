-- 명함 NAMECARD .01 18개 밴드총액 ×수량 과대청구 교정 — DRY-RUN (ROLLBACK)
-- 권위=인쇄상품가격표 260527·라이브 읽기전용 원칙(이 스크립트는 ROLLBACK·실 COMMIT 아님)
-- 실 COMMIT은 integrity-gate 독립 재실측 + 인간 승인 후. webadmin 엔진 코드 미변경.
-- 검증: 교정 후 시뮬레이터 037=24,200 / 024=6,000 / 025=8,500 재실증 필수.
-- 단가행 verbatim 불변 — prc_typ(price_components)·min_qty(component_prices 그룹C만) 변경.

BEGIN;

-- ── 그룹A: 밴드총액 .01 → .02 (14개·price_components.prc_typ_cd) ──
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.02', upd_dt = now()
WHERE comp_cd IN (
  'COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2',
  'COMP_NAMECARD_FOIL_S1_HOLO','COMP_NAMECARD_FOIL_S2_HOLO','COMP_NAMECARD_FOIL_S2_STD',
  'COMP_NAMECARD_PREMIUM_S1_MGA','COMP_NAMECARD_PREMIUM_S1_MGB',
  'COMP_NAMECARD_PREMIUM_S2_MGA','COMP_NAMECARD_PREMIUM_S2_MGB',
  'COMP_NAMECARD_WHITE_S1W_CL','COMP_NAMECARD_WHITE_S1W_NOCL',
  'COMP_NAMECARD_WHITE_S2W_CL','COMP_NAMECARD_WHITE_S2W_NOCL',
  'COMP_PHOTOCARD_BULK'
) AND prc_typ_cd = 'PRICE_TYPE.01';
-- 기대: 14행 UPDATE

-- ── 그룹B: 동판 셋업비 .01 → .03 고정 (2개·★수량무관·min_qty NULL이라 .02 불가) ──
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.03', upd_dt = now()
WHERE comp_cd IN ('COMP_NAMECARD_FOIL_SETUP_S1_STD','COMP_NAMECARD_FOIL_SETUP_S2_STD')
  AND prc_typ_cd = 'PRICE_TYPE.01';
-- 기대: 2행 UPDATE

-- ── 그룹C: 포토카드 세트단가 .01 → .02 + min_qty 1→20 재키잉 (2개·★2단계) ──
-- 1) prc_typ .01 → .02
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.02', upd_dt = now()
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
  AND prc_typ_cd = 'PRICE_TYPE.01';
-- 기대: 2행 UPDATE
-- 2) min_qty 1 → 20 (divisor=20·"20장1세트"). component_prices.
UPDATE t_prc_component_prices
SET min_qty = 20, upd_dt = now()
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
  AND min_qty = 1;
-- 기대: 2행 UPDATE (comp_price_id 3439·3440)
-- ★주의: 손님 qty=장수·incr20·step20 제약 전제(qty_rule min20 incr20과 정합).
--   만약 손님 qty 단위가 '세트수'면 그룹C는 .01 유지가 맞음 → integrity-gate가 webadmin
--   상품 qty_rule·위젯 입력단위로 최종 확정 후 적용(qty 의미가 .02+min20 판정의 유일 가정).

-- ── 검증 출력(ROLLBACK 전) ──
SELECT comp_cd, prc_typ_cd FROM t_prc_price_components
WHERE comp_cd LIKE 'COMP_NAMECARD%' OR comp_cd LIKE 'COMP_PHOTOCARD%'
ORDER BY prc_typ_cd, comp_cd;

ROLLBACK;  -- ★DRY-RUN. 실 적용 시 인간 승인 후 COMMIT으로 교체.
