-- A5_fix_min_qty.sql — .02 합가형 단가행 min_qty NULL → 1 보정 (엔진 ÷min_qty ValueError·견적 불가 해소)
-- 근거(라이브 실측): COMP_ACRYL_CLEAR3T(PRICE_TYPE.02) GAP 적재분 81행 siz_width NOT NULL·min_qty NULL.
--   엔진 pricing.py:177-192 component_subtotal: .02 = unit_price ÷ tier_min_qty × qty. min_qty≤0(NULL)이면 ValueError raise→합산 제외(견적 실패).
-- ★골든 불변: min_qty=1 → unit_price ÷ 1 × qty = unit_price × qty (.01 단가형과 수학적 동일). 30x30 3T 100개 = 3,100÷1×100=310,000.
-- 전수: prc_typ_cd='PRICE_TYPE.02' & siz_width NOT NULL & min_qty NULL 인 단가행 전건(comp 하드코딩 아님). .01 단가형은 ÷min_qty 안 하므로 제외.
-- 멱등: min_qty IS NULL 인 행만 → 2-pass 0행.
UPDATE t_prc_component_prices cp
   SET min_qty = 1, upd_dt = now()
  FROM t_prc_price_components pc
 WHERE pc.comp_cd = cp.comp_cd
   AND pc.prc_typ_cd = 'PRICE_TYPE.02'
   AND cp.siz_width IS NOT NULL
   AND cp.min_qty IS NULL;
