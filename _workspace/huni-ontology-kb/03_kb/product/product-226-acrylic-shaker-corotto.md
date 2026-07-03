---
id: product-226-acrylic-shaker-corotto
type: product
anchor: t_prd_products/PRD_000226
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000226 (prd_typ_cd=PRD_TYPE.01·use_yn=N·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.2 굿즈 226 아크릴쉐이커코롯토(use_yn=N·gap)·§0.1 아크릴 *_TBD BLOCKED·§4 NEITHER-gap 행", captured_at: "2026-07-04", badge: candidate, src_id: SR-pack-stn}
relations:
  - {rel: in_category, target: category-CAT_000009, qualifier: main, note: "굿즈 카테고리(main·live t_prd_product_categories 20260702_1119)"}
  - {rel: in_category, target: category-CAT_000159, qualifier: sub, note: "굿즈 카테고리(보조·live t_prd_product_categories 20260702_1119)"}
  - {rel: references, target: gap-226-acryl-tbd, note: "라이브 priced_by=PRF_ACRYL_SHCOROTTO_TBD(구성/단가 미설정 placeholder)·실 가격 원천 부재. O5 충족(gap 선언)"}
  - {rel: references, target: gap-goods-material-contamination, note: "자재 7행(인쇄면 3·글리터색 4)=옵션 값을 자재로 등록(비-소재 값 자재화·GP-ST-003)·substrate 아님"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "NEITHER-substance(가격공식=TBD placeholder·단가 미설정)"
  use_yn: "N"
  del_yn: "N"
  min_qty: 1
  max_qty: 10000
  qty_incr: 1
  qty_unit_typ_cd: "QTY_UNIT.01"
  file_upload_yn: "Y"
  editor_yn: "Y"
  미출시: "use_yn=N — 라이브 미출시(팬텀 가격 금지·정직 표기)"
  live_formula_binding: "PRF_ACRYL_SHCOROTTO_TBD (★구성/단가 미설정·미바인딩 해소 시그널·COMP_ACRYL_PENDING_TBD 1행)"
  scope_note: "아크릴 계열(CAT_000009 아크릴·CAT_000159 코롯토)·팩 §0.1상 아크릴 공식은 pack-acrylic 소관 — 본 노드는 정체·gap 정직 표기까지"
standards: {schema_org: "Product", xjdf: "Product(아크릴쉐이커/Goods)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(아크릴쉐이커코롯토 구성)", "미출시·가격 미설정 상태 확인"]
tags: ["#굿즈", "#아크릴", "#코롯토", "#TBD", "#미출시", "#비종이"]
updated: 2026-07-04
---

# 아크릴쉐이커코롯토 (product-226-acrylic-shaker-corotto)

아크릴쉐이커코롯토(PRD_000226)는 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·[[product-type-classification-sot]]).
라이브 실측상 `t_prd_product_sets` 등록이 없어 단품(셋트 아님)이다. **`use_yn=N` = 라이브 미출시** —
노드는 생성하되 미출시로 정직 표기(팬텀 가격 금지). 파일 업로드·에디터 지원. 최소 1·최대 10000·증분 1.

- **가격 상태(D-18)/TBD placeholder:** 라이브 `t_prd_product_price_formulas`에 226 행이 **1개 있으나**
  `PRF_ACRYL_SHCOROTTO_TBD`(공식명 "아크릴쉐이커코롯토 ★구성/단가 미설정"·note "미바인딩 해소 시그널 — 권위
  확정 후 정상 공식/단가 교체")이고 구성요소도 `COMP_ACRYL_PENDING_TBD` 1행짜리 placeholder다. 즉 **실 가격
  원천은 부재** → priced_by를 정상 공식으로 걸지 않고 [[gap-226-acryl-tbd]]로 정직 선언(O5 충족).
  고정가(`t_prd_product_prices`)도 0행.
- **아크릴 계열·범위 경계:** 카테고리가 아크릴(CAT_000009)/코롯토(CAT_000159)라 아크릴 계열이다. 팩 §0.1상
  아크릴 가격공식(`PRF_ACRYL_*`·면적매트릭스·*_TBD 실무진 BLOCKED)은 별도 `pack-acrylic` 소관 — 본 노드는
  정체·미출시·가격 TBD의 정직 표기까지만 하고 공식 설계는 아크릴 팩에 위임.
- **판형 없음:** 아크릴(비종이)이라 판형·판걸이수 해당 없음([[rule/rules#RULE_plate_paper_only]]·`t_prd_product_plate_sizes` 0행).
- **공정·인쇄옵션·사이즈 0행:** 셋 다 라이브 0행(인쇄면/색은 자재로 등록·아래).

## 카테고리 — 관찰 전사 (축 노드 미민팅·배선 대기)

<!-- transcribed-by: awk t_prd_product_categories.csv+t_cat_categories.csv PRD_000226 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| cat_cd | 이름 | 부모 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000009 | 아크릴 | (root) | Y | 15 |
| CAT_000159 | 코롯토 | CAT_000009 | N | |

카테고리 축 노드 미민팅 → `in_category` 배선 대기(needs_axis 반환). main = 아크릴(CAT_000009).

## 자재(BOM) — 관찰 전사 (인쇄면·색을 자재로 등록·GP-ST-003)

<!-- transcribed-by: awk t_prd_product_materials.csv+t_mat_materials.csv (del_yn≠Y) PRD_000226 from live-snapshot/latest snap_20260702_1119 @ 2026-07-04 -->
| mat_cd | 이름 | mat_typ | usage_cd |
|---|---|---|---|
| MAT_000309 | 양면인쇄 | MAT_TYPE.09 | USAGE.07 |
| MAT_000311 | 전면만 인쇄 | MAT_TYPE.09 | USAGE.07 |
| MAT_000313 | 배면만 인쇄 | MAT_TYPE.09 | USAGE.07 |
| MAT_000310 | 핑크글리터 | MAT_TYPE.09 | USAGE.07 |
| MAT_000312 | 화이트글리터 | MAT_TYPE.09 | USAGE.07 |
| MAT_000314 | 블루글리터 | MAT_TYPE.09 | USAGE.07 |
| MAT_000315 | 블랙글리터 | MAT_TYPE.09 | USAGE.07 |

활성 7행. 자재명이 인쇄면(양면/전면만/배면만)·글리터 색(핑크/화이트/블루/블랙)이라 substrate 소재가 아니라
**옵션 값을 자재로 등록**(비-소재 값 자재화·GP-ST-003) → `uses_material` 배선 안 함(관찰 권위=전사·
[[gap-goods-material-contamination]]). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

## 옵션·제약·추가상품

- **CPQ 옵션그룹:** 인쇄면·색이 옵션 축이나 정규 옵션 레이어 미적재(자재 대행) → 활성 옵션그룹 노드 미등재.
- **제약규칙:** `t_prd_product_constraints` 0행 → 활성 제약 없음.
- **추가상품:** `t_prd_product_addons` 0행.

## 이 상품 전용 하위 노드 (gap)

### [gap-226-acryl-tbd] 아크릴쉐이커코롯토 가격공식 TBD placeholder(구성/단가 미설정) {unknown}
- type: gap
- anchor: none  # 사유: 라이브 priced_by가 PRF_ACRYL_SHCOROTTO_TBD(미설정 placeholder)라 정상 가격 원천 부재 — 정상 공식 노드 미민팅
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "prd_cd:PRD_000226 frm_cd:PRF_ACRYL_SHCOROTTO_TBD (note '미바인딩 해소 시그널')", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_ACRYL_SHCOROTTO_TBD → COMP_ACRYL_PENDING_TBD (1행 placeholder)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "226 아크릴쉐이커코롯토 가격공식이 TBD placeholder(PRF_ACRYL_SHCOROTTO_TBD·구성요소 COMP_ACRYL_PENDING_TBD 1행)로만 존재 — 실 구성/단가 미설정이라 견적 불가. 아크릴 *_TBD = 실무진 단가 BLOCKED(팩 §0.1·source-registry GAP-5 동류)"
- gap_fill_from: "실무진 단가 확정 → pack-acrylic 소관 아크릴 가격공식 설계(면적매트릭스·PRF_ACRYL_*)로 정상 공식/단가 교체 후 priced_by 정본화"
- gap_owner: staff
- 본문: 라이브에 가격공식 행은 있으나 미설정 placeholder라 "가격 있는 것처럼" 표기하지 않는다(정직 GAP). 채움=실무진 단가 확정 후 아크릴 팩.
