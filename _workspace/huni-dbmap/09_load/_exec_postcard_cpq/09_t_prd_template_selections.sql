-- =====================================================================
-- step 09 — t_prd_template_selections (카드봉투화이트 freeze 1행)
-- TMPL-000005/006 selection = 라이브 실재(SIZ_000085 qty50) → 본 적재 미관여.
-- TMPL_000010(신규)만 freeze: SIZ_000104(base PRD_000004 보유 실재·트리거 없음) qty50.
-- tmpl_cd = base+이름 resolve(재실행 시 mint 코드 재해결). 멱등 가드 = (tmpl_cd, sel_seq) 자연키.
-- ref_dim_cd=.01 사이즈. opt_cd NULL(자기 차원 freeze). reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_template_selections (tmpl_cd, sel_seq, ref_dim_cd, ref_key1, sel_val, qty, use_yn)
SELECT (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000004' AND tmpl_nm='카드봉투(화이트) 165x115 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1), 1, 'OPT_REF_DIM.01', 'SIZ_000104', '화이트165x115mm', 50, 'Y'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_template_selections
  WHERE tmpl_cd = (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000004' AND tmpl_nm='카드봉투(화이트) 165x115 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1) AND sel_seq = 1);
