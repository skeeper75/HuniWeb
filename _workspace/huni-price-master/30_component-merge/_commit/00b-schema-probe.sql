-- READ-ONLY: 3개 대상 테이블의 PK/UNIQUE 제약 + NOT NULL 컬럼(ON CONFLICT 타깃·백업 정확성용)
\pset footer off
SELECT c.conname, c.contype, pg_get_constraintdef(c.oid) def, t.relname
FROM pg_constraint c JOIN pg_class t ON c.conrelid=t.oid
WHERE t.relname IN ('t_prc_price_components','t_prc_formula_components','t_prc_component_prices')
  AND c.contype IN ('p','u') ORDER BY t.relname, c.contype;

-- NOT NULL 컬럼 (INSERT 컬럼목록 충분성 확인)
SELECT table_name, column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name IN ('t_prc_price_components','t_prc_formula_components')
  AND is_nullable='NO'
ORDER BY table_name, ordinal_position;
