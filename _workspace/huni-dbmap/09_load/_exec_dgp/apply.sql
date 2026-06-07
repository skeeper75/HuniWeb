-- =====================================================================
-- apply.sql — 디지털인쇄 가격엔진 GO 적재본 단일 트랜잭션 래퍼 (round-5)
--   FK 위상정렬 순서로 01~05 를 \i 로드 + BEGIN…COMMIT 로 원자 래핑.
--   기본 실행은 COMMIT(인간 승인). apply.sh DRY-RUN 모드가 마지막 COMMIT; 을
--   ROLLBACK; 으로 sed 치환하여 롤백전용 실행. 중간 COMMIT 없음(원자성 R2).
--
--   적재 내용 (총 147행, 신규 mint = PRF_DGP_A~F 6 + COMP_PAPER 1):
--     00 resync_sequence              -  (comp_price_id IDENTITY 시퀀스 재동기화, 모든 INSERT 전)
--     01 t_prc_price_formulas          6  (DGP 공식 헤더, ON CONFLICT (frm_cd))
--     02 t_prc_price_components        1  (COMP_PAPER 용지비, ON CONFLICT (comp_cd))
--     03 t_prc_formula_components     72  (공식↔구성요소 배선, ON CONFLICT (frm_cd,comp_cd))
--     04 t_prc_component_prices       49  (용지비 단가, WHERE NOT EXISTS IS NOT DISTINCT FROM, auto-IDENTITY)
--     05 t_prd_product_price_formulas 19  (상품↔공식 바인딩, ON CONFLICT (prd_cd,frm_cd))
--
--   FK 의존: 00(시퀀스 재동기화) → 01·02(부모 헤더) → 03·04(엔진 자식, 01/02 후) → 05(상품 바인딩).
--   신규 siz/mat/DDL 없음. 부모 코드행 FRM_TYPE.01·PRC_COMPONENT_TYPE.03·SIZ_000499 선존재.
--
--   [수정 2026-06-07] step 00: 라이브 DRY-RUN 적발 — comp_price_id 시퀀스 stale(last_value=2 vs
--     MAX=4805). 04 의 auto-IDENTITY 가 1,2,…를 발급해 기존 행과 충돌하므로, 모든 INSERT 전에
--     시퀀스를 MAX 로 재동기화(setval). 04 의 49행은 4806~ 발급 → 충돌 0. setval 은 트랜잭션
--     롤백 시 영구 미반영(DRY-RUN 안전)이며 idempotent.
--
--   HARD: 본 하네스는 자동 COMMIT 금지. 실제 반영은 apply.sh --commit (인간 승인) 으로만.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

-- [단계 0] comp_price_id IDENTITY 시퀀스 재동기화 (모든 INSERT 전, 04 충돌 방지)
\i 00_resync_sequence.sql

-- [단계 1] 엔진 부모 헤더 (FK 위상정렬: 자식보다 먼저)
\i 01_t_prc_price_formulas.sql
\i 02_t_prc_price_components.sql

-- [단계 2] 엔진 자식 (단계1 후: frm_cd / comp_cd 선존재 보장)
\i 03_t_prc_formula_components.sql
\i 04_t_prc_component_prices.sql

-- [단계 3] 상품 바인딩 (prd_cd 선존재 + frm_cd→01)
\i 05_t_prd_product_price_formulas.sql

COMMIT;
