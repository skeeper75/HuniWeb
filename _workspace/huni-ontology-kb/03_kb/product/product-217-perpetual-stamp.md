---
id: product-217-perpetual-stamp
type: product
anchor: t_prd_products/PRD_000217
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000217(prd_nm=만년스탬프·prd_typ_cd=PRD_TYPE.01·use_yn=Y·editor_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "문서:§1.2 굿즈/악세사리(과업명시 217 만년스탬프·015 리필잉크 addon)·§3.9 CPQ·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-sg}
relations:
  - {rel: in_category, target: category-CAT_000134, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·CAT_000008)·데스크소품(CAT_000134·축 미민팅)"}
  - {rel: derived_from, target: gap-goods-neither, note: "가격 원천 부재(공식·고정가 둘 다 없음)를 GAP으로 정직 선언·O5 gap 연결 예외"}
  - {rel: references, target: gap-goods-price-unloaded, note: "채움 경로=상품마스터 고정가 verbatim 적재 대기"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-gap(공식·고정가 둘 다 미적재)"
  min_qty: 1
  file_upload_yn: "Y"
  editor_yn: "N"
standards: {schema_org: Product, xjdf: "Product(굿즈)", config_ont: "component type"}
tags: ["#굿즈", "#만년스탬프", "#NEITHER-gap", "#비종이", "#CPQ잉크색"]
updated: 2026-07-04
---

# 만년스탬프 (product-217-perpetual-stamp)

만년스탬프(PRD_000217)는 **문구/데스크소품 완제품 단품**(prd_typ_cd=`PRD_TYPE.01`·editor_yn=N). 스탬프 굿즈로,
7개 스탬프 규격(원형/사각) + **잉크색 CPQ 옵션**(7색)을 갖는다. 리필잉크(015)는 별도 addon성 상품(팩 §1.2).

- **가격(정직 GAP)**: 공식 0행·고정가 0행 = NEITHER-gap → [[gap-goods-neither]](O5 `derived_from` 예외)·
  채움 [[gap-goods-price-unloaded]]. 스탬프는 자재·사이즈가 실려 있어도 **가격 원천이 없어 견적 불가**.
- **CPQ 잉크색(전사·verified)**: 옵션그룹 OPT_000072(잉크색·SEL_TYPE.01·mand=Y·1/1)의 7 아이템이
  `OPT_REF_DIM.03`(자재)으로 잉크색 자재(MAT_000297~303)를 참조. 이 자재는 217 product_materials에 실재
  (`fn_chk_opt_item_ref` 정합). ★잉크색 자재·사이즈의 shared 축 노드는 미민팅이라 아래 전사표가 권위·
  `has_option_group`/`option_refs`/`has_size` 미배선(끊긴 링크 방지·shared 축 승격 대기).
- **비종이 → 판형 없음**(도메인 [HARD]): 공정 0행·`has_plate_size` 미배선.
- **카테고리**: 문구(CAT_000008·main) 배선. 데스크소품(CAT_000134) 미민팅 → needs_axis.

## 상품 정체·수량 (전사)

<!-- transcribed-by: awk t_prd_products.csv PRD_000217 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| prd_typ_cd | use_yn | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | Y | 1 | 10000 | 1 | QTY_UNIT.01 | Y | N |

## 사이즈 7종(전사)

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_siz_sizes.csv PRD_000217 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| siz_cd | 라벨 | work(mm) |
|---|---|---|
| SIZ_000419 | 원형13x13 | 13x13 |
| SIZ_000420 | 원형19x19 | 19x19 |
| SIZ_000421 | 원형24x24 | 24x24 |
| SIZ_000422 | 원형35x35 | 35x35 |
| SIZ_000423 | 사각30x30 | 30x30 |
| SIZ_000424 | 사각67x32 | 67x32 |
| SIZ_000425 | 사각78x28 | 78x28 |

## 잉크색 CPQ 옵션 → 자재(전사)

<!-- transcribed-by: awk t_prd_product_option_groups.csv+t_prd_product_option_items.csv+t_prd_product_materials.csv PRD_000217 from live-snapshot/latest (snap_20260702_1119) @ 2026-07-04 -->
| opt_grp | opt_cd | ref_dim | mat_cd | 잉크색 |
|---|---|---|---|---|
| OPT_000072 | OPV_000456 | OPT_REF_DIM.03 | MAT_000297 | 청보라 |
| OPT_000072 | OPV_000457 | OPT_REF_DIM.03 | MAT_000298 | 빨강 |
| OPT_000072 | OPV_000458 | OPT_REF_DIM.03 | MAT_000299 | 검정 |
| OPT_000072 | OPV_000459 | OPT_REF_DIM.03 | MAT_000300 | 파랑 |
| OPT_000072 | OPV_000460 | OPT_REF_DIM.03 | MAT_000301 | 초록 |
| OPT_000072 | OPV_000461 | OPT_REF_DIM.03 | MAT_000302 | 핑크 |
| OPT_000072 | OPV_000462 | OPT_REF_DIM.03 | MAT_000303 | 노랑 |
