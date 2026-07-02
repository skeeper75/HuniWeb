---
id: product-018-standard-postcard
type: product
anchor: t_prd_products/PRD_000018
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000018 (prd_nm=스탠다드엽서·del_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체·§3.2~3.12 축별 정답소스(디지털인쇄)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§0 distinct 36 표(엽서 구분)·§1 정체확정표 (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000001, note: "73x98(판걸이수 15v18 GAP)"}
  - {rel: has_size, target: size-SIZ_000002}
  - {rel: has_size, target: size-SIZ_000003}
  - {rel: has_size, target: size-SIZ_000004}
  - {rel: has_size, target: size-SIZ_000007}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라(opt_id=1)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라(opt_id=2)"}
  - {rel: uses_material, target: material-MAT_000074, note: "백색모조지 220g(dflt·USAGE.07)"}
  - {rel: uses_material, target: material-MAT_000081, note: "아트지 250g"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g"}
  - {rel: uses_material, target: material-MAT_000091, note: "스노우지 250g"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000027, note: "직각 모서리(옵션)"}
  - {rel: has_process, target: process-PROC_000028, note: "둥근 모서리(옵션)"}
  - {rel: has_process, target: process-PROC_000029, note: "오시(옵션)"}
  - {rel: has_process, target: process-PROC_000030, note: "미싱(옵션)"}
  - {rel: has_process, target: process-PROC_000031, note: "가변텍스트(옵션)"}
  - {rel: has_process, target: process-PROC_000032, note: "가변이미지(옵션)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택·dflt_plt_yn=Y)"}
  - {rel: has_qty_rule, target: qty-018}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-018-print}
  - {rel: has_option_group, target: optgroup-018-paper}
  - {rel: has_option_group, target: optgroup-018-corner}
  - {rel: has_option_group, target: optgroup-018-postpress}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 15
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서(디지털인쇄 완제품 단일)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(스탠다드엽서 구성·가격 축)", "양면 되는 엽서(조건 탐색)", "프리미엄엽서 vs 스탠다드엽서(형제 비교)"]
tags: ["#디지털인쇄", "#엽서", "#원자합산형", "#CPQ완전배선"]
updated: 2026-07-03
---

# 스탠다드엽서 (product-018-standard-postcard)

스탠다드엽서(PRD_000018)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 0행)·기성/디자인 아님(제조 상품). 형제
[[product/product-016-premium-postcard]](프리미엄엽서)와 **동일 골격**(같은 공식 PRF_DGP_A·같은 후가공 라우트·같은
판형)이되, 사이즈 **5행**(016은 7행)·자재 **7종**(016은 21종)으로 축소된 "표준" 라인업이다. 칼라 단/양면·
모서리(직각/둥근)·오시·미싱·가변(텍스트/이미지) 후가공. 가격은 **원자합산형 공식**
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A)으로 계산한다(값 계산=evaluate_price 권위·
[[rule/rules#RULE_price_value_boundary]]).

- **정체**: 팩 §3.1(FRESH·의미 시점무관) + live-snapshot(prd_cd 실재·prd_nm=스탠다드엽서). 디지털인쇄 시트 엽서 구분(036 distinct 중).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **CPQ 완전 배선(형제 016 대비 강점)**: 016은 `t_prd_product_options`/`option_items`가 비어 옵션그룹만 있었으나,
  018은 **옵션값 15행 + 옵션아이템 15행(ref_dim_cd 다형참조 전량)** 이 라이브에 채워져 있다 → option_refs를
  ref_key1 한정자로 정확 배선(스키마 R11·fn_chk_opt_item_ref 정합).
- **끊긴 경로(정직 선언)**: 자재 7종 중 2종(MAT_000080 아트지200g·MAT_000090 스노우지200g)이 공유
  [[axis/materials]] 미민팅 → uses_material·optgroup-018-paper option_refs는 민팅된 5종만 배선 →
  [[GAP_018_material]]. 판걸이수 73×98(SIZ_000001)은 두 tier A 원천 충돌(공유 GAP) → [[rule/gaps#GAP_pansu_73x98]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_018.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000018 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000001 | 73x98 | Y |  |  |  |
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

5 사이즈 전부 `has_size`로 연결(위 relations). 형제 016(7행) 중 95×210(SIZ_000005)·110×170(SIZ_000006)은
스탠다드엽서 라인업에서 제외(라이브 5행). 치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위. 73×98(SIZ_000001)의
판걸이수(UP수)는 두 tier A 원천 충돌(GAP)이라 값 미확정 → [[rule/gaps#GAP_pansu_73x98]](016과 동일 사이즈·공유 GAP).

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000018 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 15 | 10000 | 15 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]).
`t_prd_product_bundle_qtys` 0행은 "미적재"가 아니라 이 상품의 수량 그릇이 상품/사이즈 컬럼이라는 뜻(팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000018 @ 2026-07-03 -->
활성 자재 7행 · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | usage_cd | dflt | 공유축노드 |
|---|---|---|---|---|
| MAT_000074 | 백색모조지 220g | USAGE.07 | Y | O |
| MAT_000080 | 아트지 200g | USAGE.07 | N | X(미민팅·needed_shared) |
| MAT_000081 | 아트지 250g | USAGE.07 | N | O |
| MAT_000082 | 아트지 300g | USAGE.07 | N | O |
| MAT_000090 | 스노우지 200g | USAGE.07 | N | X(미민팅·needed_shared) |
| MAT_000091 | 스노우지 250g | USAGE.07 | N | O |
| MAT_000092 | 스노우지 300g | USAGE.07 | N | O |

활성 7행 = 팩 §3.5(USAGE.07 공통·정당). `uses_material`은 공유 축 노드가 있는 5종
(MAT_000074/081/082/091/092)만 relations로 배선; 2종(MAT_000080 아트지200g·MAT_000090 스노우지200g)은
공유 [[axis/materials]] 미민팅이라 위 BOM 표가 권위(그래프 배선 대기). 이 2종 커버리지 공백은 조용한 누락이
아니라 [[GAP_018_material]]로 정직 선언 + needed_shared_nodes로 반환(통합 단계 일괄 mint).
★IMPORT 시트 등록 자재는 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000018 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 |
|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | O |
| PROC_000027 | 직각 | N | O |
| PROC_000028 | 둥근 | N | O |
| PROC_000029 | 오시 | N | O |
| PROC_000030 | 미싱 | N | O |
| PROC_000031 | 가변텍스트 | N | O |
| PROC_000032 | 가변이미지 | N | O |

> 축노드 존재 열은 KB 상태 주석(라이브 열=proc_cd/공정명/mand는 스크립트 전사·불변).

공정 7행 전부 `has_process`로 배선(라이브 활성 7공정 전수 정합·형제 016과 동일 라우트). PROC_000004(디지털인쇄)만
mand_proc_yn=Y(base 인쇄공정·인쇄비 원천). 나머지 6종은 옵션 후가공(직각/둥근=모서리·오시·미싱·가변텍스트/이미지).
base 공정 PROC_000004 미바인딩이 디지털 인쇄비 0의 진원이었고 16상품 미러 COMMIT의 계보이나, 018은 라이브에
이미 PROC_000004 mand 보유(반영 완료·[[rule/decisions#DEC_baseproc_260701]]).

#### 인쇄옵션

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options PRD_000018 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front_clr | back_clr | dflt |
|---|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005 | CLR_000001 | Y |
| 2 | 양면 | POPT_000002 | CLR_000005 | CLR_000005 | Y |

인쇄옵션 2행 = 단면(POPT_000001)·양면(POPT_000002) 칼라. 도수 = `print_opt_cd`(색상코드 아님·
[[rule/rules#RULE_dosu_is_printopt]]). front/back_colrcnt_cd(CLR_*)는 색상수 코드 관찰 기록이지 도수 인코딩 축이
아니다(T-4 함정 회피). `has_print_option`은 [[axis/print-options]] 축 노드(POPT_000001/002)로 배선.

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000018 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선(dflt_plt_yn=Y).
판형=종이류만·고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]).
018은 판형 1행(SIZ_000499 국전)만 — 016보다 단순(016은 SIZ_000522 item 매핑 추가 관찰).

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000018 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min_sel | max_sel | mand | use |
|---|---|---|---|---|---|---|
| OPT_000013 | 인쇄 | SEL_TYPE.01 | 1 | 1 | Y | Y |
| OPT_000014 | 종이 | SEL_TYPE.01 | 1 | 1 | Y | Y |
| OPT_000015 | 모서리 | SEL_TYPE.01 | 0 | 1 | N | Y |
| OPT_000016 | 후가공 | SEL_TYPE.02 | 0 | 4 | N | Y |

활성 4그룹(전부 use_yn=Y·del_yn=N). 016(하이픈/언더스코어 혼용 8그룹)보다 정돈된 코드 체계(OPT_000013~016 연속·
separator 일관). 인쇄·종이는 택1 필수(mand_yn=Y), 모서리는 택1 선택(0~1), 후가공은 택N 다중(0~4·SEL_TYPE.02).
아래 optgroup 노드로 각각 선언 + option_items 다형참조 배선.

#### 옵션값·다형참조(options·option_items)

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options+t_prd_product_option_items PRD_000018 @ 2026-07-03 -->
| opt_grp_cd | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 | dflt |
|---|---|---|---|---|---|---|
| OPT_000013 | OPV_000055 | 단면 | OPT_REF_DIM.06 | 1 |  | Y |
| OPT_000013 | OPV_000056 | 양면 | OPT_REF_DIM.06 | 2 |  | N |
| OPT_000014 | OPV_000057 | 백색모조지 220g | OPT_REF_DIM.03 | MAT_000074 | USAGE.07 | Y |
| OPT_000014 | OPV_000058 | 아트지 200g | OPT_REF_DIM.03 | MAT_000080 | USAGE.07 | N |
| OPT_000014 | OPV_000059 | 아트지 250g | OPT_REF_DIM.03 | MAT_000081 | USAGE.07 | N |
| OPT_000014 | OPV_000060 | 아트지 300g | OPT_REF_DIM.03 | MAT_000082 | USAGE.07 | N |
| OPT_000014 | OPV_000061 | 스노우지 200g | OPT_REF_DIM.03 | MAT_000090 | USAGE.07 | N |
| OPT_000014 | OPV_000062 | 스노우지 250g | OPT_REF_DIM.03 | MAT_000091 | USAGE.07 | N |
| OPT_000014 | OPV_000063 | 스노우지 300g | OPT_REF_DIM.03 | MAT_000092 | USAGE.07 | N |
| OPT_000015 | OPV_000064 | 직각 | OPT_REF_DIM.04 | PROC_000027 |  | Y |
| OPT_000015 | OPV_000065 | 둥근 | OPT_REF_DIM.04 | PROC_000028 |  | N |
| OPT_000016 | OPV_000066 | 오시 | OPT_REF_DIM.04 | PROC_000029 |  | N |
| OPT_000016 | OPV_000067 | 미싱 | OPT_REF_DIM.04 | PROC_000030 |  | N |
| OPT_000016 | OPV_000068 | 가변텍스트 | OPT_REF_DIM.04 | PROC_000031 |  | N |
| OPT_000016 | OPV_000069 | 가변이미지 | OPT_REF_DIM.04 | PROC_000032 |  | N |

옵션값 15행 + 옵션아이템 15행이 라이브에 완전 채워짐. **ref_dim_cd 다형참조 3종**: OPT_REF_DIM.06=인쇄옵션
(ref_key1=opt_id 1/2 → POPT_000001/002·NOT clr_cd)·OPT_REF_DIM.03=자재(ref_key1=mat_cd+ref_key2=usage_cd)·
OPT_REF_DIM.04=공정(ref_key1=proc_cd). 이 정보로 아래 optgroup 노드의 option_refs를 ref_key1 한정자로 정확 배선
(스키마 R11·option_item 노드 미승격=최소안 접기). 자재 옵션 7개 중 5개만 그래프 배선(080/090 미민팅=GAP_018_material).

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000018 @ 2026-07-03 -->
| rule_cd | 규칙명 | rule_typ | use |
|---|---|---|---|
| (행 0 · 제약 미등록) |  |  |  |

제약 **0행**(라이브 미등록). 형제 016은 [DEMO] 제약 2건(오시↔미싱 상호배제·양면 시 가변텍스트 노출)을
보유하나, 018에는 그 데모조차 없다. 오시·미싱 물리 상호배제는 도메인상 성립하나(CN-4) 라이브에 미작성 →
constraint 노드 미생성(환각 금지·§31 폼빌더 계약 등록은 인간 승인 트랙) → [[gap-018-constraint]] 정직 선언.

#### 추가상품

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons PRD_000018 @ 2026-07-03 -->
| disp | tmpl_cd | base_prd_cd |
|---|---|---|
| (행 0 · 추가상품 미등록) |  |  |

추가상품 **0행**(라이브 미등록). 형제 016은 봉투 addon 5행을 보유하나 018은 없다. 엽서=봉투 딸림이 도메인
관행이나 라이브 미적재 → has_addon 엣지 미배선(환각 금지) → [[gap-018-addon-envelope]] 정직 선언.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000018 @ 2026-07-03 -->
| frm_cd | note |
|---|---|
| PRF_DGP_A | 스탠다드엽서 → PRF_DGP_A |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선·형제 016과 공유 공식).
가격 경로 = product-018 --priced_by--> PRF_DGP_A --has_component--> {디지털인쇄비·별색화이트·용지비 COMP_PAPER·
귀돌이/오시/미싱/가변/코팅}. 공식·구성요소는 공유 [[formula/digital-formulas]]·[[formula/digital-components]]가
권위(018 전용 배선 없음·재사용). 값 계산은 evaluate_price(D-18 경계). **가격 경로 연결 완료**(끊긴 사슬 아님).

---

## 이 상품 전용 하위 노드 (option_group·qty·gap)

### [qty-018] 스탠다드엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000018
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000018 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 15/10000/15)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, size_qty_rules: "사이즈별 min/max/incr 0행(상품 레벨만)"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 15·max 10000·incr 15). t_prd_product_bundle_qtys 0행·사이즈별 수량규칙 0행은 정상(수량 UI 권위=상품 레벨·[[rule/decisions#DEC_qty_audit_260702]]). 016의 SIZ_000002 incr=8 같은 사이즈 override는 018에 없음(전 사이즈 상품 기본값 상속).

### [optgroup-018-print] 인쇄(도수·단양면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000018
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000018 opt_grp_cd:OPT_000013 (키:(PRD_000018,OPT_000013))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000055/056 ref_dim_cd:OPT_REF_DIM.06 ref_key1:1/2", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000013", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand: "택1 필수(min1/max1)", ref_dim: "OPT_REF_DIM.06 인쇄옵션(opt_id)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "단면(opt_id=1→POPT_000001)"}
- rel: {rel: option_refs, target: printopt-POPT_000002, ref_key1: "2", note: "양면(opt_id=2→POPT_000002)"}
- 본문: 도수·단양면 택1 필수 그룹. option_items ref_dim=OPT_REF_DIM.06(opt_id 참조·NOT clr_cd·[[rule/rules#RULE_dosu_is_printopt]]). 도수=print_opt_cd. fn_chk_opt_item_ref 정합=대상 POPT는 부모 018 has_print_option에 실재.

### [optgroup-018-paper] 종이(자재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000018
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000018 opt_grp_cd:OPT_000014 (키:(PRD_000018,OPT_000014))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000057~063 ref_dim_cd:OPT_REF_DIM.03 ref_key1:mat_cd ref_key2:USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000014", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", mand: "택1 필수", 참조_전체: "자재 7종(BOM 표·074 dflt)", ref_dim: "OPT_REF_DIM.03 자재(mat_cd+usage_cd)"}
- rel: {rel: option_refs, target: material-MAT_000074, ref_key1: "MAT_000074", note: "백색모조지 220g(dflt)"}
- rel: {rel: option_refs, target: material-MAT_000081, ref_key1: "MAT_000081", note: "아트지 250g"}
- rel: {rel: option_refs, target: material-MAT_000082, ref_key1: "MAT_000082", note: "아트지 300g"}
- rel: {rel: option_refs, target: material-MAT_000091, ref_key1: "MAT_000091", note: "스노우지 250g"}
- rel: {rel: option_refs, target: material-MAT_000092, ref_key1: "MAT_000092", note: "스노우지 300g"}
- 본문: 용지 택1 필수 그룹. option_refs는 공유 축 노드가 있는 5종만 배선(전체 7종은 자재 BOM 표 권위·fn_chk_opt_item_ref 정합=전부 같은 부모 018 실재). 미민팅 2종(MAT_000080/090)은 [[GAP_018_material]]·needed_shared_nodes 반환.

### [optgroup-018-corner] 모서리(직각/둥근) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000018
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000018 opt_grp_cd:OPT_000015 (키:(PRD_000018,OPT_000015))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000064/065 ref_dim_cd:OPT_REF_DIM.04 ref_key1:PROC_000027/028", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000015", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", mand: "택1 선택(min0/max1)", ref_dim: "OPT_REF_DIM.04 공정(proc_cd)"}
- rel: {rel: option_refs, target: process-PROC_000027, ref_key1: "PROC_000027", note: "직각(dflt)"}
- rel: {rel: option_refs, target: process-PROC_000028, ref_key1: "PROC_000028", note: "둥근"}
- 본문: 모서리 형태(직각/둥근) 택1 선택 그룹. option_refs 대상 공정은 공유 [[axis/processes]] 축 노드(부모 018 has_process 정합·fn_chk_opt_item_ref). 가격은 귀돌이비 COMP_PP_CORNER_RIGHT(proc_grp PROC_000026·.03 고정 교정·[[rule/decisions#DEC_corner_260702]]).

### [optgroup-018-postpress] 후가공(오시·미싱·가변텍스트/이미지) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000018
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000018 opt_grp_cd:OPT_000016 (키:(PRD_000018,OPT_000016))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000066~069 ref_dim_cd:OPT_REF_DIM.04 ref_key1:PROC_000029~032", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000016", opt_grp_nm: "후가공", sel_typ_cd: "SEL_TYPE.02", mand: "택N 다중(min0/max4)", ref_dim: "OPT_REF_DIM.04 공정(proc_cd)", param_gap: "줄수/개수 파라미터 보존불가(GAP-PARAM)"}
- rel: {rel: option_refs, target: process-PROC_000029, ref_key1: "PROC_000029", note: "오시"}
- rel: {rel: option_refs, target: process-PROC_000030, ref_key1: "PROC_000030", note: "미싱"}
- rel: {rel: option_refs, target: process-PROC_000031, ref_key1: "PROC_000031", note: "가변텍스트"}
- rel: {rel: option_refs, target: process-PROC_000032, ref_key1: "PROC_000032", note: "가변이미지"}
- 본문: 후가공 택N 다중 그룹(SEL_TYPE.02·최대 4종 동시). option_refs 4공정 전부 공유 [[axis/processes]] 축 노드(부모 018 has_process 정합). 오시/미싱 줄수·가변 개수 파라미터는 CPQ가 보존하지 못함 → [[gap-018-postpress-param]](형제 033 gap-033-vardata-param과 동류).

### [GAP_018_material] 018 활성자재 7종 중 2종 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: MAT_000080/090은 live-snapshot 실재·BOM 전사표 권위이나 공유 axis/materials 미민팅이라 uses_material·option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000018 활성 7행 중 MAT_000080(아트지200g)·MAT_000090(스노우지200g)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "018 활성자재 7종 중 2종(MAT_000080 아트지200g·MAT_000090 스노우지200g)이 공유 [[axis/materials]]에 미민팅 — uses_material·optgroup-018-paper option_refs는 민팅된 5종(074/081/082/091/092)만 배선. BOM 전사표가 권위이나 그래프 탐색 시 2종 침묵 누락"
- gap_fill_from: "통합 단계가 공유 axis/materials에 material-MAT_000080·material-MAT_000090 mint(mat_typ MAT_TYPE.01·USAGE.07 공통·live-snapshot t_mat_materials 실재) → 018 uses_material 5→7·optgroup-018-paper option_refs 5→7 확장. needed_shared_nodes로 반환(직접 mint 금지)"
- gap_owner: 설계
- rel: {rel: references, target: material-MAT_000074, note: "같은 018 종이 옵션풀 대표 배선 축 노드"}
- 본문: 값은 아는데(live·BOM 전사) 공유 축 노드가 5종만이라 그래프 배선이 부분적인 KB 커버리지 공백. 조용한 누락 대신 정직 선언(형제 016 GAP_016_material과 동류). 채움=통합 단계 mint(needed_shared_nodes).

### [gap-018-constraint] 스탠다드엽서 제약 라이브 미등록 {unknown}
- type: gap
- anchor: none  # 사유: 오시·미싱 물리 상호배제는 도메인 성립하나 t_prd_product_constraints 0행 — 환각 constraint 노드 금지
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "prd_cd:PRD_000018 행 0", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "018 제약 0행. 형제 016은 [DEMO] 2건(오시↔미싱 상호배제·양면 시 가변텍스트 노출) 보유하나 018엔 데모조차 없음. 오시·미싱 동시 물리 불가(CN-4)는 도메인상 성립하나 라이브 미작성"
- gap_fill_from: "§31 제약규칙 거버넌스(폼빌더 정형 shape·CN-4 상호배제) 등록 — 인간 승인 트랙(huni-constraint-rules). 등록 후 constraint-018-* 노드 + constrains 엣지 배선"
- gap_owner: staff
- 본문: 제약이 도메인상 필요해 보이나(오시·미싱 상호배제) 라이브 미등록이라 지어내지 않고 정직 선언. evaluate_price는 제약 미참조 — validate는 위젯/주문 호출(constraint-builder 계약).

### [gap-018-addon-envelope] 스탠다드엽서 봉투 추가상품 라이브 미등록 {unknown}
- type: gap
- anchor: none  # 사유: 엽서-봉투 딸림은 도메인 관행이나 t_prd_product_addons 0행 — 환각 has_addon 금지
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "prd_cd:PRD_000018 행 0", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "018 추가상품 0행. 형제 016은 봉투 addon 5행(TMPL-000005/006/009/038/039) 보유하나 018은 미적재. 엽서=봉투 딸림 관행이나 라이브에 없음"
- gap_fill_from: "봉투 addon 필요 여부 실무진 확인 → 필요 시 t_prd_product_addons 적재(인간 승인·dbmap 위임) 후 has_addon 배선. 형제 016 봉투 addon 재사용 후보(search-before-mint)"
- gap_owner: staff
- 본문: 봉투 addon이 도메인 관행이나 라이브 미적재라 has_addon 엣지 미배선(정직 선언). 형제 016은 5행 실재 — 018 누락이 의도인지 미적재인지 실무진 확인.

### [gap-018-postpress-param] 후가공 줄수·개수 파라미터 보존불가 {unknown}
- type: gap
- anchor: none  # 사유: 오시/미싱 줄수·가변 개수는 CPQ option_items 구조에 보존 슬롯 없음(라이브 note 실증)
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "prd_cd:PRD_000018 opt_grp_cd:OPT_000016 note='줄수/개수=GAP-PARAM'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "후가공(오시/미싱/가변) 옵션이 '몇 줄·몇 개'인지 파라미터를 CPQ가 보존 못함(라이브 note가 GAP-PARAM 명시). 가격은 공정 발현되나 수량 파라미터가 옵션 구조에 없음"
- gap_fill_from: "옵션 파라미터 스키마 확장(수량 슬롯) — 설계 결정(형제 033 gap-033-vardata-param과 동일 축·횡단 해결 필요)"
- gap_owner: 설계
- rel: {rel: references, target: process-PROC_000029, note: "오시(줄수 파라미터 대상 공정)"}
- 본문: 후가공 공정은 배선되나 '오시 2줄'·'가변 100개' 같은 파라미터를 CPQ가 못 담는 구조적 공백. 형제 033과 동류(횡단 GAP 후보).
