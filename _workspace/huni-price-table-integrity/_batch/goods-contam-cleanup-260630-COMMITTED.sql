-- 굿즈 자재 오염 정리 (6상품 9매핑·2026-06-30·사용자 승인)
-- 비기재 굿즈 부속이 용지성 상품 product_materials에 오적재→논리삭제. 복수 기본자재라 기본이전 불요.
BEGIN;
UPDATE t_prd_product_materials SET del_yn='Y', del_dt=now(), upd_dt=now()
WHERE COALESCE(del_yn,'N')<>'Y' AND (prd_cd,mat_cd) IN (
  ('PRD_000037','MAT_000138'),('PRD_000037','MAT_000139'),('PRD_000037','MAT_000140'),('PRD_000037','MAT_000141'),
  ('PRD_000047','MAT_000129'),('PRD_000048','MAT_000129'),
  ('PRD_000072','MAT_000003'),('PRD_000077','MAT_000003'),('PRD_000082','MAT_000003'));
\echo '--- 사후: 상품별 잔여 활성자재 + 기본자재 수 ---'
SELECT pm.prd_cd, count(*) 잔여, sum(CASE WHEN dflt_yn='Y' THEN 1 ELSE 0 END) 기본
FROM t_prd_product_materials pm WHERE pm.prd_cd IN ('PRD_000037','PRD_000047','PRD_000048','PRD_000072','PRD_000077','PRD_000082') AND COALESCE(pm.del_yn,'N')<>'Y'
GROUP BY pm.prd_cd ORDER BY pm.prd_cd;
\echo '--- 사후: 오염자재 잔존 여부(0 기대) ---'
SELECT count(*) FROM t_prd_product_materials WHERE COALESCE(del_yn,'N')<>'Y' AND (prd_cd,mat_cd) IN (('PRD_000037','MAT_000138'),('PRD_000047','MAT_000129'),('PRD_000072','MAT_000003'));
COMMIT;
\echo '=== ROLLBACK (COMMIT 완료) ==='
