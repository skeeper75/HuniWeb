-- AW_wiring_fix.sql — 라이브 PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T 배선 메타 보정(disp_seq/addtn_yn NULL→값)
-- G-D2 W2 본체 배선 패턴: 본체 comp disp_seq=1·addtn_yn='N'(합산 시작·엔진무관 메타). 라이브 배선행 실재(NULL 메타만 보정).
-- 미러/코롯토/카라비너 공식·배선 신설 = BLOCKED(별 파일 acrylic-blocked.BLOCKED.sql).
-- 멱등: disp_seq IS NULL OR addtn_yn IS NULL 인 행만 → 2-pass 0행.
UPDATE t_prc_formula_components
   SET disp_seq = 1, addtn_yn = 'N'
 WHERE frm_cd = 'PRF_CLR_ACRYL' AND comp_cd = 'COMP_ACRYL_CLEAR3T'
   AND (disp_seq IS NULL OR addtn_yn IS NULL);
