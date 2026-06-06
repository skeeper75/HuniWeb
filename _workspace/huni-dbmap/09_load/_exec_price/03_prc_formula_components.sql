-- 03_prc_formula_components.sql
-- 단계03 공식-구성요소 배선 — PK t_prc_formula_components_pkey(frm_cd, comp_cd).
-- 생성: gen_load_sql.py (손편집 금지). 멱등: ON CONFLICT 가드.
-- BEGIN/COMMIT 미포함 — apply.sql 가 트랜잭션 래핑.

-- src: 03_prc_formula_components.csv:row2 PRF_ENV_MAKING/COMP_ENV_MAKING
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_ENV_MAKING', 'COMP_ENV_MAKING', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row3 PRF_STK_FIXED/COMP_STK_PRINT
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_STK_FIXED', 'COMP_STK_PRINT', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row4 PRF_GANGPAN_FIXED/COMP_GANGPAN_PRINT
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_GANGPAN_FIXED', 'COMP_GANGPAN_PRINT', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row5 PRF_NAMECARD_FIXED/COMP_NAMECARD_STD_S1
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_STD_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row6 PRF_NAMECARD_FIXED/COMP_NAMECARD_STD_S2
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_NAMECARD_FIXED', 'COMP_NAMECARD_STD_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row7 PRF_PCB_FIXED/COMP_PCB_S1_20P
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PCB_FIXED', 'COMP_PCB_S1_20P', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row8 PRF_PCB_FIXED/COMP_PCB_S2_20P
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PCB_FIXED', 'COMP_PCB_S2_20P', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row9 PRF_FOLD_SUM/COMP_FOLD_CARD_2H
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_FOLD_SUM', 'COMP_FOLD_CARD_2H', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row10 PRF_BIND_SUM/COMP_BIND_JUNGCHEOL
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_BIND_SUM', 'COMP_BIND_JUNGCHEOL', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row11 PRF_TTEOKME_FIXED/COMP_TTEOKME
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_TTEOKME_FIXED', 'COMP_TTEOKME', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row12 PRF_PHOTOCARD_FIXED/COMP_PHOTOCARD_SET
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_FIXED', 'COMP_PHOTOCARD_SET', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row13 PRF_PHOTOCARD_FIXED/COMP_PHOTOCARD_CLEAR_SET
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PHOTOCARD_FIXED', 'COMP_PHOTOCARD_CLEAR_SET', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
-- src: 03_prc_formula_components.csv:row14 PRF_POSTER_FIXED/COMP_POSTER_ARTPRINT_PHOTO
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_POSTER_FIXED', 'COMP_POSTER_ARTPRINT_PHOTO', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
