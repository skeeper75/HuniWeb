-- apply.sql — D-1 merge 본문 (BEGIN/COMMIT 내장 금지 [HARD])
-- 2026-06-19 / hbd-load-executor
-- 실행 래퍼(BEGIN/검증/COMMIT 또는 ROLLBACK)는 dryrun.sql / commit 단계가 분리 관리.
-- 멱등 가드 내장: 재실행 시 delta 0.

-- (a) 멤버 바인딩 제거: PRD_000004 → SIZ_000105 (정본 104 이미 바인딩 → 무손실)
DELETE FROM t_prd_product_sizes
 WHERE prd_cd='PRD_000004' AND siz_cd='SIZ_000105' AND del_yn='N';

-- (b) 멤버 논리삭제: SIZ_000105 (삭제 권위=del_yn)
UPDATE t_siz_sizes
   SET del_yn='Y', upd_dt=now()
 WHERE siz_cd='SIZ_000105' AND del_yn='N';
