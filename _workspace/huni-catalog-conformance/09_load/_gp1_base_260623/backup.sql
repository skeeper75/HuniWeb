-- backup.sql — §21 R-GP4-1 물리 백업(read-only 스냅샷)
-- 대상 prd의 기존 product_prices 행을 bak 테이블로 복제. 적재 전 실행.
DROP TABLE IF EXISTS bak_t_prd_product_prices_gp1base_20260623;
CREATE TABLE bak_t_prd_product_prices_gp1base_20260623 AS
SELECT * FROM t_prd_product_prices WHERE prd_cd IN ('PRD_000185','PRD_000196','PRD_000205','PRD_000210','PRD_000211','PRD_000212','PRD_000219','PRD_000223','PRD_000224','PRD_000225','PRD_000235','PRD_000236','PRD_000237','PRD_000248','PRD_000251','PRD_000253','PRD_000256','PRD_000257','PRD_000258','PRD_000259','PRD_000260','PRD_000263','PRD_000265','PRD_000266','PRD_000272','PRD_000275');
SELECT count(*) AS backup_rows FROM bak_t_prd_product_prices_gp1base_20260623;
