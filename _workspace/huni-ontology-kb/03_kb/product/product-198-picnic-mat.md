---
id: product-198-picnic-mat
type: product
anchor: t_prd_products/PRD_000198
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000198 (prd_nm=피크닉매트·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000198 formula 0행 + t_prd_product_prices.csv 키:PRD_000198 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈(매트)·§3.9 CPQ 옵션(색상)·§3.4 bundle_qty·§3.10 NEITHER-gap", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000181, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-neither, note: "가격 공식·고정가 둘 다 0행(견적 원천 부재)·O5 gap 선언"}
  - {rel: has_size, target: size-SIZ_000399, note: "100x70cm(1인용)·dflt_yn=Y"}
  - {rel: has_size, target: size-SIZ_000402, note: "100x150cm(2인용)·dflt_yn=Y"}
  - {rel: has_option_group, target: optgroup-198-color, note: "색상 CPQ 그룹(SEL_TYPE.01·손님 택1)"}
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
  bundle_qty_note: "t_prd_product_bundle_qtys 2행(QTY_UNIT.04·값 1/2=1인용/2인용 대응 추정)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(패브릭 굿즈·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(피크닉매트 구성·규격/색상)", "조건 탐색(여행/아웃도어 매트)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#비종이류"]
updated: 2026-07-04
---

# 피크닉매트 (product-198-picnic-mat)

피크닉매트(PRD_000198)는 **라이프/여행·아웃도어 패브릭 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단).
셋트 아님(단품). 100x70cm(1인용)·100x150cm(2인용) 2규격에 **색상 택1** CPQ 그룹을 가진다. ★가격은
**NEITHER-gap** — 가격공식·고정가가 **둘 다 0행**이라 견적 원천이 없다([[gap-goods-neither]]).

- **가격 GAP**: 공식 0행·고정가 0행 → §26·§7 dbmap 대기.
- **판형 없음**: 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **색상 옵션 ↔ 자재**: 색상 CPQ(OPT_000071)가 참조하는 자재 MAT_000255 화이트/MAT_000256 블랙(MAT_TYPE.08)이 둘 다 del_yn=Y(비활성) → option_refs 미배선(L-18 회피). 자재 재활성/재적재 대기.
- **수량**: `t_prd_product_bundle_qtys` 2행(QTY_UNIT.04·값 1/2) — 1인용/2인용 규격과 대응 가능성(추정·실무진 확인).
- **카테고리**: CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000198"' live-snapshot/latest/{t_prd_products,t_prd_product_sizes,t_siz_sizes,t_prd_product_materials,t_prd_product_option_groups,t_prd_product_bundle_qtys}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 · bundle_qtys 2행(QTY_UNIT.04) |
| 가격 | NEITHER-gap (공식 0행 · 고정가 0행 · 단가행 0행) |
| 사이즈 | SIZ_000399 100x70cm(1인용·1000x700)·SIZ_000402 100x150cm(2인용·1000x1500) |
| 색상 옵션 | OPT_000071 색상(SEL_TYPE.01·mand Y·손님 택1) |
| 자재 | MAT_000255 화이트·MAT_000256 블랙(MAT_TYPE.08)·둘 다 del_yn=Y(비활성) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |

## 이 상품 전용 하위 노드

### [size-SIZ_000399] 100x70cm 1인용 (피크닉매트 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000399
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000399 (siz_nm=100x70cm(1인용)·work 1000x700)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000399", note: "피크닉매트 1인용 100x70cm(작업 1000x700mm)·비종이라 판형 없음"}

### [size-SIZ_000402] 100x150cm 2인용 (피크닉매트 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000402
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000402 (siz_nm=100x150cm(2인용)·work 1000x1500)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000402", note: "피크닉매트 2인용 100x150cm(작업 1000x1500mm)·비종이라 판형 없음"}

### [optgroup-198-color] 색상 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000198
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000198 opt_grp_cd:OPT_000071 (색상·SEL_TYPE.01·mand Y·min/max 1/1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000071", opt_grp_nm: "색상", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1", note: "참조 자재 MAT_000255 화이트/MAT_000256 블랙 둘 다 del_yn=Y(비활성)→option_refs 미배선(L-18 회피)"}
