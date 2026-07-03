-- ============================================================
-- 판형 배선 무결성 검사 (재발방지 상시 게이트) — 2026-07-04 신설
-- 정의[HARD]: 판형사이즈 = t_siz_sizes.impos_yn='Y' 인 것 OR 판걸이수 시트 판형(316x467/330x540/330x660).
-- t_prd_product_plate_sizes.siz_cd 가 유효 판형이 아니면(=완제품/item 사이즈 오배선) 결함.
-- ★가격 영향 여부(plate_comps)와 무관하게 결함으로 판정 — 데이터 위생 우선.
-- 사용: psql ... -f plate_wiring_integrity_check.sql · 결과 0행 = 정합, >0 = 오배선 결함.
-- ============================================================
\echo '=== [1] 오배선 결함: siz_cd 가 유효 판형(impos_yn=Y) 아님 ==='
SELECT pps.prd_cd, p.prd_nm, pps.siz_cd, s.siz_nm AS wired_as_plate, s.impos_yn,
       CASE WHEN EXISTS(SELECT 1 FROM t_prd_product_sizes ps WHERE ps.prd_cd=pps.prd_cd AND ps.siz_cd=pps.siz_cd AND ps.del_yn='N')
            THEN '완제품사이즈(item)를 판형으로 오배선' ELSE 'orphan 사이즈' END AS 진단
FROM t_prd_product_plate_sizes pps
 JOIN t_siz_sizes s ON s.siz_cd=pps.siz_cd
 JOIN t_prd_products p ON p.prd_cd=pps.prd_cd
WHERE pps.del_yn='N' AND s.impos_yn IS DISTINCT FROM 'Y'
ORDER BY p.prd_nm, pps.prd_cd, pps.siz_cd;

\echo '=== [2] 결함 요약(상품 수·링크 수) ==='
SELECT count(DISTINCT pps.prd_cd) AS 결함상품, count(*) AS 결함링크
FROM t_prd_product_plate_sizes pps JOIN t_siz_sizes s ON s.siz_cd=pps.siz_cd
WHERE pps.del_yn='N' AND s.impos_yn IS DISTINCT FROM 'Y';

\echo '=== [3] (참고) 현재 유효 판형 집합(impos_yn=Y) ==='
SELECT siz_cd, siz_nm FROM t_siz_sizes WHERE impos_yn='Y' AND del_yn='N' ORDER BY siz_cd;
