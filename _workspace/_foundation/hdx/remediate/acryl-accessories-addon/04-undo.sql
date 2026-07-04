-- ============================================================
-- 아크릴 부속 저청구 교정 [addon] · 04 UNDO (COMMIT 후 회귀 필요시만)
--   전제: 01-backup 로 z_bak_acacc_* 3테이블. 기본 ROLLBACK·실 복원은 COMMIT 교체.
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_acacc_templates','z_bak_acacc_materials','z_bak_acacc_addons');
  IF n<>3 THEN RAISE EXCEPTION 'UNDO 중단: 백업 %개(3 기대).', n; END IF;
END $chk$;

UPDATE t_prd_templates t SET del_yn=b.del_yn, use_yn=b.use_yn, del_dt=b.del_dt, upd_dt=now()
  FROM z_bak_acacc_templates b WHERE t.tmpl_cd=b.tmpl_cd;

UPDATE t_prd_product_materials m SET del_yn=b.del_yn, del_dt=b.del_dt, upd_dt=now()
  FROM z_bak_acacc_materials b WHERE m.prd_cd=b.prd_cd AND m.mat_cd=b.mat_cd;

SELECT 'UNDO 템플릿 del=Y 복원(6 기대)' lbl, COUNT(*) n FROM t_prd_templates
 WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025') AND del_yn='Y';
SELECT 'UNDO 자재 del=N 복원(6 기대)' lbl, COUNT(*) n FROM t_prd_product_materials
 WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152')
   AND mat_cd IN ('MAT_000047','MAT_000048','MAT_000053','MAT_000054','MAT_000046','MAT_000049') AND del_yn='N';

ROLLBACK;  -- 검증 전용. 실 복원은 COMMIT 으로 교체.
