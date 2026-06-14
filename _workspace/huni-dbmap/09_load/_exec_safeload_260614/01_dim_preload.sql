-- =====================================================================
-- 01_dim_preload.sql — BLOCKED 차원 선적재 (L1 차원행 product-link)
--   Tier A 인간 승인 큐 D(면적형 139 끈/재단) + E 일부(디지털 접지 027/029)
--   [HARD] 모두 라이브 마스터 실재 차원행 LINK 만 — mint(신규 차원) 없음.
--   화이트별색(024/025)은 공정코드 미상(C-1)이라 본 패키지 제외(발명 금지).
--   멱등 가드 = 자연키 NOT EXISTS. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================

-- ── 139 메쉬현수막: 끈 BUNDLE·재단 차원 LINK (areaform _l1_link_preload.sql 동일) ──
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000139', 'PROC_000084', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000084');

INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000139', 'PROC_000081', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000139' AND proc_cd='PROC_000081');

INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000139', 'MAT_000070', 'USAGE.07', 'N', 10
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd='PRD_000139' AND mat_cd='MAT_000070' AND usage_cd='USAGE.07');

-- ── 접지 027(2단)·029(3단): 접지 공정 LINK (마스터 PROC_000065~068 실재) ──
-- 027 2단접지카드: 2단가로접지(065)·2단세로접지(066)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000027', 'PROC_000065', 'N', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000027' AND proc_cd='PROC_000065');

INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000027', 'PROC_000066', 'N', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000027' AND proc_cd='PROC_000066');

-- 029 3단접지카드: 3단가로접지(067)·3단세로접지(068)
INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000029', 'PROC_000067', 'N', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000029' AND proc_cd='PROC_000067');

INSERT INTO t_prd_product_processes (prd_cd, proc_cd, mand_proc_yn, disp_seq)
SELECT 'PRD_000029', 'PROC_000068', 'N', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes
  WHERE prd_cd='PRD_000029' AND proc_cd='PROC_000068');
