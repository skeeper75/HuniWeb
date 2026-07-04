-- ============================================================
-- 아크릴키링 고리 저청구 교정 [addon] · 03 FIX (실 COMMIT)
--   ★ 02-dryrun GO + 라이브 sim 검증 GO(은색고리+1100/금색+1200/구슬줄+300) + 인간 승인 후 실행.
--   전제: 01-backup 선행(z_bak_ackeyr2_*). 02-dryrun 과 동일 로직·게이트. 차이 = COMMIT.
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_ackeyr2_templates','z_bak_ackeyr2_addons','z_bak_ackeyr2_materials');
  IF n<>3 THEN RAISE EXCEPTION '중단: 백업 %개(3 기대). 01-backup 선행 필요.', n; END IF;
END $chk$;

DO $pre$ DECLARE n_tmpl int; n_mat int; n_link int; BEGIN
  SELECT count(*) INTO n_tmpl FROM t_prd_templates
   WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017') AND del_yn='Y';
  IF n_tmpl<>3 THEN RAISE EXCEPTION '사전게이트①: 복원대상 삭제템플릿 %개(3 기대)', n_tmpl; END IF;
  SELECT count(*) INTO n_mat FROM t_prd_product_materials
   WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456') AND del_yn='N';
  IF n_mat<>3 THEN RAISE EXCEPTION '사전게이트③: 제거대상 고리자재 %개(3 기대)', n_mat; END IF;
  SELECT count(*) INTO n_link FROM t_prd_product_addons
   WHERE prd_cd='PRD_000146' AND tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');
  IF n_link<>0 THEN RAISE EXCEPTION '사전게이트②: 이미 addon 링크 %개(0 기대)', n_link; END IF;
END $pre$;

UPDATE t_prd_templates SET del_yn='N', del_dt=NULL, use_yn='Y', upd_dt=now()
 WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');

INSERT INTO t_prd_product_addons (prd_cd, disp_seq, note, reg_dt, tmpl_cd) VALUES
 ('PRD_000146', 9,  'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000015'),
 ('PRD_000146', 10, 'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000016'),
 ('PRD_000146', 11, 'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000017');

UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456');

DO $post$ DECLARE n_tmpl int; n_link int; n_mat int; BEGIN
  SELECT count(*) INTO n_tmpl FROM t_prd_templates
   WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017') AND del_yn='N';
  IF n_tmpl<>3 THEN RAISE EXCEPTION '사후게이트①: 복원 %개(3 기대)', n_tmpl; END IF;
  SELECT count(*) INTO n_link FROM t_prd_product_addons
   WHERE prd_cd='PRD_000146' AND tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');
  IF n_link<>3 THEN RAISE EXCEPTION '사후게이트②: addon 링크 %개(3 기대)', n_link; END IF;
  SELECT count(*) INTO n_mat FROM t_prd_product_materials
   WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456') AND del_yn='N';
  IF n_mat<>0 THEN RAISE EXCEPTION '사후게이트③: 고리자재 잔존 %개(0 기대)', n_mat; END IF;
  RAISE NOTICE 'FIX 게이트 통과: 복원3·링크3·고리자재제거.';
END $post$;

COMMIT;  -- 실 적재. 사후 라이브 sim 재검증·스냅샷 재생성·재진단 권장.
