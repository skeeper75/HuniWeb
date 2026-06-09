-- =====================================================================
-- apply.sql — 프리미엄엽서(PRD_000016) CPQ 옵션레이어 + 봉투 template/addon + constraints (단일 트랜잭션)
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh가 주입). --commit/commit 시에만 COMMIT.
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(R2 원자성). 중간 COMMIT 금지. NEVER COMMIT(기본).
--   멱등: 전 INSERT/UPDATE 이름·자연키 기반 NOT EXISTS / IS DISTINCT FROM 가드 → 2회차 delta 0. 코드 재발급 없음.
--
--   FK 위상정렬:
--     00 markers(no INSERT)
--     05 option_groups → 06 options → 07 option_items(INSERTABLE 4, 트리거 차원행 EXISTS)
--     08 templates(카드화이트 mint·접착/비접착은 라이브 실재 reuse) → 09 template_selections(카드화이트 freeze)
--     10 addons(PRD_000016 → 3 봉투 템플릿, 1행 기실재 흡수) → 11 constraints(3) → 12 constraint_json compile UPDATE.
--   [중요] options(06)가 option_items(07) 부모(opt_cd) · templates(08)가 selections(09)·addons(10) 부모(tmpl_cd).
--          option_items 트리거 fn_chk_opt_item_ref: 도수(print_option opt_id)·모서리(processes) 차원행 라이브 실재 → 통과.
--   [BLOCKED] 후가공4+종이1 option_item = 차원행 부재 → _blocked/07 (apply 안 함). R-* constraints 3건은 INSERTABLE.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00 markers (no INSERT) — applied decisions / re-code / search-before-mint'
  \i 00_preload_markers.sql
  \echo '>> step 05 t_prd_product_option_groups (5 · OPT_000005~000009)'
  \i 05_t_prd_product_option_groups.sql
  \echo '>> step 06 t_prd_product_options (13 · OPV_000017~000029)'
  \i 06_t_prd_product_options.sql
  \echo '>> step 07 t_prd_product_option_items (INSERTABLE 4: 도수2 .06 + 모서리2 .04)'
  \i 07_t_prd_product_option_items.sql
  \echo '>> step 08 t_prd_templates (카드봉투화이트 TMPL_000010 mint 1 · 접착/비접착 reuse)'
  \i 08_t_prd_templates.sql
  \echo '>> step 09 t_prd_template_selections (카드봉투화이트 freeze 1 · SIZ_000104 qty50)'
  \i 09_t_prd_template_selections.sql
  \echo '>> step 10 t_prd_product_addons (PRD_000016 → 봉투 3 · 1행 기실재 흡수)'
  \i 10_t_prd_product_addons.sql
  \echo '>> step 11 t_prd_product_constraints (3 · RULE_001~003)'
  \i 11_t_prd_product_constraints.sql
  \echo '>> step 12 UPDATE t_prd_products.constraint_json (compile 캐시 · AND of 3 rules)'
  \i 12_t_prd_products_constraint_json.sql
-- 기본 ROLLBACK (apply.sh가 주입). 실제 적재는 commit 인간 승인 시에만. NEVER COMMIT by default.
