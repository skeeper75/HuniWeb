---
id: product-240-canvas-triangle-pouch
type: product
anchor: t_prd_products/PRD_000240
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000240(prd_nm=캔버스 삼각 파우치·prd_typ_cd=PRD_TYPE.01·nonspec_yn=N·min_qty=1·max_qty=10000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.01·file_upload_yn=Y·editor_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 파우치·§3.5 자재 오염·§3.10 가격아키타입·§4 파우치 봉제 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
  - {source_file: "live t_prd_product_price_formulas (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRD_000240 frm_cd=PRF_GOODS_FIXED_SIZ(굿즈 사이즈등급 고정가·use_yn=Y)·comp COMP_GOODS_FIXED_SIZ(use_dims [siz_cd]·단가행 2셀)·★스냅샷(20260702_1119) '공식 0행'은 stale 오전사→라이브 공식 실재 정정", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
relations:
  - {rel: in_category, target: category-CAT_000222, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000011, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: uses_material, target: material-MAT_000185, note: "substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"}
  - {rel: priced_by, target: formula-PRF_GOODS_FIXED_SIZ, note: "굿즈 사이즈등급 고정가(siz_cd 룩업·07-04 live 재프라이싱=NEITHER 오표기 정정)"}
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
  price_archetype: "공식형(PRF_GOODS_FIXED_SIZ·굿즈 사이즈등급 고정가·siz_cd 룩업·07-04 live)"
  substrate: "캔버스(옥스포드) MAT_000185(MAT_TYPE.05 원단·실 소재)"
  구분: "파우치·백(봉제 상품·비종이·판형 없음)"
standards: {schema_org: "Product", xjdf: "Product(파우치)", config_ont: "component type"}
answers_cq: ["캔버스 삼각 파우치 구성·가격 질의(사이즈등급 고정가 공식)"]
tags: ["#파우치", "#캔버스", "#봉제", "#비종이", "#공식형", "#사이즈등급고정가"]
updated: 2026-07-04
---

# 캔버스 삼각 파우치 (product-240-canvas-triangle-pouch)

캔버스 삼각 파우치(PRD_000240)는 **봉제 완제품 단품**(PRD_TYPE.01·셋트 아님). 원단(캔버스)이라 **비종이 →
판형 없음**. 가격은 **공식형** — 라이브 `t_prd_product_price_formulas`에 **PRF_GOODS_FIXED_SIZ**(굿즈
사이즈등급 고정가·use_yn=Y·07-04 SELECT 실측)가 바인딩돼 있다(priced_by). 실 소재는 캔버스(옥스포드·
MAT_000185)이나 사이즈 라벨(M/L)이 자재로 오적재([[gap-goods-material-contamination]]).

- ★**재프라이싱 정정(07-04 live)**: 스냅샷(20260702_1119) 기반 최초 전사가 "가격공식 0행=NEITHER-gap"로
  오표기했으나, 라이브 07-04 재프라이싱(reprice_goods_260704)에서 **PRF_GOODS_FIXED_SIZ 공식 실재** 확인 →
  priced_by 배선·gap-goods-neither 참조 은퇴. 값 계산=`evaluate_price` 권위(D-18).
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
| 가격공식 | PRF_GOODS_FIXED_SIZ (1행·use_yn=Y·07-04 live) | 공식형→priced_by([[formula-PRF_GOODS_FIXED_SIZ]]) |
| 고정가(t_prd_product_prices) | 0행 | 공식형이라 직접단가 미사용(정상) |
| plate_sizes(비종이 오용) | SIZ_000433 220x300·SIZ_000447 260x380 | 판형 아님(관찰·미배선) |

수량 규칙 = 상품 마스터(min 1·max 10000·incr 1·QTY_UNIT.01). 값·치수는 스크립트 전사(D-9).

## 이 상품 전용 하위 노드 (공식·구성요소·050 패턴 in-file mint)

### [formula-PRF_GOODS_FIXED_SIZ] 굿즈 사이즈등급 고정가 {verified}
- type: price_formula
- anchor: none  # 사유: PRF_GOODS_FIXED_SIZ는 07-04 라이브 신규 공식(스냅샷 20260702_1119 t_prc_price_formulas 미포함)·closed-world(L-17) 미실재이나 라이브 SELECT verified. 스냅샷 재캡처 시 t_prc_price_formulas/PRF_GOODS_FIXED_SIZ로 승격
- src: {source_file: "live t_prc_price_formulas (07-04 SELECT·reprice_goods_260704)", source_locator: "키:PRF_GOODS_FIXED_SIZ·frm_nm '굿즈 사이즈등급 고정가'·use_yn=Y", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
- src: {source_file: "live t_prd_product_price_formulas (07-04 SELECT)", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000240,PRF_GOODS_FIXED_SIZ)·other_users 0(240 전용)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
- src: {source_file: "live t_prc_formula_components (07-04 SELECT)", source_locator: "frm_cd:PRF_GOODS_FIXED_SIZ(comp COMP_GOODS_FIXED_SIZ)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
- rel: {rel: has_component, target: component-COMP_GOODS_FIXED_SIZ}
- props: {archetype: "고정가(사이즈등급)", prc_typ: "완제품가·siz_cd 룩업", note: "240 캔버스 삼각 파우치 부모공식. 굿즈 사이즈별 완제품가(고정가) — siz_cd 차원으로 룩업. 값 계산=evaluate_price 권위(D-18)."}

### [component-COMP_GOODS_FIXED_SIZ] 굿즈 사이즈별 완제품가 {verified}
- type: price_component
- anchor: none  # 사유: COMP_GOODS_FIXED_SIZ는 07-04 라이브 신규 구성요소(스냅샷 20260702_1119 t_prc_price_components 미포함)·closed-world(L-17) 미실재이나 라이브 SELECT verified. 스냅샷 재캡처 시 t_prc_price_components/COMP_GOODS_FIXED_SIZ로 승격
- src: {source_file: "live t_prc_price_components (07-04 SELECT)", source_locator: "키:COMP_GOODS_FIXED_SIZ·comp_nm '굿즈 사이즈별 완제품가'·use_dims [siz_cd]·단가행 2셀(t_prc_component_prices)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-reprice-0704}
- props: {use_dims: '["siz_cd"]', 단가행: "2셀(siz_cd별·값 미전사 L-12·evaluate_price 권위)", role: "240 굿즈 사이즈별 완제품가. PRF_GOODS_FIXED_SIZ 배선(has_component)."}
