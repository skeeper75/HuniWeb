-- 05_t_prd_product_materials.sql
-- 단계05 상품-자재 — PK t_prd_product_materials_pkey(prd_cd, mat_cd, usage_cd).
-- 생성: gen_load_sql.py (손편집 금지). BEGIN/COMMIT 미포함 — apply.sql 가 래핑.

-- src: 05_t_prd_product_materials.csv:row2 PRD_000016/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row3 PRD_000016/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000082', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row4 PRD_000016/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000092', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row5 PRD_000016/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000101', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row6 PRD_000016/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000109', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row7 PRD_000016/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000113', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row8 PRD_000016/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000114', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row9 PRD_000016/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000115', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row10 PRD_000016/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000116', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row11 PRD_000016/MAT_000117/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000117', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row12 PRD_000016/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000118', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row13 PRD_000016/MAT_000120/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000120', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row14 PRD_000016/MAT_000121/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000121', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row15 PRD_000016/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000123', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row16 PRD_000016/MAT_000124/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000124', 'USAGE.07', NULL, 'N', 15, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row17 PRD_000016/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000125', 'USAGE.07', NULL, 'N', 16, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row18 PRD_000016/MAT_000126/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000126', 'USAGE.07', NULL, 'N', 17, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row19 PRD_000016/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000127', 'USAGE.07', NULL, 'N', 18, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row20 PRD_000016/MAT_000128/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000128', 'USAGE.07', NULL, 'N', 19, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row21 PRD_000016/MAT_000129/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000129', 'USAGE.07', NULL, 'N', 20, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row22 PRD_000016/MAT_000130/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000016', 'MAT_000130', 'USAGE.07', NULL, 'N', 21, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row23 PRD_000018/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row24 PRD_000018/MAT_000080/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000080', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row25 PRD_000018/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000081', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row26 PRD_000018/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000082', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row27 PRD_000018/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000090', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row28 PRD_000018/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000091', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row29 PRD_000018/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000018', 'MAT_000092', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row30 PRD_000027/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row31 PRD_000027/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000081', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row32 PRD_000027/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000082', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row33 PRD_000027/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000091', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row34 PRD_000027/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000092', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row35 PRD_000027/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000101', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row36 PRD_000027/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000108', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row37 PRD_000027/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000109', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row38 PRD_000027/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000113', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row39 PRD_000027/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000114', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row40 PRD_000027/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000115', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row41 PRD_000027/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000116', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row42 PRD_000027/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000123', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row43 PRD_000027/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000027', 'MAT_000125', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row44 PRD_000028/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row45 PRD_000028/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000081', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row46 PRD_000028/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000082', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row47 PRD_000028/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000091', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row48 PRD_000028/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000092', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row49 PRD_000028/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000101', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row50 PRD_000028/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000108', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row51 PRD_000028/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000109', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row52 PRD_000028/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000113', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row53 PRD_000028/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000114', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row54 PRD_000028/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000115', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row55 PRD_000028/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000116', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row56 PRD_000028/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000123', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row57 PRD_000028/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000028', 'MAT_000125', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row58 PRD_000029/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row59 PRD_000029/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000081', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row60 PRD_000029/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000082', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row61 PRD_000029/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000091', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row62 PRD_000029/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000092', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row63 PRD_000029/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000101', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row64 PRD_000029/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000108', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row65 PRD_000029/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000109', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row66 PRD_000029/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000113', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row67 PRD_000029/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000114', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row68 PRD_000029/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000115', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row69 PRD_000029/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000116', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row70 PRD_000029/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000123', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row71 PRD_000029/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000029', 'MAT_000125', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row72 PRD_000031/MAT_000099/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000099', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row73 PRD_000031/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000101', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row74 PRD_000031/MAT_000102/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000102', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row75 PRD_000031/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000108', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row76 PRD_000031/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000109', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row77 PRD_000031/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000113', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row78 PRD_000031/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000114', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row79 PRD_000031/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000115', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row80 PRD_000031/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000116', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row81 PRD_000031/MAT_000117/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000117', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row82 PRD_000031/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000118', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row83 PRD_000031/MAT_000119/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000119', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row84 PRD_000031/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000123', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row85 PRD_000031/MAT_000124/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000124', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row86 PRD_000031/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000125', 'USAGE.07', NULL, 'N', 15, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row87 PRD_000031/MAT_000126/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000031', 'MAT_000126', 'USAGE.07', NULL, 'N', 16, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row88 PRD_000047/MAT_000072/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000072', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row89 PRD_000047/MAT_000073/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000073', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row90 PRD_000047/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000074', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row91 PRD_000047/MAT_000076/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000076', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row92 PRD_000047/MAT_000077/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000077', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row93 PRD_000047/MAT_000078/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000078', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row94 PRD_000047/MAT_000079/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000079', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row95 PRD_000047/MAT_000080/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000080', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row96 PRD_000047/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000081', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row97 PRD_000047/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000082', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row98 PRD_000047/MAT_000086/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000086', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row99 PRD_000047/MAT_000087/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000087', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row100 PRD_000047/MAT_000088/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000088', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row101 PRD_000047/MAT_000089/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000089', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row102 PRD_000047/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000090', 'USAGE.07', NULL, 'N', 15, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row103 PRD_000047/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000091', 'USAGE.07', NULL, 'N', 16, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row104 PRD_000047/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000092', 'USAGE.07', NULL, 'N', 17, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row105 PRD_000047/MAT_000095/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000095', 'USAGE.07', NULL, 'N', 18, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row106 PRD_000047/MAT_000096/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000096', 'USAGE.07', NULL, 'N', 19, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row107 PRD_000047/MAT_000097/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000097', 'USAGE.07', NULL, 'N', 20, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row108 PRD_000047/MAT_000098/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000098', 'USAGE.07', NULL, 'N', 21, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row109 PRD_000047/MAT_000099/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000099', 'USAGE.07', NULL, 'N', 22, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row110 PRD_000047/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000101', 'USAGE.07', NULL, 'N', 23, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row111 PRD_000047/MAT_000102/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000102', 'USAGE.07', NULL, 'N', 24, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row112 PRD_000047/MAT_000104/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000104', 'USAGE.07', NULL, 'N', 25, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row113 PRD_000047/MAT_000105/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000105', 'USAGE.07', NULL, 'N', 26, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row114 PRD_000047/MAT_000106/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000106', 'USAGE.07', NULL, 'N', 27, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row115 PRD_000047/MAT_000107/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000107', 'USAGE.07', NULL, 'N', 28, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row116 PRD_000047/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000108', 'USAGE.07', NULL, 'N', 29, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row117 PRD_000047/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000109', 'USAGE.07', NULL, 'N', 30, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row118 PRD_000047/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000113', 'USAGE.07', NULL, 'N', 31, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row119 PRD_000047/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000114', 'USAGE.07', NULL, 'N', 32, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row120 PRD_000047/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000115', 'USAGE.07', NULL, 'N', 33, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row121 PRD_000047/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000116', 'USAGE.07', NULL, 'N', 34, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row122 PRD_000047/MAT_000117/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000117', 'USAGE.07', NULL, 'N', 35, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row123 PRD_000047/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000118', 'USAGE.07', NULL, 'N', 36, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row124 PRD_000047/MAT_000119/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000119', 'USAGE.07', NULL, 'N', 37, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row125 PRD_000047/MAT_000120/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000120', 'USAGE.07', NULL, 'N', 38, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row126 PRD_000047/MAT_000121/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000121', 'USAGE.07', NULL, 'N', 39, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row127 PRD_000047/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000123', 'USAGE.07', NULL, 'N', 40, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row128 PRD_000047/MAT_000124/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000124', 'USAGE.07', NULL, 'N', 41, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row129 PRD_000047/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000125', 'USAGE.07', NULL, 'N', 42, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row130 PRD_000047/MAT_000126/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000126', 'USAGE.07', NULL, 'N', 43, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row131 PRD_000047/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000127', 'USAGE.07', NULL, 'N', 44, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row132 PRD_000047/MAT_000128/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000128', 'USAGE.07', NULL, 'N', 45, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row133 PRD_000047/MAT_000129/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000129', 'USAGE.07', NULL, 'N', 46, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row134 PRD_000047/MAT_000130/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000047', 'MAT_000130', 'USAGE.07', NULL, 'N', 47, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row135 PRD_000048/MAT_000072/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000072', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row136 PRD_000048/MAT_000073/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000073', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row137 PRD_000048/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000074', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row138 PRD_000048/MAT_000076/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000076', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row139 PRD_000048/MAT_000077/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000077', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row140 PRD_000048/MAT_000078/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000078', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row141 PRD_000048/MAT_000079/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000079', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row142 PRD_000048/MAT_000080/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000080', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row143 PRD_000048/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000081', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row144 PRD_000048/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000082', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row145 PRD_000048/MAT_000086/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000086', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row146 PRD_000048/MAT_000087/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000087', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row147 PRD_000048/MAT_000088/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000088', 'USAGE.07', NULL, 'N', 13, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row148 PRD_000048/MAT_000089/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000089', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row149 PRD_000048/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000090', 'USAGE.07', NULL, 'N', 15, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row150 PRD_000048/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000091', 'USAGE.07', NULL, 'N', 16, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row151 PRD_000048/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000092', 'USAGE.07', NULL, 'N', 17, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row152 PRD_000048/MAT_000095/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000095', 'USAGE.07', NULL, 'N', 18, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row153 PRD_000048/MAT_000096/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000096', 'USAGE.07', NULL, 'N', 19, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row154 PRD_000048/MAT_000097/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000097', 'USAGE.07', NULL, 'N', 20, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row155 PRD_000048/MAT_000098/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000098', 'USAGE.07', NULL, 'N', 21, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row156 PRD_000048/MAT_000099/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000099', 'USAGE.07', NULL, 'N', 22, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row157 PRD_000048/MAT_000101/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000101', 'USAGE.07', NULL, 'N', 23, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row158 PRD_000048/MAT_000102/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000102', 'USAGE.07', NULL, 'N', 24, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row159 PRD_000048/MAT_000104/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000104', 'USAGE.07', NULL, 'N', 25, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row160 PRD_000048/MAT_000105/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000105', 'USAGE.07', NULL, 'N', 26, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row161 PRD_000048/MAT_000106/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000106', 'USAGE.07', NULL, 'N', 27, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row162 PRD_000048/MAT_000107/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000107', 'USAGE.07', NULL, 'N', 28, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row163 PRD_000048/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000108', 'USAGE.07', NULL, 'N', 29, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row164 PRD_000048/MAT_000109/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000109', 'USAGE.07', NULL, 'N', 30, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row165 PRD_000048/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000113', 'USAGE.07', NULL, 'N', 31, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row166 PRD_000048/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000114', 'USAGE.07', NULL, 'N', 32, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row167 PRD_000048/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000115', 'USAGE.07', NULL, 'N', 33, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row168 PRD_000048/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000116', 'USAGE.07', NULL, 'N', 34, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row169 PRD_000048/MAT_000117/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000117', 'USAGE.07', NULL, 'N', 35, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row170 PRD_000048/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000118', 'USAGE.07', NULL, 'N', 36, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row171 PRD_000048/MAT_000119/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000119', 'USAGE.07', NULL, 'N', 37, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row172 PRD_000048/MAT_000120/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000120', 'USAGE.07', NULL, 'N', 38, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row173 PRD_000048/MAT_000121/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000121', 'USAGE.07', NULL, 'N', 39, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row174 PRD_000048/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000123', 'USAGE.07', NULL, 'N', 40, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row175 PRD_000048/MAT_000124/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000124', 'USAGE.07', NULL, 'N', 41, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row176 PRD_000048/MAT_000125/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000125', 'USAGE.07', NULL, 'N', 42, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row177 PRD_000048/MAT_000126/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000126', 'USAGE.07', NULL, 'N', 43, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row178 PRD_000048/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000127', 'USAGE.07', NULL, 'N', 44, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row179 PRD_000048/MAT_000128/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000128', 'USAGE.07', NULL, 'N', 45, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row180 PRD_000048/MAT_000129/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000129', 'USAGE.07', NULL, 'N', 46, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row181 PRD_000048/MAT_000130/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000048', 'MAT_000130', 'USAGE.07', NULL, 'N', 47, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row182 PRD_000068/MAT_000073/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000073', 'USAGE.01', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row183 PRD_000068/MAT_000077/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000077', 'USAGE.01', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row184 PRD_000068/MAT_000078/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000078', 'USAGE.01', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row185 PRD_000068/MAT_000079/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000079', 'USAGE.01', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row186 PRD_000068/MAT_000080/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000080', 'USAGE.01', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row187 PRD_000068/MAT_000087/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000087', 'USAGE.01', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row188 PRD_000068/MAT_000088/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000088', 'USAGE.01', NULL, 'N', 7, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row189 PRD_000068/MAT_000089/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000089', 'USAGE.01', NULL, 'N', 8, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row190 PRD_000068/MAT_000090/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000090', 'USAGE.01', NULL, 'N', 9, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row191 PRD_000068/MAT_000104/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000104', 'USAGE.01', NULL, 'N', 10, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row192 PRD_000068/MAT_000105/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000105', 'USAGE.01', NULL, 'N', 11, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row193 PRD_000068/MAT_000106/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000106', 'USAGE.01', NULL, 'N', 12, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row194 PRD_000068/MAT_000107/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000107', 'USAGE.01', NULL, 'N', 13, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row195 PRD_000068/MAT_000073/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000073', 'USAGE.02', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row196 PRD_000068/MAT_000077/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000077', 'USAGE.02', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row197 PRD_000068/MAT_000078/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000078', 'USAGE.02', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row198 PRD_000068/MAT_000079/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000079', 'USAGE.02', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row199 PRD_000068/MAT_000080/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000080', 'USAGE.02', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row200 PRD_000068/MAT_000087/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000087', 'USAGE.02', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row201 PRD_000068/MAT_000088/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000088', 'USAGE.02', NULL, 'N', 7, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row202 PRD_000068/MAT_000089/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000089', 'USAGE.02', NULL, 'N', 8, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row203 PRD_000068/MAT_000090/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000090', 'USAGE.02', NULL, 'N', 9, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row204 PRD_000068/MAT_000104/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000104', 'USAGE.02', NULL, 'N', 10, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row205 PRD_000068/MAT_000105/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000105', 'USAGE.02', NULL, 'N', 11, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row206 PRD_000068/MAT_000106/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000106', 'USAGE.02', NULL, 'N', 12, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row207 PRD_000068/MAT_000107/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000068', 'MAT_000107', 'USAGE.02', NULL, 'N', 13, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row208 PRD_000069/MAT_000073/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000073', 'USAGE.01', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row209 PRD_000069/MAT_000077/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000077', 'USAGE.01', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row210 PRD_000069/MAT_000087/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000087', 'USAGE.01', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row211 PRD_000069/MAT_000095/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000095', 'USAGE.01', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row212 PRD_000069/MAT_000096/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000096', 'USAGE.01', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row213 PRD_000069/MAT_000104/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000104', 'USAGE.01', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row214 PRD_000069/MAT_000105/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000105', 'USAGE.01', NULL, 'N', 7, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row215 PRD_000069/MAT_000074/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000074', 'USAGE.02', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row216 PRD_000069/MAT_000081/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000081', 'USAGE.02', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row217 PRD_000069/MAT_000082/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000082', 'USAGE.02', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row218 PRD_000069/MAT_000091/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000091', 'USAGE.02', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row219 PRD_000069/MAT_000092/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000092', 'USAGE.02', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row220 PRD_000069/MAT_000109/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000069', 'MAT_000109', 'USAGE.02', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row221 PRD_000071/MAT_000072/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000072', 'USAGE.01', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row222 PRD_000071/MAT_000073/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000073', 'USAGE.01', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row223 PRD_000071/MAT_000076/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000076', 'USAGE.01', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row224 PRD_000071/MAT_000077/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000077', 'USAGE.01', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row225 PRD_000071/MAT_000078/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000078', 'USAGE.01', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row226 PRD_000071/MAT_000079/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000079', 'USAGE.01', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row227 PRD_000071/MAT_000086/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000086', 'USAGE.01', NULL, 'N', 7, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row228 PRD_000071/MAT_000087/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000087', 'USAGE.01', NULL, 'N', 8, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row229 PRD_000071/MAT_000088/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000088', 'USAGE.01', NULL, 'N', 9, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row230 PRD_000071/MAT_000089/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000089', 'USAGE.01', NULL, 'N', 10, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row231 PRD_000071/MAT_000095/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000095', 'USAGE.01', NULL, 'N', 11, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row232 PRD_000071/MAT_000096/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000096', 'USAGE.01', NULL, 'N', 12, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row233 PRD_000071/MAT_000097/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000097', 'USAGE.01', NULL, 'N', 13, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row234 PRD_000071/MAT_000104/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000104', 'USAGE.01', NULL, 'N', 14, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row235 PRD_000071/MAT_000105/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000105', 'USAGE.01', NULL, 'N', 15, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row236 PRD_000071/MAT_000106/USAGE.01
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000106', 'USAGE.01', NULL, 'N', 16, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row237 PRD_000071/MAT_000072/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000072', 'USAGE.02', NULL, 'Y', 1, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row238 PRD_000071/MAT_000073/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000073', 'USAGE.02', NULL, 'N', 2, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row239 PRD_000071/MAT_000074/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000074', 'USAGE.02', NULL, 'N', 3, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row240 PRD_000071/MAT_000076/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000076', 'USAGE.02', NULL, 'N', 4, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row241 PRD_000071/MAT_000077/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000077', 'USAGE.02', NULL, 'N', 5, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row242 PRD_000071/MAT_000078/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000078', 'USAGE.02', NULL, 'N', 6, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row243 PRD_000071/MAT_000079/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000079', 'USAGE.02', NULL, 'N', 7, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row244 PRD_000071/MAT_000080/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000080', 'USAGE.02', NULL, 'N', 8, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row245 PRD_000071/MAT_000081/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000081', 'USAGE.02', NULL, 'N', 9, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row246 PRD_000071/MAT_000082/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000082', 'USAGE.02', NULL, 'N', 10, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row247 PRD_000071/MAT_000086/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000086', 'USAGE.02', NULL, 'N', 11, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row248 PRD_000071/MAT_000087/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000087', 'USAGE.02', NULL, 'N', 12, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row249 PRD_000071/MAT_000088/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000088', 'USAGE.02', NULL, 'N', 13, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row250 PRD_000071/MAT_000089/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000089', 'USAGE.02', NULL, 'N', 14, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row251 PRD_000071/MAT_000090/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000090', 'USAGE.02', NULL, 'N', 15, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row252 PRD_000071/MAT_000091/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000091', 'USAGE.02', NULL, 'N', 16, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row253 PRD_000071/MAT_000092/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000092', 'USAGE.02', NULL, 'N', 17, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row254 PRD_000071/MAT_000095/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000095', 'USAGE.02', NULL, 'N', 18, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row255 PRD_000071/MAT_000096/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000096', 'USAGE.02', NULL, 'N', 19, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row256 PRD_000071/MAT_000097/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000097', 'USAGE.02', NULL, 'N', 20, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row257 PRD_000071/MAT_000098/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000098', 'USAGE.02', NULL, 'N', 21, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row258 PRD_000071/MAT_000099/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000099', 'USAGE.02', NULL, 'N', 22, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row259 PRD_000071/MAT_000104/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000104', 'USAGE.02', NULL, 'N', 23, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row260 PRD_000071/MAT_000105/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000105', 'USAGE.02', NULL, 'N', 24, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row261 PRD_000071/MAT_000106/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000106', 'USAGE.02', NULL, 'N', 25, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row262 PRD_000071/MAT_000107/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000107', 'USAGE.02', NULL, 'N', 26, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row263 PRD_000071/MAT_000108/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000108', 'USAGE.02', NULL, 'N', 27, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row264 PRD_000071/MAT_000109/USAGE.02
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000071', 'MAT_000109', 'USAGE.02', NULL, 'N', 28, DEFAULT, NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row265 PRD_000108/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000090', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row266 PRD_000108/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000113', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row267 PRD_000108/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000114', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row268 PRD_000108/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000115', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row269 PRD_000108/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000116', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row270 PRD_000108/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000123', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row271 PRD_000108/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000108', 'MAT_000127', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row272 PRD_000109/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000090', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row273 PRD_000109/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000113', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row274 PRD_000109/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000114', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row275 PRD_000109/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000115', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row276 PRD_000109/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000116', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row277 PRD_000109/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000109', 'MAT_000127', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row278 PRD_000110/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000090', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row279 PRD_000110/MAT_000098/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000098', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row280 PRD_000110/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000113', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row281 PRD_000110/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000114', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row282 PRD_000110/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000115', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row283 PRD_000110/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000116', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row284 PRD_000110/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000118', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row285 PRD_000110/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000123', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row286 PRD_000110/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000110', 'MAT_000127', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row287 PRD_000111/MAT_000074/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000074', 'USAGE.07', NULL, 'Y', 1, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row288 PRD_000111/MAT_000079/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000079', 'USAGE.07', NULL, 'N', 2, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row289 PRD_000111/MAT_000080/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000080', 'USAGE.07', NULL, 'N', 3, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row290 PRD_000111/MAT_000081/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000081', 'USAGE.07', NULL, 'N', 4, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row291 PRD_000111/MAT_000082/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000082', 'USAGE.07', NULL, 'N', 5, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row292 PRD_000111/MAT_000089/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000089', 'USAGE.07', NULL, 'N', 6, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row293 PRD_000111/MAT_000090/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000090', 'USAGE.07', NULL, 'N', 7, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row294 PRD_000111/MAT_000091/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000091', 'USAGE.07', NULL, 'N', 8, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row295 PRD_000111/MAT_000092/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000092', 'USAGE.07', NULL, 'N', 9, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row296 PRD_000111/MAT_000097/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000097', 'USAGE.07', NULL, 'N', 10, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row297 PRD_000111/MAT_000098/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000098', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row298 PRD_000111/MAT_000099/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000099', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row299 PRD_000111/MAT_000108/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000108', 'USAGE.07', NULL, 'N', 14, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row300 PRD_000111/MAT_000113/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000113', 'USAGE.07', NULL, 'N', 15, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row301 PRD_000111/MAT_000114/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000114', 'USAGE.07', NULL, 'N', 16, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row302 PRD_000111/MAT_000115/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000115', 'USAGE.07', NULL, 'N', 17, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row303 PRD_000111/MAT_000116/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000116', 'USAGE.07', NULL, 'N', 18, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row304 PRD_000111/MAT_000118/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000118', 'USAGE.07', NULL, 'N', 19, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row305 PRD_000111/MAT_000119/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000119', 'USAGE.07', NULL, 'N', 20, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row306 PRD_000111/MAT_000123/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000123', 'USAGE.07', NULL, 'N', 21, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row307 PRD_000111/MAT_000127/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000111', 'MAT_000127', 'USAGE.07', NULL, 'N', 22, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row308 PRD_000146/MAT_000051/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000146', 'MAT_000051', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row309 PRD_000146/MAT_000052/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000146', 'MAT_000052', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row310 PRD_000148/MAT_000047/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000148', 'MAT_000047', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row311 PRD_000148/MAT_000048/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000148', 'MAT_000048', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row312 PRD_000149/MAT_000056/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000149', 'MAT_000056', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row313 PRD_000150/MAT_000054/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000150', 'MAT_000054', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row314 PRD_000150/MAT_000053/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000150', 'MAT_000053', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row315 PRD_000152/MAT_000046/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000152', 'MAT_000046', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row316 PRD_000152/MAT_000049/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000152', 'MAT_000049', 'USAGE.07', NULL, 'N', 12, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
-- src: 05_t_prd_product_materials.csv:row317 PRD_000154/MAT_000057/USAGE.07
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dep_proc_cd, dflt_yn, disp_seq, reg_dt, upd_dt)
VALUES ('PRD_000154', 'MAT_000057', 'USAGE.07', NULL, 'N', 11, '2026-06-05 00:00:00', NULL)
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
