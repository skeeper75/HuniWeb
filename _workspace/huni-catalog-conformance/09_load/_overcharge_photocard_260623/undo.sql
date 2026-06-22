-- =====================================================================
-- undo.sql — §21 포토카드 V3 교정 되돌리기 (COMMIT 후 복원용)
-- 2026-06-23 · 위상 역순(BIND 원복 → 고아 FIXED use_yn 복원 → 신규 공식 비활성).
--
-- 복원 대상(교정 전 상태로):
--   1. BIND 024/025 frm_cd → PRF_PHOTOCARD_FIXED (둘 다 FIXED로 원복)
--   2. PRF_PHOTOCARD_FIXED use_yn → 'Y' (고아 비활성 해제·다시 활성)
--   3. 신규 공식 PRF_PHOTOCARD_NORMAL/CLEAR → use_yn='N' (논리비활성·★del_yn 컬럼 부재)
--      ※ FC 배선(NORMAL←SET·CLEAR←CLEAR_SET)은 남겨도 무해(바인딩 0이라 미참조) — 완전 제거 옵션은 아래 주석.
--
-- ★단가행 unit_price·comp use_dims는 교정에서 무변경이라 복원 불필요.
-- ★기본 ROLLBACK. 실 undo는 ROLLBACK→COMMIT 교체 + 인간 승인.
-- =====================================================================

\set ON_ERROR_STOP on
BEGIN;

-- [위상 역순 1] BIND 024/025 → PRF_PHOTOCARD_FIXED 원복 (먼저 부모 재가리킴)
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_FIXED'
WHERE prd_cd='PRD_000024' AND apply_bgn_ymd='2026-06-01';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_FIXED'
WHERE prd_cd='PRD_000025' AND apply_bgn_ymd='2026-06-01';

-- [위상 역순 2] 고아 해제된 FIXED 다시 활성
UPDATE t_prc_price_formulas SET use_yn='Y', upd_dt=now()
WHERE frm_cd='PRF_PHOTOCARD_FIXED';

-- [위상 역순 3] 신규 공식 논리비활성 (use_yn='N' — FK 참조 0이라 안전)
UPDATE t_prc_price_formulas SET use_yn='N', upd_dt=now()
WHERE frm_cd IN ('PRF_PHOTOCARD_NORMAL','PRF_PHOTOCARD_CLEAR');

-- (선택·완전 제거) 신규 공식·FC 물리삭제를 원하면 아래 주석 해제 (위상: FC 먼저 → FRM):
-- DELETE FROM t_prc_formula_components WHERE frm_cd IN ('PRF_PHOTOCARD_NORMAL','PRF_PHOTOCARD_CLEAR');
-- DELETE FROM t_prc_price_formulas     WHERE frm_cd IN ('PRF_PHOTOCARD_NORMAL','PRF_PHOTOCARD_CLEAR');

-- 복원 후 확인
\echo '--- undo 후 상태 ---'
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000024','PRD_000025') ORDER BY prd_cd;
SELECT frm_cd, use_yn FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_PHOTOCARD%' ORDER BY frm_cd;

-- 기본 ROLLBACK. 실 undo COMMIT은 아래 줄을 COMMIT으로 교체.
ROLLBACK;
-- COMMIT;
