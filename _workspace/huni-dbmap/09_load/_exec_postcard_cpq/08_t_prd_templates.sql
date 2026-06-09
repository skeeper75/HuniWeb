-- =====================================================================
-- step 08 — t_prd_templates (카드봉투화이트 TMPL_000010 신규 mint 1행)
-- [search-before-mint] OPP접착 TMPL-000005·OPP비접착 TMPL-000006 = 라이브 실재(del_yn=N) → mint 안 함(중복 방지).
--   각각 template_selections(SIZ_000085 qty50)도 실재 → 본 적재 미관여(09 step 미적재).
-- 카드봉투(화이트)만 활성 템플릿 부재(TMPL-000007=del_yn=Y) → TMPL_000010 신규 mint(base PRD_000004, `_` 통일·D3).
-- 멱등 가드 = (base_prd_cd, tmpl_nm, del_yn='N') NOT EXISTS. price 없음(R4). reg_dt 생략→DEFAULT now(). 손편집 금지.
-- =====================================================================
INSERT INTO t_prd_templates (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, note)
SELECT 'TMPL_000010', 'PRD_000004', '카드봉투(화이트) 165x115 mm 50장', 50, 'Y', '엽서 봉투 add-on SKU. 카드봉투(화이트) base PRD_000004. 활성 템플릿 부재(TMPL-000007=del_yn=Y·base PRD_000281)라 신규 mint. price 컬럼 라이브 부재(R4·가격엔진 t_prc_* 연계). 설계 TMPL-ENV-CARD-WHITE 재코드.'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prd_templates
  WHERE base_prd_cd = 'PRD_000004' AND tmpl_nm = '카드봉투(화이트) 165x115 mm 50장' AND del_yn = 'N');
