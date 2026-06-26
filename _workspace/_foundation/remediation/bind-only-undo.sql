-- bind-only-undo.sql — bind-only-fix.sql 되돌리기(정확한 16행만 삭제)
-- 생성 2026-06-26 · hsp-set-designer · 적재 후 회귀 시 load-executor가 실행.
-- ★삭제 범위 = 이번 fix가 INSERT한 정확한 (prd_cd, frm_cd, apply_bgn_ymd) 16조합만.
--   frm_cd 동시 일치로 우연히 동일 PK의 다른 바인딩 오삭제 방지. 기초데이터 무삭제(바인딩 행만).

DO $$
DECLARE v_del INT := 0;
BEGIN
  DELETE FROM t_prd_product_price_formulas
  WHERE apply_bgn_ymd = '2026-06-15'
    AND (
      (frm_cd = 'PRF_CLR_ACRYL' AND prd_cd IN (
        'PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151',
        'PRD_000152','PRD_000155','PRD_000156','PRD_000157','PRD_000158',
        'PRD_000159','PRD_000160','PRD_000161','PRD_000162','PRD_000166'))
      OR
      (frm_cd = 'PRF_COROTTO_ACRYL' AND prd_cd = 'PRD_000164')
    );
  GET DIAGNOSTICS v_del = ROW_COUNT;
  RAISE NOTICE 'undo deleted: % (expected 16)', v_del;
END $$;
