-- 03_price_fill.sql — 단가행 판별값 충전/재배선 (멱등·단가 verbatim 불변·IS DISTINCT FROM 가드)
-- 대상: t_prc_component_prices  PK=comp_price_id.  unit_price는 WHERE 검증값으로만 가드(미변경).
-- FK 안전: proc_cd→t_proc_processes (PROC_000104·PROC_000079 실재 del_yn=N). opt_cd는 FK 없음.
-- ⓐ 일반 타공 proc_cd 105→104 (3행)  ⓑ 메쉬 타공 NULL→079 + dim_vals 충전 (3행)  ⓒ 족자 bdl_qty→opt_cd (1행)

-- ⓐ 일반현수막(138) PUNCH_4: proc_cd PROC_000105 → PROC_000104 (부모). dim_vals 유지(verbatim).
-- src: live 38219 dim_vals{타공수:4} price 3000
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000104', upd_dt = now()
 WHERE comp_price_id = 38219
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4'
   AND unit_price = 3000.00
   AND dim_vals = '{"타공수": 4}'::jsonb
   AND proc_cd IS DISTINCT FROM 'PROC_000104';
-- src: live 38220 dim_vals{타공수:6} price 4000
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000104', upd_dt = now()
 WHERE comp_price_id = 38220
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4'
   AND unit_price = 4000.00
   AND dim_vals = '{"타공수": 6}'::jsonb
   AND proc_cd IS DISTINCT FROM 'PROC_000104';
-- src: live 38221 dim_vals{타공수:8} price 8000
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000104', upd_dt = now()
 WHERE comp_price_id = 38221
   AND comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4'
   AND unit_price = 8000.00
   AND dim_vals = '{"타공수": 8}'::jsonb
   AND proc_cd IS DISTINCT FROM 'PROC_000104';

-- ⓑ 메쉬현수막(139) PUNCH_4/6/8: proc_cd NULL → PROC_000079 (부모) + dim_vals{타공수} 충전. 단가 verbatim.
-- src: live 4750 NULL price 3000 → 타공수:4
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000079', dim_vals = '{"타공수": 4}'::jsonb, upd_dt = now()
 WHERE comp_price_id = 4750
   AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4'
   AND unit_price = 3000.00
   AND (proc_cd IS DISTINCT FROM 'PROC_000079' OR dim_vals IS DISTINCT FROM '{"타공수": 4}'::jsonb);
-- src: live 4752 NULL price 4000 → 타공수:6
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000079', dim_vals = '{"타공수": 6}'::jsonb, upd_dt = now()
 WHERE comp_price_id = 4752
   AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6'
   AND unit_price = 4000.00
   AND (proc_cd IS DISTINCT FROM 'PROC_000079' OR dim_vals IS DISTINCT FROM '{"타공수": 6}'::jsonb);
-- src: live 4754 NULL price 5000 → 타공수:8
UPDATE t_prc_component_prices
   SET proc_cd = 'PROC_000079', dim_vals = '{"타공수": 8}'::jsonb, upd_dt = now()
 WHERE comp_price_id = 4754
   AND comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8'
   AND unit_price = 5000.00
   AND (proc_cd IS DISTINCT FROM 'PROC_000079' OR dim_vals IS DISTINCT FROM '{"타공수": 8}'::jsonb);

-- ⓒ 족자 천정고리: bdl_qty=2 → NULL + opt_cd=OPV_000431 충전. 6500 verbatim.
-- src: live 4594 bdl_qty=2 price 6500
UPDATE t_prc_component_prices
   SET bdl_qty = NULL, opt_cd = 'OPV_000431', upd_dt = now()
 WHERE comp_price_id = 4594
   AND comp_cd = 'COMP_POSTEROPT_JOKJA_CEILHOOK'
   AND unit_price = 6500.00
   AND (bdl_qty IS DISTINCT FROM NULL OR opt_cd IS DISTINCT FROM 'OPV_000431');

-- [린넨 LINEN_FINISH 단가행 5행 = 124 옵션 정합·재배선 0·충전 0]
