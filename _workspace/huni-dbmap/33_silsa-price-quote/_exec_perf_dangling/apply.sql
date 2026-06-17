-- ============================================================================
-- 미싱 dangling 배선 정리 통합 apply (D1) — G-D2 W5 잔재 제거
--   비활성(use_yn=N) COMP_PP_PERF_2L·_3L 의 formula_components 배선 4건 제거.
--   정본 PERF_1L 동반 배선(PRF_DGP_A·PRF_DGP_D)으로 미싱 가격 경로 보존(가격 불변).
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- 단가행/comp 무변경(배선만 DELETE)·멱등.
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- D1: 미싱 레거시 PERF_2L/3L dangling 배선 제거 (PRF_DGP_A·PRF_DGP_D) ---'
\i D1_unwire_perf_legacy.sql

-- 기본 ROLLBACK. apply.sh --commit 이 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
