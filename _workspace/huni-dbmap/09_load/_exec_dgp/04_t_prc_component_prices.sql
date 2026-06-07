-- 04_t_prc_component_prices.sql  — 용지비 49행 (COMP_PAPER × 국4절 SIZ_000499 × 49 종이 mat_cd)
-- !! 멱등 가드 = INSERT … SELECT … WHERE NOT EXISTS (자연키 IS NOT DISTINCT FROM 매칭) !!
--   사유: 자연키 UNIQUE ux_t_prc_comp_prices_nat_key(8) 가 NULLS DISTINCT
--   (indnullsnotdistinct=f, 라이브 read-only 확인). 용지비는 clr_cd/coat_side_cnt/
--   bdl_qty/min_qty = NULL → ON CONFLICT 가 NULL 포함 행에 안 걸려 재실행 시 중복 INSERT.
--   IS NOT DISTINCT FROM 은 NULL=NULL 을 TRUE 로 매칭 → 재실행 0행 (R1 멱등 보장).
-- comp_price_id = surrogate PK(생략, 자동). reg_dt omit(DEFAULT now()). siz_cd=SIZ_000499 고정.

-- src: t_prc_component_prices_PAPER.csv:2  mat_cd=MAT_000072
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000072', NULL, NULL, NULL, 30.73, '용지비 백색모조지 100g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000072' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:3  mat_cd=MAT_000073
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000073', NULL, NULL, NULL, 36.875, '용지비 백색모조지 120g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000073' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:4  mat_cd=MAT_000074
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000074', NULL, NULL, NULL, 70.64, '용지비 백색모조지 220g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000074' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:5  mat_cd=MAT_000076
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000076', NULL, NULL, NULL, 30.565, '용지비 아트지 100g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000076' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:6  mat_cd=MAT_000077
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000077', NULL, NULL, NULL, 36.675, '용지비 아트지 120g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000077' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:7  mat_cd=MAT_000078
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000078', NULL, NULL, NULL, 46.65, '용지비 아트지 150g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000078' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:8  mat_cd=MAT_000079
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000079', NULL, NULL, NULL, 55.98, '용지비 아트지 180g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000079' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:9  mat_cd=MAT_000080
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000080', NULL, NULL, NULL, 62.195, '용지비 아트지 200g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000080' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:10  mat_cd=MAT_000081
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000081', NULL, NULL, NULL, 77.745, '용지비 아트지 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000081' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:11  mat_cd=MAT_000082
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000082', NULL, NULL, NULL, 93.3, '용지비 아트지 300g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000082' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:12  mat_cd=MAT_000086
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000086', NULL, NULL, NULL, 30.565, '용지비 스노우지 100g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000086' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:13  mat_cd=MAT_000087
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000087', NULL, NULL, NULL, 36.675, '용지비 스노우지 120g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000087' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:14  mat_cd=MAT_000088
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000088', NULL, NULL, NULL, 46.65, '용지비 스노우지 150g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000088' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:15  mat_cd=MAT_000089
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000089', NULL, NULL, NULL, 55.98, '용지비 스노우지 180g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000089' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:16  mat_cd=MAT_000090
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000090', NULL, NULL, NULL, 62.195, '용지비 스노우지 200g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000090' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:17  mat_cd=MAT_000091
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000091', NULL, NULL, NULL, 77.745, '용지비 스노우지 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000091' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:18  mat_cd=MAT_000092
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000092', NULL, NULL, NULL, 93.3, '용지비 스노우지 300g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000092' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:19  mat_cd=MAT_000095
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000095', NULL, NULL, NULL, 54.865, '용지비 앙상블 100g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000095' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:20  mat_cd=MAT_000101
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000101', NULL, NULL, NULL, 71.33, '용지비 랑데뷰 WH 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000101' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:21  mat_cd=MAT_000102
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000102', NULL, NULL, NULL, 87.795, '용지비 랑데뷰 WH 310g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000102' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:22  mat_cd=MAT_000104
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000104', NULL, NULL, NULL, 59.25, '용지비 몽블랑 100g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000104' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:23  mat_cd=MAT_000105
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000105', NULL, NULL, NULL, 77.025, '용지비 몽블랑 130g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000105' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:24  mat_cd=MAT_000106
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000106', NULL, NULL, NULL, 94.8, '용지비 몽블랑 160g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000106' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:25  mat_cd=MAT_000107
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000107', NULL, NULL, NULL, 112.575, '용지비 몽블랑 190g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000107' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:26  mat_cd=MAT_000108
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000108', NULL, NULL, NULL, 124.425, '용지비 몽블랑 210g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000108' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:27  mat_cd=MAT_000109
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000109', NULL, NULL, NULL, 142.2, '용지비 몽블랑 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000109' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:28  mat_cd=MAT_000113
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000113', NULL, NULL, NULL, 126, '용지비 아코팩(웜화이트) 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000113' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:29  mat_cd=MAT_000114
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000114', NULL, NULL, NULL, 152.5, '용지비 리사이클러스 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000114' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:30  mat_cd=MAT_000115
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000115', NULL, NULL, NULL, 167.75, '용지비 매쉬멜로우 233g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000115' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:31  mat_cd=MAT_000116
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000116', NULL, NULL, NULL, 295, '용지비 린넨커버 216g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000116' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:32  mat_cd=MAT_000117
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000117', NULL, NULL, NULL, 337.5, '용지비 스타화이트(하이테크) 238g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000117' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:33  mat_cd=MAT_000118
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000118', NULL, NULL, NULL, 480, '용지비 클래식 크래스트 스티플 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000118' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:34  mat_cd=MAT_000120
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000120', NULL, NULL, NULL, 226.864, '용지비 매직터치(백색) 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000120' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:35  mat_cd=MAT_000121
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000121', NULL, NULL, NULL, 244, '용지비 켄도 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000121' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:36  mat_cd=MAT_000125
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000125', NULL, NULL, NULL, 330, '용지비 한지 170g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000125' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:37  mat_cd=MAT_000126
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000126', NULL, NULL, NULL, 380, '용지비 스코트랜드 220g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000126' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:38  mat_cd=MAT_000127
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000127', NULL, NULL, NULL, 407.5, '용지비 스타드림(다이아몬드) 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000127' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:39  mat_cd=MAT_000128
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000128', NULL, NULL, NULL, 425, '용지비 스타드림(실버) 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000128' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:40  mat_cd=MAT_000129
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000129', NULL, NULL, NULL, 435, '용지비 스타드림(골드) 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000129' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:41  mat_cd=MAT_000130
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000130', NULL, NULL, NULL, 524, '용지비 스타드림(로즈쿼츠) 240g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000130' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:42  mat_cd=MAT_000136
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000136', NULL, NULL, NULL, 314, '용지비 뉴에코블랙 400g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000136' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:43  mat_cd=MAT_000137
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000137', NULL, NULL, NULL, 880, '용지비 큐리어스스킨 화이트 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000137' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:44  mat_cd=MAT_000138
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000138', NULL, NULL, NULL, 1242.5, '용지비 큐리어스스킨 레드 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000138' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:45  mat_cd=MAT_000139
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000139', NULL, NULL, NULL, 1242.5, '용지비 큐리어스스킨 다크블루 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000139' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:46  mat_cd=MAT_000140
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000140', NULL, NULL, NULL, 1242.5, '용지비 큐리어스스킨 바이올렛 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000140' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:47  mat_cd=MAT_000141
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000141', NULL, NULL, NULL, 1242.5, '용지비 큐리어스스킨 블랙 270g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000141' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:48  mat_cd=MAT_000142
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000142', NULL, NULL, NULL, 100, '용지비 유니크라프트 260g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000142' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:49  mat_cd=MAT_000150
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000150', NULL, NULL, NULL, 105, '용지비 뉴크라프트 250g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000150' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- src: t_prc_component_prices_PAPER.csv:50  mat_cd=MAT_000151
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PAPER', '2026-06-01', 'SIZ_000499', NULL, 'MAT_000151', NULL, NULL, NULL, 72, '용지비 팬시크라프트 120g 국4절(316x467) 절가'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd IS NOT DISTINCT FROM 'COMP_PAPER' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000499' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000151' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
