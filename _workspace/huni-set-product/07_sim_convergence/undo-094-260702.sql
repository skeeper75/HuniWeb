-- ============================================================================
-- undo-094-260702.sql — fix-094-260702.sql 원복 (백업=backup-094-260702.txt 기준)
-- fix가 새로 INSERT한 행만 제거해 pre-fix 상태로 정확 복원한다.
-- (해당 행들은 fix 전 존재하지 않았음 — 백업 덤프로 실증. 따라서 DELETE=정확 원복.)
-- 실행: psql --single-transaction -v ON_ERROR_STOP=1 -f undo-094-260702.sql
-- ============================================================================

DELETE FROM t_prd_product_sizes
 WHERE prd_cd IN ('PRD_000095','PRD_000096')
   AND siz_cd IN ('SIZ_000003','SIZ_000004','SIZ_000124');

DELETE FROM t_prd_product_materials
 WHERE (prd_cd='PRD_000095' AND mat_cd='MAT_000109' AND usage_cd='USAGE.01')
    OR (prd_cd='PRD_000096' AND mat_cd='MAT_000092' AND usage_cd='USAGE.02');

DELETE FROM t_prd_product_print_options
 WHERE prd_cd IN ('PRD_000095','PRD_000096')
   AND print_opt_cd IN ('POPT_000001','POPT_000002');

DELETE FROM t_prd_product_plate_sizes
 WHERE prd_cd='PRD_000094' AND siz_cd='SIZ_000499' AND item_siz_cd='';
