-- R1 부자재 오염 논리삭제(del_yn=Y) — 결정론 안전 교정
-- 마스터(t_mat_materials) 미터치·상품 링크(t_prd_product_materials)만
-- [HARD] 실 COMMIT은 인간 승인 후. DRY-RUN(BEGIN/ROLLBACK)으로 선검증.

-- PRD_000020 ← MAT_000138 젤리볼펜(가칭) (부속물 오염)
UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000020' AND mat_cd='MAT_000138' AND del_yn='N';

-- PRD_000020 ← MAT_000139 지비츠부속 (부속물 오염)
UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000020' AND mat_cd='MAT_000139' AND del_yn='N';

-- PRD_000042 ← MAT_000128 면끈 (부속물 오염)
UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000042' AND mat_cd='MAT_000128' AND del_yn='N';

-- PRD_000042 ← MAT_000129 아크릴키링고리 (부속물 오염)
UPDATE t_prd_product_materials SET del_yn='Y', upd_dt=now()
 WHERE prd_cd='PRD_000042' AND mat_cd='MAT_000129' AND del_yn='N';

