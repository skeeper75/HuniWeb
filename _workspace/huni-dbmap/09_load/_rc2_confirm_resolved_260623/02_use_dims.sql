-- 02_use_dims.sql — comp use_dims 충전/재배선 (멱등·IS DISTINCT FROM 가드)
-- 대상: t_prc_price_components.use_dims (jsonb)
-- 메쉬 타공: PUNCH_4/8 []→proc_cd 차원 충전 / PUNCH_6 proc_grp 토큰 PROC_000080→PROC_000079 정정.
-- 족자: bdl_qty→opt_cd 재배선.  [린넨 use_dims 이미 ["opt_cd","min_qty"] 정합·충전 0]
-- always-add 제거 핵심: 빈 use_dims([])는 판별차원 부재 → 충전으로 미선택 0가산 보장.

-- 메쉬 PUNCH_4: [] → proc_cd 차원 (proc_grp 토큰=부모 PROC_000079)
UPDATE t_prc_price_components
   SET use_dims = '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4'
   AND use_dims IS DISTINCT FROM '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb;

-- 메쉬 PUNCH_6: proc_grp 토큰 PROC_000080 → PROC_000079 정정 (표시용 토큰·매칭 무관·정합)
UPDATE t_prc_price_components
   SET use_dims = '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6'
   AND use_dims IS DISTINCT FROM '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb;

-- 메쉬 PUNCH_8: [] → proc_cd 차원
UPDATE t_prc_price_components
   SET use_dims = '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8'
   AND use_dims IS DISTINCT FROM '["proc_cd", "min_qty", "proc_grp:PROC_000079"]'::jsonb;

-- 족자 천정고리: ["bdl_qty","min_qty"] → ["opt_cd","min_qty"] (bdl_qty 의미오용 교정)
UPDATE t_prc_price_components
   SET use_dims = '["opt_cd", "min_qty"]'::jsonb, upd_dt = now()
 WHERE comp_cd = 'COMP_POSTEROPT_JOKJA_CEILHOOK'
   AND use_dims IS DISTINCT FROM '["opt_cd", "min_qty"]'::jsonb;

-- [일반현수막 PUNCH_4 use_dims 이미 ["proc_cd","min_qty","proc_grp:PROC_000104"] 정합·충전 0]
