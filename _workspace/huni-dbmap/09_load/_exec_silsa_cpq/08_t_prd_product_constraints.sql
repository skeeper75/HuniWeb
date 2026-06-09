-- =====================================================================
-- step 08 — t_prd_product_constraints (R-GAKMOK · RULE_001) — BLOCKED(siz 의존)
-- R-GAKMOK: 각목(900이하)↔세로변 900이하, 각목(900초과)↔세로변 900초과 호환.
--   var=mat_cd(각목=material 재귀속·D-2 별 mat_cd 2개: MAT_000338/MAT_000339).
--   rule_cd=RULE_001(상품별 카운터·D5). rule_typ_cd=RULE_TYPE.01(호환). logic jsonb NOT NULL.
-- [BLOCKED] logic 의 siz_cd 멤버십 집합이 siz 76규격 미등록(가격트랙)으로 미완 → 본 트랜잭션 미적재.
--   각목 mat_cd(338/339)는 본 패키지 mint 로 충족되나, siz 차원 집합 부재로 constraint 는 DEFER.
--   siz 등록(가격트랙·인간승인) + 폼빌더 배열-멤버십 입력방식(F-1) 후 별도 적재 → _blocked/.
-- =====================================================================
SELECT '08: constraints — 0 rows now (R-GAKMOK GAP-DEFER: siz 76규격 미등록·F-1 폼빌더 미검증). _blocked/08_*.sql 참조' AS step_08;
