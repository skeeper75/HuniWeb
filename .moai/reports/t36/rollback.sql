-- t36 rollback — apply.sql 을 되돌린다.
-- 되돌릴 대상은 apply.sql 이 건드리는 STK_KISSCUT_PRINT 한 건뿐이다.
-- 원본 값은 적용 전 실측(.moai/reports/t36/before_use_dims.txt)에서 그대로 가져왔다:
--   STK_KISSCUT_PRINT  ["siz_cd", "mat_cd", "min_qty"]
--
-- ★ apply.sql 이 COMMIT 되지 않았으므로(verdict.md = COMMIT 보류) 현재 이 파일을
--   실행할 필요는 없다. 나중에 apply 를 COMMIT 한 뒤 되돌려야 할 때 쓴다.

BEGIN;

UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb;

SELECT comp_cd, use_dims
  FROM t_prc_price_components
 WHERE comp_cd = 'STK_KISSCUT_PRINT';

COMMIT;
