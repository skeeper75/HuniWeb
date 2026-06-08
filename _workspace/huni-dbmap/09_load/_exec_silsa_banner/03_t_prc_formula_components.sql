-- =====================================================================
-- step 03 — t_prc_formula_components
-- PRF_BANNER_NORMAL ↔ 11 comp(면적1+옵션10) 배선. PK=(frm_cd,comp_cd) → ON CONFLICT DO NOTHING
-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).
-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).
-- =====================================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_POSTER_BANNER_NORMAL', 1, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_HEATCUT', 2, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_EYELET4', 3, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_EYELET6', 4, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_EYELET8', 5, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_DTAPE', 6, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_FIN_SEW', 7, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_ADD_QBANG4', 8, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_ADD_STRING4', 9, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_ADD_LUMBER_LE900', 10, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_BANNER_NORMAL', 'COMP_BANNER_ADD_LUMBER_GT900', 11, 'Y', now())
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
