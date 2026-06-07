-- 03_t_prc_formula_components.sql  — 공식↔구성요소 배선 72행
-- 멱등: PK (frm_cd, comp_cd) → ON CONFLICT (frm_cd, comp_cd) DO NOTHING
-- FK: frm_cd→01(PRF_DGP_*), comp_cd→재사용 35 + COMP_PAPER(02). reg_dt omit.

INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_DIGITAL_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_DIGITAL_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_WHITE_S1', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_WHITE_S2', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_CLEAR_S1', 5, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_CLEAR_S2', 6, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_PINK_S1', 7, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_PINK_S2', 8, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_GOLD_S1', 9, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_GOLD_S2', 10, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_SILVER_S1', 11, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PRINT_SPOT_SILVER_S2', 12, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_COAT_GLOSSY', 13, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_COAT_MATTE', 14, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PAPER', 15, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_CREASE_1L', 16, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_CREASE_2L', 17, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_CREASE_3L', 18, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_PERF_1L', 19, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_PERF_2L', 20, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_PERF_3L', 21, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARTEXT_1EA', 22, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARTEXT_2EA', 23, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARTEXT_3EA', 24, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARIMG_1EA', 25, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARIMG_2EA', 26, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_VARIMG_3EA', 27, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_CORNER_RIGHT', 28, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_A', 'COMP_PP_CORNER_ROUND', 29, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_B', 'COMP_PRINT_DIGITAL_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_B', 'COMP_PRINT_DIGITAL_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_B', 'COMP_PAPER', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_B', 'COMP_CUT_FULL_DIECUT', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_C', 'COMP_PRINT_DIGITAL_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_C', 'COMP_PRINT_DIGITAL_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_C', 'COMP_PAPER', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_C', 'COMP_FOLD_CARD_2H', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_C', 'COMP_CUT_PERF_1H6', 5, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PRINT_DIGITAL_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PRINT_DIGITAL_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_COAT_GLOSSY', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_COAT_MATTE', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PAPER', 5, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_CUT_PERF_1H6', 6, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_CREASE_1L', 7, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_CREASE_2L', 8, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_CREASE_3L', 9, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_PERF_1L', 10, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_PERF_2L', 11, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_PERF_3L', 12, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARTEXT_1EA', 13, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARTEXT_2EA', 14, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARTEXT_3EA', 15, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARIMG_1EA', 16, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARIMG_2EA', 17, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_VARIMG_3EA', 18, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_CORNER_RIGHT', 19, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_D', 'COMP_PP_CORNER_ROUND', 20, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_PRINT_DIGITAL_S1', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_PRINT_DIGITAL_S2', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_COAT_GLOSSY', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_COAT_MATTE', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_PAPER', 5, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_FOLD_LEAF_HALF', 6, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_FOLD_LEAF_3FOLD', 7, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_FOLD_LEAF_4ACC', 8, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_FOLD_LEAF_4GATE', 9, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_E', 'COMP_CUT_PERF_1H6', 10, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_F', 'COMP_PAPER', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_F', 'COMP_PRINT_DIGITAL_S1', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_F', 'COMP_PRINT_DIGITAL_S2', 3, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_DGP_F', 'COMP_CUT_FULL_DIECUT', 4, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
