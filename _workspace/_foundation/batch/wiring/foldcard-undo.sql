-- foldcard-undo.sql
-- foldcard-fix 를 COMMIT 한 뒤 되돌리는 스크립트. 백업(foldcard-backup-260701.csv) 상태로 환원.
-- 사전 상태: OPV_000107 item 존재(del_yn=Y) / OPV_000108·029 OPV_000135·OPV_000136 item 부재.
-- 주의: 물리 DELETE 는 원래 부재였던 3행에만 적용(원 상태 복원). 107 은 del_yn 만 Y 로 되돌림.

BEGIN;

-- (1) 027 기본값 item 을 원래대로 논리삭제 상태로 되돌림.
UPDATE t_prd_product_option_items
   SET del_yn = 'Y'
 WHERE prd_cd = 'PRD_000027' AND opt_cd = 'OPV_000107' AND item_seq = 1;

-- (2) fix 에서 새로 INSERT 한 3행을 물리 제거(원래 부재였으므로 완전 삭제가 원상복원).
DELETE FROM t_prd_product_option_items
 WHERE (prd_cd,opt_cd,item_seq) IN
       (('PRD_000027','OPV_000108',1),
        ('PRD_000029','OPV_000135',1),
        ('PRD_000029','OPV_000136',1));

SELECT prd_cd, opt_cd, item_seq, del_yn
  FROM t_prd_product_option_items
 WHERE (prd_cd,opt_cd) IN
       (('PRD_000027','OPV_000107'),('PRD_000027','OPV_000108'),
        ('PRD_000029','OPV_000135'),('PRD_000029','OPV_000136'))
 ORDER BY prd_cd, opt_cd;

-- COMMIT;  -- 확인 후 주석 해제
ROLLBACK;
