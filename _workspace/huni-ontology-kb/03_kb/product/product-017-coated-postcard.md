---
id: product-017-coated-postcard
type: product
anchor: t_prd_products/PRD_000017
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000017 (prd_nm=코팅엽서·del_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체·§3.2~3.11 축별 정답소스(디지털인쇄)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md", source_locator: "문서:§4-A base 공정 18건 COMMIT 목록(017 포함)", captured_at: "2026-07-03", badge: verified, src_id: SR-26-baseproc}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000001}
  - {rel: has_size, target: size-SIZ_000002}
  - {rel: has_size, target: size-SIZ_000003}
  - {rel: has_size, target: size-SIZ_000004}
  - {rel: has_size, target: size-SIZ_000005}
  - {rel: has_size, target: size-SIZ_000006}
  - {rel: has_size, target: size-SIZ_000007}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(opt_id=1)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(opt_id=2)"}
  - {rel: uses_material, target: material-MAT_000081, note: "아트지 250g·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g·USAGE.07"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천·17=7월 18건 COMMIT 소속)"}
  - {rel: has_process, target: process-PROC_000014, note: "유광라미네이팅(코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000015, note: "무광라미네이팅(코팅 옵션)"}
  - {rel: has_process, target: process-PROC_000027, note: "직각 모서리(옵션·귀돌이 PROC_000026 자식)"}
  - {rel: has_process, target: process-PROC_000028, note: "둥근 모서리(옵션·귀돌이 R)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택·SIZ_000499 dflt)"}
  - {rel: has_qty_rule, target: qty-017}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-017-print}
  - {rel: has_option_group, target: optgroup-017-paper}
  - {rel: has_option_group, target: optgroup-017-coat}
  - {rel: has_option_group, target: optgroup-017-corner}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 15
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서(디지털인쇄 완제품 단일)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(코팅엽서 구성·가격 축)", "코팅(유광/무광) 되는 엽서(조건 탐색)"]
tags: ["#디지털인쇄", "#엽서", "#원자합산형", "#코팅"]
updated: 2026-07-03
---

# 코팅엽서 (product-017-coated-postcard)

코팅엽서(PRD_000017)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품).
형제 [[product/product-016-premium-postcard]](프리미엄엽서)와 동일한 사이즈 **7행**(73×98~148×210·이산 사이즈)·
칼라 단/양면을 쓰되, 그 위에 **코팅(유광/무광 라미네이팅)**을 선택 축으로 얹은 것이 정체상 차이다.
자재는 아트지 250g·300g 2종, 모서리(직각/둥근) 후가공, 가격은 형제와 같은 **원자합산형 공식**
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A)로 계산한다(값 계산=evaluate_price 권위·
[[rule/rules#RULE_price_value_boundary]]).

- **정체**: 팩 §3.1(FRESH·의미 시점무관) + live-snapshot(prd_cd 실재). 016과 동형(엽서)이나 자재·옵션은 코팅엽서 실측.
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **7월 교정 계보(017 직접 소속)**: base 공정 미바인딩→인쇄비 0 대발견의 **18건 COMMIT 목록에 017 포함**
  ([[rule/decisions#DEC_baseproc_260701]]·팩 §4-A). 즉 PROC_000004 mand 바인딩은 016 미러로 017에도 부여돼 인쇄비 정상화됨.
- **★코팅 가격 경로 연결(016 대비 신규 발현)**: 016에서는 코팅 구성요소(COMP_COAT_GLOSSY/MATTE)가 PRF_DGP_A에
  배선돼 있어도 016 자체는 코팅 공정을 안 물어 휴면 상태였다. 017은 코팅(유광 PROC_000014·무광 PROC_000015)을
  **실제 선택 옵션**으로 물고 같은 PRF_DGP_A에 그 두 구성요소가 배선돼 있어, 코팅 선택→가격 반영 경로가 실제로 살아난다
  (엔진의 공정→구성요소 매칭은 evaluate_price 소관·D-18).
- **끊긴 경로(정직 선언)**: **신규 상품별 GAP 0**. 전 축(사이즈 7·자재 2·공정 5·도수 2·판형 1)이 공유 축에 이미 민팅돼
  전수 배선됨(016의 자재 17종 커버리지 공백·봉투 addon 공백 같은 결함이 017엔 없음 — 자재 2종·추가상품 0). 단
  73×98(SIZ_000001)의 판걸이수(UP수)는 두 tier A 원천 충돌이라 **횡단 GAP** [[rule/gaps#GAP_pansu_73x98]]를 참조한다
  (017 전용 신규 gap 아님·016과 공유).

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_017.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000017 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000001 | 73x98 | Y |  |  |  |
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000005 | 95x210 | Y |  |  |  |
| SIZ_000006 | 110x170 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

7 사이즈 전부 `has_size`로 연결(위 relations). 치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위(형제 016과 동일 7행).
73×98(SIZ_000001)의 판걸이수는 두 tier A 원천 충돌(GAP)이라 값 미확정 → [[rule/gaps#GAP_pansu_73x98]].

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000017 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 15 | 10000 | 15 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). `t_prd_product_bundle_qtys`
0행은 "미적재"가 아니라 이 상품의 수량 그릇이 상품 마스터 컬럼(min 15·max 10000·incr 15)이라는 뜻(팩 §3.4 STALE 함정 회피).
017은 사이즈별 수량규칙(min/max/incr) 오버라이드도 라이브에 없음(전 사이즈 공란=상품 레벨 규칙 적용).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000017 @ 2026-07-03 -->
활성 자재 2행 · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | usage_cd | 축노드 |
|---|---|---|---|
| MAT_000081 | 아트지 250g | USAGE.07 | O |
| MAT_000082 | 아트지 300g | USAGE.07 | O |

자재 2종 전부 공유 [[axis/materials]] 축에 민팅돼 있어 `uses_material` 전수 배선(016처럼 대표 subset이 아님 —
017은 애초에 2종뿐이라 커버리지 공백 없음). 코팅엽서 자재는 아트지(코팅 라미 접착이 잘 먹는 코트지 계열) 2 평량.
★IMPORT 시트 등록 자재는 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 인쇄옵션(도수)

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options PRD_000017 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front_clr | back_clr | dflt |
|---|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005 | CLR_000001 | Y |
| 2 | 양면 | POPT_000002 | CLR_000005 | CLR_000005 | Y |

도수 = 인쇄옵션 코드(print_opt_cd)이지 색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]). 단면=POPT_000001·
양면=POPT_000002를 `has_print_option`으로 배선([[axis/print-options]] 축 노드). front/back_clr 코드는 전사 관찰 기록.

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000017 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 |
|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | O |
| PROC_000014 | 유광라미네이팅 | N | O |
| PROC_000015 | 무광라미네이팅 | N | O |
| PROC_000027 | 직각 | N | O |
| PROC_000028 | 둥근 | N | O |

공정 5행 전부 `has_process`로 배선(라이브 활성 5공정 전수 정합). 5종 모두 공유 [[axis/processes]] 축에 이미 민팅됨
(PROC_000004 base·PROC_000014/015 라미네이팅·PROC_000027/028 모서리 — 260703 승격분). PROC_000004는 mand(인쇄비 원천),
나머지 4는 옵션. 유광/무광 라미네이팅이 이 상품을 "코팅"엽서로 만드는 축이다(016엔 없던 공정).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000017 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선. 판형=종이류만·고객 미선택·
fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]). 017 판형 1행(dflt_plt=Y·
국전 SIZ_000499)으로 016보다 깔끔(016은 SIZ_000522 관찰행이 추가로 있었음).

#### 추가상품(템플릿)

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons PRD_000017 @ 2026-07-03 -->
추가상품 행수 0 (없으면 has_addon 없음)

코팅엽서는 봉투 addon이 라이브에 **없다**(0행). 따라서 `has_addon` 엣지 없음 — 이것은 결함/GAP이 아니라 실측 부재다
(016의 봉투 addon 5행·gap-016-addon-target과 대비). 코팅엽서 봉투 구성이 향후 필요하면 그때 addon 행 적재(범위 밖 관찰).

#### 옵션그룹 (item→ref 다형참조)

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+t_prd_product_options+t_prd_product_option_items PRD_000017 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | use | del | option(opt_cd) | ref_dim | ref_key1 |
|---|---|---|---|---|---|---|---|
| OPT_000009 | 인쇄 | SEL_TYPE.01 | Y | N | OPV_000046 (단면) | OPT_REF_DIM.06 | 1 |
| OPT_000009 | 인쇄 | SEL_TYPE.01 | Y | N | OPV_000047 (양면) | OPT_REF_DIM.06 | 2 |
| OPT_000010 | 종이 | SEL_TYPE.01 | Y | N | OPV_000048 (아트지 250g) | OPT_REF_DIM.03 | MAT_000081 |
| OPT_000010 | 종이 | SEL_TYPE.01 | Y | N | OPV_000049 (아트지 300g) | OPT_REF_DIM.03 | MAT_000082 |
| OPT_000011 | 코팅 | SEL_TYPE.01 | Y | N | OPV_000050 (코팅없음) | — | — (센티넬/미참조) |
| OPT_000011 | 코팅 | SEL_TYPE.01 | Y | N | OPV_000051 (유광라미네이팅) | OPT_REF_DIM.04 | PROC_000014 |
| OPT_000011 | 코팅 | SEL_TYPE.01 | Y | N | OPV_000052 (무광라미네이팅) | OPT_REF_DIM.04 | PROC_000015 |
| OPT_000012 | 모서리 | SEL_TYPE.01 | Y | N | OPV_000053 (직각) | OPT_REF_DIM.04 | PROC_000027 |
| OPT_000012 | 모서리 | SEL_TYPE.01 | Y | N | OPV_000054 (둥근) | OPT_REF_DIM.04 | PROC_000028 |

활성 옵션그룹 4개(SEL_TYPE.01=손님 택1). 다형참조(ref_dim_cd)로 옵션값이 실물 차원을 가리킨다:
인쇄=OPT_REF_DIM.06(opt_id 1/2→도수)·종이=OPT_REF_DIM.03(자재)·코팅/모서리=OPT_REF_DIM.04(공정). 각 그룹은 아래
optgroup 노드로 선언하고 `option_refs`로 배선(fn_chk_opt_item_ref 정합=전부 같은 부모 017 차원에 실재). 코팅 그룹의
"코팅없음"(OPV_000050)은 option_item 참조가 없는 **선택안함 센티넬**(0행·정상·미참조).

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000017 @ 2026-07-03 -->
제약 행수 0 (없으면 constraint 노드 없음·GAP 아님)

코팅엽서는 라이브 제약규칙(`t_prd_product_constraints`)이 **없다**(0행). 016의 [DEMO] 제약 2건과 대비 — 017엔
제약 노드를 만들지 않는다(부재이지 결함/GAP 아님). 코팅×도수 등 잠재 제약이 필요하면 §31 제약규칙 거버넌스가 소관.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000017 @ 2026-07-03 -->
| frm_cd | dflt |
|---|---|
| PRF_DGP_A |  |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선). 코팅엽서 가격 경로:
디지털인쇄비(COMP_PRINT_DIGITAL_S1·PROC_000004 매칭) + 용지비(COMP_PAPER·plt_siz×mat) + **코팅비(COMP_COAT_GLOSSY/
COMP_COAT_MATTE·유광/무광 라미 매칭)** + 모서리/오시/미싱/가변. 값 계산은 evaluate_price(D-18 경계). 즉 상품→공식→
구성요소→차원 가격 경로가 코팅축까지 **끊김 없이 연결**됨(고아 공식 0·형제 016과 공유 공식).

#### 카테고리

<!-- transcribed-by: _meta/scripts/transcribe_product_017.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000017 @ 2026-07-03 -->
| cat_cd | 분류명 | main_cat_yn |
|---|---|---|
| CAT_000001 | 엽서/카드 | N |
| CAT_000307 | 엽서 | Y |

`in_category` 2행. 017은 CAT_000307 엽서가 **main_cat_yn=Y**(대표 분류) — 016(둘 다 N)과 다른 관찰 기록.
두 분류 노드 모두 공유 [[axis/categories]]에 민팅됨.

---

## 이 상품 전용 하위 노드 (option_group·qty)

### [qty-017] 코팅엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000017
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000017 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 15/10000/15)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, size_override: "없음(전 사이즈 공란·상품 레벨 적용)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 15·max 10000·incr 15). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈·[[rule/decisions#DEC_qty_audit_260702]]). 017은 사이즈별 오버라이드 없음(016의 98×98 incr=8 같은 예외도 없음).

### [optgroup-017-print] 인쇄(도수·단양면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000017
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000017,OPT_000009) opt_grp_nm=인쇄", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000009", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1", ref_dim: "OPT_REF_DIM.06(opt_id→도수)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, note: "단면(OPV_000046·ref_key1=opt_id 1)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, note: "양면(OPV_000047·ref_key1=opt_id 2)"}
- 본문: 도수·단양면 선택 그룹. 도수=print_opt_cd([[rule/rules#RULE_dosu_is_printopt]]). ref_dim=OPT_REF_DIM.06은 opt_id(1/2)를 가리키므로 t_prd_product_print_options에서 POPT_000001/002로 해소해 배선(부모 017 has_print_option 정합·fn_chk_opt_item_ref).

### [optgroup-017-paper] 종이(자재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000017
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000017,OPT_000010) opt_grp_nm=종이", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000010", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", ref_dim: "OPT_REF_DIM.03(자재)"}
- rel: {rel: option_refs, target: material-MAT_000081, note: "아트지 250g(OPV_000048·ref_key1=MAT_000081)"}
- rel: {rel: option_refs, target: material-MAT_000082, note: "아트지 300g(OPV_000049·ref_key1=MAT_000082)"}
- 본문: 용지 선택 그룹. option_refs 대상 자재 2종 전부 공유 [[axis/materials]] 축 노드로 배선(부모 017 uses_material 정합·전수). 016의 21종 대표 subset 커버리지 공백이 017엔 없음(자재 2종=전수).

### [optgroup-017-coat] 코팅(유광/무광 라미네이팅) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000017
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000017,OPT_000011) opt_grp_nm=코팅", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000011", opt_grp_nm: "코팅", sel_typ_cd: "SEL_TYPE.01", ref_dim: "OPT_REF_DIM.04(공정)", 센티넬: "OPV_000050 코팅없음(선택안함·미참조)"}
- rel: {rel: option_refs, target: process-PROC_000014, note: "유광라미네이팅(OPV_000051·ref_key1=PROC_000014)"}
- rel: {rel: option_refs, target: process-PROC_000015, note: "무광라미네이팅(OPV_000052·ref_key1=PROC_000015)"}
- 본문: 코팅(유광/무광 라미네이팅) 선택 그룹 — 이 상품을 "코팅"엽서로 만드는 축. option_refs 대상 공정(PROC_000014 유광·PROC_000015 무광)은 공유 [[axis/processes]] 축 노드(260703 승격)로 배선(부모 017 has_process 정합·fn_chk_opt_item_ref). 가격은 PRF_DGP_A의 COMP_COAT_GLOSSY/COMP_COAT_MATTE로 반영(엔진 공정→구성요소 매칭·D-18). "코팅없음"(OPV_000050)은 참조 없는 센티넬.

### [optgroup-017-corner] 모서리(직각/둥근) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000017
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:(PRD_000017,OPT_000012) opt_grp_nm=모서리", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000012", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", ref_dim: "OPT_REF_DIM.04(공정)"}
- rel: {rel: option_refs, target: process-PROC_000027, note: "직각(OPV_000053·ref_key1=PROC_000027)"}
- rel: {rel: option_refs, target: process-PROC_000028, note: "둥근(OPV_000054·ref_key1=PROC_000028)"}
- 본문: 모서리 형태(직각/둥근) 선택 그룹. option_refs 대상 공정(027 직각·028 둥근)은 공유 [[axis/processes]] 축 노드로 배선(부모 017 has_process 정합·fn_chk_opt_item_ref). 가격은 귀돌이비 COMP_PP_CORNER_RIGHT(proc_grp PROC_000026·.03 고정 교정·[[rule/decisions#DEC_corner_260702]]).
