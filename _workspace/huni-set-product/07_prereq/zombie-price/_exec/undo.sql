-- ============================================================
-- undo.sql — 좀비 부활 역연산 (사후검증 불일치 시에만 실행)
-- 부활(del_yn N)을 백업 기준으로 재논리삭제(del_yn Y, del_dt 백업값 복원).
-- 백업 테이블: bak_t_mat_materials_zombie_20260624_1250 (부활 전 상태 보존).
-- 멱등 가드 WHERE del_yn='N'. 물리 DELETE 없음.
-- ============================================================

\echo '=== UNDO: 부활 역연산 트랜잭션 시작 ==='
BEGIN;

UPDATE t_mat_materials m
SET del_yn = b.del_yn,
    del_dt = b.del_dt
FROM bak_t_mat_materials_zombie_20260624_1250 b
WHERE m.mat_cd = b.mat_cd
  AND m.mat_cd IN ('MAT_000159','MAT_000119')
  AND m.del_yn = 'N';

\echo '--- UNDO 후 상태 (백업과 동일: del_yn=Y 기대) ---'
SELECT m.mat_cd, m.del_yn AS now_del, b.del_yn AS bak_del, m.del_dt AS now_dt, b.del_dt AS bak_dt
FROM t_mat_materials m
JOIN bak_t_mat_materials_zombie_20260624_1250 b ON m.mat_cd=b.mat_cd
ORDER BY m.mat_cd;

COMMIT;
\echo '=== UNDO COMMIT 완료 ==='
