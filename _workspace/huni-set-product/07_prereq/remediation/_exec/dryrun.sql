-- dryrun.sql (_exec) — 롤백전용 라이브 DRY-RUN (BEGIN…ROLLBACK)
-- 부1(자재 10행 부활)만 검증. 부2=CONFIRM 분리(COMMIT 제외)이므로 DML 없음.
-- 제약위반0·멱등(2차 delta0)·예상 카운트·FK 고아 64→23 실증. ROLLBACK이라 라이브 무변경.
-- 2회 호출(R1 멱등): 한 트랜잭션 내 2회 APPLY → 2차 delta 0 확인.

BEGIN;

-- PRE 측정
SELECT 'PRE_dead_10' AS k, count(*) AS v FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146') AND del_yn='Y';
SELECT 'PRE_fk_orphan' AS k, count(*) AS v FROM t_mat_materials c JOIN t_mat_materials p ON c.upr_mat_cd=p.mat_cd WHERE c.del_yn='N' AND p.del_yn='Y';

-- APPLY 1차 (P2-A 전용지 + P3-A 종이 root 9)
WITH a AS (
  UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
   WHERE mat_cd='MAT_000246' AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY_P2A' AS k, count(*) AS v FROM a;
WITH b AS (
  UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
   WHERE mat_cd IN ('MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
     AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY_P3A' AS k, count(*) AS v FROM b;

-- APPLY 2차 (멱등 — delta 0 기대)
WITH c2 AS (
  UPDATE t_mat_materials SET del_yn='N', del_dt=NULL
   WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
     AND del_yn IS DISTINCT FROM 'N' RETURNING 1)
SELECT 'APPLY_2nd_idempotent_delta' AS k, count(*) AS v FROM c2;

-- POST 측정
SELECT 'POST_active_10' AS k, count(*) AS v FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146') AND del_yn='N';
SELECT 'POST_fk_orphan' AS k, count(*) AS v FROM t_mat_materials c JOIN t_mat_materials p ON c.upr_mat_cd=p.mat_cd WHERE c.del_yn='N' AND p.del_yn='Y';

-- 돈무손상 확인(단가행 0)
SELECT 'money_priced_rows' AS k, count(*) AS v FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146');

ROLLBACK;

-- ROLLBACK 후 무변경 확인(별도 실행):
SELECT 'AFTER_ROLLBACK_dead_10' AS k, count(*) AS v FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146') AND del_yn='Y';
-- 기대: PRE_dead_10=10, PRE_fk_orphan=64, APPLY_P2A=1, APPLY_P3A=9, APPLY_2nd_idempotent_delta=0,
--       POST_active_10=10, POST_fk_orphan=23, money_priced_rows=0, AFTER_ROLLBACK_dead_10=10.
