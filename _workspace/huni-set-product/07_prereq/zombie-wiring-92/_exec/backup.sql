-- backup.sql (zombie-wiring-92 _exec) — 물리 백업 테이블 2종 (COMMIT 직전 실행)
-- 부1: t_mat_materials 4행(008/261 REVIVE 대상 + 260/270 REWIRE 좀비 자재 — 상태 스냅샷)
-- 부2: t_prd_product_materials REWIRE 대상 배선 8행(260=7, 270=1) + REVIVE 자재 배선 27행(008=23, 261=4)
-- 백업 = 교정 전 상태 스냅샷. 복원은 undo.sql. 멱등(DROP IF EXISTS 후 재생성).
-- 라이브 변경 없음(CREATE TABLE AS SELECT). 자격증명은 .env.local에서만.
-- 타임스탬프 = 20260625_053924

-- ── 부1 백업: 대상 자재 4행 (t_mat_materials) ──
DROP TABLE IF EXISTS bak_t_mat_materials_zombiewire_20260625_053924;
CREATE TABLE bak_t_mat_materials_zombiewire_20260625_053924 AS
SELECT mat_cd, mat_nm, mat_typ_cd, upr_mat_cd,
       use_yn, del_yn, del_dt, upd_dt, now() AS backup_dt
  FROM t_mat_materials
 WHERE mat_cd IN (
        'MAT_000008',  -- REVIVE 레더 (23wire)
        'MAT_000261',  -- REVIVE 무지내지 (4wire)
        'MAT_000260',  -- REWIRE 좀비 아트250+무광코팅 -> MAT_000250
        'MAT_000270'   -- REWIRE 좀비 워터북보틀500ml -> MAT_000343
       );

-- ── 부2 백업: 영향받는 배선 행 (t_prd_product_materials) ──
-- REWIRE 대상(260/270 좀비 배선 8행) + REVIVE 자재 배선(008/261 27행) = 35행 기대
DROP TABLE IF EXISTS bak_t_prd_product_materials_zombiewire_20260625_053924;
CREATE TABLE bak_t_prd_product_materials_zombiewire_20260625_053924 AS
SELECT prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq,
       reg_dt, upd_dt, del_yn, del_dt, now() AS backup_dt
  FROM t_prd_product_materials
 WHERE mat_cd IN ('MAT_000260','MAT_000270','MAT_000008','MAT_000261');

-- 백업 행수 확인:
SELECT 'bak_mat(부1)' AS tbl, count(*) AS rows FROM bak_t_mat_materials_zombiewire_20260625_053924
UNION ALL
SELECT 'bak_wire(부2)', count(*) FROM bak_t_prd_product_materials_zombiewire_20260625_053924;
-- 기대: 부1=4행(전부 del_yn='Y'), 부2=35행(260=7, 270=1, 008=23, 261=4 — 전부 del_yn='N').
