-- 01_use_dims.sql — RC-2 일반현수막 옵션 comp use_dims 판별차원 충전 (멱등 UPDATE)
-- 빈 [] / 오설정 opt_grp → opt_cd+opt_grp 판별차원. IS DISTINCT FROM 가드(2회차 0행).

-- src: mapping.csv use_dims · COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000003"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000003"]'::jsonb;

-- src: mapping.csv use_dims · COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000003"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000003"]'::jsonb;

-- src: mapping.csv use_dims · COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000003"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000003"]'::jsonb;

-- src: mapping.csv use_dims · COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000004"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000004"]'::jsonb;

-- src: mapping.csv use_dims · COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "opt_grp:OPT_000004"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4'
   AND use_dims IS DISTINCT FROM '["opt_cd", "opt_grp:OPT_000004"]'::jsonb;

