-- =====================================================================
-- RC-5 교정 원복(undo) — apply.sql COMMIT 후 되돌리기용
-- 142/143/129 단가를 교정 전 라이브 실측값으로 복원 + 폼보드 A1 신규 INSERT DELETE.
-- 라이브 실측(2026-06-23) 교정 전 unit_price 기준. 단일 트랜잭션·기본 ROLLBACK.
-- A1 DELETE는 본 RC-5가 신규 INSERT한 행만(comp_cd+siz_cd 핀포인트) — 다른 단가행 불간섭.
-- =====================================================================

\set ON_ERROR_STOP on

BEGIN;

-- 유광아크릴 원복 (교정 전 값)
UPDATE t_prc_component_prices SET unit_price =  9000, upd_dt = now() WHERE comp_price_id = 4792;  -- 12000 → 9000
UPDATE t_prc_component_prices SET unit_price = 14000, upd_dt = now() WHERE comp_price_id = 4793;  -- 18000 → 14000
UPDATE t_prc_component_prices SET unit_price = 32000, upd_dt = now() WHERE comp_price_id = 4794;  -- 28000 → 32000
UPDATE t_prc_component_prices SET unit_price = 37000, upd_dt = now() WHERE comp_price_id = 4795;  -- 47000 → 37000

-- 미러아크릴 원복
UPDATE t_prc_component_prices SET unit_price = 11000, upd_dt = now() WHERE comp_price_id = 4796;  -- 15000 → 11000
UPDATE t_prc_component_prices SET unit_price = 18000, upd_dt = now() WHERE comp_price_id = 4797;  -- 22000 → 18000
UPDATE t_prc_component_prices SET unit_price = 29000, upd_dt = now() WHERE comp_price_id = 4798;  -- 36000 → 29000
UPDATE t_prc_component_prices SET unit_price = 50000, upd_dt = now() WHERE comp_price_id = 4799;  -- 62000 → 50000

-- 폼보드 A3 원복 + A1 신규행 삭제
UPDATE t_prc_component_prices SET unit_price = 7000, upd_dt = now() WHERE comp_price_id = 4780;   -- 6000 → 7000

DELETE FROM t_prc_component_prices
 WHERE comp_cd = 'COMP_POSTER_FOAMBOARD_WHITE' AND siz_cd = 'SIZ_000294'
   AND unit_price = 20000;   -- RC-5가 INSERT한 A1행만 핀포인트 삭제

ROLLBACK;
-- COMMIT;  -- 인간 승인 후에만 수동 활성화
