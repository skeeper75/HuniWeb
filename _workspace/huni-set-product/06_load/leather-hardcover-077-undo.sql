-- ================================================================
-- UNDO — leather-hardcover-077 적재 취소 (baseline 복원·인간 승인 후 실행)
-- baseline(2026-07-01 백업): 077 셋트 4행(표지078 seq1·면지079/080/081 seq2/3/4·min/max NULL)
--   · 077/285 공식 바인딩 0행 · PRD_000285 부재
-- 복원 원칙: 신규 mint(285)는 생성분이므로 물리삭제 허용. 077 baseline 셋트행은 disp_seq·min/max 원복.
-- 단일 트랜잭션 권장: psql -v ON_ERROR_STOP=1 로 BEGIN; \i undo.sql; COMMIT;
-- ================================================================
BEGIN;

-- [1] 내지285 셋트 member 제거 (신규 추가분·물리삭제)
DELETE FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000285';

-- [2] 077 baseline 셋트행 원복 (표지078 min/max NULL·면지 disp_seq 2/3/4로 환원)
UPDATE t_prd_product_sets SET min_cnt=NULL, max_cnt=NULL, cnt_incr=NULL, disp_seq=1, note='표지=레더(화이트)', del_yn='N', upd_dt=now()
  WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000078';
UPDATE t_prd_product_sets SET disp_seq=2, note='면지=화이트면지', del_yn='N', upd_dt=now()
  WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000079';
UPDATE t_prd_product_sets SET disp_seq=3, note='면지=블랙면지', del_yn='N', upd_dt=now()
  WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000080';
UPDATE t_prd_product_sets SET disp_seq=4, note='면지=그레이면지', del_yn='N', upd_dt=now()
  WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000081';

-- [3] 공식 바인딩 제거 (077 부모공식·285 내지공식 둘 다 baseline=0행)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000077' AND frm_cd='PRF_HC_MUSEON_SET';
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000285';

-- [4] 내지285 차원 제거 (신규 생성분·물리삭제·마스터 t_siz_/t_mat_ 등은 미관여)
DELETE FROM t_prd_product_plate_sizes  WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_materials    WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_print_options WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_sizes        WHERE prd_cd='PRD_000285';

-- [5] 내지 반제품 마스터 제거 (신규 mint·물리삭제)
DELETE FROM t_prd_products WHERE prd_cd='PRD_000285';

-- 검증 (baseline 복귀 기대: 077=4행·285 부재·바인딩 0)
\echo '=== undo 후 검증 ==='
SELECT 'set_077' AS chk, count(*) AS n FROM t_prd_product_sets WHERE prd_cd='PRD_000077' AND del_yn='N'
UNION ALL SELECT 'product_285', count(*) FROM t_prd_products WHERE prd_cd='PRD_000285'
UNION ALL SELECT 'formula_077_285', count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000077','PRD_000285')
ORDER BY chk;

COMMIT;
