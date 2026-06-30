-- §29 034 펄명함 정상화 (2026-06-30)
-- 권위=가격표 260527 B04(스타드림: 다이아/실버/골드 단9000·양10000 / 로즈쿼츠 단10000·양11000)
-- 현 PEARL 단가행=굿즈 mat 오염·034 자재=굿즈 오염 → 스타드림 4색으로 재구축
BEGIN;
-- 1. PEARL 단가행 재구축 (굿즈 오염 12행 → 스타드림 4색 8행)
DELETE FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%';
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price)
SELECT (SELECT COALESCE(MAX(comp_price_id),0) FROM t_prc_component_prices)+ROW_NUMBER() OVER (),
       v.comp_cd,'2026-06-01',v.mat_cd,v.po,100,v.price
FROM (VALUES
  -- S1 단면: A 9000 / B 로즈쿼츠 10000
  ('COMP_NAMECARD_PEARL_S1','MAT_000352','POPT_000001',9000),('COMP_NAMECARD_PEARL_S1','MAT_000358','POPT_000001',9000),
  ('COMP_NAMECARD_PEARL_S1','MAT_000359','POPT_000001',9000),('COMP_NAMECARD_PEARL_S1','MAT_000360','POPT_000001',10000),
  -- S2 양면: A 10000 / B 로즈쿼츠 11000
  ('COMP_NAMECARD_PEARL_S2','MAT_000352','POPT_000002',10000),('COMP_NAMECARD_PEARL_S2','MAT_000358','POPT_000002',10000),
  ('COMP_NAMECARD_PEARL_S2','MAT_000359','POPT_000002',10000),('COMP_NAMECARD_PEARL_S2','MAT_000360','POPT_000002',11000)
) v(comp_cd,mat_cd,po,price);

-- 2. 034 자재 교정 (굿즈 4종 논리삭제 → 스타드림 4색 추가)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
  WHERE prd_cd='PRD_000034' AND mat_cd IN ('MAT_000128','MAT_000129','MAT_000240','MAT_000241') AND COALESCE(del_yn,'N')<>'Y';
INSERT INTO t_prd_product_materials (prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq)
SELECT 'PRD_000034',v.mat_cd,'USAGE.07',v.dflt,v.seq
FROM (VALUES ('MAT_000352','Y',1),('MAT_000358','Y',2),('MAT_000359','Y',3),('MAT_000360','Y',4)) v(mat_cd,dflt,seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials pm WHERE pm.prd_cd='PRD_000034' AND pm.mat_cd=v.mat_cd AND COALESCE(pm.del_yn,'N')<>'Y');

\echo '--- 사후: PEARL 단가행(8 기대·스타드림만) ---'
SELECT cp.comp_cd,m.mat_nm,cp.print_opt_cd,cp.unit_price FROM t_prc_component_prices cp JOIN t_mat_materials m ON m.mat_cd=cp.mat_cd WHERE cp.comp_cd LIKE 'COMP_NAMECARD_PEARL%' ORDER BY cp.comp_cd,cp.unit_price;
\echo '--- 사후: 034 활성자재(4 스타드림 기대) ---'
SELECT m.mat_nm,pm.dflt_yn,pm.disp_seq FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd WHERE pm.prd_cd='PRD_000034' AND COALESCE(pm.del_yn,'N')<>'Y' ORDER BY pm.disp_seq;
ROLLBACK;
\echo '=== ROLLBACK (DRY-RUN) ==='
