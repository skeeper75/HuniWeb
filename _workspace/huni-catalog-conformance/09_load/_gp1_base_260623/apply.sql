-- apply.sql — §21 R-GP4-1 굿즈 GP-1 base 적재 (26 prd)
-- [HARD] BEGIN/COMMIT 미내장. 호출측이 트랜잭션 래핑. 멱등=ON CONFLICT DO NOTHING.
-- 단가=상품마스터260610 가격(C열) verbatim. PK=(prd_cd,apply_ymd).
INSERT INTO t_prd_product_prices (prd_cd, apply_ymd, unit_price, note, reg_dt)
VALUES
  ('PRD_000185','2026-06-10',2500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000196','2026-06-10',5000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000205','2026-06-10',3000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000210','2026-06-10',5000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000211','2026-06-10',18000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000212','2026-06-10',2500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000219','2026-06-10',4500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000223','2026-06-10',14000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000224','2026-06-10',12000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000225','2026-06-10',14500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000235','2026-06-10',16500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000236','2026-06-10',18000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000237','2026-06-10',20000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000248','2026-06-10',12500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000251','2026-06-10',6500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000253','2026-06-10',7200,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000256','2026-06-10',7500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000257','2026-06-10',8500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000258','2026-06-10',8500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000259','2026-06-10',9500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000260','2026-06-10',10500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000263','2026-06-10',31000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000265','2026-06-10',16500,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000266','2026-06-10',24000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000272','2026-06-10',58000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now()),
  ('PRD_000275','2026-06-10',25000,'GP-1 base 단일고정가 §21 R-GP4-1 (260610 verbatim)',now())
ON CONFLICT (prd_cd, apply_ymd) DO NOTHING;
