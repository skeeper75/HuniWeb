-- ============================================================================
-- 반칼 모양 062/063 가격 연결 — 통합 apply (BK-1·BK-2·단일 트랜잭션)
--   round-23 항목 7. arbiter bankal-shapes-resolution BK-1/BK-2 즉시 GO분.
--   062 반칼팬시·063 반칼팬시투명 → PRF_STK_FIXED 바인딩 (가격행 추가 0·기존 B01 단가 재사용).
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: 부모 PRF_STK_FIXED·PRD_062/063 라이브 실존 → 바인딩만(단일 스텝·FK 단순).
-- 멱등: PK=(prd_cd,apply_bgn_ymd) NOT EXISTS. 가격행 INSERT 0(형상=칼틀·가격 무관).
-- BLOCKED(미포함): 058~061(Q-BK-1)·064(Q-BK-2)·062/063 100x140(Q-BK-3)
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- BK-1/BK-2: 062/063 → PRF_STK_FIXED 바인딩 (가격행 0) ---'
\i BK_bindings.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
