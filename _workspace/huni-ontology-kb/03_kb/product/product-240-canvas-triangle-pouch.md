---
id: product-240-canvas-triangle-pouch
type: product
anchor: t_prd_products/PRD_000240
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000240(prd_nm=캔버스 삼각 파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치·§3.5 자재 오염·§3.10 NEITHER-gap·§4 파우치 봉제 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000240 가격공식 0행 + t_prd_product_prices.csv 동키 0행(전수 실측=NEITHER-gap)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
relations:
  - {rel: references, target: gap-goods-neither, note: "PRF·고정가 둘 다 0행=견적 원천 부재(O5 충족)"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000319(M)·MAT_000320(L)=사이즈 라벨 자재 오적재(.09)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "PROC_000081 부착만 배선(봉제→부착 오적재·GP-ST-004)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(가격공식·고정가 둘 다 0행)"
  substrate: "캔버스(옥스포드) MAT_000185(MAT_TYPE.05 원단·실 소재)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["캔버스 삼각 파우치 구성·가격 질의(가격 원천 부재 정직 응답)"]
tags: ["#파우치", "#캔버스", "#봉제", "#비종이", "#NEITHER-gap"]
updated: 2026-07-04
---

# 캔버스 삼각 파우치 (product-240-canvas-triangle-pouch)

캔버스 삼각 파우치(PRD_000240)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). 원단(캔버스)이라 **비종이 →
판형 없음**. 가격은 **NEITHER-gap**(가격공식·고정가 둘 다 0행·[[gap-goods-neither]]). 실 소재는 캔버스(옥스포드·
MAT_000185)이나 사이즈 라벨(M/L)이 자재로 오적재([[gap-goods-material-contamination]]).

- NEITHER-gap이라 priced_by 없음 → [[gap-goods-neither]] 참조로 가격 사슬 부재 정직 선언(O5·D-18 경계).
- 원단 상품이라 has_plate_size 미배선(도메인 [HARD]). plate_sizes 테이블의 SIZ 행은 비종이 판형 오용 관찰(아래 표).
- 실 원단·카테고리·사이즈 축 노드 미민팅 → needs_axis(전사표가 권위).

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_price_formulas+t_prd_product_prices+t_prd_product_plate_sizes+t_prd_product_categories PRD_000240 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000222 패브릭파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | MAT_000185 캔버스(옥스포드·MAT_TYPE.05 원단) | 실 소재(축 미민팅·needs_axis) |
| 자재 | MAT_000319 "M"·MAT_000320 "L" (MAT_TYPE.09) | ★사이즈 라벨 자재 오적재([[gap-goods-material-contamination]]) |
| 공정 | PROC_000081 부착(mand=N) | 봉제→부착 오적재 의심([[gap-goods-sewing-missing]]) |
| 가격공식 | 0행 | NEITHER-gap |
| 고정가(t_prd_product_prices) | 0행 | NEITHER-gap |
| plate_sizes(비종이 오용) | SIZ_000433 220x300·SIZ_000447 260x380 | 판형 아님(관찰·미배선) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).
