-- ============================================================================
-- 064 소량자유형 가격 적재 — 통합 apply (S064·단일 트랜잭션)
--   round-23 항목 7. 사용자 결정: B01 col1 규격가 사이즈무관 동일 적용·우선 등록 후 추후 변경.
--   064 소형 7사이즈(50x70~94x94)·소재 5종 = B01 col1(SIZ_059) 단가 verbatim 복사(잠정 note).
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: S064a(단가·comp/siz/mat 기존)→S064b(바인딩·PRF 기존). siz 채번 0(7종 실존).
-- 멱등: 전건 NOT EXISTS·단가 verbatim(INSERT…SELECT 복사·하드코딩 0)·search-before-mint(신규 0).
-- ★잠정: 단가행 note 에 "B01 규격가 잠정·추후 변경" 표기 — 실무진 식별 가능.
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- S064a: 064 소형 7사이즈 단가행 (B01 col1 verbatim 복사·5소재×36mq=1260·잠정 note) ---'
\i S064a_prices.sql

\echo '--- S064b: 064 → PRF_STK_FIXED 바인딩 ---'
\i S064b_binding.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
