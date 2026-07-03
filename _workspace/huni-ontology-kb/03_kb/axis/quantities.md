<!-- axis page: E8 quantity(bundle_qty) — 수량 그릇(상품 min/max/incr + bundle_qtys). -->
<!-- 디렉토리 명세 §1.1: axis/ = E3~E8(수량 포함). qty 노드는 셋트/일반 상품 수량규칙 per-product 원자. -->
<!-- 선례 qty-094(product-094-postcard-book-nodes.md)와 동형 형식. product 파일은 C2 소관이라 축 파일(여기)에 mint. -->

# 축: 수량규칙 (bundle_qty) — 상품 수량 그릇

수량 그릇 = 상품 마스터 컬럼(min_qty·max_qty·qty_incr·qty_unit_typ_cd) + (있으면)
t_prd_product_bundle_qtys 행. bundle_qtys 0행이면 수량 UI 권위 = 상품 min/max/incr 스칼라
([[qty-system-audit-260702]]). has_qty_rule(product→bundle_qty)은 상품 노드(Stage C2)가 배선.

## 문구 셋트(SB-1) 수량규칙 — Stage C1(okb-knowledge-builder 260703)

### [qty-176] 먼슬리플래너 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000176
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000176 min_qty/max_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "키:PRD_000176 (0행 — bundle_qtys 미등록)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/500/1)", bdl_unit_typ_cd: "QTY_UNIT.03", bundle_qtys_rows: 0}
- 본문: 먼슬리플래너 수량 그릇 = 상품 마스터 컬럼(min 1·max 500·incr 1·단위 QTY_UNIT.03). t_prd_product_bundle_qtys 0행(수량 UI 권위=상품 스칼라). has_qty_rule은 상품 노드(Stage C2)가 배선.

### [qty-177] 스프링노트 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000177
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000177 min_qty/max_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "키:PRD_000177 (0행 — bundle_qtys 미등록)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.03", bundle_qtys_rows: 0}
- 본문: 스프링노트 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1·단위 QTY_UNIT.03). t_prd_product_bundle_qtys 0행. has_qty_rule은 상품 노드(Stage C2)가 배선.

### [qty-178] 스프링수첩 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000178
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000178 min_qty/max_qty/qty_incr/qty_unit_typ_cd", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_bundle_qtys.csv", source_locator: "키:PRD_000178 (0행 — bundle_qtys 미등록)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 4/500/4·★incr=4 특이)", bdl_unit_typ_cd: "QTY_UNIT.03", bundle_qtys_rows: 0}
- 본문: 스프링수첩 수량 그릇 = 상품 마스터 컬럼(min 4·max 500·incr 4·단위 QTY_UNIT.03). ★증분 incr=4가 특이(4·8·12… 단위 주문). t_prd_product_bundle_qtys 0행. has_qty_rule은 상품 노드(Stage C2)가 배선.
