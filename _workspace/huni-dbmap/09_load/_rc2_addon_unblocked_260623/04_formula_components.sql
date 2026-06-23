-- 04_formula_components.sql — 공식 바인딩 (멱등 UPSERT·PK=(frm_cd,comp_cd))
-- addtn_yn=Y 가산·disp_seq=2부터. ON CONFLICT DO UPDATE 가드.

-- src: 메쉬 큐방 가산 바인딩
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_M', 'COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: 메쉬 끈 가산 바인딩 (disp_seq 3)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_M', 'COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4', 3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: 캔버스 우드행거 가산 바인딩
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_CANVAS_HANGING', 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: 린넨 우드봉 가산 바인딩
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_LINEN_WOODBONG', 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

