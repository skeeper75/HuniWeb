-- =====================================================================
-- step 05 — t_prd_product_constraints (R-SIZE-NONSPEC · RULE_001 — 7상품)
-- 비규격 입력 7상품(118/120/121/122/124/125/139). 규격이면 통과·사용자입력이면 4변 범위.
-- rule_cd=RULE_001(상품별 카운터·D5). rule_typ_cd=RULE_TYPE.01(compatible). logic jsonb NOT NULL.
-- 멱등 가드 = (prd_cd, rule_cd) NOT EXISTS. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000118', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000118' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000120', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000120' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000121', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000121' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000122', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000122' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000124', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000124' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000125', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 200]}, {"<=": [{"var": "width"}, 1200]}, {">=": [{"var": "height"}, 200]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000125' AND rule_cd='RULE_001');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, use_yn, disp_seq)
SELECT 'PRD_000139', 'RULE_001', '사용자입력 치수 범위', 'RULE_TYPE.01', '{"or": [{"!=": [{"var": "size_mode"}, "nonspec"]}, {"and": [{">=": [{"var": "width"}, 500]}, {"<=": [{"var": "width"}, 900]}, {">=": [{"var": "height"}, 500]}, {"<=": [{"var": "height"}, 3000]}]}]}'::jsonb, '가로 500~900mm, 세로 500~3000mm 범위로 입력하세요', 'Y', 1
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd='PRD_000139' AND rule_cd='RULE_001');
-- NOTE: constraint_json compile 캐시(t_prd_products.constraint_json) 갱신은 인간 승인 COMMIT 후 별도 (활성 rule AND).
