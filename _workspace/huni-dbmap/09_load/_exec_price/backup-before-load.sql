-- backup-before-load.sql — 가격(t_prc_*) 적재 전 스냅샷 쿼리 (read-only)
-- 생성: gen_safety_sql.py (손편집 금지). COPY ... TO STDOUT 만 — DB 변경 0.
-- 셸(backup-before-load.sh)이 stdout 을 backup_<runts>/before_prc_counts.csv 로 리다이렉트.
-- 가격 5 테이블은 라이브 EMPTY → 적재 전 행수=0 을 기록(되돌림 안전 근거).
-- 코드행(PRC_COMPONENT_TYPE.06) 선존여부도 떠둔다(선존이면 언두가 보존해야 함).

COPY (SELECT 't_prc_price_formulas' AS tbl, count(*) AS cnt FROM t_prc_price_formulas UNION ALL SELECT 't_prc_price_components', count(*) FROM t_prc_price_components UNION ALL SELECT 't_prc_formula_components', count(*) FROM t_prc_formula_components UNION ALL SELECT 't_prc_component_prices', count(*) FROM t_prc_component_prices UNION ALL SELECT 't_prd_product_price_formulas', count(*) FROM t_prd_product_price_formulas UNION ALL SELECT 't_cod_base_codes:PRC_COMPONENT_TYPE.06', count(*) FROM t_cod_base_codes WHERE cod_cd = 'PRC_COMPONENT_TYPE.06' ORDER BY tbl) TO STDOUT WITH (FORMAT csv, HEADER true);

