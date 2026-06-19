-- verify.sql — 공정축 9 thin-mirror 논리삭제 사후검증 V1~V5 (COMMIT 후 라이브 재실측)
-- 2026-06-19 / hbd-load-executor

\echo '=== V1 자식 9건 del_yn=Y (기대: 전부 Y) ==='
SELECT proc_cd, del_yn FROM t_proc_processes
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
 ORDER BY proc_cd;

\echo '=== V2 정본 부모 9건 del_yn=N 무변경 (기대: 전부 N) ==='
SELECT proc_cd, proc_nm, del_yn FROM t_proc_processes
 WHERE proc_cd IN ('PROC_000054','PROC_000080','PROC_000081','PROC_000053','PROC_000082','PROC_000055','PROC_000083','PROC_000084','PROC_000002')
 ORDER BY proc_cd;

\echo '=== V3 가격 무영향: component_prices/product_processes 전체 행수 (기대: cp=7288, prdproc=270 불변) ==='
SELECT (SELECT count(*) FROM t_prc_component_prices) AS cp_total,
       (SELECT count(*) FROM t_prd_product_processes) AS prdproc_total;

\echo '=== V4 FK고아 0: 9 자식 외부참조 여전히 0 ==='
SELECT t.proc_cd,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.proc_cd=t.proc_cd) AS cp,
  (SELECT count(*) FROM t_prd_product_processes p WHERE p.proc_cd=t.proc_cd) AS prdproc,
  (SELECT count(*) FROM t_proc_processes c WHERE c.upr_proc_cd=t.proc_cd) AS children
FROM (VALUES ('PROC_000087'),('PROC_000088'),('PROC_000089'),('PROC_000091'),('PROC_000093'),('PROC_000094'),('PROC_000095'),('PROC_000096'),('PROC_000097')) t(proc_cd)
ORDER BY t.proc_cd;

\echo '=== V5 멱등: apply 재실행 시 delta=0 (롤백전용) ==='
BEGIN;
WITH u AS (
  UPDATE t_proc_processes SET del_yn='Y', upd_dt=now()
   WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
     AND del_yn='N'
  RETURNING 1)
SELECT 'V5 re-apply delta (expect 0)' AS step, COUNT(*) AS delta FROM u;
ROLLBACK;

\echo '=== V-BLOCKED 미실행 확인: 086/090/092 여전히 del_yn=N + comp 보유 ==='
SELECT proc_cd, proc_nm, del_yn,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.proc_cd=t.proc_cd) AS cp
FROM t_proc_processes t
 WHERE proc_cd IN ('PROC_000086','PROC_000090','PROC_000092') ORDER BY proc_cd;
