-- ============================================================================
-- foamboard-undo.sql — foamboard-fix 되돌리기 (해당 fix가 COMMIT됐을 경우에만)
-- 2026-07-01 · BEGIN…(검토 후 COMMIT) · 대상 한정
-- ----------------------------------------------------------------------------
-- [A] 폼보드 PRD_000129 = BLOCKED로 아무것도 커밋 안 함 → undo 대상 없음.
-- [B] 포맥스 PRD_000130 = fix가 DEFER 권고. 만약 COMMIT됐다면 아래로 원복.
--     (사이즈 등록/배선은 신규행이므로 물리 DELETE로 정확 원복 — 기존행 무영향)
-- ============================================================================
BEGIN;

-- B-2 배선 원복: 5mm formula_component 제거 (해당 신규행만)
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE5MM';

-- B-1 사이즈 등록 원복: PRD_000130 ← 315/317 제거 (fix가 추가한 신규행만)
DELETE FROM t_prd_product_sizes
 WHERE prd_cd='PRD_000130' AND siz_cd IN ('SIZ_000315','SIZ_000317');

\echo '=== VERIFY: 포맥스 원복 후 (174/197 3mm만, 배선 3mm seq1만) ==='
SELECT prd_cd, siz_cd, del_yn FROM t_prd_product_sizes WHERE prd_cd='PRD_000130' AND del_yn='N' ORDER BY siz_cd;
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' ORDER BY disp_seq;

ROLLBACK;  -- 실제 원복 필요 시 ROLLBACK→COMMIT (인간 승인 후)
-- ============================================================================
