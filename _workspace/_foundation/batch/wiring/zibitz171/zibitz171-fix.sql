BEGIN;

-- 1) PRD_000171(지비츠★): 156과 동일 비규격 설정 + 사용유무 Y
UPDATE t_prd_products SET
  nonspec_yn = 'Y',
  nonspec_width_min = 15.00, nonspec_width_max = 35.00, nonspec_width_incr = 1.00,
  nonspec_height_min = 15.00, nonspec_height_max = 35.00, nonspec_height_incr = 1.00,
  use_yn = 'Y'
WHERE prd_cd = 'PRD_000171';

-- 2) PRD_000156(아크릴지비츠): 사용유무 Y (동시 론칭)
UPDATE t_prd_products SET use_yn = 'Y' WHERE prd_cd = 'PRD_000156';

-- 3) 171 가격공식 재배선: 빈 placeholder(PRF_ACRYL_ZIBITZ2_TBD) → 156과 동일한 실동작 공식(PRF_ZIBITZ_ACRYL)
UPDATE t_prd_product_price_formulas SET frm_cd = 'PRF_ZIBITZ_ACRYL'
WHERE prd_cd = 'PRD_000171' AND frm_cd = 'PRF_ACRYL_ZIBITZ2_TBD';

-- 4) 171 옵션그룹 "가공"(156과 동일 코드 OPT_000083 재사용 — use_dims의 opt_grp:OPT_000083 매칭조건 때문에 필수)
INSERT INTO t_prd_product_option_groups
  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000171', 'OPT_000083', '가공', 'SEL_TYPE.01', 1, 1, 'Y', 1, 'Y', 'N');

-- 5) 171 옵션값 "투명"/"스핀"(156과 동일 코드 OPV_000493/494 재사용 — 단가행이 이 정확한 코드로 매칭됨)
INSERT INTO t_prd_product_options
  (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn)
VALUES
  ('PRD_000171', 'OPV_000493', 'OPT_000083', '투명', 'Y', 1, 'Y', 'N'),
  ('PRD_000171', 'OPV_000494', 'OPT_000083', '스핀', 'N', 2, 'Y', 'N');

-- 검증: 변경 후 상태 확인
\echo '=== VERIFY: PRD_000171/156 products ==='
SELECT prd_cd, prd_nm, nonspec_yn, nonspec_width_min, nonspec_width_max, use_yn FROM t_prd_products WHERE prd_cd IN ('PRD_000156','PRD_000171');
\echo '=== VERIFY: 171 formula binding ==='
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000171';
\echo '=== VERIFY: 171 option groups/options ==='
SELECT prd_cd, opt_grp_cd, opt_grp_nm FROM t_prd_product_option_groups WHERE prd_cd='PRD_000171';
SELECT prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn FROM t_prd_product_options WHERE prd_cd='PRD_000171';

ROLLBACK;
