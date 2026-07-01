-- jibbitz-tbd-cleanup-undo.sql — 정리 되돌리기(배선 복원·공식 재활성)
BEGIN;
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
VALUES ('PRF_ACRYL_ZIBITZ_TBD','COMP_ACRYL_PENDING_TBD',1,'N',now()) ON CONFLICT (frm_cd, comp_cd) DO NOTHING;
UPDATE t_prc_price_formulas SET use_yn='Y', upd_dt=now() WHERE frm_cd='PRF_ACRYL_ZIBITZ_TBD';
COMMIT;
