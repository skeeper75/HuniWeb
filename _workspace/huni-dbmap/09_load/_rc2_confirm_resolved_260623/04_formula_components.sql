-- 04_formula_components.sql — 공식 바인딩 (멱등 INSERT·NOT EXISTS 가드·addtn_yn=Y)
-- 대상: t_prc_formula_components  PK=(frm_cd, comp_cd).  reg_dt=DEFAULT now().
-- 린넨 LINEN_FINISH→PRF_POSTER_LINEN(disp_seq=2) / 메쉬 타공 3 comp→PRF_POSTER_BANNER_M(disp_seq 4/5/6)
-- / 족자 천정고리→PRF_POSTER_JOKJA(disp_seq=2).  [일반 PUNCH_4 이미 disp_seq=2 바인딩·추가 0]

-- 린넨마감 (CONFIRM-B): COMP_POSTEROPT_LINEN_FINISH → PRF_POSTER_LINEN (기존 MAX=1 → disp_seq=2)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_LINEN', 'COMP_POSTEROPT_LINEN_FINISH', 2, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd = 'PRF_POSTER_LINEN' AND comp_cd = 'COMP_POSTEROPT_LINEN_FINISH'
);

-- 메쉬 타공 (CONFIRM-A): 3 comp → PRF_POSTER_BANNER_M (기존 MAX=3 → disp_seq 4/5/6)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_M', 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4', 4, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd = 'PRF_POSTER_BANNER_M' AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4'
);
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_M', 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6', 5, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd = 'PRF_POSTER_BANNER_M' AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6'
);
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_BANNER_M', 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8', 6, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd = 'PRF_POSTER_BANNER_M' AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8'
);

-- 족자 천정고리 (CONFIRM-C): COMP_POSTEROPT_JOKJA_CEILHOOK → PRF_POSTER_JOKJA (기존 MAX=1 → disp_seq=2)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_POSTER_JOKJA', 'COMP_POSTEROPT_JOKJA_CEILHOOK', 2, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components
   WHERE frm_cd = 'PRF_POSTER_JOKJA' AND comp_cd = 'COMP_POSTEROPT_JOKJA_CEILHOOK'
);
