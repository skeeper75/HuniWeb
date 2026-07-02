---
id: product-038-emboss-namecard
type: product
anchor: t_prd_products/PRD_000038
badge: candidate
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000038", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "문서:§3.1 정체(명함)·§3.3 도수=printopt·§3.8 판형", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용·라이브 2행)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y·disp_seq 8)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N)"}
  # 차원 — 사이즈 (R2 has_size — 명함 사이즈 1종만·공유 축 승격노드 재사용)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm(dflt_yn=Y)·라이브 1행뿐(032/033은 2종·86x52 SIZ_000133 미바인딩)"}
  # 도수·인쇄방식 (R4 has_print_option — 공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도 CLR_000005·back 인쇄안함 CLR_000001)"}
  - {rel: has_print_option, target: printopt-POPT_000002, note: "양면(front/back CMYK 4도 CLR_000005)"}
  # 공정 (R5 has_process — 모서리 2종만 mand_proc_yn=N·공유 축 재사용. ★형압 PROC_000050 미바인딩=GAP)
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각(모서리·default 재단)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근(모서리 라운딩)"}
  # 판형 (R6 has_plate_size — 종이류·국전계열·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "SIZ_000499 출력용지·OUTPUT_PAPER_TYPE.01(dflt_plt_yn=Y)"}
  # 가격 경로 부재 → GAP 정직 선언(O5 예외=derived_from gap 연결)
  - {rel: derived_from, target: gap-038-no-price-path, note: "priced_by 미배선(t_prd_product_price_formulas 0행)→견적 0. 가격사슬 부재를 GAP으로 정직 선언(O5 gap 연결 예외)"}
  # 정의적 특징(형압)·스켈레톤 바인딩 공백 GAP (서술 참조)
  - {rel: references, target: gap-038-emboss-unbound, note: "형압 공정 PROC_000050 마스터 실재하나 038 미바인딩(정의적 특징 부재)"}
  - {rel: references, target: gap-038-skeleton-bindings, note: "자재 0행·옵션그룹 0행 스켈레톤 바인딩 공백"}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모 미등록·SOT §1)
  use_yn: N                          # ★미출시/비활성(라이브 use_yn=N·8 완주상품과 대비되는 핵심 상태·src SR-5-livesnap)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  del_yn: N
  archetype_price: "미정(공식 미배선)"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). t_prd_product_bundle_qtys 0행·사이즈 수량규칙 공란(정상·GAP 아님)"
  binding_summary: "sizes1·materials0·print_options2·processes2·plate1·formula0·option_groups0·addons0·constraints0·categories2(전사=cache/transcribed-038-260703.json)"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3]
tags: [디지털인쇄, 명함, 형압, 미출시, 스켈레톤]
updated: 2026-07-03
---

# 상품: 형압명함 (PRD_000038)

형압명함은 명함 카테고리(CAT_000313)의 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·
SOT §1: 완제품=셋트 아닌 단일 제조상품·`t_prd_product_sets` 부모 미등록). 코팅명함(032)·
스탠다드명함(033)의 형제 상품이나, 라이브 바인딩은 **스켈레톤**이다 — 사이즈 1종·도수 단/양면·
모서리 공정 2종·국전 판형만 실려 있고 **자재·가격공식·CPQ 옵션그룹이 전부 0행**이며 상품 자체가
**`use_yn=N`(미출시/비활성)**이다. 파일 업로드형(`file_upload_yn=Y`·`editor_yn=N`)·수량규칙은
상품 스칼라(min/max/incr·단위 QTY_UNIT.02 "매")로 아래 전사표 참조.

**★badge=candidate 사유(정직 선언):** 위 정체·바인딩·"무엇이 비었나"는 전부 라이브 스냅샷
20260702_1119에서 결정론 스크립트로 전사한 **verified 사실**이나, 상품이 `use_yn=N`(미출시)이고
가격·자재·옵션 경로가 미완이라 "완성된 판매 상품"으로 verified 승급하지 않는다. 완주 8상품과
구분되는 provisional 상태를 badge로 표기한다. 미완 경로는 아래 GAP 노드로 정직 노출한다.

**정의적 특징(형압) 부재:** 상품명이 "형압명함"이나 라이브 공정 바인딩은 모서리(직각/둥근)뿐이고
**형압 공정(PROC_000050 embossing)이 없다** — 마스터 `t_proc_processes`에는 PROC_000050 형압이
실재(`use_yn=Y`)하나 038에 미바인딩. 정체와 바인딩의 불일치를 [[#gap-038-emboss-unbound]]로 선언한다.

**가격 경계(D-18):** 온톨로지는 상품→공식→구성요소→차원(use_dims)까지만 모델링하고 값 계산은
`evaluate_price` 단일 권위다([[rule/rules#RULE_price_value_boundary]]). 038은 애초에 `priced_by`
공식이 없어 그 경계에 도달조차 못 한다(가격사슬 부재·[[#gap-038-no-price-path]]).

## 상품 스칼라 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000038 @ 2026-07-03 -->
| prd_nm | prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | use_yn | del_yn |
|---|---|---|---|---|---|---|---|
| 형압명함 | PRD_TYPE.01 | 100 | 10000 | 100 | QTY_UNIT.02 | N | N |

> 수량규칙은 **상품 레벨 스칼라**(min100/max10000/incr100·단위 QTY_UNIT.02 "매")로만 실린다.
> `t_prd_product_bundle_qtys` 0행·사이즈 수량규칙 공란 → 별도 `bundle_qty` 노드(E8) 미생성·
> `has_qty_rule` 엣지 없음(정상·팩 §3.4: bundle_qtys 0행이 곧 미적재를 뜻하지 않음).

## 사이즈 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 |

> 명함 사이즈 SIZ_000008(90x50)은 **공유 축 노드**([[axis/sizes#size-SIZ_000008]]·032/033 승격 260703)로
> 재사용한다(중복 정의 금지 [HARD]·has_size 엣지가 축 노드로 resolve). 038은 라이브에 **1행만**
> 바인딩(dflt_yn=Y) — 032/033이 갖는 86x52(SIZ_000133)는 미바인딩. 판걸이수(UP수)는 사이즈 컬럼이
> 아니라 파생값(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

## 도수(인쇄옵션)·색상수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| opt_id | print_opt_cd | 면 | 앞면 색상수 | 뒷면 색상수 |
|---|---|---|---|---|
| 1 | POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |
| 2 | POPT_000002 | 양면 | CMYK 4도 | CMYK 4도 |

> 도수 = 인쇄옵션 코드(`print_opt_cd`)이지 색상코드가 아니다([[rule/rules#RULE_dosu_is_printopt]]·
> T-4 함정). 앞/뒷면 색상수(CLR_000005 CMYK 4도·CLR_000001 인쇄안함)는 도수 코드의 세부이지
> clr_cd 8차원 인코딩이 아니다. 공유 축 노드 [[axis/print-options#printopt-POPT_000001]]/002 재사용.

## 공정 (모서리만·형압 부재)

038 후가공 바인딩 = 모서리 공정 2종뿐이다(전부 `mand_proc_yn=N`·공유 축 재사용):
- [[axis/processes#process-PROC_000027]] 직각(귀돌이 PROC_000026 자식·default 재단)
- [[axis/processes#process-PROC_000028]] 둥근(귀돌이 자식·R 라운딩)

**형압 공정은 없다**(정의적 특징 부재) — 상세는 [[#gap-038-emboss-unbound]]. 별색·박·코팅 등
다른 후가공도 바인딩 0(스켈레톤).

## 판형 (종이류·국전계열)

038은 종이 명함이므로 판형이 유효하다([[rule/rules#RULE_plate_paper_only]]). 라이브 판형 =
[[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]] 국전계열(출력용지 SIZ_000499·OUTPUT_PAPER_TYPE.01·
`dflt_plt_yn=Y`). 고객은 판형을 안 고르고 `fn_best_plate`가 판수>0 연결을 자동선택한다.

## 바인딩 행수 (전사 — 무엇이 비었나)

<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_* @ 2026-07-03 -->
| 바인딩 테이블 | 행수 |
|---|---|
| sizes | 1 |
| materials | 0 |
| print_options | 2 |
| processes | 2 |
| plate_sizes | 1 |
| bundle_qtys | 0 |
| addons | 0 |
| constraints | 0 |
| price_formulas | 0 |
| categories | 2 |
| option_groups | 0 |
| option_items | 0 |
| options | 0 |
| page_rules | 0 |

> 이 행수 표가 038의 핵심 지식이다 — **materials 0·price_formulas 0·option_groups 0**이 끊긴
> 경로의 원천이며, 아래 GAP 노드로 각각 선언한다(지어내지 않고 "비었음"을 등재).

## 끊긴 경로·미해결 (GAP — 정직 선언)

### [gap-038-no-price-path] 가격공식 미배선 → 견적 0 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_price_formulas에 PRD_000038 행 0(공식 미배선·앵커할 대상 부재)
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:PRD_000038 (0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.10 가격공식·§3.11 단가행 존재≠배선완료", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "형압명함(038)은 priced_by 공식이 0행 — 가격사슬(상품→공식→구성요소→차원)이 시작조차 못 함. 032/033은 PRF_NAMECARD_COAT/FIXED 고정가로 배선됐으나 038은 명함 고정가 공식(또는 형압 가산 공식)이 미배선·미설계. 단가행 존재 여부와 무관하게 배선 없으면 견적 0([[rule/rules#RULE_dataline_neq_wiring]])"
- gap_fill_from: "가격엔진 설계(§18 huni-price-engine-design) — 명함 고정가 공식 재사용/신설 + 형압 가산 구성요소 설계 후 배선(실 COMMIT은 인간 승인 후 §7 dbmap). 권위 = 상품마스터 260702 명함/형압 가격표(팩에 형압명함 셀 원천 미지목 → 권위 셀 확보 선행)"
- gap_owner: 설계
- rel: {rel: references, target: product-038-emboss-namecard, note: "이 상품의 가격사슬 부재"}

### [gap-038-emboss-unbound] 형압 공정 PROC_000050 미바인딩 (정의적 특징 부재) {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_processes에 PRD_000038↔PROC_000050 행 없음(공정은 마스터 실재하나 상품 미바인딩)
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "키:PROC_000050(proc_nm:형압·note:embossing·use_yn=Y) — 마스터 실재", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "키:PRD_000038 (PROC_000027/028만·PROC_000050 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "상품명 '형압명함'의 정의적 특징인 형압(embossing) 공정 PROC_000050이 마스터 t_proc_processes에는 실재(use_yn=Y·inputs 크기/mm)하나 038에 has_process 바인딩되지 않음 — 정체와 바인딩 불일치. 형압 없는 형압명함은 스탠다드명함(033)과 구분 불가"
- gap_fill_from: "실무진 확인 + 상품 재구축 — PROC_000050 형압을 038에 바인딩(옵션/공정)하고 형압 가산 가격구성요소 설계(gap-038-no-price-path와 연동). 형압 공정 축 노드(process-PROC_000050)는 공유 axis/processes.md에 미민팅 → needed_shared_nodes로 반환(통합 단계 mint)"
- gap_owner: staff
- rel: {rel: references, target: product-038-emboss-namecard, note: "이 상품의 정의적 특징 미바인딩"}

### [gap-038-skeleton-bindings] 자재 0·옵션그룹 0 스켈레톤 바인딩 공백 {unknown}
- type: gap
- anchor: none  # 사유: t_prd_product_materials·t_prd_product_option_groups에 PRD_000038 행 0(바인딩 대상 부재)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:PRD_000038 (0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "키:PRD_000038 (0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "038은 자재(용지) 바인딩 0행·CPQ 옵션그룹 0행 — 명함인데 종이가 없고, 032/033이 갖는 손님 선택축(인쇄/종이/모서리 옵션그룹)이 없다. 자재는 명함 고정가 use_dims(mat_cd)의 차원이므로 가격 미완과도 직결. ★[HARD] 자재를 나중에 IMPORT로 채울 갭이지 '삭제 대상' 아님([[rule/rules#RULE_import_material_no_delete]])"
- gap_fill_from: "상품 재구축 — 명함 용지(아트지/스노우 등 USAGE.07)·옵션그룹(§7 dbmap CPQ 매핑) 바인딩. 권위 = 상품마스터 260702 형압명함 행(팩 미지목 → 권위 셀 확보 선행). 실 COMMIT 인간 승인"
- gap_owner: 설계
- rel: {rel: references, target: product-038-emboss-namecard, note: "이 상품의 스켈레톤 바인딩 공백"}

## 정상(GAP 아님) 확인

- **수량규칙 노드 부재**: `t_prd_product_bundle_qtys` 0행 → 상품 스칼라(min/max/incr)로만 표현(정상).
- **제약규칙 없음**: `t_prd_product_constraints` 0행 → 별도 교차제약 불요(정상·옵션그룹도 0이라 제약 대상 없음).
- **추가상품 없음**: `t_prd_product_addons` 0행 → `has_addon` 없음(정상·명함 addon 미보유).
- **페이지룰 없음**: `t_prd_product_page_rules` 0행(낱장 명함·정상).

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): `t_prd_products`(PRD_000038 정체·use_yn=N·수량)·
  `t_prd_product_sizes`(SIZ_000008 1행)·`t_prd_product_print_options`(POPT_000001/002)·
  `t_prd_product_processes`(PROC_000027/028 mand=N)·`t_prd_product_plate_sizes`(SIZ_000499 국전)·
  `t_prd_product_categories`(CAT_000003 main/CAT_000313)·`t_prd_product_materials`(0행)·
  `t_prd_product_price_formulas`(0행)·`t_prd_product_option_groups/options/option_items`(0행)·
  `t_prd_product_bundle_qtys/addons/constraints/page_rules`(0행)·`t_proc_processes`(PROC_000050 형압 마스터 실재)·
  `t_clr_color_counts`(CLR_000005/000001). 전사=`_meta/scripts/transcribe_product_038.py`(cache/transcribed-038-260703.json).
- `_workspace/huni-ontology-kb/01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd)·
  §3.8(판형 종이류·fn_best_plate)·§3.10(가격공식)·§3.11(단가행≠배선).
- 공유 축·규칙 노드: `axis/sizes.md`(SIZ_000008)·`axis/print-options.md`·`axis/processes.md`(PROC_000027/028)·
  `axis/plate-sizes.md`·`axis/categories.md`(CAT_000003/313)·`rule/rules.md`(RULE_price_value_boundary·
  RULE_dosu_is_printopt·RULE_plate_paper_only·RULE_pansu_db_function·RULE_dataline_neq_wiring·RULE_import_material_no_delete).
