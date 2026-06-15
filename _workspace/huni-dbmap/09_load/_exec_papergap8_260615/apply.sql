-- =====================================================================
-- apply.sql — 디지털 국4절 종이비 GAP 7행 적재 (단일 트랜잭션)
--   COMMIT/ROLLBACK 은 apply.sh 가 -c 로 주입(기본 ROLLBACK = DRY-RUN).
--   포함: 01_comp_paper_gap (COMP_PAPER 단가행 7행 멱등 INSERT, NOT EXISTS 가드)
--   ★ backup.sql 은 여기 포함하지 않음 — 실 COMMIT 직전에 별도 실행(인간 승인).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;

\echo '── 적재 전: COMP_PAPER 행수 ──'
SELECT 'before' AS phase, count(*) AS comp_paper_rows FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';

\echo '── 01 디지털 국4절 종이비 GAP 7행 멱등 적재 ──'
\ir 01_comp_paper_gap.sql

\echo '── 적재 후 검증 (트랜잭션 내) ──'
-- 1) 전체 행수 (기존 49 + 신규 ≤7 = 56 기대 / 2회차 재실행 시 56 유지)
SELECT 'after' AS phase, count(*) AS comp_paper_rows FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';

-- 2) 7 GAP 단가행 실재 + 가격표 권위값 일치 검증
--    expected = 가격표 I열을 numeric(12,2) 스케일로 정규화한 값(라이브 49 RU 동일 관례).
--    가격표 87.795 → 라이브 87.80 (round-half-up, scale=2). 무손실 위반 아님 = 컬럼 제약 honor.
SELECT m.mat_cd, m.mat_nm, p.unit_price,
       CASE m.mat_cd
         WHEN 'MAT_000096' THEN 71.33  WHEN 'MAT_000097' THEN 87.80
         WHEN 'MAT_000098' THEN 104.24 WHEN 'MAT_000099' THEN 115.23
         WHEN 'MAT_000119' THEN 500    WHEN 'MAT_000123' THEN 245
         WHEN 'MAT_000124' THEN 306 END AS expected_price,
       (p.unit_price = CASE m.mat_cd
         WHEN 'MAT_000096' THEN 71.33  WHEN 'MAT_000097' THEN 87.80
         WHEN 'MAT_000098' THEN 104.24 WHEN 'MAT_000099' THEN 115.23
         WHEN 'MAT_000119' THEN 500    WHEN 'MAT_000123' THEN 245
         WHEN 'MAT_000124' THEN 306 END) AS price_match
FROM t_prc_component_prices p JOIN t_mat_materials m ON p.mat_cd=m.mat_cd
WHERE p.comp_cd='COMP_PAPER'
  AND m.mat_cd IN ('MAT_000096','MAT_000097','MAT_000098','MAT_000099','MAT_000119','MAT_000123','MAT_000124')
ORDER BY m.mat_cd;

-- 3) FK 무결성: 신규 7행의 mat_cd·siz_cd 부모 실재 확인 (고아 0 기대)
SELECT 'FK orphan check (0 기대)' AS chk,
       count(*) FILTER (WHERE NOT EXISTS (SELECT 1 FROM t_mat_materials m WHERE m.mat_cd=p.mat_cd)) AS mat_orphan,
       count(*) FILTER (WHERE NOT EXISTS (SELECT 1 FROM t_siz_sizes s WHERE s.siz_cd=p.siz_cd)) AS siz_orphan
FROM t_prc_component_prices p
WHERE p.comp_cd='COMP_PAPER'
  AND p.mat_cd IN ('MAT_000096','MAT_000097','MAT_000098','MAT_000099','MAT_000119','MAT_000123','MAT_000124');

-- 4) 자연키 중복 0 검증 (멱등 깨짐 탐지 — 7 GAP mat_cd 각 1행 기대)
SELECT 'natkey dup check (전건 1 기대)' AS chk, mat_cd, count(*) AS rows_per_key
FROM t_prc_component_prices
WHERE comp_cd='COMP_PAPER' AND apply_ymd='2026-06-01' AND siz_cd='SIZ_000499'
  AND clr_cd IS NULL AND proc_cd IS NULL AND opt_cd IS NULL
  AND coat_side_cnt IS NULL AND bdl_qty IS NULL AND min_qty IS NULL
  AND mat_cd IN ('MAT_000096','MAT_000097','MAT_000098','MAT_000099','MAT_000119','MAT_000123','MAT_000124')
GROUP BY mat_cd ORDER BY mat_cd;

-- COMMIT/ROLLBACK 은 apply.sh 가 주입
