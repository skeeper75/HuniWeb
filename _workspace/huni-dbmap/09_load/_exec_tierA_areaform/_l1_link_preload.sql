-- =====================================================================
-- _l1_link_preload.sql — L1 차원 LINK 선적재 (apply.sql L2 트랜잭션 비포함·별도 인간 승인)
-- [FINDING-1 보정] product-materials/processes INSERT = L1 차원행 생성 → L2 옵션레이어 경계 밖.
--   124/133/134/135 복합끈 BLOCKED 와 동일 처리(차원 LINK 선적재=인간 승인). 139만 LINK 묶던 불일치 해소.
-- 끈 MAT_000070·열재단 PROC_000084·부착 PROC_000081 = 라이브 차원 실재(mint 불요·LINK only)·139 미링크.
-- 이 패키지 적재(인간 승인) 후 139 재단만/끈추가 option_items 가 트리거 통과(INSERTABLE 승격).
-- 멱등 가드 = 자연키 NOT EXISTS. reg_dt 생략→DEFAULT now(). 손편집 금지. NEVER COMMIT by default.
-- =====================================================================
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000139', 'PROC_000084', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000084');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000139', 'MAT_000070', 'USAGE.07', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd='PRD_000139' AND mat_cd='MAT_000070' AND usage_cd='USAGE.07');
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000139', 'PROC_000081', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000081');
