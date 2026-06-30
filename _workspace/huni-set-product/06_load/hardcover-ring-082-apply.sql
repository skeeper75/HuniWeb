-- ================================================================
-- hardcover-ring-082 APPLY (단일 트랜잭션 래핑·실 COMMIT)
-- 게이트: 05_gate/gate-verdict-hardcover-ring-082.md (CONDITIONAL GO) + 인간 승인 완료.
-- 백업: bak_t_prd_product_sets_setbuild_20260701_0041 (5행 스냅샷) + backup-20260701_0041.sql
-- DRY-RUN 입증: 제약위반0·멱등 delta0·복합PK 충돌0·S8 오염0·ROLLBACK 후 baseline 복귀.
-- 효과: 082 견적 0원(부모공식 0행) → PRICE≠0 (제본 30,000 + 내지 → A5·30p·양면 = 44,123원).
-- 적재 항목 27행: 부모공식 mint1 + 비목배선1 + 286 mint1 + 차원15(siz3/popt2/mat9/plate1)
--   + 공식 바인딩2 + 셋트행6. 표지/면지 ×2·면지유료는 BLOCKED(본 COMMIT 밖).
-- ================================================================
BEGIN;
\i hardcover-ring-082-load.sql
COMMIT;
