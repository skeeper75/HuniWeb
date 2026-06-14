-- =====================================================================
-- step 08 — t_prd_product_constraints (스티커 4상품 · 0행)
--   인쇄/종이/커팅(택1)·화이트별색(택1)은 option_groups.sel_typ_cd/min/max 로 충족 → JSONLogic 불요.
--   수량배수(증가 8/4/2/1/1000)는 t_prd_products MIN/MAX/INCR 범위 — 옵션레이어 제약 아님(attribute-entity-map §3.4).
--   캐스케이드(자재→커팅 disable 등)는 스티커 L1 부재(종이↔커팅 자유조합).
-- 본 적재 constraints 0행. 손편집 금지.
-- =====================================================================
\echo '   constraints: 0행 (sel_typ 로 충족, 캐스케이드 없음)'
