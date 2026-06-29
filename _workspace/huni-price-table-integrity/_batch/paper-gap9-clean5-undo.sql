-- 출력소재 5건 적재 되돌리기 (2026-06-29). 적재 전 max=41055.
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND comp_price_id>41055 AND mat_cd IN('MAT_000144','MAT_000147','MAT_000111','MAT_000112','MAT_000093');
ROLLBACK;  -- 확인 후 COMMIT
