-- ============================================================================
-- round6-sticker-bankal-cpq-260703 / undo.sql
-- load.sql 로 적재한 신규 CPQ 행 제거 + 062 은퇴행 복원 → 적재 직전 상태로 원복.
-- 신규 행은 우리가 만든 것이므로 물리 DELETE 가 정당한 undo(이전 상태=부재).
-- FK 위상 역순: items → options → groups. 062 은퇴는 논리삭제 복원.
-- ============================================================================
BEGIN;

-- 1) 신규 option_items 제거 (note 는 items 테이블에 없으므로 opt_cd 연번 범위로)
DELETE FROM t_prd_product_option_items
 WHERE prd_cd IN ('PRD_000059','PRD_000060','PRD_000061','PRD_000062')
   AND opt_cd BETWEEN 'OPV_000639' AND 'OPV_000666';

-- 2) 신규 options 제거
DELETE FROM t_prd_product_options
 WHERE note='round6-sticker-bankal-cpq-260703'
   AND opt_cd BETWEEN 'OPV_000639' AND 'OPV_000666';

-- 3) 신규 option_groups 제거
DELETE FROM t_prd_product_option_groups
 WHERE note='round6-sticker-bankal-cpq-260703'
   AND opt_grp_cd BETWEEN 'OPT_000160' AND 'OPT_000171';

-- 4) 062 은퇴행 복원 (논리삭제 해제)
UPDATE t_prd_product_option_groups SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000062' AND opt_grp_cd IN ('OPT-000040','OPT-000041');
UPDATE t_prd_product_options SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000062'
   AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087');
UPDATE t_prd_product_option_items SET del_yn='N', del_dt=NULL, upd_dt=now()
 WHERE prd_cd='PRD_000062'
   AND opt_cd IN ('OPV-000082','OPV-000083','OPV-000084','OPV-000085','OPV-000086','OPV-000087');

COMMIT;
