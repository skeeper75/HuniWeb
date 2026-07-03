---
id: product-216-clear-clipboard
type: product
anchor: t_prd_products/PRD_000216
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000216(prd_nm=투명클립보드·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(스탬프·기타 216 투명클립보드)·§3.8 판형 종이류만·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000130, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·CAT_000008)·홀더/클립보드(CAT_000130·축 미민팅)"}
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#투명클립보드", "#NEITHER-gap", "#비종이"]
updated: 2026-07-04
---

# 투명클립보드 (product-216-clear-clipboard)

투명클립보드(PRD_000216)는 **문구/홀더 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 투명(아크릴/PVC계) 클립보드 굿즈.

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 [[gap-goods-price-unloaded]].
- **자재**: active 2행 MAT_000295(A5용)·MAT_000296(A4용·MAT_TYPE.09)는 **규격 변형값**이지 substrate 아님 → `uses_material` 미배선.
- **비종이(투명판) → 판형 없음**(도메인 [HARD]): 공정 0행·옵션그룹 0행·`has_plate_size` 미배선.
- **카테고리**: 문구(CAT_000008·main) 배선. 홀더/클립보드(CAT_000130) 미민팅 → needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000216 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 자재행(전사) — 규격 변형값

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000216 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage | del_yn |
|---|---|---|---|---|
| MAT_000295 | A5용 | MAT_TYPE.09 | USAGE.07 | N |
| MAT_000296 | A4용 | MAT_TYPE.09 | USAGE.07 | N |
