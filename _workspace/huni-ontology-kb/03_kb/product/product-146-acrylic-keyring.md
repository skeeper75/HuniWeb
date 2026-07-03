---
id: product-146-acrylic-keyring
type: product
anchor: t_prd_products/PRD_000146
badge: verified
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000146(prd_nm=아크릴키링·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min1/max10000/incr1·editor_yn=N·nonspec_yn=Y)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000146→PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(PRICE_TYPE.02·use_dims=[mat_cd,siz_width,siz_height,min_qty]·277셀·2,000~32,700)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-addon-templates-260704.csv", source_locator: "146 addon=칼라볼체인 8색 TMPL-000056~063(각 1,000·acryl-addons-detail reg_dt 2026-07-03)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M2b(면적+addon)·§3.5 substrate 3mm+고리/군번줄 부속(T-8)·§3.6 UV평판/레이저커팅/굿즈가공·§3.8 판형 8행 양면(T-9)·§3.12 볼체인 addon·§4 양면표", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-acryl}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: main, note: "단품형(아크릴 root CAT_000009 하위·live t_prd_product_categories 20260702_1119·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000329, note: "20x30 면적 프리셋(146-nodes 정의·shared 승격대기)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000331, note: "30x40 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000332, note: "30x70 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000333, note: "40x40 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000334, note: "40x50 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000335, note: "40x60 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50 면적 프리셋"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm substrate(MAT_TYPE.03·USAGE.07·dflt_yn=Y·axis/materials). 고리(MAT_000051/052)·군번줄(MAT_000456)은 부속=has_addon이지 substrate 아님(T-8)"}
  - {rel: has_process, target: process-PROC_000111, note: "UV평판인쇄(mand_proc_yn=Y·axis/processes·146 공정 세분화판)"}
  - {rel: has_process, target: process-PROC_000124, note: "레이저커팅(완칼 형상·product-143-mirror-acrylic-sticker-nodes 정의 재사용·T-3 위키 PROC_000053 STALE)"}
  - {rel: has_process, target: process-PROC_000151, note: "굿즈가공(mand_proc_yn=Y·axis/processes)"}
  - {rel: has_qty_rule, target: qty-146, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_CLR_ACRYL, note: "면적매트릭스 본체(silsa 동형·has_component COMP_ACRYL_CLEAR3T=Stage A formula/acrylic-formulas). 볼체인 부속은 addon 별도합산"}
  - {rel: has_option_group, target: optgroup-146-ring, note: "고리 택1 OPT_000157(items 0·GAP-AC-4·146-nodes)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  nonspec_yn: "Y"
  editor_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  use_yn: "Y"
  del_yn: "N"
  archetype: "면적매트릭스+addon(M2b·본체 COMP_ACRYL_CLEAR3T 면적가 + 볼체인 addon 별도합산·pack §1.1)"
  가격상태: "면적매트릭스 견적가능(COMP_ACRYL_CLEAR3T 277셀·2,000~32,700·값=evaluate_price)"
  substrate: "아크릴 투명 3mm(MAT_000043·두께변형·색상값 아님·T-8)"
  addon_templates: "칼라볼체인 8색 TMPL-000056~063(각 1,000·손님 택1·always-add 아님·SA-5 카탈로그)"
  판형: "plate_sizes 8행 실재하나 면적공식 미참조=가격영향 없음(비종이·T-9·양면)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴키링)", config_ont: "component type"}
answers_cq: ["아크릴키링 가격 경로(면적매트릭스)", "아크릴키링 볼체인 부속 선택", "아크릴키링 사이즈"]
tags: ["#굿즈", "#아크릴", "#키링", "#면적매트릭스", "#비종이류", "#addon"]
updated: 2026-07-04
---

# 아크릴키링 (product-146-acrylic-keyring)

아크릴키링(PRD_000146)은 **아크릴 굿즈 완제품 단품**(`PRD_TYPE.01`·비종이·UV 평판). 손님이 **면적
[가로×세로] 치수**(프리셋 8종 또는 연속입력·`nonspec_yn=Y`)를 고르면 컬러아크릴 **면적매트릭스**
(`COMP_ACRYL_CLEAR3T`·277셀)에서 본체 통가격을 조회하고, **칼라볼체인 8색**을 부속(addon)으로 택1해
별도 합산한다. silsa 포스터사인 [가로×세로] off-grid ceiling과 **동형**([[product-118-artprint-poster]]).

## 정체·유형 (SOT 준수)
- 상품유형 = **완제품(.01)** 일반 단일(`t_prd_product_sets` 부모 등록 없음·단품·`has_member` 없음).
- 카테고리 = **단품형 `CAT_000322`**(아크릴 root `CAT_000009` 하위·main_cat_yn=N·live 20260702_1119).
  leaf 귀속 정밀도는 현재값 라벨(pack §3.1 GAP).

## 차원
- **사이즈:** 면적 [가로×세로] — 프리셋 8종(20x30·30x30·30x40·30x70·40x40·40x50·40x60·50x50) +
  연속입력(`nonspec_yn=Y`). 프리셋 코드·라벨 = [[product-146-acrylic-keyring-nodes]] 전사표. ★유효
  가격 권위 = 면적매트릭스 셀(프리셋은 W×H를 매트릭스에 넣는 입력 UX·pack §3.2). off-grid=한 단계
  큰 규격 ceiling(앱 계산). {snapshot 8행·07-04 summary 9행 — 1행 신규(드리프트)·[[product-146-acrylic-keyring-nodes]]}
- **도수:** 면적단가가 "양면9도/단면7도 통용단가"로 도수를 흡수(단가표 헤더·pack §3.3) — 도수 컬럼 축
  얕음. `t_prd_product_print_options` 얕음(설계상·결함 아님).
- **수량규칙:** 제품레벨 min1/max10000/incr1(QTY_UNIT.01·[[qty-146]]). 면적매트릭스 use_dims에
  `min_qty` 포함(수량 티어 실재).

## 자재·공정
- **자재(substrate):** **아크릴 투명 3mm** `MAT_000043`(MAT_TYPE.03·USAGE.07·dflt_yn=Y·[[material-MAT_000043]]).
  substrate = 두께변형이지 색상값 아님(T-8). ★고리(은색 `MAT_000051`·금색 `MAT_000052`)·군번줄
  `MAT_000456`은 `dflt_yn=N` **부속**(MAT_TYPE.07 포장부자재) → `uses_material`에 배선하지 않는다
  (오염 방지·T-8). 부속은 아래 addon으로 표현. ★IMPORT 등록 자재 삭제 금지.
- **공정:** ① UV평판인쇄 `PROC_000111` + ② 레이저커팅 `PROC_000124`(완칼 형상) + ③ 굿즈가공
  `PROC_000151`(전부 mand_proc_yn=Y). ★146은 6월 이후 **공정 세분화판**(대다수 아크릴은 `PROC_000002 UV`
  단일·pack §3.6·T-3). 레이저커팅은 product-143(미러 아크릴스티커)이 정의한 노드 재사용(중복 mint 금지·L-3).

## 판형 (★비종이류 — 가격축 아님)
- 라이브 `t_prd_product_plate_sizes` = 146에 **8행 실재**하나 면적공식(`COMP_ACRYL_CLEAR3T`)의
  use_dims=`[mat_cd,siz_width,siz_height,min_qty]`에 **`plt_siz_cd` 없음** → 판형은 **가격축 아님**
  (생산 임포지션 메타 or 오적재 의심). ★**양면 표기:** `현재값: plate_sizes 8행` / `가격영향: 없음`.
  종이류 `fn_calc_pansu`·`fn_best_plate` 이식 금지(pack §3.8·T-9·[[harness-domain-rules-12-260701]]).
  그래서 `has_plate_size` 관계를 걸지 않는다(환각 방지). GAP-AC-3(성격 판정)=§7/§29.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-146 --priced_by--> formula-PRF_CLR_ACRYL --has_component--> component-COMP_ACRYL_CLEAR3T`
  ([[formula/acrylic-formulas#formula-PRF_CLR_ACRYL]]·[[formula/acrylic-components#component-COMP_ACRYL_CLEAR3T]]·Stage A
  공유). **가격 경로 연결됨**(고아 공식 아님). ★`t_prd_product_prices`(직접단가룩업)=0행 — 아크릴은
  전량 공식기반이므로 `gap-goods-fixed-lookup-no-formula` 아키타입 **아님**(T-7).
- **면적매트릭스형** = 단일 구성요소 `COMP_ACRYL_CLEAR3T`를 use_dims 4축(두께 mat_cd × 가로 siz_width
  × 세로 siz_height × 수량 min_qty)으로 조회. 값(unit_price)은 기록하지 않는다(차원 선언까지·D-18·
  [[rule/rules#RULE_price_value_boundary]]).
- **볼체인 부속(addon)**: 본체 면적가 + 볼체인 별도합산([[goods-variant-formula-fixed-price-model-260704]]
  "본체 공식 + 부자재 별도합산"). 8색 택1(always-add 아님)·상세 전사=[[product-146-acrylic-keyring-nodes]].

## 옵션·제약·추가상품
- **옵션그룹 1:** 고리 `OPT_000157`(mand_yn=N·items 0). ★items 미적재(GAP-AC-4·[[optgroup-146-ring]])
  — 옵션그룹은 있으나 선택지 행이 없다(양면·§31 대기).
- **제약규칙:** `t_prd_product_constraints` = 146에 **0행**(아크릴 전 상품 0행·pack §3.9). 결함 아님(현재값).
- **추가상품(addon):** `t_prd_product_addons` = 146에 **볼체인 8종**(TMPL-000056~063·각 1,000). R14
  `has_addon`의 실 배선=product→template(tmpl_cd)이나 볼체인은 판매 universe 상품이 아니라
  `t_prd_templates` 부자재라 대상 product 노드가 없다 → **`has_addon` 엣지 미생성**(끊긴 링크 방지·
  024 선례) → props·[[product-146-acrylic-keyring-nodes]] 전사표로 접음(SA-5 카탈로그 인용).

## 승계·freshness 메모
- 가격/부속 = 07-04 신규 라이브 SELECT 캐시(§0.2·H-1 회피·T-2 — snapshot 20260702 가격 정본 금지).
  볼체인 addon reg_dt 2026-07-03(병행 dbmap 세션 적재 실측).
- ★과업/구 문서의 "146 키링=480,000" 대형 숫자는 **라이브 부재=STALE**(T-1) — 실측 면적 최대
  32,700·볼체인 1,000. 인용 금지.
- 판형·부속 양면은 pack §3.8·§3.12·§4(FRESH). 위키 상품수(23)·PROC 코드는 REVERIFY 완료(라이브 재측정).
