---
id: product-241-canvas-strap-label-pouch
type: product
anchor: t_prd_products/PRD_000241
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000241(prd_nm=캔버스 스트랩 라벨파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치·§3.5 자재 오염·§3.6 봉제 MISSING·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000241 가격공식 0행 + t_prd_product_prices.csv 동키 0행 + t_prd_product_processes.csv 0행(전수 실측)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000222, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000011, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: has_size, target: size-SIZ_000448, note: "실 사이즈(t_prd_product_sizes 활성·dflt=Y)"}
  - {rel: references, target: gap-pouch-empty-shell, note: "실 원단 자재 0행(MAT_000256 블랙=색 라벨뿐)·공정 0행"}
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 has_process 0행(MISSING)"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000256 '블랙'=색 라벨을 자재(.08)로 오적재(비-소재 값 자재화)"}
  - {rel: references, target: gap-goods-fixed-lookup-no-formula, note: "고정가룩업(t_prd_product_prices 단일 unit_price·frm_cd 없음)·O5 가격gap 정직 선언(07-04 live 재프라이싱)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(가격공식·고정가 둘 다 0행)"
  substrate: "실 원단 자재 미적재(색 라벨 MAT_000256 블랙만·empty-shell)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
  fixed_price: "8500원 (t_prd_product_prices unit_price·transcribed-by reprice_goods_260704 @ 07-04 live)"
  가격상태: "고정가룩업·8500원(unit_price·transcribed·07-04 live·reg_dt=2026-07-03)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["캔버스 스트랩 라벨파우치 구성·가격 질의(원천 부재 정직 응답)"]
tags: ["#파우치", "#캔버스", "#봉제", "#비종이", "#NEITHER-gap", "#empty-shell"]
updated: 2026-07-04
---

# 캔버스 스트랩 라벨파우치 (product-241-canvas-strap-label-pouch)

> **★재프라이싱 정정(07-04 live·H-1 스냅샷 드리프트):** 이 상품은 라이브 `t_prd_product_prices`에 **고정가 8500원**(reg_dt=2026-07-03·07-04 SELECT 실측)이 실재한다. 스냅샷(20260702_1119) 기반 최초 전사가 'NEITHER-gap(가격 원천 부재)'로 오표기했던 것을 정정 — [[gap-goods-fixed-lookup-no-formula]](고정가룩업·공식 없는 직접가)로 O5 가격gap 정직 선언. 아래 본문의 '0행/원천 부재' 서술은 stale이며 이 배너·frontmatter가 권위. 값 계산=`evaluate_price` 권위.


캔버스 스트랩 라벨파우치(PRD_000241)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). **비종이 → 판형 없음**.
가격은 **고정가룩업(07-04 재프라이싱 정정)**([[gap-goods-fixed-lookup-no-formula]]). 실 원단 자재가 미적재이고(색 라벨 MAT_000256 "블랙"만 있음)
공정도 0행이라 **BOM empty-shell**([[gap-pouch-empty-shell]]·[[gap-goods-sewing-missing]]).

- 고정가룩업(07-04 재프라이싱 정정)이라 priced_by 없음 → [[gap-goods-fixed-lookup-no-formula]] 참조로 가격 사슬 부재 정직 선언(O5).
- 원단 상품이라 has_plate_size 미배선(도메인 [HARD]).
- 실 사이즈 SIZ_000448(70x100)은 `t_prd_product_sizes`에 실재하나 사이즈 축 노드 미민팅 → needs_axis.

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_price_formulas+t_prd_product_prices+t_prd_product_sizes+t_prd_product_categories PRD_000241 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000222 패브릭파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | MAT_000256 "블랙" (MAT_TYPE.08) | ★색 라벨 자재 오적재·실 원단 자재 0행([[gap-goods-material-contamination]]) |
| 공정 | 0행 | 봉제 MISSING([[gap-goods-sewing-missing]]) |
| 가격공식 | 0행 | 고정가룩업(07-04 재프라이싱 정정) |
| 고정가(t_prd_product_prices) | 0행 | 고정가룩업(07-04 재프라이싱 정정) |
| 사이즈(t_prd_product_sizes) | SIZ_000448 70x100 | 실 상품 사이즈(축 미민팅·needs_axis) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).
