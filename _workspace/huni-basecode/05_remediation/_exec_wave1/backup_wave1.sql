-- ============================================================================
-- backup_wave1.sql — Wave 1 교정 대상 행 현재 상태 read-only 스냅샷
-- ----------------------------------------------------------------------------
-- [HARD] SELECT만 — 쓰기 0. 실행 전 backup_*.csv로 현재 상태 보존(undo 근거).
-- 사용: psql ... -f backup_wave1.sql  (또는 apply_wave1.sh가 호출)
-- 측정일: 2026-06-18 Railway `railway` DB
-- ============================================================================

-- R1 SZ-1 (siz_nm 원복용)
\copy (SELECT 'R1_siz' AS item, siz_cd, siz_nm, del_yn, use_yn FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000104','SIZ_000105') ORDER BY siz_cd) TO 'backup_R1_siz.csv' WITH (FORMAT csv, HEADER true);

-- R2 카테고리 소프트삭제 11 (del_yn/upr 원복용)
\copy (SELECT 'R2_cat' AS item, cat_cd, cat_nm, upr_cat_cd, cat_lvl, del_yn, del_dt, use_yn FROM t_cat_categories WHERE cat_cd IN ('CAT_000294','CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306') ORDER BY cat_cd) TO 'backup_R2_cat.csv' WITH (FORMAT csv, HEADER true);

-- R3 카테고리 재연결 2 (upr_cat_cd 원복용)
\copy (SELECT 'R3_cat' AS item, cat_cd, cat_nm, upr_cat_cd, cat_lvl, del_yn, use_yn FROM t_cat_categories WHERE cat_cd IN ('CAT_000302','CAT_000304') ORDER BY cat_cd) TO 'backup_R3_cat.csv' WITH (FORMAT csv, HEADER true);

-- R4 레이플랫 PROC_000025 (del_yn 원복용)
\copy (SELECT 'R4_proc' AS item, proc_cd, proc_nm, del_yn, del_dt, use_yn FROM t_proc_processes WHERE proc_cd='PROC_000025') TO 'backup_R4_proc.csv' WITH (FORMAT csv, HEADER true);

-- R5 .10->.07 부자재 16 (mat_typ_cd 원복용)
\copy (SELECT 'R5_mat' AS item, mat_cd, mat_nm, mat_typ_cd, del_yn, use_yn FROM t_mat_materials WHERE mat_cd IN ('MAT_000210','MAT_000212','MAT_000213','MAT_000215','MAT_000216','MAT_000217','MAT_000219','MAT_000220','MAT_000221','MAT_000222','MAT_000224','MAT_000226','MAT_000227','MAT_000228','MAT_000230','MAT_000231') ORDER BY mat_cd) TO 'backup_R5_mat.csv' WITH (FORMAT csv, HEADER true);

-- R6 봉투 placeholder 5 + 헤더 6 (del_yn 원복용)
\copy (SELECT 'R6_mat' AS item, mat_cd, mat_nm, mat_typ_cd, del_yn, del_dt, use_yn FROM t_mat_materials WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201','MAT_000211','MAT_000218','MAT_000223','MAT_000225','MAT_000229','MAT_000233') ORDER BY mat_cd) TO 'backup_R6_mat.csv' WITH (FORMAT csv, HEADER true);
