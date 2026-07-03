---
id: product-199-clear-fan
type: product
anchor: t_prd_products/PRD_000199
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000199(prd_nm=투명부채·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(과업명시 199 투명부채)·§0.1 use_yn=N 미출시·§3.10 NEITHER-gap·§4 적재 미완 정직표", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기(현재 미적재)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  use_yn: "N"          # 미출시(팬텀 가격 금지)
  min_qty: 1           # 단일 스칼라(본문 전사표 권위)
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#투명부채", "#NEITHER-gap", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 투명부채 (product-199-clear-fan)

투명부채(PRD_000199)는 **굿즈/악세사리 완제품 단품**(prd_typ_cd=`PRD_TYPE.01` · 셋트 부모/구성원
아님·`t_prd_product_sets` 미등록). ★현재 **use_yn=N 미출시** 상태다(정직 표기 — 팬텀 가격 금지).

- **가격(정직 GAP)**: 가격공식(`t_prd_product_price_formulas` 0행)도 고정가(`t_prd_product_prices` 0행)도
  **둘 다 없다** = NEITHER-gap(견적 원천 부재). "가격 있는 것처럼" 넣지 않고 [[gap-goods-neither]]로 정직 선언
  (O5 `derived_from` 예외). 채움 경로 = 상품마스터 고정가 verbatim 적재([[gap-goods-price-unloaded]]).
- **비종이 → 판형 없음**(도메인 [HARD]·팩 §3.8): `has_plate_size` 미배선. `t_prd_product_plate_sizes` 0행.
- **자재·공정 empty-shell**: `t_prd_product_materials` 0행·`t_prd_product_processes` 0행·옵션그룹 0행.
- **카테고리**: 여행/아웃도어(CAT_000181·main)·라이프(CAT_000010) — 두 축 노드 공유 axis/categories 미민팅
  → `in_category` 미배선(끊긴 링크 방지)·needs_axis 반환.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000199 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |
