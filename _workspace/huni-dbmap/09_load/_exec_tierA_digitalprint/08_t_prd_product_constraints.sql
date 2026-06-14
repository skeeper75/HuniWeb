-- =====================================================================
-- step 08 — t_prd_product_constraints (0행 — 본 파일럿 제약 없음)
-- 후가공 다중·박칼라 택1은 option_groups(SEL_TYPE/min/max)로 충족 → 별도 JSONLogic 불요.
--   R-QTY-PANSU(수량=판수 배수)는 GAP-PANSU(가격엔진 입력)이며 본 옵션레이어 제약 아님(attr-map §3.4).
-- 025 더미 RULE_001(금지테스트)=정리 대상(_cleanup_dummy.sql). 본 적재 미관여.
-- =====================================================================
SELECT '08: constraints — 0 rows (옵션그룹 SEL_TYPE 로 다중/택일 충족·판수=가격엔진)' AS step_08;
