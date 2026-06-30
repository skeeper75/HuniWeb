-- ================================================================
-- hardcover-ring-082 UNDO (역연산·COMMIT 되돌리기·단일 트랜잭션)
-- 원칙: 신규 mint(286·PRF_HC_TWINRING_SET)는 물리삭제 가능. 082 셋트는 baseline(5행·seq1~5)으로 원복.
-- 백업 복원 참조: backup-20260701_0041.sql · bak_t_prd_product_sets_setbuild_20260701_0041
-- ================================================================
BEGIN;

-- [셋트행] 신규 내지286 member 물리삭제 + 면지 disp_seq 원복(baseline 5행·표지seq1·면지084~087 seq2~5)
DELETE FROM t_prd_product_sets WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000286';
UPDATE t_prd_product_sets SET min_cnt=NULL, max_cnt=NULL, cnt_incr=NULL, disp_seq=1, note='표지=전용지'      WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000083';
UPDATE t_prd_product_sets SET disp_seq=2, note='면지=화이트면지' WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000084';
UPDATE t_prd_product_sets SET disp_seq=3, note='면지=블랙면지'   WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000085';
UPDATE t_prd_product_sets SET disp_seq=4, note='면지=그레이면지' WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000086';
UPDATE t_prd_product_sets SET disp_seq=5, note='면지=인쇄면지'   WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000087';

-- [082 부모공식 바인딩 제거 — 견적 0원 baseline 복귀]
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000082' AND frm_cd='PRF_HC_TWINRING_SET';

-- [내지286 공식·차원·마스터 — 신규 mint 전체 물리삭제]
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_plate_sizes    WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_materials      WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_print_options  WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_sizes          WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_products               WHERE prd_cd='PRD_000286';

-- [링 부모공식 신설분 — 082 전용·다른 상품 미사용 시]
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_HC_TWINRING_SET';
DELETE FROM t_prc_price_formulas     WHERE frm_cd='PRF_HC_TWINRING_SET';

COMMIT;
-- 검증: 082 셋트 5행(seq1~5)·286 부재·PRF_HC_TWINRING_SET 부재 = baseline 복귀.
