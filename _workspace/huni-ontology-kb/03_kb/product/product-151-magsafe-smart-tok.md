---
id: product-151-magsafe-smart-tok
type: product
anchor: t_prd_products/PRD_000151
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000151(prd_nm=맥세이프 스마트톡·prd_typ_cd=PRD_TYPE.01·nonspec_yn=Y·use_yn=Y·del_yn=N·min1/max10000/incr1)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "행:PRD_000151 frm PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적 277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-prod-formulas-260704.csv", source_locator: "행:PRD_000151 note '맥세이프 바디=업체 가격 미정·본체만'", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/pack-acrylic.md", source_locator: "§1.1 M1·§3.5 substrate·§5.1 CL-1", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000009, qualifier: main, note: "아크릴 root(main_cat_yn=Y·live)"}
  - {rel: in_category, target: category-CAT_000010, qualifier: sub, note: "라이프(main_cat_yn=N·보조)"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50(재사용·product-046)"}
  - {rel: has_size, target: size-SIZ_000148, note: "60x60(재사용·product-146-acrylic-keyring-nodes)"}
  - {rel: has_size, target: size-SIZ_000344, note: "70x60(재사용·product-150-nodes)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm=substrate(dflt_yn=Y·유일 자재)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV 인쇄(mand_proc_yn=Y)"}
  - {rel: has_process, target: process-PROC_000081, note: "부착(mand_proc_yn=N·맥세이프 바디 결합·[[product-138-standard-hanging-banner-nodes]] 재사용)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "컬러아크릴 면적매트릭스(공유 M1·본체만·바디 무가)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "Y"
  use_yn: "Y"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  editor_yn: "N"
  archetype: "면적매트릭스형(area-matrix·본체만·맥세이프 바디 업체가 미정→본체 면적가만)"
  plate_sizes_note: "plate_sizes 3행 실재·면적공식 미참조 → 가격영향 없음(비종이·T-9)"
  addon_templates: "없음(addon 0행·바디 가격 업체 미정으로 addon 미적재)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴)", config_ont: "component type"}
answers_cq: ["맥세이프 스마트톡 가격 경로(면적매트릭스 본체가)", "조건 탐색(맥세이프 크기)"]
tags: ["#굿즈", "#아크릴", "#면적매트릭스", "#비종이류"]
updated: 2026-07-04
---

# product-151 맥세이프 스마트톡 (PRD_000151)

맥세이프 스마트톡은 **아크릴 굿즈 완제품 단품**(비종이·UV 평판). 크기(50x50·60x60·70x60 또는
자유치수) 선택 → 컬러아크릴 **면적매트릭스** 본체가 조회. `t_prd_product_sets` 부모 없음 = 일반
단일 완제품(has_member 없음).

## 차원
- **사이즈:** 규격 3행(50x50 `SIZ_000011`·60x60 `SIZ_000148`·70x60 `SIZ_000344`·전부 재사용) +
  비규격 연속(nonspec_yn=Y). 면적매트릭스 W×H.
- **수량규칙:** min 1·max 10000·incr 1.

## 자재·공정
- **substrate:** 아크릴 투명 3mm(`MAT_000043`·dflt_yn=Y·유일 자재·[[material-MAT_000043]]).
- **공정:** UV 인쇄(`PROC_000002`·mand) + 부착(`PROC_000081`·mand=N·맥세이프 바디 결합·공유 축 재사용).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 3행 실재·면적공식 미참조 → 가격영향 없음([GAP-AC-3]·T-9). `has_plate_size` 미배선.

## 가격 경로 (D-18)
- `product-151 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`
  (면적매트릭스 277셀). ★**본체만 과금** — 맥세이프 바디는 업체 가격 미정이라 addon/부속 미적재
  (라이브 note·GB-1 견적불가 해소는 본체 면적가로). `t_prd_product_prices` 0행 = 직접룩업 아님(T-7).
  값=evaluate_price 권위.

## 승계·freshness 메모
- 07-04 신규 SELECT 캐시(pack §0.2·note '맥세이프 바디 업체가 미정·본체만'). ★과업 '151 맥세이프=590,000'은
  라이브 부재=STALE(T-1) — 실측 면적 최대 32,700. snapshot 가격 금지(T-2).
