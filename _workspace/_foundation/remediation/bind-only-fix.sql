-- bind-only-fix.sql — 가격만결손 51 중 BIND_ONLY 16건 가격공식 바인딩
-- 생성 2026-06-26 · hsp-set-designer · DB 미적재(게이트 GO+인간 승인 후 load-executor 실행)
-- 멱등: NOT EXISTS 가드(PK=prd_cd,apply_bgn_ymd). 트랜잭션 래핑은 load-executor가 BEGIN/COMMIT.
-- reg_dt = DEFAULT now() (컬럼 기본값). note = 바인딩 근거.
-- ★단가값 무수정·기초데이터 무삭제. 16건 전 사전 바인딩 0행 실측(idempotency baseline clean).

DO $$
DECLARE
  v_ins INT := 0;
BEGIN
  -- PRF_CLR_ACRYL (투명3T 아크릴 15건) · apply_bgn_ymd=2026-06-15(동군 PRD_000146 정합)
  INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
  SELECT v.prd_cd, 'PRF_CLR_ACRYL', '2026-06-15',
         'price-only-51 BIND_ONLY: CLR_ACRYL 165행 면적매트릭스 전사이즈 covered(dflt MAT_043)'
  FROM (VALUES
    ('PRD_000147'),('PRD_000148'),('PRD_000149'),('PRD_000150'),('PRD_000151'),
    ('PRD_000152'),('PRD_000155'),('PRD_000156'),('PRD_000157'),('PRD_000158'),
    ('PRD_000159'),('PRD_000160'),('PRD_000161'),('PRD_000162'),('PRD_000166')
  ) AS v(prd_cd)
  WHERE NOT EXISTS (
    SELECT 1 FROM t_prd_product_price_formulas f
    WHERE f.prd_cd = v.prd_cd AND f.apply_bgn_ymd = '2026-06-15'
  );
  GET DIAGNOSTICS v_ins = ROW_COUNT;
  RAISE NOTICE 'PRF_CLR_ACRYL inserted: %', v_ins;

  -- PRF_COROTTO_ACRYL (164 아크릴코롯토) · apply_bgn_ymd=2026-06-15(CONFIRM-164-ymd)
  INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
  SELECT 'PRD_000164', 'PRF_COROTTO_ACRYL', '2026-06-15',
         'price-only-51 BIND_ONLY: COROTTO 21행 면적매트릭스 6사이즈(30-80square) covered. A2 C4-D04 고아바인딩'
  WHERE NOT EXISTS (
    SELECT 1 FROM t_prd_product_price_formulas f
    WHERE f.prd_cd = 'PRD_000164' AND f.apply_bgn_ymd = '2026-06-15'
  );
  GET DIAGNOSTICS v_ins = ROW_COUNT;
  RAISE NOTICE 'PRF_COROTTO_ACRYL inserted: %', v_ins;
END $$;
