-- =====================================================================
-- price-211 slice C2 load.sql — BOOKLET(하드커버)/PHOTOBOOK 적재 실행본
-- 멱등 INSERT, 단일 트랜잭션, FK 위상정렬. reg_dt omit(DEFAULT now()).
-- [HARD] 본 파일은 DRY-RUN(ROLLBACK)로만 검증. 실제 COMMIT=인간 승인.
-- 적재: PRF_PBK_PAGEBAND 1 / COMP 2 / formula_components 2 / component_prices 22 / binding 4 = 31행
-- 제본비 component_prices·엽서북·떡메 = 이미 라이브 적재됨(대상 아님).
-- =====================================================================
BEGIN;

-- ---- 단계 1a: t_prc_price_formulas (PK frm_cd → ON CONFLICT DO NOTHING) ----
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn)
VALUES ('PRF_PBK_PAGEBAND', '포토북 page-band 합산형(기본가24P+추가2P당)', 'FRM_TYPE.01', '합산형: 판매가=기본가(24P)+ceil((pages-24)/2)*추가2P단가. page count multiply는 앱 런타임(DB=lookup only).', 'Y')
ON CONFLICT (frm_cd) DO NOTHING;

-- ---- 단계 1b: t_prc_price_components (PK comp_cd → ON CONFLICT DO NOTHING) ----
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PBK_BASE24P', '포토북 기본가(완제품가, ≤24P) [COMP_PBK_BASE24P]', 'PRC_COMPONENT_TYPE.06', '사이즈(siz)×표지(mat) 기본단가 @ 24P. 통가격(완제품비).', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;
INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn)
VALUES ('COMP_PBK_ADD2P', '포토북 추가2P당 증분단가 [COMP_PBK_ADD2P]', 'PRC_COMPONENT_TYPE.06', '사이즈×표지 추가 2페이지당 증분. 곱셈계수 ceil((pages-24)/2)는 앱 적용(DB=단위단가 lookup).', 'Y')
ON CONFLICT (comp_cd) DO NOTHING;

-- ---- 단계 2a: t_prc_formula_components (PK (frm_cd,comp_cd) → ON CONFLICT DO NOTHING) ----
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PBK_PAGEBAND', 'COMP_PBK_BASE24P', 1, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn)
VALUES ('PRF_PBK_PAGEBAND', 'COMP_PBK_ADD2P', 2, 'Y')
ON CONFLICT (frm_cd, comp_cd) DO NOTHING;

-- ---- 단계 2b: t_prc_component_prices ----
-- 멱등 가드 = INSERT … SELECT … WHERE NOT EXISTS (자연키8 IS NOT DISTINCT FROM).
--   사유: 자연키 UNIQUE는 NULLS DISTINCT(indnullsnotdistinct=f) → NULL 포함행은 ON CONFLICT
--   미발화. clr/coat/bdl/min_qty=NULL이므로 IS NOT DISTINCT FROM 가드로 재실행 0행 보장(R1).
-- src: t_prc_component_prices.csv:2  COMP_PBK_BASE24P SIZ_000269 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000005', NULL, NULL, NULL, 15000, '포토북 8 x 8 (200 x 200 mm) 하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:3  COMP_PBK_ADD2P SIZ_000269 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000005', NULL, NULL, NULL, 500, '포토북 8 x 8 (200 x 200 mm) 하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:4  COMP_PBK_BASE24P SIZ_000269 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000006', NULL, NULL, NULL, 23000, '포토북 8 x 8 (200 x 200 mm) 레더하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:5  COMP_PBK_ADD2P SIZ_000269 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000006', NULL, NULL, NULL, 500, '포토북 8 x 8 (200 x 200 mm) 레더하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:6  COMP_PBK_BASE24P SIZ_000269 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000007', NULL, NULL, NULL, 12000, '포토북 8 x 8 (200 x 200 mm) 소프트커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:7  COMP_PBK_ADD2P SIZ_000269 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000269', NULL, 'MAT_000007', NULL, NULL, NULL, 500, '포토북 8 x 8 (200 x 200 mm) 소프트커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000269' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:8  COMP_PBK_BASE24P SIZ_000274 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000274', NULL, 'MAT_000005', NULL, NULL, NULL, 22000, '포토북 10 x 10 (250 x 250 mm) 하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000274' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:9  COMP_PBK_ADD2P SIZ_000274 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000274', NULL, 'MAT_000005', NULL, NULL, NULL, 1000, '포토북 10 x 10 (250 x 250 mm) 하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000274' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:10  COMP_PBK_BASE24P SIZ_000274 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000274', NULL, 'MAT_000006', NULL, NULL, NULL, 32000, '포토북 10 x 10 (250 x 250 mm) 레더하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000274' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:11  COMP_PBK_ADD2P SIZ_000274 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000274', NULL, 'MAT_000006', NULL, NULL, NULL, 1000, '포토북 10 x 10 (250 x 250 mm) 레더하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000274' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:12  COMP_PBK_BASE24P SIZ_000170 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000005', NULL, NULL, NULL, 12000, '포토북 A5 (148 x 210 mm) 하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:13  COMP_PBK_ADD2P SIZ_000170 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000005', NULL, NULL, NULL, 300, '포토북 A5 (148 x 210 mm) 하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:14  COMP_PBK_BASE24P SIZ_000170 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000006', NULL, NULL, NULL, 19000, '포토북 A5 (148 x 210 mm) 레더하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:15  COMP_PBK_ADD2P SIZ_000170 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000006', NULL, NULL, NULL, 300, '포토북 A5 (148 x 210 mm) 레더하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:16  COMP_PBK_BASE24P SIZ_000170 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000007', NULL, NULL, NULL, 10000, '포토북 A5 (148 x 210 mm) 소프트커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:17  COMP_PBK_ADD2P SIZ_000170 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000170', NULL, 'MAT_000007', NULL, NULL, NULL, 300, '포토북 A5 (148 x 210 mm) 소프트커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000170' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:18  COMP_PBK_BASE24P SIZ_000172 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000005', NULL, NULL, NULL, 16000, '포토북 A4 (210 x 297 mm) 하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:19  COMP_PBK_ADD2P SIZ_000172 MAT_000005
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000005', NULL, NULL, NULL, 600, '포토북 A4 (210 x 297 mm) 하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000005' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:20  COMP_PBK_BASE24P SIZ_000172 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000006', NULL, NULL, NULL, 26000, '포토북 A4 (210 x 297 mm) 레더하드커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:21  COMP_PBK_ADD2P SIZ_000172 MAT_000006
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000006', NULL, NULL, NULL, 600, '포토북 A4 (210 x 297 mm) 레더하드커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000006' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:22  COMP_PBK_BASE24P SIZ_000172 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_BASE24P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000007', NULL, NULL, NULL, 13000, '포토북 A4 (210 x 297 mm) 소프트커버 기본가(24P)'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_BASE24P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);
-- src: t_prc_component_prices.csv:23  COMP_PBK_ADD2P SIZ_000172 MAT_000007
INSERT INTO t_prc_component_prices
  (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note)
SELECT 'COMP_PBK_ADD2P', '2026-06-01', 'SIZ_000172', NULL, 'MAT_000007', NULL, NULL, NULL, 600, '포토북 A4 (210 x 297 mm) 소프트커버 추가2P당'
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices WHERE
    comp_cd IS NOT DISTINCT FROM 'COMP_PBK_ADD2P' AND apply_ymd IS NOT DISTINCT FROM '2026-06-01' AND siz_cd IS NOT DISTINCT FROM 'SIZ_000172' AND clr_cd IS NOT DISTINCT FROM NULL AND mat_cd IS NOT DISTINCT FROM 'MAT_000007' AND coat_side_cnt IS NOT DISTINCT FROM NULL AND bdl_qty IS NOT DISTINCT FROM NULL AND min_qty IS NOT DISTINCT FROM NULL
);

-- ---- 단계 3: t_prd_product_price_formulas (PK (prd_cd,frm_cd) → ON CONFLICT DO NOTHING) ----
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000072', 'PRF_BIND_SUM', '2026-06-01', '하드커버책자→제본 구성요소(하드커버무선=COMP_BIND_HC_MUSEON, proc PROC_000023)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000077', 'PRF_BIND_SUM', '2026-06-01', '레더 하드커버책자→제본 구성요소(하드커버무선=COMP_BIND_HC_MUSEON, proc PROC_000023)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000082', 'PRF_BIND_SUM', '2026-06-01', '하드커버 링책자→제본 구성요소(하드커버트윈링=COMP_BIND_HC_TWINRING, proc PROC_000024)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;
INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note)
VALUES ('PRD_000100', 'PRF_PBK_PAGEBAND', '2026-06-01', '포토북→page-band 합산형(기본가24P+추가2P당)')
ON CONFLICT (prd_cd, frm_cd) DO NOTHING;

-- [HARD] DRY-RUN: ROLLBACK. 실제 적재 시 인간 승인 후 ROLLBACK→COMMIT 교체.
ROLLBACK;
