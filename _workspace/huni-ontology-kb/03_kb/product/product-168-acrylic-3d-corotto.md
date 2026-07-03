---
id: product-168-acrylic-3d-corotto
type: product
anchor: t_prd_products/PRD_000168
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000168(아크릴입체코롯토·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N·min/max/incr=NULL·nonspec_yn=N)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000168→PRF_ACRYL_3DCOROTTO_TBD→COMP_ACRYL_PENDING_TBD(PRICE_TYPE.02·use_dims [min_qty]·price_rows=0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live railway t_prd_product_categories/t_prd_product_sizes/materials/processes (07-04 읽기전용 SELECT)", source_locator: "카테고리 CAT_000159 코롯토(main_cat_yn=N)·사이즈 0행·자재 0행·공정 0행(product-summary 전부 0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 GAP TBD·§3.4 수량규칙 NULL·§4 미출시·CL-5", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000159, qualifier: main, note: "코롯토 카테고리(main_cat_yn=N·live 07-04)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_3DCOROTTO_TBD, note: "TBD 공식(바인딩됨·SA-3 공유·acrylic-formulas.md)"}
  - {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "COMP_ACRYL_PENDING_TBD 0단가행=견적 불가·실무진 단가 BLOCKED"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "TBD(공식 바인딩·단가행 0·차원 미충전)"
  status: "미출시(use_yn=N·del_yn=N)"
  use_yn: "N"
  nonspec_yn: "N"
  min_qty: "NULL(미설정)"
  max_qty: "NULL(미설정)"
  qty_incr: "NULL(미설정)"
  editor_yn: "N"
  가격상태: "견적 불가(TBD·0셀)·미출시 — 추천 제외·팬텀 가격 금지"
  구성상태: "사이즈·자재·공정·수량규칙 전부 미설정(빈 껍데기·출시 전 보강 필요)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·입체 코롯토)", config_ont: "component type"}
answers_cq: ["아크릴입체코롯토 상품 존재·가격 미확정(미출시 TBD·빈 껍데기)"]
tags: ["#굿즈", "#아크릴", "#코롯토", "#입체", "#TBD", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 아크릴입체코롯토 (product-168-acrylic-3d-corotto)

아크릴입체코롯토(PRD_000168)는 **아크릴 굿즈 완제품 단품**(PRD_TYPE.01·비종이·CL-5 코롯토류). ★**미출시**
(`use_yn=N`)·★**견적 불가**(TBD)·★**빈 껍데기** — 가격공식 `PRF_ACRYL_3DCOROTTO_TBD`만 바인딩됐고
사이즈·자재·공정·수량규칙이 **전부 미설정**(product-summary 0/0/0). 추천 결과 제외·팬텀 가격 금지(pack §4).

## 정체·유형
- 완제품(.01) 일반 단품(셋트 부모 없음·has_member 없음). 카테고리 = **코롯토 `CAT_000159`**(live 07-04).

## 차원·자재·공정 (★전부 미설정)
- **사이즈 0행·자재 0행·공정 0행**(product-summary·live SELECT 실측). 출시 전 규격·substrate·공정 보강 필요.
- **수량규칙:** `min_qty/max_qty/qty_incr = NULL`(미설정·pack §3.4). 출시 시 설정 필요.

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 0행. 아크릴=비종이 → 종이류 판형 로직 이식 금지(T-9). `has_plate_size` 미부여.

## 가격 경로 (★TBD — 견적 불가)
- `product-168 --priced_by--> formula-PRF_ACRYL_3DCOROTTO_TBD --has_component--> component-COMP_ACRYL_PENDING_TBD`.
  단가행 0셀 → 견적 불가. **단가 미충전이 본질**([[gap-acryl-tbd-formula-no-priced-rows]]·165/168/169/170 공유·
  references로 O5 충족·slug 'tbd' 가격류 gap).
- ★t_prd_product_prices 0행 = gap-goods-fixed-lookup 아키타입 아님(pack T-7).
- gap 충전: 실무진 단가(source-registry §9 GAP-5·BLOCKED) → §18 설계·§7 적재(인간 승인).

## 옵션·제약·추가상품
- 옵션그룹 0·제약 0·추가상품 0.

## 승계·freshness 메모
- 미출시/TBD/빈 껍데기 = pack §1.1·§3.4·§4·live 07-04 신규 SELECT. live-snapshot 가격 정본 금지(T-2).
