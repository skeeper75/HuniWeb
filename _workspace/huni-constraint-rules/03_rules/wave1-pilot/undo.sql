-- =====================================================================
-- Huni-Constraint-Rules · wave-1 파일럿 · 129 폼보드 / 130 포맥스보드
-- CN-2 자재↔사이즈 엇갈림 제약 (RULE_TYPE.03 필수동반)
-- 유도 시점: 2026-07-02 13:59:30 · 원천: 라이브 t_prc_component_prices(읽기전용)
-- 생성: gen_sql.py (derived-rules.json verbatim) · 멱등 UPSERT
-- =====================================================================

-- 대칭 복원: 신규 8규칙 논리삭제 + 구 R_DEMO_MATSIZ 재활성
BEGIN;

UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND rule_cd='R_MATSIZ_FB_A3_WHITE_5MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND rule_cd='R_MATSIZ_FB_A3_BLACK_5MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND rule_cd='R_MATSIZ_FB_A2_WHITE_5MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000129' AND rule_cd='R_MATSIZ_FB_A2_BLACK_5MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000130' AND rule_cd='R_MATSIZ_FX_A3_WHITE_3MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000130' AND rule_cd='R_MATSIZ_FX_A2_WHITE_3MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000130' AND rule_cd='R_MATSIZ_FX_A3_WHITE_5MM';
UPDATE t_prd_product_constraints SET use_yn='N', del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000130' AND rule_cd='R_MATSIZ_FX_A2_WHITE_5MM';

UPDATE t_prd_product_constraints SET use_yn='Y', del_yn='N', upd_dt=now()
 WHERE prd_cd IN ('PRD_000129','PRD_000130') AND rule_cd='R_DEMO_MATSIZ';

COMMIT;
