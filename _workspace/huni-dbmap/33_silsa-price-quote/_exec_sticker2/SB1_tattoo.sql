-- SB1 · 타투스티커(PRD_000067) 합가형 가격사슬 신설 — formula + component + 단가행 + 바인딩
-- 출처: sticker-blocked-resolution §1 (가격표 B05 A81/B81 verbatim·엔진 pricing.py 합가형)
-- ★.02 합가형 단가행 min_qty=3 NOT NULL 필수(엔진 base=unit/tier_min_qty·base<=0 ValueError).
-- 환산: 4000÷3=1333.33/장 × 주문수량. 기본가 2000(A80)은 합가형 표현 불가→BLOCKED(blocked-and-gaps).
-- search-before-mint: mat_167(타투전용지)·siz_060(90x190) 라이브 실존·신규 frm/comp만.

-- (1) 구성요소 COMP_STK_TATTOO (.02 합가형)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, prc_typ_cd, use_dims, use_yn, reg_dt)
SELECT 'COMP_STK_TATTOO','타투스티커 단가(3장 합가형) [COMP_STK_TATTOO]','PRICE_TYPE.02','["siz_cd", "mat_cd", "min_qty"]','Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_components c WHERE c.comp_cd='COMP_STK_TATTOO');

-- (2) 공식 PRF_STK_TATTOO
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt)
SELECT 'PRF_STK_TATTOO','타투스티커 합가형(3장당 4000)','Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd='PRF_STK_TATTOO');

-- (3) 배선 formula_components (disp_seq=1·addtn_yn=Y·STK_FIXED 패턴)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_STK_TATTOO','COMP_STK_TATTOO',1,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_STK_TATTOO' AND fc.comp_cd='COMP_STK_TATTOO');

-- (4) 단가행 (siz_060·mat_167·min_qty=3·4000 verbatim)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_TATTOO','2026-06-01','SIZ_000060','MAT_000167',3,4000::numeric,'타투 3장당 4000(합가형·min_qty=3 필수)',now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_TATTOO' AND cp.apply_ymd='2026-06-01'
     AND cp.siz_cd='SIZ_000060' AND cp.mat_cd='MAT_000167' AND cp.min_qty=3
);

-- (5) 바인딩 PRD_000067 → PRF_STK_TATTOO (PK=(prd,apply_bgn_ymd))
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT 'PRD_000067','PRF_STK_TATTOO','2026-06-01',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd='PRD_000067' AND pf.apply_bgn_ymd='2026-06-01');
