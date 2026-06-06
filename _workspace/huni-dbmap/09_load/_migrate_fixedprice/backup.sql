-- =====================================================================
-- 백업 스냅샷 (backup.sql) — 읽기전용
-- 마이그레이션이 DELETE할 15상품의 PRF_POSTER_FIXED 바인딩을 CSV로 저장.
-- undo 시 복원 권위본. 어떤 쓰기도 하지 않는다(SELECT/\copy out 만).
-- =====================================================================
\copy (SELECT prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000129','PRD_000130','PRD_000131','PRD_000132','PRD_000133','PRD_000134','PRD_000135','PRD_000136','PRD_000137','PRD_000140','PRD_000141','PRD_000142','PRD_000143','PRD_000144','PRD_000145') AND frm_cd='PRF_POSTER_FIXED' ORDER BY prd_cd) TO 'backup_prf_poster_bindings.csv' WITH CSV HEADER

-- 참고용: 선행 broken-partial component_prices(17 comp) 스냅샷도 함께 저장
\copy (SELECT comp_price_id, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt FROM t_prc_component_prices WHERE comp_cd IN ('COMP_FOAMBOARD_WHITE','COMP_FOAMBOARD_BLACK','COMP_FOMEXBOARD_WHITE','COMP_FOMEXBOARD_BLACK','COMP_POSTER_FRAMELESS_WOOD','COMP_POSTER_LEATHER_FRAME','COMP_POSTER_CANVAS_HANGING','COMP_POSTER_LINEN_WOODBONG','COMP_POSTER_JOKJA','COMP_POSTER_PET_BANNER','COMP_POSTER_MESH_BANNER','COMP_POSTER_SHEETCUT_MATTE','COMP_POSTER_SHEETCUT_HOLO','COMP_POSTER_ACRYLSTK_GLOSS','COMP_POSTER_ACRYLSTK_MIRROR','COMP_POSTER_MINI_STANDBOARD','COMP_POSTER_MINI_BANNER') ORDER BY comp_cd, siz_cd, min_qty) TO 'backup_partial_component_prices.csv' WITH CSV HEADER
