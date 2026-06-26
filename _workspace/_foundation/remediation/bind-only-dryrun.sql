-- bind-only-dryrun.sql — 롤백전용 DRY-RUN(적재 가능성·멱등성 실증, 실 변경 0)
-- 생성 2026-06-26 · hsp-set-designer · 전체를 BEGIN ... ROLLBACK으로 감싸 라이브 무변경.
-- 1차 INSERT delta=16 기대, 2차 동일 INSERT delta=0(멱등) 기대.

BEGIN;

-- 적재 전 카운트
SELECT 'before' AS phase, COUNT(*) AS n
FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151',
  'PRD_000152','PRD_000155','PRD_000156','PRD_000157','PRD_000158','PRD_000159',
  'PRD_000160','PRD_000161','PRD_000162','PRD_000166','PRD_000164');

-- 1차: fix 본문 (CLR_ACRYL 15 + COROTTO 1)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, 'PRF_CLR_ACRYL', '2026-06-15', 'dryrun'
FROM (VALUES ('PRD_000147'),('PRD_000148'),('PRD_000149'),('PRD_000150'),('PRD_000151'),
  ('PRD_000152'),('PRD_000155'),('PRD_000156'),('PRD_000157'),('PRD_000158'),
  ('PRD_000159'),('PRD_000160'),('PRD_000161'),('PRD_000162'),('PRD_000166')) AS v(prd_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas f
  WHERE f.prd_cd = v.prd_cd AND f.apply_bgn_ymd = '2026-06-15');
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT 'PRD_000164', 'PRF_COROTTO_ACRYL', '2026-06-15', 'dryrun'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas f
  WHERE f.prd_cd = 'PRD_000164' AND f.apply_bgn_ymd = '2026-06-15');

SELECT 'after_1st' AS phase, COUNT(*) AS n
FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151',
  'PRD_000152','PRD_000155','PRD_000156','PRD_000157','PRD_000158','PRD_000159',
  'PRD_000160','PRD_000161','PRD_000162','PRD_000166','PRD_000164');

-- 2차: 멱등 재적재(delta 0 기대)
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
SELECT v.prd_cd, 'PRF_CLR_ACRYL', '2026-06-15', 'dryrun2'
FROM (VALUES ('PRD_000147'),('PRD_000148'),('PRD_000149'),('PRD_000150'),('PRD_000151'),
  ('PRD_000152'),('PRD_000155'),('PRD_000156'),('PRD_000157'),('PRD_000158'),
  ('PRD_000159'),('PRD_000160'),('PRD_000161'),('PRD_000162'),('PRD_000166')) AS v(prd_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas f
  WHERE f.prd_cd = v.prd_cd AND f.apply_bgn_ymd = '2026-06-15');

SELECT 'after_2nd_idempotent' AS phase, COUNT(*) AS n
FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000151',
  'PRD_000152','PRD_000155','PRD_000156','PRD_000157','PRD_000158','PRD_000159',
  'PRD_000160','PRD_000161','PRD_000162','PRD_000166','PRD_000164');

ROLLBACK;
