-- =====================================================================
-- backup.sql — 읽기전용 백업 스냅샷 (undo 권위본)
--   t_siz_sizes는 INSERT-only → backup = 신규 발급 siz_cd(501~510) 부재 확증.
--   영향 comp_cd(COMP_GANGPAN_PRINT) 기존 GP 행(35mm 등 committed) 스냅샷 → 적재 전/후 대조.
--   DB 쓰기 없음(\copy out 만).
-- =====================================================================
\set ON_ERROR_STOP on
-- 1) 신규 발급 예정 siz_cd 범위 (undo 권위) — 본 파일이 박제 + 라이브 부재 확증.
\copy (SELECT 'SIZ_000501' AS first_new, 'SIZ_000510' AS last_new, 10 AS new_count) TO 'backup_new_siz_range.csv' CSV HEADER
\copy (SELECT siz_cd FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000501', 'SIZ_000502', 'SIZ_000503', 'SIZ_000504', 'SIZ_000505', 'SIZ_000506', 'SIZ_000507', 'SIZ_000508', 'SIZ_000509', 'SIZ_000510') ORDER BY siz_cd) TO 'backup_existing_collisions.csv' CSV HEADER  -- 0행이어야 정상(충돌 없음)

-- 2) 영향 comp_cd 기존 component_prices 스냅샷 (적재 전 상태 — committed 35mm 포함).
\copy (SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, mat_cd, min_qty, unit_price FROM t_prc_component_prices WHERE comp_cd IN ('COMP_GANGPAN_PRINT') ORDER BY comp_price_id) TO 'backup_gp_component_prices_before.csv' CSV HEADER

-- 3) PRD_000066 기존 size link 스냅샷 (적재 전 — 원형 외 기존 규격 보존 확인).
\copy (SELECT prd_cd, siz_cd, dflt_yn, disp_seq FROM t_prd_product_sizes WHERE prd_cd = 'PRD_000066' ORDER BY disp_seq) TO 'backup_066_product_sizes_before.csv' CSV HEADER
