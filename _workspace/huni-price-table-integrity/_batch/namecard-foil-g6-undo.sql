-- namecard-foil-g6-undo.sql — G6 교정(64,000) 되돌리기
-- 교정 전 두 행은 unit_price=63000 이었으므로 정확한 역연산 = 64000→63000.
-- 멱등 가드: 64000인 행만 63000으로 되돌림(이미 63000이면 0행).
-- 주의: 이 undo 는 load.sql 의 교정을 인간 승인 COMMIT 한 뒤에만 의미가 있다.
BEGIN;

UPDATE t_prc_component_prices
   SET unit_price = 63000, upd_dt = now()
 WHERE comp_cd IN ('COMP_NAMECARD_FOIL_S1_STD','COMP_NAMECARD_FOIL_S2_STD')
   AND min_qty  = 1000
   AND unit_price = 64000;

-- COMMIT;   -- ← 인간 승인 후 주석 해제.
ROLLBACK;
