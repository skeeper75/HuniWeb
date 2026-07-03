---
id: product-201-leather-strap-keyring
type: product
anchor: t_prd_products/PRD_000201
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000201(prd_nm=레더스트랩키링·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(과업명시 201)·§3.5 자재 오염(키링고리 부속)·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000189, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
  - {rel: references, target: gap-goods-material-contamination, note: "키링고리(금속 부속)=substrate 아님. active 자재행(미니50/일반100mm)은 규격 변형값(MAT_TYPE.09)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "Y"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#레더스트랩키링", "#NEITHER-gap", "#비종이", "#자재오염주의"]
updated: 2026-07-04
---

# 레더스트랩키링 (product-201-leather-strap-keyring)

레더스트랩키링(PRD_000201)은 **굿즈/악세사리 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`). 레더 스트랩 +
키링고리(금속 부속) 조합 굿즈.

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 [[gap-goods-price-unloaded]].
- **★자재**: active 2행 MAT_000275(미니 50mm)·MAT_000276(일반 100mm)는 **규격 변형값(MAT_TYPE.09)** 이지
  원단 substrate로 명확히 배선할 shared 자재 축 노드가 없다. 키링고리(부속)는 substrate 아님
  ([[gap-goods-material-contamination]]) → `uses_material` 미배선(팩 §3.5 과분할·오염 가드).
- **비종이 → 판형 없음**(도메인 [HARD]): 공정 0행·옵션그룹 0행·`has_plate_size` 미배선.
- **카테고리**: 라이프(CAT_000010·main)·기념품/액세서리(CAT_000189) — 축 노드 미민팅 → `in_category` 미배선·needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000201 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | Y |

## 자재행(전사) — 규격 변형값

<!-- transcribed-by: awk t_prd_product_materials.csv PRD_000201 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| mat_cd | 자재명 | mat_typ | usage | del_yn |
|---|---|---|---|---|
| MAT_000275 | 미니 50mm | MAT_TYPE.09 | USAGE.07 | N |
| MAT_000276 | 일반 100mm | MAT_TYPE.09 | USAGE.07 | N |

> 두 행 = 스트랩 규격 선택값(형상)·substrate 원단 아님 → uses_material 미배선(shared 축 미민팅).
