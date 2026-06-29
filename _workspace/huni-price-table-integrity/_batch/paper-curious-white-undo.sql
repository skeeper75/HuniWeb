-- UNDO: 큐리어스스킨 화이트 하위(MAT_000361) COMP_PAPER 적재 되돌리기.
-- 적재 전 (COMP_PAPER, MAT_000361) 행수=0 이었으므로 해당 조합 전체 삭제가 정확한 역연산.
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND mat_cd='MAT_000361';
COMMIT;
