-- ============================================================
-- 검토 필요(자동 적용 금지) — 인간 판단 후 개별 결정
-- ============================================================

-- [A] 사이즈 MISMATCH: 기존 non-null 값이 권위와 다름 (덮어쓰기 여부 결정)
-- 프리미엄엽서 SIZ_000002[98 x 98 mm] 현재(12,1000,12) -> 권위(12,10000,12)
-- UPDATE t_prd_product_sizes SET min_qty=12, max_qty=10000, qty_incr=12 WHERE prd_cd='PRD_000016' AND siz_cd='SIZ_000002' AND del_yn='N';

-- [B] 상품 BAND_CONFLICT: 상품마스터 최소 < 가격표 최소구간 → 인상 제안
--     ※ 대부분 박(FOIL) 등 옵션 조건부 최소구간 — 인상 시 무옵션/기본 주문 하한도 함께 막힘. 신중.
-- 무선책자(PRD_000069) 현재min=2 권위min=2 가격표min=10 -> 제안min=10 | 권위min 2 < 가격표최소구간 10 → 10 채택
-- UPDATE t_prd_products SET min_qty=10 WHERE prd_cd='PRD_000069';

-- PUR책자(PRD_000070) 현재min=2 권위min=2 가격표min=10 -> 제안min=10 | 권위min 2 < 가격표최소구간 10 → 10 채택
-- UPDATE t_prd_products SET min_qty=10 WHERE prd_cd='PRD_000070';

-- 2단접지카드(PRD_000027) 현재min=8 권위min=8 가격표min=10 -> 제안min=10 | 권위min 8 < 가격표최소구간 10 → 10 채택
-- UPDATE t_prd_products SET min_qty=10 WHERE prd_cd='PRD_000027';

-- 3단접지카드(PRD_000029) 현재min=8 권위min=8 가격표min=10 -> 제안min=10 | 권위min 8 < 가격표최소구간 10 → 10 채택
-- UPDATE t_prd_products SET min_qty=10 WHERE prd_cd='PRD_000029';

-- 프리미엄명함(PRD_000031) 현재min=100 권위min=100 가격표min=200 -> 제안min=200 | 권위min 100 < 가격표최소구간 200 → 200 채택
-- UPDATE t_prd_products SET min_qty=200 WHERE prd_cd='PRD_000031';

-- 펄명함(PRD_000034) 현재min=100 권위min=100 가격표min=200 -> 제안min=200 | 권위min 100 < 가격표최소구간 200 → 200 채택
-- UPDATE t_prd_products SET min_qty=200 WHERE prd_cd='PRD_000034';

