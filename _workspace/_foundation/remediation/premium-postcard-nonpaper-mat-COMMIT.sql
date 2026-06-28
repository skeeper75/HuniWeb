-- 프리미엄엽서(PRD_000016) 부자재 오염 제거 — D3 위반 교정 COMMIT (인간 승인 2026-06-28)
-- 면끈(MAT_000128·.17)·아크릴키링고리(MAT_000129·.03)·네오디움자석(MAT_000130·.03)=비종이.
-- 권위(상품마스터 디지털인쇄 시트)=종이만. del_yn=Y(소프트·마스터코드 보존[[base-master-code-no-delete]]·undo 가능).
\set ON_ERROR_STOP on
BEGIN;
\echo '--BEFORE: 프리미엄엽서 비종이 자재--'
SELECT pm.mat_cd, m.mat_nm, m.mat_typ_cd FROM t_prd_product_materials pm LEFT JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd WHERE pm.prd_cd='PRD_000016' AND m.mat_typ_cd<>'MAT_TYPE.01' AND coalesce(pm.del_yn,'N')='N';
UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000016' AND mat_cd IN (SELECT mat_cd FROM t_mat_materials WHERE mat_typ_cd<>'MAT_TYPE.01') AND coalesce(del_yn,'N')='N';
\echo '--AFTER: 활성 자재(종이 18만 남아야)--'
SELECT count(*) AS active_paper FROM t_prd_product_materials WHERE prd_cd='PRD_000016' AND coalesce(del_yn,'N')='N';
\echo '--COMMIT--'
COMMIT;
