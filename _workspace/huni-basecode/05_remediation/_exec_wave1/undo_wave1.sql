-- ============================================================================
-- undo_wave1.sql — Wave 1 교정 되돌리기 (실 COMMIT된 경우에만 사용)
-- ----------------------------------------------------------------------------
-- [HARD] 본 파일은 apply_wave1.sql이 실 COMMIT된 후 원복용. DRY-RUN 단계엔 불요.
--   값 = 2026-06-18 백업 스냅샷(backup_*.csv) 기준 원상태. 라이브 변경 시 백업 재실측.
-- [HARD] 로더가 BEGIN…(기본 ROLLBACK) 래핑. 실 원복은 --commit 인간 승인.
-- ============================================================================

\set ON_ERROR_STOP on

-- R1 원복 — siz_nm 색 인코딩 복원
UPDATE t_siz_sizes SET siz_nm = '화이트165x115mm(10장)', upd_dt = now() WHERE siz_cd = 'SIZ_000104';
UPDATE t_siz_sizes SET siz_nm = '블랙165x115mm(10장)',  upd_dt = now() WHERE siz_cd = 'SIZ_000105';

-- R2 원복 — 카테고리 소프트삭제 해제(del_yn='N'·del_dt=NULL). use_yn은 원상태(CAT_000294='Y'·나머지='N') 복원.
UPDATE t_cat_categories SET del_yn = 'N', del_dt = NULL, use_yn = 'Y', upd_dt = now() WHERE cat_cd = 'CAT_000294';
UPDATE t_cat_categories SET del_yn = 'N', del_dt = NULL, use_yn = 'N', upd_dt = now()
 WHERE cat_cd IN ('CAT_000293','CAT_000295','CAT_000296','CAT_000298','CAT_000299','CAT_000300','CAT_000301','CAT_000303','CAT_000305','CAT_000306');

-- R3 원복 — upr_cat_cd → NULL(원 고아 상태)
UPDATE t_cat_categories SET upr_cat_cd = NULL, upd_dt = now() WHERE cat_cd IN ('CAT_000302','CAT_000304');

-- R4 원복 — 레이플랫 소프트삭제 해제
UPDATE t_proc_processes SET del_yn = 'N', del_dt = NULL, upd_dt = now() WHERE proc_cd = 'PROC_000025';

-- R5 원복 — mat_typ_cd .07 → .10 복원
UPDATE t_mat_materials SET mat_typ_cd = 'MAT_TYPE.10', upd_dt = now()
 WHERE mat_cd IN ('MAT_000210','MAT_000212','MAT_000213','MAT_000215','MAT_000216','MAT_000217','MAT_000219','MAT_000220','MAT_000221','MAT_000222','MAT_000224','MAT_000226','MAT_000227','MAT_000228','MAT_000230','MAT_000231');

-- R6 원복 — 봉투 placeholder 소프트삭제 해제(헤더 6은 원래 'Y'였으므로 원복 제외)
UPDATE t_mat_materials SET del_yn = 'N', del_dt = NULL, upd_dt = now()
 WHERE mat_cd IN ('MAT_000197','MAT_000198','MAT_000199','MAT_000200','MAT_000201');
