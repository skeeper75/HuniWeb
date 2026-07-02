---
id: product-020-white-print-postcard
type: product
anchor: t_prd_products/PRD_000020
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000020 (del_yn=N·use_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 도수·별색=공정·§3.5 자재·§3.7 인쇄옵션(020 화이트인쇄 SPOT 발현)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "MEMORY/whiteprint-material-4color-unified-spot-component-260630.md", source_locator: "§1 화이트인쇄 자재=색지4색(화이트 제외)·§2 통합별색 component(020=040 동형선례)", captured_at: "2026-07-03", badge: candidate, src_id: SR-mem-whiteprint}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y·라이브 실측)"}
  - {rel: has_size, target: size-SIZ_000002, note: "98x98"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150"}
  - {rel: has_size, target: size-SIZ_000004, note: "135x135"}
  - {rel: has_size, target: size-SIZ_000007, note: "148x210"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면"}
  - {rel: uses_material, target: material-MAT_000362, note: "큐리어스스킨 레드 270g(색지·USAGE.07)"}
  - {rel: uses_material, target: material-MAT_000363, note: "큐리어스스킨 다크블루 270g"}
  - {rel: uses_material, target: material-MAT_000364, note: "큐리어스스킨 바이올렛 270g"}
  - {rel: uses_material, target: material-MAT_000365, note: "큐리어스스킨 블랙 270g"}
  - {rel: has_process, target: process-PROC_000008, qualifier: mandatory, note: "화이트인쇄(별색·mand_proc_yn=Y·인쇄비 원천)"}
  - {rel: has_process, target: process-PROC_000009, note: "클리어인쇄(별색·옵션)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-020}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-020-white}
  - {rel: has_option_group, target: optgroup-020-paper}
  - {rel: has_option_group, target: optgroup-020-clear}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 12
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서(디지털인쇄 완제품 단일·화이트인쇄 별색)"
standards: {schema_org: "Product", xjdf: "Product(엽서·SpotColorIntent)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(화이트인쇄엽서 구성·가격 축)", "조건 탐색(색지에 흰색 인쇄 되는 엽서)"]
tags: ["#디지털인쇄", "#엽서", "#화이트인쇄", "#별색", "#원자합산형"]
updated: 2026-07-03
---

# 화이트인쇄엽서 (product-020-white-print-postcard)

화이트인쇄엽서(PRD_000020)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품).
**어두운/유색 색지(큐리어스스킨 4색) 위에 불투명 흰 토너(화이트인쇄)를 올리는 별색 인쇄물**이다 — 흰 종이에
흰 토너는 대비 0이라 무의미하므로 자재가 유색 색지로 한정된다([[rule/rules#RULE_dosu_is_printopt]] 별색=공정 정합·
MEMORY 화이트인쇄 색지4색). 사이즈 **4행**(98×98~148×210·이산 사이즈)·칼라 단/양면·클리어인쇄 옵션. 가격은
**원자합산형 공식** [[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A)으로 계산한다(값 계산=evaluate_price
권위·[[rule/rules#RULE_price_value_boundary]]).

- **정체**: live-snapshot(prd_cd·prd_nm 실재) + 팩 §3.3/§3.7(화이트인쇄=별색·SPOT 발현). 016 프리미엄엽서의 **화이트인쇄 변형**(같은 엽서 카테고리·같은 공식·자재만 색지로 교체).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **화이트인쇄 = 별색 공정**: 인쇄비는 CMYK base(PROC_000004)가 아니라 **별색 화이트/클리어**(PROC_000008/009)에서
  나온다 — 공식 PRF_DGP_A의 `COMP_PRINT_SPOT_WHITE_S1`(통합 별색·화이트8/클리어9 단가행 보유)이 이를 커버(§가격공식 사슬).
- **끊긴 경로(정직 선언)**: 봉투 addon 5행은 live 실재하나 대상 봉투 상품·template 노드 미민팅 → [[product-020-white-print-postcard-nodes#gap-020-addon-target]].
  종이 옵션의 CPQ ref 레이어(option_items) 부재 → [[product-020-white-print-postcard-nodes#gap-020-paper-optitem-ref]].

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_020.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님·D-9).

#### 정체

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000020 @ 2026-07-03 -->
| 컬럼 | 값 |
|---|---|
| prd_cd | PRD_000020 |
| prd_nm | 화이트인쇄엽서 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 12 |
| max_qty | 10000 |
| qty_incr | 12 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | Y |
| del_yn | N |

수량 min/incr = 12(016=15과 다름·이 상품 고유). 파일 업로드형(editor_yn=N).

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000020 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

4 사이즈 전부 공유 [[axis/sizes]] 축 노드로 `has_size` 연결(016이 이미 민팅한 SIZ_000002/003/004/007 재사용·중복 생성 없음).
016 대비 73×98(SIZ_000001)·95×210(005)·110×170(006) 3종 미제공(화이트인쇄는 4종만). 치수(작업/재단)는 축 전사표 권위.

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000020 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 12 | 10000 | 12 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). `t_prd_product_bundle_qtys`
0행은 "미적재"가 아니라 이 상품의 수량 그릇이 상품/사이즈 컬럼이라는 뜻(팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000020 @ 2026-07-03 -->
활성 자재 4행 · 화이트인쇄=유색 색지(화이트 용지 제외·도메인 필터)

| mat_cd | 자재명 | mat_typ | usage_cd |
|---|---|---|---|
| MAT_000362 | 큐리어스스킨 레드 270g | MAT_TYPE.01 | USAGE.07 |
| MAT_000363 | 큐리어스스킨 다크블루 270g | MAT_TYPE.01 | USAGE.07 |
| MAT_000364 | 큐리어스스킨 바이올렛 270g | MAT_TYPE.01 | USAGE.07 |
| MAT_000365 | 큐리어스스킨 블랙 270g | MAT_TYPE.01 | USAGE.07 |

활성 4행 = 전부 유색 색지(큐리어스스킨 레드/다크블루/바이올렛/블랙). 화이트(MAT_000361)는 **부재**(흰 종이에 흰 토너=대비 0
무효·이미 교정됨·040 화이트인쇄명함 동형 선례·MEMORY whiteprint). 4 자재는 공유 [[axis/materials]] 미민팅이라
[[product-020-white-print-postcard-nodes]]에 product-local 민팅해 `uses_material` 배선(040과 공유·공유 축 승격 후보=needed_shared_nodes).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000020 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 |
|---|---|---|---|
| PROC_000008 | 화이트인쇄 | Y | X(미민팅→product-local) |
| PROC_000009 | 클리어인쇄 | N | X(미민팅→product-local) |

공정 2행 = 별색 인쇄(도수 아님·[[_glossary#TERM_spot_color]]). 화이트인쇄(mand)+클리어인쇄(opt). 둘 다 공유 [[axis/processes]]에
미민팅(별색 PROC_000007만 축에 있음)이라 [[product-020-white-print-postcard-nodes]]에 product-local 민팅해 `has_process` 배선.
★016의 CMYK base 인쇄(PROC_000004)는 **없음** — 화이트인쇄는 흰/투명 토너 별색이라 CMYK 층이 없다(가격은 별색 단가행에서·§가격공식 사슬).

#### 인쇄옵션(도수·인쇄 방식)

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options PRD_000020 @ 2026-07-03 -->
| print_opt_cd | 인쇄옵션명 | print_side | front_clr | back_clr |
|---|---|---|---|---|
| POPT_000001 | 단면 |  |  |  |
| POPT_000002 | 양면 |  |  |  |

단/양면 = 공유 [[axis/print-options]] POPT_000001/002 재사용(`has_print_option`). 도수=print_opt_cd([[rule/rules#RULE_dosu_is_printopt]]).
별색(화이트/클리어)은 여기 도수가 아니라 위 공정으로 들어온다(clr_cd=NULL·팩 §3.3).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000020 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선(dflt_plt=Y). 판형=종이류만·고객 미선택·
fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]).

#### 추가상품(템플릿)

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates PRD_000020 @ 2026-07-03 -->
| disp | tmpl_cd | 템플릿명 | base_prd_cd |
|---|---|---|---|
| 1 | TMPL-000005 | OPP접착봉투 110x160 mm  50장 | PRD_000001 |
| 2 | TMPL-000006 | OPP비접착봉투 110x160 mm 50장 | PRD_000002 |
| 3 | TMPL-000038 | 카드봉투 (화이트) 165x115mm 10장 | PRD_000004 |
| 4 | TMPL-000039 | 카드봉투 (블랙) 165x115mm 10장 | PRD_000004 |
| 5 | TMPL-000009 | 트레싱지봉투 160x110 mm 20장 | PRD_000283 |

봉투 addon **5행 확정**(라이브 실재·016과 동일 봉투 세트). 대상 봉투 상품(PRD_000001/002/004/283)·템플릿 노드가 KB 미민팅이라
`has_addon`(product→product) 엣지 미배선 → [[product-020-white-print-postcard-nodes#gap-020-addon-target]]. 추가상품 표는 위 전사표가 권위.

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000020 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | use | del |
|---|---|---|---|---|
| OPT-000025 | 화이트인쇄 | SEL_TYPE.01 | Y | N |
| OPT-000026 | 종이 | SEL_TYPE.01 | Y | N |
| OPT-000027 | 클리어인쇄 | SEL_TYPE.01 | Y | N |

활성 3그룹(화이트인쇄 택1 필수·종이 택1 필수·클리어인쇄 택1 옵션). 코드 접두사 하이픈(OPT-) — separator 비일관(팩 §3.12 C-17·GAP-DP-4).
각 그룹은 [[product-020-white-print-postcard-nodes]]의 optgroup 노드로 선언(option_refs 공정/자재).

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000020 @ 2026-07-03 -->
| rule_cd | 규칙명 | rule_typ | use |
|---|---|---|---|
| (행 없음) | | | |

라이브 제약규칙 **0행**(016의 [DEMO] 제약과 달리 020은 제약 미등록). 제약 노드 없음 — 정직 표기(§31 제약 거버넌스 미착수 상품).

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_020.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000020 @ 2026-07-03 -->
| frm_cd | dflt |
|---|---|
| PRF_DGP_A |  |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선·016/041 공유).

## 가격공식 사슬 (연결만·값=evaluate_price)

020 → **PRF_DGP_A**(priced_by) → `has_component`로 배선된 구성요소 중 이 상품에 발현하는 사슬:

<!-- 아래 표는 수치(가격) 전사표가 아니라 손집필 연결 맵(구성요소↔차원명↔발현 근거)이다. 차원명/코드는 -->
<!-- formula/digital-components.md 축 노드 권위·가격 값은 evaluate_price(D-18). L-16(transcribed-by) 비대상. -->
| 구성요소 | 차원(use_dims) | 020 발현 근거 |
|---|---|---|
| [[formula/digital-components#component-COMP_PRINT_SPOT_WHITE_S1]] 별색인쇄비 | proc_cd·plt_siz·print_opt·min_qty·proc_grp:PROC_000007 | 화이트(PROC_000008)+클리어(PROC_000009) 단가행 보유 → 020 별색 인쇄비 원천 |
| [[formula/digital-components#component-COMP_PAPER]] 용지비 | plt_siz_cd·mat_cd | 국전(SIZ_000499)×색지(MAT_000362~365) → 용지비 |
| [[formula/digital-components#component-COMP_PRINT_DIGITAL_S1]] 디지털인쇄비 | proc_cd(PROC_000004)·… | 020은 PROC_000004 미바인딩 → 이 구성요소 **기여 0**(화이트인쇄=CMYK base 없음·정상·결함 아님) |

**가격 경로 연결됨**: 020 → PRF_DGP_A → COMP_PRINT_SPOT_WHITE_S1(별색 화이트/클리어 단가행·live 실측 proc_cd 8·9 보유)
+ COMP_PAPER(색지 용지비). 별색 다중공정은 공정마다 개별 룩업·합산(evaluate_price·A안·MEMORY whiteprint §2).
★클리어는 통합 별색 component가 이미 커버 — 별도 클리어 component 배선 금지(이중과금·[[rule/rules#RULE_dataline_neq_wiring]] 계보).
골든값은 미기록(값=evaluate_price 권위·D-18) — 검증 레인(okb-adversarial-verifier)이 골든 재계산.

## 이 상품 전용 하위 노드

product-local 민팅 노드(자재 4·공정 2·수량 1·옵션그룹 3·GAP 2)는 companion 파일
[[product-020-white-print-postcard-nodes]]에 정의(자기 네임스페이스·공유 축 미수정).
