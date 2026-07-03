---
id: product-165-photocard-corotto
type: product
anchor: t_prd_products/PRD_000165
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000165(포카코롯토·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N·min1/max10000/incr1·nonspec_yn=N)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000165→PRF_ACRYL_PHCOROTTO_TBD→COMP_ACRYL_PENDING_TBD(PRICE_TYPE.02·use_dims [min_qty]·price_rows=0=견적 원천 부재)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live railway t_prd_product_categories/t_prd_product_sizes/t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "카테고리 CAT_000155 조합형(main_cat_yn=Y)·사이즈 1행(SIZ_000012 55x86 dflt_yn=Y)·자재 MAT_000044(8mm)·공정 0행", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 GAP TBD·§3.10 GAP-AC-5·§4 미출시/TBD 정직 표기·CL-5", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000155, qualifier: main, note: "조합형 카테고리(main_cat_yn=Y·live 07-04)"}
  - {rel: has_size, target: size-SIZ_000012, note: "55x86 포토카드 규격(타 상품 정의·재사용)"}
  - {rel: uses_material, target: material-MAT_000044, note: "아크릴 투명 8mm substrate(dflt_yn=Y·axis 공유·MAT_TYPE.03 오타이핑 GAP-AC-1)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_PHCOROTTO_TBD, note: "TBD 공식(바인딩됨·SA-3 공유·acrylic-formulas.md)"}
  - {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "공식 바인딩됨·COMP_ACRYL_PENDING_TBD 0단가행=견적 불가·실무진 단가 BLOCKED"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "TBD(공식 바인딩·단가행 0)"
  status: "미출시(use_yn=N·del_yn=N)"
  use_yn: "N"
  nonspec_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  editor_yn: "N"
  가격상태: "견적 불가(TBD·COMP_ACRYL_PENDING_TBD 0셀)·미출시 — 추천 제외·팬텀 가격 금지"
  공정상태: "product_processes 0행(MISSING·GAP-AC-2)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·포토카드 코롯토)", config_ont: "component type"}
answers_cq: ["포카코롯토 상품 존재·가격 미확정(미출시 TBD)"]
tags: ["#굿즈", "#아크릴", "#코롯토", "#포토카드", "#TBD", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 포카코롯토 (product-165-photocard-corotto)

포카코롯토(PRD_000165)는 **아크릴 굿즈 완제품 단품**(PRD_TYPE.01·비종이·CL-5 코롯토류·포토카드 규격). ★**미출시**
(`use_yn=N`)이며 ★**견적 불가**(TBD) — 가격공식 `PRF_ACRYL_PHCOROTTO_TBD`가 구성요소
`COMP_ACRYL_PENDING_TBD`에 바인딩됐으나 **단가행 0셀**(견적 원천 부재). 추천 결과에서 제외하고 팬텀 가격을
만들지 않는다(pack §4·GAP-AC-5).

## 정체·유형
- 완제품(.01) 일반 단품(셋트 부모 없음·has_member 없음). 카테고리 = **조합형 `CAT_000155`**(live 07-04·main_cat_yn=Y).

## 차원
- **사이즈:** 규격 1행 55x86(`SIZ_000012`·dflt_yn=Y·포토카드 크기·타 상품 정의 재사용). `nonspec_yn=N`(규격 선택형).
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01).

## 자재·공정
- **자재:** 아크릴 투명 8mm `MAT_000044`(dflt_yn=Y·substrate 두께·axis 공유). substrate=두께(색상 아님·T-8).
- **공정:** `t_prd_product_processes` **0행**(MISSING·GAP-AC-2).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 0행. 아크릴=비종이 → 종이류 판형 로직 이식 금지(T-9). `has_plate_size` 미부여.

## 가격 경로 (★TBD — 견적 불가)
- `product-165 --priced_by--> formula-PRF_ACRYL_PHCOROTTO_TBD --has_component--> component-COMP_ACRYL_PENDING_TBD`.
  공식·구성요소는 실재하나 `COMP_ACRYL_PENDING_TBD` **단가행 0셀** → 견적 불가. **고아 공식이 아니라 단가
  미충전이 본질**([[gap-acryl-tbd-formula-no-priced-rows]]·165/168/169/170 공유). references로 O5 충족(slug에
  'tbd' 포함·가격류 gap·graph-build-spec v1.0.5).
- ★t_prd_product_prices(직접단가룩업) 0행 = gap-goods-fixed-lookup 아키타입 아님(pack T-7).
- gap 충전 경로: 실무진 단가 확정(source-registry §9 GAP-5·wiring HANDOFF 아크릴 *_TBD BLOCKED) → 단가행
  충전 → §18 설계·§7 적재(인간 승인). 미출시라 값 계산은 출시 후.

## 옵션·제약·추가상품
- 옵션그룹 0·제약 0·추가상품 0(product-summary·live constraints=0).

## 승계·freshness 메모
- TBD/미출시 판정 = pack §1.1 GAP TBD·§4·live 07-04 신규 SELECT(H-1 회피·T-2). live-snapshot 가격 정본 금지·대형
  부속 숫자 STALE(T-1).
