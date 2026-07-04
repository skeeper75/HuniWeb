-- ============================================================
-- 아크릴 부속 저청구 교정 [addon·키링 동형] · 03 FIX (실 COMMIT)
--   ★ dryrun GO + 라이브 sim 검증 GO(부속 자재선택=0원 트랩·addon=권위가) + 인간 승인 후 실행.
--   02-dryrun 은 이 파일 맨 끝 COMMIT→ROLLBACK 로 실행. 전제: 01-backup 선행.
--   교정: 삭제 템플릿 6 복원 + 오모델 자재 6 제거(del_yn=Y). addon 링크 기존 존재(insert 없음).
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_acacc_templates','z_bak_acacc_materials','z_bak_acacc_addons');
  IF n<>3 THEN RAISE EXCEPTION '중단: 백업 %개(3 기대). 01-backup 선행.', n; END IF;
END $chk$;

DO $pre$ DECLARE n_t int; n_m int; BEGIN
  SELECT count(*) INTO n_t FROM t_prd_templates
   WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025') AND del_yn='Y';
  IF n_t<>6 THEN RAISE EXCEPTION '사전게이트①: 복원대상 삭제템플릿 %개(6 기대)', n_t; END IF;
  SELECT count(*) INTO n_m FROM t_prd_product_materials
   WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152')
     AND mat_cd IN ('MAT_000047','MAT_000048','MAT_000053','MAT_000054','MAT_000046','MAT_000049') AND del_yn='N';
  IF n_m<>6 THEN RAISE EXCEPTION '사전게이트②: 제거대상 오모델 자재 %개(6 기대)', n_m; END IF;
END $pre$;

-- ① 삭제 템플릿 복원
UPDATE t_prd_templates SET del_yn='N', del_dt=NULL, use_yn='Y', upd_dt=now()
 WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025');

-- ② 오모델 자재 제거(논리삭제·0원 트랩 제거)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152')
   AND mat_cd IN ('MAT_000047','MAT_000048','MAT_000053','MAT_000054','MAT_000046','MAT_000049');

DO $post$ DECLARE n_t int; n_m int; BEGIN
  SELECT count(*) INTO n_t FROM t_prd_templates
   WHERE tmpl_cd IN ('TMPL-000019','TMPL-000020','TMPL-000022','TMPL-000023','TMPL-000024','TMPL-000025') AND del_yn='N';
  IF n_t<>6 THEN RAISE EXCEPTION '사후게이트①: 복원 %개(6 기대)', n_t; END IF;
  SELECT count(*) INTO n_m FROM t_prd_product_materials
   WHERE prd_cd IN ('PRD_000148','PRD_000150','PRD_000152')
     AND mat_cd IN ('MAT_000047','MAT_000048','MAT_000053','MAT_000054','MAT_000046','MAT_000049') AND del_yn='N';
  IF n_m<>0 THEN RAISE EXCEPTION '사후게이트②: 오모델 자재 잔존 %개(0 기대)', n_m; END IF;
  RAISE NOTICE 'FIX 게이트 통과: 템플릿복원6·오모델자재제거6.';
END $post$;

COMMIT;  -- 실 적재. 사후 라이브 sim 재검증·스냅샷 재생성·재진단 권장.
