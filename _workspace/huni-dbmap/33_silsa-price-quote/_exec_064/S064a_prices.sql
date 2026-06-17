-- S064a · 소량자유형(PRD_000064) 소형 7사이즈 단가행 — B01 col1 규격가 사이즈무관 동일 적용 (잠정)
-- 출처: 라이브 B01 col1 = COMP_STK_PRINT·SIZ_000059(124x186)·5소재(153/084/242/155/156)×36mq verbatim 복사
--   사용자 결정: 064 소형 7사이즈(가격표 단가 부재)에 B01 col1 규격가를 사이즈 무관 동일 적용·우선 등록 후 추후 변경.
-- 7 siz(SIZ_036 94x94·043 80x80·061 50x70·062 70x50·063 50x94·064 94x50·065 65x65) × 5소재 × 36mq = 1260행.
-- ★단가 = SIZ_059 단가 verbatim 복사(INSERT…SELECT·하드코딩 0·소재별/수량밴드별 그대로).
-- ★note 잠정: 실무진이 잠정임을 식별 가능하게(추후 실측 단가로 변경).
-- 멱등: 자연키(comp_cd,apply_ymd,siz_cd,mat_cd,min_qty) NOT EXISTS (PK=시퀀스라 ON CONFLICT 불가).
-- search-before-mint: 064 siz 7종·소재 5종 전부 라이브 실존(신규 채번 0).
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_PRINT', src.apply_ymd, tgt.siz_cd, src.mat_cd, src.min_qty, src.unit_price,
       '[잠정] 소형반칼 B01 규격가(col1·124x186) 사이즈무관 적용·실측 단가 미수령·추후 변경 (064 소량자유형)',
       now()
FROM (
  SELECT apply_ymd, mat_cd, min_qty, unit_price
    FROM t_prc_component_prices
   WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000059' AND apply_ymd='2026-06-01'
     AND mat_cd IN ('MAT_000153','MAT_000084','MAT_000242','MAT_000155','MAT_000156')
) src
CROSS JOIN (VALUES
  ('SIZ_000036'),('SIZ_000043'),('SIZ_000061'),('SIZ_000062'),
  ('SIZ_000063'),('SIZ_000064'),('SIZ_000065')
) AS tgt(siz_cd)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_PRINT' AND cp.apply_ymd=src.apply_ymd
     AND cp.siz_cd=tgt.siz_cd AND cp.mat_cd=src.mat_cd AND cp.min_qty=src.min_qty
);
