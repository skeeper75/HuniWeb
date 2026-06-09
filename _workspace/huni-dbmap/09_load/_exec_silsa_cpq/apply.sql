-- =====================================================================
-- apply.sql — 일반현수막(PRD_000138) CPQ 옵션레이어 v2 + 마스터 mint (단일 트랜잭션)
--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh가 주입). --commit/commit 시에만 COMMIT.
--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(R2 원자성). 중간 COMMIT 금지. NEVER COMMIT(기본).
--   멱등: 전 INSERT 이름기반 NOT EXISTS 가드 → 2회차 delta 0. 코드 재발급 없음(라이브 MAX+1 리터럴).
--   FK 위상정렬: 마커(00) → 자재 mint(01) → 공정 mint(02) → 자재 링크(03) → 공정 링크(04)
--                → 옵션그룹(05) → 옵션(06) → 옵션아이템 BUNDLE(07) → 제약(08·DEFER).
--   [중요] 같은 트랜잭션 내 01/03(자재 mint+링크)·02/04(열재단 mint+링크)가 07(옵션아이템) 선행 →
--          트리거 fn_chk_opt_item_ref 의 자재(.03)/공정(.04) 차원행 EXISTS 검사 통과.
-- =====================================================================
\set ON_ERROR_STOP on
BEGIN;
  \echo '>> step 00 markers (no INSERT) — applied decisions'
  \i 00_preload_markers.sql
  \echo '>> step 01 t_mat_materials (mint 4: 큐방·각목900이하·각목900초과·봉제사)'
  \i 01_t_mat_materials.sql
  \echo '>> step 02 t_proc_processes (mint 1: 열재단 PROC_000084)'
  \i 02_t_proc_processes.sql
  \echo '>> step 03 t_prd_product_materials (자재 링크 6행)'
  \i 03_t_prd_product_materials.sql
  \echo '>> step 04 t_prd_product_processes (열재단 링크 1행)'
  \i 04_t_prd_product_processes.sql
  \echo '>> step 05 t_prd_product_option_groups (가공 OPT_000003 · 추가 OPT_000004)'
  \i 05_t_prd_product_option_groups.sql
  \echo '>> step 06 t_prd_product_options (11 options OPV_000006~000016)'
  \i 06_t_prd_product_options.sql
  \echo '>> step 07 t_prd_product_option_items (BUNDLE 자재.03 + 공정.04 · 18행)'
  \i 07_t_prd_product_option_items.sql
  \echo '>> step 08 t_prd_product_constraints (0행 — R-GAKMOK DEFER, siz 의존)'
  \i 08_t_prd_product_constraints.sql
-- 기본 ROLLBACK (apply.sh가 주입). 실제 적재는 commit 인간 승인 시에만. NEVER COMMIT by default.
