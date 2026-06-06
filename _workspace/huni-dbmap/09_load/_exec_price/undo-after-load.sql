-- undo-after-load.sql — 가격(t_prc_*) 적재를 무손실 되돌리는 언두 데이터 연산 (round-5)
-- 생성: gen_safety_sql.py (손편집 금지).
--
-- 본 파일은 BEGIN/CREATE TEMP/\copy FROM 을 포함하지 않는다 — undo.sh 가 리터럴 경로로
-- _undo_keys 를 선적재한 뒤 이 파일을 \i 한다. (psql v18 \copy 는 :'var' 경로 보간 미지원.)
-- COMMIT/ROLLBACK 도 undo.sh 가 주입. 기본 = DRY-RUN(ROLLBACK).
--
-- 5 t_prc_* 테이블은 라이브 EMPTY 였으므로 적재행 = 신규행 전부 → DELETE-all 등가.
-- 다만 inserted_keys_<runts>.csv 로그키만 DELETE 하여, 만에 하나 선존행이 있어도 불가침.
-- 코드행(t_cod_base_codes)은 로그에 있을 때만(=이번에 신설했을 때만) DELETE.

\echo '>> undo DELETE t_prd_product_price_formulas (logged new keys only)'
DELETE FROM t_prd_product_price_formulas USING _undo_keys
 WHERE _undo_keys.tbl = 't_prd_product_price_formulas'
   AND t_prd_product_price_formulas.prd_cd::text = split_part(_undo_keys.pk_vals, '|', 1)
   AND t_prd_product_price_formulas.frm_cd::text = split_part(_undo_keys.pk_vals, '|', 2);

\echo '>> undo DELETE t_prc_component_prices (logged new keys only)'
DELETE FROM t_prc_component_prices USING _undo_keys
 WHERE _undo_keys.tbl = 't_prc_component_prices'
   AND t_prc_component_prices.comp_price_id::text = split_part(_undo_keys.pk_vals, '|', 1);

\echo '>> undo DELETE t_prc_formula_components (logged new keys only)'
DELETE FROM t_prc_formula_components USING _undo_keys
 WHERE _undo_keys.tbl = 't_prc_formula_components'
   AND t_prc_formula_components.frm_cd::text = split_part(_undo_keys.pk_vals, '|', 1)
   AND t_prc_formula_components.comp_cd::text = split_part(_undo_keys.pk_vals, '|', 2);

\echo '>> undo DELETE t_prc_price_components (logged new keys only)'
DELETE FROM t_prc_price_components USING _undo_keys
 WHERE _undo_keys.tbl = 't_prc_price_components'
   AND t_prc_price_components.comp_cd::text = split_part(_undo_keys.pk_vals, '|', 1);

\echo '>> undo DELETE t_prc_price_formulas (logged new keys only)'
DELETE FROM t_prc_price_formulas USING _undo_keys
 WHERE _undo_keys.tbl = 't_prc_price_formulas'
   AND t_prc_price_formulas.frm_cd::text = split_part(_undo_keys.pk_vals, '|', 1);

\echo '>> undo DELETE t_cod_base_codes (logged new keys only)'
DELETE FROM t_cod_base_codes USING _undo_keys
 WHERE _undo_keys.tbl = 't_cod_base_codes'
   AND t_cod_base_codes.cod_cd::text = split_part(_undo_keys.pk_vals, '|', 1);

-- (BEGIN/COMMIT/ROLLBACK·_undo_keys 선적재는 undo.sh 가 리터럴 경로로 래핑.)
