-- =====================================================================
-- STEP 3: PRD_000066(합판도무송스티커) 원형 size link (t_prd_product_sizes)
--   11 행 = 신규 10(SIZ_000501~510) + 재사용 1(SIZ_000422, 원형35mm).
--   충돌키 = 라이브 PK (prd_cd, siz_cd) [t_prd_product_sizes_pkey, 03_pks.tsv 63-64 확인].
--   (MINT_NEEDED) → 실 siz_cd 치환. dflt_yn/disp_seq/reg_dt = BLOCKED CSV verbatim.
--   reg_dt = '2026-06-05 00:00:00'(실값) 명시 — 공란 아님이라 NOT NULL DEFAULT 위험 없음(round-5 교훈).
--   FK: prd_cd→t_prd_products(PRD_000066 실재), siz_cd→t_siz_sizes(STEP1 등록 + 422 재사용).
--   upd_dt/del_dt 미포함(NULL 허용), del_yn 미포함→DEFAULT 'N' 발화.
-- =====================================================================
-- 원형10mm size link — 신규 SIZ_000501 (직경 10mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000501', 'N', 27, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형15mm size link — 신규 SIZ_000502 (직경 15mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000502', 'N', 28, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형20mm size link — 신규 SIZ_000503 (직경 20mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000503', 'N', 29, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형25mm size link — 신규 SIZ_000504 (직경 25mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000504', 'N', 30, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형30mm size link — 신규 SIZ_000505 (직경 30mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000505', 'N', 31, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형35mm size link — SIZ_000422 재사용(committed) (직경 35mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000422', 'N', 32, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형40mm size link — 신규 SIZ_000506 (직경 40mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000506', 'N', 33, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형45mm size link — 신규 SIZ_000507 (직경 45mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000507', 'N', 34, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형50mm size link — 신규 SIZ_000508 (직경 50mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000508', 'N', 35, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형55mm size link — 신규 SIZ_000509 (직경 55mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000509', 'N', 36, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
-- 원형60mm size link — 신규 SIZ_000510 (직경 60mm)
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq, reg_dt) VALUES ('PRD_000066', 'SIZ_000510', 'N', 37, '2026-06-05 00:00:00') ON CONFLICT (prd_cd, siz_cd) DO NOTHING;
