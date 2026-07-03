---
id: product-194-water-book-bottle
type: product
anchor: t_prd_products/PRD_000194
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000194 (prd_nm=워터북보틀·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000194 formula 0행 + t_prd_product_prices.csv 키:PRD_000194 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈·§3.10 GAP-GD-1 NEITHER-gap·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000328, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000269, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: uses_material, target: material-MAT_000343, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: references, target: gap-goods-neither, note: "가격 공식·고정가 둘 다 0행(견적 원천 부재)·O5 gap 선언"}
props:
  prd_typ_cd: PRD_TYPE.01
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: Y
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: Y
  del_yn: N
  archetype: "NEITHER-gap(공식·고정가 둘 다 없음·견적 원천 부재)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000328 데코소품 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(워터북보틀 구성)", "조건 탐색(데코 굿즈)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#비종이류"]
updated: 2026-07-04
---

# 워터북보틀 (product-194-water-book-bottle)

워터북보틀(PRD_000194)은 **라이프/데코소품 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 보틀). 셋트 아님
(단품). ★가격은 **NEITHER-gap** — 가격공식·고정가가 **둘 다 0행**이라 견적 원천이 없다([[gap-goods-neither]]).

- **가격 GAP**: 상품마스터 굿즈 시트 + 실무진 가격표 → §26·§7 dbmap 적재 대기.
- **판형 없음**: 보틀(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **자재**: 활성 substrate 2종(워터북보틀 본체·500ml 용량 변형). 축 노드 미민팅 → uses_material 미배선(needs_axis·BOM 표 권위).
- **카테고리**: CAT_000010 라이프(main)·CAT_000328 데코소품 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000194"' live-snapshot/latest/{t_prd_products,t_prd_product_materials,t_mat_materials}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 가격 | NEITHER-gap (공식 0행 · 고정가 0행 · 단가행 0행) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |

#### 자재 BOM (활성·전사)
<!-- transcribed-by: awk -F, '$1=="PRD_000194"' live-snapshot/latest/t_prd_product_materials.csv + t_mat_materials.csv 조인 (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ_cd | usage_cd | del_yn |
|---|---|---|---|---|
| MAT_000269 | 워터북보틀 | MAT_TYPE.12 | USAGE.07 | N (활성) |
| MAT_000343 | 워터북보틀 500ml | MAT_TYPE.12 | USAGE.07 | N (활성) |
