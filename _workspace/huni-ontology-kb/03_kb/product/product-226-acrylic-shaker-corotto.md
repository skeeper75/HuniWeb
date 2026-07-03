---
id: product-226-acrylic-shaker-corotto
type: product
anchor: t_prd_products/PRD_000226
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000226(아크릴쉐이커코롯토·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N·min1/max10000/incr1·editor_yn=Y·nonspec_yn=N)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000226→PRF_GOODS_FIXED_SIZ→COMP_GOODS_FIXED_SIZ(PRICE_TYPE.01·use_dims [siz_cd]·77셀 공유·200~60,000)·★07-04 재바인딩(구 PRF_ACRYL_SHCOROTTO_TBD 대체)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live railway t_prd_product_categories/sizes/materials/options/option_items + t_prc_component_prices (07-04 읽기전용 SELECT)", source_locator: "카테고리 CAT_000009 아크릴(main)+CAT_000159 코롯토(sub)·사이즈 3행(611 양면/612 전면만/613 배면만)·글리터 4자재(MAT_000310/312/314/315·MAT_TYPE.09·dflt_yn=Y)·구 인쇄면자재(309/311/313) del_yn=Y·OPT_000203 인쇄면(OPV745-747→siz OPT_REF_DIM.01)·OPT_000204 글리터(OPV748-751→자재 OPT_REF_DIM.03·ref_key2 USAGE.07)·★COMP_GOODS_FIXED_SIZ에 611/612/613 단가행 3건(611=9,000·612/613=7,500·reg 07-03·재-SELECT acryl-226-reselect-260704.csv)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
  - {source_file: "01_curation/_cache/acryl-226-reselect-260704.csv", source_locator: "COMP_GOODS_FIXED_SIZ 226 자기 3사이즈 단가행 재-SELECT(정본): SIZ_000611 양면=9,000·SIZ_000612 전면만=7,500·SIZ_000613 배면만=7,500(min_qty NULL 단일티어·reg_dt 2026-07-03·병행 §7 굿즈 GB-2 세션 적재). ★D-AC-P1 false-gap 정정·H-1 드리프트 재발", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-reselect-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§0.1·§3.9(226 인쇄면/글리터)·§4 미출시·CL-5(§23 재바인딩·인쇄면 siz화+글리터 무가 CPQ)", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000009, qualifier: main, note: "아크릴 root 카테고리(main_cat_yn=Y·live 07-04)"}
  - {rel: in_category, target: category-CAT_000159, qualifier: sub, note: "코롯토 카테고리(보조·main_cat_yn=N·live 07-04)"}
  - {rel: has_size, target: size-SIZ_000611, note: "양면인쇄(226 로컬·-nodes·인쇄면 옵션 dflt)"}
  - {rel: has_size, target: size-SIZ_000612, note: "전면만 인쇄(226 로컬·-nodes)"}
  - {rel: has_size, target: size-SIZ_000613, note: "배면만 인쇄(226 로컬·-nodes)"}
  - {rel: uses_material, target: material-MAT_000310, note: "핑크글리터(글리터 옵션 dflt·무가 CPQ·226 로컬·-nodes)"}
  - {rel: uses_material, target: material-MAT_000312, note: "화이트글리터(글리터 옵션·226 로컬·-nodes)"}
  - {rel: uses_material, target: material-MAT_000314, note: "블루글리터(글리터 옵션·226 로컬·-nodes)"}
  - {rel: uses_material, target: material-MAT_000315, note: "블랙글리터(글리터 옵션·226 로컬·-nodes)"}
  - {rel: priced_by, target: formula-PRF_GOODS_FIXED_SIZ, note: "굿즈 사이즈등급 고정가(굿즈 공유·§23 07-04 재바인딩·[[formula-PRF_GOODS_FIXED_SIZ]] 재사용)"}
  - {rel: has_option_group, target: optgroup-226-print-face, note: "인쇄면 택1(양면/전면/배면→siz·가격축)"}
  - {rel: has_option_group, target: optgroup-226-glitter, note: "글리터 택1(핑크/화이트/블루/블랙→자재·무가)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "고정가형 by-siz(굿즈 공유 공식·§23 재바인딩)"
  status: "미출시(use_yn=N·del_yn=N)"
  use_yn: "N"
  nonspec_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  가격상태: "견적가능(미출시)·자기 siz 3행 단가 실재(611 양면=9,000·612 전면만=7,500·613 배면만=7,500·재-SELECT acryl-226-reselect-260704.csv)·값=evaluate_price 권위 — use_yn=N이라 출시 승인 대기·추천 결과 제외·팬텀 가격 금지"
  글리터: "무가 CPQ(글리터 선택은 가격 무변동·COMP use_dims=[siz_cd]만)"
  drift_note: "★구 노드(pack-stationery-goods·snap_20260702_1119)는 STALE(binding=PRF_ACRYL_SHCOROTTO_TBD·인쇄면 자재오염)을 표기 — 07-04 라이브 §23 재바인딩으로 대체(H-1·T-2 정정·CL-5 소관)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴 쉐이커코롯토)", config_ont: "component type"}
answers_cq: ["아크릴쉐이커코롯토 상품 존재·인쇄면/글리터 옵션·가격 상태(미출시)"]
tags: ["#굿즈", "#아크릴", "#쉐이커", "#코롯토", "#고정가형", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 아크릴쉐이커코롯토 (product-226-acrylic-shaker-corotto)

아크릴쉐이커코롯토(PRD_000226)는 **아크릴 굿즈 완제품 단품**(PRD_TYPE.01·비종이·CL-5·에디터 상품 editor_yn=Y).
★**미출시**(`use_yn=N`). §23 셋트 재설계에서 **굿즈 공유 고정가 공식 `PRF_GOODS_FIXED_SIZ`로 재바인딩**되고
**인쇄면이 siz로**·**글리터가 무가 CPQ로** 정리됐다(pack §3.9). 추천 결과 제외·팬텀 가격 금지(pack §4).

> ★**drift 정정:** 구 노드(pack-stationery-goods·06-30 스냅샷)는 `PRF_ACRYL_SHCOROTTO_TBD` 바인딩과 인쇄면
> 자재오염을 표기했으나, 이는 §23 재바인딩(07-03/04) 이전의 STALE 상태다(H-1·T-2). 본 노드는 **07-04 라이브
> 신규 SELECT**로 현재 상태(PRF_GOODS_FIXED_SIZ·인쇄면 siz화·글리터 옵션 소재)를 반영한다(CL-5 소관).

## 정체·유형
- 완제품(.01) 일반 단품(셋트 부모 없음·has_member 없음). 카테고리 = **아크릴 root `CAT_000009`(main)** +
  **코롯토 `CAT_000159`(sub)**(live 07-04·226만 카테고리 2행).
- ★170 아크릴쉐이커★(PRD_000170)와 별개 상품(170=PRF_ACRYL_SHAKER_TBD·이 상품=PRF_GOODS_FIXED_SIZ 재바인딩).

## 차원
- **사이즈(=인쇄면):** 3행(전부 dflt_yn=Y) — 양면인쇄(SIZ_000611·dflt)·전면만 인쇄(SIZ_000612)·배면만
  인쇄(SIZ_000613). ★사이즈명이 규격이 아니라 **인쇄면 종류**다 — 인쇄면 옵션(OPT_000203)이 siz로 환원되어
  고정가 공식의 `siz_cd` 가격축이 된다("인쇄면 siz화"·§23). 상세=[[product-226-acrylic-shaker-corotto-nodes]]. `nonspec_yn=N`.
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01).

## 자재·공정
- **자재:** 글리터 4종(핑크 `MAT_000310`·화이트 `MAT_000312`·블루 `MAT_000314`·블랙 `MAT_000315`·전부
  dflt_yn=Y·`MAT_TYPE.09`). ★글리터는 **substrate(두께)도 addon(부속)도 아닌 장식 소재**(글리터 옵션 대상·
  무가·pack §3.5 T-8 경계). `MAT_TYPE.09 봉제부자재`로 오타이핑됨(GAP-AC-1·현재값 기록). ★구 인쇄면-자재
  (MAT_000309 양면/311 전면/313 배면)는 §23에서 `del_yn=Y` 은퇴(인쇄면이 siz+옵션으로 이관) → 자재오염 해소·
  노드 미생성. 상세=[[product-226-acrylic-shaker-corotto-nodes]].
- **공정:** `t_prd_product_processes` 0행(MISSING·GAP-AC-2 동류).

## 판형 (★비종이 — 가격축 아님)
- plate_sizes 0행. 아크릴=비종이 → 종이류 판형 로직 이식 금지(T-9). `has_plate_size` 미부여.

## 가격 경로 (★견적가능·미출시 — 자기 siz 단가 실재)
- `product-226 --priced_by--> formula-PRF_GOODS_FIXED_SIZ --has_component--> component-COMP_GOODS_FIXED_SIZ`
  (굿즈 공유·[[formula-PRF_GOODS_FIXED_SIZ]]). 공식·구성요소는 실재해 O5 충족(priced_by≥1).
- ★**자기 3사이즈(SIZ_000611/612/613)는 COMP_GOODS_FIXED_SIZ에 단가행 3건 실재**(재-SELECT 07-04 정본
  `acryl-226-reselect-260704.csv`): 양면(611)=**9,000**·전면만(612)=**7,500**·배면만(613)=**7,500**
  (min_qty NULL 단일티어·reg_dt 2026-07-03·병행 §7 굿즈 GB-2 세션 07-03 적재). → **견적가능(미출시)**.
  값 계산=evaluate_price 권위(D-18). ★구축 초기 SELECT 이후 07-03 적재로 인한 H-1 드리프트를 07-04 재-SELECT로
  정정(초기 "단가행 0건=견적불가"는 false-gap·사실오류였음). 출시(use_yn=Y) 승인 대기.
- **글리터 옵션 = 무가**: 고정가 공식 use_dims=`[siz_cd]`뿐 → 글리터(자재) 선택은 가격에 영향 없음(무가 CPQ).
- ★t_prd_product_prices(직접단가룩업) 0행 = gap-goods-fixed-lookup 아키타입 아님(pack T-7·값=evaluate_price).

## 옵션·제약·추가상품
- **옵션그룹 2**(둘 다 SEL_TYPE.01 택1·mand): **인쇄면**(OPT_000203·양면/전면/배면→siz·OPT_REF_DIM.01·가격축) +
  **글리터**(OPT_000204·핑크/화이트/블루/블랙→자재·OPT_REF_DIM.03·무가). option_refs 상세·정합(fn_chk_opt_item_ref·
  같은 부모 실재)=[[product-226-acrylic-shaker-corotto-nodes]].
- **제약 0·추가상품 0**(live constraints=0·addon=0).

## 승계·freshness 메모
- §23 재바인딩·인쇄면 siz화·글리터 무가 CPQ = pack §3.9·CL-5·live 07-04 신규 SELECT(H-1 회피·T-2).
- ★live-snapshot 20260702_1119은 아크릴 가격 정본 금지(T-2)·구 노드 STALE 정정. 자기 사이즈 단가행 3건(611=9,000·612/613=7,500)은 07-04 재-SELECT(`acryl-226-reselect-260704.csv`) 실측 — 구축 초기 "0건" 판정은 07-03 병행 §7 적재 이전 스냅샷 기준 **H-1 드리프트 재발**이었고 재-SELECT로 정정(D-AC-P1).
