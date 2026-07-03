---
id: product-164-acrylic-corotto
type: product
anchor: t_prd_products/PRD_000164
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000164(아크릴코롯토·prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N·min1/max10000/incr1·nonspec_yn=Y)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000164→PRF_COROTTO_ACRYL→COMP_ACRYL_COROTTO(PRICE_TYPE.01·use_dims [siz_width,siz_height]·36셀·3,600~8,400)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "live railway t_prd_product_categories/t_prd_product_sizes/t_prd_product_materials (07-04 읽기전용 SELECT)", source_locator: "카테고리 CAT_000159 코롯토(main_cat_yn=N)·사이즈 6행(011/043/148/211/330/333 dflt_yn=Y)·자재 MAT_000044(8mm·dflt_yn=Y)·공정 0행", captured_at: "live 2026-07-04", badge: verified, src_id: SR-live-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M5 코롯토 면적공식·§4 미출시 정직 표기·CL-5", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000159, qualifier: main, note: "코롯토 카테고리(main_cat_yn=N·live 07-04·유일 카테고리 행)"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50(타 상품 정의·재사용)"}
  - {rel: has_size, target: size-SIZ_000043, note: "80x80(타 상품 정의·재사용)"}
  - {rel: has_size, target: size-SIZ_000148, note: "60x60(164 로컬 신설·-nodes)"}
  - {rel: has_size, target: size-SIZ_000211, note: "70x70(164 로컬 신설·-nodes)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30mm(164 로컬 신설·-nodes)"}
  - {rel: has_size, target: size-SIZ_000333, note: "40x40mm(164 로컬 신설·-nodes)"}
  - {rel: uses_material, target: material-MAT_000044, note: "아크릴 투명 8mm substrate(dflt_yn=Y·axis 공유·MAT_TYPE.03 오타이핑 GAP-AC-1)"}
  - {rel: priced_by, target: formula-PRF_COROTTO_ACRYL, note: "코롯토 면적공식(W×H·36셀·SA-3 공유 공식·acrylic-formulas.md)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "면적공식(W×H·수량 티어 없음)"
  status: "미출시(use_yn=N·del_yn=N)"
  use_yn: "N"
  nonspec_yn: "Y"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  editor_yn: "N"
  가격상태: "면적공식 견적가능(36셀 실재)이나 미출시 — 추천 결과 제외·팬텀 가격 금지"
  공정상태: "product_processes 0행(MISSING·GAP-AC-2)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴 코롯토)", config_ont: "component type"}
answers_cq: ["아크릴 코롯토 상품 존재·가격 모델(미출시)"]
tags: ["#굿즈", "#아크릴", "#코롯토", "#면적공식", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 아크릴코롯토 (product-164-acrylic-corotto)

아크릴코롯토(PRD_000164)는 **아크릴 굿즈 완제품 단품**(PRD_TYPE.01·비종이·CL-5 코롯토류). ★**미출시**
(`use_yn=N`·`del_yn=N`) — 정상 등록됐으나 화면 미노출. 추천 결과에서 제외하고 팬텀 가격을 만들지 않는다
(pack §4). 가격은 **코롯토 면적공식**(M5)으로 **견적 가능**하나(단가행 36셀 실재), 미출시라 값 계산은
출시 승인 후에만 의미가 있다.

## 정체·유형 (SOT 준수)
- 상품유형 = **완제품(.01)** 일반 단품(`t_prd_product_sets` 부모 등록 없음·has_member 없음).
- 카테고리 = **코롯토 `CAT_000159`**(live 07-04·main_cat_yn=N·유일 카테고리 행). 아크릴 root `CAT_000009`는
  164 행에 없음(현재값·정직).

## 차원
- **사이즈:** 규격 6행(전부 dflt_yn=Y·del_yn=N) — 50x50(SIZ_000011)·80x80(SIZ_000043)·60x60(SIZ_000148)·
  70x70(SIZ_000211)·30x30mm(SIZ_000330)·40x40mm(SIZ_000333). `nonspec_yn=Y`(연속 입력 병존). ★코롯토
  면적공식은 `[siz_width, siz_height]`로 조회하므로 이 규격들이 W×H 격자에 매핑된다. 상세=[[product-164-acrylic-corotto-nodes]].
- **도수:** 면적단가에 흡수(도수 축 얕음·pack §3.3).
- **수량규칙:** min 1·max 10000·incr 1(QTY_UNIT.01). 코롯토 면적공식 use_dims에 min_qty 없음 → **수량축이
  가격 차원 아님**(셀단가=W×H 통가격).

## 자재·공정
- **자재:** 아크릴 투명 8mm `MAT_000044`(dflt_yn=Y·substrate 두께·axis 공유 노드). ★substrate=두께(색상값
  아님·pack §3.5·T-8). `MAT_TYPE.03`으로 타이핑됨(아크릴판인데 부자재 유형·GAP-AC-1·현재값 기록).
- **공정:** ★`t_prd_product_processes` **0행**(MISSING). 아크릴 정체 공정(UV/레이저커팅/굿즈가공)이 164에
  미적재 = **[GAP-AC-2]**(레이저커팅/굿즈가공 미적재). 결함 신호이나 미출시라 출시 전 보강 대상.

## 판형 (★비종이 — 가격축 아님)
- `t_prd_product_plate_sizes` = 164 **0행**(product-summary plate=0). 아크릴=비종이(UV 평판)·면적공식
  `plt_siz_cd` 미참조 → 종이류 `fn_calc_pansu`/`fn_best_plate` 로직 이식 금지(pack §3.8·T-9). `has_plate_size`
  관계 미부여(정직 표기).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-164 --priced_by--> formula-PRF_COROTTO_ACRYL --has_component--> component-COMP_ACRYL_COROTTO`
  (SA-3 공유 공식·[[formula-PRF_COROTTO_ACRYL]]·[[component-COMP_ACRYL_COROTTO]]). **가격 경로 연결됨**(고아
  공식 아님·단가행 36셀 실재·3,600~8,400).
- **면적공식형**: 단일 구성요소 `COMP_ACRYL_COROTTO`를 `[siz_width, siz_height]` 2축으로 조회(off-grid
  ceiling=엔진). ★**t_prd_product_prices(직접단가룩업) 0행** = 아크릴은 gap-goods-fixed-lookup 아키타입이
  아님(pack T-7). 값(unit_price)은 미전사 — 연결·차원·셀수까지만(값=evaluate_price·[[rule/rules#RULE_price_value_boundary]]).

## 옵션·제약·추가상품
- **옵션그룹 0·제약 0·추가상품 0**(product-summary og=0·addon=0·live constraints=0). 순수 규격 선택형(부속 없음).

## 승계·freshness 메모
- 가격 사슬·미출시·MISSING 공정은 pack §1.1(M5)·§4·§3.6(GAP-AC-2)·live 07-04 신규 SELECT(H-1 회피·T-2).
- ★live-snapshot 20260702_1119은 아크릴 가격 정본 금지(T-2) — 가격 구조는 07-04 캐시·SELECT에서만. 대형
  부속 숫자(480k/590k 등)는 STALE(T-1).
