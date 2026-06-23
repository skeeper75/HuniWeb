-- undo.sql — RC-2 CONFIRM 확정 3건 원복 (멱등·verbatim 복원·라이브 실측 직전값 기준)
-- 직전값 기준: 2026-06-23 라이브 실측. 단가 verbatim(불변)이었으므로 원복도 판별값/바인딩/옵션/use_yn만 되돌림.
-- 역순(FK 위상 역): 좀비 → 바인딩 → 단가행 → use_dims → 옵션
\set ON_ERROR_STOP on
BEGIN;

-- 05 역: 일반 좀비 use_yn=N → Y (직전=Y)
UPDATE t_prc_price_components SET use_yn='Y', upd_dt=now()
 WHERE comp_cd IN ('COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6','COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8')
   AND del_yn='Y' AND use_yn IS DISTINCT FROM 'Y';

-- 04 역: 신규 바인딩 4건 삭제 (린넨·메쉬타공3·족자). 일반 PUNCH_4(기존)·본체 보존.
DELETE FROM t_prc_formula_components
 WHERE (frm_cd='PRF_POSTER_LINEN'       AND comp_cd='COMP_POSTEROPT_LINEN_FINISH')
    OR (frm_cd='PRF_POSTER_BANNER_M'    AND comp_cd IN ('COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4',
                                                        'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6',
                                                        'COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8'))
    OR (frm_cd='PRF_POSTER_JOKJA'       AND comp_cd='COMP_POSTEROPT_JOKJA_CEILHOOK');

-- 03 역: 단가행 판별값 원복 (단가 verbatim 가드)
-- 일반 타공 proc_cd 104 → 105 (직전)
UPDATE t_prc_component_prices SET proc_cd='PROC_000105', upd_dt=now()
 WHERE comp_price_id IN (38219,38220,38221) AND comp_cd='COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4'
   AND proc_cd IS DISTINCT FROM 'PROC_000105';
-- 메쉬 타공 proc_cd 079 → NULL + dim_vals → NULL (직전)
UPDATE t_prc_component_prices SET proc_cd=NULL, dim_vals=NULL, upd_dt=now()
 WHERE comp_price_id IN (4750,4752,4754)
   AND (proc_cd IS DISTINCT FROM NULL OR dim_vals IS DISTINCT FROM NULL);
-- 족자 opt_cd OPV_000431 → NULL + bdl_qty NULL → 2 (직전)
UPDATE t_prc_component_prices SET opt_cd=NULL, bdl_qty=2, upd_dt=now()
 WHERE comp_price_id=4594 AND comp_cd='COMP_POSTEROPT_JOKJA_CEILHOOK' AND unit_price=6500.00
   AND (opt_cd IS DISTINCT FROM NULL OR bdl_qty IS DISTINCT FROM 2);

-- 02 역: use_dims 원복 (직전 라이브값)
UPDATE t_prc_price_components SET use_dims='[]'::jsonb, upd_dt=now()
 WHERE comp_cd IN ('COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4','COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8')
   AND use_dims IS DISTINCT FROM '[]'::jsonb;
UPDATE t_prc_price_components SET use_dims='["proc_cd", "min_qty", "proc_grp:PROC_000080"]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6'
   AND use_dims IS DISTINCT FROM '["proc_cd", "min_qty", "proc_grp:PROC_000080"]'::jsonb;
UPDATE t_prc_price_components SET use_dims='["bdl_qty", "min_qty"]'::jsonb, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_JOKJA_CEILHOOK'
   AND use_dims IS DISTINCT FROM '["bdl_qty", "min_qty"]'::jsonb;

-- 01 역: 신규 옵션 OPV_000431 삭제
DELETE FROM t_prd_product_options WHERE prd_cd='PRD_000135' AND opt_cd='OPV_000431';

-- 기본 ROLLBACK(apply.sh undo 주입). 실제 원복은 undo-commit 인자로만 COMMIT.
