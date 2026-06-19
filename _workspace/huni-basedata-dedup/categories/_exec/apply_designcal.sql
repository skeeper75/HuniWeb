-- apply_designcal.sql — REAL COMMIT. NO embedded BEGIN/COMMIT (run via psql -1 -f for single tx).
-- Authority: empty-node-analysis.md v2 §6. Run ONLY after dryrun GO + backup taken.
-- (가) node logical-delete 318/319/320 ; (나) junction append 108/110/111 -> CAT_000118 main='N'.

-- (가) node logical-delete (idempotent guard del_yn='N')
UPDATE t_cat_categories
SET del_yn='Y', use_yn='N', upd_dt=now()
WHERE cat_cd IN ('CAT_000318','CAT_000319','CAT_000320')
  AND del_yn='N';

-- (나) junction multi-classification append (main='N' secondary), idempotent
INSERT INTO t_prd_product_categories (prd_cd, cat_cd, main_cat_yn, reg_dt)
VALUES
  ('PRD_000108','CAT_000118','N', now()),
  ('PRD_000110','CAT_000118','N', now()),
  ('PRD_000111','CAT_000118','N', now())
ON CONFLICT (prd_cd, cat_cd) DO NOTHING;
