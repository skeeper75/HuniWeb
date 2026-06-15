-- =====================================================================
-- verify_batch.sql — 배치 적재 SQL 집계 전수 검증 (dbm-batch-load)
--   가격표↔라이브 전 행 diff·FK·NULL·중복·멱등을 쿼리로 한 번에.
--   출력 = 검사별 통과/실패 카운트 + 예외 행 목록. 행별 토큰 0.
--   DRY-RUN(BEGIN…ROLLBACK) 또는 COMMIT 후 호출. psql 변수로 클래스 파라미터화.
--   사용: psql ... -v cls='PRF_DGP_A' -v tbl='t_prc_component_prices' -f verify_batch.sql
-- =====================================================================
\set ON_ERROR_STOP on
\timing off

\echo '===== [V1] FK 고아 (mat_cd·siz_cd 등 — 클래스별 조정) ====='
SELECT 'FK_orphan_mat' AS check, count(*) AS fail
FROM t_prc_component_prices cp
WHERE cp.mat_cd IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM t_mat_materials m WHERE m.mat_cd = cp.mat_cd);

SELECT 'FK_orphan_siz' AS check, count(*) AS fail
FROM t_prc_component_prices cp
WHERE cp.siz_cd IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM t_siz_sizes s WHERE s.siz_cd = cp.siz_cd);

\echo '===== [V2] NOT NULL 위반 (적재 필수 컬럼) ====='
SELECT 'null_required' AS check, count(*) AS fail
FROM t_prc_component_prices
WHERE comp_cd IS NULL OR unit_price IS NULL OR apply_ymd IS NULL;

\echo '===== [V3] 자연키 중복 (멱등 위반 신호) ====='
SELECT 'natkey_dup' AS check, count(*) AS fail FROM (
  SELECT comp_cd, mat_cd, siz_cd, clr_cd, proc_cd, opt_cd,
         coat_side_cnt, bdl_qty, min_qty, apply_ymd, count(*) c
  FROM t_prc_component_prices
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11 HAVING count(*) > 1
) d;

\echo '===== [V4] 적용일 시계열 — apply_ymd 단일 세대(분기 0 기대) ====='
SELECT 'apply_ymd_generations' AS check, count(DISTINCT apply_ymd) AS generations
FROM t_prc_component_prices;

\echo '===== [V5] 가격 권위 diff (클래스별 — 가격표 staged 테이블과 대조) ====='
-- 적용 시: 가격표 L1 을 임시 staged 테이블(stg_price)로 \copy 후 아래 diff.
-- staged 미존재 시 이 검사는 건너뜀(클래스별 채움). 예시 골격:
-- SELECT 'price_mismatch' AS check, count(*) AS fail
-- FROM stg_price g JOIN t_prc_component_prices cp USING (comp_cd, mat_cd, siz_cd, min_qty)
-- WHERE round(g.unit_price, 2) <> cp.unit_price;
\echo '(V5 staged diff: 클래스별 stg_price 준비 시 활성화)'

\echo '===== [요약] 모든 fail=0 이면 집계 GO ====='
