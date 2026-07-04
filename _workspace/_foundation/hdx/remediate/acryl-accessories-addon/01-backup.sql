-- ============================================================
-- 아크릴 부속 저청구 교정 [addon·키링 동형] · 01 백업
--   대상 3상품: 아크릴뱃지(148)·아크릴스마트톡(150)·아크릴명찰(152).
--   근본원인(키링 동일·webadmin 규명): 부속(핀/자석/바디)이 base 자재로 오모델 → 선택 시 상품 0원.
--   교정: 삭제 addon 템플릿 복원 + 오모델 자재 제거(addon 링크는 이미 존재).
-- 복원 템플릿 6: TMPL-000019 원형핀600·020 1구자석1000·022 화이트바디2600·023 투명바디3000·
--                024 일자핀700·025 2구자석1700 (전부 template_prices 권위값 보유·신규 mint 0).
-- 제거 자재 6: 148[MAT_000047 원형핀·048 1구자석] 150[053 투명바디·054 화이트바디] 152[046 일자핀·049 2구자석]
-- ============================================================
DROP TABLE IF EXISTS z_bak_acacc_templates;
CREATE TABLE z_bak_acacc_templates AS SELECT * FROM t_prd_templates
 WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025');

DROP TABLE IF EXISTS z_bak_acacc_materials;
CREATE TABLE z_bak_acacc_materials AS SELECT * FROM t_prd_product_materials
 WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152');

DROP TABLE IF EXISTS z_bak_acacc_addons;
CREATE TABLE z_bak_acacc_addons AS SELECT * FROM t_prd_product_addons
 WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152');

SELECT 'BAK templates(6·del=Y 기대)' lbl, tmpl_cd, tmpl_nm, del_yn FROM z_bak_acacc_templates ORDER BY tmpl_cd;
SELECT 'BAK 제거대상 자재(6·del=N 기대)' lbl, COUNT(*) n FROM z_bak_acacc_materials
 WHERE mat_cd IN ('MAT_000047','MAT_000048','MAT_000053','MAT_000054','MAT_000046','MAT_000049') AND del_yn='N';
SELECT 'BAK addon 링크(6·삭제템플릿 지목 기대)' lbl, COUNT(*) n FROM z_bak_acacc_addons
 WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025');
