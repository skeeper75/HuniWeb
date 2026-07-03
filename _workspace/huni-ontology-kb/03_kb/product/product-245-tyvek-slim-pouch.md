---
id: product-245-tyvek-slim-pouch
type: product
anchor: t_prd_products/PRD_000245
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000245(prd_nm=타이벡 슬림 파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치(타이벡)·§3.5·§3.6 봉제 MISSING·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000245 가격공식 0행 + t_prd_product_prices.csv 동키 0행 + t_prd_product_processes.csv 0행(전수 실측)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000228, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000011, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-goods-neither, note: "PRF·고정가 둘 다 0행=견적 원천 부재(O5 충족)"}
  - {rel: references, target: gap-pouch-empty-shell, note: "실 타이벡 원단 자재 0행(MAT_000319/320=사이즈 라벨뿐)·공정 0행"}
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 has_process 0행(MISSING)"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000319(M)·MAT_000320(L)=사이즈 라벨 자재 오적재(.09)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(가격공식·고정가 둘 다 0행)"
  substrate: "실 타이벡 원단 자재 미적재(사이즈 라벨 M/L만·empty-shell)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["타이벡 슬림 파우치 구성·가격 질의(원천 부재 정직 응답)"]
tags: ["#파우치", "#타이벡", "#봉제", "#비종이", "#NEITHER-gap", "#empty-shell"]
updated: 2026-07-04
---

# 타이벡 슬림 파우치 (product-245-tyvek-slim-pouch)

타이벡 슬림 파우치(PRD_000245)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). **비종이 → 판형 없음**.
가격은 **NEITHER-gap**([[gap-goods-neither]]). 실 타이벡 원단 자재 미적재(사이즈 라벨 M/L만)·공정 0행 →
**BOM empty-shell**([[gap-pouch-empty-shell]]·[[gap-goods-sewing-missing]]).

- NEITHER-gap이라 priced_by 없음 → [[gap-goods-neither]] 참조로 가격 사슬 부재 정직 선언(O5).
- 원단 상품이라 has_plate_size 미배선(도메인 [HARD]).
- 실 사이즈·카테고리 축 노드 미민팅 → needs_axis.

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_price_formulas+t_prd_product_prices+t_prd_product_plate_sizes+t_prd_product_categories PRD_000245 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000228 타이벡파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | MAT_000319 "M"·MAT_000320 "L" (MAT_TYPE.09) | ★사이즈 라벨 자재 오적재·실 원단 자재 0행([[gap-goods-material-contamination]]·[[gap-pouch-empty-shell]]) |
| 공정 | 0행 | 봉제 MISSING([[gap-goods-sewing-missing]]) |
| 가격공식 | 0행 | NEITHER-gap |
| 고정가(t_prd_product_prices) | 0행 | NEITHER-gap |
| plate_sizes(비종이 오용) | SIZ_000435 220x294·SIZ_000436 260x374 | 판형 아님(관찰·미배선) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).
