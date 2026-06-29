-- 본 등록·매핑 롤백 (필요 시)
BEGIN;
DELETE FROM t_prd_product_plate_sizes WHERE siz_cd IN ('SIZ_000521','SIZ_000522');
DELETE FROM t_siz_sizes WHERE siz_cd IN ('SIZ_000521','SIZ_000522');
COMMIT;
