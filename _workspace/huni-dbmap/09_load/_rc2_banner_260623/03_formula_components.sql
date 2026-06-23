-- 03_formula_components.sql — RC-2 공식 바인딩 (멱등 UPSERT·PK=(frm_cd,comp_cd))
-- 대상공식 PRF_POSTER_BANNER_N. addtn_yn=Y 가산. 기존 PUNCH_4행은 addtn_yn/disp_seq 충전.

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE', 3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE', 4, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW', 5, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4', 6, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

-- src: mapping.csv bind · COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_POSTER_BANNER_N', 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4', 7, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO UPDATE
   SET addtn_yn = EXCLUDED.addtn_yn, disp_seq = EXCLUDED.disp_seq, upd_dt = now()
 WHERE t_prc_formula_components.addtn_yn IS DISTINCT FROM EXCLUDED.addtn_yn
    OR t_prc_formula_components.disp_seq IS DISTINCT FROM EXCLUDED.disp_seq;

