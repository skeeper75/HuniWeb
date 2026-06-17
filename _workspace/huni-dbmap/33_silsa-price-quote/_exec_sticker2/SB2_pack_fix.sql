-- SB2 · 스티커팩(PRD_000065) prc_typ 오적재 교정 + 합가형 사슬 — UPDATE + DELETE + INSERT
-- 출처: sticker-blocked-resolution §2 (가격표 B06 "54장 1세트 4000"·엔진 합가형)
-- 진단: 현 COMP_STK_PACK .01 단가형(min_qty 1·1000 둘 다 4000)=오적재(54장세트인데 4000×수량).
-- 교정: prc_typ .01→.02 합가형 + ★min_qty=54 단일행(기존 2행 폐기) → 4000÷54=74.07/장.
-- ★min_qty=54 NOT NULL 필수(엔진 .02 base<=0 ValueError). 환산단위(장/세트)=Q-STK-3b 컨펌(권고=장·min_qty=54).

-- (1) 구성요소 prc_typ .01→.02 교정
UPDATE t_prc_price_components
   SET prc_typ_cd='PRICE_TYPE.02', upd_dt=now(),
       note=COALESCE(note,'') || ' [.01→.02 합가형 교정·54장1세트]'
 WHERE comp_cd='COMP_STK_PACK' AND prc_typ_cd='PRICE_TYPE.01';

-- (2) 기존 단가행 2개(min_qty 1·1000·단가형 전제) 폐기
DELETE FROM t_prc_component_prices
 WHERE comp_cd='COMP_STK_PACK' AND apply_ymd='2026-06-01'
   AND siz_cd='SIZ_000068' AND min_qty IN (1,1000);

-- (3) min_qty=54 단일행 적재(54장 1세트 4000 verbatim)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_PACK','2026-06-01','SIZ_000068',54,4000::numeric,'스티커팩 54장1세트 4000(합가형·min_qty=54 필수)',now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_PACK' AND cp.apply_ymd='2026-06-01'
     AND cp.siz_cd='SIZ_000068' AND cp.min_qty=54
);

-- (4) 공식 PRF_STK_PACK
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt)
SELECT 'PRF_STK_PACK','스티커팩 합가형(54장1세트 4000)','Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd='PRF_STK_PACK');

-- (5) 배선
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_STK_PACK','COMP_STK_PACK',1,'Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_STK_PACK' AND fc.comp_cd='COMP_STK_PACK');

-- (6) 바인딩 PRD_000065 → PRF_STK_PACK
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT 'PRD_000065','PRF_STK_PACK','2026-06-01',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf WHERE pf.prd_cd='PRD_000065' AND pf.apply_bgn_ymd='2026-06-01');
