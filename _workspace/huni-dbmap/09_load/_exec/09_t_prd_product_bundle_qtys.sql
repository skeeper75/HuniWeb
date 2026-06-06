-- 09_t_prd_product_bundle_qtys.sql
-- 단계09 상품-묶음수 — PK t_prd_product_bundle_qtys_pkey(prd_cd, bdl_qty).
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: 09_t_prd_product_bundle_qtys.csv:row2 PRD_000160/bdl2
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 2, 'QTY_UNIT.01', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: 09_t_prd_product_bundle_qtys.csv:row3 PRD_000160/bdl3
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 3, 'QTY_UNIT.01', 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: 09_t_prd_product_bundle_qtys.csv:row4 PRD_000160/bdl4
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 4, 'QTY_UNIT.01', 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: 09_t_prd_product_bundle_qtys.csv:row5 PRD_000160/bdl5
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 5, 'QTY_UNIT.01', 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: 09_t_prd_product_bundle_qtys.csv:row6 PRD_000160/bdl6
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000160', 6, 'QTY_UNIT.01', 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: 09_t_prd_product_bundle_qtys.csv:row7 PRD_000163/bdl10
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000163', 10, 'QTY_UNIT.01', 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
