-- UNDO — 캘린더 부속 논리삭제 되돌리기 (round-13 · GAP-CAL-2)
-- 작성 2026-07-03. load.sql COMMIT 후 문제 발생 시 6행 부속 링크를 활성(del_yn='N') 복원.
-- [HARD] 정확히 load.sql이 건드린 6행만 복원(mat_typ_cd<>MAT_TYPE.01·5상품·del_yn='Y').
--        주의: 이 UNDO는 "부속을 종이 드롭다운에 되살림" — 원상 회귀용일 뿐 정답 아님.
-- 멱등: WHERE pm.del_yn='Y' 가드.

BEGIN;

UPDATE t_prd_product_materials pm
SET del_yn = 'N'
FROM t_mat_materials m
WHERE pm.mat_cd = m.mat_cd
  AND pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
  AND m.mat_typ_cd <> 'MAT_TYPE.01'
  AND pm.del_yn = 'Y';
-- 기대: UPDATE 6 (load.sql 적용분 복원)

SELECT pm.prd_cd, pm.mat_cd, m.mat_nm, m.mat_typ_cd, pm.del_yn
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
  AND m.mat_typ_cd<>'MAT_TYPE.01' ORDER BY pm.prd_cd, pm.mat_cd;
-- 기대: 6행 del_yn='N'

ROLLBACK;
-- COMMIT;
