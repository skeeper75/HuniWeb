-- ============================================================================
-- 신안(siz_width/siz_height) + G-D2(본체+후가공 배선) 통합 실행본 — apply.sql
-- ============================================================================
-- X-1 단일화: 신안 V2(use_dims→[siz_width,siz_height])와 G-D2 W2(본체 배선)가 같은 13
--   본체 comp를 건드림 → 따로 COMMIT 시 엔진 selection 키 충돌(area body가 siz_cd인지
--   siz_width/height인지 비결정). 본 통합으로 use_dims 전환(V2)·데이터(V1/V1b)·배선(W1~W6)을
--   단일 트랜잭션에 묶어 신안을 G-D2 상위 차원으로 단일화.
--
-- 통합 정합 규칙:
--   · 면적 13 comp: use_dims=[siz_width,siz_height](V2). 단가=V1(667)+V1b(17 전환). off-grid=V3.
--   · 고정가 15 comp: siz_cd 이산 유지(신안 미적용). 공식분리/본체배선은 W1/W2 그대로.
--   · 후가공/미싱/별색(W4~W6): 28공식 공통·proc_cd/dim_vals(사이즈축 무관·신안 영향 0).
--   · U1(좌표 siz 채번) 폐기 · U2(면적단가)=신안 V1로 대체.
--   · U5'(별색 dedup)=별 트랙(이번 제외). W4 배선은 포함, dedup은 별도.
--
-- FK 위상·단일 트랜잭션·멱등(NOT EXISTS/조건부 UPDATE)·단가행 재적재 0(값 불변).
-- [HARD] 기본 ROLLBACK(DRY-RUN). 실 COMMIT은 apply.sh --commit + 인간 최종 승인.
-- ============================================================================

\set ON_ERROR_STOP on
\timing off
BEGIN;

\echo '===== [1/10] V1 면적단가 INSERT (667·신안 siz_width/height) ====='
\i ../_exec_wh/V1_area_unitprices.sql

\echo '===== [2/10] V1b 라이브 siz_cd 매트릭스 → siz_width/height 전환 (17) ====='
\i ../_exec_wh/V1b_convert_live_sizcd.sql

\echo '===== [3/10] V2 면적 13 comp use_dims [siz_cd]→[siz_width,siz_height] ====='
\i ../_exec_wh/V2_use_dims_switch.sql

\echo '===== [4/10] W1 본체 공식분리 (28 PRF_POSTER_*) ====='
\i ../_exec_gd2/W1_body_formula_split.sql

\echo '===== [5/10] W2 본체 배선 (28: 면적13 siz_width/h + 고정15 siz_cd) ====='
\i ../_exec_gd2/W2_body_wiring.sql

\echo '===== [6/10] W3 바인딩 교체 (28상품 PRF_POSTER_FIXED→유형별) ====='
\i ../_exec_gd2/W3_binding_swap.sql

\echo '===== [7/10] W4 후가공 배선 (오시/귀돌이/가변/별색·proc_cd 차원) ====='
\i ../_exec_gd2/W4_postproc_wiring.sql

\echo '===== [8/10] W5 미싱 차원전환 (opt_cd→proc_cd+dim_vals.줄수·prc_typ.02→.01) ====='
\i ../_exec_gd2/W5_perf_dim_convert.sql

\echo '===== [9/10] W6 미싱 배선 (PERF_1L→28공식) ====='
\i ../_exec_gd2/W6_perf_wiring.sql

\echo '===== [10/10] V3 off-grid nonspec_incr 백필 (13상품) ====='
\i ../_exec_wh/V3_nonspec_incr.sql

-- [HARD] 기본 = 롤백전용 DRY-RUN. apply.sh 가 --commit 시에만 이 ROLLBACK 을 COMMIT 으로 치환.
ROLLBACK;
\echo '===== ROLLBACK 완료 (COMMIT 0 — 라이브 무변경) ====='
