-- =====================================================================
-- [DEPRECATED·FINDING-1 보정] 이 파일은 더 이상 사용하지 않음.
-- L1 차원 LINK 선적재(product-materials/processes INSERT)는 _l1_link_preload.sql 로 분리됨.
--   사유: product-link INSERT = L1 차원행 생성 → L2 옵션레이어 트랜잭션(apply.sql) 경계 밖.
--   apply.sql 은 L1 LINK 를 포함하지 않는 순수 L2 적재. _l1_link_preload.sql 은 별도 인간 승인 선행.
-- 본 파일은 gen_load_sql.py 가 더 이상 생성/참조하지 않음(stale stub).
-- =====================================================================
SELECT '01_product_links.sql DEPRECATED → _l1_link_preload.sql (FINDING-1 보정)' AS deprecated;
