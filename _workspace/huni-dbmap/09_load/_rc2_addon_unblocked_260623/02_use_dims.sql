-- 02_use_dims.sql — comp 판별차원 충전 (멱등 IS DISTINCT FROM 가드)
-- always-add 가드: use_dims에 opt_cd 포함 → 미선택(opt_cd≠신규) 시 단가행 매칭 None → 가산 0.

-- src: spec §2; cur [] (OPV_000425)
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000023"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000023"]'::jsonb;

-- src: spec §2; cur [] (OPV_000426)
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000023"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000023"]'::jsonb;

-- src: spec §2; cur [siz_cd] -> add opt_cd (always-add guard) (OPV_000429)
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "siz_cd", "opt_grp:OPT_000012"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER'
   AND use_dims IS DISTINCT FROM '["opt_cd", "siz_cd", "opt_grp:OPT_000012"]'::jsonb;

-- src: spec §2; cur [siz_cd] -> add opt_cd (always-add guard) (OPV_000430)
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "siz_cd", "opt_grp:OPT_000014"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG'
   AND use_dims IS DISTINCT FROM '["opt_cd", "siz_cd", "opt_grp:OPT_000014"]'::jsonb;

