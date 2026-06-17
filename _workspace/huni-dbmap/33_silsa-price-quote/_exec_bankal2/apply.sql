-- ============================================================================
-- 반칼 058~061 가능분 가격 연결 — 통합 apply (BK6·단일 트랜잭션·FK 위상)
--   round-23 항목 7. arbiter bankal-058-064-deepcheck BK6 + 사용자 컨펌(A5=124x186 동일가·A4 반칼 분리).
--   058 반칼원형·059 반칼정사각·060 반칼직사각·061 반칼띠지 (A5/A4 시트·소재 5종·형상=조각 칼틀).
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: BK6a(A4 siz 채번 부모)→BK6c(A4 단가·siz FK)·BK6b(A5 단가·SIZ_170 기존)→BK6d(product_sizes·SIZ_520 FK)→BK6e(바인딩·PRF 기존)
-- ★돈 크리티컬: A4 반칼=SIZ_000520 신규(B01 col2 5000/6000)·B02 낱장 SIZ_172(4000) 무접촉 → 오청구 0.
-- 멱등: 전건 NOT EXISTS/조건부 UPDATE·단가 verbatim·search-before-mint(siz 채번 1·소재 5종 기존).
-- BLOCKED(미포함): 064 소량자유형(가격표 단가 부재·Q-DC-3)·058~061 A3(마스터 미등록 불요).
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- BK6a: A4 반칼 전용 siz 채번 SIZ_000520 (B02 SIZ_172와 분리) ---'
\i BK6a_codegen.sql

\echo '--- BK6b: 058~061 A5 단가행 (SIZ_170·5소재×36mq·col1=124x186 동일가) ---'
\i BK6b_price_a5.sql

\echo '--- BK6c: 058~061 A4 반칼 단가행 (SIZ_520·5소재×36mq·col2 5000/6000) ---'
\i BK6c_price_a4.sql

\echo '--- BK6d: 058~061 A4 등록 siz 교정 (SIZ_172 B02낱장 → SIZ_520 반칼전용) ---'
\i BK6d_fix_product_sizes.sql

\echo '--- BK6e: 058~061 → PRF_STK_FIXED 바인딩 ---'
\i BK6e_bindings.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
