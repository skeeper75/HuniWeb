-- =====================================================================
-- apply.sql — 스티커 Tier A 4상품(052·053·055·066) CPQ 옵션레이어 (단일 트랜잭션)
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh가 주입). commit 시에만 COMMIT(인간 승인).
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(원자성). 중간 COMMIT 금지. NEVER COMMIT(기본).
--   멱등: 전 INSERT 이름기반 NOT EXISTS 가드 → 2회차 delta 0. 코드 재발급 없음(라이브 MAX+1 리터럴).
--   FK 위상정렬: 마커(00) → 옵션그룹(05) → 옵션(06) → 옵션아이템(07) → 제약(08·0행).
--   [중요] 차원행 mint 없음 — 전 차원(자재/공정/도수/사이즈) 라이브 적재 실측(2026-06-14, BLOCKED 0).
--          트리거 fn_chk_opt_item_ref 가 07 행단위 차원행 EXISTS 검사 → 라이브 차원행으로 직접 통과.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00 markers (no INSERT) — 적용 결정·stub 회피'
  \i 00_preload_markers.sql
  \echo '>> step 05 t_prd_product_option_groups (12행 OPT_000006~000017)'
  \i 05_t_prd_product_option_groups.sql
  \echo '>> step 06 t_prd_product_options (22행 OPV_000017~000038)'
  \i 06_t_prd_product_options.sql
  \echo '>> step 07 t_prd_product_option_items (21행 INSERTABLE)'
  \i 07_t_prd_product_option_items.sql
  \echo '>> step 08 t_prd_product_constraints (0행)'
  \i 08_t_prd_product_constraints.sql
  \echo '>> post-apply count check (DRY-RUN 내부 — 트랜잭션 내 가시)'
  SELECT 'groups' AS tbl, count(*) AS n FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000055','PRD_000066') AND del_yn='N'
  UNION ALL SELECT 'options', count(*) FROM t_prd_product_options WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000055','PRD_000066') AND del_yn='N'
  UNION ALL SELECT 'items', count(*) FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000052','PRD_000053','PRD_000055','PRD_000066') AND del_yn='N';
-- 기본 ROLLBACK (apply.sh가 주입). 실제 적재는 commit 인간 승인 시에만. NEVER COMMIT by default.
