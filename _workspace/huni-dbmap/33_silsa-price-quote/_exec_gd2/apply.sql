-- apply.sql — G-D2 포스터 본체 후가공 배선 실행본 (W1~W6 단일 트랜잭션·FK 위상순)
-- ★기본 ROLLBACK(DRY-RUN). 실 COMMIT은 인간 승인 후 apply.sh --commit 에서만.
-- FK 위상순: W1(공식) → W2(본체배선) → W3(바인딩) → W4(후가공배선) → W5(미싱 차원전환) → W6(미싱배선).
--   W1이 W2/W4/W6의 frm_cd 부모. comp_cd/prd_cd는 모두 라이브 선존재(검증 완료).
-- 단가행 재적재 0 — 전부 배선/차원전환(값 불변). 동시매칭 0 — 각 공식 본체 1 comp(소재차원 불요).

\set ON_ERROR_STOP on
BEGIN;

\echo '--- W1 본체 공식 분리 (28) ---'
\i W1_body_formula_split.sql

\echo '--- W2 본체 배선 (disp_seq=1) ---'
\i W2_body_wiring.sql

\echo '--- W3 바인딩 교체 (PRF_POSTER_FIXED → 유형별) ---'
\i W3_binding_swap.sql

\echo '--- W4 후가공 배선 (오시·귀돌이2·가변2·별색2 = 7×28) ---'
\i W4_postproc_wiring.sql

\echo '--- W5 미싱 차원전환 (opt_cd → proc_cd+dim_vals.줄수·prc_typ.02→.01·2L/3L use_yn=N) ---'
\i W5_perf_dim_convert.sql

\echo '--- W6 미싱 배선 (disp_seq=9·W5 후) ---'
\i W6_perf_wiring.sql

-- 기본 ROLLBACK. (apply.sh 가 --commit 시에만 COMMIT 으로 치환)
ROLLBACK;
