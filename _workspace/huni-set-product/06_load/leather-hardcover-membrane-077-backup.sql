-- ═══════════════════════════════════════════════════════════════════════════
-- 077 면지 통합 재설계 — 물리 백업 (시점 스냅샷) · 2026-07-03 03:53
-- 접미사: setbuild077_20260703_0353 · 영향 6테이블 · COMMIT 전 실행됨(라이브에 존재).
-- 복원은 undo(leather-hardcover-membrane-077-undo.sql) 우선, 최후수단=백업 테이블 참조.
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE bak_t_prd_products_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_products WHERE prd_cd IN ('PRD_000077','PRD_000079','PRD_000080','PRD_000081');           -- 4행
CREATE TABLE bak_t_prd_product_sets_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_product_sets WHERE prd_cd='PRD_000077';                                                   -- 5행
CREATE TABLE bak_t_prd_product_materials_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000077','PRD_000079');                            -- 3행(077 USAGE.03)
CREATE TABLE bak_t_prd_product_option_groups_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000077','PRD_000079');                        -- 1행(077 OPT_065)
CREATE TABLE bak_t_prd_product_options_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_product_options WHERE prd_cd IN ('PRD_000077','PRD_000079');                              -- 3행
CREATE TABLE bak_t_prd_product_option_items_setbuild077_20260703_0353 AS
  SELECT * FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000077','PRD_000079');                         -- 3행
