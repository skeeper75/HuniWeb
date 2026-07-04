-- ============================================================
-- 아크릴키링 고리 저청구 교정 [addon] · 04 UNDO (COMMIT 후 회귀 필요시만)
--   전제: 01-backup 로 z_bak_ackeyr2_* 3테이블 보유. 기본 ROLLBACK(검증)·실 복원은 COMMIT 교체.
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_ackeyr2_templates','z_bak_ackeyr2_addons','z_bak_ackeyr2_materials');
  IF n<>3 THEN RAISE EXCEPTION 'UNDO 중단: 백업 %개(3 기대).', n; END IF;
END $chk$;

-- ① 템플릿 원복(del_yn/use_yn/del_dt 복원)
UPDATE t_prd_templates t SET del_yn=b.del_yn, use_yn=b.use_yn, del_dt=b.del_dt, upd_dt=now()
  FROM z_bak_ackeyr2_templates b WHERE t.tmpl_cd=b.tmpl_cd;

-- ② addon 링크 원복(추가한 3행 제거·백업엔 없던 것)
DELETE FROM t_prd_product_addons
 WHERE prd_cd='PRD_000146' AND tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');

-- ③ 고리 자재 원복(del_yn 복원)
UPDATE t_prd_product_materials m SET del_yn=b.del_yn, del_dt=b.del_dt, upd_dt=now()
  FROM z_bak_ackeyr2_materials b WHERE m.prd_cd=b.prd_cd AND m.mat_cd=b.mat_cd;

SELECT 'UNDO 템플릿 del=Y 복원(3 기대)' lbl, COUNT(*) n FROM t_prd_templates
 WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017') AND del_yn='Y';
SELECT 'UNDO addon 링크 제거(0 기대)' lbl, COUNT(*) n FROM t_prd_product_addons
 WHERE prd_cd='PRD_000146' AND tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');
SELECT 'UNDO 고리자재 복원 del=N(3 기대)' lbl, COUNT(*) n FROM t_prd_product_materials
 WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456') AND del_yn='N';

ROLLBACK;  -- 검증 전용. 실 복원은 COMMIT 으로 교체(인간 승인).
