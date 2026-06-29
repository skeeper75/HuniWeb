-- digital 견적0 교정 UNDO (2026-06-29 COMMIT 직전 스냅샷 기준)
-- 충전 전 상태: SIZ_000119/124/133 work_width/height·margins 전부 NULL · 025 bdl_qty=20 행 없음.
BEGIN;
DELETE FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000025' AND bdl_qty=20;
UPDATE t_siz_sizes SET work_width=NULL, work_height=NULL,
       margin_top=NULL, margin_bot=NULL, margin_lft=NULL, margin_rgt=NULL, upd_dt=now()
 WHERE siz_cd IN ('SIZ_000119','SIZ_000124','SIZ_000133');
COMMIT;
