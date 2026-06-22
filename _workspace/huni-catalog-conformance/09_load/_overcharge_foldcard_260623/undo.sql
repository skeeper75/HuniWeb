-- =====================================================================
-- undo.sql — §21 접지카드 V2 교정 되돌리기 (COMMIT 후 복원용)
-- 2026-06-23 · 위상 역순(단가행 FK 참조 해제 → 마스터 신규코드 논리삭제).
--
-- 복원 대상:
--   1. component_prices.proc_cd → NULL (4 comp) — FK 참조 해제 선행
--   2. price_components.use_dims → ["min_qty"] (교정 전 원복)
--   3. 신규 마스터 PROC_000106/107 → del_yn='Y' (논리삭제·재사용 071/060은 무관)
--
-- ★단가행 unit_price는 교정에서 무변경이라 복원 불필요.
-- ★기본 ROLLBACK. 실 undo는 \set 또는 -v commit=1 로 COMMIT 분기.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- [위상 역순 1] 단가행 proc_cd NULL 복원 (FK 참조 먼저 해제)
UPDATE t_prc_component_prices SET proc_cd = NULL
WHERE comp_cd IN ('COMP_FOLD_LEAF_3FOLD','COMP_FOLD_LEAF_4ACC','COMP_FOLD_LEAF_4GATE','COMP_FOLD_LEAF_HALF');

-- [위상 역순 2] use_dims 교정 전 원복
UPDATE t_prc_price_components SET use_dims = '["min_qty"]'::jsonb
WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%';

-- [위상 역순 3] 신규 마스터 코드 논리삭제 (FK 참조 해제된 뒤 안전)
--   ※ PROC_000060(3단접지·기존)·PROC_000071(병풍·기존 재사용)은 무관 — 건드리지 않음.
UPDATE t_proc_processes SET del_yn = 'Y', use_yn = 'N'
WHERE proc_cd IN ('PROC_000106','PROC_000107');

-- 복원 후 확인
\echo '--- undo 후 상태 ---'
SELECT comp_cd, COALESCE(proc_cd,'<NULL>') proc_cd FROM t_prc_component_prices
WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' GROUP BY comp_cd, proc_cd ORDER BY comp_cd;
SELECT comp_cd, use_dims::text FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' ORDER BY comp_cd;
SELECT proc_cd, proc_nm, use_yn, del_yn FROM t_proc_processes WHERE proc_cd IN ('PROC_000106','PROC_000107');

-- 기본 ROLLBACK. 실 undo COMMIT은 아래 줄을 COMMIT으로 바꾸거나 -v 분기.
ROLLBACK;
-- COMMIT;
