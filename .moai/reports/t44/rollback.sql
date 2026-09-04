-- t44 R1/R5 되돌리기 — apply.sql 과 대칭.
--
-- 되돌린 뒤 상태 = pre_live.txt 와 동일해야 한다:
--   SIZ_000633  재단 454x297 · 작업 460x303 · 여백 3  → pansu(316x467) = 0
--   PRD_000290/292 판형 풀 = [316x467 공통 dflt Y] + [480x320 item_siz_cd=SIZ_000633]
--
-- 실행: psql <URL> -f rollback.sql

\set ON_ERROR_STOP 1

BEGIN;

-- ① 표지A4 를 시트 고정치수로 되돌린다
UPDATE t_siz_sizes
   SET cut_width = 454.00, cut_height = 297.00,
       work_width = 460.00, work_height = 303.00,
       upd_dt = now()
 WHERE siz_cd = 'SIZ_000633';

-- ② 480x320 사이즈전용 배선 2행을 되살린다
UPDATE t_prd_product_plate_sizes
   SET del_yn = 'N', del_dt = NULL, upd_dt = now()
 WHERE siz_cd = 'SIZ_000641' AND item_siz_cd = 'SIZ_000633';

\echo '=== 되돌린 뒤 — pre_live.txt 와 대조 ==='
SELECT siz_cd, cut_width, cut_height, work_width, work_height,
       fn_calc_pansu('SIZ_000499', siz_cd) AS pansu_316x467
  FROM t_siz_sizes WHERE siz_cd = 'SIZ_000633';

SELECT prd_cd, siz_cd AS plate, item_siz_cd, dflt_plt_yn, del_yn
  FROM t_prd_product_plate_sizes
 WHERE prd_cd IN ('PRD_000290','PRD_000292') AND del_yn = 'N'
 ORDER BY prd_cd, siz_cd;

COMMIT;
