-- 캘린더 5상품 종이 드롭다운 정합 — 부속(비종이) 논리삭제 (round-13 · GAP-CAL-2)
-- 작성 2026-07-03. 대상 = t_prd_product_materials 의 부속행(mat_typ_cd<>MAT_TYPE.01)만.
-- [HARD] 논리삭제(del_yn='Y')만. 물리 DELETE 없음. 마스터 t_mat_materials 미터치.
-- [HARD] 실 COMMIT은 인간 승인 + webadmin 실화면(종이 드롭다운 부속 미노출·가격시뮬 종이비 정상) 확인 후.
--        아래는 트랜잭션 래핑 — 승인 전에는 마지막 COMMIT을 ROLLBACK으로 두고 검증만.
-- 멱등: WHERE pm.del_yn='N' 가드 → 재실행 시 0행 UPDATE.
-- 정확 대상 6행: 108(삼각대싸바리 MAT_000252·링블랙 MAT_000253),
--                109(삼각대종이 MAT_000254·링블랙 MAT_000253), 111(링블랙), 112(링블랙).

BEGIN;

UPDATE t_prd_product_materials pm
SET del_yn = 'Y'
FROM t_mat_materials m
WHERE pm.mat_cd = m.mat_cd
  AND pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
  AND m.mat_typ_cd <> 'MAT_TYPE.01'   -- 부속(.07 부속 · .15 싸바리) = 종이 아님
  AND pm.del_yn = 'N';                 -- 멱등 가드
-- 기대: UPDATE 6

-- 사후 검증: 5상품 활성 자재가 전부 종이(MAT_TYPE.01)여야, 부속 0
SELECT pm.prd_cd,
       count(*) FILTER (WHERE pm.del_yn='N') AS active,
       count(*) FILTER (WHERE pm.del_yn='N' AND m.mat_typ_cd='MAT_TYPE.01') AS papers,
       count(*) FILTER (WHERE pm.del_yn='N' AND m.mat_typ_cd<>'MAT_TYPE.01') AS nonpaper
FROM t_prd_product_materials pm JOIN t_mat_materials m ON pm.mat_cd=m.mat_cd
WHERE pm.prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112')
GROUP BY pm.prd_cd ORDER BY pm.prd_cd;
-- 기대: nonpaper=0 전 상품. papers = 108:8 109:7 110:10 111:22 112:3

-- 승인 전: 검증만 하고 되돌린다. 승인 후: ROLLBACK → COMMIT 으로 교체.
ROLLBACK;
-- COMMIT;
