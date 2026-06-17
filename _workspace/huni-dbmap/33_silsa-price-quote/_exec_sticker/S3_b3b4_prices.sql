-- S3 · B4/B3 단가행 채움 (GAP-SIZ-3) — 즉시 GO (siz 라이브 실존·채번 0)
-- 출처: 20_price-import/sticker/sticker-import.xlsx#4b_component_prices_BLOCKED (verbatim) + 라이브 SIZ_000515(B4)·SIZ_000514(B3) 실존
-- arbiter §4.2 권위: 단일 comp COMP_STK_PRINT, B02 일반낱장=mat 153(유포), B03 투명낱장=mat 162(투명스티커).
--   (xlsx 4b 의 mat 165/COMP_STK_PRINT_CLEAR 는 round-16 stale → arbiter 153/162·단일 comp 채택)
-- 멱등: 자연키 NOT EXISTS. search-before-mint: siz/mat 신규 0.
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note, reg_dt)
SELECT 'COMP_STK_PRINT', v.apply_ymd, v.siz_cd, v.mat_cd, v.min_qty, v.unit_price, v.note, now()
FROM (VALUES
  ('2026-06-01','SIZ_000514','MAT_000153',1,12000::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000514','MAT_000153',20,11640::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000514','MAT_000153',50,11400::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000514','MAT_000153',100,10800::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000514','MAT_000153',200,10200::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000514','MAT_000153',300,9600::numeric,'B02 유포 B3'),
  ('2026-06-01','SIZ_000515','MAT_000153',1,6000::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000515','MAT_000153',20,5820::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000515','MAT_000153',50,5700::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000515','MAT_000153',100,5400::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000515','MAT_000153',200,5100::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000515','MAT_000153',300,4800::numeric,'B02 유포 B4'),
  ('2026-06-01','SIZ_000514','MAT_000162',1,21000::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000514','MAT_000162',20,20370::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000514','MAT_000162',50,19950::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000514','MAT_000162',100,18900::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000514','MAT_000162',200,17850::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000514','MAT_000162',300,16800::numeric,'B03 투명 B3'),
  ('2026-06-01','SIZ_000515','MAT_000162',1,10500::numeric,'B03 투명 B4'),
  ('2026-06-01','SIZ_000515','MAT_000162',20,10185::numeric,'B03 투명 B4'),
  ('2026-06-01','SIZ_000515','MAT_000162',50,9975::numeric,'B03 투명 B4'),
  ('2026-06-01','SIZ_000515','MAT_000162',100,9450::numeric,'B03 투명 B4'),
  ('2026-06-01','SIZ_000515','MAT_000162',200,8925::numeric,'B03 투명 B4'),
  ('2026-06-01','SIZ_000515','MAT_000162',300,8400::numeric,'B03 투명 B4')
) AS v(apply_ymd, siz_cd, mat_cd, min_qty, unit_price, note)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd='COMP_STK_PRINT' AND cp.apply_ymd=v.apply_ymd
     AND cp.siz_cd=v.siz_cd AND cp.mat_cd=v.mat_cd AND cp.min_qty=v.min_qty
);
