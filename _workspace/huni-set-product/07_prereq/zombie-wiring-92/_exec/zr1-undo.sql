-- zr1-undo.sql (zombie-wiring-92 _exec) — rev2 REVIVE 9건 되돌리기 (백업 복원·권장)
-- 백업 테이블 bak_t_mat_materials_zr1revive_20260625_055716 선행 필요(zr1-backup.sql).
-- 단일 트랜잭션 래핑. 멱등(IS DISTINCT FROM 가드). 자재 del_yn/del_dt 원값 복귀(전부 'Y').

BEGIN;

-- 방식1(권장): 백업에서 정확 복원
UPDATE t_mat_materials m
   SET del_yn = b.del_yn, del_dt = b.del_dt
  FROM bak_t_mat_materials_zr1revive_20260625_055716 b
 WHERE m.mat_cd = b.mat_cd
   AND (m.del_yn IS DISTINCT FROM b.del_yn OR m.del_dt IS DISTINCT FROM b.del_dt);

COMMIT;

-- 검증: 9행 원상(del_yn='Y') 복귀 확인
SELECT mat_cd, mat_nm, del_yn, del_dt FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262')
 ORDER BY mat_cd;

-- ── 방식2(백업 없을 때 폴백): del_dt 근사 복원 ──
-- BEGIN;
-- UPDATE t_mat_materials SET del_yn='Y', del_dt=COALESCE(del_dt, now())
--  WHERE mat_cd IN ('MAT_000069','MAT_000070','MAT_000337','MAT_000338','MAT_000340','MAT_000244','MAT_000245','MAT_000154','MAT_000262')
--    AND del_yn IS DISTINCT FROM 'Y';
-- COMMIT;
