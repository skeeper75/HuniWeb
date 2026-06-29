-- silsa siz_cd 재키잉 UNDO (정본→중복본 원복·comp_price_id 정확지정)
-- 2026-06-29 COMMIT 직전 스냅샷. 문제 시 이 파일로 원복.
BEGIN;
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4580;  -- COMP_POSTER_FRAMELESS_WOOD unit=16000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4581;  -- COMP_POSTER_FRAMELESS_WOOD unit=23000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4587;  -- COMP_POSTER_LEATHER_FRAME unit=16000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4588;  -- COMP_POSTER_LEATHER_FRAME unit=21000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4589;  -- COMP_POSTER_JOKJA unit=13000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4590;  -- COMP_POSTER_JOKJA unit=15000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4595;  -- COMP_POSTER_CANVAS_HANGING unit=6000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4596;  -- COMP_POSTER_CANVAS_HANGING unit=10500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4597;  -- COMP_POSTER_CANVAS_HANGING unit=20000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000426' WHERE comp_price_id=4755;  -- COMP_POSTER_MINI_STANDBOARD unit=3500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4756;  -- COMP_POSTER_MINI_STANDBOARD unit=4500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4757;  -- COMP_POSTER_MINI_STANDBOARD unit=6500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000426' WHERE comp_price_id=4758;  -- COMP_POSTER_MINI_STANDBOARD unit=3400.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4759;  -- COMP_POSTER_MINI_STANDBOARD unit=4300.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4760;  -- COMP_POSTER_MINI_STANDBOARD unit=6200.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000426' WHERE comp_price_id=4761;  -- COMP_POSTER_MINI_STANDBOARD unit=3300.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4762;  -- COMP_POSTER_MINI_STANDBOARD unit=4200.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4763;  -- COMP_POSTER_MINI_STANDBOARD unit=6100.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000426' WHERE comp_price_id=4764;  -- COMP_POSTER_MINI_STANDBOARD unit=3100.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4765;  -- COMP_POSTER_MINI_STANDBOARD unit=4000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4766;  -- COMP_POSTER_MINI_STANDBOARD unit=5900.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000426' WHERE comp_price_id=4767;  -- COMP_POSTER_MINI_STANDBOARD unit=2900.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4768;  -- COMP_POSTER_MINI_STANDBOARD unit=3800.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4769;  -- COMP_POSTER_MINI_STANDBOARD unit=5500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4780;  -- COMP_POSTER_FOAMBOARD_WHITE unit=6000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4781;  -- COMP_POSTER_FOAMBOARD_WHITE unit=12000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4786;  -- COMP_POSTER_FOMEXBOARD_WHITE3MM unit=8500.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4787;  -- COMP_POSTER_FOMEXBOARD_WHITE3MM unit=13000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4800;  -- COMP_POSTER_SHEETCUT_MATTE unit=6000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4801;  -- COMP_POSTER_SHEETCUT_MATTE unit=11000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4802;  -- COMP_POSTER_SHEETCUT_MATTE unit=32000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000258' WHERE comp_price_id=4803;  -- COMP_POSTER_SHEETCUT_HOLO unit=8000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000315' WHERE comp_price_id=4804;  -- COMP_POSTER_SHEETCUT_HOLO unit=16000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000317' WHERE comp_price_id=4805;  -- COMP_POSTER_SHEETCUT_HOLO unit=32000.00
UPDATE t_prc_component_prices SET siz_cd='SIZ_000294' WHERE comp_price_id=38239;  -- COMP_POSTER_FOAMBOARD_WHITE unit=20000.00
COMMIT;
