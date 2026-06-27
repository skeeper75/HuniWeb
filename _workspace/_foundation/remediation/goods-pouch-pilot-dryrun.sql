-- ============================================================================
-- goods-pouch-pilot-dryrun.sql — 굿즈 기초정보(크기) 시범 3개 DRY-RUN
--   레더 플랫/슬림/삼각 파우치(230/231/232)에 기존 크기코드(M·L) 연결
--   + 잘못 적재된 M/L 소재링크 논리해제(del_yn='Y'·마스터 코드 보존).
--   권위 = 상품마스터 260610 굿즈파우치 시트 작업사이즈. 라이브 미변경(ROLLBACK).
-- ----------------------------------------------------------------------------
-- search-before-mint: 필요 크기 6종 전부 기존 존재 → 신규 mint 0(연결만).
--   230: M=SIZ_433(220x300)·L=SIZ_434(260x340)
--   231: M=SIZ_435(220x294)·L=SIZ_436(260x374)
--   232: M=SIZ_437(440x160)·L=SIZ_438(520x200)
-- [HARD] 기초마스터 코드 삭제금지 → M/L 소재(MAT_319/320)는 물리삭제 아닌 del_yn='Y'(링크 해제).
-- ============================================================================
\echo '===== BEFORE: 230~232 사이즈 연결(0=결손)·소재 ====='
SELECT p.prd_cd,
 (SELECT count(*) FROM t_prd_product_sizes s WHERE s.prd_cd=p.prd_cd AND COALESCE(s.del_yn,'N')<>'Y') n_siz,
 (SELECT string_agg(m.mat_nm,', ') FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
   WHERE pm.prd_cd=p.prd_cd AND COALESCE(pm.del_yn,'N')<>'Y') mats
FROM t_prd_products p WHERE p.prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') ORDER BY p.prd_cd;

BEGIN;

-- 1) 크기 연결(멱등: 대상 prd×siz DELETE 후 INSERT). dflt_yn: M=Y(기본)·L=N. disp_seq M=1·L=2.
DELETE FROM t_prd_product_sizes WHERE (prd_cd,siz_cd) IN
 (('PRD_000230','SIZ_000433'),('PRD_000230','SIZ_000434'),
  ('PRD_000231','SIZ_000435'),('PRD_000231','SIZ_000436'),
  ('PRD_000232','SIZ_000437'),('PRD_000232','SIZ_000438'));
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq) VALUES
 ('PRD_000230','SIZ_000433','Y',1),('PRD_000230','SIZ_000434','N',2),
 ('PRD_000231','SIZ_000435','Y',1),('PRD_000231','SIZ_000436','N',2),
 ('PRD_000232','SIZ_000437','Y',1),('PRD_000232','SIZ_000438','N',2);

-- 2) 잘못 적재된 M/L 소재링크 논리해제(del_yn='Y'). 마스터 코드 MAT_319/320 보존(삭제금지).
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232')
   AND mat_cd IN ('MAT_000319','MAT_000320') AND COALESCE(del_yn,'N')<>'Y';

\echo '===== AFTER: 사이즈 연결 결과 ====='
SELECT ps.prd_cd, ps.siz_cd, s.siz_nm, s.work_width, s.work_height, ps.dflt_yn, ps.disp_seq
FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd
WHERE ps.prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') AND COALESCE(ps.del_yn,'N')<>'Y'
ORDER BY ps.prd_cd, ps.disp_seq;

\echo '===== AFTER: 소재(M/L 해제 후 = 레더만 남아야) ====='
SELECT pm.prd_cd, string_agg(m.mat_nm,', ') mats
FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
WHERE pm.prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') AND COALESCE(pm.del_yn,'N')<>'Y'
GROUP BY pm.prd_cd ORDER BY pm.prd_cd;

\echo '===== AFTER: M/L 마스터 코드 보존 확인(삭제 안 됨) ====='
SELECT mat_cd, mat_nm FROM t_mat_materials WHERE mat_cd IN ('MAT_000319','MAT_000320') ORDER BY mat_cd;

DO $$
DECLARE v_siz int; v_mat int;
BEGIN
  SELECT count(*) INTO v_siz FROM t_prd_product_sizes
   WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') AND COALESCE(del_yn,'N')<>'Y';
  IF v_siz <> 6 THEN RAISE EXCEPTION '검증 실패: 사이즈 연결 %건(기대 6)', v_siz; END IF;
  SELECT count(*) INTO v_mat FROM t_prd_product_materials
   WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232')
     AND mat_cd IN ('MAT_000319','MAT_000320') AND COALESCE(del_yn,'N')<>'Y';
  IF v_mat <> 0 THEN RAISE EXCEPTION '검증 실패: M/L 소재 미해제 %건', v_mat; END IF;
  RAISE NOTICE 'DRY-RUN 검증 OK: 사이즈 6연결·M/L 소재 해제·레더 보존·마스터코드 보존';
END $$;

ROLLBACK;
\echo '===== ROLLBACK 완료 — 라이브 미변경 ====='
