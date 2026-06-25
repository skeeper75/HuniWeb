-- ============================================================
-- backup.sql — 좀비 자재 2건 부활 전 물리 백업
-- 대상: t_mat_materials MAT_000159 / MAT_000119 (부활 전 del_yn/del_dt 보존)
-- 백업 테이블: bak_t_mat_materials_zombie_20260624_1250
-- 안전: 읽기 백업(원본 무변경). 2행만.
-- ============================================================

DROP TABLE IF EXISTS bak_t_mat_materials_zombie_20260624_1250;

CREATE TABLE bak_t_mat_materials_zombie_20260624_1250 AS
SELECT *, now() AS _bak_ts
FROM t_mat_materials
WHERE mat_cd IN ('MAT_000159','MAT_000119');

-- 검증: 행수(=2)·부활 전 상태(del_yn='Y') 기록
SELECT count(*) AS bak_rows FROM bak_t_mat_materials_zombie_20260624_1250;
SELECT mat_cd, mat_nm, del_yn, del_dt FROM bak_t_mat_materials_zombie_20260624_1250 ORDER BY mat_cd;
