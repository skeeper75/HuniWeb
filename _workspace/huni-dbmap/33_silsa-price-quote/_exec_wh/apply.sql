-- apply.sql — 신안(siz_width/siz_height 구간) 실행본. 단일 트랜잭션·FK 위상순·롤백전용 DRY-RUN.
-- [HARD] 기본 ROLLBACK(아래). 실 COMMIT은 인간 승인 후 apply.sh --commit 으로만.
-- 순서: V1(면적단가 INSERT) → V1b(라이브 siz_cd 17 전환) → V2(use_dims 전환) → V3(nonspec incr).
--   V1/V1b 가 V2(모델 전환) 전에 데이터를 채워 가격 공백 0. comp_cd/prd_cd 부모 라이브 선존재(검증).
-- 단가행 = 가격표 verbatim(날조 0). 좌표 siz 채번 0(U1 폐기).
\set ON_ERROR_STOP on
BEGIN;

\echo '=== V1: 면적매트릭스 단가행 667 INSERT (siz_width/siz_height) ==='
\i V1_area_unitprices.sql

\echo '=== V1b: 라이브 siz_cd 매트릭스 17행 → siz_width/siz_height 전환(값 불변) ==='
\i V1b_convert_live_sizcd.sql

\echo '=== V2: 본체 13 comp use_dims [siz_cd] → [siz_width,siz_height] ==='
\i V2_use_dims_switch.sql

\echo '=== V3: nonspec_width_incr/height_incr 백필 (13 상품) ==='
\i V3_nonspec_incr.sql

-- 기본 = 롤백전용 DRY-RUN. (실 COMMIT 은 apply.sh --commit 이 ROLLBACK→COMMIT 치환)
ROLLBACK;
