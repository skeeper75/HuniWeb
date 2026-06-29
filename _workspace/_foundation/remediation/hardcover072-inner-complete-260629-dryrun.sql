-- 하드커버책자072 내지(PRD_000284) 종단 완성 = 공식 + 차원충전 통합 (DRY-RUN·ROLLBACK)
-- 이전사이트 오라클 확정(pcode40): 내지종이 9종(앙상블100 포함)·사이즈 A5/B5/A4·인쇄 단/양면·면지 무료.
-- 세트 = 표지+제본(PRF_HC_MUSEON_SET·COMMIT됨) + 내지(이 SQL) + 면지(무료). 골든: 내지 24p=12,400·총 46,500.
-- search-before-mint: 9종 전부 COMP_PAPER 국4절 단가행 보유·정본 siz_cd(중복본 회피)·공식 comp 재사용.
BEGIN;

-- 1) 내지 공식 PRF_DGP_INNER + 배선2 + 284 바인딩
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT 'PRF_DGP_INNER','디지털인쇄 책자 내지(인쇄비+용지비·출력매수)',
  '책자 내지 구성원. 인쇄비(판수밴드×판수)+용지비(절가×출력매수). 위젯 qty=derive_inner_sheets(부수,page,pansu). 072/077/082/088 동형.',
  'Y', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER','COMP_PRINT_DIGITAL_S1',1,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PRINT_DIGITAL_S1');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
SELECT 'PRF_DGP_INNER','COMP_PAPER',2,'Y'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_INNER' AND comp_cd='COMP_PAPER');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)
SELECT 'PRD_000284','PRF_DGP_INNER','2026-06-06','하드커버책자 내지 구성원(디지털 합가형).', now()
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER' AND apply_bgn_ymd='2026-06-06');

-- 2) 내지 사이즈 3종(정본 A5·B5·A4)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', v.s, v.d, v.q, now(), 'N' FROM (VALUES
  ('SIZ_000170','Y',1),('SIZ_000380','N',2),('SIZ_000172','N',3)) v(s,d,q)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND siz_cd=v.s);

-- 3) 출력판형 국4절
INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, output_file_typ, reg_dt, del_yn)
SELECT 'PRD_000284','SIZ_000499','N','OUTPUT_PAPER_TYPE.01','PDF', now(), 'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND siz_cd='SIZ_000499');

-- 4) 내지종이 9종(전부 COMP_PAPER 국4절 단가행 보유·앙상블100=MAT_000095 추가)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt, del_yn)
SELECT 'PRD_000284', v.m, 'USAGE.07', v.d, v.q, now(), 'N' FROM (VALUES
  ('MAT_000072','Y',1),('MAT_000073','N',2),('MAT_000086','N',3),('MAT_000087','N',4),
  ('MAT_000076','N',5),('MAT_000077','N',6),('MAT_000104','N',7),('MAT_000105','N',8),
  ('MAT_000095','N',9)) v(m,d,q)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND mat_cd=v.m);

-- 5) 내지 인쇄 단면/양면 (양면=기본·legacy tmp_p09 정합)
INSERT INTO t_prd_product_print_options (prd_cd, opt_id, print_side, front_colrcnt_cd, back_colrcnt_cd, dflt_yn, disp_seq, reg_dt, del_yn, print_opt_cd)
SELECT 'PRD_000284', v.id, v.side, 'CLR_000005', v.bk, v.d, 1, now(), 'N', v.po FROM (VALUES
  (1,'단면','CLR_000001','N','POPT_000001'),(2,'양면','CLR_000005','Y','POPT_000002')) v(id,side,bk,d,po)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND print_opt_cd=v.po);

-- 검증
SELECT '공식' t,count(*) n FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_INNER'
UNION ALL SELECT '배선',count(*) FROM t_prc_formula_components WHERE frm_cd='PRF_DGP_INNER'
UNION ALL SELECT '284바인딩',count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000284' AND frm_cd='PRF_DGP_INNER'
UNION ALL SELECT '284사이즈',count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000284' AND del_yn='N'
UNION ALL SELECT '284판형',count(*) FROM t_prd_product_plate_sizes WHERE prd_cd='PRD_000284' AND del_yn='N'
UNION ALL SELECT '284내지종이',count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000284' AND del_yn='N'
UNION ALL SELECT '284인쇄옵션',count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000284' AND del_yn='N';

ROLLBACK;
