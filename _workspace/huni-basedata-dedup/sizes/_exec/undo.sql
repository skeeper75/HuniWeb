-- undo.sql — D-1 역연산(백업 복원) 스크립트
-- 2026-06-19 / hbd-load-executor
-- COMMIT 후 사후검증 불일치 시 라이브를 백업 상태로 되돌린다.
-- 두 방법 제공: (A) 직접 역연산(권장·간단), (B) 백업 테이블 복원.

-- ===== (A) 직접 역연산 =====
BEGIN;
-- (b') 멤버 논리삭제 되돌리기: SIZ_000105 del_yn='N'
UPDATE t_siz_sizes
   SET del_yn='N', upd_dt=now()
 WHERE siz_cd='SIZ_000105' AND del_yn='Y';
-- (a') 멤버 바인딩 복구: PRD_000004 → SIZ_000105 (백업값 dflt_yn=Y, disp_seq=1)
--      논리삭제된 행이 남아있지 않으므로 백업에서 복원
INSERT INTO t_prd_product_sizes
  SELECT * FROM bak_prdsiz_basedata_dedup_20260619_0800 b
   WHERE b.siz_cd='SIZ_000105'
     AND NOT EXISTS (
       SELECT 1 FROM t_prd_product_sizes t
        WHERE t.prd_cd=b.prd_cd AND t.siz_cd=b.siz_cd);
-- 확인 후 COMMIT 또는 ROLLBACK
SELECT siz_cd, del_yn FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000104','SIZ_000105') ORDER BY siz_cd;
SELECT prd_cd, siz_cd, dflt_yn, del_yn FROM t_prd_product_sizes WHERE prd_cd='PRD_000004' ORDER BY siz_cd;
ROLLBACK;  -- 검증 후 COMMIT으로 교체하여 실제 복원

-- ===== (B) 백업 테이블 정리(복원 완료·검증 GO 후) =====
-- DROP TABLE IF EXISTS bak_siz_basedata_dedup_20260619_0800;
-- DROP TABLE IF EXISTS bak_prdsiz_basedata_dedup_20260619_0800;
