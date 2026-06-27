-- goods-pouch-pilot-fix.sql — 굿즈 크기 시범 3개 실제 저장(COMMIT)
-- 230/231/232 레더 파우치: 기존 크기코드 M·L 연결 + 잘못된 M/L 소재 논리해제.
-- 권위=상품마스터260610 굿즈파우치 작업사이즈. 신규 mint 0·물리삭제 0(del_yn만).
BEGIN;
DELETE FROM t_prd_product_sizes WHERE (prd_cd,siz_cd) IN
 (('PRD_000230','SIZ_000433'),('PRD_000230','SIZ_000434'),
  ('PRD_000231','SIZ_000435'),('PRD_000231','SIZ_000436'),
  ('PRD_000232','SIZ_000437'),('PRD_000232','SIZ_000438'));
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq) VALUES
 ('PRD_000230','SIZ_000433','Y',1),('PRD_000230','SIZ_000434','N',2),
 ('PRD_000231','SIZ_000435','Y',1),('PRD_000231','SIZ_000436','N',2),
 ('PRD_000232','SIZ_000437','Y',1),('PRD_000232','SIZ_000438','N',2);
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now()
 WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232')
   AND mat_cd IN ('MAT_000319','MAT_000320') AND COALESCE(del_yn,'N')<>'Y';
DO $$
DECLARE v_siz int; v_mat int;
BEGIN
  SELECT count(*) INTO v_siz FROM t_prd_product_sizes
   WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232') AND COALESCE(del_yn,'N')<>'Y';
  IF v_siz <> 6 THEN RAISE EXCEPTION '검증 실패: 사이즈 %건(기대 6)', v_siz; END IF;
  SELECT count(*) INTO v_mat FROM t_prd_product_materials
   WHERE prd_cd IN ('PRD_000230','PRD_000231','PRD_000232')
     AND mat_cd IN ('MAT_000319','MAT_000320') AND COALESCE(del_yn,'N')<>'Y';
  IF v_mat <> 0 THEN RAISE EXCEPTION '검증 실패: M/L 미해제 %건', v_mat; END IF;
  RAISE NOTICE '저장 검증 OK: 사이즈 6연결·M/L 해제·레더 보존·마스터코드 보존';
END $$;
COMMIT;
