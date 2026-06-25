-- ============================================================================
-- backup-ext.sql — 동형 전파 2차(남은 6셋트) 물리 백업 스냅샷
-- 생성: hsp-load-executor · 시점 백업(COMMIT 직전) · 영향 행만 복제
-- 백업 접미사 <YYYYMMDD_HHMM>은 실행 시 치환(setbuild_ext_<ts>)
-- 영향 테이블: t_prd_product_sets(6셋트 26행) · t_prd_products(6 부모행)
-- 비파괴: CREATE TABLE AS SELECT(원본 불변) · undo-ext.sql가 이 스냅샷으로 복원
-- ============================================================================

-- [B1] 6셋트 26 구성원 행 스냅샷
CREATE TABLE bak_t_prd_product_sets_setbuild_ext_:ts AS
SELECT * FROM t_prd_product_sets
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');

-- [B2] 6 부모상품 행 스냅샷 (prd_typ_cd 04 원상)
CREATE TABLE bak_t_prd_products_setbuild_ext_:ts AS
SELECT * FROM t_prd_products
 WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');

-- 백업 행수 검증
SELECT 'bak_sets'    AS tbl, count(*) AS rows FROM bak_t_prd_product_sets_setbuild_ext_:ts
UNION ALL
SELECT 'bak_products', count(*) FROM bak_t_prd_products_setbuild_ext_:ts;
