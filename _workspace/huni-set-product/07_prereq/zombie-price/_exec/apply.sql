-- ============================================================
-- apply.sql — 좀비 자재 2건 부활 라이브 COMMIT (래핑본)
-- 사용자 승인 완료. 실행 대상 = 자재 del_yn 'Y'→'N' 2 UPDATE만.
-- ★단가행(t_prc_component_prices)·배선(t_prd_product_materials) 일절 미변경(청구 불변).
-- 멱등 가드 WHERE del_yn='Y'. 단일 트랜잭션 all-or-nothing. 물리 DELETE 금지.
-- 선행: backup.sql 이 백업테이블을 만든 뒤 실행할 것.
-- ============================================================

\echo '=== APPLY: 좀비 부활 COMMIT 트랜잭션 시작 ==='
BEGIN;

UPDATE t_mat_materials
SET del_yn = 'N'
WHERE mat_cd IN ('MAT_000159','MAT_000119')
  AND del_yn = 'Y';

\echo '--- COMMIT 전 상태 (둘 다 del_yn=N 기대 · 멱등이면 이미 N) ---'
SELECT mat_cd, mat_nm, del_yn FROM t_mat_materials
WHERE mat_cd IN ('MAT_000159','MAT_000119') ORDER BY mat_cd;

COMMIT;
\echo '=== COMMIT 완료 ==='
