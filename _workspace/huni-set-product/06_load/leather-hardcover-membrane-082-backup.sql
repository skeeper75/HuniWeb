-- ═══════════════════════════════════════════════════════════════════════════
-- 082 하드커버 링책자 면지 통합 재설계 — 물리 백업 (시점 스냅샷) · 2026-07-03 04:26
-- 접미사: setbuild082_20260703_0426 · 영향 6테이블 · COMMIT 전 실행(라이브에 존재).
-- 복원은 undo(leather-hardcover-membrane-082-undo.sql) 우선, 최후수단=백업 테이블 참조.
-- ★USAGE.07 링자재(MAT_013/014/015)도 082 materials 백업에 포함(불가침이나 스냅샷 보존).
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE bak_t_prd_products_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_products WHERE prd_cd IN ('PRD_000082','PRD_000084','PRD_000085','PRD_000086','PRD_000087');   -- 5행
CREATE TABLE bak_t_prd_product_sets_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_product_sets WHERE prd_cd='PRD_000082';                                                        -- 6행
CREATE TABLE bak_t_prd_product_materials_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000082','PRD_000084');                                 -- 082 USAGE.03(4)+USAGE.07(3)+084
CREATE TABLE bak_t_prd_product_option_groups_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000082','PRD_000084');                             -- 082 OPT_066
CREATE TABLE bak_t_prd_product_options_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_product_options WHERE prd_cd IN ('PRD_000082','PRD_000084');                                   -- 082 4옵션
CREATE TABLE bak_t_prd_product_option_items_setbuild082_20260703_0426 AS
  SELECT * FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000082','PRD_000084');                              -- 082 4아이템
