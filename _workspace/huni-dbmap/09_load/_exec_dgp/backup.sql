-- =====================================================================
-- backup.sql — 디지털인쇄 가격엔진 적재 before-state 캡처 (read-only SELECT만)
--   신규 INSERT 트랙이라 "되살릴 행"은 없다. 대신:
--     (1) 신규 키 부재 확인 — 적재 전 PRF_DGP_*·COMP_PAPER·바인딩·용지비가 모두 없어야 함
--         (이미 있으면 멱등 INSERT 가 건드리지 않으므로 적재/롤백 안전성 판단 근거).
--     (2) 영향 5테이블 현행 행수 — 적재 후 +147(또는 0 재실행) 검증 기준선.
--   DB 무변경(SELECT만). backup.sh 가 타임스탬프 파일로 결과를 덤프한다.
-- =====================================================================
\echo '== before-state (1) 신규 키 부재 확인 (전부 0 이어야 적재 깨끗) =='
SELECT 'price_formulas PRF_DGP_*' AS chk, count(*) AS cnt
  FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_DGP_%'
UNION ALL
SELECT 'price_components COMP_PAPER', count(*)
  FROM t_prc_price_components WHERE comp_cd = 'COMP_PAPER'
UNION ALL
SELECT 'formula_components frm_cd PRF_DGP_*', count(*)
  FROM t_prc_formula_components WHERE frm_cd LIKE 'PRF_DGP_%'
UNION ALL
SELECT 'component_prices COMP_PAPER@SIZ_000499', count(*)
  FROM t_prc_component_prices WHERE comp_cd = 'COMP_PAPER' AND siz_cd = 'SIZ_000499'
UNION ALL
SELECT 'product_price_formulas frm_cd PRF_DGP_*', count(*)
  FROM t_prd_product_price_formulas WHERE frm_cd LIKE 'PRF_DGP_%';

\echo '== before-state (2) 영향 5테이블 현행 총 행수 (적재 후 +147 검증 기준선) =='
SELECT 't_prc_price_formulas' AS tbl, count(*) AS rows_now FROM t_prc_price_formulas
UNION ALL SELECT 't_prc_price_components', count(*) FROM t_prc_price_components
UNION ALL SELECT 't_prc_formula_components', count(*) FROM t_prc_formula_components
UNION ALL SELECT 't_prc_component_prices', count(*) FROM t_prc_component_prices
UNION ALL SELECT 't_prd_product_price_formulas', count(*) FROM t_prd_product_price_formulas
ORDER BY tbl;
