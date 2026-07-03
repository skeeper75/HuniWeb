---
id: product-147-acrylic-magnet
type: product
anchor: t_prd_products/PRD_000147
badge: verified
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000147(prd_nm=아크릴마그넷·prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min1/max10000/incr1·nonspec_yn=Y)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "prd:PRD_000147→PRF_ACRYL_MAGNET→COMP_ACRYL_CLEAR3T(277셀·2,000~32,700) + COMP_ACRYL_MAGNET(PRICE_TYPE.01·use_dims=[opt_cd,min_qty,opt_grp:OPT_000074]·800)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-addon-templates-260704.csv", source_locator: "147 addon=자석부착(네오디움12mm) TMPL-000014(800)·옵션구성요소 COMP_ACRYL_MAGNET와 이중표현(GAP-AC-6)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M2(면적+부속선택)·§3.5 substrate 3mm+네오디움자석 부속(T-8)·§3.6 UV+부착·§3.12 부속 이중표현(GAP-AC-6)·§4 양면표", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-acryl}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: main, note: "단품형(아크릴 root CAT_000009 하위·live 20260702_1119·main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000336, note: "20x20 면적 프리셋(146-nodes 정의)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000331, note: "30x40 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000333, note: "40x40 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000334, note: "40x50 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000011, note: "50x50 면적 프리셋"}
  - {rel: has_size, target: size-SIZ_000148, note: "60x60 면적 프리셋"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm substrate(MAT_TYPE.03·USAGE.07·dflt_yn=Y). 네오디움자석(MAT_000050)은 부속=부자재이지 substrate 아님(T-8)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV(mand_proc_yn=Y·axis/processes)"}
  - {rel: has_process, target: process-PROC_000081, note: "부착(자석 결합·mand_proc_yn=N·product-138-standard-hanging-banner-nodes 정의 재사용)"}
  - {rel: has_qty_rule, target: qty-147, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_MAGNET, note: "면적+부속선택(has_component COMP_ACRYL_CLEAR3T 본체 + COMP_ACRYL_MAGNET 자석 800=Stage A). 본체 면적가 + 자석 별도합산"}
  - {rel: has_option_group, target: optgroup-147-magnet, note: "자석 택1 OPT_000074(mand_yn=Y·items 0·GAP-AC-4·147-nodes)"}
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
  archetype: "면적매트릭스+부속선택(M2·본체 COMP_ACRYL_CLEAR3T 면적가 + 자석 COMP_ACRYL_MAGNET 별도합산·pack §1.1)"
  가격상태: "면적매트릭스+부속 견적가능(본체 277셀 2,000~32,700 + 자석 800·값=evaluate_price)"
  substrate: "아크릴 투명 3mm(MAT_000043·두께변형·색상값 아님·T-8)"
  부속_이중표현: "자석 = COMP_ACRYL_MAGNET(800·OPT_000074 택1·priced 우선배선) AND addon TMPL-000014(800) — 이중표현(GAP-AC-6)"
  판형: "plate_sizes 7행 실재하나 면적공식 미참조=가격영향 없음(비종이·T-9·양면)"
standards: {schema_org: "Product", xjdf: "Product(굿즈·아크릴마그넷)", config_ont: "component type"}
answers_cq: ["아크릴마그넷 가격 경로(면적+자석)", "아크릴마그넷 자석 부속", "아크릴마그넷 사이즈"]
tags: ["#굿즈", "#아크릴", "#마그넷", "#면적매트릭스", "#비종이류", "#부속선택"]
updated: 2026-07-04
---

# 아크릴마그넷 (product-147-acrylic-magnet)

아크릴마그넷(PRD_000147)은 **아크릴 굿즈 완제품 단품**(`PRD_TYPE.01`·비종이·UV 평판). 손님이 **면적
[가로×세로] 치수**(프리셋 7종/연속·`nonspec_yn=Y`)를 고르면 컬러아크릴 **면적매트릭스**
(`COMP_ACRYL_CLEAR3T`·277셀)에서 본체가를 조회하고, **자석**(`COMP_ACRYL_MAGNET`·800)을 부속 택1해
별도 합산한다. 본체 면적가 + 부속 별도합산 모델([[goods-variant-formula-fixed-price-model-260704]]).

## 정체·유형 (SOT 준수)
- 상품유형 = **완제품(.01)** 일반 단일(`t_prd_product_sets` 부모 없음·단품·`has_member` 없음).
- 카테고리 = **단품형 `CAT_000322`**(아크릴 root `CAT_000009` 하위·main_cat_yn=N·live 20260702_1119).

## 차원
- **사이즈:** 면적 [가로×세로] — 프리셋 7종(20x20·30x30·30x40·40x40·40x50·50x50·60x60) + 연속입력
  (`nonspec_yn=Y`). 프리셋 코드·라벨 = [[product-146-acrylic-keyring-nodes]] 공유 canonical. 유효
  가격 권위 = 면적매트릭스 셀(프리셋은 W×H 입력·pack §3.2). off-grid=ceiling(앱).
- **도수:** 면적단가가 도수를 흡수(양면9도/단면7도 통용·pack §3.3).
- **수량규칙:** 제품레벨 min1/max10000/incr1(QTY_UNIT.01·[[qty-147]]).

## 자재·공정
- **자재(substrate):** **아크릴 투명 3mm** `MAT_000043`(MAT_TYPE.03·USAGE.07·dflt_yn=Y·[[material-MAT_000043]]).
  ★네오디움자석 `MAT_000050`은 `dflt_yn=N` **부속**(MAT_TYPE.07) → `uses_material`에 배선하지 않는다
  (T-8). 자석은 아래 부속(옵션구성요소+addon 이중표현)으로 표현.
- **공정:** ① UV `PROC_000002`(mand_proc_yn=Y) + ② 부착 `PROC_000081`(자석 결합·mand_proc_yn=N).
  부착은 product-138(현수막)이 정의한 노드 재사용(중복 mint 금지·L-3).

## 판형 (★비종이류 — 가격축 아님)
- `t_prd_product_plate_sizes` = 147에 **7행 실재**하나 면적공식 use_dims에 `plt_siz_cd` 없음 → **가격축
  아님**. ★양면: `현재값: plate_sizes 7행` / `가격영향: 없음`. `fn_calc_pansu` 이식 금지(T-9·pack §3.8).
  `has_plate_size` 미배선(환각 방지). GAP-AC-3=§7/§29.

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위)
- `product-147 --priced_by--> formula-PRF_ACRYL_MAGNET --has_component--> {COMP_ACRYL_CLEAR3T(본체 면적),
  COMP_ACRYL_MAGNET(자석 800)}` ([[formula/acrylic-formulas#formula-PRF_ACRYL_MAGNET]]·Stage A 공유 2 구성요소).
  **가격 경로 연결됨**. ★`t_prd_product_prices`=0행 — 전량 공식기반(gap-goods-fixed-lookup 아님·T-7).
- **본체** = `COMP_ACRYL_CLEAR3T`(면적 4축 W×H×두께×수량)·**자석** = `COMP_ACRYL_MAGNET`(PRICE_TYPE.01·
  use_dims=`[opt_cd,min_qty,opt_grp:OPT_000074]`·800·택1). 본체 면적가 + 자석 별도합산(silent 가산 아님 —
  자석 use_dims에 opt_cd 포함=선택 구동·pack §3.12). 값=evaluate_price(D-18).

## 옵션·제약·추가상품
- **옵션그룹 1:** 자석 `OPT_000074`(SEL_TYPE.01 택1·mand_yn=Y·items 0). ★items 미적재(GAP-AC-4·
  [[optgroup-147-magnet]]) — 공식 구성요소 use_dims는 `opt_grp:OPT_000074`를 참조하나 option_items 행이
  0이라 UI 선택지 미충전(양면·§31 대기).
- **제약규칙:** `t_prd_product_constraints` = 147에 **0행**(아크릴 전 상품 0·pack §3.9). 결함 아님.
- **추가상품(addon):** `t_prd_product_addons` = 147에 **자석부착** `TMPL-000014`(800). ★**이중표현**
  (GAP-AC-6): 자석이 (a) 가격구성요소 `COMP_ACRYL_MAGNET`(priced_by 공식 has_component·우선 배선)
  AND (b) addon 템플릿 `TMPL-000014`로 동시 존재. **priced_by 공식이 권위 배선**이고 addon은 props/전사표로
  병기(대상 product 노드 없어 `has_addon` 엣지 미생성·024 선례). 상세=[[product-147-acrylic-magnet-nodes]].

## 승계·freshness 메모
- 가격/부속 = 07-04 신규 라이브 SELECT 캐시(§0.2·H-1·T-2). ★"부속 자석 330,000" 등 대형 숫자는 라이브
  부재=STALE(T-1) — 실측 자석 800.
- 부속 이중표현(GAP-AC-6)·판형 양면(§3.8)·자석 substrate 아님(T-8)은 pack FRESH.
