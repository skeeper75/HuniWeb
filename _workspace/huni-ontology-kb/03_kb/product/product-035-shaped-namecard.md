---
id: product-035-shaped-namecard
type: product
anchor: t_prd_products/PRD_000035
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000035", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함=인쇄홍보물)·§3.3 도수=print_opt·§3.10 가격공식", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N·upr CAT_000003)"}
  # 차원 — 사이즈 (R2 has_size — 단일 사이즈·공유 축 재사용)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm 단일(dflt Y·032/033 공유 명함 사이즈 재사용)"}
  # 자재 (R3 uses_material — 단일 본문 자재·USAGE.07 default 슬롯·공유 축 재사용)
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g(USAGE.07·dflt Y·023/027/046 공유 축 재사용)"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005 4도)"}
  # 판형 (R6 has_plate_size — 종이류·공유 축 국전계열·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01"}
  # 가격 (R8 priced_by — 명함 모양 전용 고정가·SHARED 노드는 needed_shared_nodes로 mint 대기)
  - {rel: priced_by, target: formula-PRF_NAMECARD_SHAPE, note: "모양명함 면/수량별 단가(용지포함)·SHAPE_S1/S2 print_opt 태깅·siz_cd 정확매칭"}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  archetype_price: "고정가(용지포함)"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). t_prd_product_bundle_qtys 0행·사이즈 수량규칙(min/max/incr) 공란"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 모양, 고정가]
updated: 2026-07-03
---

# 상품: 모양명함 (PRD_000035)

모양명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·SOT: 완제품=셋트 아닌 단일
제조상품·`t_prd_product_sets` 부모 미등록). 명함 카테고리의 **모양(shape) 변형** 상품 —
스탠다드/코팅 명함이 사각 재단인 데 비해, 모양명함은 도안 모양대로 잘라내는 명함이다.
파일 업로드형(`file_upload_yn=Y`·`editor_yn=N`). 사이즈 1종(90×50)·몽블랑 240g 단일 용지·
칼라 단/양면을 손님이 고른다. 최소 100매·100매 증분·최대 10,000매(QTY_UNIT.02 "매").

**가격 아키타입 = 고정가(용지포함)** — 엽서 원자합산형(PRF_DGP_A)이 아니라 명함 전용 고정가
공식 [[formula-PRF_NAMECARD_SHAPE]]로 계산한다. 값 차원(use_dims)은 `[siz_cd, min_qty,
print_opt_cd]` — 즉 **사이즈·수량·단/양면**으로 가격이 갈린다. 코팅명함(032)·스탠다드명함(033)의
고정가 구성요소가 `mat_cd`를 키로 삼는(용지 다종) 데 비해, 모양명함은 용지가 단일(몽블랑240g)
이라 **`siz_cd` 정확매칭**을 키로 쓴다(라이브 구성요소 note "siz_cd 정확매칭"). 가격 값 계산은
`evaluate_price` 단일 권위([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 연결까지만(D-18).
골든 스냅샷 = live 20260702_1119 기준(값 미기록).

**형제 명함과의 관계:** 스탠다드명함(033·PRF_NAMECARD_FIXED)=사각 baseline, 코팅명함(032·
PRF_NAMECARD_COAT)=코팅 변형, 모양명함(035·PRF_NAMECARD_SHAPE)=모양 재단 변형. 세 상품이
같은 명함 사이즈 축(SIZ_000008)과 명함 카테고리(CAT_000313)를 공유한다.

## 모양명함 사이즈 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_035.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |

> SIZ_000008(90×50)=명함 재단 사이즈(단일·dflt Y). SIZ_000499(316×467)=국전 출력용지 판형
> (`t_prd_product_plate_sizes`·OUTPUT_PAPER_TYPE.01·fn_best_plate 자동선택). 판걸이수(UP수)는
> 사이즈 컬럼이 아니라 파생값(`fn_calc_pansu`·엔진·T-7). SIZ_000008 note "판걸이=24.0"은 참고
> 메모이며 권위 판걸이수는 엔진 계산.

## 가격 사슬 (전사·값 미기록·차원만)

<!-- transcribed-by: _meta/scripts/transcribe_product_035.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components/t_prc_price_components @ 2026-07-03 -->
| comp_cd | 구성요소명 | prc_typ | use_dims(차원) | 단가행수 |
|---|---|---|---|---|
| COMP_NAMECARD_SHAPE_S1 | 모양명함 완제품가 단면(용지포함) | PRICE_TYPE.02 | ["siz_cd", "min_qty", "print_opt_cd"] | 1 |
| COMP_NAMECARD_SHAPE_S2 | 모양명함 완제품가 양면(용지포함) | PRICE_TYPE.02 | ["siz_cd", "min_qty", "print_opt_cd"] | 1 |

> 가격 경로 = `priced_by`→[[formula-PRF_NAMECARD_SHAPE]]→`has_component`→S1(단면)/S2(양면)
> →차원 `[siz_cd, min_qty, print_opt_cd]`. 단가행 1행/면은 **단일 사이즈(SIZ_000008)×단일
> min_qty 티어(100)** 격자가 꽉 찬 것이다(형제 STD_S1=5행은 용지 5종 mat_cd 키·COAT_S1=2행은
> 용지 2종 — 모양명함은 siz_cd 키·용지 단일이라 1행이 완전 격자). 단가행은 노드로 펼치지
> 않고 구성요소 속성/집계로 접는다(D-22). 100매 초과 수량의 가격 스케일은 `evaluate_price`
> 권위(KB 밖·D-18) — 아래 §끊긴 경로에서 관찰만.

## 정체·분류 근거 (SOT)

- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 모양명함은 `t_prd_product_sets`
  부모 미등록(단일)·`prd_typ_cd=PRD_TYPE.01`(SOT: `_workspace/_foundation/product-type-classification-sot.md`).
- 카테고리: 주=인쇄홍보물([[axis/categories#category-CAT_000003]]·main_cat_yn=Y)·
  부=명함([[axis/categories#category-CAT_000313]]·upr CAT_000003).
- 도수=인쇄옵션(`print_opt_cd`·NOT clr_cd — [[rule/rules#RULE_dosu_is_printopt]]). 단면=POPT_000001
  (front 4도 CLR_000005·back 인쇄안함 CLR_000001)·양면=POPT_000002(양면 4도).

## 끊긴 경로·미해결 (정직 선언)

- **모양(die-cut) 공정 미바인딩 GAP**: [[gap-035-diecut-process]] — "모양명함"의 정체인 모양
  재단(도무송/완칼) 공정이 `t_prd_product_processes`에 0행. 형제 모양엽서(023)는 완칼
  PROC_000123을 바인딩하나 035는 없음(⚪).
- **CPQ 옵션그룹 부재 GAP**: [[gap-035-cpq-option-layer]] — `t_prd_product_option_groups` 0행.
  032/033은 인쇄(단/양면) option_group을 두는데 035는 없어 손님 선택축(단/양면)이 CPQ
  옵션으로 정형화되지 않고 `t_prd_product_print_options`로만 존재(⚪).
- **수량구간 노드 부재**: `t_prd_product_bundle_qtys` PRD_000035 0행 → 별도 `bundle_qty`
  노드(E8) 미생성. 수량은 상품 스칼라(min100/max10000/incr100)로만 표현(정상·GAP 아님·팩 §3.4).
- **제약규칙 없음**: `t_prd_product_constraints` 0행. 옵션 자체가 없어 교차제약 불요(정상).
- **추가상품 없음**: `t_prd_product_addons` 0행 → `has_addon` 없음(모양명함은 addon 미보유).

<!-- 이하: PRD_000035 전용 하위 노드(GAP만). 공유 축(사이즈·자재·도수·판형·카테고리·공식)은 위 relations로 재사용·중복 정의 금지. 수량은 상품 props 스칼라로 표현(033 방식·별도 bundle_qty 노드 미생성). -->

### [gap-035-diecut-process] 모양(die-cut/도무송) 공정 미바인딩 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_processes에 PRD_000035 행 0(모양 재단 공정 원천 부재)
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 필터:prd_cd=PRD_000035 → 0행", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.6 공정(완칼 PROC_000123·모양 재단)·§4-B 완칼 교정", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "모양명함(PRD_000035)의 정체인 모양 재단(도무송/완칼 die-cut) 공정이 t_prd_product_processes에 전혀 바인딩되지 않음(0행). 형제 모양엽서(023)는 완칼 PROC_000123 mand 공정을 두어 생산 라우팅을 표현하나 035는 없어, '모양'을 어떤 공정으로 제작·과금하는지가 데이터에 없음. 고정가(용지포함) 완제품가에 모양 재단비가 포함됐는지(별도 공정비 불요)인지, 누락된 것인지 원천으로 판정 불가"
- gap_fill_from: "실무진 확인(모양 재단 공정·과금 포함 여부) + §26 가격테이블 무결성/§31 제약규칙 하네스(모양×사이즈 물리제약 필요 여부)"
- gap_owner: staff
- rel: {rel: references, target: product-035-shaped-namecard, note: "이 상품의 모양 재단 공정 공백"}

### [gap-035-cpq-option-layer] CPQ 옵션그룹 부재(단/양면 선택 미정형화) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_option_groups에 PRD_000035 행 0(CPQ 옵션 레이어 미적재)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 필터:prd_cd=PRD_000035 → 0행(options/option_items도 0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "모양명함은 손님이 단/양면을 골라야 하고 가격도 print_opt_cd 차원으로 갈리는데, 그 선택을 표현할 CPQ 옵션그룹(t_prd_product_option_groups)이 0행이다. 형제 032/033은 인쇄(단/양면) option_group(sel_typ 택1 필수)을 둔다. 035는 t_prd_product_print_options로 단/양면 2행은 있으나 CPQ 옵션 레이어로 정형화되지 않아, 폼빌더/위젯이 옵션으로 surfacing할 shape가 없음"
- gap_fill_from: "실무진 확인 + §7 dbmap CPQ 옵션 적재(optgroup print 택1) 또는 §31 제약규칙 하네스(폼빌더 정형 shape)"
- gap_owner: staff
- rel: {rel: references, target: printopt-POPT_000001, note: "단/양면 선택축이 CPQ 옵션그룹으로 미정형화"}

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): `t_prd_products`(PRD_000035 정체·수량 스칼라·PRD_TYPE.01)·`t_prd_product_sizes`(SIZ_000008 1행 dflt Y)·`t_prd_product_materials`(MAT_000109 1행 USAGE.07 dflt Y)·`t_prd_product_print_options`(POPT_000001/002 2행)·`t_prd_product_processes`(0행)·`t_prd_product_plate_sizes`(SIZ_000499 OUTPUT_PAPER_TYPE.01)·`t_prd_product_price_formulas`(PRF_NAMECARD_SHAPE)·`t_prd_product_categories`(CAT_000003 Y·CAT_000313 N)·`t_prd_product_bundle_qtys`(0행)·`t_prd_product_addons`(0행)·`t_prd_product_constraints`(0행)·`t_prd_product_option_groups/options/option_items`(전부 0행)·`t_prc_price_formulas`(PRF_NAMECARD_SHAPE "모양명함 면/수량별 단가(용지포함)")·`t_prc_formula_components`(COMP_NAMECARD_SHAPE_S1/S2)·`t_prc_price_components`(S1/S2 PRICE_TYPE.02 use_dims [siz_cd,min_qty,print_opt_cd]) — 전사=`_meta/scripts/transcribe_product_035.py`(cache/transcribed-035-260703.json).
- `01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·§3.5(자재 USAGE.07)·§3.6(공정·완칼)·§3.10(가격공식)·§3.11(가격구성요소).
- 공유 축·공식 노드(재사용): `axis/sizes.md`(SIZ_000008·SIZ_000499)·`axis/materials.md`(MAT_000109 몽블랑240g)·`axis/print-options.md`(POPT_000001/002)·`axis/plate-sizes.md`(OUTPUT_PAPER_TYPE_01)·`axis/categories.md`(CAT_000003/313)·`rule/rules.md`(도수·상품유형·가격경계).
- ★needed_shared_nodes(통합 단계 mint 대기·직접 mint 금지): `formula/digital-formulas.md`에 `formula-PRF_NAMECARD_SHAPE`, `formula/digital-components.md`에 `component-COMP_NAMECARD_SHAPE_S1`·`component-COMP_NAMECARD_SHAPE_S2`.
