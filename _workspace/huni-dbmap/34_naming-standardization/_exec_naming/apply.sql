-- ============================================================================
-- apply.sql — 가격구성요소 comp_nm/note 네이밍 표준화 적재 (round-34)
-- ----------------------------------------------------------------------------
-- 대상   : t_prc_price_components (comp_nm / note / COMP_STK_TATTOO.comp_typ_cd)
-- 변경    : comp 대상행 111 + comp_typ_cd 보강 1 = 행 112 (모두 멱등 가드)
-- 무변경  : t_prc_component_prices(가격행) · use_yn · formula_components(배선)
-- 권위    : 34_naming-standardization/component-naming-cleanup.md (v2) verbatim
-- 생성    : gen_naming_sql.py → _naming_updates.sql (손편집 금지)
-- ----------------------------------------------------------------------------
-- ★트랜잭션: BEGIN 만 연다. COMMIT / ROLLBACK 은 로더(apply.sh)가 주입.
--   기본 실행(apply.sh)은 ROLLBACK DRY-RUN. 실 COMMIT 은 --commit + 인간 승인.
-- ============================================================================

\set ON_ERROR_STOP on
\encoding UTF8

BEGIN;

-- 멱등 가드 UPDATE 블록 (생성기 산출본을 그대로 포함 — 단일 사실원)
\i _naming_updates.sql

-- 적용 직후 자가 점검 (트랜잭션 내부·COMMIT 전):
-- 코드노출 잔존 = 2 (제외한 빈 더미 2건) 이어야 함.
SELECT '코드노출 잔존(목표=2, 빈더미)' AS chk,
       count(*) AS n
  FROM t_prc_price_components
 WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\';

-- 빈 note(use_yn=Y) 잔존 = 0 이어야 함(COROTTO·TATTOO 보강 후).
SELECT 'use_yn=Y note 빈값 잔존(목표=0)' AS chk,
       count(*) AS n
  FROM t_prc_price_components
 WHERE use_yn = 'Y' AND (note IS NULL OR btrim(note) = '');

-- comp_typ_cd 빈값 잔존 = 0 이어야 함(TATTOO 보강 후).
SELECT 'comp_typ_cd 빈값 잔존(목표=0)' AS chk,
       count(*) AS n
  FROM t_prc_price_components
 WHERE comp_typ_cd IS NULL OR btrim(comp_typ_cd) = '';

-- ★COMMIT / ROLLBACK 은 여기서 내보내지 않는다 — 로더가 주입.
