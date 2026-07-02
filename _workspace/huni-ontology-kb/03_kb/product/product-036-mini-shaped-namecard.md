---
id: product-036-mini-shaped-namecard
type: product
anchor: t_prd_products/PRD_000036
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000036 (use_yn=Y 출시·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함=인쇄홍보물)·§3.3 도수=printopt·§3.11 명함 배선교정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "테이블:t_prd_product_price_formulas 키:(PRD_000036,PRF_NAMECARD_MINISHAPE) note:'namecard-special 미니모양 S1+S2 print_opt 태깅 배선·siz_cd 정확매칭·용지포함 완제품가'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y·disp 6)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N)"}
  # 차원 — 사이즈 (R2 has_size — 단일 사이즈·046과 공용·size-SIZ_000011 재사용)
  - {rel: has_size, target: size-SIZ_000011, note: "50x50 (단일 사이즈·dflt·046 라벨택과 공용 정의 재사용)"}
  # 자재 (R3 uses_material — 공유 축 재사용·단일 슬롯 USAGE.07 default)
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g(USAGE.07·dflt·단일 자재)"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CLR_000005 4도·back CLR_000001 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CLR_000005 4도)"}
  # 판형 (R6 has_plate_size — 종이류만·공유 축 국전계열·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01·종이류라 판형 유효"}
  # 가격 (R8 priced_by — 미니모양명함 전용 고정가·용지포함·신규 공유 공식)
  - {rel: priced_by, target: formula-PRF_NAMECARD_MINISHAPE, note: "고정가(용지포함)·면/수량별 단가표·S1단면+S2양면 태깅 배선"}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록)
  semi_role_cd: null
  file_upload_yn: Y
  editor_yn: N
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  use_yn: Y
  del_yn: N
  구분: "명함(디지털인쇄 완제품 단일·모양 재단 미니 명함)"
  archetype_price: "고정가(용지포함)"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). 별도 t_prd_product_bundle_qtys 행 없음·사이즈 수량규칙 공란(단일 사이즈)"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(미니모양명함 구성·가격 경로)", "조건 탐색(모양 재단 명함)"]
tags: ["#디지털인쇄", "#명함", "#모양", "#고정가"]
updated: 2026-07-03
---

# 상품: 미니모양명함 (PRD_000036) — 디지털인쇄 완제품 (명함)

미니모양명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·SOT: 완제품=셋트 아닌 단일
제조상품). 50×50 단일 사이즈의 작은 명함을 몽블랑 240g 낱장에 칼라 단/양면 인쇄해 **모양대로 재단**
하는 상품이다. 카테고리는 인쇄홍보물(`CAT_000003`·주)·명함(`CAT_000313`·부). 파일 업로드형
(`file_upload_yn=Y`·에디터 미사용). 출시 상태(`use_yn=Y`). 최소 100매·100매 증분·최대 10,000매
(단위 QTY_UNIT.02 "매"). 수치(사이즈·수량) raw 값은 아래 §전사표가 권위(스크립트 전사·손전사 금지).

**가격 아키타입 = 고정가(용지포함)** — 원자합산형(엽서 PRF_DGP_A)이 아니라 명함류 전용 고정가
공식 [[formula/digital-formulas#formula-PRF_NAMECARD_MINISHAPE]]로 계산한다. 값 차원(use_dims)은
`[siz_cd, min_qty, print_opt_cd]` — 즉 **사이즈·수량·단/양면**으로 완제품가(용지·모양 재단 포함)를
lookup한다. 형제 명함(코팅명함 032=`PRF_NAMECARD_COAT`·스탠다드명함 033=`PRF_NAMECARD_FIXED`)과
같은 "명함 고정가(용지포함)" 계열이되, 미니모양 전용 공식(`PRF_NAMECARD_MINISHAPE`·S1단면/S2양면
태깅 배선)을 쓴다. 가격 값 계산은 evaluate_price 단일 권위([[rule/rules#RULE_price_value_boundary]]) —
온톨로지는 연결까지만(D-18). 골든 스냅샷 = live 20260702_1119·가격표260527 B08 기준(값 미기록·날짜 라벨).

## 정체·유형 (SOT 준수)
- 상품유형 분류 SOT: **완제품(.01)** = 일반 단일 제조상품. 미니모양명함은 `t_prd_product_sets` 부모
  등록이 없어(셋트 아님) 일반 단일 완제품(SOT 정합). 기성/디자인 아님(제조 상품).
- 구분 그룹 = "명함"(디지털인쇄 7구분 중 하나·팩 §3.1). 형제 032 코팅명함·033 스탠다드명함과 같은
  명함 카테고리(`CAT_000313`)·인쇄홍보물(`CAT_000003`). 차이 = 미니모양명함은 **단일 50×50 모양 재단**
  (사이즈·자재 각 1종)이라 CPQ 옵션 없이 단/양면만 선택.

## 차원
- **사이즈:** 1행(50x50·작업 60x60·재단 50x50) — 이산 단일 사이즈. 046 라벨택과 **공용**
  ([[product-046-label-tag-nodes#size-SIZ_000011]]에 이미 정의·중복 노드 생성 금지 원칙에 따라 재사용).
  50×50의 판걸이수(UP수)는 **사이즈의 파생값**(`fn_calc_pansu` t_siz_pansu lookup→기하 폴백·라이브
  note "판걸이=35.0"은 참고 메모·권위는 엔진 계산·[[rule/rules#RULE_pansu_db_function]]).
- **도수:** 인쇄옵션 코드값(칼라 단면 POPT_000001 / 양면 POPT_000002). 도수는 색상코드가
  아니다([[rule/rules#RULE_dosu_is_printopt]]). 라이브 색상수 코드 = 앞면 CLR_000005(CMYK 4도),
  단면의 뒷면 = CLR_000001(인쇄 안 함)·양면 뒷면 = CLR_000005.
- **수량규칙:** 제품 레벨 min 100 / max 10,000 / incr 100(QTY_UNIT.02). `t_prd_product_bundle_qtys`
  에 036 행 **없음**(제품 레벨 규칙만). 수량 UI 권위 = 제품/사이즈 수량규칙(가격구간과 역할 분리·
  팩 §3.4). 별도 bundle_qty 노드 미생성(정상·GAP 아님).

## 자재·공정
- **자재:** 1종(몽블랑 240g `MAT_000109`·USAGE.07 default 단일 슬롯·팩 §3.5). 공유 축 재사용
  ([[axis/materials#material-MAT_000109]]·027 접지카드·046 라벨택과 공용). ★IMPORT 시트 등록 자재
  삭제 금지([[rule/rules#RULE_import_material_no_delete]]).
- **공정:** 라이브 `t_prd_product_processes` = **0행**. "모양(완칼) 재단"이 물리적으로 필요한데도
  생산 공정행이 없다 — 모양 재단 비용이 **고정가 완제품가(PRF_NAMECARD_MINISHAPE·용지포함)에 흡수**돼
  가격축에는 별도 공정/구성요소가 없다. 이는 원자합산형(023 모양엽서가 완칼을 공정행 PROC_000123 +
  구성요소 COMP_CUT_FULL_DIECUT로 **이중 표현**한 것)과 대비되는 가격 모델 차이다. 다만 **생산 라우팅
  관점의 완칼 공정 표현 부재**는 정직하게 관찰로 남긴다 → [[#gap-036-diecut-process-absent]].
  base 인쇄공정(PROC_000004) 미바인딩이면 인쇄비 영구 0이 되는 결함 계열(팩 §4-A·016 미러)이나,
  036은 고정가 완제품가라 인쇄비가 공정 아닌 완제품가 단가표에 포함(별도 base 공정 배선 불요).

## 가격 경로 (D-18 경계 — 값은 evaluate_price 권위) — ★가격 경로 연결됨
- `product-036 --priced_by--> formula-PRF_NAMECARD_MINISHAPE --has_component-->
  {COMP_NAMECARD_MINISHAPE_S1(단면 완제품가·disp1·addtn Y), COMP_NAMECARD_MINISHAPE_S2(양면 완제품가·disp2·addtn Y)}`.
  라이브 `t_prc_formula_components`에 2행 배선 실재(frm_cd=PRF_NAMECARD_MINISHAPE) → **고아 공식 아님**
  (has_component 2개)·**끊긴 가격 사슬 아님**(priced_by 1개).
- 두 구성요소(comp_typ PRC_COMPONENT_TYPE.06 완제품가·prc_typ PRICE_TYPE.02)의 use_dims =
  `[siz_cd, min_qty, print_opt_cd]` — 사이즈(SIZ_000011)·수량구간(100 이상)·단/양면(POPT_000001/002)으로
  1건당 단가(용지·모양 재단 포함)를 lookup. print_opt 태깅으로 S1(단면)/S2(양면)을 가른다.
- **골든:** 라이브 단가행 = (SIZ_000011·수량 100 이상 단일구간·단면 POPT_000001 / 양면 POPT_000002) 각 1행
  (가격표260527 B08 앵커·수량 100~10,000 전 구간 동일 고정단가). 값은 evaluate_price/단가표 권위라 본문에
  raw 금액을 기록하지 않고 날짜 라벨(live 20260702_1119)로만 참조한다([[rule/rules#RULE_price_value_boundary]]).
  단가행 접기(D-22) — component 노드 속성/집계로 접음(라이브 단가표가 권위·스크립트 전사 대상).
- ★신규 공유 노드 대기: `formula-PRF_NAMECARD_MINISHAPE`·`component-COMP_NAMECARD_MINISHAPE_S1`·
  `component-COMP_NAMECARD_MINISHAPE_S2`는 공유 `formula/*`에 아직 미등재 — 통합 단계 mint 대상
  (needed_shared_nodes 반환). 그 전까지 priced_by/has_component 링크는 mint 후 resolve.

## 옵션·제약·추가상품·셋트 (라이브 실측 — 전부 미등록)
- **옵션그룹:** `t_prd_product_option_groups`/`t_prd_product_options`/`t_prd_product_option_items` = 036 행
  **없음**(CPQ 옵션 레이어 미구성). 손님 선택 축은 도수(단/양면)뿐이며 사이즈·자재는 각 1종이라
  선택 여지가 없다 → 도수는 상품 차원(has_print_option)으로만 표현(옵션 레이어 불요·정상). 형제
  032/033은 CPQ 4그룹 보유하나 036은 사이즈·자재 단일이라 옵션 그룹 없음(구조 차이·결함 아님).
- **제약:** `t_prd_product_constraints` = 036 행 **없음**. 교차 옵션이 없어 제약 불요(정상).
- **추가상품:** `t_prd_product_addons` = 036 행 **없음** → `has_addon` 없음(명함은 addon 미보유·033 동일).
- **셋트:** `t_prd_product_sets` = 036 행 **없음**(부품조립 셋트 아님·완제품 단일 SOT 정합).

## 승계·freshness 메모
- 정체·명함 구분·도수=printopt = 팩 §3.1/§3.3 FRESH 승계. 명함 고정가(용지포함) 계열 = 032/033 형제 정합.
- base 공정 미바인딩→인쇄비 0 결함(팩 §4-A)은 원자합산형 상품 계열 사실 — 036은 고정가라 무관(인쇄비가
  완제품가 단가표 포함). 위키 🔴 결함표(T-6)를 그대로 옮기지 않고 §4 원장·live-snapshot로 재조준.
- use_yn=Y 출시는 라이브 현재 상태(권위=live-snapshot). 현재값=정답(양면 노드 아님).

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_036.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000011 | 50x50 | 60x60 | 50x50 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |

> 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생값(`fn_calc_pansu`·엔진)이다(F-9·T-7). SIZ_000011
> note "판걸이=35.0"은 참고 메모이며 권위 판걸이수는 엔진 계산. SIZ_000499 = 출력용지(판형·국4절).

<!-- transcribed-by: _meta/scripts/transcribe_product_036.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000036 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | qty_unit_typ_cd |
|---|---|---|---|
| 100 | 10000 | 100 | QTY_UNIT.02 |

---

## 이 상품 전용 하위 노드 (GAP — 정직 선언)

> 공유 축(사이즈 SIZ_000011=046-nodes·자재 MAT_000109·도수·판형·카테고리)은 위 relations로 재사용
> (중복 노드 생성 금지). 신규 공유 노드(공식·구성요소)는 needed_shared_nodes로 반환(직접 mint 금지).
> 아래는 이 상품 고유 관찰 GAP.

### [gap-036-diecut-process-absent] 모양(완칼) 재단 공정 표현 부재 {unknown}
- type: gap
- anchor: none  # 사유: "모양명함"이 물리적으로 완칼 재단을 요하나 t_prd_product_processes 0행·완칼 구성요소도 없음(고정가 완제품가에 흡수). 의도적 흡수인지 생산 라우팅 누락인지 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:PRD_000036 (0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_NAMECARD_MINISHAPE_S1/S2 note:'명함 완제품가(용지 포함)·소재·인쇄면·수량 합산 1건당 단가표'(완칼 항목 명시 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "미니모양명함의 모양(완칼) 재단이 가격상 고정가 완제품가에 흡수돼 별도 공정행/가격구성요소로 표현되지 않음(t_prd_product_processes 0행). 023 모양엽서는 완칼을 공정행(PROC_000123)+구성요소(COMP_CUT_FULL_DIECUT)로 이중 표현 — 036은 둘 다 없음. 가격은 무영향(완제품가 포함)이나 생산 라우팅/견적 근거 표현에는 공백"
- gap_fill_from: "실무진 확인 — 모양 재단이 고정가에 의도적으로 흡수된 것인지, 생산 공정행(완칼 라우팅)이 누락된 것인지. 후자면 §26/§7 공정 배선 검토"
- gap_owner: staff
- rel: {rel: references, target: formula-PRF_NAMECARD_MINISHAPE, note: "이 공식이 모양 재단을 완제품가에 흡수(별도 완칼 구성요소 없음)"}
- 본문: 지어내지 않고 정직 선언. 형제 023(완칼 이중 표현)·046(완칼 구성요소만)과 달리 036은 완칼 표현이 전혀 없다. 가격 경로는 고정가로 완결(연결됨)이므로 이 GAP은 견적 차단이 아니라 생산 라우팅 표현 공백의 관찰이다.

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N·use_yn=Y): `t_prd_products`(PRD_000036 정체·수량 스칼라)·`t_prd_product_categories`(CAT_000003 주/CAT_000313 부)·`t_prd_product_sizes`(SIZ_000011 1행)·`t_prd_product_materials`(MAT_000109 1행 USAGE.07)·`t_prd_product_print_options`(POPT_000001/002)·`t_prd_product_plate_sizes`(SIZ_000499 OUTPUT_PAPER_TYPE.01)·`t_prd_product_processes`(0행)·`t_prd_product_bundle_qtys`(0행)·`t_prd_product_price_formulas`(PRF_NAMECARD_MINISHAPE)·`t_prc_formula_components`(2행 S1/S2)·`t_prc_price_components`(COMP_NAMECARD_MINISHAPE_S1/S2·use_dims [siz_cd,min_qty,print_opt_cd])·`t_prd_product_option_groups/options/option_items`(0행)·`t_prd_product_addons`(0행)·`t_prd_product_constraints`(0행)·`t_prd_product_sets`(0행).
- `_workspace/huni-ontology-kb/01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·§3.5(자재 USAGE.07)·§3.11(명함 고정가 계열).
- 공유 축·공식 노드: `axis/materials.md`(MAT_000109)·`axis/print-options.md`(POPT_000001/002)·`axis/plate-sizes.md`(OUTPUT_PAPER_TYPE.01)·`axis/categories.md`(CAT_000003/313)·`product-046-label-tag-nodes.md`(size-SIZ_000011 공용)·`formula/digital-formulas.md`+`formula/digital-components.md`(★PRF_NAMECARD_MINISHAPE·COMP_NAMECARD_MINISHAPE_S1/S2 = 통합 mint 대기).
- 수치 전사: `_meta/scripts/transcribe_product_036.py`(사이즈·수량 스칼라).
