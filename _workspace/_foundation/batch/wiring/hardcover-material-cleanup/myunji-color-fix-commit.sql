BEGIN;

-- 1) 부모(072/077/082/088)에 올바른 면지 색상 자재 등록(옵션참조 무결성 트리거 요구사항)
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq) VALUES
  ('PRD_000072','MAT_000382','USAGE.03','Y',1),
  ('PRD_000072','MAT_000383','USAGE.03','N',2),
  ('PRD_000072','MAT_000384','USAGE.03','N',3),
  ('PRD_000077','MAT_000382','USAGE.03','Y',1),
  ('PRD_000077','MAT_000383','USAGE.03','N',2),
  ('PRD_000077','MAT_000384','USAGE.03','N',3),
  ('PRD_000082','MAT_000382','USAGE.03','Y',1),
  ('PRD_000082','MAT_000383','USAGE.03','N',2),
  ('PRD_000082','MAT_000384','USAGE.03','N',3),
  ('PRD_000082','MAT_000385','USAGE.03','N',4),
  ('PRD_000088','MAT_000382','USAGE.03','Y',1),
  ('PRD_000088','MAT_000383','USAGE.03','N',2),
  ('PRD_000088','MAT_000384','USAGE.03','N',3),
  ('PRD_000088','MAT_000385','USAGE.03','N',4);

-- 2) 옵션 항목의 잘못된 참조(아크릴투명/우드거치대/폼보드/일반면지) → 올바른 색상별 자재로 교정
UPDATE t_prd_product_option_items SET ref_key1='MAT_000382' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000434';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000383' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000435';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000384' WHERE prd_cd='PRD_000072' AND opt_cd='OPV_000436';

UPDATE t_prd_product_option_items SET ref_key1='MAT_000382' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000437';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000383' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000438';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000384' WHERE prd_cd='PRD_000077' AND opt_cd='OPV_000439';

UPDATE t_prd_product_option_items SET ref_key1='MAT_000382' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000440';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000383' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000441';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000384' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000442';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000385' WHERE prd_cd='PRD_000082' AND opt_cd='OPV_000443';

UPDATE t_prd_product_option_items SET ref_key1='MAT_000382' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000444';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000383' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000445';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000384' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000446';
UPDATE t_prd_product_option_items SET ref_key1='MAT_000385' WHERE prd_cd='PRD_000088' AND opt_cd='OPV_000447';

-- 검증
\echo '=== VERIFY: 옵션항목 참조 자재 ==='
SELECT oi.prd_cd, po.opt_nm, oi.ref_key1, m.mat_nm
FROM t_prd_product_option_items oi
JOIN t_prd_product_options po ON po.prd_cd=oi.prd_cd AND po.opt_cd=oi.opt_cd
JOIN t_mat_materials m ON m.mat_cd=oi.ref_key1
WHERE oi.prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088')
ORDER BY oi.prd_cd, oi.opt_cd;

\echo '=== VERIFY: 부모 자재(잔여 오염 없어야) ==='
SELECT pm.prd_cd, m.mat_nm, pm.usage_cd FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE pm.prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088') ORDER BY pm.prd_cd;

COMMIT;
