-- COMP_FOLD_CARD_6CR use_dims proc_grp 보강 — UNDO (백업에서 원복)
-- 02-fix.sql COMMIT 후 되돌릴 때. z_bak_fold6cr_usedims 원본 use_dims(=["min_qty"]) 복원.
BEGIN;

UPDATE t_prc_price_components t
   SET use_dims = b.use_dims, upd_dt = now()
  FROM z_bak_fold6cr_usedims b
 WHERE t.comp_cd = b.comp_cd;

DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n
    FROM t_prc_price_components
   WHERE comp_cd = 'COMP_FOLD_CARD_6CR'
     AND use_dims @> '["proc_grp:PROC_000073"]'::jsonb;
  IF n <> 0 THEN
    RAISE EXCEPTION 'undo gate fail: proc_grp still present (n=%)', n;
  END IF;
END $$;

COMMIT;
