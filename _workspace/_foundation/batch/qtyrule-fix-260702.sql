-- A그룹 교정 1: 스티커팩 단가행 min_qty 오키잉(세트당 장수 54 → 수량구간 1·권위: 1부터 4,000 평탄)
UPDATE t_prc_component_prices SET min_qty=1 WHERE comp_price_id=28002 AND comp_cd='COMP_STK_PACK' AND min_qty=54;
-- A그룹 교정 2: 떡메모지 최소수량 3→6 (가격표 최소구간 6·엽서북 선례와 동일 패턴)
UPDATE t_prd_products SET min_qty=6, upd_dt=now() WHERE prd_cd='PRD_000097' AND min_qty=3;
