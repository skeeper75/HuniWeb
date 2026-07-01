-- =============================================================================
-- sticker-material-undo.sql — sticker-material-fix 되돌리기
-- 신설 단가행(신규 mat_cd)을 정확 삭제. pre-state=0행이었으므로 mat_cd+마커로 안전.
-- ★실행 전제: sticker-material-fix.sql(COMMIT본)이 실제 적재된 경우에만.
-- DRY-RUN 검증: BEGIN...ROLLBACK 로 감싸 삭제행수 확인 후 필요시 ROLLBACK→COMMIT 교체.
-- =============================================================================
BEGIN;

DELETE FROM t_prc_component_prices
 WHERE comp_cd IN ('COMP_STK_PRINT','COMP_STK_TATTOO')
   AND mat_cd IN ('MAT_000584','MAT_000585','MAT_000586','MAT_000609','MAT_000371','MAT_000372','MAT_000594')
   AND note LIKE '%[mint260701 src=%';

\echo '--- undo 후 잔여(기대 0행) ---'
SELECT mat_cd, count(*) FROM t_prc_component_prices
 WHERE mat_cd IN ('MAT_000584','MAT_000585','MAT_000586','MAT_000609','MAT_000371','MAT_000372','MAT_000594')
 GROUP BY mat_cd ORDER BY mat_cd;

ROLLBACK;   -- 실 undo 시 COMMIT 으로 교체(인간 승인)
-- =============================================================================
