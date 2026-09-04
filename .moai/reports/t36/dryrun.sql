-- t36 DRY-RUN — apply.sql 과 rollback.sql 을 한 트랜잭션에서 돌리고 ROLLBACK 한다.
-- 라이브에는 아무것도 남지 않는다(마지막이 ROLLBACK).
-- 증명하려는 것 셋:
--   ① apply 가 정확히 1행을 갱신한다
--   ② 같은 apply 를 한 번 더 돌리면 0행이다(멱등)
--   ③ rollback 이 원래 값으로 정확히 되돌린다

\echo '=== 0. 적용 전 상태 ==='
BEGIN;

SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN ('STK_KISSCUT_PRINT','STK_CUT_PRINT','STK_CUT_CLEAR_PRINT',
                   'STK_CUT_LARGE_PRINT','COMP_STK_PRINT') ORDER BY 1;

\echo '=== 1. apply 1회 — 1행 갱신 기대 ==='
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb;

\echo '=== 2. apply 2회(멱등) — 0행 갱신 기대 ==='
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb;

\echo '=== 3. 적용 후 상태 — KISSCUT 만 plt_siz_cd 포함, 나머지 4건 불변 기대 ==='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN ('STK_KISSCUT_PRINT','STK_CUT_PRINT','STK_CUT_CLEAR_PRINT',
                   'STK_CUT_LARGE_PRINT','COMP_STK_PRINT') ORDER BY 1;

\echo '=== 4. 단가행 무변경 확인 — plt_siz_cd NOT NULL 은 0건이어야 한다 ==='
SELECT count(*) AS plt_notnull_rows
  FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT' AND plt_siz_cd IS NOT NULL;

\echo '=== 5. rollback — 1행 갱신 기대 ==='
UPDATE t_prc_price_components
   SET use_dims = '["siz_cd", "mat_cd", "min_qty"]'::jsonb,
       upd_dt   = now()
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND use_dims = '["siz_cd", "mat_cd", "plt_siz_cd", "min_qty"]'::jsonb;

\echo '=== 6. 되돌린 뒤 상태 — 0번과 같아야 한다 ==='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN ('STK_KISSCUT_PRINT','STK_CUT_PRINT','STK_CUT_CLEAR_PRINT',
                   'STK_CUT_LARGE_PRINT','COMP_STK_PRINT') ORDER BY 1;

\echo '=== 7. ROLLBACK — 라이브에 아무것도 남기지 않는다 ==='
ROLLBACK;

\echo '=== 8. 트랜잭션 밖 재확인 — 원래 값 그대로여야 한다 ==='
SELECT comp_cd, use_dims FROM t_prc_price_components
 WHERE comp_cd IN ('STK_KISSCUT_PRINT','STK_CUT_PRINT','STK_CUT_CLEAR_PRINT',
                   'STK_CUT_LARGE_PRINT','COMP_STK_PRINT') ORDER BY 1;
