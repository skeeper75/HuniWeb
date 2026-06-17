-- ============================================================================
-- 스티커 누락 채움 — 통합 apply (S1~S3·S8·단일 트랜잭션·FK 위상)
--   round-23 실사 가격 견적화 트랙 항목 7. 즉시 GO 가능분만(채번/컨펌 무의존).
--   S1 B01 소재 4미적재(288) · S2 투명 오매핑 교정 170→162(≤90 UPDATE)
--   S3 B4/B3 단가행(24·siz 실존) · S8 바인딩 3상품(054/056/057)
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: S1/S2/S3(component_prices·부모 COMP_STK_PRINT 기존)→S8(ppf·부모 PRF_STK_FIXED 기존)
--   · S1 홀로(163) 단가행이 S8 054 바인딩보다 선행(같은 트랜잭션 내 순서). 단 ppf↔component_prices FK 없음(논리 매칭).
-- 멱등: 전건 NOT EXISTS/조건부 UPDATE·단가 verbatim·search-before-mint(신규 siz/mat/comp/frm 0).
-- BLOCKED(미포함): S4 A4/A3(Q-STK-7)·S5 채번(100x148/90x110)·S6 타투(Q-STK-1)·S7 팩(Q-STK-3)·058~064(Q-STK-8)
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- S1: B01 소재 4미적재 (비코팅084·미색242·유광156·홀로163 × SIZ 59/60) 288행 ---'
\i S1_b01_materials.sql

\echo '--- S2: 투명 오매핑 교정 170→162 (기존 행 UPDATE·과교정 0) ---'
\i S2_clear_remap.sql

\echo '--- S3: B4/B3 단가행 24 (SIZ_000515/514 실존·verbatim) ---'
\i S3_b3b4_prices.sql

\echo '--- S8: 바인딩 3상품 054/056/057 → PRF_STK_FIXED ---'
\i S8_bindings.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
