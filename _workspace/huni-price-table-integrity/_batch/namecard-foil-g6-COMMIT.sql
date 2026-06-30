-- namecard-foil-g6-COMMIT.sql — 인간 승인 실 COMMIT 버전 (2026-06-30)
-- G6 1셀 오적재 교정: COMP_NAMECARD_FOIL_S1_STD/_S2_STD 1000구간 63,000 → 64,000(권위 verbatim).
-- 멱등 가드: unit_price=63000 인 행만 갱신(재실행 NO-OP). undo=namecard-foil-g6-undo.sql.
-- [REAL COMMIT] BEGIN … UPDATE … COMMIT. dryrun(ROLLBACK)=namecard-foil-g6-load.sql 별도 보존.
\set ON_ERROR_STOP on
SET client_min_messages = warning;
BEGIN;

UPDATE t_prc_component_prices
   SET unit_price = 64000, upd_dt = now()
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD')
   AND min_qty  = 1000
   AND unit_price = 63000;   -- 멱등 가드: 이미 64000이면 0행

COMMIT;
