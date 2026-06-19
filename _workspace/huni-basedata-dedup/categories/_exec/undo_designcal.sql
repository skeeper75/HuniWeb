-- undo_designcal.sql — reverse operation for apply_designcal.sql COMMIT.
-- Run via psql -1 -f to restore pre-COMMIT state. Backup tables also available for full restore.

-- reverse (가): restore 318/319/320 to del_yn='N', use_yn='Y'
UPDATE t_cat_categories
SET del_yn='N', use_yn='Y', upd_dt=now()
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320')
  AND del_yn='Y';

-- reverse (나): remove the 3 multi-classification junction rows (only the main='N' appends)
DELETE FROM t_prd_product_categories
WHERE cat_cd='CAT_000118'
  AND prd_cd IN ('PRD_000108','PRD_000110','PRD_000111')
  AND main_cat_yn='N';
