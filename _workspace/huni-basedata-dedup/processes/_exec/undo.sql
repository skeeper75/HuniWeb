-- undo.sql — 공정축 9 thin-mirror 논리삭제 역연산(복원) 스크립트
-- 2026-06-19 / hbd-load-executor
-- COMMIT 후 사후검증 불일치 시 라이브를 백업 상태(del_yn='N')로 되돌린다.
-- 단순 논리삭제만 했으므로 역연산도 del_yn='N' 복원 only (백업 테이블은 보조 검증용).

-- ===== 직접 역연산 (롤백전용 검증 → COMMIT으로 교체 시 실제 복원) =====
BEGIN;
UPDATE t_proc_processes
   SET del_yn='N', upd_dt=now()
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091',
                   'PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
   AND del_yn='Y';
-- 확인
SELECT proc_cd, del_yn FROM t_proc_processes
 WHERE proc_cd IN ('PROC_000087','PROC_000088','PROC_000089','PROC_000091','PROC_000093','PROC_000094','PROC_000095','PROC_000096','PROC_000097')
 ORDER BY proc_cd;
ROLLBACK;  -- 실제 복원 시 COMMIT으로 교체

-- ===== 백업 대조(선택) =====
-- SELECT b.proc_cd, b.del_yn AS bak_del, t.del_yn AS live_del
--   FROM bak_proc_dedup_round_pilot b JOIN t_proc_processes t USING (proc_cd) ORDER BY b.proc_cd;

-- ===== 백업 테이블 정리 (복원/검증 GO 완료 후) =====
-- DROP TABLE IF EXISTS bak_proc_dedup_round_pilot;
