-- 034 펄명함 정상화 원복 (2026-06-30)
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_NAMECARD_PEARL%';
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (3338,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000127','POPT_000001',100,9000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (3339,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000130','POPT_000001',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (3340,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000127','POPT_000002',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (3341,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000130','POPT_000002',100,11000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38910,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000240','POPT_000001',100,9000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38911,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000128','POPT_000001',100,9000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38912,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000129','POPT_000001',100,9000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38913,'COMP_NAMECARD_PEARL_S1','2026-06-01','MAT_000241','POPT_000001',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38914,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000240','POPT_000002',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38915,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000128','POPT_000002',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38916,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000129','POPT_000002',100,10000.00);
INSERT INTO t_prc_component_prices (comp_price_id,comp_cd,apply_ymd,mat_cd,print_opt_cd,min_qty,unit_price) VALUES (38917,'COMP_NAMECARD_PEARL_S2','2026-06-01','MAT_000241','POPT_000002',100,11000.00);
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000034' AND mat_cd IN ('MAT_000352','MAT_000358','MAT_000359','MAT_000360');
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now() WHERE prd_cd='PRD_000034' AND mat_cd IN ('MAT_000128','MAT_000129','MAT_000240','MAT_000241');
COMMIT;
