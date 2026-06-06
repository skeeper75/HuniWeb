-- 09b_correction_bundle_qtys.sql
-- 단계09b 정정(보완) 묶음수 — Jun-4 SIZE_NAME_NOISE 정정 GO 적재본 18행 9상품.
-- round-5 _exec 미통합 고아 적재본을 멱등 통합. PK t_prd_product_bundle_qtys_pkey(prd_cd, bdl_qty).
-- 출처: 02_mapping/correction/load/t_prd_product_bundle_qtys.csv (검증 GO — correction-validation-report.md §3).
-- FK 검증 완료(read-only): prd_cd 9/9·QTY_UNIT .01/.02/.04 실존. PRD_000001/50·PRD_000002/50 선존→DO NOTHING no-op.
-- 생성: gen_correction_bundle_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: correction/load/t_prd_product_bundle_qtys.csv:row2 PRD_000001/bdl50
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000001', 50, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row3 PRD_000002/bdl50
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000002', 50, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row4 PRD_000002/bdl20
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000002', 20, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row5 PRD_000003/bdl20
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000003', 20, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row6 PRD_000003/bdl40
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000003', 40, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row7 PRD_000003/bdl100
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000003', 100, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row8 PRD_000003/bdl30
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000003', 30, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row9 PRD_000004/bdl10
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000004', 10, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row10 PRD_000005/bdl10
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000005', 10, 'QTY_UNIT.02', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row11 PRD_000009/bdl10
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000009', 10, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row12 PRD_000011/bdl20
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000011', 20, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row13 PRD_000066/bdl8
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000066', 8, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row14 PRD_000066/bdl6
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000066', 6, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row15 PRD_000066/bdl3
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000066', 3, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row16 PRD_000066/bdl2
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000066', 2, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row17 PRD_000066/bdl1
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000066', 1, 'QTY_UNIT.01', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row18 PRD_000198/bdl1
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000198', 1, 'QTY_UNIT.04', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
-- src: correction/load/t_prd_product_bundle_qtys.csv:row19 PRD_000198/bdl2
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000198', 2, 'QTY_UNIT.04', 'N', NULL, DEFAULT, NULL)
ON CONFLICT (prd_cd, bdl_qty) DO NOTHING;
