-- 040 빌드 원복 (2026-06-30)
BEGIN;
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000040' AND frm_cd='PRF_DGP_A';
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000040' AND proc_cd IN ('PROC_000008','PROC_000009');
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000040' AND mat_cd IN ('MAT_000361','MAT_000362','MAT_000363','MAT_000364','MAT_000365');
UPDATE t_prd_product_materials SET del_yn='N', del_dt=NULL, upd_dt=now() WHERE prd_cd='PRD_000040' AND mat_cd IN ('MAT_000138','MAT_000139','MAT_000140','MAT_000141');
COMMIT;
