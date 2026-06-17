-- ============================================================================
-- dryrun.sql — 네이밍 표준화 적재 롤백전용 DRY-RUN (round-34)
-- ----------------------------------------------------------------------------
-- 목적: comp_nm/note UPDATE 의 적재가능성·멱등성·무변경 불변식을 라이브에서
--       실증하되 절대 COMMIT 하지 않는다(BEGIN … ROLLBACK).
-- 검증: ① before/after (코드노출 102→2) ② 멱등 2-pass (2회차 0행)
--       ③ 가격행(component_prices) 무변경 ④ use_yn 무변경
--       ⑤ 컨펌 해소 반영(귀돌이·큐방·열재단·봉미싱·각목+끈·오리지널박명함 등)
-- 실행: psql … -f dryrun.sql   (COMMIT 0 — 끝에서 ROLLBACK)
-- ============================================================================

\set ON_ERROR_STOP on
\encoding UTF8
\timing off
\pset pager off

BEGIN;

-- ── 사전 스냅샷 (변경 전) ────────────────────────────────────────────────
CREATE TEMP TABLE _pre AS
SELECT comp_cd, comp_typ_cd, comp_nm, note, use_yn
  FROM t_prc_price_components;

-- 가격행·use_yn 기준 스냅샷(무변경 증명용)
CREATE TEMP TABLE _pre_prices AS
SELECT comp_cd, count(*) AS price_rows
  FROM t_prc_component_prices GROUP BY comp_cd;

\echo '== [BEFORE] 코드노출 comp_nm 수 (기대 102) =='
SELECT count(*) AS code_exposed_before
  FROM t_prc_price_components
 WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\';

\echo '== [BEFORE] use_yn=Y note 빈값 (기대 2: COROTTO·TATTOO) =='
SELECT count(*) AS empty_note_before
  FROM t_prc_price_components
 WHERE use_yn = 'Y' AND (note IS NULL OR btrim(note) = '');

\echo '== [BEFORE] comp_typ_cd 빈값 (기대 1: TATTOO) =='
SELECT count(*) AS empty_typ_before
  FROM t_prc_price_components
 WHERE comp_typ_cd IS NULL OR btrim(comp_typ_cd) = '';

-- ── PASS 1: 적용 ─────────────────────────────────────────────────────────
\echo '== [PASS-1] 적용 =='
\i _naming_updates.sql

\echo '== [AFTER] 코드노출 comp_nm 수 (기대 2 = 제외한 빈 더미) =='
SELECT count(*) AS code_exposed_after
  FROM t_prc_price_components
 WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\';

\echo '== [AFTER] 잔존 코드노출 comp_cd (기대: 2 빈더미만) =='
SELECT comp_cd, comp_nm
  FROM t_prc_price_components
 WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\'
 ORDER BY comp_cd;

\echo '== [AFTER] use_yn=Y note 빈값 (기대 0) =='
SELECT count(*) AS empty_note_after
  FROM t_prc_price_components
 WHERE use_yn = 'Y' AND (note IS NULL OR btrim(note) = '');

\echo '== [AFTER] comp_typ_cd 빈값 (기대 0) =='
SELECT count(*) AS empty_typ_after
  FROM t_prc_price_components
 WHERE comp_typ_cd IS NULL OR btrim(comp_typ_cd) = '';

-- ── 변경 행수 (before≠after diff) ─────────────────────────────────────────
\echo '== 실제 변경된 행수 (comp_nm/note/comp_typ_cd) =='
SELECT count(*) AS changed_rows
  FROM t_prc_price_components c
  JOIN _pre p USING (comp_cd)
 WHERE c.comp_nm IS DISTINCT FROM p.comp_nm
    OR c.note    IS DISTINCT FROM p.note
    OR c.comp_typ_cd IS DISTINCT FROM p.comp_typ_cd;

-- ── 무변경 불변식 ① 가격행(component_prices) 무변경 ──────────────────────
\echo '== [INVARIANT] 가격행 변동 (기대 0행) =='
SELECT po.comp_cd, po.price_rows AS before_rows,
       (SELECT count(*) FROM t_prc_component_prices x WHERE x.comp_cd = po.comp_cd) AS after_rows
  FROM _pre_prices po
 WHERE po.price_rows <> (SELECT count(*) FROM t_prc_component_prices x WHERE x.comp_cd = po.comp_cd);
\echo '   (위 결과가 비어 있으면 가격행 무변경 — PASS)'

-- ── 무변경 불변식 ② use_yn 무변경 ────────────────────────────────────────
\echo '== [INVARIANT] use_yn 변동 (기대 0행) =='
SELECT c.comp_cd, p.use_yn AS before_yn, c.use_yn AS after_yn
  FROM t_prc_price_components c JOIN _pre p USING (comp_cd)
 WHERE c.use_yn IS DISTINCT FROM p.use_yn;
\echo '   (위 결과가 비어 있으면 use_yn 무변경 — PASS)'

-- ── PASS 2: 멱등성 (재적용 시 0행 변경) ──────────────────────────────────
\echo '== [PASS-2] 멱등 재적용 — 변경 0행 기대 =='
CREATE TEMP TABLE _mid AS
SELECT comp_cd, comp_nm, note, comp_typ_cd FROM t_prc_price_components;
\i _naming_updates.sql
SELECT count(*) AS pass2_changed_rows
  FROM t_prc_price_components c JOIN _mid m USING (comp_cd)
 WHERE c.comp_nm IS DISTINCT FROM m.comp_nm
    OR c.note    IS DISTINCT FROM m.note
    OR c.comp_typ_cd IS DISTINCT FROM m.comp_typ_cd;
\echo '   (pass2_changed_rows = 0 이면 멱등 — PASS)'

-- ── 컨펌 해소 반영 검증 (refinement 확정 한글명) ─────────────────────────
\echo '== [CONFIRM] 컨펌 해소 반영 — 표준 한글명 적용 확인 =='
SELECT comp_cd, comp_nm FROM t_prc_price_components
 WHERE comp_cd IN (
   'COMP_PP_CORNER_RIGHT','COMP_PP_CORNER_ROUND',                          -- 귀돌이비
   'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4',                            -- 큐방
   'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE',                           -- 열재단
   'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW',                           -- 봉미싱
   'COMP_POPT_BNR_GAKMOK_STR_900_4_GT','COMP_POPT_BNR_GAKMOK_STR_900_4_LE', -- 각목+끈
   'COMP_POSTEROPT_PET_BANNER_STAND_IN','COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1',
   'COMP_POSTEROPT_JOKJA_CEILHOOK','COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER',
   'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE',                             -- 양면테잎
   'COMP_NAMECARD_FOIL_S1_STD'                                            -- 오리지널박명함
 )
 ORDER BY comp_cd;

-- ── 코드노출 0 목표 점검(빈더미 제외) ────────────────────────────────────
\echo '== [GOAL] 빈더미 제외 코드노출 (기대 0) =='
SELECT count(*) AS code_exposed_excl_dummy
  FROM t_prc_price_components
 WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\'
   AND comp_cd NOT IN ('COMP_POSTEROPT_BANNER_MESH_PROC_OPT','COMP_POPT_BNR_GAKMOK_STR_900_4');

-- ★절대 COMMIT 금지 — 롤백전용 DRY-RUN
ROLLBACK;
\echo '== ROLLBACK 완료 — 라이브 무변경(DRY-RUN) =='
