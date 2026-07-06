-- UNDO: 책자 내지 5종 디지털인쇄 공정 배선 되돌리기 (bookinner-print-proc-260706-load.sql)
-- 대상 5종은 적재 전 t_prd_product_processes 행 0개였음(사전 확인 완료) → 삭제로 원상복구.
BEGIN;

DELETE FROM t_prd_product_processes
WHERE proc_cd = 'PROC_000004'
  AND prd_cd IN ('PRD_000285','PRD_000286','PRD_000287','PRD_000289','PRD_000291');

SELECT prd_cd, proc_cd FROM t_prd_product_processes
WHERE prd_cd IN ('PRD_000285','PRD_000286','PRD_000287','PRD_000289','PRD_000291');
-- (0행이어야 원상복구)

COMMIT;
