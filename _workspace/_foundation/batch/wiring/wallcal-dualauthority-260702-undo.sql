-- UNDO: 벽걸이캘린더(111/112) 제본 이중권위 통일 되돌리기(캘린더전용→범용 트윈링).
BEGIN;
UPDATE t_prc_formula_components SET comp_cd='COMP_BIND_TWINRING'
 WHERE frm_cd='PRF_DGP_CAL_WIDE' AND comp_cd='COMP_BIND_CAL_WALL';
UPDATE t_prd_product_processes SET proc_cd='PROC_000021'
 WHERE prd_cd IN ('PRD_000111','PRD_000112') AND proc_cd='PROC_000099';
COMMIT;
