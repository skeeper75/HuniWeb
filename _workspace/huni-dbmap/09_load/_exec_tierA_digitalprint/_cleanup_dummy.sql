-- =====================================================================
-- _cleanup_dummy.sql — 016/025 테스트 더미 정리 (인간 승인 전용 · 자동 실행 금지)
--   우리 정식 옵션 레이어와 무관한 더미. 멱등 이름검사라 충돌은 없으나, 더미 잔존은 UI 혼란.
--   [HARD] 본 파일은 apply.sql 에 포함되지 않음. 인간이 명시 승인 시에만 별도 실행.
-- =====================================================================
-- 016 더미: 그룹 OPT-000005(후가공) · 옵션 OPV-000007~010 · option_items 7행 (코드체계 OPT-/OPV- 하이픈)
-- 025 더미: constraint RULE_001(금지테스트)
BEGIN;
  DELETE FROM t_prd_product_option_items WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');
  DELETE FROM t_prd_product_options       WHERE prd_cd='PRD_000016' AND opt_cd IN ('OPV-000007','OPV-000008','OPV-000009','OPV-000010');
  DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000016' AND opt_grp_cd='OPT-000005';
  DELETE FROM t_prd_product_constraints   WHERE prd_cd='PRD_000025' AND rule_cd='RULE_001';
-- ROLLBACK;  -- 기본은 검토용. 실제 정리는 COMMIT(인간 승인) 으로 교체.
ROLLBACK;
