-- backup.sql — 공정축 thin-mirror 9건 논리삭제 물리 백업
-- 2026-06-19 / hbd-load-executor
-- 영향 테이블의 영향 행만 고정명 백업 테이블로 복제(undo 안전망).
-- 멱등: 백업 테이블 존재 시 재실행하지 않도록 IF NOT EXISTS 가드.
-- 백업명 고정 접미사(_round_pilot) — Date.now() 금지.

CREATE TABLE IF NOT EXISTS bak_proc_dedup_round_pilot AS
  SELECT * FROM t_proc_processes
   WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091',
                     'PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097');

-- 백업 행수 확인 (기대: 9)
SELECT 'bak_proc_dedup_round_pilot' AS bak, COUNT(*) AS rows
  FROM bak_proc_dedup_round_pilot;
