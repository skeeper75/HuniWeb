-- =============================================================================
-- pcb30p-undo.sql  (롤백본 — pcb30p-fix.sql COMMIT 되돌리기)
-- 사전상태 복원: 30P 배선 제거·판별차원 NULL 환원·use_dims 원복·옵션그룹/값 삭제.
-- 원본 use_dims 백업 = pcb30p-usedims-backup-260701.tsv (20P=siz+min+print / 30P=siz+min)
-- ★물리 DELETE (신규 mint한 옵션그룹/값·배선행이라 논리삭제 아님 — 사전상태엔 아예 없었음).
-- =============================================================================
BEGIN;

-- [역순3] 배선 30P 제거
DELETE FROM t_prc_formula_components
 WHERE frm_cd='PRF_PCB_FIXED' AND comp_cd IN ('COMP_PCB_S1_30P','COMP_PCB_S2_30P');

-- [역순2b] use_dims 원복
UPDATE t_prc_price_components SET use_dims='["siz_cd", "min_qty", "print_opt_cd"]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P');
UPDATE t_prc_price_components SET use_dims='["siz_cd", "min_qty"]', upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_30P','COMP_PCB_S2_30P');

-- [역순2] 판별차원 NULL 환원 (fix가 채운 값만 되돌림)
UPDATE t_prc_component_prices SET opt_cd=NULL, upd_dt=now()
 WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P') AND opt_cd='OPV_000491';
UPDATE t_prc_component_prices SET opt_cd=NULL, print_opt_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_PCB_S1_30P' AND opt_cd='OPV_000492' AND print_opt_cd='POPT_000001';
UPDATE t_prc_component_prices SET opt_cd=NULL, print_opt_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_PCB_S2_30P' AND opt_cd='OPV_000492' AND print_opt_cd='POPT_000002';

-- [역순1] 선택수단 삭제
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000094' AND opt_cd IN ('OPV_000491','OPV_000492');
DELETE FROM t_prd_product_option_groups WHERE prd_cd='PRD_000094' AND opt_grp_cd='OPT_000082';

COMMIT;
