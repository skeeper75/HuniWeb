-- =====================================================================
-- step 11 — t_prd_product_constraints (3행 · RULE_001~RULE_003)
-- 설계 R-HUGA-MAXN/R-HUGA-PARAM/R-QTY-PANSU → 상품별 카운터 RULE_001~003 재코드(D5·복합 PK 충돌 없음).
-- rule_typ_cd 코드 FK(.01 호환/.03 필수동반·R5). logic jsonb NOT NULL(JSONLogic·python 검증 PASS).
-- 멱등 가드 = (prd_cd, rule_nm, del_yn='N'). reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn)
SELECT 'PRD_000016', 'RULE_001', '후가공 최대 4종', 'RULE_TYPE.01', '{ "<=": [ { "reduce": [ { "var": "hugagong" }, { "+": [ { "var": "accumulator" }, 1 ] }, 0 ] }, 4 ] }'::jsonb, '후가공은 최대 4종까지 선택 가능합니다', 1, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd = 'PRD_000016' AND rule_nm = '후가공 최대 4종' AND del_yn = 'N');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn)
SELECT 'PRD_000016', 'RULE_002', '후가공 파라미터 범위', 'RULE_TYPE.01', '{ "and": [ { ">=": [ { "var": "osi_julsu" }, 0 ] }, { "<=": [ { "var": "osi_julsu" }, 3 ] }, { ">=": [ { "var": "mising_julsu" }, 0 ] }, { "<=": [ { "var": "mising_julsu" }, 3 ] }, { ">=": [ { "var": "vartext_cnt" }, 0 ] }, { "<=": [ { "var": "vartext_cnt" }, 3 ] }, { ">=": [ { "var": "varimg_cnt" }, 0 ] }, { "<=": [ { "var": "varimg_cnt" }, 3 ] } ] }'::jsonb, '오시/미싱 줄수·가변 개수는 0~3 범위입니다', 2, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd = 'PRD_000016' AND rule_nm = '후가공 파라미터 범위' AND del_yn = 'N');
INSERT INTO t_prd_product_constraints (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn)
SELECT 'PRD_000016', 'RULE_003', '수량 판수 배수', 'RULE_TYPE.03', '{ "or": [ { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000001" ] }, { "==": [ { "%": [ { "var": "qty" }, 15 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000002" ] }, { "==": [ { "%": [ { "var": "qty" }, 12 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000003" ] }, { "==": [ { "%": [ { "var": "qty" }, 8 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000004" ] }, { "==": [ { "%": [ { "var": "qty" }, 6 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000005" ] }, { "==": [ { "%": [ { "var": "qty" }, 6 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000006" ] }, { "==": [ { "%": [ { "var": "qty" }, 4 ] }, 0 ] } ] }, { "and": [ { "==": [ { "var": "siz_cd" }, "SIZ_000007" ] }, { "==": [ { "%": [ { "var": "qty" }, 4 ] }, 0 ] } ] } ] }'::jsonb, '제작수량은 선택 사이즈의 판수 배수여야 합니다', 3, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_constraints
  WHERE prd_cd = 'PRD_000016' AND rule_nm = '수량 판수 배수' AND del_yn = 'N');
