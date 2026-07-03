---
id: product-206-short-sleeve-tshirt
type: product
anchor: t_prd_products/PRD_000206
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000206 (prd_nm=반팔티셔츠·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000206 formula 0행 + t_prd_product_prices.csv 키:PRD_000206 0행 (NEITHER-gap)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 패브릭·의류(티셔츠)·§3.10 GAP-GD-1 NEITHER-gap·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: unknown, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000206, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
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
  use_yn: Y
  del_yn: N
  archetype: "NEITHER-gap(공식·고정가 둘 다 없음·견적 원천 부재)"
  in_category_ref: "CAT_000010 라이프(main)·CAT_000206 패션 — 카테고리 축 노드 미민팅(needs_axis)"
  fixed_price: "12000원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·12000원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: Product, xjdf: "Product(의류 굿즈)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(반팔티셔츠 구성)", "조건 탐색(패션 의류 굿즈)"]
tags: ["#굿즈", "#패브릭의류패드", "#NEITHER-gap", "#비종이류"]
updated: 2026-07-04
---

# 반팔티셔츠 (product-206-short-sleeve-tshirt)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 12000원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


반팔티셔츠(PRD_000206)는 **라이프/패션 의류 굿즈 완제품 단일**(prd_typ_cd=PRD_TYPE.01·비종이 원단). 셋트 아님
(단품). ★가격은 **고정가룩업(07-04 재프라이싱 정정)** — 가격공식·고정가가 **둘 다 0행**이라 견적 원천이 없다([[gap-goods-fixed-lookup-no-formula]]).

- **가격 GAP**: 상품마스터 굿즈 시트 + 실무진 가격표 → §26·§7 dbmap 적재 대기.
- **판형 없음**: 원단(비종이)이라 판형 불필요([[rule/rules#RULE_plate_paper_only]]).
- **자재(색×규격 8종·전부 비활성)**: 화이트/블랙 × M/L/XL/XXL(MAT_TYPE.09) 8행 모두 del_yn=Y(2026-06-16 논리삭제)라 활성 substrate 없음 → uses_material 미배선(empty-shell·정직). ★색×규격 직교는 본체색×사이즈 옵션 성격(과분할 주의·pack §3.2 GP-DIM).
- **카테고리**: CAT_000010 라이프(main)·CAT_000206 패션 — 축 노드 미민팅(needs_axis).

## 상품 요소 전사 (live-snapshot awk 전사)

<!-- transcribed-by: awk -F, '$1=="PRD_000206"' live-snapshot/latest/{t_prd_products,t_prd_product_materials,t_mat_materials}.csv (snap_20260702_1119) @ 2026-07-04 -->
| 항목 | 값 |
|---|---|
| prd_typ_cd | PRD_TYPE.01 (완제품 단일) |
| 수량 | min 1 · max 10000 · incr 1 · QTY_UNIT.01 |
| 가격 | 고정가룩업(07-04 재프라이싱 정정) (공식 0행 · 고정가 0행 · 단가행 0행) |
| 자재 | 화이트/블랙 × M/L/XL/XXL 8행(MAT_000282~289·MAT_TYPE.09)·전부 del_yn=Y(비활성) |
| 공정 | 0행 (봉제/전사 미배선) |
| 판형 | 실 판형 0 (비종이) |
