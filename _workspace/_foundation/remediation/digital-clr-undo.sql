-- UNDO: 디지털 흑백/칼라 교정 복원 (260626)
-- 복원 절차: 교정행 삭제 후 백업 재적재
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1';
\copy t_prc_component_prices(comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty,unit_price,note,proc_cd,opt_cd,dim_vals,print_opt_cd,plt_siz_cd,siz_width,siz_height) FROM '_workspace/_foundation/remediation/digital-clr-backup-s1.csv' CSV HEADER
-- 검증 후 COMMIT;
