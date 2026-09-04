-- t40 rollback — apply.sql 이 넣은 648행만 지운다.
-- 식별 조건: 이 카드가 넣은 3사이즈 + 이번에 붙인 비고 접두어.
-- 기존 1,944행은 siz_cd 가 다르거나(058·067 은 통째로 신규), A6 는 자재 2종만 대상이라
-- 아래 조건에 걸리지 않는다.
--
-- ★ apply.sql 이 COMMIT 되지 않았다면 실행할 필요가 없다.

BEGIN;

DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND apply_ymd = '2026-09-02'
   AND note LIKE '권위 스티커 r% c1%'
   AND ( (siz_cd = 'SIZ_000057' AND mat_cd IN ('MAT_000609','MAT_000611'))
      OR  siz_cd IN ('SIZ_000058','SIZ_000067') );

SELECT siz_cd, count(*) FROM t_prc_component_prices
 WHERE comp_cd = 'STK_KISSCUT_PRINT'
   AND siz_cd IN ('SIZ_000057','SIZ_000058','SIZ_000067')
 GROUP BY 1 ORDER BY 1;

COMMIT;
