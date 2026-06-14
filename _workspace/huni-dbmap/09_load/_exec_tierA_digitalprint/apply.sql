-- =====================================================================
-- apply.sql — 디지털인쇄 Tier A 14상품 CPQ 옵션레이어 (단일 트랜잭션)
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh 가 주입). --commit/commit 시에만 COMMIT.
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(원자성). 중간 COMMIT 금지. NEVER COMMIT(기본).
--   멱등: 전 INSERT 이름기반 NOT EXISTS 가드 → 2회차 delta 0. 코드 재발급 없음(라이브 MAX+1 리터럴).
--   FK 위상정렬: 마커(00) → 옵션그룹(05) → 옵션(06) → 옵션아이템 INSERTABLE(07) → 제약(08·0행).
--     [선행] 차원행(sizes/materials/print_options/processes) = L1 라이브 적재 실측 완료(2026-06-14).
--     트리거 fn_chk_opt_item_ref 가 07 행단위로 차원행 EXISTS 검사 → 차원행 실재 INSERTABLE.
--   BLOCKED(접지/화이트별색 6행) = _blocked/ (본 트랜잭션 미포함). 더미 정리 = _cleanup_dummy.sql(인간 승인).
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00 markers (no INSERT) — applied decisions D-A~D-J'
  \i 00_preload_markers.sql
  \echo '>> step 05 t_prd_product_option_groups (58행)'
  \i 05_t_prd_product_option_groups.sql
  \echo '>> step 06 t_prd_product_options (267행)'
  \i 06_t_prd_product_options.sql
  \echo '>> step 07 t_prd_product_option_items (INSERTABLE 252행 · 트리거 차원행 검사)'
  \i 07_t_prd_product_option_items.sql
  \echo '>> step 08 t_prd_product_constraints (0행 — 옵션그룹 SEL_TYPE 로 충족)'
  \i 08_t_prd_product_constraints.sql
-- 기본 ROLLBACK (apply.sh 가 주입). 실제 적재는 commit 인간 승인 시에만. NEVER COMMIT by default.
