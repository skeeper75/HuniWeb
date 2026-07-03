---
id: product-156-acrylic-zibitz
type: product
anchor: t_prd_products/PRD_000156
badge: verified
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000156 아크릴지비츠(prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min1/max10000/incr1·editor_yn=N·nonspec_yn=Y)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000156→PRF_ZIBITZ_ACRYL→COMP_ACRYL_ZIBITZ(PRICE_TYPE.01·use_dims [opt_cd,min_qty,opt_grp:OPT_000083]·price_rows 2·200~600)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M4 부속선택 공식·§5.1 CL-4·§3.6 공정 MISSING 10상품(156 포함)·§3.5 substrate 두께", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000322, qualifier: sub, note: "단품형(CAT_000322·상위 CAT_000009 아크릴·main_cat_yn=N·live t_prd_product_categories 20260702_1119)"}
  - {rel: has_size, target: size-SIZ_000352, note: "15x15(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000336, note: "20x20(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000353, note: "25x25(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000330, note: "30x30(dflt_yn=Y·del_yn=N)"}
  - {rel: has_size, target: size-SIZ_000354, note: "35x35(dflt_yn=Y·del_yn=N)"}
  - {rel: uses_material, target: material-MAT_000043, note: "아크릴 투명 3mm(substrate 두께·USAGE.07·dflt_yn=Y — 색상값 아님·T-8)"}
  - {rel: has_qty_rule, target: qty-156, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_ZIBITZ_ACRYL, note: "부속선택 공식(M4·가공 택1 opt_cd 룩업·Stage A 공유 공식)"}
  - {rel: has_option_group, target: optgroup-156-gagong, note: "가공 택1(투명/스핀·opt_cd가 가격차원)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  editor_yn: "N"
  nonspec_yn: "Y"
  use_yn: "Y"
  del_yn: "N"
  archetype: "부속선택 공식형(M4·opt_cd 룩업·COMP_ACRYL_ZIBITZ use_dims=[opt_cd,min_qty,opt_grp:OPT_000083])"
  가격상태: "공식기반(PRF_ZIBITZ_ACRYL·단가행 2·값=evaluate_price 권위·직접단가룩업 아님·T-7)"
  구분: "아크릴 굿즈 완제품 단품(비종이·UV·has_member 없음)"
standards: {schema_org: "Product", xjdf: "Product(아크릴 굿즈/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴지비츠 가격 경로)", "가공(투명/스핀) 선택 가격"]
tags: ["#굿즈", "#아크릴", "#지비츠", "#부속선택공식", "#비종이"]
updated: 2026-07-04
---

# 아크릴지비츠 (product-156-acrylic-zibitz)

아크릴지비츠(PRD_000156)는 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이·UV).
`t_prd_product_sets` 부모 등록이 없어 단품(셋트 아님·[[product-type-classification-sot]]). 활성 상품
(`use_yn=Y`·`del_yn=N`). 손님이 **가공(투명/스핀)** 을 택1하고 **규격(15~35mm 정사각)** 을 고르면,
**부속선택 공식**(`PRF_ZIBITZ_ACRYL`)이 가공(opt_cd) × 수량(min_qty)으로 단가를 조회한다(M4 아키타입).
파일 업로드 방식(에디터 미사용·`editor_yn=N`). 수량 1~10000·증분 1.

- **★가격 아키타입 = 부속선택 공식(M4·면적매트릭스 아님)**: 컬러아크릴 본체(면적매트릭스 `COMP_ACRYL_CLEAR3T`)와
  달리, 지비츠는 **`COMP_ACRYL_ZIBITZ`**(`PRICE_TYPE.01`·use_dims `[opt_cd, min_qty, opt_grp:OPT_000083]`·
  단가행 2개·200~600원)를 **가공 선택(opt_cd)** 으로 조회한다. `priced_by`→[[formula-PRF_ZIBITZ_ACRYL]]
  →`has_component`→[[component-COMP_ACRYL_ZIBITZ]](둘 다 Stage A 공유 노드). ★**t_prd_product_prices
  직접단가룩업 아님**(아크릴 전량 공식기반·`gap-goods-fixed-lookup-no-formula` 붙이지 말 것·T-7).
  값 계산=evaluate_price 권위(KB 밖·[[rule/rules#RULE_price_value_boundary]]).
- **★공정 MISSING(정직)**: 라이브 `t_prd_product_processes` = 156 행 **0개**(공정 미적재 10상품 중 하나·
  pack §3.6 GAP-AC-2). UV·레이저커팅·굿즈가공이 실제로는 걸려야 하나 적재 안 됨 → `has_process`를 걸지
  않는다(환각 방지·정직). 가격에는 영향 없음(공식이 opt_cd로 조회·공정비 원자합산 아님).
- **substrate = 아크릴 투명 3mm(두께·색상값 아님·T-8)**: 자재 `MAT_000043`(USAGE.07·dflt_yn=Y).
  투명/스핀은 **가공(옵션)** 이지 substrate 아님 — 부속을 `uses_material`에 배선하지 않는다(오염 방지).
- **판형 없음**: `acryl-product-summary`(plate=0)·비종이(UV 평판)라 판형·판걸이수 해당 없음
  ([[rule/rules#RULE_plate_paper_only]]·T-9).
- 상세(사이즈 5·가공 옵션그룹·수량규칙)=[[product-156-acrylic-zibitz-nodes]].

## 카테고리 — 관찰 전사

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000156 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | cat_lvl |
|---|---|---|---|---|
| CAT_000322 | 단품형 | CAT_000009(아크릴) | N | 2 |

main 카테고리 미지정(main_cat_yn=N) — 라이브 상태 그대로. `in_category`는 Stage A 공유 노드
[[category-CAT_000322]] 참조(sub).

## 승계·freshness 메모
- 가격모델(M4)·공정 MISSING·substrate 두께는 pack §1.1·§3.5·§3.6(FRESH·07-04 라이브 재프라이싱).
- ★live-snapshot `snap_20260702_1119`은 아크릴 가격 정본 아님(H-1·T-2) — 가격/단가행은 07-04 신규
  SELECT 캐시(`acryl-price-chain-260704.csv`)에서만 인용. 156 가격 사슬 연결됨(고아·미배선 아님).
- 과업/구 문서 대형 부속 숫자(480k/590k 등)는 라이브 부재 STALE(T-1) — 지비츠 단가 200~600원(공유
  구성요소 범위).
