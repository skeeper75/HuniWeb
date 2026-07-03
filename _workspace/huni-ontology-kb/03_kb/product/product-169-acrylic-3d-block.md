---
id: product-169-acrylic-3d-block
type: product
anchor: t_prd_products/PRD_000169
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000169(아크릴입체블럭·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N·min/max/incr=NULL·nonspec_yn=N)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000169→PRF_ACRYL_3DBLOCK_TBD→COMP_ACRYL_PENDING_TBD(PRICE_TYPE.02·use_dims [min_qty]·price_rows=0)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-materials-named-260704.csv + acryl-processes-named-260704.csv", source_locator: "자재 MAT_000192 투명아크릴(MAT_TYPE.03·dflt_yn=Y)·공정 PROC_000083 가공(mand_proc_yn=Y·169 유일 공정행)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live railway t_prd_product_categories/t_prd_product_sizes (07-04 읽기전용 SELECT)", source_locator: "카테고리 CAT_000159 코롯토(main_cat_yn=N)·사이즈 2행(SIZ_000003 100x150·SIZ_000043 80x80 dflt_yn=Y)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 GAP TBD·§3.4 수량규칙 NULL·§3.6 공정(169 PROC_000083 1행)·§4 미출시·CL-5", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000159, qualifier: main, note: "코롯토 카테고리(main_cat_yn=N·live 07-04)"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150(axis 공유 노드·재사용)"}
  - {rel: has_size, target: size-SIZ_000043, note: "80x80(타 상품 정의·재사용)"}
  - {rel: uses_material, target: material-MAT_000192, note: "투명아크릴 substrate(dflt_yn=Y·axis 공유·MAT_TYPE.03 오타이핑 GAP-AC-1)"}
  - {rel: has_process, target: process-PROC_000083, note: "가공(mand_proc_yn=Y·169 유일 공정행·axis 공유)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_3DBLOCK_TBD, note: "TBD 공식(바인딩됨·SA-3 공유·acrylic-formulas.md)"}
  - {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "COMP_ACRYL_PENDING_TBD 0단가행=견적 불가(가공공정 1행만 실재)·실무진 단가 BLOCKED"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "TBD(공식 바인딩·단가행 0)"
  status: "미출시(use_yn=N·del_yn=N)"
  use_yn: "N"
  nonspec_yn: "N"
  min_qty: "NULL(미설정)"
  max_qty: "NULL(미설정)"
  qty_incr: "NULL(미설정)"
  editor_yn: "N"
  가격상태: "견적 불가(TBD·0셀)·미출시 — 추천 제외·팬텀 가격 금지"
standards: {schema_org: "Product", xjdf: "Product(굿즈·입체 블럭)", config_ont: "component type"}
answers_cq: ["아크릴입체블럭 상품 존재·가격 미확정(미출시 TBD)"]
tags: ["#굿즈", "#아크릴", "#입체블럭", "#TBD", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 아크릴입체블럭 (product-169-acrylic-3d-block)

아크릴입체블럭(PRD_000169)은 **아크릴 굿즈 완제품 단품**(PRD_TYPE.01·비종이·CL-5). ★**미출시**(`use_yn=N`)·
★**견적 불가**(TBD) — 가격공식 `PRF_ACRYL_3DBLOCK_TBD`가 `COMP_ACRYL_PENDING_TBD`에 바인딩됐으나 **단가행
0셀**. 자재(투명아크릴)·공정(가공)·사이즈 2행은 실재하나 가격 원천이 없다. 추천 결과 제외·팬텀 가격 금지(pack §4).

## 정체·유형
- 완제품(.01) 일반 단품(셋트 부모 없음·has_member 없음). 카테고리 = **코롯토 `CAT_000159`**(live 07-04).

## 차원
- **사이즈:** 규격 2행 100x150(`SIZ_000003`·axis 공유)·80x80(`SIZ_000043`·타 상품 정의·재사용). `nonspec_yn=N`.
- **수량규칙:** `min/max/incr = NULL`(미설정·pack §3.4·출시 시 필요).

## 자재·공정
- **자재:** 투명아크릴 `MAT_000192`(dflt_yn=Y·substrate·axis 공유). substrate=투명 소재(색상 아님·T-8·`MAT_TYPE.03`
  오타이핑 GAP-AC-1).
- **공정:** 가공 `PROC_000083`(mand_proc_yn=Y·169 유일 공정행·CL-5 중 유일하게 공정 실재). UV/레이저커팅 세분
  공정은 미적재(GAP-AC-2 동류).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 0행. 아크릴=비종이 → 종이류 판형 로직 이식 금지(T-9). `has_plate_size` 미부여.

## 가격 경로 (★TBD — 견적 불가)
- `product-169 --priced_by--> formula-PRF_ACRYL_3DBLOCK_TBD --has_component--> component-COMP_ACRYL_PENDING_TBD`.
  단가행 0셀 → 견적 불가. **단가 미충전이 본질**([[gap-acryl-tbd-formula-no-priced-rows]]·공유·references로 O5 충족).
- ★t_prd_product_prices 0행 = gap-goods-fixed-lookup 아키타입 아님(pack T-7).
- gap 충전: 실무진 단가(source-registry §9 GAP-5·BLOCKED) → §18 설계·§7 적재(인간 승인).

## 옵션·제약·추가상품
- 옵션그룹 0·제약 0·추가상품 0.

## 승계·freshness 메모
- 미출시/TBD·공정 1행 = pack §1.1·§3.6·§4·live 07-04 신규 SELECT. live-snapshot 가격 정본 금지(T-2).
