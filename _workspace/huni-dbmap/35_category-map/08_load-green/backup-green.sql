-- round-24 2단계 · 적재 전 백업 (backup-green.sql) — undo 근거
-- 영향 prd_cd(36)의 기존 junction 행 전부 캡처. 실행 결과를 파일/테이블로 보존 후 적재.
-- 권장: psql \copy 또는 CREATE TABLE bak_pc_green_<ts> AS SELECT ... 로 스냅샷.

-- (A) 영향 prd_cd의 현재 junction 전수 SELECT (적재 전 상태)
SELECT prd_cd, cat_cd, main_cat_yn, disp_seq, note, reg_dt, upd_dt
FROM t_prd_product_categories
WHERE prd_cd IN (
  'PRD_000016', 'PRD_000017', 'PRD_000018', 'PRD_000024', 'PRD_000025', 'PRD_000026', 'PRD_000027', 'PRD_000029', 'PRD_000031', 'PRD_000032', 'PRD_000033', 'PRD_000041', 'PRD_000042', 'PRD_000047', 'PRD_000052', 'PRD_000053', 'PRD_000055', 'PRD_000066', 'PRD_000068', 'PRD_000069', 'PRD_000071', 'PRD_000094', 'PRD_000118', 'PRD_000120', 'PRD_000121', 'PRD_000122', 'PRD_000124', 'PRD_000125', 'PRD_000133', 'PRD_000134', 'PRD_000135', 'PRD_000136', 'PRD_000137', 'PRD_000138', 'PRD_000139', 'PRD_000145'
)
ORDER BY prd_cd, cat_cd;

-- (B) 백업 테이블 스냅샷 예시(실행자 선택):
-- CREATE TABLE bak_pc_green_20260618 AS
--   SELECT * FROM t_prd_product_categories
--   WHERE prd_cd IN ('PRD_000016', 'PRD_000017', 'PRD_000018', ... );

-- undo: 적재 후 문제 시 → bak 스냅샷으로 해당 prd_cd 행 복원(DELETE 영향행 + INSERT 백업행).
