-- T1 보강: banner (1200,900) 권위 셀 2개 INSERT (라이브 sparse 누락·권위 verbatim·대칭가격)
-- 권위: BANNER_NORMAL 1200x900=8640 · BANNER_MESH 1200x900=21600 (라이브 부재 적발)
BEGIN;
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, siz_width, siz_height, reg_dt)
SELECT 40386,'COMP_POSTER_BANNER_NORMAL','2026-06-01',1,8640,1200,900,now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_BANNER_NORMAL' AND siz_width=1200 AND siz_height=900);

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, unit_price, siz_width, siz_height, reg_dt)
SELECT 40387,'COMP_POSTER_BANNER_MESH','2026-06-01',21600,1200,900,now()
WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_BANNER_MESH' AND siz_width=1200 AND siz_height=900);
COMMIT;
