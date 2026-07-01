-- UNDO: 지그재그엽서(030) 접지 라벨스왑 교정 되돌리기(원래 크로스 상태로).
BEGIN;
UPDATE t_prd_product_option_items SET ref_key1='PROC_000074'
 WHERE prd_cd='PRD_000030' AND opt_cd='OPV-000057' AND ref_key1='PROC_000073';
UPDATE t_prd_product_option_items SET ref_key1='PROC_000073'
 WHERE prd_cd='PRD_000030' AND opt_cd='OPV-000058' AND ref_key1='PROC_000074';
COMMIT;
