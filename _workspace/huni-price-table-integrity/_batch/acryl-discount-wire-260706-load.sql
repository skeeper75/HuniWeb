-- 아크릴 7상품 수량할인 미배선 교정 (돈 크리티컬)
-- 발견: dim-editor-audit/DISCOUNT-CONFORMANCE-FINDINGS-260706.md 결함1
-- 같은 공식 PRF_CLR_ACRYL 형제(판아크릴 161·포카스탠드 162)는 DSC_ACR_QTY 배선·정상 작동.
-- 미배선 7상품은 대량주문 시 수량할인 전무 → 최대 정가의 2배 과청구.
-- base 가격 무변경(할인 배선만 추가). 형식 = 배선된 형제 행과 동일(apply_bgn_ymd 2026-06-01·note 공백).
-- 멱등: PK=(prd_cd, apply_bgn_ymd). ON CONFLICT DO UPDATE(재실행 안전).
-- [HARD] COMMIT은 인간 승인 + 각 상품 webadmin 실화면 배선후 할인적용 재확인 후에만.

BEGIN;

INSERT INTO t_prd_product_discount_tables (prd_cd, dsc_tbl_cd, apply_bgn_ymd, note)
VALUES
  ('PRD_000152', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 아크릴명찰
  ('PRD_000148', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 아크릴뱃지
  ('PRD_000157', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 아크릴네임택
  ('PRD_000150', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 아크릴스마트톡
  ('PRD_000151', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 맥세이프 스마트톡
  ('PRD_000159', 'DSC_ACR_QTY', '2026-06-01', ''),  -- 아크릴 코스터
  ('PRD_000158', 'DSC_ACR_QTY', '2026-06-01', '')   -- 아크릴 포카키링
ON CONFLICT (prd_cd, apply_bgn_ymd)
DO UPDATE SET dsc_tbl_cd = EXCLUDED.dsc_tbl_cd, upd_dt = now();

-- 사후 검증(트랜잭션 내): 7행 배선 확인
SELECT p.prd_cd, p.prd_nm, d.dsc_tbl_cd
FROM t_prd_products p
JOIN t_prd_product_discount_tables d ON d.prd_cd = p.prd_cd
WHERE p.prd_cd IN ('PRD_000152','PRD_000148','PRD_000157','PRD_000150','PRD_000151','PRD_000159','PRD_000158')
ORDER BY p.prd_cd;

-- 확인 후 COMMIT / 문제시 ROLLBACK
COMMIT;
