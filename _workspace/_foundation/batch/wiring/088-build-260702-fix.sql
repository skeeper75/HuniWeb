-- 088 레더 링바인더 가격 구성 라이브 COMMIT (260702·실무진 답변 후·2단계 실행분 기록)
-- 실무진 결정: 제본/바인더비=077 레더하드커버 통합단가 동형(COMP_HC_MUSEON_COVERBIND·표지+제본·100부 7,969)·D링 두께 무관 단일가.
-- 088=빈 바인더(내지없음)→COVERBIND 하나만 배선. comp·단가행 재사용(신규 단가행 0·날조 0). undo=088-build-260702-undo.sql.
BEGIN;
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, use_yn)
VALUES ('PRF_LEATHER_RINGBINDER_SET', '레더 링바인더 표지+제본 통합(077 COVERBIND 동형)', 'Y');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_LEATHER_RINGBINDER_SET', 'COMP_HC_MUSEON_COVERBIND', 1, 'Y');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd)
VALUES ('PRD_000088', 'PRF_LEATHER_RINGBINDER_SET', '2026-01-01');
UPDATE t_prd_products SET use_yn='Y', upd_dt=now() WHERE prd_cd='PRD_000088';
COMMIT;
-- 사후검증(시뮬): copies=1→34,100·copies=100→796,900(7,969/부·077 tier 동형). 면지/표지 member=구조(0기여).
