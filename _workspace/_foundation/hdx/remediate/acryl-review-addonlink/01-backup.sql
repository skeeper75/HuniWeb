-- REVIEW 안전분 addon 링크 · 01 백업(undo=추가 링크 제거 기준)
DROP TABLE IF EXISTS z_bak_acrev_addons;
CREATE TABLE z_bak_acrev_addons AS SELECT * FROM t_prd_product_addons
 WHERE prd_cd IN ('PRD_000158','PRD_000110','PRD_000108');
SELECT 'BAK 대상 3상품 기존 링크(0 기대)' lbl, COUNT(*) n FROM z_bak_acrev_addons;
