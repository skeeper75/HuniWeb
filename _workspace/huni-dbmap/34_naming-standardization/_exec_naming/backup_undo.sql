-- ============================================================================
-- backup_undo.sql — 네이밍 표준화 백업 + 원복(undo) (round-34)
-- ----------------------------------------------------------------------------
-- ① BACKUP : 변경 대상 comp 의 현재 comp_nm/note/comp_typ_cd 를 출력(SELECT).
--            psql -f backup_undo.sql > backup_<날짜>.txt 로 보존.
-- ② UNDO   : _naming_undo.sql (라이브 실측 2026-06-18 pre-state 기준) 적용.
--            apply 후 원복이 필요할 때만 실행. 멱등(현재=pre면 0행).
-- ----------------------------------------------------------------------------
-- 사용:
--   백업만 :  psql … -v run_undo=0 -f backup_undo.sql
--   원복실행: psql … -v run_undo=1 -f backup_undo.sql   (BEGIN…COMMIT)
--   (기본 run_undo 미지정 시 백업만 수행)
-- ============================================================================

\set ON_ERROR_STOP on
\encoding UTF8
\if :{?run_undo}
\else
  \set run_undo 0
\endif

-- ── ① 현재값 백업 SELECT (변경 대상 111 comp) ────────────────────────────
\echo '== [BACKUP] 변경 대상 comp 현재값 (comp_cd | comp_typ_cd | comp_nm | note) =='
SELECT comp_cd, comp_typ_cd, comp_nm, COALESCE(note,'<NULL>') AS note
  FROM t_prc_price_components
 WHERE comp_cd IN (
   SELECT comp_cd FROM t_prc_price_components
    WHERE comp_nm LIKE '%[COMP\_%' ESCAPE '\'
       OR comp_cd IN (
         'COMP_ACRYL_COROTTO','COMP_STK_TATTOO',
         'COMP_PRINT_DIGITAL_S1','COMP_PP_CREASE_2L','COMP_PP_CREASE_3L',
         'COMP_PP_PERF_2L','COMP_PP_PERF_3L','COMP_PP_CORNER_RIGHT','COMP_PP_CORNER_ROUND',
         'COMP_BIND_TWINRING','COMP_BIND_SSABARI','COMP_BIND_CAL_WALL'))
   -- 빈더미 2건은 제외(미변경)
   AND comp_cd NOT IN ('COMP_POSTEROPT_BANNER_MESH_PROC_OPT','COMP_POPT_BNR_GAKMOK_STR_900_4')
 ORDER BY comp_cd;

-- ── ② UNDO (원복) ─ run_undo=1 일 때만 ──────────────────────────────────
\if :run_undo
  \echo '== [UNDO] pre-state 원복 적용 (BEGIN…COMMIT) =='
  BEGIN;
  \i _naming_undo.sql
  COMMIT;
  \echo '== UNDO COMMIT 완료 =='
\else
  \echo '== [UNDO] 미실행 (run_undo=0). 원복하려면 -v run_undo=1 =='
\endif
