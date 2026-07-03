-- UNDO: 상품악세사리 Phase 1 가격 적재 되돌리기
-- 이번 세션이 넣은 apply_ymd='2026-07-03' 34행만 삭제(다른 apply_ymd·다른 상품 무접촉).
\set ON_ERROR_STOP on
BEGIN;
DELETE FROM t_prd_template_prices
WHERE apply_ymd='2026-07-03'
  AND tmpl_cd IN ('TMPL-000005','TMPL-000029','TMPL-000006','TMPL-000012','TMPL-000030',
    'TMPL-000038','TMPL-000039','TMPL-000040','TMPL-000041','TMPL-000056','TMPL-000057',
    'TMPL-000058','TMPL-000059','TMPL-000060','TMPL-000061','TMPL-000062','TMPL-000063',
    'TMPL-000064','TMPL-000065','TMPL-000066','TMPL-000042','TMPL-000043','TMPL-000044',
    'TMPL-000045','TMPL-000046','TMPL-000047','TMPL-000048','TMPL-000049','TMPL-000050',
    'TMPL-000051','TMPL-000052','TMPL-000053','TMPL-000054','TMPL-000055');
\echo '=== UNDO 후 악세사리 priced 개수(0 기대) ==='
SELECT count(*) FROM t_prd_template_prices tp JOIN t_prd_templates t ON t.tmpl_cd=tp.tmpl_cd
WHERE t.base_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015';
-- 실행: 기본 ROLLBACK. 실제 되돌리려면 apply.sh 처럼 ROLLBACK→COMMIT 치환.
ROLLBACK;
