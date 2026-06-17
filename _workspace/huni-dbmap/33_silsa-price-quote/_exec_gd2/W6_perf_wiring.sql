-- W6_perf_wiring.sql — 미싱(PERF_1L) 배선 (W5 차원전환 후·disp_seq=9)
-- W5로 PERF_1L이 proc_cd/proc_grp 모델(.01)로 통일된 뒤에야 다른 후가공과 동형 배선 가능.
-- 멱등: (frm_cd,comp_cd) NOT EXISTS. 단가행 재적재 0.
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, 'COMP_PP_PERF_1L', 9, 'Y', now()
FROM (VALUES
  ('PRF_POSTER_ARTPRINT'),
  ('PRF_POSTER_ARTPAPER'),
  ('PRF_POSTER_WATERPROOF'),
  ('PRF_POSTER_ADH_WP'),
  ('PRF_POSTER_ADH_CLEAR'),
  ('PRF_POSTER_ARTFABRIC'),
  ('PRF_POSTER_LINEN'),
  ('PRF_POSTER_CANVAS'),
  ('PRF_POSTER_LEATHER_AP'),
  ('PRF_POSTER_TYVEK'),
  ('PRF_POSTER_MESH'),
  ('PRF_POSTER_FOAMBOARD'),
  ('PRF_POSTER_FOMEXBOARD'),
  ('PRF_POSTER_FRAMELESS'),
  ('PRF_POSTER_LEATHER_FRAME'),
  ('PRF_POSTER_CANVAS_HANGING'),
  ('PRF_POSTER_LINEN_WOODBONG'),
  ('PRF_POSTER_JOKJA'),
  ('PRF_POSTER_PET_BANNER'),
  ('PRF_POSTER_MESH_BANNER'),
  ('PRF_POSTER_BANNER_N'),
  ('PRF_POSTER_BANNER_M'),
  ('PRF_POSTER_SHEETCUT_MATTE'),
  ('PRF_POSTER_SHEETCUT_HOLO'),
  ('PRF_POSTER_ACRYLSTK_GLOSS'),
  ('PRF_POSTER_ACRYLSTK_MIRROR'),
  ('PRF_POSTER_MINI_STANDBOARD'),
  ('PRF_POSTER_MINI_BANNER')
) AS v(frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd='COMP_PP_PERF_1L');
