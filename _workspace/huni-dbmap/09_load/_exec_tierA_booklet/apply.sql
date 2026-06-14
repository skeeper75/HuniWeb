-- =====================================================================
-- apply.sql — 책자 Tier A 4상품 CPQ 옵션레이어 (단일 트랜잭션)
--   대상: PRD_000068 중철 · PRD_000069 무선 · PRD_000071 트윈링 · PRD_000094 엽서북.
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh가 주입). commit 인자 시에만 COMMIT.
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(원자성). 중간 COMMIT 금지. NEVER COMMIT(기본).
--   멱등: 전 INSERT 이름기반 NOT EXISTS 가드 → 2회차 delta 0. opt_cd 동적 채번(리터럴 0, 충돌 0).
--   FK 위상정렬: 옵션그룹(05) → 옵션(06, opt_grp 이름 resolve) → 옵션아이템(07, opt_nm resolve) → 제약(08·0행).
--   [중요] 차원행(siz/mat/proc/print_options/sets)은 전부 라이브 실재(BLOCKED 0) — 차원 mint 단계 없음.
--          트리거 fn_chk_opt_item_ref 가 07에서 .01/.03/.04/.06/.07 차원행 EXISTS 검사 → 라이브 통과.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 05 t_prd_product_option_groups (4상품 32 그룹)'
  \i 05_t_prd_product_option_groups.sql
  \echo '>> step 06 t_prd_product_options (enum 24 DO + mat_usage 8 DO)'
  \i 06_t_prd_product_options.sql
  \echo '>> step 07 t_prd_product_option_items (enum 63 + mat_usage 8 DO · 포인터)'
  \i 07_t_prd_product_option_items.sql
  \echo '>> step 08 t_prd_product_constraints (0행 — page_rule 비옵션·제약 DEFER)'
  \i 08_t_prd_product_constraints.sql
  \echo '>> verify counts (this transaction)'
  SELECT 'option_groups' tbl, count(*) n FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000071','PRD_000094') AND del_yn='N'
  UNION ALL SELECT 'options', count(*) FROM t_prd_product_options WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000071','PRD_000094') AND del_yn='N'
  UNION ALL SELECT 'option_items', count(*) FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000068','PRD_000069','PRD_000071','PRD_000094') AND del_yn='N';
-- 기본 ROLLBACK (apply.sh가 주입). 실제 적재는 commit 인간 승인 시에만. NEVER COMMIT by default.
