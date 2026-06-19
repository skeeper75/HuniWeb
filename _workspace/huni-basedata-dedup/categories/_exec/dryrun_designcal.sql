-- dryrun_designcal.sql — ROLLBACK-ONLY dry-run. Proves expected deltas + idempotency + constraints.
-- NEVER commits. Run twice (2-pass): 2nd pass must show delta 0 for both (가) and (나).
-- Authority: empty-node-analysis.md v2 §6.

BEGIN;

-- ============ (가) node logical-delete: CAT_000318/319/320 ============
\echo '--- (가) BEFORE ---'
SELECT cat_cd, del_yn, use_yn FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320','CAT_000118') ORDER BY cat_cd;

WITH upd_ga AS (
  UPDATE t_cat_categories
  SET del_yn='Y', use_yn='N', upd_dt=now()
  WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320')
    AND del_yn='N'                  -- idempotent guard
  RETURNING cat_cd
)
SELECT '(가) UPDATE rows' AS op, count(*) AS affected FROM upd_ga;  -- expect 3 (pass1), 0 (pass2)

-- ============ (나) junction multi-classification append: PRD 108/110/111 -> CAT_000118 (main='N') ============
WITH ins_na AS (
  INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, reg_dt)
  VALUES
    ('PRD_000108','CAT_000118','N', now()),
    ('PRD_000110','CAT_000118','N', now()),
    ('PRD_000111','CAT_000118','N', now())
  ON CONFLICT (prd_cd, cat_cd) DO NOTHING  -- idempotent
  RETURNING prd_cd
)
SELECT '(나) INSERT rows' AS op, count(*) AS affected FROM ins_na;  -- expect 3 (pass1), 0 (pass2)

\echo '--- (가) AFTER ---'
SELECT cat_cd, del_yn, use_yn FROM t_cat_categories
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320','CAT_000118') ORDER BY cat_cd;

\echo '--- (나) AFTER (junction for 108/110/111) ---'
SELECT prd_cd, cat_cd, main_cat_yn FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111') ORDER BY prd_cd, cat_cd;

-- ============ constraint / integrity checks ============
\echo '--- CHECK: CAT_000118 must stay del_yn=N (not deleted) ---'
SELECT cat_cd, del_yn FROM t_cat_categories WHERE cat_cd='CAT_000118';

\echo '--- CHECK: main_cat_yn=Y multiplicity per prd (new rows are N, so no new Y) ---'
SELECT prd_cd, count(*) FILTER (WHERE main_cat_yn='Y') AS main_y_count
FROM t_prd_product_categories
WHERE prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
GROUP BY prd_cd ORDER BY prd_cd;

\echo '--- CHECK: FK orphans (junction cat_cd not in categories) for new rows ---'
SELECT j.prd_cd, j.cat_cd FROM t_prd_product_categories j
LEFT JOIN t_cat_categories c ON j.cat_cd=c.cat_cd
WHERE j.cat_cd='CAT_000118' AND c.cat_cd IS NULL;  -- expect 0 rows

ROLLBACK;
