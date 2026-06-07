-- =====================================================================
-- STEP 2: GP(합판도무송) 원형 가격 적재 (t_prc_component_prices)
--   100 GP 원형 행 (10직경×2mat[MAT_000084/153]×5수량밴드[1000..5000]). 35mm 제외(committed).
--   placeholder SIZ_PENDING_GP_원형NNmm → 실 siz_cd(501~510) 치환. note 에 [siz-corrected:…] 접두.
--
--   [수정 2026-06-07 — 라이브 DRY-RUN 적발 결함]
--   기존: comp_price_id 명시(2956~3065) + ON CONFLICT (comp_price_id) DO NOTHING.
--   결함: comp_price_id 는 IDENTITY(BY DEFAULT)·시퀀스 stale(last_value=2 vs MAX=4805).
--         명시 ID 는 시퀀스를 무시 → 향후 auto-IDENTITY INSERT 와 충돌·재실행 비멱등.
--         또한 ON CONFLICT(comp_price_id) 가 명시 ID 가 우연히 라이브에 있으면 가격행을
--         자연키 무관하게 silently skip → under-load.
--   수정: comp_price_id 생략(auto-IDENTITY) + 자연키 NOT EXISTS 멱등 가드.
--         migrate.sql step 00 setval 로 시퀀스를 MAX 로 재동기화 → 100행 4806~ 발급.
--   자연키(8): (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty).
--     GP 용 NULL 차원(clr/coat/bdl) 존재 → ux_t_prc_comp_prices_nat_key 가 NULLS DISTINCT
--     (라이브 indnullsnotdistinct=f)라 ON CONFLICT 무력 → IS NOT DISTINCT FROM 매칭 가드 사용.
--   reg_dt 미포함 — NOT NULL DEFAULT now() 발화(round-5 reg_dt 교훈 준수).
--   comp_cd=COMP_GANGPAN_PRINT 는 라이브 실재(35mm 행이 이미 참조). FK fk_prc_comp_prices_comp_cd PASS.
-- =====================================================================
-- src: load_price/t_prc_component_prices.csv:2957 (was comp_price_id=2956) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2958 (was comp_price_id=2957) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2959 (was comp_price_id=2958) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000084', NULL, NULL, 1000, 20600, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2960 (was comp_price_id=2959) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000153', NULL, NULL, 1000, 27200, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2961 (was comp_price_id=2960) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000084', NULL, NULL, 1000, 21500, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2962 (was comp_price_id=2961) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000153', NULL, NULL, 1000, 28500, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2963 (was comp_price_id=2962) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2964 (was comp_price_id=2963) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2965 (was comp_price_id=2964) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000084', NULL, NULL, 1000, 20000, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2966 (was comp_price_id=2965) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000153', NULL, NULL, 1000, 26100, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2969 (was comp_price_id=2968) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000084', NULL, NULL, 1000, 24000, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2970 (was comp_price_id=2969) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000153', NULL, NULL, 1000, 33300, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2971 (was comp_price_id=2970) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000084', NULL, NULL, 1000, 18500, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2972 (was comp_price_id=2971) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000153', NULL, NULL, 1000, 23500, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2973 (was comp_price_id=2972) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000084', NULL, NULL, 1000, 20300, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2974 (was comp_price_id=2973) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000153', NULL, NULL, 1000, 26700, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2975 (was comp_price_id=2974) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000084', NULL, NULL, 1000, 22000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2976 (was comp_price_id=2975) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000153', NULL, NULL, 1000, 29500, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2977 (was comp_price_id=2976) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000084', NULL, NULL, 1000, 24000, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2978 (was comp_price_id=2977) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000153', NULL, NULL, 1000, 33300, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/유포/투명데드롱/은데드롱 제작수량≥1000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 1000
);
-- src: load_price/t_prc_component_prices.csv:2979 (was comp_price_id=2978) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2980 (was comp_price_id=2979) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2981 (was comp_price_id=2980) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000084', NULL, NULL, 2000, 30900, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2982 (was comp_price_id=2981) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000153', NULL, NULL, 2000, 41500, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2983 (was comp_price_id=2982) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000084', NULL, NULL, 2000, 32500, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2984 (was comp_price_id=2983) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000153', NULL, NULL, 2000, 49600, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2985 (was comp_price_id=2984) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2986 (was comp_price_id=2985) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2987 (was comp_price_id=2986) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000084', NULL, NULL, 2000, 30000, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2988 (was comp_price_id=2987) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000153', NULL, NULL, 2000, 39200, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2991 (was comp_price_id=2990) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000084', NULL, NULL, 2000, 36000, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2992 (was comp_price_id=2991) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000153', NULL, NULL, 2000, 54600, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2993 (was comp_price_id=2992) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000084', NULL, NULL, 2000, 28000, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2994 (was comp_price_id=2993) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000153', NULL, NULL, 2000, 35600, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2995 (was comp_price_id=2994) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000084', NULL, NULL, 2000, 30500, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2996 (was comp_price_id=2995) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000153', NULL, NULL, 2000, 39800, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2997 (was comp_price_id=2996) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000084', NULL, NULL, 2000, 33000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2998 (was comp_price_id=2997) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000153', NULL, NULL, 2000, 46300, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:2999 (was comp_price_id=2998) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000084', NULL, NULL, 2000, 36000, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/비코팅/무광코팅/유광코팅 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:3000 (was comp_price_id=2999) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000153', NULL, NULL, 2000, 54600, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/유포/투명데드롱/은데드롱 제작수량≥2000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 2000
);
-- src: load_price/t_prc_component_prices.csv:3001 (was comp_price_id=3000) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3002 (was comp_price_id=3001) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3003 (was comp_price_id=3002) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000084', NULL, NULL, 3000, 41500, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3004 (was comp_price_id=3003) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000153', NULL, NULL, 3000, 55600, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3005 (was comp_price_id=3004) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000084', NULL, NULL, 3000, 46500, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3006 (was comp_price_id=3005) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000153', NULL, NULL, 3000, 71100, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3007 (was comp_price_id=3006) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3008 (was comp_price_id=3007) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3009 (was comp_price_id=3008) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000084', NULL, NULL, 3000, 40000, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3010 (was comp_price_id=3009) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000153', NULL, NULL, 3000, 52200, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3013 (was comp_price_id=3012) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000084', NULL, NULL, 3000, 50000, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3014 (was comp_price_id=3013) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000153', NULL, NULL, 3000, 75700, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3015 (was comp_price_id=3014) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000084', NULL, NULL, 3000, 37000, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3016 (was comp_price_id=3015) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000153', NULL, NULL, 3000, 47300, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3017 (was comp_price_id=3016) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000084', NULL, NULL, 3000, 40600, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3018 (was comp_price_id=3017) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000153', NULL, NULL, 3000, 52800, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3019 (was comp_price_id=3018) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000084', NULL, NULL, 3000, 44000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3020 (was comp_price_id=3019) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000153', NULL, NULL, 3000, 62700, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3021 (was comp_price_id=3020) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000084', NULL, NULL, 3000, 50000, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/비코팅/무광코팅/유광코팅 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3022 (was comp_price_id=3021) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000153', NULL, NULL, 3000, 75700, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/유포/투명데드롱/은데드롱 제작수량≥3000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 3000
);
-- src: load_price/t_prc_component_prices.csv:3023 (was comp_price_id=3022) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3024 (was comp_price_id=3023) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3025 (was comp_price_id=3024) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000084', NULL, NULL, 4000, 51500, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3026 (was comp_price_id=3025) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000153', NULL, NULL, 4000, 69900, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3027 (was comp_price_id=3026) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000084', NULL, NULL, 4000, 60000, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3028 (was comp_price_id=3027) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000153', NULL, NULL, 4000, 92400, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3029 (was comp_price_id=3028) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3030 (was comp_price_id=3029) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3031 (was comp_price_id=3030) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000084', NULL, NULL, 4000, 50000, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3032 (was comp_price_id=3031) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000153', NULL, NULL, 4000, 65300, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3035 (was comp_price_id=3034) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000084', NULL, NULL, 4000, 64000, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3036 (was comp_price_id=3035) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000153', NULL, NULL, 4000, 97200, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3037 (was comp_price_id=3036) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000084', NULL, NULL, 4000, 46500, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3038 (was comp_price_id=3037) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000153', NULL, NULL, 4000, 59400, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3039 (was comp_price_id=3038) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000084', NULL, NULL, 4000, 51500, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3040 (was comp_price_id=3039) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000153', NULL, NULL, 4000, 62900, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3041 (was comp_price_id=3040) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000084', NULL, NULL, 4000, 55000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3042 (was comp_price_id=3041) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000153', NULL, NULL, 4000, 79400, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3043 (was comp_price_id=3042) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000084', NULL, NULL, 4000, 64000, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/비코팅/무광코팅/유광코팅 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3044 (was comp_price_id=3043) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000153', NULL, NULL, 4000, 97200, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/유포/투명데드롱/은데드롱 제작수량≥4000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 4000
);
-- src: load_price/t_prc_component_prices.csv:3045 (was comp_price_id=3044) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3046 (was comp_price_id=3045) siz:SIZ_PENDING_GP_원형10mm->SIZ_000501
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000501', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '[siz-corrected: SIZ_PENDING_GP_원형10mm→SIZ_000501] 원형 10mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000501' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3047 (was comp_price_id=3046) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000084', NULL, NULL, 5000, 62000, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3048 (was comp_price_id=3047) siz:SIZ_PENDING_GP_원형15mm->SIZ_000502
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000502', NULL, 'MAT_000153', NULL, NULL, 5000, 84100, '[siz-corrected: SIZ_PENDING_GP_원형15mm→SIZ_000502] 원형 15mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000502' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3049 (was comp_price_id=3048) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000084', NULL, NULL, 5000, 74000, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3050 (was comp_price_id=3049) siz:SIZ_PENDING_GP_원형20mm->SIZ_000503
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000503', NULL, 'MAT_000153', NULL, NULL, 5000, 113900, '[siz-corrected: SIZ_PENDING_GP_원형20mm→SIZ_000503] 원형 20mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000503' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3051 (was comp_price_id=3050) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3052 (was comp_price_id=3051) siz:SIZ_PENDING_GP_원형25mm->SIZ_000504
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000504', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '[siz-corrected: SIZ_PENDING_GP_원형25mm→SIZ_000504] 원형 25mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000504' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3053 (was comp_price_id=3052) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000084', NULL, NULL, 5000, 60000, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3054 (was comp_price_id=3053) siz:SIZ_PENDING_GP_원형30mm->SIZ_000505
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000505', NULL, 'MAT_000153', NULL, NULL, 5000, 78300, '[siz-corrected: SIZ_PENDING_GP_원형30mm→SIZ_000505] 원형 30mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000505' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3057 (was comp_price_id=3056) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000084', NULL, NULL, 5000, 77000, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3058 (was comp_price_id=3057) siz:SIZ_PENDING_GP_원형40mm->SIZ_000506
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000506', NULL, 'MAT_000153', NULL, NULL, 5000, 118500, '[siz-corrected: SIZ_PENDING_GP_원형40mm→SIZ_000506] 원형 40mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000506' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3059 (was comp_price_id=3058) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000084', NULL, NULL, 5000, 55500, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3060 (was comp_price_id=3059) siz:SIZ_PENDING_GP_원형45mm->SIZ_000507
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000507', NULL, 'MAT_000153', NULL, NULL, 5000, 71100, '[siz-corrected: SIZ_PENDING_GP_원형45mm→SIZ_000507] 원형 45mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000507' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3061 (was comp_price_id=3060) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000084', NULL, NULL, 5000, 61000, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3062 (was comp_price_id=3061) siz:SIZ_PENDING_GP_원형50mm->SIZ_000508
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000508', NULL, 'MAT_000153', NULL, NULL, 5000, 78900, '[siz-corrected: SIZ_PENDING_GP_원형50mm→SIZ_000508] 원형 50mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000508' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3063 (was comp_price_id=3062) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000084', NULL, NULL, 5000, 66000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3064 (was comp_price_id=3063) siz:SIZ_PENDING_GP_원형55mm->SIZ_000509
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000509', NULL, 'MAT_000153', NULL, NULL, 5000, 96000, '[siz-corrected: SIZ_PENDING_GP_원형55mm→SIZ_000509] 원형 55mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000509' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3065 (was comp_price_id=3064) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000084', NULL, NULL, 5000, 77000, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/비코팅/무광코팅/유광코팅 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000084' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
-- src: load_price/t_prc_component_prices.csv:3066 (was comp_price_id=3065) siz:SIZ_PENDING_GP_원형60mm->SIZ_000510
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_GANGPAN_PRINT', '2026-06-01', 'SIZ_000510', NULL, 'MAT_000153', NULL, NULL, 5000, 118500, '[siz-corrected: SIZ_PENDING_GP_원형60mm→SIZ_000510] 원형 60mm/유포/투명데드롱/은데드롱 제작수량≥5000 (원형=라이브부재 SIZ_PENDING 정당, 소재묶음=대표mat)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_GANGPAN_PRINT' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000510' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000153' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM 5000
);
