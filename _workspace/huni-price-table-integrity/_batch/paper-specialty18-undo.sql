-- 특수용지 하위 18 적재 되돌리기 (2026-06-29). 적재 전 max=41102.
BEGIN; DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND comp_price_id>41102; ROLLBACK;
