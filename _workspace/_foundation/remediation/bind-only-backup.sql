-- bind-only-backup.sql — 적재 전 영향 대상 16건 현재 상태 백업(롤백 근거)
-- 생성 2026-06-26 · hsp-set-designer · 읽기전용 백업(쓰기 없음)
-- 적재 직전 load-executor가 실행하여 적재 전 스냅샷 보존.

-- 16 대상 prd_cd의 현재 바인딩 전수(빈 결과 = clean baseline, 충돌 없음)
SELECT prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt, upd_dt
FROM t_prd_product_price_formulas
WHERE prd_cd IN (
  'PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151',
  'PRD_000152','PRD_000155','PRD_000156','PRD_000157','PRD_000158',
  'PRD_000159','PRD_000160','PRD_000161','PRD_000162','PRD_000166',
  'PRD_000164'
)
ORDER BY prd_cd, apply_bgn_ymd;

-- 대상 공식 실재 확인(use_yn=Y)
SELECT frm_cd, frm_nm, use_yn
FROM t_prc_price_formulas
WHERE frm_cd IN ('PRF_CLR_ACRYL','PRF_COROTTO_ACRYL');
