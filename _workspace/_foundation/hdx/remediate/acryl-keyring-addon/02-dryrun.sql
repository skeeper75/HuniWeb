-- ============================================================
-- 아크릴키링 고리 저청구 교정 [addon] · 02 DRY-RUN (검증 전용·ROLLBACK)
--   전제: 01-backup.sql 선행(z_bak_ackeyr2_* 3테이블). 단일 트랜잭션·게이트·맨 끝 ROLLBACK.
-- 교정 3축(신규 mint 0):
--   ① 삭제 템플릿 복원: TMPL-000015 은색고리(1100)·016 금색고리(1200)·017 은색구슬줄(300) → del_yn=N
--   ② addon 링크: PRD_000146 → 위 3템플릿(disp_seq 9/10/11·볼체인 1~8 뒤)
--   ③ 오모델링 자재 제거: PRD_000146 product_materials MAT_000051/052/456 → del_yn=Y(0원 트랩 제거)
-- ============================================================
BEGIN;
SET LOCAL statement_timeout = '60s';

DO $chk$ DECLARE n int; BEGIN
  SELECT count(*) INTO n FROM information_schema.tables
   WHERE table_name IN ('z_bak_ackeyr2_templates','z_bak_ackeyr2_addons','z_bak_ackeyr2_materials');
  IF n<>3 THEN RAISE EXCEPTION '중단: 백업 %개(3 기대). 01-backup 선행 필요.', n; END IF;
END $chk$;

-- 사전 게이트(드리프트 방지)
DO $pre$ DECLARE n_tmpl int; n_mat int; n_link int; BEGIN
  SELECT count(*) INTO n_tmpl FROM t_prd_templates
   WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017') AND del_yn='Y';
  IF n_tmpl<>3 THEN RAISE EXCEPTION '사전게이트①: 복원대상 삭제템플릿 %개(3 기대)', n_tmpl; END IF;
  SELECT count(*) INTO n_mat FROM t_prd_product_materials
   WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456') AND del_yn='N';
  IF n_mat<>3 THEN RAISE EXCEPTION '사전게이트③: 제거대상 고리자재 %개(3 기대)', n_mat; END IF;
  SELECT count(*) INTO n_link FROM t_prd_product_addons
   WHERE prd_cd='PRD_000146' AND tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');
  IF n_link<>0 THEN RAISE EXCEPTION '사전게이트②: 이미 addon 링크 존재 %개(0 기대·중복)', n_link; END IF;
  RAISE NOTICE '사전게이트 통과: 삭제템플릿3·고리자재3·기존링크0.';
END $pre$;

-- ① 삭제 템플릿 복원
UPDATE t_prd_templates SET del_yn='N', del_dt=NULL, use_yn='Y', upd_dt=now()
 WHERE tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017');

-- ② addon 링크 추가(disp_seq 9/10/11)
INSERT INTO t_prd_product_addons (prd_cd, disp_seq, note, reg_dt, tmpl_cd) VALUES
 ('PRD_000146', 9,  'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000015'),
 ('PRD_000146', 10, 'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000016'),
 ('PRD_000146', 11, 'addon 고리 복원(가격표 260527 B04·저청구 교정)', now(), 'TMPL-000017');

-- ③ 오모델링 고리 자재 제거(논리삭제·base 대체 0원 트랩 제거)
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd='PRD_000146' AND mat_cd IN ('MAT_000051','MAT_000052','MAT_000456');

-- 사후 게이트
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
  RAISE NOTICE '사후게이트 통과: 복원3·링크3·고리자재제거(활성0).';
END $post$;

SELECT '교정후 고리 addon' lbl, a.disp_seq, a.tmpl_cd, t.tmpl_nm, p.unit_price
  FROM t_prd_product_addons a JOIN t_prd_templates t USING(tmpl_cd)
  LEFT JOIN t_prd_template_prices p USING(tmpl_cd)
  WHERE a.prd_cd='PRD_000146' AND a.tmpl_cd IN ('TMPL-000015','TMPL-000016','TMPL-000017')
  ORDER BY a.disp_seq;

ROLLBACK;  -- 검증 전용. 실 적재는 03-fix.sql(COMMIT).
