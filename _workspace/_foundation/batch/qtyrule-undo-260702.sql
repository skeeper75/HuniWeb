UPDATE t_prc_component_prices SET min_qty=54 WHERE comp_price_id=28002 AND comp_cd='COMP_STK_PACK' AND min_qty=1;
UPDATE t_prd_products SET min_qty=3, upd_dt=now() WHERE prd_cd='PRD_000097' AND min_qty=6;
