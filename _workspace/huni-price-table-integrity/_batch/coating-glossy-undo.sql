-- 코팅 유광(COMP_COAT_GLOSSY) 92행 적재 되돌리기 (2026-06-29 COMMIT)
-- 적재 전 max comp_price_id=40387 · GLOSSY 0행이었음.
BEGIN;
DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_COAT_GLOSSY' AND comp_price_id>40387;
-- 확인 후 COMMIT 또는 ROLLBACK
ROLLBACK;
