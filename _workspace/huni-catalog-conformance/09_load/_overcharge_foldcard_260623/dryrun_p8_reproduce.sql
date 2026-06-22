-- dryrun_p8_reproduce.sql — P8-1 택일 분리 SQL 재현 (Django 환경 부재 시 폴백)
-- pricing.py:444-475(_evaluate_formula proc_sels 분기) + :38 NON_QTY_DIMS 충실 모사.
-- 라이브 트랜잭션 + ROLLBACK. 실 COMMIT 없음. unit_price 미변경.
-- 실행: psql ... -f dryrun_p8_reproduce.sql  (BEFORE 25000 / 부분교정 25000 / 전체교정 6000 / verbatim 불변)
\set ON_ERROR_STOP on
BEGIN;

\echo '=== BEFORE 교정: proc_cd NULL·is_proc=False → 4개 자동합산 ==='
SELECT 'BEFORE' AS phase, sum(unit_price) AS fold_total,
       string_agg(comp_cd||'='||unit_price::text, ', ' ORDER BY comp_cd) AS detail
FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' AND min_qty=1;

-- STEP 1 교정(실재분): 3FOLD=PROC_000060
UPDATE t_prc_component_prices SET proc_cd='PROC_000060'
  WHERE comp_cd='COMP_FOLD_LEAF_3FOLD' AND (proc_cd IS DISTINCT FROM 'PROC_000060');
UPDATE t_prc_price_components SET use_dims='["proc_cd","min_qty","proc_grp:PROC_000056"]'::jsonb
  WHERE comp_cd='COMP_FOLD_LEAF_3FOLD';

\echo ''
\echo '=== AFTER 부분교정(3FOLD만)·3단접지 택일: 미교정 3개 여전히 합산(BLOCKED 한계) ==='
WITH sel AS (SELECT 'PROC_000060'::text AS chosen)
SELECT 'AFTER_부분' AS phase,
  sum(CASE WHEN cp.comp_cd='COMP_FOLD_LEAF_3FOLD' AND cp.proc_cd=(SELECT chosen FROM sel) THEN cp.unit_price
           WHEN cp.comp_cd='COMP_FOLD_LEAF_3FOLD' THEN 0
           ELSE cp.unit_price END) AS fold_total
FROM t_prc_component_prices cp WHERE cp.comp_cd LIKE 'COMP_FOLD_LEAF_%' AND cp.min_qty=1;

\echo ''
\echo '=== AFTER 전체교정 what-if(4개 모두 proc_cd 충전 가정)·3단접지 택일: 6000 분리 ==='
SELECT 'AFTER_전체' AS phase,
  sum(CASE WHEN comp_cd='COMP_FOLD_LEAF_3FOLD' THEN unit_price ELSE 0 END) AS fold_total,
  '6000 기대(3단만·나머지 proc 불일치 탈락)' AS note
FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' AND min_qty=1;

\echo ''
\echo '=== verbatim 게이트: 단가행 합 불변 ==='
SELECT comp_cd, count(*) rows, sum(unit_price) sum_price
FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_FOLD_LEAF_%' GROUP BY comp_cd ORDER BY comp_cd;

ROLLBACK;
\echo '[ROLLBACK] 라이브 무변경.'
