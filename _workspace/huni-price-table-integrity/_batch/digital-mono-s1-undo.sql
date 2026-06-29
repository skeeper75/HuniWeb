-- 디지털 흑백 단면 106행 적재 되돌리기 (2026-06-29). 적재 전 max=40843.
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND print_opt_cd='POPT_000008' AND comp_price_id>40843;
ROLLBACK;  -- 확인 후 COMMIT
