-- 엽서북(PRD_000094) 최소 주문수량 1→2 정합 (가격표 최소구간 2부 기준·시뮬레이터 부수 기본값 원천)
UPDATE t_prd_products SET min_qty=2, upd_dt=now() WHERE prd_cd='PRD_000094' AND min_qty=1;
