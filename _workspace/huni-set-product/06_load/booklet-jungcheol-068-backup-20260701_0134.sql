-- ================================================================
-- booklet-jungcheol-068 물리 백업 (시점 스냅샷) — 접미사 setbuild_20260701_0134
-- 생성: hsp-load-executor 2026-07-01
-- 목적: COMMIT 전 영향 테이블의 영향 행을 bak_*_setbuild_20260701_0134 로 복제.
--       undo 가 이 스냅샷으로 baseline 복원한다.
-- 영향 prd_cd: PRD_000068(셋트행·부모공식)·PRD_000287(내지)·PRD_000288(표지)
-- 영향 frm_cd: PRF_BOOK_COVER (신규공식·formula_components)
-- ================================================================

CREATE TABLE bak_t_prd_products_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_products WHERE prd_cd IN ('PRD_000068','PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_sets_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_sets WHERE prd_cd='PRD_000068';

CREATE TABLE bak_t_prd_product_sizes_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_sizes WHERE prd_cd IN ('PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_print_options_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_print_options WHERE prd_cd IN ('PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_materials_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_plate_sizes_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_processes_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_processes WHERE prd_cd IN ('PRD_000287','PRD_000288');

CREATE TABLE bak_t_prd_product_price_formulas_setbuild_20260701_0134 AS
  SELECT * FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000068','PRD_000287','PRD_000288');

CREATE TABLE bak_t_prc_price_formulas_setbuild_20260701_0134 AS
  SELECT * FROM t_prc_price_formulas WHERE frm_cd='PRF_BOOK_COVER';

CREATE TABLE bak_t_prc_formula_components_setbuild_20260701_0134 AS
  SELECT * FROM t_prc_formula_components WHERE frm_cd='PRF_BOOK_COVER';
