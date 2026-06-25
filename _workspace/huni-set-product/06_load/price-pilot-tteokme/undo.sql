-- undo.sql — 097 떡메모지 가격공식 바인딩 되돌리기
-- 백업 테이블 bak_t_prd_product_price_formulas_tteokme_20260625_153807 (0행=097 사전 무바인딩)
-- COMMIT한 1행 삭제 = 사전 상태(097 바인딩 0행) 복귀. 멱등.

BEGIN;
DELETE FROM t_prd_product_price_formulas
 WHERE prd_cd='PRD_000097' AND frm_cd='PRF_TTEOKME_FIXED' AND apply_bgn_ymd='2026-06-01';
COMMIT;

-- 검증: 097 바인딩 0행 복귀 확인
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000097';
