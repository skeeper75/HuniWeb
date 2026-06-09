-- =====================================================================
-- step 03 — t_prd_product_materials (PRD_000138 자재 링크 6행)
-- 트리거 fn_chk_opt_item_ref(.03) 선행조건: 옵션아이템(07) 자재 seq가 (prd_cd,mat_cd,usage_cd) 존재 요구.
-- 멱등 가드 = (prd_cd, mat_cd, usage_cd) NOT EXISTS. mint 자재는 이름→코드 조회(재실행 안전).
-- usage_cd=USAGE.07(공통). dflt_yn='N'. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', 'MAT_000069', 'USAGE.07', 'N', 1
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = 'MAT_000069' AND usage_cd = 'USAGE.07');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', 'MAT_000070', 'USAGE.07', 'N', 2
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = 'MAT_000070' AND usage_cd = 'USAGE.07');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '큐방' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 'N', 3
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '큐방' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1) AND usage_cd = 'USAGE.07');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '각목(900이하)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 'N', 4
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '각목(900이하)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1) AND usage_cd = 'USAGE.07');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '각목(900초과)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 'N', 5
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '각목(900초과)' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1) AND usage_cd = 'USAGE.07');
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq)
SELECT 'PRD_000138', (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '봉제사' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1), 'USAGE.07', 'N', 6
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_materials
  WHERE prd_cd = 'PRD_000138' AND mat_cd = (SELECT mat_cd FROM t_mat_materials WHERE mat_nm = '봉제사' AND mat_typ_cd='MAT_TYPE.07' AND del_yn='N' ORDER BY mat_cd LIMIT 1) AND usage_cd = 'USAGE.07');
