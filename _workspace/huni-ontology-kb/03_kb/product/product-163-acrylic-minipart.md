---
id: product-163-acrylic-minipart
type: product
anchor: t_prd_products/PRD_000163
badge: candidate
sources:
  - {source_file: "01_curation/_cache/acryl-universe-260704.csv", source_locator: "키:PRD_000163 아크릴미니파츠(prd_typ_cd=PRD_TYPE.01·use_yn=Y·del_yn=N·min1/max10000/incr1·editor_yn=N·nonspec_yn=N)", captured_at: "live 2026-07-04", badge: verified, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-price-chain-260704.csv", source_locator: "PRD_000163→PRF_ACRYL_MINIPART→COMP_ACRYL_MINIPART_TBD(PRICE_TYPE.02·use_dims [siz_cd,min_qty]·price_rows 1·placeholder 10,000·note 단가 미정)", captured_at: "live 2026-07-04", badge: candidate, src_id: SR-ac-0704}
  - {source_file: "01_curation/_cache/acryl-prod-formulas-260704.csv", source_locator: "키:(PRD_000163,PRF_ACRYL_MINIPART) note '단가 미정 시그널(실무진 확인 후 단가행 추가)'", captured_at: "live 2026-07-04", badge: candidate, src_id: SR-ac-0704}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-acrylic.md", source_locator: "§1.1 M4·§4 TBD placeholder 단가(163 양면 current 10,000 / authority 미정)·§5.1 CL-4·GAP-AC-5", captured_at: "2026-07-04", badge: verified, src_id: SR-pack-ac}
relations:
  - {rel: in_category, target: category-CAT_000163, note: "액세서리(CAT_000009 아크릴 하위·cat_lvl 2·t_prd_product_categories 정션 실재·260704 Stage C 배선)"}
  - {rel: has_size, target: size-SIZ_000365, note: "120x50 규격(dflt_yn=Y·del_yn=N)"}
  - {rel: uses_material, target: material-MAT_000042, note: "아크릴 투명 1.5mm(substrate 두께·USAGE.07·dflt_yn=Y — 색상값 아님·T-8)"}
  - {rel: has_process, target: process-PROC_000002, note: "UV(mand_proc_yn=Y·Stage A 공유 공정)"}
  - {rel: has_qty_rule, target: qty-163, note: "제품레벨 min1/max10000/incr1(QTY_UNIT.01)"}
  - {rel: priced_by, target: formula-PRF_ACRYL_MINIPART, note: "고정가형 by-siz 공식(M4·단가 placeholder 10,000·Stage A 공유·O5 충족)"}
  - {rel: references, target: gap-acryl-tbd-formula-no-priced-rows, note: "163 단가행 1셀=placeholder 10,000(단가 미정·실무진 확정 대기)→양면 정직 선언"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  editor_yn: "N"
  nonspec_yn: "N"
  use_yn: "Y"
  del_yn: "N"
  archetype: "고정가형 by-siz(M4·placeholder·COMP_ACRYL_MINIPART_TBD use_dims=[siz_cd,min_qty])"
  가격상태_양면: "current=10,000원(placeholder·note '단가 미정') / authority=미정(실무진 확정 대기)"
  가격상태: "공식기반 placeholder(PRF_ACRYL_MINIPART·단가행 1·직접단가룩업 아님·T-7). 견적은 되나 값 미확정(candidate)"
  구분: "아크릴 굿즈 완제품 단품(비종이·UV·has_member 없음)"
standards: {schema_org: "Product", xjdf: "Product(아크릴 굿즈/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴미니파츠 가격 경로)", "가격 placeholder(단가 미정) 상태 확인"]
tags: ["#굿즈", "#아크릴", "#미니파츠", "#고정가형", "#TBD양면", "#비종이"]
updated: 2026-07-04
---

# 아크릴미니파츠 (product-163-acrylic-minipart)

아크릴미니파츠(PRD_000163)는 **아크릴 굿즈 완제품 단품**(`prd_typ_cd=PRD_TYPE.01`·비종이·UV).
`t_prd_product_sets` 부모 등록이 없어 단품(셋트 아님·[[product-type-classification-sot]]). **활성 상품**
(`use_yn=Y`·`del_yn=N` — 미출시 아님). 손님이 **규격(120x50)** 을 고르면 **고정가형 by-siz 공식**
(`PRF_ACRYL_MINIPART`)이 사이즈(siz_cd) × 수량(min_qty)으로 단가를 조회한다(M4 아키타입). 파일 업로드
방식(에디터 미사용·`editor_yn=N`). 수량 1~10000·증분 1.

- **★가격 상태 = placeholder 양면(단가 미정·badge=candidate)**: `priced_by`→[[formula-PRF_ACRYL_MINIPART]]
  →`has_component`→[[component-COMP_ACRYL_MINIPART_TBD]]. 구성요소 단가행이 **1개뿐이고 값이 placeholder
  10,000원**(라이브 note "단가 미정 시그널 — 실무진 확인 후 단가행 추가")이다. 즉 **견적은 되지만(0행 견적불가
  아님) 값이 확정 안 됨** → 양면 정직 표기: **current=10,000(placeholder) / authority=미정(실무진)**.
  가격 사슬은 연결됨(priced_by ≥1·O5 충족)이나 값 신뢰는 미확정이라 상품 badge=**candidate**(defect 아님·
  file-format-spec 지침). 두 얼굴은 공유 [[gap-acryl-tbd-formula-no-priced-rows]]로 선언(163은 placeholder
  1행, 165/168/169/170은 0행 계열). 값 계산=evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]).
- **★t_prd_product_prices 직접단가룩업 아님(T-7)**: 아크릴 전량 공식기반 — `gap-goods-fixed-lookup-no-formula`
  붙이지 말 것. 163은 공식(PRF_ACRYL_MINIPART) 경유 placeholder이지 굿즈식 직접 unit_price 룩업이 아니다.
- **자재·공정**: substrate = 아크릴 투명 1.5mm(`MAT_000042`·USAGE.07·dflt_yn=Y·두께이지 색상값 아님·T-8).
  공정 = UV(`PROC_000002`·mand_proc_yn=Y·Stage A 공유). 156과 달리 163은 UV 1행 실적재(공정 MISSING 아님).
- **★판형 없음(비종이·file-spec placeholder)**: `t_prd_product_plate_sizes` 163 = 1행이나 **`del_yn=Y`·
  `output_file_typ=PDF`·note "파일사양"** = 파일 규격 placeholder(출력용지 판형 아님·06-30 논리삭제). 실사
  118·거울 185와 동형 → `has_plate_size` 걸지 않음(비종이 UV 평판·종이류 fn_calc_pansu 이식 금지·T-9·
  [[rule/rules#RULE_plate_paper_only]]).
- 상세(사이즈 1·수량규칙)=[[product-163-acrylic-minipart-nodes]].

## 카테고리 — 관찰 전사 (축 노드 미민팅·needs_axis 반환)

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000163 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | cat_lvl |
|---|---|---|---|---|
| CAT_000163 | 액세서리 | CAT_000009(아크릴) | N | 2 |

카테고리 `CAT_000163`(액세서리)는 **260704 Stage C에 axis/categories.md로 민팅 완료** → main 프론트매터
`in_category: category-CAT_000163` 배선 완료(needs_axis 해소·226 동형 처리·환각 방지).

## 승계·freshness 메모
- 가격모델(M4 placeholder)·양면·substrate·판형 판정은 pack §1.1·§4·§3.5·§3.8(FRESH·07-04 재프라이싱).
- ★live-snapshot `snap_20260702_1119`은 아크릴 가격 정본 아님(H-1·T-2) — 단가 placeholder(10,000)·양면은
  07-04 신규 SELECT 캐시(`acryl-price-chain-260704.csv`·`acryl-prod-formulas-260704.csv`)에서만 인용.
- ★과업/구 문서 대형 부속 숫자(480k/590k 등)는 라이브 부재 STALE(T-1) — 163 placeholder=10,000(단가 미정).
