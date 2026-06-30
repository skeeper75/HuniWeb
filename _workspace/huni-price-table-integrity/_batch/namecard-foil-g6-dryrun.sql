-- namecard-foil-g6-dryrun.sql — G6 교정 DRY-RUN(반드시 ROLLBACK 종결·라이브 무변경 증명)
-- load.sql 과 동일 UPDATE 를 BEGIN…ROLLBACK 로 감싸 멱등·무오류·영향행수만 확인.
-- 읽기 안전: ROLLBACK 으로 끝나므로 라이브 데이터는 변하지 않는다.
BEGIN;

-- 교정 전 상태(63000 기대):
SELECT 'BEFORE' tag, comp_cd, min_qty, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD') AND min_qty=1000
 ORDER BY comp_cd;

UPDATE t_prc_component_prices
   SET unit_price = 64000, upd_dt = now()
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD')
   AND min_qty  = 1000
   AND unit_price = 63000;

-- 교정 후(트랜잭션 내·64000 기대·2행 영향):
SELECT 'AFTER' tag, comp_cd, min_qty, unit_price
  FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD') AND min_qty=1000
 ORDER BY comp_cd;

-- 멱등 재실행(같은 트랜잭션 내 2회차 = 0행 영향 기대):
UPDATE t_prc_component_prices
   SET unit_price = 64000, upd_dt = now()
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD')
   AND min_qty  = 1000
   AND unit_price = 63000;

ROLLBACK;   -- [HARD] 라이브 무변경 — 절대 COMMIT 금지
