---
id: product-239-canvas-flat-pouch
type: product
anchor: t_prd_products/PRD_000239
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000239(prd_nm=캔버스 플랫 파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치·§3.5 자재 오염·§3.10 NEITHER-gap·§4 파우치 봉제 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000239 가격공식 0행 + t_prd_product_prices.csv 동키 0행(전수 실측=NEITHER-gap)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
relations:
  - {rel: in_category, target: category-CAT_000222, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000011, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000185, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: references, target: gap-goods-neither, note: "PRF·고정가 둘 다 0행=견적 원천 부재(O5 충족·가격 사슬 없음)"}
  - {rel: references, target: gap-goods-material-contamination, note: "MAT_000319(M)·MAT_000320(L)=사이즈 라벨을 자재(.09)로 오적재·비-소재 값 자재화(GP-ST-003)"}
  - {rel: references, target: gap-goods-sewing-missing, note: "정체 공정=봉제인데 PROC_000081 부착만 배선(봉제→부착 오적재·GP-ST-004)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  price_archetype: "NEITHER-gap(가격공식·고정가 둘 다 0행·견적 원천 부재)"
  substrate: "캔버스(옥스포드) MAT_000185(MAT_TYPE.05 원단·실 소재)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["캔버스 파우치 구성·가격 질의(가격 원천 부재 정직 응답)"]
tags: ["#파우치", "#캔버스", "#봉제", "#비종이", "#NEITHER-gap", "#empty-shell"]
updated: 2026-07-04
---

# 캔버스 플랫 파우치 (product-239-canvas-flat-pouch)

캔버스 플랫 파우치(PRD_000239)는 **봉제 완제품 단품**(prd_typ_cd=PRD_TYPE.01·셋트 아님·`t_prd_product_sets`
미등록). 원단(캔버스)이라 **비종이 → 판형 없음**([[rule/rules#RULE_plate_paper_only]]). 가격은 **가격공식·고정가
둘 다 0행(NEITHER-gap)** — 견적 원천이 없어 손님이 0/최소가를 만난다([[gap-goods-neither]]). 실 소재는
캔버스(옥스포드·MAT_000185·원단 .05)이나 사이즈 라벨(M/L)이 자재로 오적재돼 있다([[gap-goods-material-contamination]]).

- **가격 경계(D-18)**: 이 노드는 상품→가격 원천 연결까지만 정직 표기한다. NEITHER-gap이라 priced_by 엣지 없음 → [[gap-goods-neither]] 참조로 가격 사슬 부재를 정직 선언(O5).
- **판형 없음(도메인 [HARD])**: 원단 상품이라 has_plate_size 미배선. 라이브 `t_prd_product_plate_sizes`에 SIZ 행이 있으나 이는 비종이 상품에 판형 테이블을 오용한 관찰 기록(아래 표)일 뿐 판형 축이 아니다.
- **자재/축 미민팅(정직)**: 실 원단(MAT_000185 캔버스)·카테고리(CAT_000222 패브릭파우치)·사이즈 축 노드가 KB 미민팅이라 uses_material·in_category·has_size 배선 불가 → needs_axis(끊긴 링크 대신 아래 전사표가 권위).

## 상품 요소 전사표 (권위 = 라이브 스냅샷·awk 결정론 전사)

<!-- transcribed-by: awk over live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_prd_product_processes+t_prd_product_price_formulas+t_prd_product_prices+t_prd_product_plate_sizes+t_prd_product_categories PRD_000239 @ 2026-07-04 -->

| 축 | 라이브 값 | 판정 |
|---|---|---|
| 카테고리 | CAT_000222 패브릭파우치 → CAT_000011 에코백 | 축 노드 미민팅(needs_axis) |
| 자재 | MAT_000185 캔버스(옥스포드·MAT_TYPE.05 원단) | 실 소재(축 미민팅·needs_axis) |
| 자재 | MAT_000319 "M"·MAT_000320 "L" (MAT_TYPE.09) | ★사이즈 라벨을 자재로 오적재([[gap-goods-material-contamination]]) |
| 공정 | PROC_000081 부착(mand=N) | 봉제→부착 오적재 의심([[gap-goods-sewing-missing]]) |
| 가격공식 | 0행 | NEITHER-gap |
| 고정가(t_prd_product_prices) | 0행 | NEITHER-gap |
| plate_sizes(비종이 오용) | SIZ_000433 220x300·SIZ_000434 260x340 | 판형 아님(관찰·has_plate_size 미배선) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(손전사 금지·D-9).
