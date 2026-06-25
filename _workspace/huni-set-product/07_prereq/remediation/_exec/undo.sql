-- undo.sql (_exec) — 부1 부활 되돌리기 (백업 복원·권장)
-- 백업 테이블 bak_t_mat_materials_w1_20260624_1137 선행 필요(backup.sql).
-- 단일 트랜잭션 래핑. 멱등(IS DISTINCT FROM 가드).

BEGIN;

-- 방식1(권장): 백업에서 정확 복원 (del_yn·del_dt 원값 복귀)
UPDATE t_mat_materials m
   SET del_yn = b.del_yn, del_dt = b.del_dt
  FROM bak_t_mat_materials_w1_20260624_1137 b
 WHERE m.mat_cd = b.mat_cd
   AND (m.del_yn IS DISTINCT FROM b.del_yn OR m.del_dt IS DISTINCT FROM b.del_dt);

COMMIT;

-- 검증: 10행 원상(del_yn='Y') 복귀 확인
SELECT mat_cd, mat_nm, del_yn, del_dt FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
 ORDER BY mat_cd;

-- ── 방식2(백업 없을 때 폴백): del_dt 근사 복원 ──
-- BEGIN;
-- UPDATE t_mat_materials SET del_yn='Y', del_dt=COALESCE(del_dt, now())
--  WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094','MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
--    AND del_yn IS DISTINCT FROM 'Y';
-- COMMIT;
