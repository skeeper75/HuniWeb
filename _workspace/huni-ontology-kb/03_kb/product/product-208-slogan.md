---
id: product-208-slogan
type: product
anchor: t_prd_products/PRD_000208
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000208 (prd_nm=슬로건·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000208 formula 0행 + t_prd_product_prices.csv 키:PRD_000208 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§0.1 use_yn=N 미출시(208 슬로건)·§3.10 NEITHER-gap·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000198, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
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
  use_yn: N
  del_yn: N
  상태: "use_yn=N·미출시(정직 표기·팬텀 가격 금지)"
  archetype: "NEITHER-gap(공식·고정가 둘 다 없음·견적 원천 부재)"
  in_category_ref: "CAT_000010 라이프(main·disp23)·CAT_000198 응원/시즌 — 카테고리 축 노드 미민팅(needs_axis)"
  fixed_price: "12000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·12000원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: Product, xjdf: "Product(응원/패브릭 굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(슬로건·미출시)", "조건 탐색(응원/시즌 굿즈)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#미출시", "#비종이류"]
updated: 2026-07-04
---

# 슬로건 (product-208-slogan)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 12000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


슬로건(PRD_000208)은 **라이프/응원·시즌 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단/현수형). ★현재
**use_yn=N(미출시)** — 노드는 생성하되 미출시로 정직 표기(팬텀 가격 금지). 셋트 아님(단품). 가격은 **고정가룩업(07-04 재프라이싱 정정)**
(공식·고정가 **둘 다 0행**·견적 원천 부재·[[gap-goods-fixed-lookup-no-formula]]).

- **미출시**: `use_yn=N`·`del_yn=N`(폐기 아님·판매 비노출). 출시 시 가격 원천 적재 필요.
- **가격 GAP**: 공식 0행·고정가 0행 → §26·§7 dbmap 대기.
- **판형 없음**: 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **자재(비활성)**: 양면 가로형(MAT_000290)·양면 세로형(MAT_000291·MAT_TYPE.09) 둘 다 del_yn=Y(비활성) → uses_material 미배선(정직).
- **카테고리**: CAT_000010 라이프(main)·CAT_000198 응원/시즌 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000208"' live-snapshot/latest/{t_prd_products,t_prd_product_materials,t_mat_materials}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| use_yn | N (미출시) · del_yn N |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 가격 | 고정가룩업(07-04 재프라이싱 정정) (공식 0행 · 고정가 0행 · 단가행 0행) |
| 자재 | MAT_000290 양면 가로형·MAT_000291 양면 세로형(MAT_TYPE.09)·둘 다 del_yn=Y(비활성) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |
