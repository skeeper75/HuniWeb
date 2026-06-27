-- acryl-addon-147-152-undo.sql — 아크릴 addon 5상품 적재 롤백(fix.sql COMMIT 후 되돌림)
-- 역위상순 삭제. 공유 자원(COMP_ACRYL_CLEAR3T·PRF_CLR_ACRYL·기존 product_material)은 절대 미터치.
-- 본 적재본이 신규 생성한 것만 삭제. 실행은 인간 승인 후.
BEGIN;

-- [7] 바인딩 (147~152 신규 PRF_ACRYL_* @2026-06-28)
DELETE FROM t_prd_product_price_formulas
WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000152')
  AND frm_cd IN ('PRF_ACRYL_MAGNET','PRF_ACRYL_BADGE','PRF_ACRYL_CLIP','PRF_ACRYL_SMARTTOK','PRF_ACRYL_NAMETAG')
  AND apply_bgn_ymd='2026-06-28';

-- [6] formula_components + 공식
DELETE FROM t_prc_formula_components
WHERE frm_cd IN ('PRF_ACRYL_MAGNET','PRF_ACRYL_BADGE','PRF_ACRYL_CLIP','PRF_ACRYL_SMARTTOK','PRF_ACRYL_NAMETAG');
DELETE FROM t_prc_price_formulas
WHERE frm_cd IN ('PRF_ACRYL_MAGNET','PRF_ACRYL_BADGE','PRF_ACRYL_CLIP','PRF_ACRYL_SMARTTOK','PRF_ACRYL_NAMETAG');

-- [5] 단가행
DELETE FROM t_prc_component_prices WHERE comp_price_id BETWEEN 39078 AND 39085;

-- [4] 가산 comp
DELETE FROM t_prc_price_components
WHERE comp_cd IN ('COMP_ACRYL_MAGNET','COMP_ACRYL_BADGE','COMP_ACRYL_CLIP','COMP_ACRYL_SMARTTOK','COMP_ACRYL_NAMETAG_PIN');

-- [3] 옵션아이템
DELETE FROM t_prd_product_option_items
WHERE opt_cd IN ('OPV_000465','OPV_000466','OPV_000467','OPV_000468','OPV_000469','OPV_000470','OPV_000471','OPV_000472')
  AND item_seq=1 AND ref_dim_cd='OPT_REF_DIM.03';

-- [2] 옵션
DELETE FROM t_prd_product_options
WHERE opt_cd IN ('OPV_000465','OPV_000466','OPV_000467','OPV_000468','OPV_000469','OPV_000470','OPV_000471','OPV_000472');

-- [1] 옵션그룹
DELETE FROM t_prd_product_option_groups
WHERE opt_grp_cd IN ('OPT_000074','OPT_000075','OPT_000076','OPT_000077','OPT_000078');

-- [0] product_material 보강분 (147 MAT_050만 — 본 적재본 생성분)
DELETE FROM t_prd_product_materials
WHERE prd_cd='PRD_000147' AND mat_cd='MAT_000050' AND usage_cd='USAGE.07';

COMMIT;
