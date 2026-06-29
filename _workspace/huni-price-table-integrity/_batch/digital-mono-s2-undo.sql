-- UNDO: 디지털 흑백 양면 적재 되돌리기 (POPT_000009 단가행 + 인쇄옵션)
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND print_opt_cd='POPT_000009';
DELETE FROM t_prt_print_options WHERE print_opt_cd='POPT_000009';
COMMIT;
