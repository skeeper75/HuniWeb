-- =====================================================================
-- apply.sql — 일반현수막(PRD_000138) round-5 멱등 적재 (단일 트랜잭션)
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh/load.py 가 주입). --commit 시에만 COMMIT.
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(R2 원자성). 중간 COMMIT 금지.
--   주 트랜잭션 = INSERTABLE 행만. BLOCKED(siz77·area77·열재단·자재 seq)는 _blocked/ 별도(인간 승인 선행).
--   [v2] 옵션 = 자재+공정 BUNDLE. 주 트랜잭션 옵션아이템(08)=공정 seq(.04) 9행. 자재 seq(.03)=_blocked/.
--   FK 위상정렬: 마커(00) → 공식(01) → comp(02) → 배선(03) → 단가(04) → 바인딩(05)
--                → 옵션그룹(06) → 옵션(07) → 옵션아이템 공정seq(08) → 제약(09).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00 pre-load markers (no INSERT)'
  \i 00_preload_markers.sql
  \echo '>> [price] step 01 t_prc_price_formulas'
  \i 01_t_prc_price_formulas.sql
  \echo '>> [price] step 02 t_prc_price_components'
  \i 02_t_prc_price_components.sql
  \echo '>> [price] step 03 t_prc_formula_components'
  \i 03_t_prc_formula_components.sql
  \echo '>> [price] step 04 t_prc_component_prices (INSERTABLE 13)'
  \i 04_t_prc_component_prices.sql
  \echo '>> [price] step 05 t_prd_product_price_formulas'
  \i 05_t_prd_product_price_formulas.sql
  \echo '>> [master] step 06 t_prd_product_option_groups'
  \i 06_t_prd_product_option_groups.sql
  \echo '>> [master] step 07 t_prd_product_options'
  \i 07_t_prd_product_options.sql
  \echo '>> [master] step 08 t_prd_product_option_items (INSERTABLE 9)'
  \i 08_t_prd_product_option_items.sql
  \echo '>> [master] step 09 t_prd_product_constraints (0 rows, GAP-DEFER)'
  \i 09_t_prd_product_constraints.sql
-- 기본 ROLLBACK (apply.sh/load.py 주입). 실제 적재는 --commit 인간 승인 시에만.
