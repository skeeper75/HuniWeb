-- apply.sql — 공정축 9 thin-mirror 논리삭제 APPLY 본문 (COMMIT)
-- 2026-06-19 / hbd-load-executor
-- ★[HARD] 내장 BEGIN/COMMIT 금지(round-24 비인가 COMMIT 사고 재발방지).
--   이 파일은 멱등 UPDATE 본문만 — 실행 래퍼(psql -1 또는 명시 BEGIN/COMMIT)는 분리 호출.
-- 멱등 가드 WHERE del_yn='N' (이미 Y면 no-op·재실행 delta 0).

UPDATE t_proc_processes
   SET del_yn='Y', upd_dt=now()
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091',
                   'PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
   AND del_yn='N';
-- 예상 delta: 9행 (재실행 시 0). 정본 부모 무변경·단가행 이동 0·바인딩 재배선 0·물리삭제 0.
