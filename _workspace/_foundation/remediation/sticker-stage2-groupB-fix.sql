-- sticker-stage2-groupB-fix.sql — A6/100x140 사이즈 제거 (인간 승인 2026-06-28·'사이즈 빼기')
-- 권위 가격표에 A6(SIZ_196)·100x140(SIZ_058) 단가 부재 → 논리삭제(del_yn=Y·물리삭제 0)
\set ON_ERROR_STOP on
BEGIN;
DROP TABLE IF EXISTS bak_sticker_s2b_sizes_260628;
CREATE TABLE bak_sticker_s2b_sizes_260628 AS
  SELECT * FROM t_prd_product_sizes
  WHERE (prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196')
     OR (prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058');
UPDATE t_prd_product_sizes SET del_yn='Y', del_dt=now(), upd_dt=now()
 WHERE ((prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196')
     OR (prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058')) AND del_yn='N';
\echo '== 제거 후 active 잔존(기대 0) =='
SELECT count(*) AS active_left FROM t_prd_product_sizes
 WHERE ((prd_cd IN('PRD_000052','PRD_000053','PRD_000054') AND siz_cd='SIZ_000196')
     OR (prd_cd IN('PRD_000062','PRD_000063') AND siz_cd='SIZ_000058')) AND del_yn='N';
COMMIT;
\echo '== 그룹B COMMIT 완료 (undo=bak_sticker_s2b_sizes_260628) =='
