-- backup_designcal.sql — physical read-only snapshot before design-calendar correction
-- Fixed suffix (no Date.now()). Run BEFORE any apply. Idempotent: DROP IF EXISTS then CREATE.
-- Authority: empty-node-analysis.md v2 (MAP authority isomorphic correction)

-- (가) node backup: CAT_000318/319/320 (correction targets) + CAT_000118 (kept, for completeness)
DROP TABLE IF EXISTS bak_cat_designcal_nodes;
CREATE TABLE bak_cat_designcal_nodes AS
SELECT * FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320','CAT_000118');

-- (나) junction backup: all rows for PRD_000108/110/111 + all rows in target cat CAT_000118 region
DROP TABLE IF EXISTS bak_prdcat_designcal_links;
CREATE TABLE bak_prdcat_designcal_links AS
SELECT * FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
   OR cat_cd IN ('CAT_000318','CAT_000319','CAT_000320','CAT_000118');

-- report backup row counts
SELECT 'bak_cat_designcal_nodes' AS backup, count(*) AS rows FROM bak_cat_designcal_nodes
UNION ALL
SELECT 'bak_prdcat_designcal_links', count(*) FROM bak_prdcat_designcal_links;
