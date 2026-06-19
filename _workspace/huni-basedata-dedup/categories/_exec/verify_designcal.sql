-- verify_designcal.sql — post-COMMIT live re-measurement V1~V7.
\echo '=== V1: 318/319/320 del_yn=Y use_yn=N (expect 3 rows all Y/N) ==='
SELECT cat_cd, del_yn, use_yn FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320') ORDER BY cat_cd;

\echo '=== V2: CAT_000118 del_yn=N kept (NOT deleted) ==='
SELECT cat_cd, del_yn, use_yn FROM t_cat_categories WHERE cat_cd='CAT_000118';

\echo '=== V3: junction (108/110/111, CAT_000118) main=N exist (expect 3) ==='
SELECT prd_cd, cat_cd, main_cat_yn FROM t_prd_product_categories
WHERE cat_cd='CAT_000118' AND prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
ORDER BY prd_cd;

\echo '=== V4: existing junction for 108/110/111 unchanged (112/114/115 still present) ==='
SELECT prd_cd, cat_cd, main_cat_yn FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111') ORDER BY prd_cd, cat_cd;

\echo '=== V5: main_cat_yn=Y multiplicity per prd (no new Y from this op) ==='
SELECT prd_cd, count(*) FILTER (WHERE main_cat_yn='Y') AS main_y_count, count(*) AS total
FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
GROUP BY prd_cd ORDER BY prd_cd;

\echo '=== V6: FK orphans / PK dup — junction cat_cd missing from categories (expect 0) ==='
SELECT j.prd_cd, j.cat_cd FROM t_prd_product_categories j
LEFT JOIN t_cat_categories c ON j.cat_cd=c.cat_cd
WHERE j.cat_cd='CAT_000118' AND c.cat_cd IS NULL;
\echo '--- PK dup check (expect 0) ---'
SELECT prd_cd, cat_cd, count(*) FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
GROUP BY prd_cd, cat_cd HAVING count(*) > 1;

-- V7 (idempotency) is proven by re-running apply via dryrun pass2 separately.
