---
id: product-197-mini-mat
type: product
anchor: t_prd_products/PRD_000197
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000197 (prd_nm=미니매트·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000197 formula 0행 + t_prd_product_prices.csv 키:PRD_000197 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈(매트)·§3.9 CPQ 옵션(색상)·§3.10 NEITHER-gap·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000181, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: has_size, target: size-SIZ_000396, note: "45x45cm 단일 규격(dflt_yn=Y)"}
  - {rel: has_option_group, target: optgroup-197-color, note: "색상 CPQ 그룹(SEL_TYPE.01·손님 택1)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
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
  in_category_ref: "CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 카테고리 축 노드 미민팅(needs_axis)"
  fixed_price: "16000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·16000원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: Product, xjdf: "Product(패브릭 굿즈·LayoutIntent FinishedDimensions)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미니매트 구성·색상)", "조건 탐색(여행/아웃도어 매트)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#비종이류"]
updated: 2026-07-04
---

# 미니매트 (product-197-mini-mat)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 16000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


미니매트(PRD_000197)는 **라이프/여행·아웃도어 패브릭 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단).
셋트 아님(단품). 45x45cm 단일 규격에 **색상(화이트/블랙) 택1** CPQ 그룹을 가진다. ★가격은 **고정가룩업(07-04 재프라이싱 정정)** —
가격공식·고정가가 **둘 다 0행**이라 견적 원천이 없다([[gap-goods-fixed-lookup-no-formula]]).

- **가격 GAP**: 공식 0행·고정가 0행 → §26·§7 dbmap 대기.
- **판형 없음**: 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **색상 옵션 ↔ 자재**: 색상 CPQ(OPT_000070)가 참조하는 자재 MAT_000255 화이트/MAT_000256 블랙(MAT_TYPE.08)이 둘 다 del_yn=Y(비활성) → option_refs 미배선(부모 uses_material 미실재·L-18 회피). 색상 옵션은 실재하나 참조 자재 재활성/재적재 대기.
- **카테고리**: CAT_000010 라이프(main)·CAT_000181 여행/아웃도어 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000197"' live-snapshot/latest/{t_prd_products,t_prd_product_sizes,t_siz_sizes,t_prd_product_materials,t_prd_product_option_groups}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 가격 | 고정가룩업(07-04 재프라이싱 정정) (공식 0행 · 고정가 0행 · 단가행 0행) |
| 사이즈 | SIZ_000396 45x45cm (작업 450x450) |
| 색상 옵션 | OPT_000070 색상(SEL_TYPE.01·mand Y·손님 택1) |
| 자재 | MAT_000255 화이트·MAT_000256 블랙(MAT_TYPE.08)·둘 다 del_yn=Y(비활성) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |

## 이 상품 전용 하위 노드

### [size-SIZ_000396] 45x45cm (미니매트 전용) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000396
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000396 (siz_nm=45x45cm·work 450x450)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000396", note: "미니매트 단일 규격 45x45cm(작업 450x450mm)·비종이라 판형 없음"}

### [optgroup-197-color] 색상 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000197
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000197 opt_grp_cd:OPT_000070 (색상·SEL_TYPE.01·mand Y·min/max 1/1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000070", opt_grp_nm: "색상", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1", note: "참조 자재 MAT_000255 화이트/MAT_000256 블랙 둘 다 del_yn=Y(비활성)→option_refs 미배선(L-18 회피). 자재 재활성 후 배선 대기"}
