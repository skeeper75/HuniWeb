---
id: product-021-pink-spot-postcard
type: product
anchor: t_prd_products/PRD_000021
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000021 (prd_nm=핑크별색엽서·prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 도수(별색=공정·PROC_000007)·§3.11 통합별색 component·§4-A base 공정", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md", source_locator: "문서:§4-A base 공정 미바인딩 18건(021 포함)", captured_at: "2026-07-03", badge: verified, src_id: SR-26-baseproc}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000002, note: "98x98"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150"}
  - {rel: has_size, target: size-SIZ_000004, note: "135x135"}
  - {rel: has_size, target: size-SIZ_000007, note: "148x210"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(CMYK 4도·back=인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(CMYK 4도)"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g·USAGE.07 (활성 3종 중 유일 축노드)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천·7월 18건 COMMIT에 021 포함)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-021}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-021-print}
  - {rel: has_option_group, target: optgroup-021-paper}
  - {rel: has_option_group, target: optgroup-021-pink}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 12
  qty_incr: 12
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "N"
  status_note: "미출시(use_yn=N) — 라이브 실재·del_yn=N이나 판매 비활성. 가격공식 바인딩 note에도 '미출시' 명기."
  구분: "엽서(디지털인쇄 완제품 단일·별색=핑크)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(핑크별색엽서 구성·가격 축)", "별색 엽서(조건 탐색·핑크 spot color)"]
tags: ["#디지털인쇄", "#엽서", "#별색", "#원자합산형", "#미출시"]
updated: 2026-07-03
---

# 핑크별색엽서 (product-021-pink-spot-postcard)

핑크별색엽서(PRD_000021)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품).
형제 [[product/product-016-premium-postcard]](프리미엄엽서)와 같은 엽서 구분·같은 원자합산형 공식
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A) 바인딩이나, **정체의 핵심은 "핑크 별색(spot color)"**
= CMYK 4도 위에 **핑크 별색 인쇄를 추가 공정으로 얹는** 엽서다.

- **정체**: live-snapshot `t_prd_products` PRD_000021(prd_nm=핑크별색엽서) + 팩 §3.3(별색=공정). 사이즈 4행·
  칼라 단/양면·핑크별색 인쇄. 봉투 5행 추가상품.
- **★별색=공정 [HARD]**: 핑크별색은 **도수(print_opt_cd)가 아니라 공정 [[axis/processes#process-PROC_000007]]
  별색인쇄의 자식 공정 `PROC_000010`(핑크인쇄, upr_proc_cd=PROC_000007)** 으로 들어온다(clr_cd=NULL·팩 §3.3·
  [[rule/rules#RULE_dosu_is_printopt]]·용어 [[_glossary#TERM_spot_color]]). base 도수는 CMYK 4도(칼라).
- **미출시(use_yn=N)**: 라이브 실재하나 판매 비활성. 가격공식 바인딩 note·상품 마스터 use_yn 모두 "미출시" 일관
  (badge=verified — 데이터는 검증됨·미출시는 상태 사실이지 결함 아님).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만. 최종 값은 견적기(evaluate_price·
  [[rule/rules#RULE_price_value_boundary]]).
- **7월 교정 계보**: base 공정 PROC_000004 미바인딩→인쇄비 0 대발견의 **18건 COMMIT 대상에 021 포함**
  ([[rule/decisions#DEC_baseproc_260701]]) · 통합별색 component 채택([[rule/decisions#DEC_spotwhite_260630]]).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원) — 연결됨

핑크별색엽서 → `priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선) →
`has_component` → 아래 구성요소 사슬로 **가격 경로 연결 완료**(고아 공식 아님):

- **base 인쇄비** = `COMP_PRINT_DIGITAL_S1`(PROC_000004 매칭·disp_seq 0).
- **★핑크 별색 인쇄비** = **통합별색 component `COMP_PRINT_SPOT_WHITE_S1`**(disp_seq 1·별색인쇄비·
  use_dims에 `proc_grp:PROC_000007` 포함 — 화이트/금/은/클리어/**핑크** 5별색을 단면/양면으로 통합·개별
  `COMP_PRINT_SPOT_PINK_S1/S2`는 use_yn=N·[[rule/decisions#DEC_spotwhite_260630]]). 021의 핑크인쇄 공정
  PROC_000010은 그룹 [[axis/processes#process-PROC_000007]](PROC_000007)의 자식이라, **가격 차원 쪽은
  공유 축 노드 PROC_000007로 연결**된다(상품측 has_process→PROC_000010 배선은 축 노드 미민팅으로 대기 →
  [[gap-021-pink-process]]).
- **용지비** = `COMP_PAPER`(plt_siz×mat) + 후가공(귀돌이/오시/미싱/가변/코팅) 원자합산.

즉 **가격 경로는 공유 노드만으로 연결**되고(product→PRF_DGP_A→COMP_PRINT_SPOT_WHITE_S1/COMP_PRINT_DIGITAL_S1/
COMP_PAPER), 핑크 별색의 단가 차원은 `proc_grp:PROC_000007`(공유 축)로 환원된다. 값 계산은 evaluate_price 권위.

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_021.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000021 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

사이즈 **4행**(98×98·100×150·135×135·148×210·이산 사이즈·면적매트릭스 아님). 형제 016(7행)의 부분집합(73×98·
95×210·110×170 없음). 4행 전부 `has_size` 배선. 치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위. 판걸이수(UP수)는
DB 함수 `fn_calc_pansu` 파생([[rule/rules#RULE_pansu_db_function]]·마스터 vs 판걸이수시트 충돌은 [[rule/gaps#GAP_pansu_73x98]]).

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000021 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 12 | 10000 | 12 | QTY_UNIT.02 | 상품 레벨 수량규칙(use_yn=N) |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12·016의 15와 다름). `t_prd_product_bundle_qtys` 0행은
정상(수량 UI 권위=상품/사이즈 규칙·가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]·팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000021 @ 2026-07-03 -->
활성 자재 3행 · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | usage_cd | 축노드 존재 |
|---|---|---|---|
| MAT_000107 | 몽블랑 190g | USAGE.07 | X(미민팅) |
| MAT_000109 | 몽블랑 240g | USAGE.07 | O |
| MAT_000347 | 아코팩 웜화이트 250g | USAGE.07 | O(미민팅)† |

† 스크립트 화이트리스트 표기는 위와 같으나 실제 공유 [[axis/materials]]에는 MAT_000107·MAT_000347 **미민팅**
(몽블랑240g만 존재). 활성 3행 전부 usage_cd 단일 슬롯(USAGE.07·팩 §3.5 C-03 공통·정당). `uses_material`은 축 노드가
있는 **MAT_000109만** 배선; MAT_000107(몽블랑190g)·MAT_000347(아코팩웜화이트250g)은 위 BOM 표가 권위이며 그래프
커버리지 공백은 [[gap-021-material]]로 정직 선언(형제 016 GAP_016_material과 동류). ★IMPORT 시트 등록 자재는
삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 인쇄옵션(도수)

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options PRD_000021 @ 2026-07-03 -->
| print_opt_cd | 라벨 | print_side | front_clr | back_clr |
|---|---|---|---|---|
| POPT_000001 | 단면 | 단면 | CLR_000005 | CLR_000001 |
| POPT_000002 | 양면 | 양면 | CLR_000005 | CLR_000005 |

도수(base) = 단면/양면 **CMYK 4도**(front CLR_000005=CMYK 4도·단면 back CLR_000001=인쇄안함). 도수=print_opt_cd
(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]). ★핑크 별색은 여기(도수) 아님 — 공정 PROC_000010으로 분리
([[axis/processes#process-PROC_000007]] 계열·아래 공정표·팩 §3.3 T-4 함정 회피).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000021 @ 2026-07-03 -->
| proc_cd | 공정명 | upr_proc | mand | 축노드 존재 |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | PROC_000001 | Y | O |
| PROC_000010 | 핑크인쇄 | PROC_000007 | N | X(미민팅·단독상품) |

공정 2행. `PROC_000004`(디지털인쇄 base·mand)는 공유 [[axis/processes#process-PROC_000004]]로 `has_process` 배선
(7월 base 공정 18건 COMMIT에 021 포함·[[rule/decisions#DEC_baseproc_260701]]). **`PROC_000010`(핑크인쇄·별색
공정·PROC_000007 자식)은 021 단독 사용**이라 공유 축 미민팅 → `has_process` 배선 대기([[gap-021-pink-process]]).
가격 쪽은 통합별색 component가 `proc_grp:PROC_000007`(공유 축)로 환원해 연결됨(위 가격 경로 절).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000021 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선(dflt_plt=Y). 판형=종이류만·
고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]).

#### 추가상품(템플릿)

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates PRD_000021 @ 2026-07-03 -->
| disp | tmpl_cd | 템플릿명 | base_prd_cd |
|---|---|---|---|
| 1 | TMPL-000005 | OPP접착봉투 110x160 mm  50장 | PRD_000001 |
| 2 | TMPL-000006 | OPP비접착봉투 110x160 mm 50장 | PRD_000002 |
| 3 | TMPL-000038 | 카드봉투 (화이트) 165x115mm 10장 | PRD_000004 |
| 4 | TMPL-000039 | 카드봉투 (블랙) 165x115mm 10장 | PRD_000004 |
| 5 | TMPL-000032 | 트레싱지봉투 160x110 mm 100장 | PRD_000283 |

봉투 addon **5행 확정**(라이브 실재·base_prd PRD_000001/002/004/283). 016과 조합이 다름(021=TMPL-000032 트레싱지봉투
100장, 016=TMPL-000009 트레싱지봉투 20장). 대상 봉투 상품·template 노드가 KB 미민팅이라 `has_addon`(product→product)
엣지는 배선 불가 → [[gap-021-addon-target]]. always-add 가드(use_dims에 opt_cd 미포함→silent 가산·형제 016 참조).

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000021 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | mand | use | del |
|---|---|---|---|---|---|
| OPT-000018 | 인쇄 | SEL_TYPE.01 | N | Y | N |
| OPT-000019 | 종이 | SEL_TYPE.01 | N | Y | N |
| OPT-000020 | 핑크인쇄 | SEL_TYPE.01 | N | Y | N |

활성 3그룹(인쇄·종이·핑크인쇄). ★코드 접두사 하이픈(OPT-) — separator 비일관(팩 §3.12 C-17·GAP-DP-4·open_question).
아래 optgroup 노드로 각각 선언. 핑크인쇄 그룹(OPT-000020)이 별색 공정을 손님 택1로 노출.

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000021 @ 2026-07-03 -->
제약 행수 0

(제약 미등록 — 016 데모 제약과 달리 021은 제약 0행)

제약 규칙 미등록(라이브 0행). 형제 016의 [DEMO] 제약과 달리 021은 제약이 없다(§31 제약규칙 거버넌스 미착수 상품).

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000021 @ 2026-07-03 -->
| frm_cd | note |
|---|---|
| PRF_DGP_A | 핑크별색엽서 → PRF_DGP_A (use_yn=N 미출시) |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소·016과 공유). 바인딩 note에
"use_yn=N 미출시" 명기. 핑크 별색 인쇄비는 통합별색 component(COMP_PRINT_SPOT_WHITE_S1) 경유(위 가격 경로 절).

---

## 이 상품 전용 하위 노드 (option_group·qty·gap)

### [qty-021] 핑크별색엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000021
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000021 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 12/10000/12)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈·[[rule/decisions#DEC_qty_audit_260702]]).

### [optgroup-021-print] 인쇄(도수·단양면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000021
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000021 opt_grp_cd:OPT-000018", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000018", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", min_max_sel: "0/1"}
- rel: {rel: option_refs, target: printopt-POPT_000001, note: "단면"}
- rel: {rel: option_refs, target: printopt-POPT_000002, note: "양면"}
- 본문: 도수·단양면 선택 그룹. 도수=print_opt_cd(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]). option_refs 대상(POPT_000001/002)은 부모 021 has_print_option 정합(fn_chk_opt_item_ref).

### [optgroup-021-paper] 종이(자재) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000021
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000021 opt_grp_cd:OPT-000019", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000019", opt_grp_nm: "종이", sel_typ_cd: "SEL_TYPE.01", 참조_전체: "활성 자재 3종(BOM 표·MAT_000107/109/347)"}
- rel: {rel: option_refs, target: material-MAT_000109, note: "종이 옵션→자재 차원(축 노드 있는 유일 자재)"}
- 본문: 용지 선택 그룹. option_refs는 축 노드가 있는 MAT_000109만 배선(전체 3종은 자재 BOM 표 권위·fn_chk_opt_item_ref 정합=전부 같은 부모 021 실재). MAT_000107/347 미민팅은 [[gap-021-material]].

### [optgroup-021-pink] 핑크인쇄(별색 공정) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000021
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000021 opt_grp_cd:OPT-000020", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 별색=공정(PROC_000007)·clr_cd=NULL", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
- props: {opt_grp_cd: "OPT-000020", opt_grp_nm: "핑크인쇄", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", refs_pending: "PROC_000010(핑크인쇄·PROC_000007 자식)=공유 축 미민팅→option_refs 대기"}
- 본문: 핑크 별색 인쇄를 손님 택1로 노출하는 옵션 그룹(별색=공정·도수 아님·[[rule/rules#RULE_dosu_is_printopt]]·용어 [[_glossary#TERM_spot_color]]). option_refs 대상 공정 PROC_000010이 공유 [[axis/processes]] 미민팅이라 엣지 배선은 대기 → [[gap-021-pink-process]]. 가격은 통합별색 component가 proc_grp:PROC_000007로 환원([[rule/decisions#DEC_spotwhite_260630]]).

### [gap-021-pink-process] 핑크인쇄 공정 PROC_000010 공유 축 미민팅 {unknown}
- type: gap
- anchor: none  # 사유: PROC_000010(핑크인쇄)은 live 실재(021 단독 사용)이나 공유 axis/processes.md 미민팅이라 has_process·optgroup-021-pink option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000021 proc_cd:PROC_000010 (upr_proc_cd=PROC_000007·mand_proc_yn=N)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "핑크인쇄 공정 PROC_000010(별색·PROC_000007 자식)이 공유 axis/processes에 미민팅 — 021 has_process·optgroup-021-pink option_refs 배선 대기. 가격 차원은 proc_grp:PROC_000007(공유 축·이미 존재)로 환원되어 가격 경로 자체는 연결됨"
- gap_fill_from: "architect가 process-PROC_000010(핑크인쇄) 공유 축 노드 mint 결정 시 배선 완료(needed_shared_nodes 반환). 단독상품 소유라 016 방식(gap→R2 승격)과 동일 경로"
- gap_owner: 설계
- rel: {rel: references, target: process-PROC_000007, note: "부모 별색공정 그룹(가격 차원 환원처·공유 축 존재)"}
- 본문: 021의 정체 핵심(핑크 별색) 공정 노드가 공유 축에 없어 상품측 배선이 대기 중. 값·의미는 확정(live·transcribe)이고 조용한 누락 대신 정직 선언. 채움=공유 축 mint(직접 mint 금지·needed_shared_nodes 반환).

### [gap-021-material] 021 활성자재 3종 중 2종 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: MAT_000107·MAT_000347은 live 실재·BOM 전사표 권위이나 공유 axis/materials 미민팅(MAT_000109만 존재)이라 uses_material·option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000021 활성 3행 중 2종(MAT_000107 몽블랑190g·MAT_000347 아코팩웜화이트250g)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "021 활성자재 3종 중 MAT_000107(몽블랑190g)·MAT_000347(아코팩웜화이트250g)이 공유 axis/materials 미민팅 — uses_material·optgroup-021-paper option_refs는 MAT_000109만 배선. BOM 전사표가 권위이나 그래프 탐색 시 2종 침묵 누락(형제 016 GAP_016_material 동류)"
- gap_fill_from: "architect 완전성 정책 — 공유 축에 MAT_000107·MAT_000347 mint(needed_shared_nodes 반환) 후 021 uses_material 1→3 확장"
- gap_owner: 설계
- rel: {rel: references, target: material-MAT_000109, note: "같은 021 종이 옵션풀 대표 배선 축 노드"}
- 본문: 값은 아는데(live·BOM 전사) 공유 축 노드가 1종만이라 그래프 배선이 부분적인 KB 커버리지 공백. 정직 선언. 채움=공유 축 mint 결정.

### [gap-021-addon-target] 봉투 addon 대상 상품·템플릿 노드 미민팅 {unknown}
- type: gap
- anchor: none  # 사유: 봉투 addon 5행은 live 실재하나 대상 봉투 상품/템플릿 노드가 KB 미민팅으로 has_addon(product→product) 배선 불가
- src: {source_file: "live-snapshot/latest/t_prd_product_addons.csv", source_locator: "prd_cd:PRD_000021 (TMPL-000005/006/038/039/032→base_prd PRD_000001/002/004/283)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "021 봉투 addon 5행(TMPL-000005/006/038/039/032) 확정이나 대상 봉투 상품(PRD_000001/002/004/283)·template 노드가 KB 미민팅 → has_addon 엣지 미배선. TMPL-000032(트레싱지봉투 100장)는 016(TMPL-000009 20장)과 다른 조합"
- gap_fill_from: "봉투 상품 노드 집필 또는 template 노드 승격(스키마 §1.1 R14·파일럿 후 인간 승인)"
- gap_owner: 설계
- 본문: 봉투 5행은 실재·확정. 대상 노드 부재로 엣지만 대기(형제 016 gap-016-addon-target과 동류). 추가상품 표가 권위.
