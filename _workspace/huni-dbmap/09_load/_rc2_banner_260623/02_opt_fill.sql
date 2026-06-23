-- 02_opt_fill.sql — RC-2 단가행 opt_cd 판별값 충전 (멱등 UPDATE·단가 verbatim 불변)
-- comp_price_id=라이브 PK. unit_price는 WHERE 검증값으로만(미변경). opt_cd만 채움.

-- src: mapping.csv opt_fill · COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE (price 3000.00 불변)
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000006', upd_dt = now()
 WHERE comp_price_id = 4692
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE'
   AND unit_price = 3000.00            -- verbatim 단가 검증(불일치 시 0행=가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000006';

-- src: mapping.csv opt_fill · COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE (price 3000.00 불변)
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000010', upd_dt = now()
 WHERE comp_price_id = 4699
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE'
   AND unit_price = 3000.00            -- verbatim 단가 검증(불일치 시 0행=가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000010';

-- src: mapping.csv opt_fill · COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW (price 4000.00 불변)
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000011', upd_dt = now()
 WHERE comp_price_id = 4701
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW'
   AND unit_price = 4000.00            -- verbatim 단가 검증(불일치 시 0행=가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000011';

-- src: mapping.csv opt_fill · COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4 (price 3000.00 불변)
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000013', upd_dt = now()
 WHERE comp_price_id = 4694
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4'
   AND unit_price = 3000.00            -- verbatim 단가 검증(불일치 시 0행=가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000013';

-- src: mapping.csv opt_fill · COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4 (price 4000.00 불변)
UPDATE t_prc_component_prices
   SET opt_cd = 'OPV_000014', upd_dt = now()
 WHERE comp_price_id = 4696
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4'
   AND unit_price = 4000.00            -- verbatim 단가 검증(불일치 시 0행=가드)
   AND opt_cd IS DISTINCT FROM 'OPV_000014';

