---
id: product-022-gold-silver-spot-postcard
type: product
anchor: t_prd_products/PRD_000022
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000022 (del_yn=N·use_yn=N 미출시)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체·§3.3 별색=공정·§3.11 통합별색 component(디지털인쇄)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§0 distinct 36 표 엽서 그룹 (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(main_cat_yn=Y)"}
  - {rel: in_category, target: category-CAT_000001, note: "엽서/카드 상위(main_cat_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000002, note: "98x98"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150"}
  - {rel: has_size, target: size-SIZ_000004, note: "135x135"}
  - {rel: has_size, target: size-SIZ_000007, note: "148x210"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK4도·back 인쇄안함)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CMYK4도)"}
  - {rel: uses_material, target: material-MAT_000109, note: "몽블랑 240g·USAGE.07(활성 3종 중 축 민팅된 1종)"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand_proc_yn=Y·인쇄비 원천). ★별색공정 PROC_000007 미배선"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-022}
  - {rel: priced_by, target: formula-PRF_DGP_A, note: "원자합산형(016 엽서·041 상품권과 공유). 별색인쇄비 component 포함하나 공정 미배선"}
  - {rel: references, target: process-PROC_000007, note: "정체(금은별색)가 요구하는 별색인쇄 공정 — 이 상품엔 미배선(gap-022-spotcolor-unwired)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 12
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  use_yn: "N (미출시·라이브 미노출)"
  구분: "엽서(디지털인쇄 완제품 단일)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(금은별색엽서 구성·가격 축)", "별색(금/은) 되는 엽서(조건 탐색)"]
tags: ["#디지털인쇄", "#엽서", "#별색", "#원자합산형", "#미출시"]
updated: 2026-07-03
---

# 금은별색엽서 (product-022-gold-silver-spot-postcard)

금은별색엽서(PRD_000022)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 0행)·기성/디자인 아님(제조 상품).
이름의 "금은별색"은 금(gold)·은(silver) **별색(spot color)** 인쇄를 뜻하며, 도메인 규칙상 **별색은 도수가
아니라 "공정"으로 들어온다**([[rule/rules#RULE_dosu_is_printopt]]·팩 §3.3). 사이즈 **4행**(98×98~148×210·이산
사이즈)·칼라 단/양면·자재 3종·판형 국전. 가격은 **원자합산형 공식**
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A·016 엽서·041 상품권과 공유)로 계산(값 계산=
evaluate_price 권위·[[rule/rules#RULE_price_value_boundary]]).

- **★미출시 상태(use_yn=N)**: 라이브에 등록(del_yn=N)됐으나 **use_yn=N**(미노출·미출시). 가격공식 바인딩 note도
  "use_yn=N 미출시" 명기. 즉 완성·발행된 상품이 아니라 **불완전 등록 상태**(정체는 verified·완결성은 아래 GAP).
- **★정체 기능(금은별색)의 가격 경로 끊김(핵심 GAP)**: PRF_DGP_A는 별색인쇄비 구성요소
  [[formula/digital-components#component-COMP_PRINT_SPOT_WHITE_S1]](통합별색·proc_grp PROC_000007 키)를
  **포함**하나, 이 상품은 활성 공정이 **PROC_000004(디지털인쇄 base) 1행뿐** — 별색인쇄 공정(PROC_000007)을
  배선하지 않는다. 따라서 상품의 **정의 기능인 금/은 별색이 가격에 기여하지 못한다**(별색 공정 미선택→별색인쇄비
  단가행 미매칭). 지어내지 않고 정직 선언 → [[gap-022-spotcolor-unwired]].
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **끊긴 경로(정직 선언)**: 활성 자재 3종 중 2종(몽블랑190g·아코팩)이 공유 [[axis/materials]] 미민팅 →
  [[GAP_022_material]](형제 016과 동류). CPQ 옵션그룹·제약·추가상품·셋트 = **전부 0행**(손님 선택축 미구성·미출시 정합).

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_022.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 정체(마스터)

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000022 @ 2026-07-03 -->
| 필드 | 값 |
|---|---|
| prd_cd | PRD_000022 |
| prd_nm | 금은별색엽서 |
| prd_typ_cd | PRD_TYPE.01 |
| min_qty | 12 |
| max_qty | 10000 |
| qty_incr | 12 |
| qty_unit_typ_cd | QTY_UNIT.02 |
| file_upload_yn | Y |
| editor_yn | N |
| use_yn | N |
| del_yn | N |

use_yn=N = 미출시(라이브 미노출). del_yn=N이라 존재는 확정이나 판매 활성 아님 → 완결성은 GAP 소관.

#### 분류

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000022 @ 2026-07-03 -->
| cat_cd | 분류명 | main_cat_yn(연결) |
|---|---|---|
| CAT_000001 | 엽서/카드 | Y |
| CAT_000307 | 엽서 | Y |

두 분류 다 `in_category`로 연결([[axis/categories#category-CAT_000307]]·[[axis/categories#category-CAT_000001]]).
상품 마스터 cat_cd는 NULL이나 junction(t_prd_product_categories) 2행이 권위.

#### 사이즈+수량규칙

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000022 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

4 사이즈 전부 `has_size`로 연결(위 relations·전부 공유 [[axis/sizes]] 재사용·016 엽서 7행의 부분집합).
치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위. 4행 모두 dflt_yn=Y(라이브 실측·복수 기본값 관찰 기록).

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000022 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 12 | 10000 | 12 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). min=12·incr=12(016은 15·
사이즈별 override 없음). `t_prd_product_bundle_qtys` 0행은 정상(팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성 del_yn≠Y) PRD_000022 @ 2026-07-03 -->
활성 자재 3행 · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | usage_cd | dflt | 축노드 존재 |
|---|---|---|---|---|
| MAT_000107 | 몽블랑 190g | USAGE.07 | Y | X(미민팅) |
| MAT_000109 | 몽블랑 240g | USAGE.07 | Y | O |
| MAT_000113 | 아코팩 | USAGE.07 | Y | X(미민팅) |

활성 3행 = 팩 §3.5 C-03(USAGE.07 공통·정당)과 일치. `uses_material`은 공유 축 노드가 있는 1종
(MAT_000109 몽블랑240g)만 relations로 배선; 나머지 2종(몽블랑190g·아코팩)은 위 BOM 표가 권위(축 노드 미민팅·
[[axis/materials]]는 대표 용지만). 이 2종 그래프 커버리지 공백은 조용한 누락이 아니라 [[GAP_022_material]]로 정직 선언
(needed_shared_nodes로 축 mint 반환). ★IMPORT 시트 등록 자재는 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 인쇄옵션(도수)

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts+t_prt_print_options PRD_000022 @ 2026-07-03 -->
| print_opt_cd | 인쇄옵션명 | side | front 도수 | back 도수 |
|---|---|---|---|---|
| POPT_000001 | 단면 | 단면 | CMYK 4도 | 인쇄 안 함 |
| POPT_000002 | 양면 | 양면 | CMYK 4도 | CMYK 4도 |

도수 = print_opt_cd(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]). 두 옵션 다 CMYK 4도(칼라)이며 **금/은
별색을 인코딩하지 않는다** — 별색은 인쇄옵션이 아니라 별색인쇄 **공정**으로 들어와야 한다(팩 §3.3·아래 공정 표 참조).
즉 인쇄옵션 층에도 금은별색 신호가 없다(정체 기능 미배선의 방증).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000022 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | 축노드 존재 |
|---|---|---|---|
| PROC_000004 | 디지털인쇄 | Y | O |

> ★금은별색(별색인쇄 PROC_000007) 공정 미배선 — 활성 공정 행에 없음(위 표가 라이브 전수).

공정 **1행뿐**(PROC_000004 디지털인쇄 base·mand). `has_process`로 배선([[axis/processes#process-PROC_000004]]).
★핵심: 상품명이 요구하는 **별색인쇄 공정 PROC_000007**([[axis/processes#process-PROC_000007]]·축 노드는 존재)이
이 상품에 **배선되지 않았다**(del 포함 전수 확인). 그래서 PRF_DGP_A의 별색인쇄비 구성요소가 매칭할 proc_cd가 없어
금/은 별색이 가격에 기여 못함 → [[gap-022-spotcolor-unwired]]. 통합별색 component 자체는 정상 적재
([[rule/decisions#DEC_spotwhite_260630]]) — 결함은 **상품 공정 배선 부재**(component 아님).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000022 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |
|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  | Y |

`has_plate_size`는 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])로 배선(dflt_plt_yn=Y).
판형=종이류만·고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]).

#### CPQ·추가상품·셋트 (전부 0행)

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups/items/constraints/addons/sets PRD_000022 @ 2026-07-03 -->
| 레이어 | 활성 행수 |
|---|---|
| 옵션그룹(option_groups) | 0 |
| 옵션항목(option_items) | 0 |
| 제약(constraints) | 0 |
| 추가상품(addons) | 0 |
| 셋트구성(sets) | 0 |

CPQ 손님 선택축(옵션그룹/항목)·제약·추가상품(봉투 addon)·셋트 구성 **전부 미구성**. 형제 016(옵션그룹 7·봉투 addon 5)과
대비된다 — 미출시(use_yn=N) 상태와 정합. `has_option_group`·`has_addon`·`has_member` 엣지는 대상 행이 없어 배선 없음
(끊긴 링크 아님·라이브 실측 0). 손님이 금/은 별색·용지를 고를 UI 축도 없다.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_022.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000022 @ 2026-07-03 -->
| frm_cd | note |
|---|---|
| PRF_DGP_A | 금은별색엽서 → PRF_DGP_A (use_yn=N 미출시) |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형·10구성요소 배선). 구성요소 사슬:
디지털인쇄비(COMP_PRINT_DIGITAL_S1·PROC_000004 매칭=작동)+**별색인쇄비(COMP_PRINT_SPOT_WHITE_S1·PROC_000007
공정 요구=미배선→미작동)**+용지비(COMP_PAPER·plt_siz×mat)+귀돌이/오시/미싱/가변/코팅. 즉 **공식(그릇)은 연결되나,
정체 기능(별색) 몫의 가격은 상품 공정 미배선으로 흐르지 않는다**. 값 계산은 evaluate_price(D-18 경계).

---

## 이 상품 전용 하위 노드 (qty·gap)

### [qty-022] 금은별색엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000022
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000022 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 12/10000/12)", bdl_unit_typ_cd: "QTY_UNIT.02", size_override: "없음(사이즈별 min/incr 공백)", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12). 사이즈별 override 없음. t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈·[[rule/decisions#DEC_qty_audit_260702]]).

### [gap-022-spotcolor-unwired] 정체 기능(금/은 별색)의 별색인쇄 공정 미배선 → 가격 미기여 {unknown}
- type: gap
- anchor: none  # 사유: 상품 정체(금은별색)가 요구하는 별색인쇄 공정(PROC_000007)이 라이브 활성 공정에 없음 — 원천이 "왜 미배선인지"를 못박지 못함(미출시 의도인지 결함인지 미상)
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000022 활성 1행(PROC_000004만)·PROC_000007 부재(del 포함 전수)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:PRF_DGP_A COMP_PRINT_SPOT_WHITE_S1 use_dims proc_grp:PROC_000007", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "금은별색엽서(PRD_000022)의 정의 기능인 금/은 별색이 가격에 기여하지 못함 — PRF_DGP_A는 별색인쇄비 구성요소(COMP_PRINT_SPOT_WHITE_S1·proc_grp PROC_000007)를 포함하나 상품은 별색인쇄 공정(PROC_000007)을 배선하지 않아 별색 단가행이 매칭 안 됨(공정 PROC_000004 base 1행뿐). 손님이 금/은을 고를 옵션그룹도 0행"
- gap_fill_from: "실무진/설계 판정 — ① 미출시(use_yn=N) 의도된 미완성인가(발행 전 별색 공정+옵션 배선 예정) vs ② 발행 예정인데 별색 공정 누락 결함인가. 확정 후 별색인쇄 공정(PROC_000007) has_process 배선 + 별색 선택 옵션그룹 구성(형제 020 화이트인쇄 SPOT 발현 교정=배선 6~7세션 선례)"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000007, note: "배선돼야 할 별색인쇄 공정(축 노드는 존재·상품 미배선)"}
- rel: {rel: references, target: formula-PRF_DGP_A, note: "별색인쇄비 구성요소를 담은 공식(그릇은 연결·공정 키 미충족)"}
- 본문: 값·구조는 아는데(공식은 별색 구성요소 보유·별색 공정 축 노드도 존재) **상품 공정 배선이 없어** 정체 기능의 가격 경로가 끊긴 상태. 미출시(use_yn=N)와 함께 "불완전 등록"의 핵심 증거. 조용한 누락 대신 정직 선언(형제 020 화이트인쇄 인쇄옵션 0건→SPOT 발현 교정과 동류 패턴·배선 HANDOFF round22). 해소 판정은 실무진 의도 확인 후(검증가/다음 라운드).

### [GAP_022_material] 022 활성자재 3종 중 2종 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: 2자재(몽블랑190g·아코팩)는 live-snapshot 실재·BOM 전사표 권위이나 공유 axis/materials 미민팅이라 uses_material 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000022 활성 3행 중 2종(MAT_000107 몽블랑190g·MAT_000113 아코팩)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "022 활성자재 3종 중 2종(MAT_000107 몽블랑190g·MAT_000113 아코팩)이 공유 [[axis/materials]]에 미민팅 — uses_material은 축 노드가 있는 1종(MAT_000109 몽블랑240g)만 배선. BOM 전사표가 권위이나 그래프 탐색 시 2종 침묵 누락"
- gap_fill_from: "architect 파일럿 완전성 정책 — 공유 axis/materials에 MAT_000107·MAT_000113 mint(needed_shared_nodes로 반환). 후 022 uses_material 1→3 확장"
- gap_owner: 설계
- rel: {rel: references, target: material-MAT_000109, note: "대표 배선 축 노드(같은 022 종이 슬롯)"}
- 본문: 값은 아는데(live·BOM 전사) 공유 축 노드가 1종만이라 그래프 배선이 부분적인 KB 커버리지 공백. 형제 016 GAP_016_material과 동류. 채움=축 mint(needed_shared_nodes 반환·통합 단계 일괄 mint).
