-- ============================================================
-- 아크릴키링(PRD_000146) 고리 저청구 교정 [addon 방식·확정] · 01 물리 백업
--   ★COMMIT(03-fix) 직전 실행. undo(04)가 참조. 재실행 시 DROP 후 재생성(멱등).
-- 근본원인(webadmin 실화면 규명): 고리가 base 자재(mat_cd)로 오모델링 → 선택 시 상품 전체 0원.
-- 교정: 고리를 addon 템플릿으로(볼체인 패턴·라이브 sim 검증 +1100/1200/300 반영).
--   ① 삭제 템플릿 TMPL-000015/016/017 복원 ② PRD_000146 addon 링크 ③ 오모델링 자재 3종 제거.
-- 대상 3테이블: t_prd_templates · t_prd_product_addons · t_prd_product_materials.
-- ============================================================

DROP TABLE IF EXISTS z_bak_ackeyr2_templates;
CREATE TABLE z_bak_ackeyr2_templates AS
SELECT * FROM t_prd_templates WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');

DROP TABLE IF EXISTS z_bak_ackeyr2_addons;
CREATE TABLE z_bak_ackeyr2_addons AS
SELECT * FROM t_prd_product_addons WHERE prd_cd = 'PRD_000146';

DROP TABLE IF EXISTS z_bak_ackeyr2_materials;
CREATE TABLE z_bak_ackeyr2_materials AS
SELECT * FROM t_prd_product_materials WHERE prd_cd = 'PRD_000146';

-- 백업 검증(라이브 실측 기대):
--   templates=3(del_yn=Y·1100/1200/300) · addons=8(볼체인) · materials=6(투명2+고리3+MAT_000386)
SELECT 'BAK templates(3·del=Y 기대)' lbl, tmpl_cd, tmpl_nm, del_yn FROM z_bak_ackeyr2_templates ORDER BY tmpl_cd;
SELECT 'BAK addons(8 기대)' lbl, COUNT(*) n FROM z_bak_ackeyr2_addons;
SELECT 'BAK 고리자재(3·del=N 기대)' lbl, COUNT(*) n FROM z_bak_ackeyr2_materials
  WHERE mat_cd IN ('MAT_000051','MAT_000052','MAT_000456') AND del_yn='N';
