-- 03_price_fill.sql — 단가행 opt_cd 충전 + RC-4 siz_cd 재배선 (멱등·단가 verbatim 불변)
-- comp_price_id=라이브 PK. unit_price는 WHERE 검증값으로만 가드(미변경).
-- 순서: ⓐ opt_cd 충전(전 단가행) → ⓑ RC-4 siz_cd 재배선(캔버스 우드행거 3행).

-- ⓐ opt_cd 판별값 충전 (single-statement: opt_cd NULL=와일드카드 always-add 해소)
-- src: live 4751 opt_cd NULL price 3000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000425', upd_dt = now()
 WHERE comp_price_id = 4751
   AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4'
   AND unit_price = 3000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000425';

-- src: live 4753 opt_cd NULL price 4000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000426', upd_dt = now()
 WHERE comp_price_id = 4753
   AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4'
   AND unit_price = 4000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000426';

-- src: live 4598 opt_cd NULL price 16000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000429', upd_dt = now()
 WHERE comp_price_id = 4598
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 16000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000429';

-- src: live 4599 opt_cd NULL price 18000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000429', upd_dt = now()
 WHERE comp_price_id = 4599
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 18000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000429';

-- src: live 4600 opt_cd NULL price 20000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000429', upd_dt = now()
 WHERE comp_price_id = 4600
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 20000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000429';

-- src: live 4604 opt_cd NULL price 7000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000430', upd_dt = now()
 WHERE comp_price_id = 4604
   AND comp_cd = 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG'
   AND unit_price = 7000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000430';

-- src: live 4605 opt_cd NULL price 9800
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000430', upd_dt = now()
 WHERE comp_price_id = 4605
   AND comp_cd = 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG'
   AND unit_price = 9800.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000430';

-- src: live 4606 opt_cd NULL price 12000
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000430', upd_dt = now()
 WHERE comp_price_id = 4606
   AND comp_cd = 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG'
   AND unit_price = 12000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000430';

-- ⓑ RC-4 캔버스 우드행거 siz_cd 재배선 (133 미등록 258/315/317 → 등록 172/174/197 동일치수)
-- src: RC-4; A4 210x297 동일등급 (SIZ_000258->SIZ_000172)
UPDATE t_prc_component_prices
   SET siz_cd = 'SIZ_000172', upd_dt = now()
 WHERE comp_price_id = 4598
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 16000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND siz_cd IS DISTINCT FROM 'SIZ_000172'
   AND siz_cd IN ('SIZ_000258', 'SIZ_000172');

-- src: RC-4; A3 297x420 동일등급 (SIZ_000315->SIZ_000174)
UPDATE t_prc_component_prices
   SET siz_cd = 'SIZ_000174', upd_dt = now()
 WHERE comp_price_id = 4599
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 18000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND siz_cd IS DISTINCT FROM 'SIZ_000174'
   AND siz_cd IN ('SIZ_000315', 'SIZ_000174');

-- src: RC-4; A2 420x594 동일등급 (SIZ_000317->SIZ_000197)
UPDATE t_prc_component_prices
   SET siz_cd = 'SIZ_000197', upd_dt = now()
 WHERE comp_price_id = 4600
   AND comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND unit_price = 20000.00            -- verbatim 단가 검증(불일치=0행 가드)
   AND siz_cd IS DISTINCT FROM 'SIZ_000197'
   AND siz_cd IN ('SIZ_000317', 'SIZ_000197');

