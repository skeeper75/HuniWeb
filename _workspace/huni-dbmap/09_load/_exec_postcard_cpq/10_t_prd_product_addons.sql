-- =====================================================================
-- step 10 — t_prd_product_addons (PRD_000016 → 봉투 3 템플릿 링크)
-- PK=(prd_cd, tmpl_cd). 라이브 실재: PRD_000016 → TMPL-000005(disp_seq1) → 멱등 가드 흡수(재적재 안 함).
-- 본 적재 신규 = TMPL-000006(seq2)·TMPL_000010(seq3). tmpl_cd = base+이름 resolve(재실행 안전).
-- 멱등 가드 = (prd_cd, tmpl_cd) 자연키. reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, note)
SELECT 'PRD_000016', (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000001' AND tmpl_nm='OPP접착봉투 110x160 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1), 1, 'OPP접착봉투 50장 (TMPL-000005 라이브 실재·AS-IS addon_prd_cd=PRD_000001 마이그). 설계 TMPL-ENV-OPP-JEOPCHAK.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_addons
  WHERE prd_cd = 'PRD_000016' AND tmpl_cd = (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000001' AND tmpl_nm='OPP접착봉투 110x160 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1));
INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, note)
SELECT 'PRD_000016', (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000002' AND tmpl_nm='OPP비접착봉투 110x160 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1), 2, 'OPP비접착봉투 50장 (TMPL-000006 라이브 실재·AS-IS addon_prd_cd=PRD_000002 마이그). 설계 TMPL-ENV-OPP-BIJEOPCHAK.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_addons
  WHERE prd_cd = 'PRD_000016' AND tmpl_cd = (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000002' AND tmpl_nm='OPP비접착봉투 110x160 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1));
INSERT INTO t_prd_product_addons (prd_cd, tmpl_cd, disp_seq, note)
SELECT 'PRD_000016', (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000004' AND tmpl_nm='카드봉투(화이트) 165x115 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1), 3, '카드봉투화이트 50장 (TMPL_000010 본 적재 mint·AS-IS addon_prd_cd=PRD_000004 마이그). 설계 TMPL-ENV-CARD-WHITE.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_product_addons
  WHERE prd_cd = 'PRD_000016' AND tmpl_cd = (SELECT tmpl_cd FROM t_prd_templates WHERE base_prd_cd='PRD_000004' AND tmpl_nm='카드봉투(화이트) 165x115 mm 50장' AND del_yn='N' ORDER BY tmpl_cd LIMIT 1));
