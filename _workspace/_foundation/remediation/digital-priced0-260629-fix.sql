-- digital 견적0 교정 4건 (★COMMIT·인간 승인 2026-06-29)
-- ① 투명포토카드(PRD_000025): 묶음수(bdl_qty=20) 행 누락 → 추가(단가행 8,500 존재).
-- ②③④ 모양엽서(SIZ_000119 90x90)·접지카드(SIZ_000124 150x100·SIZ_000133 86x52):
--    공유 사이즈 작업치수(work) NULL → fn_calc_pansu NULL → 견적0. 재단+2mm 블리드로 충전.
--    ★무회귀 입증: 명함032/033은 work치수 NULL인데도 고정가 3,500 정상(work 미사용) → 충전 무영향.
--    공유 마스터 코드 DELETE/이름변경 없이 NULL 컬럼만 보정([[base-master-code-no-delete]] 정합).
-- UNDO=digital-priced0-260629-UNDO.sql.
BEGIN;

-- ① 투명포토카드 묶음수 20개 행 추가(멱등)
INSERT INTO t_prd_product_bundle_qtys
       (prd_cd, bdl_qty, bdl_unit_typ_cd, dflt_yn, disp_seq, del_yn, reg_dt)
SELECT 'PRD_000025', 20, 'QTY_UNIT.06', 'Y', 1, 'N', now()
 WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_bundle_qtys
                    WHERE prd_cd='PRD_000025' AND bdl_qty=20);

-- ② SIZ_000124 (150x100) 작업치수 충전 — 접지카드 027·029
UPDATE t_siz_sizes
   SET work_width=152, work_height=102,
       margin_top=COALESCE(margin_top,1), margin_bot=COALESCE(margin_bot,1),
       margin_lft=COALESCE(margin_lft,1), margin_rgt=COALESCE(margin_rgt,1), upd_dt=now()
 WHERE siz_cd='SIZ_000124' AND (work_width IS NULL OR work_height IS NULL);

-- ③ SIZ_000133 (86x52) 작업치수 충전 — 미니접지카드 028
UPDATE t_siz_sizes
   SET work_width=88, work_height=54,
       margin_top=COALESCE(margin_top,1), margin_bot=COALESCE(margin_bot,1),
       margin_lft=COALESCE(margin_lft,1), margin_rgt=COALESCE(margin_rgt,1), upd_dt=now()
 WHERE siz_cd='SIZ_000133' AND (work_width IS NULL OR work_height IS NULL);

-- ④ SIZ_000119 (90x90) 작업치수 충전 — 모양엽서 023
UPDATE t_siz_sizes
   SET work_width=92, work_height=92,
       margin_top=COALESCE(margin_top,1), margin_bot=COALESCE(margin_bot,1),
       margin_lft=COALESCE(margin_lft,1), margin_rgt=COALESCE(margin_rgt,1), upd_dt=now()
 WHERE siz_cd='SIZ_000119' AND (work_width IS NULL OR work_height IS NULL);

COMMIT;
