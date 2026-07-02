---
id: product-016-premium-postcard
type: product
anchor: t_prd_products/PRD_000016
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000016 (del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체·§3.2~3.12 축별 정답소스(디지털인쇄)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§1 정체확정표 프리미엄엽서 (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=N)"}
  - {rel: has_size, target: size-SIZ_000001}
  - {rel: has_size, target: size-SIZ_000002, qualifier: {qty_incr: 8}}
  - {rel: has_size, target: size-SIZ_000003}
  - {rel: has_size, target: size-SIZ_000004}
  - {rel: has_size, target: size-SIZ_000005}
  - {rel: has_size, target: size-SIZ_000006}
  - {rel: has_size, target: size-SIZ_000007}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 칼라"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면 칼라"}
  - {rel: uses_material, target: material-MAT_000074, note: "대표(활성 21종 중)·USAGE.07"}
  - {rel: uses_material, target: material-MAT_000082, note: "아트지 300g"}
  - {rel: uses_material, target: material-MAT_000092, note: "스노우지 300g"}
  - {rel: uses_material, target: material-MAT_000101, note: "랑데뷰 WH 240g"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000027, note: "직각 모서리(옵션·귀돌이 PROC_000026 자식·R2 배선)"}
  - {rel: has_process, target: process-PROC_000028, note: "둥근 모서리(옵션·귀돌이 R·R2 배선)"}
  - {rel: has_process, target: process-PROC_000029, note: "오시(옵션)"}
  - {rel: has_process, target: process-PROC_000030, note: "미싱(옵션)"}
  - {rel: has_process, target: process-PROC_000031, note: "가변텍스트(옵션·가변데이타 PROC_000085 자식·R2 배선)"}
  - {rel: has_process, target: process-PROC_000032, note: "가변이미지(옵션·가변데이타 자식·R2 배선)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-016}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-016-print}
  - {rel: has_option_group, target: optgroup-016-paper}
  - {rel: has_option_group, target: optgroup-016-corner}
  - {rel: has_option_group, target: optgroup-016-crease}
  - {rel: has_option_group, target: optgroup-016-perf}
  - {rel: has_option_group, target: optgroup-016-vartext}
  - {rel: has_option_group, target: optgroup-016-varimg}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 15
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서(디지털인쇄 완제품 단일)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(프리미엄엽서 구성·가격 축)", "양면 되는 엽서(조건 탐색)"]
tags: ["#디지털인쇄", "#엽서", "#원자합산형", "#파일럿앵커"]
updated: 2026-07-03
---

# 프리미엄엽서 (product-016-premium-postcard)

프리미엄엽서(PRD_000016)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품).
사이즈 **7행**(73×98~148×210·이산 사이즈·면적매트릭스 아님)·칼라 단/양면·모서리(직각/둥근)·오시·미싱·
가변(텍스트/이미지) 후가공. 봉투를 **추가상품**으로 딸 수 있고, 가격은 **원자합산형 공식**
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A)으로 계산한다(값 계산=evaluate_price 권위·
[[rule/rules#RULE_price_value_boundary]]).

- **정체**: 팩 §3.1(FRESH·의미 시점무관) + live-snapshot(prd_cd 실재). 파일럿 앵커 상품(스키마 §4.1 예시 A).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **7월 교정 계보**: base 공정 미바인딩→인쇄비 0 대발견의 **기준점(016 미러)**([[rule/decisions#DEC_baseproc_260701]]) ·
  귀돌이비 ×수량 과대청구→.03 교정([[rule/decisions#DEC_corner_260702]]) · 수량 max 2행 교정([[rule/decisions#DEC_qty_audit_260702]]).
- **공정 배선 완료(R2)**: 공정 4행(직각/둥근/가변텍스트/가변이미지)은 공유 [[axis/processes]] 축 노드
  민팅(260703 승격)으로 has_process 3→7 배선 완료(라이브 7공정 전수 정합·gap-016-process-nodes 대상 소멸).
- **끊긴 경로(정직 선언)**: 봉투 addon 대상 봉투 상품·template 노드가 아직 없어 has_addon 배선 대기 →
  [[gap-016-addon-target]]. 자재는 대표 4종만 축 배선(17종 커버리지 공백) → [[GAP_016_material]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_016.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000016 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000001 | 73x98 | Y |  |  |  |
| SIZ_000002 | 98x98 | Y |  |  | 8 |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000005 | 95x210 | Y |  |  |  |
| SIZ_000006 | 110x170 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

7 사이즈 전부 `has_size`로 연결(위 relations). 치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위.
73×98(SIZ_000001)의 판걸이수(UP수)는 두 tier A 원천 충돌(GAP)이라 값 미확정 → [[rule/gaps#GAP_pansu_73x98]].

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000016 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 15 | 10000 | 15 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). `t_prd_product_bundle_qtys`
0행은 "미적재"가 아니라 이 상품의 수량 그릇이 상품/사이즈 컬럼이라는 뜻(팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000016 @ 2026-07-03 -->
활성 자재 21행 · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | usage_cd |
|---|---|---|
| MAT_000074 | 백색모조지 220g | USAGE.07 |
| MAT_000351 | 스타화이트(하이테크) 238g | USAGE.07 |
| MAT_000353 | 클래식 크래스트 스티플 270g | USAGE.07 |
| MAT_000354 | 매직터치(백색) 250g | USAGE.07 |
| MAT_000355 | 켄도 250g | USAGE.07 |
| MAT_000123 | 띤또레또 200g | USAGE.07 |
| MAT_000124 | 띤또레또 250g | USAGE.07 |
| MAT_000356 | 한지 170g | USAGE.07 |
| MAT_000357 | 스코트랜드 220g | USAGE.07 |
| MAT_000352 | 스타드림(다이아몬드) 240g | USAGE.07 |
| MAT_000358 | 스타드림(실버) 240g | USAGE.07 |
| MAT_000082 | 아트지 300g | USAGE.07 |
| MAT_000359 | 스타드림(골드) 240g | USAGE.07 |
| MAT_000360 | 스타드림(로즈쿼츠) 240g | USAGE.07 |
| MAT_000092 | 스노우지 300g | USAGE.07 |
| MAT_000101 | 랑데뷰 WH 240g | USAGE.07 |
| MAT_000109 | 몽블랑 240g | USAGE.07 |
| MAT_000347 | 아코팩 웜화이트 250g | USAGE.07 |
| MAT_000348 | 리사이클러스 240g | USAGE.07 |
| MAT_000349 | 매쉬멜로우 233g | USAGE.07 |
| MAT_000350 | 린넨커버 216g | USAGE.07 |

활성 21행 = 팩 §3.5 C-03(USAGE.07 공통·정당)과 일치. `uses_material`은 공유 축 노드가 있는 4종
(MAT_000074/082/092/101)만 relations로 배선; 나머지 17종(켄도·띤또레또·한지·스타드림 계열 등)은 위 BOM 표가
권위(축 노드 미민팅·[[axis/materials]]는 대표 용지만). 이 17종 그래프 커버리지 공백은 조용한 누락이 아니라
[[GAP_016_material]]로 정직 선언(형제 027/033/041은 전 자재 배선 — 016만 대표 subset·architect 완전성 정책 대기).
★IMPORT 시트 등록 자재는 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000016 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 | has_process |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | O | O |
| PROC_000027 | 직각 | N | O(260703 승격) | O(R2 배선) |
| PROC_000028 | 둥근 | N | O(260703 승격) | O(R2 배선) |
| PROC_000029 | 오시 | N | O | O |
| PROC_000030 | 미싱 | N | O | O |
| PROC_000031 | 가변텍스트 | N | O(260703 승격) | O(R2 배선) |
| PROC_000032 | 가변이미지 | N | O(260703 승격) | O(R2 배선) |

> 축노드 존재·has_process 열은 KB 상태 주석(라이브 열=proc_cd/공정명/mand는 스크립트 전사·불변).

공정 7행 전부 `has_process`로 배선(R2·라이브 활성 7공정 전수 정합). 4종(직각/둥근=모서리·가변텍스트/가변이미지)은
260703 공유 [[axis/processes]] 축 승격으로 노드가 생겨 배선 완료(형제 033/027과 동일 패턴·gap-016-process-nodes 대상 소멸).
★가격측 proc_grp는 026(귀돌이)·085(가변데이타)로 이원화(pack §3.6 "proc 이원화 systemic") — 상품 선택 공정(027/028/031/032)과
가격 proc_grp가 다른 코드다(has_process는 상품 선택 공정 코드로 배선).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000016 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000522 |  | SIZ_000003 | N |
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | N |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선. 판형=종이류만·고객 미선택·
fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]). SIZ_000522 행은
output_paper_typ 없이 item_siz=SIZ_000003(100×150)만 가리키는 판형 매핑 — 관찰 기록(대표 판형 축 노드는 국전).

#### 추가상품(템플릿)

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates PRD_000016 @ 2026-07-03 -->
| disp | tmpl_cd | 템플릿명 | base_prd_cd |
|---|---|---|---|
| 1 | TMPL-000005 | OPP접착봉투 110x160 mm  50장 | PRD_000001 |
| 2 | TMPL-000006 | OPP비접착봉투 110x160 mm 50장 | PRD_000002 |
| 3 | TMPL-000009 | 트레싱지봉투 160x110 mm 20장 | PRD_000283 |
| 4 | TMPL-000038 | 카드봉투 (화이트) 165x115mm 10장 | PRD_000004 |
| 5 | TMPL-000039 | 카드봉투 (블랙) 165x115mm 10장 | PRD_000004 |

봉투 addon **5행 확정**(라이브 실재). 다만 대상 봉투 상품(PRD_000001/002/283/004)·템플릿 노드가 KB 미민팅이라
`has_addon`(product→product) 엣지는 배선 불가 → [[gap-016-addon-target]]. ★현재값 tmpl_cd(038/039)는 팩/위키의
"010/011" 서술과 다르다(live 우선·팩 서술 낡음 — open_question).

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000016 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | use | del |
|---|---|---|---|---|
| OPT_000005 | 인쇄 | SEL_TYPE.01 | Y | N |
| OPT_000006 | 종이 | SEL_TYPE.01 | Y | N |
| OPT_000007 | 모서리 | SEL_TYPE.01 | Y | N |
| OPT_000008 | 후가공 | SEL_TYPE.02 | Y | Y |
| OPT-000005 | 오시 | SEL_TYPE.01 | Y | N |
| OPT-000006 | 미싱 | SEL_TYPE.01 | Y | N |
| OPT-000007 | 가변텍스트 | SEL_TYPE.01 | Y | N |
| OPT-000008 | 가변이미지 | SEL_TYPE.01 | Y | N |

활성 7그룹(OPT_000008 후가공은 del_yn=Y=폐기). ★코드 접두사 하이픈(OPT-)·언더스코어(OPT_) 혼용 =
separator 비일관(팩 §3.12 C-17·GAP-DP-4 — open_question). 아래 optgroup 노드로 각각 선언.

#### 제약(데모)

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000016 @ 2026-07-03 -->
| rule_cd | 규칙명 | rule_typ | use |
|---|---|---|---|
| R_DEMO_VIS | [DEMO] 양면 선택 시 가변텍스트 노출 | RULE_TYPE.01 | Y |
| R_DEMO_EXC | [DEMO] 오시·미싱 동시 불가 | RULE_TYPE.02 | Y |

두 규칙 다 **[DEMO]**(제약조건데모·§31 폼빌더 계약) — 최종 생산규칙 아님(badge=candidate). 아래 constraint 노드 참조.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_016.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000016 @ 2026-07-03 -->
| frm_cd | dflt |
|---|---|
| PRF_DGP_A |  |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선). 구성요소 사슬:
디지털인쇄비(COMP_PRINT_DIGITAL_S1·PROC_000004 매칭)+별색화이트+용지비(COMP_PAPER·plt_siz×mat)+귀돌이/오시/미싱/
가변/코팅. 값 계산은 evaluate_price(D-18 경계).

---

## 이 상품 전용 하위 노드 (option_group·constraint·qty·gap)

### [qty-016] 프리미엄엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000016 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 15/10000/15)", bdl_unit_typ_cd: "QTY_UNIT.02", size_override: "SIZ_000002 incr=8", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 15·max 10000·incr 15) + 사이즈별 규칙(98×98만 incr 8). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈). 2026-07-02 max 2행 교정(DEC_qty_audit_260702).

### [optgroup-016-print] 인쇄(도수·단양면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT_000005", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000005", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand: "손님 택1"}
- rel: {rel: option_refs, target: printopt-POPT_000001, note: "단면"}
- rel: {rel: option_refs, target: printopt-POPT_000002, note: "양면"}
- 본문: 도수·단양면 선택 그룹. 도수=print_opt_cd(색상코드 아님·RULE_dosu_is_printopt).

### [optgroup-016-paper] 종이(자재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT_000006", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000006", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", 참조_전체: "활성 자재 21종(BOM 표)"}
- rel: {rel: option_refs, target: material-MAT_000074, note: "종이 옵션→자재 차원(대표)"}
- rel: {rel: option_refs, target: material-MAT_000082}
- rel: {rel: option_refs, target: material-MAT_000092}
- rel: {rel: option_refs, target: material-MAT_000101}
- 본문: 용지 선택 그룹. option_refs는 축 노드가 있는 4종만 배선(전체 21종은 자재 BOM 표 권위·fn_chk_opt_item_ref 정합=전부 같은 부모 016 실재).

### [optgroup-016-corner] 모서리(직각/둥근) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT_000007", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000007", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", refs: "PROC_000027 직각·PROC_000028 둥근(R2 배선·축 노드 민팅됨)"}
- rel: {rel: option_refs, target: process-PROC_000027, note: "직각(R2 배선)"}
- rel: {rel: option_refs, target: process-PROC_000028, note: "둥근(R2 배선)"}
- 본문: 모서리 형태(직각/둥근) 선택 그룹. option_refs 대상 공정(027 직각·028 둥근)은 공유 [[axis/processes]]에 민팅된 축 노드로 배선(R2·부모 016 has_process 정합·fn_chk_opt_item_ref). 가격은 귀돌이비 COMP_PP_CORNER_RIGHT(proc_grp PROC_000026·.03 고정 교정).

### [optgroup-016-crease] 오시 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT-000005", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000005", opt_grp_nm: "오시", sel_typ_cd: "SEL_TYPE.01"}
- rel: {rel: option_refs, target: process-PROC_000029, note: "오시(crease)"}
- 본문: 오시(접는 자국) 옵션 그룹 → 공정 PROC_000029.

### [optgroup-016-perf] 미싱 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT-000006", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000006", opt_grp_nm: "미싱", sel_typ_cd: "SEL_TYPE.01"}
- rel: {rel: option_refs, target: process-PROC_000030, note: "미싱(perforation)"}
- 본문: 미싱(절취선) 옵션 그룹 → 공정 PROC_000030.

### [optgroup-016-vartext] 가변텍스트 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT-000007", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000007", opt_grp_nm: "가변텍스트", sel_typ_cd: "SEL_TYPE.01", refs: "PROC_000031(R2 배선·축 노드 민팅됨)"}
- rel: {rel: option_refs, target: process-PROC_000031, note: "가변텍스트(R2 배선)"}
- 본문: 가변텍스트(넘버링·개인화) 옵션 → 공정 PROC_000031(공유 축 민팅·R2 배선·부모 016 has_process 정합). 가격은 COMP_PP_VARTEXT_1EA(proc_grp PROC_000085).

### [optgroup-016-varimg] 가변이미지 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000016 opt_grp_cd:OPT-000008", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000008", opt_grp_nm: "가변이미지", sel_typ_cd: "SEL_TYPE.01", refs: "PROC_000032(R2 배선·축 노드 민팅됨)"}
- rel: {rel: option_refs, target: process-PROC_000032, note: "가변이미지(R2 배선)"}
- 본문: 가변이미지 옵션 → 공정 PROC_000032(공유 축 민팅·R2 배선·부모 016 has_process 정합). 가격은 COMP_PP_VARIMG_1EA(proc_grp PROC_000085).

### [constraint-016-demo-exc] [DEMO] 오시·미싱 동시 불가 {candidate}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "prd_cd:PRD_000016 rule_cd:R_DEMO_EXC (rule_typ RULE_TYPE.02)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-constraint-rules/03_rules", source_locator: "제약조건데모 폼빌더 계약(§31·CN-4 상호배제)", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-dp}
- props: {rule_cd: "R_DEMO_EXC", 유형: "CN-4 상호배제(mutual exclusion)", 상태: "[DEMO]·최종 생산규칙 아님", err_msg: "오시(접지선)와 미싱(절취선)은 동시에 적용할 수 없습니다"}
- rel: {rel: constrains, target: optgroup-016-crease, note: "오시"}
- rel: {rel: constrains, target: optgroup-016-perf, note: "미싱"}
- 본문: 오시·미싱 상호배제 데모 제약. 폼빌더 정형 shape([[rule/rules]] §31·raw JSONLogic 금지). evaluate_price는 제약 미참조 — validate는 위젯/주문이 호출(constraint-builder 계약).

### [constraint-016-demo-vis] [DEMO] 양면 선택 시 가변텍스트 노출 {candidate}
- type: constraint
- anchor: t_prd_product_constraints/PRD_000016
- src: {source_file: "live-snapshot/latest/t_prd_product_constraints.csv", source_locator: "prd_cd:PRD_000016 rule_cd:R_DEMO_VIS (rule_typ RULE_TYPE.01)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {rule_cd: "R_DEMO_VIS", 유형: "가시성(visibility)·조건부 노출", 상태: "[DEMO]·최종 생산규칙 아님"}
- rel: {rel: constrains, target: optgroup-016-vartext, note: "양면(POPT_000002)일 때 가변텍스트 노출"}
- 본문: 양면 선택 시 가변텍스트 그룹 노출 데모 제약(가시성 규칙). 폼빌더 계약.

<!-- [gap-016-process-nodes] 제거(R2·2026-07-03): 대상 4공정(027/028/031/032)이 260703 공유 axis/processes.md에 -->
<!-- verified 민팅되고 016 has_process·optgroup option_refs 배선이 R2에서 완료 → gap의 대상(미민팅·미배선)이 실제로 -->
<!-- 소멸. '해소' 자기선언 아님: 데이터를 라이브 부합으로 교정한 결과 gap 자체가 사라진 것(해소 판정은 검증가·다음 라운드). -->
<!-- 근거: live t_prd_product_processes PRD_000016=7공정 전수 배선·형제 033/027 동일 패턴. fix-log R2 참조. -->

### [GAP_016_material] 016 활성자재 21종 중 17종 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: 17자재는 live-snapshot 실재·BOM 전사표 권위이나 공유 axis/materials 미민팅(대표 4종만)이라 uses_material·option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000016 활성 21행 중 17종(MAT_000109/123/124/347~360 등)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "016 활성자재 21종 중 17종(켄도·띤또레또·한지·스타드림 계열 등)이 공유 [[axis/materials]]에 미민팅 — uses_material·optgroup-016-paper option_refs는 대표 4종(074/082/092/101)만 배선. BOM 전사표가 권위이나 그래프 탐색 시 17종 침묵 누락(형제 027/033/041은 전 자재 배선)"
- gap_fill_from: "architect 파일럿 완전성 정책 결정 — 대표 subset 유지(커버리지 GAP 선언) vs 17자재 product-local 민팅+전수 배선(041 방식). 후자면 자재 노드 17 mint 후 016 uses_material 4→21 확장"
- gap_owner: 설계
- rel: {rel: references, target: material-MAT_000074, note: "대표 배선 축 노드(같은 016 종이 옵션풀)"}
- 본문: 값은 아는데(live·BOM 전사) 공유 축 노드가 대표 4종만이라 그래프 배선이 부분적인 KB 커버리지 공백. 조용한 누락 대신 정직 선언(옛 gap-016-process-nodes와 동류·그쪽은 R2 배선 완료로 소멸). 채움=architect 완전성 정책 결정.

### [gap-016-addon-target] 봉투 addon 대상 상품·템플릿 노드 미민팅 {unknown}
- type: gap
- anchor: none  # 사유: 봉투 addon 5행은 live 실재하나 대상 봉투 상품/템플릿 노드가 KB 미민팅으로 has_addon(product→product) 배선 불가
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "prd_cd:PRD_000016 (TMPL-000005/006/009/038/039→base_prd PRD_000001/002/283/004)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "016 봉투 addon 5행(TMPL-000005/006/009/038/039) 확정이나 대상 봉투 상품(PRD_000001/002/283/004)·template 노드가 KB 미민팅 → has_addon 엣지 미배선. 또한 팩/위키 서술의 tmpl_cd(010/011)는 live(038/039)와 불일치=낡음"
- gap_fill_from: "봉투 상품 노드 집필 또는 template 노드 승격(스키마 §1.1 R14·파일럿 후 인간 승인) + 팩 tmpl_cd 서술 갱신"
- gap_owner: 설계
- 본문: 봉투 5행은 실재·확정(스키마 §4.1 예시 A의 has_addon 경로). 대상 노드 부재로 엣지만 대기. 추가상품 표는 위 전사표가 권위.
