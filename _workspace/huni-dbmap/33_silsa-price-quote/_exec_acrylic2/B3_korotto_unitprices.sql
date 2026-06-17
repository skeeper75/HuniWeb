-- B3_korotto_unitprices.sql — 코롯토 단가행 21 verbatim INSERT (siz_width/siz_height·채번 0)
-- 출처(HARD·날조 금지): acrylic-import.xlsx 시트 5_korotto_NEW B06 21조합 (siz_cd 17 siz_nm 파싱 + GAP 4 GxS). W앞·H뒤.
-- prc_typ .01 단가형이나 min_qty=1 명시(일관성·.01은 ÷안 하나 NULL 회피). 좌표 siz 채번 0(siz_cd 미사용·WH 직접).
-- 멱등: 자연키(comp,apply_ymd,siz_width,siz_height, 그외 차원 NULL) NOT EXISTS 가드 → 2-pass delta 0.
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_width, siz_height, min_qty, unit_price)
SELECT v.comp_cd, v.apply_ymd, v.siz_width, v.siz_height, 1, v.unit_price
FROM (VALUES
  ('COMP_ACRYL_COROTTO','2026-06-01',30,30,3600),
  ('COMP_ACRYL_COROTTO','2026-06-01',30,40,4400),
  ('COMP_ACRYL_COROTTO','2026-06-01',50,30,4400),
  ('COMP_ACRYL_COROTTO','2026-06-01',30,60,5200),
  ('COMP_ACRYL_COROTTO','2026-06-01',30,70,5200),
  ('COMP_ACRYL_COROTTO','2026-06-01',80,30,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',40,40,4400),
  ('COMP_ACRYL_COROTTO','2026-06-01',40,50,5200),
  ('COMP_ACRYL_COROTTO','2026-06-01',60,40,5200),
  ('COMP_ACRYL_COROTTO','2026-06-01',40,70,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',40,80,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',50,50,5200),
  ('COMP_ACRYL_COROTTO','2026-06-01',50,60,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',70,50,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',80,50,8000),
  ('COMP_ACRYL_COROTTO','2026-06-01',60,60,6400),
  ('COMP_ACRYL_COROTTO','2026-06-01',60,70,8000),
  ('COMP_ACRYL_COROTTO','2026-06-01',60,80,8000),
  ('COMP_ACRYL_COROTTO','2026-06-01',70,70,8000),
  ('COMP_ACRYL_COROTTO','2026-06-01',70,80,8400),
  ('COMP_ACRYL_COROTTO','2026-06-01',80,80,8400)
) AS v(comp_cd, apply_ymd, siz_width, siz_height, unit_price)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices cp
   WHERE cp.comp_cd = v.comp_cd AND cp.apply_ymd = v.apply_ymd
     AND cp.siz_width = v.siz_width AND cp.siz_height = v.siz_height
     AND cp.siz_cd IS NULL AND cp.plt_siz_cd IS NULL AND cp.clr_cd IS NULL AND cp.mat_cd IS NULL
     AND cp.proc_cd IS NULL AND cp.opt_cd IS NULL AND cp.print_opt_cd IS NULL
     AND cp.coat_side_cnt IS NULL AND cp.bdl_qty IS NULL
     AND COALESCE(cp.dim_vals,'{}'::jsonb) = '{}'::jsonb
);
