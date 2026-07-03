-- ═══════════════════════════════════════════════════════════════════════════
-- 088 레더 링바인더 면지 통합 재설계 — 물리 백업 (시점 스냅샷) · 2026-07-03 10:25
-- 접미사: setbuild088_20260703_1025 · 영향 6테이블 · COMMIT 전 실행(라이브에 존재).
-- 복원은 undo(leather-hardcover-membrane-088-undo.sql) 우선, 최후수단=백업 테이블 참조.
-- ★USAGE.07 D링자재(MAT_247/248/249)도 088 materials 백업에 포함(불가침이나 스냅샷 보존).
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE bak_t_prd_products_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_products WHERE prd_cd IN ('PRD_000088','PRD_000090','PRD_000091','PRD_000092','PRD_000093');   -- 5행
CREATE TABLE bak_t_prd_product_sets_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_product_sets WHERE prd_cd='PRD_000088';                                                        -- 5행(089/090/091/092/093)
CREATE TABLE bak_t_prd_product_materials_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_product_materials WHERE prd_cd IN ('PRD_000088','PRD_000090');                                 -- 088 USAGE.03(4)+USAGE.07 D링(3)+090
CREATE TABLE bak_t_prd_product_option_groups_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_product_option_groups WHERE prd_cd IN ('PRD_000088','PRD_000090');                             -- 088 OPT_067
CREATE TABLE bak_t_prd_product_options_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_product_options WHERE prd_cd IN ('PRD_000088','PRD_000090');                                   -- 088 4옵션
CREATE TABLE bak_t_prd_product_option_items_setbuild088_20260703_1025 AS
  SELECT * FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000088','PRD_000090');                              -- 088 4아이템
