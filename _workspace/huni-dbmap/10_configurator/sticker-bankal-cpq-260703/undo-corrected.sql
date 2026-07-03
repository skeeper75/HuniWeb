-- 스티커 반칼 CPQ(교정본) undo — load.sql(공정교정+CPQ) 역연산.
BEGIN;
-- CPQ 신규 제거 (OPT_000160-171 / OPV_000639-666 = 이번 신규)
DELETE FROM t_prd_product_option_items
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061','PRD_000062')
   AND opt_cd BETWEEN 'OPV_000639' AND 'OPV_000666';
DELETE FROM t_prd_product_options
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061','PRD_000062')
   AND opt_cd BETWEEN 'OPV_000639' AND 'OPV_000666';
DELETE FROM t_prd_product_option_groups
 WHERE opt_grp_cd BETWEEN 'OPT_000160' AND 'OPT_000171';
-- 062 기존 partial 복원
UPDATE t_prd_product_option_groups SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000062' AND opt_grp_cd IN ('OPT-000040','OPT-000041');
UPDATE t_prd_product_options SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000062' AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087');
UPDATE t_prd_product_option_items SET del_yn='N', del_dt=NULL
 WHERE prd_cd='PRD_000062' AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087');
-- 공정 원복 (반칼커팅 은퇴 → 스티커완칼 복원)
UPDATE t_prd_product_processes SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061') AND proc_cd='PROC_000122';
UPDATE t_prd_product_processes SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061') AND proc_cd='PROC_000055';
COMMIT;
