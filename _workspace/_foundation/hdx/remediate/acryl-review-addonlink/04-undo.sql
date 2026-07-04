-- REVIEW 안전분 addon 링크 · 04 UNDO(추가 링크 제거·기본 ROLLBACK)
BEGIN;
DELETE FROM t_prd_product_addons
 WHERE prd_cd='PRD_000158' AND tmpl_cd IN ('TMPL-000056','TMPL-000057','TMPL-000058','TMPL-000059','TMPL-000060','TMPL-000061','TMPL-000062','TMPL-000063');
DELETE FROM t_prd_product_addons WHERE prd_cd='PRD_000110' AND tmpl_cd='TMPL-000045';
DELETE FROM t_prd_product_addons WHERE prd_cd='PRD_000108' AND tmpl_cd IN ('TMPL-000040','TMPL-000041');
SELECT 'UNDO 잔존 링크(0 기대)' lbl, COUNT(*) n FROM t_prd_product_addons WHERE prd_cd IN ('PRD_000158','PRD_000110','PRD_000108');
ROLLBACK;  -- 검증 전용. 실 복원은 COMMIT 교체.
