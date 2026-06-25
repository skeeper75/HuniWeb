-- undo.sql — apply.sql 교정 되돌리기(부활 → 재논리삭제)
-- 두 가지 방식 제공. 방식1(백업 복원·권장)은 backup.sql 선행 필요.
-- BEGIN/COMMIT 미내장 — 실행자가 트랜잭션으로 감싼다.
-- 멱등: WHERE del_yn != 목표값 가드.

-- ── 방식1(권장): 백업 테이블에서 정확 복원 ──
-- backup.sql로 _bak_mat_materials_remediation_260624 생성돼 있어야 함.
UPDATE t_mat_materials m
   SET del_yn = b.del_yn,
       del_dt = b.del_dt
  FROM _bak_mat_materials_remediation_260624 b
 WHERE m.mat_cd = b.mat_cd
   AND (m.del_yn IS DISTINCT FROM b.del_yn OR m.del_dt IS DISTINCT FROM b.del_dt);

-- ── 방식2(백업 없을 때 폴백): 교정 전 상태가 del_yn='Y'였음을 명세로 재적용 ──
-- (apply.sql이 전부 'Y'→'N' 부활이었으므로, undo = 'N'→'Y' 재논리삭제)
-- 주의: del_dt는 원래 NULL이 아니었을 수 있으나 라이브 실측 시 del_yn='Y'행의 del_dt 원값 미보존이면
--       방식1(백업) 사용. 방식2는 del_dt를 now()로 둠(근사 복원).
-- UPDATE t_mat_materials
--    SET del_yn = 'Y', del_dt = COALESCE(del_dt, now())
--  WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094',
--                   'MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
--    AND del_yn IS DISTINCT FROM 'Y';

-- 검증: 10행 del_yn 원상('Y') 복귀 확인.
SELECT mat_cd, mat_nm, del_yn, del_dt FROM t_mat_materials
 WHERE mat_cd IN ('MAT_000246','MAT_000071','MAT_000075','MAT_000085','MAT_000094',
                  'MAT_000100','MAT_000103','MAT_000122','MAT_000143','MAT_000146')
 ORDER BY mat_cd;
</content>
