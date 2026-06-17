-- apply.sql — 실사 가격 견적화 트랙(round-23 Phase C) 멱등 적재/교정 단일 트랜잭션
-- ===========================================================================
-- HARD: 기본 ROLLBACK(DRY-RUN). 실 COMMIT은 apply.sh --commit(인간 승인) 에서만.
--   본 파일 자체는 COMMIT 미포함 — 로더(apply.sh)가 ROLLBACK/COMMIT을 주입.
-- FK 위상정렬: U1(siz 부모) → U3/U4(comp/배선) → U5(삭제) → U6(공식/배선/바인딩) → U8(가독성).
-- U2(면적단가)·U7(제본배선) = BLOCKED(별 파일, apply 제외).
-- ===========================================================================
\set ON_ERROR_STOP on

BEGIN;

\echo '== U1: 신규 좌표 siz 106행 선적재 =='
\i U1_siz_coords.sql

\echo '== U3: C-1/2/3 오시·가변 통합(레거시 use_yn=N·배선 교체) =='
\i U3_integrate_creasevar.sql

\echo '== U4: C-4 미싱 통합 + prc_typ .02->.01 + opt_cd->dim_vals 재정규화 =='
\i U4_perf_normalize.sql

\echo '== U5: 별색 WHITE_S1 잉여 4색 proc 단가행 424 삭제(106 유지) =='
\i U5_white_dedup.sql

\echo '== U6: 가격사슬 공식 분리(28상품 유형별 공식+자기 comp 배선+바인딩 교체) =='
\i U6_formula_split.sql

\echo '== U8: 실무진 가독성 정비(comp_nm/note 한국어) =='
\i U8_readability.sql

-- 로더가 여기서 ROLLBACK(기본) 또는 COMMIT(--commit) 주입.
