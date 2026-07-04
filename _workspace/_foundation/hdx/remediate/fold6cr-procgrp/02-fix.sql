-- COMP_FOLD_CARD_6CR use_dims proc_grp 보강 — FIX (COMMIT)
-- ★[HARD] 인간 승인 + webadmin 실화면(지그재그엽서 PRD_000030 견적 불변) 확인 후에만 실행.
-- 상세 근거·가격중립·overlay 확증 = 01-dryrun.sql 헤더 참조.
-- 백업 테이블 z_bak_fold6cr_usedims 는 COMMIT 후 라이브 보유(undo 용). 03-undo.sql 로 복원.
BEGIN;

DROP TABLE IF EXISTS z_bak_fold6cr_usedims;
CREATE TABLE z_bak_fold6cr_usedims AS
  SELECT comp_cd, use_dims
    FROM t_prc_price_components
   WHERE comp_cd = 'COMP_FOLD_CARD_6CR';

UPDATE t_prc_price_components
   SET use_dims = '["min_qty", "proc_grp:PROC_000073", "proc_grp:PROC_000074"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'COMP_FOLD_CARD_6CR';

DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n
    FROM t_prc_price_components
   WHERE comp_cd = 'COMP_FOLD_CARD_6CR'
     AND use_dims @> '["proc_grp:PROC_000073", "proc_grp:PROC_000074"]'::jsonb
     AND use_dims @> '["min_qty"]'::jsonb;
  IF n <> 1 THEN
    RAISE EXCEPTION 'gate fail: expected 1 row with proc_grp+min_qty, got %', n;
  END IF;
END $$;

COMMIT;
