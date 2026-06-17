-- ============================================================================
-- 스티커 BLOCKED 마무리 — 통합 apply (SB1·SB2·SB3·단일 트랜잭션·FK 위상)
--   round-23 항목 7. arbiter sticker-blocked-resolution SB1~SB3 즉시 GO분.
--   SB1 타투 합가형 사슬(frm+comp+단가+바인딩 5) · SB2 팩 .01→.02 교정(comp U·단가 D2+I1·frm+배선+바인딩)
--   SB3 채번(siz 518/519) → B01 100x148/90x110 단가행 504
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: SB3_codegen(siz 부모)→SB3_b01_prices(단가·siz 부모) / SB1·SB2(comp→단가→frm→배선→바인딩)
-- ★.02 합가형 min_qty NOT NULL(타투 3·팩 54)=엔진 pricing.py:188 base<=0 ValueError 회피.
-- 멱등: 전건 NOT EXISTS/조건부 UPDATE/조건부 DELETE·단가 verbatim·search-before-mint(siz 채번 2·frm/comp 신규).
-- BLOCKED(미포함): 타투 기본가2000(Q-STK-1b)·058~064 반칼변형(Q-STK-8)·A4/A3 B01 단가(Q-STK-7r)
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- SB3 채번: SIZ_000518(100x148)·SIZ_000519(90x110) 코드행 선적재 ---'
\i SB3_codegen.sql

\echo '--- SB3 단가: B01 100x148/90x110 504행 (verbatim) ---'
\i SB3_b01_prices.sql

\echo '--- SB1 타투: PRF_STK_TATTOO + COMP_STK_TATTOO(.02) + 단가행(min_qty=3·4000) + 바인딩067 ---'
\i SB1_tattoo.sql

\echo '--- SB2 팩 교정: COMP_STK_PACK .01→.02 + min_qty=54 단일행 + PRF_STK_PACK + 바인딩065 ---'
\i SB2_pack_fix.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
