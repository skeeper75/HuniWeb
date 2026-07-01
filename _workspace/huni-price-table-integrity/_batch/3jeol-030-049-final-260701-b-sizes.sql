-- 049(와이드접지리플렛) 완제품 사이즈 등록 -- 2026-07-01
-- 권위(판걸이수 시트 행74: 재단640x297·작업646x303)와 정확히 일치하는 SIZ_000055 기존재 확인(search-before-mint, 신규 mint 불필요)
BEGIN;
INSERT INTO t_prd_product_sizes (prd_cd,siz_cd,dflt_yn,disp_seq,reg_dt,del_yn)
SELECT 'PRD_000049','SIZ_000055','Y',1,now(),'N'
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_sizes WHERE prd_cd='PRD_000049' AND siz_cd='SIZ_000055');
COMMIT;
