-- 명함 NAMECARD/PHOTOCARD .01 18개 밴드총액 교정 — UNDO (원복·COMMIT)
-- COMMIT 분에 대응하는 역연산. 백업 테이블에서 원래 값 복원.
-- 백업(2026-06-29 17:49 스냅샷):
--   bak_t_prc_price_components_namecardband_20260629_1749 (18행·prc_typ 원본)
--   bak_t_prc_component_prices_namecardband_20260629_1749 (2행·min_qty 원본)
-- ★실행 시 종결자 COMMIT 확인 후. 사후 시뮬 불일치 등 복구 필요 시에만.

BEGIN;

-- price_components 18행 prc_typ_cd 원복 (.02/.03 → 원본 .01)
UPDATE t_prc_price_components t
SET prc_typ_cd = b.prc_typ_cd, upd_dt = now()
FROM bak_t_prc_price_components_namecardband_20260629_1749 b
WHERE t.comp_cd = b.comp_cd;
-- 기대: 18행 UPDATE

-- component_prices 그룹C 2행 min_qty 원복 (20 → 원본 1)
UPDATE t_prc_component_prices t
SET min_qty = b.min_qty, upd_dt = now()
FROM bak_t_prc_component_prices_namecardband_20260629_1749 b
WHERE t.comp_price_id = b.comp_price_id;
-- 기대: 2행 UPDATE (comp_price_id 3439·3440)

COMMIT;  -- ★원복 적용.
