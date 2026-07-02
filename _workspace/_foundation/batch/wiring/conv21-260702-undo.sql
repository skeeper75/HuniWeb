-- conv21 교정 undo — 2026-07-02 (backup=conv21-backup-260702.txt)
BEGIN;
-- ① 삭제오염 복원 되돌림
UPDATE t_prc_price_components SET del_yn='Y', del_dt='2026-06-17 15:31:27.294557', upd_dt=now()
WHERE comp_cd='COMP_BIND_HC_TWINRING';
-- ② 110 base proc 제거
DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000110' AND proc_cd='PROC_000004';
-- ③ 020 인쇄옵션 제거
DELETE FROM t_prd_product_print_options WHERE prd_cd='PRD_000020' AND print_opt_cd IN ('POPT_000001','POPT_000002');
-- ④ 고아 은퇴 복귀 (note 부착분은 잔존·가격 무영향)
UPDATE t_prc_price_components SET use_yn='Y', upd_dt=now()
WHERE comp_cd IN ('COMP_FOLD_CARD_3H','COMP_POSTER_FOAMBOARD_BLACK','COMP_POSTER_FOAMBOARD_WHITE');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt, upd_dt)
SELECT 'PRF_POSTER_FOAMBOARD','COMP_POSTER_FOAMBOARD_WHITE',1,'Y','2026-06-17 13:00:58.993206','2026-06-18 20:31:50.050932'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOAMBOARD' AND comp_cd='COMP_POSTER_FOAMBOARD_WHITE');
-- ⑤ 포맥스 BOARD 확장 철회
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_BOARD';
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_FOMEXBOARD_BOARD';
DELETE FROM t_prc_price_components WHERE comp_cd='COMP_POSTER_FOMEXBOARD_BOARD';
DELETE FROM t_prd_product_materials WHERE prd_cd='PRD_000130' AND mat_cd IN ('MAT_000022','MAT_000554','MAT_000023','MAT_000555');
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt, upd_dt)
SELECT 'PRF_POSTER_FOMEXBOARD','COMP_POSTER_FOMEXBOARD_WHITE3MM',1,'Y','2026-06-17 13:00:58.993206','2026-06-18 20:31:38.267558'
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_FOMEXBOARD' AND comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM');
UPDATE t_prc_price_components SET use_yn='Y', upd_dt=now()
WHERE comp_cd IN ('COMP_POSTER_FOMEXBOARD_WHITE3MM','COMP_POSTER_FOMEXBOARD_WHITE5MM');
COMMIT;
