---
id: product-207-microfiber-towel
type: product
anchor: t_prd_products/PRD_000207
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000207 (prd_nm=극세사타월·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=N·del_yn=N·min/max/incr 공란)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000207 formula 0행 + t_prd_product_prices.csv 키:PRD_000207 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§0.1 use_yn=N 미출시(207 극세사타월)·§3.10 NEITHER-gap·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000323, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-neither, note: "가격 공식·고정가 둘 다 0행(견적 원천 부재)·O5 gap 선언"}
props:
  prd_typ_cd: PRD_TYPE.01
  nonspec_yn: N
  file_upload_yn: Y
  editor_yn: Y
  qty_unit_typ_cd: QTY_UNIT.01
  use_yn: N
  del_yn: N
  상태: "use_yn=N·미출시(정직 표기·팬텀 가격 금지)"
  archetype: "NEITHER-gap(공식·고정가 둘 다 없음·견적 원천 부재)"
  qty_note: "min_qty/max_qty/qty_incr 공란(미설정)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000323 생활소품 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(패브릭 굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(극세사타월·미출시)", "조건 탐색(생활소품)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#미출시", "#비종이류"]
updated: 2026-07-04
---

# 극세사타월 (product-207-microfiber-towel)

극세사타월(PRD_000207)은 **라이프/생활소품 패브릭 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단). ★현재
**use_yn=N(미출시)** — 노드는 생성하되 미출시로 정직 표기(팬텀 가격 금지). 셋트 아님(단품). 가격은 **NEITHER-gap**
(공식·고정가 **둘 다 0행**·견적 원천 부재·[[gap-goods-neither]]).

- **미출시**: `use_yn=N`·`del_yn=N`(폐기 아님·판매 비노출). 출시 시 가격 원천 적재 필요.
- **가격 GAP**: 공식 0행·고정가 0행 → §26·§7 dbmap 대기.
- **판형 없음**: 극세사 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **자재/공정 empty-shell**: 자재 0행·공정 0행.
- **카테고리**: CAT_000010 라이프(main)·CAT_000323 생활소품 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000207"' live-snapshot/latest/{t_prd_products,t_prd_product_materials,t_prd_product_processes}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| use_yn | N (미출시) · del_yn N |
| 수량 | min/max/incr 공란(미설정) · QTY_UNIT.01 |
| 가격 | NEITHER-gap (공식 0행 · 고정가 0행 · 단가행 0행) |
| 자재 | 0행 (empty-shell) |
| 공정 | 0행 |
| 판형 | 실 판형 0 (비종이) |
