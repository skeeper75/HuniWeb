---
id: product-242-cotton-string-label-pouch
type: product
anchor: t_prd_products/PRD_000242
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000242(prd_nm=광목 스트링 라벨파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치(★242=순수 empty-shell 자재/공정 0행)·§3.5·§3.6·§3.10 NEITHER-gap·§4", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:PRD_000242 자재 0행 + t_prd_product_processes.csv 0행 + 가격공식/고정가 둘 다 0행(전수 실측=순수 empty-shell)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
relations:
  - {rel: references, target: gap-goods-neither, note: "PRF·고정가 둘 다 0행=견적 원천 부재(O5 충족)"}
  - {rel: references, target: gap-pouch-empty-shell, note: "★순수 empty-shell — 자재 0행·공정 0행(파우치 대표 사례)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "봉제 공정 has_process 0행(MISSING)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(가격공식·고정가 둘 다 0행)"
  substrate: "★순수 empty-shell — 자재 0행·공정 0행"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["광목 스트링 라벨파우치 구성·가격 질의(순수 empty-shell 정직 응답)"]
tags: ["#파우치", "#광목", "#봉제", "#비종이", "#NEITHER-gap", "#empty-shell"]
updated: 2026-07-04
---

# 광목 스트링 라벨파우치 (product-242-cotton-string-label-pouch)

광목 스트링 라벨파우치(PRD_000242)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). **비종이 → 판형 없음**.
★이 상품은 **순수 empty-shell** — 자재 0행·공정 0행·가격 원천 0행(파우치군 대표 미적재 사례). 가격은
**NEITHER-gap**([[gap-goods-neither]]), BOM은 완전 비어 있다([[gap-pouch-empty-shell]]·[[gap-goods-sewing-missing]]).

- NEITHER-gap이라 priced_by 없음 → [[gap-goods-neither]] 참조로 가격 사슬 부재 정직 선언(O5).
- 순수 empty-shell: 실무진 BOM(원단 자재·봉제 공정) 충전 대기(§7 dbmap).
- 실 사이즈 SIZ_000246(100x70)·SIZ_000449(100x40)는 `t_prd_product_sizes`에 실재하나 축 노드 미민팅 → needs_axis.

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_price_formulas+t_prd_product_prices+t_prd_product_sizes+t_prd_product_categories PRD_000242 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000222 패브릭파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | 0행 | ★순수 empty-shell([[gap-pouch-empty-shell]]) |
| 공정 | 0행 | 봉제 MISSING([[gap-goods-sewing-missing]]) |
| 가격공식 | 0행 | NEITHER-gap |
| 고정가(t_prd_product_prices) | 0행 | NEITHER-gap |
| 사이즈(t_prd_product_sizes) | SIZ_000246 100x70·SIZ_000449 100x40 | 실 상품 사이즈(축 미민팅·needs_axis) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).
