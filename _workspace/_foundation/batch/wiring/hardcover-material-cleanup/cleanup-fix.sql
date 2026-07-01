BEGIN;

-- 1) 오염 자재 제거 (아크릴투명·우드거치대·폼보드 — 072/077/082/088 전부)
DELETE FROM t_prd_product_materials
WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088')
  AND mat_cd IN ('MAT_000002','MAT_000003','MAT_000004');

-- 2) 일반 "면지"(MAT_000001) 제거 — 정상 패턴(074 등)처럼 면지 반제품은 자재 없이 이름으로만 구분
DELETE FROM t_prd_product_materials
WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088')
  AND mat_cd = 'MAT_000001';

-- 3) 078/089 의 잘못된 몽블랑130g(내지용 종이) 제거
DELETE FROM t_prd_product_materials
WHERE prd_cd IN ('PRD_000078','PRD_000089') AND mat_cd = 'MAT_000105';

-- 4) 표지 자재를 부모 → 표지 반제품으로 이관 (072/082 = 전용지, 077/088 = 레더화이트)
DELETE FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000072','PRD_000082') AND mat_cd = 'MAT_000246' AND usage_cd='USAGE.02';
DELETE FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000077','PRD_000088') AND mat_cd = 'MAT_000186' AND usage_cd='USAGE.02';

INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq) VALUES
  ('PRD_000073', 'MAT_000246', 'USAGE.02', 'Y', 1),
  ('PRD_000083', 'MAT_000246', 'USAGE.02', 'Y', 1),
  ('PRD_000078', 'MAT_000379', 'USAGE.02', 'Y', 1),
  ('PRD_000089', 'MAT_000379', 'USAGE.02', 'Y', 1);

-- 검증
\echo '=== VERIFY: 072/077/082/088 부모 잔여 자재(링류만 남아야 함) ==='
SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, pm.usage_cd
FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE pm.prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088')
ORDER BY pm.prd_cd;

\echo '=== VERIFY: 073/078/083/089(표지) 자재 ==='
SELECT pm.prd_cd, p.prd_nm, pm.mat_cd, m.mat_nm, pm.usage_cd
FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd JOIN t_prd_products p ON p.prd_cd=pm.prd_cd
WHERE pm.prd_cd IN ('PRD_000073','PRD_000078','PRD_000083','PRD_000089');

ROLLBACK;
