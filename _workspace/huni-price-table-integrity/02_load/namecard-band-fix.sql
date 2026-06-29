-- 명함 NAMECARD/PHOTOCARD .01 18개 밴드총액 ×수량 과대청구 교정 — FIX (COMMIT)
-- ★★★ 실 COMMIT 스크립트 — 인간 승인 완료(게이트 GO 18/18)·dryrun ROLLBACK 검증 완료 후에만 실행.
-- 종결자=COMMIT. 백업 선행(bak_t_prc_*_namecardband_<TS>)·undo=namecard-band-undo.sql 보유.
-- 권위=인쇄상품가격표 260527. 단가행 verbatim 불변 — prc_typ(price_components)·min_qty(component_prices 그룹C만) 변경.
-- 멱등 가드: prc_typ='PRICE_TYPE.01'(A/B/C) · min_qty=1(C) → 재실행 delta 0.

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

-- ── 그룹B: 동판 셋업비 .01 → .03 고정 (2개·수량무관·min_qty NULL이라 .02 불가) ──
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.03', upd_dt = now()
WHERE comp_cd IN ('COMP_NAMECARD_FOIL_SETUP_S1_STD','COMP_NAMECARD_FOIL_SETUP_S2_STD')
  AND prc_typ_cd = 'PRICE_TYPE.01';
-- 기대: 2행 UPDATE

-- ── 그룹C: 포토카드 세트단가 .01 → .02 + min_qty 1→20 재키잉 (2개·2단계) ──
UPDATE t_prc_price_components
SET prc_typ_cd = 'PRICE_TYPE.02', upd_dt = now()
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
  AND prc_typ_cd = 'PRICE_TYPE.01';
-- 기대: 2행 UPDATE

UPDATE t_prc_component_prices
SET min_qty = 20, upd_dt = now()
WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET')
  AND min_qty = 1;
-- 기대: 2행 UPDATE (comp_price_id 3439·3440)

COMMIT;  -- ★실 적용. 종결자 COMMIT 확인됨.
