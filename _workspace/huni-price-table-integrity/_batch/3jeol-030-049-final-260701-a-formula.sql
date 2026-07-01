-- 030(지그재그엽서)/049(와이드접지리플렛) 가격공식 배선 -- 2026-07-01
-- 030: 라이브 등록공정(PROC_000073 6단오시접지/PROC_000074 6단미싱접지)과 정합하려면
--       PRF_DGP_C(2단접지 COMP_FOLD_CARD_2H)를 그대로 못 씀 -- 신규 PRF_DGP_C_6CR
--       (PRF_DGP_C 구조 그대로 복제, 접지 컴포넌트만 기존 고아 COMP_FOLD_CARD_6CR로 교체)
-- 049: 라이브 등록공정(3단접지·병풍접지·라미네이팅)과 기존 PRF_DGP_E 구성이 정합 -- 그대로 재사용
-- search-before-mint: 신규 컴포넌트 mint 없음(기존 고아 COMP_FOLD_CARD_6CR 배선만)
BEGIN;
INSERT INTO t_prc_price_formulas (frm_cd,frm_nm,note,use_yn,reg_dt)
SELECT 'PRF_DGP_C_6CR','디지털인쇄 원자합산형C-6단접지 지그재그엽서',
       'PRF_DGP_C 복제+6단접지(COMP_FOLD_CARD_6CR) 교체. 인쇄비+용지비+6단접지비+타공비(미등록시0). 260701 지그재그엽서(030) 전용 신설.','Y',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_C_6CR');

INSERT INTO t_prc_formula_components (frm_cd,comp_cd,addtn_yn,disp_seq)
SELECT v.frm_cd, v.comp_cd, v.addtn_yn, v.disp_seq FROM (VALUES
  ('PRF_DGP_C_6CR','COMP_PRINT_DIGITAL_S1','Y',0),
  ('PRF_DGP_C_6CR','COMP_PAPER','Y',1),
  ('PRF_DGP_C_6CR','COMP_FOLD_CARD_6CR','Y',2),
  ('PRF_DGP_C_6CR','COMP_CUT_PERF_1H6','Y',3)
) AS v(frm_cd,comp_cd,addtn_yn,disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd=v.comp_cd);

INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000030','PRF_DGP_C_6CR',to_char(now(),'YYYYMMDD'),'3절 판형이관+6단접지 공식 신설 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000030');
INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,note,reg_dt)
SELECT 'PRD_000049','PRF_DGP_E',to_char(now(),'YYYYMMDD'),'3절 판형이관+기존 PRF_DGP_E 재사용 260701',now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000049');
COMMIT;
