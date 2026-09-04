-- t41 rollback — apply.sql 을 ③②① 역순으로 되돌린다.
-- ★ apply.sql 이 COMMIT 되지 않았다면 실행할 필요가 없다.

BEGIN;

-- ③ 단가행 648행 제거 (이 카드가 넣은 것만)
DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND apply_ymd = '2026-09-02'
   AND note LIKE '권위 스티커 r% c1%'
   AND ( (siz_cd = 'SIZ_000057' AND mat_cd IN ('MAT_000609','MAT_000611'))
      OR  siz_cd IN ('SIZ_000058','SIZ_000067') );

-- ② use_dims 원복
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb;

-- ① 판형 원복
UPDATE t_prd_product_plate_sizes
   SET siz_cd = 'SIZ_000521',
       upd_dt = now()
 WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000054','PRD_000058','PRD_000059',
                  'PRD_000060','PRD_000061','PRD_000062','PRD_000063','PRD_000064')
   AND siz_cd = 'SIZ_000498'
   AND COALESCE(del_yn,'N') = 'N';

COMMIT;
