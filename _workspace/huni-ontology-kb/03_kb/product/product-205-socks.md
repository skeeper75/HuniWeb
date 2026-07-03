---
id: product-205-socks
type: product
anchor: t_prd_products/PRD_000205
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000205 (prd_nm=양말·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "키:PRD_000205 unit_price=3000.00 apply_ymd=2026-06-10 (GP-1 base 단일고정가·260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 패브릭·의류(205 양말=3,000)·§3.10 고정가룩업·§4 굿즈 고정가 행", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-stn}
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
  archetype: "고정가룩업(t_prd_product_prices·3,000원·transcribed·공식 없음)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000206 패션 — 카테고리 축 노드 미민팅(needs_axis)"
standards: {schema_org: Product, xjdf: "Product(패브릭 굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(양말 가격)", "조건 탐색(패션 패브릭 고정가)"]
tags: ["#굿즈", "#패브릭의류패드", "#고정가룩업", "#비종이류"]
updated: 2026-07-04
---

# 양말 (product-205-socks)

양말(PRD_000205)은 **라이프/패션 패브릭 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단). 셋트 아님
(단품). 가격은 **고정가룩업**(`t_prd_product_prices` 단일 unit_price 3,000원·공식 없음)이다(값=evaluate_price 권위·D-18).

- **가격 경계**: 공식 0행·단가행 0행 → 고정단가만이 가격 원천(고정가룩업 정상). ★O5 참고: priced_by/gap 대신 고정단가.
- **판형 없음**: 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **자재/공정 empty-shell**: `t_prd_product_materials` 0행·`t_prd_product_processes` 0행. 원단/봉제 BOM 미충전이나 가격은 고정단가로 견적 가능(BOM과 가격은 별개).
- **카테고리**: CAT_000010 라이프(main)·CAT_000206 패션 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000205"' live-snapshot/latest/{t_prd_products,t_prd_product_prices,t_prd_product_materials,t_prd_product_processes}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 고정가 | 3,000원 (unit_price 3000.00·apply 2026-06-10·260610 verbatim) |
| 공식/단가행 | t_prd_product_price_formulas 0행 · t_prc_component_prices 0행 |
| 자재 | 0행 (empty-shell) |
| 공정 | 0행 (봉제 미배선) |
| 판형 | 실 판형 0 (비종이) |
