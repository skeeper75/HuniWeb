-- ============================================================================
-- 린넨패브릭포스터 마감가공 옵션 등록 — 통합 apply (L1~L5·단일 트랜잭션·FK 위상)
--   PRD_000124 · 가공 5택1 · 단가 verbatim(0/800/1000/2000/2000)
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT 은 apply.sh --commit + 인간 최종 승인.
-- FK 위상: L1(옵션)→L1b(item·trigger)→L2(comp)→L3(단가·comp 부모)→L4(배선·frm+comp 부모)→L5(dflt UPDATE)
--   · L1b 는 L1(옵션 OPV_000424 존재) 이후 — option_items FK→options.
--   · L3 는 L2(comp 존재) 이후 — component_prices.comp_cd FK→price_components.
--   · L4 는 L2(comp) + 기존 PRF_POSTER_LINEN 이후.
-- 멱등 NOT EXISTS/조건부 UPDATE·단가 verbatim·search-before-mint(신규 OPV 1·comp 1·proc/자재 0).
-- ============================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '--- L1: 복합 옵션 (말아박기+면끈 신규 OPV_000424·오버로크+리본끈 OPV-000024 기존) ---'
\i L1_composite_options.sql

\echo '--- L1b: 복합 옵션 item (OPT_REF_DIM.04→PROC_000080) ---'
\i L1b_composite_items.sql

\echo '--- L2: add-on comp COMP_POSTEROPT_LINEN_FINISH ---'
\i L2_addon_comp.sql

\echo '--- L3: 단가행 5 (opt_cd별 0/800/1000/2000/2000) ---'
\i L3_unit_prices.sql

\echo '--- L4: 공식 배선 PRF_POSTER_LINEN disp10 ---'
\i L4_formula_wiring.sql

\echo '--- L5: 오버로크 dflt_yn=Y (기본 무료) ---'
\i L5_default_overlock.sql

-- 기본 ROLLBACK. apply.sh --commit 가 이 줄을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
