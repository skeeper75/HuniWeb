-- dryrun.sql — 공정축 9 thin-mirror 논리삭제 롤백전용 DRY-RUN (BEGIN ... ROLLBACK)
-- 2026-06-19 / hbd-load-executor
-- 변경을 트랜잭션 내에서 실행 → 영향 행수·사후검증 SELECT 확인 → ROLLBACK(무손상).
-- 멱등 입증은 2-pass(이 스크립트 2회 연속 실행)로 수행 — 단, ROLLBACK이므로
-- 1회차 delta=9, 2회차도 ROLLBACK 후 동일 9가 아님을 입증하려면 동일 트랜잭션 내 2회 UPDATE로 가드 확인.

BEGIN;

-- (1차) thin-mirror 자식 9건 논리삭제 (멱등 가드 WHERE del_yn='N')
WITH u1 AS (
  UPDATE t_proc_processes
     SET del_yn='Y', upd_dt=now()
   WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091',
                     'PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
     AND del_yn='N'
  RETURNING 1)
SELECT 'PASS1 UPD t_proc_processes del_yn' AS step, COUNT(*) AS delta FROM u1;
--   기대 delta: 9

-- (2차 동일 트랜잭션 내 재실행) 멱등 가드 입증 — 이미 del_yn='Y' 이므로 0행
WITH u2 AS (
  UPDATE t_proc_processes
     SET del_yn='Y', upd_dt=now()
   WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091',
                     'PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
     AND del_yn='N'
  RETURNING 1)
SELECT 'PASS2 UPD (idempotent guard)' AS step, COUNT(*) AS delta FROM u2;
--   기대 delta: 0 (멱등)

-- 사후검증 (트랜잭션 내 상태)
\echo '--- V1 자식 9건=Y, 부모 9건=N ---'
SELECT proc_cd, del_yn FROM t_proc_processes
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097',
                   'PROC_000054','PROC_000080','PROC_000081','PROC_000053','PROC_000082','PROC_000055','PROC_000083','PROC_000084','PROC_000002')
 ORDER BY del_yn DESC, proc_cd;

\echo '--- V3/V4 멤버 외부참조 여전히 0 (CASCADE 무발생·FK고아 0) ---'
SELECT t.proc_cd,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.proc_cd=t.proc_cd) AS cp,
  (SELECT count(*) FROM t_prd_product_processes p WHERE p.proc_cd=t.proc_cd) AS prdproc
FROM (VALUES ('PROC_000087'),('PROC_000088'),('PROC_000089'),('PROC_000091'),('PROC_000093'),('PROC_000094'),('PROC_000095'),('PROC_000096'),('PROC_000097')) t(proc_cd)
ORDER BY t.proc_cd;
--   기대: 전부 0, 0

ROLLBACK;
