-- B4_korotto_formula.sql — 코롯토 공식 신설 + 본체 배선 (PRF_COROTTO_ACRYL)
-- 공식 = 면적매트릭스 본체(단일 comp). 배선 disp_seq=1·addtn_yn=N(본체·합산 시작·G-D2 W2 패턴).
-- 멱등: frm_cd PK NOT EXISTS / (frm_cd,comp_cd) NOT EXISTS 가드.
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn, reg_dt)
SELECT 'PRF_COROTTO_ACRYL', '아크릴코롯토 공식', 'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_COROTTO_ACRYL');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_COROTTO_ACRYL', 'COMP_ACRYL_COROTTO', 1, 'N', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_COROTTO_ACRYL' AND comp_cd='COMP_ACRYL_COROTTO');
