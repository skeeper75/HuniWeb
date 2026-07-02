---
id: product-039-transparent-namecard
type: product
anchor: t_prd_products/PRD_000039
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000039 (del_yn=N·투명명함)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.1 정체(명함=인쇄홍보물)·§3.3 도수·§3.10 가격공식·worklist 명함행 PRF_NAMECARD_CLEAR", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/worklist-digitalprint-remaining.md", source_locator: "§1 명함(8) — PRD_000039 투명명함 PRF_NAMECARD_CLEAR", captured_at: "2026-07-03", badge: verified, src_id: SR-worklist-dp}
relations:
  # 정체·분류 (R1 in_category — 공유 축 재사용)
  - {rel: in_category, target: category-CAT_000003, note: "인쇄홍보물(주·main_cat_yn=Y·disp_seq 9)"}
  - {rel: in_category, target: category-CAT_000313, note: "명함(부·main_cat_yn=N·상위 CAT_000003)"}
  # 차원 — 사이즈 (R2 has_size — 명함 기본 사이즈 1종·공유 축 재사용)
  - {rel: has_size, target: size-SIZ_000008, note: "90x50mm(명함 기본·단일 사이즈)"}
  # 자재 (R3 uses_material — MAT_000178 PET·공유 axis/materials 미민팅→needed_shared_nodes)
  - {rel: uses_material, target: material-MAT_000178, note: "PET(MAT_TYPE.08)·USAGE.07 dflt·활성 단일 자재. 공유 축 미민팅(mint 대기)"}
  # 도수·인쇄방식 (R4 has_print_option — 단면만·공유 축·도수=print_opt_cd)
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(front CMYK 4도 CLR_000005·back 인쇄안함 CLR_000001)·양면 없음"}
  # 공정 (R5 has_process — 모서리 후가공 2종·모두 mand_proc_yn=N·공유 축 재사용)
  - {rel: has_process, target: process-PROC_000027, qualifier: {mand: N}, note: "직각 모서리(default 재단·귀돌이 PROC_000026 자식)"}
  - {rel: has_process, target: process-PROC_000028, qualifier: {mand: N}, note: "둥근 모서리(R 라운딩·귀돌이 PROC_000026 자식)"}
  # 판형 (R6 has_plate_size — 출력용지 국전계열·투명소재 전지·fn_best_plate 자동선택)
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "출력용지 국전계열(SIZ_000522 315x467 투명소재 전지·OUTPUT_PAPER_TYPE.01)·fn_best_plate 자동선택"}
  # 가격 (R8 priced_by — 투명명함 전용 고정가·자재무관·단면만·공유 formula 미민팅→needed_shared_nodes)
  - {rel: priced_by, target: formula-PRF_NAMECARD_CLEAR, note: "투명명함 수량별 단가(용지포함)·자재무관 동일가·단면 CLEAR_S1 단독. mint 대기"}
  # 미해결 참조 (R19 references — GAP)
  - {rel: references, target: gap-039-white-print-absent, note: "투명 소재이나 화이트인쇄 공정/구성요소 미보유(019·025 형제와 대비)"}
props:
  prd_typ_cd: PRD_TYPE.01            # 완제품 단일(셋트 아님·t_prd_product_sets 부모/구성원 미등록)
  min_qty: 100                       # src SR-5-livesnap(상품 스칼라 수량규칙)
  max_qty: 10000
  qty_incr: 100
  qty_unit_typ_cd: QTY_UNIT.02       # "매"
  file_upload_yn: Y
  editor_yn: N
  archetype_price: "고정가(용지포함·자재무관·단면 단독)"
  use_dims_note: "가격 차원=수량(min_qty)만 — 자재 무관·단면만(양면 없음). 값 계산=evaluate_price 권위(D-18)"
  qty_rule_note: "수량규칙=상품 스칼라(min100/max10000/incr100). t_prd_product_bundle_qtys 0행·사이즈 수량규칙 공란"
standards: {schema_org: Product, xjdf: "Product(명함)", config_ont: "component type"}
answers_cq: [S2, S3, "투명 소재 인쇄물(조건 탐색)"]
tags: [디지털인쇄, 명함, 투명PET, 고정가]
updated: 2026-07-03
---

# 상품: 투명명함 (PRD_000039)

투명명함은 디지털인쇄 **완제품 단일**(`prd_typ_cd=PRD_TYPE.01`·[[product-type-classification-sot]]
준수 — 셋트 부모/구성원 아님·기성/디자인 아님). 명함 카테고리([[axis/categories#category-CAT_000313]]
명함·주 분류 [[axis/categories#category-CAT_000003]] 인쇄홍보물)의 **투명 PET 소재 변형** 명함이다.
불투명 아트지에 인쇄하는 형제 [[product-033-standard-namecard]](스탠다드명함)·[[product-032-coated-namecard]]
(코팅명함)와 달리, **투명 PET 낱장에 단면 칼라(CMYK 4도)만** 인쇄한다. 파일 업로드형(`file_upload_yn=Y`·
`editor_yn=N`). 최소 100매·100매 증분·최대 10,000매(QTY_UNIT.02 "매"). <!-- lint-allow: L-12 src=SR-5-livesnap 수량스칼라 -->

수량 스칼라(min/max/incr)는 전사표가 권위이며 위 산문 수치는 그 요약이다.

- **가격 아키타입 = 고정가(용지포함·자재무관·단면 단독)** — 원자합산형(엽서 PRF_DGP_A)이나 다른 명함
  고정가(PRF_NAMECARD_FIXED/COAT)와 별개로, **투명명함 전용 고정가 공식**
  [[formula/digital-formulas#formula-PRF_NAMECARD_CLEAR]](PRF_NAMECARD_CLEAR)로 계산한다. 라이브 공식
  note = "자재 무관 동일가·단면만 존재"(가격표260527 B05 앵커). 즉 **가격 차원(use_dims)은 수량(min_qty)만**
  — 자재·도수(단면 고정)·모서리는 가격 축이 아니다. 값 계산은 `evaluate_price` 단일 권위
  ([[rule/rules#RULE_price_value_boundary]]) — 온톨로지는 연결까지만(D-18). 골든 스냅샷=live 20260702_1119(값 미기록).
- **도수=인쇄옵션**(색상코드 아님·[[axis/print-options#printopt-POPT_000001]]·[[rule/rules#RULE_dosu_is_printopt]]).
  투명명함은 **단면(POPT_000001)만** 제공(양면 POPT_000002 없음·투명 낱장 특성).
- **판형**: 라이브가 국전계열 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]]·활성 전지 SIZ_000522
  315x467 "투명소재 전지")를 등록·`fn_best_plate` 자동선택([[rule/rules#RULE_pansu_db_function]]). ★PET는
  종이류가 아니라 [[rule/rules#RULE_plate_paper_only]]와 긴장 관계 — 여기서는 relitigate 없이 **라이브 현재값만**
  기록(형제 025 투명포토카드 동일 처리).

## 가격 경로 연결 확인 (priced_by → 공식 → 구성요소)

`priced_by` → [[formula/digital-formulas#formula-PRF_NAMECARD_CLEAR]] → `has_component` →
[[formula/digital-components#component-COMP_NAMECARD_CLEAR_S1]](투명명함 완제품가 단면·용지포함)로
**라이브에서 배선 완료**(t_prc_formula_components 1행·addtn_yn=Y·아래 전사표 권위). 즉 가격 사슬이
끊기지 않았다(O5/O6 충족). 다만 공식 노드(PRF_NAMECARD_CLEAR)·구성요소 노드(COMP_NAMECARD_CLEAR_S1)가
공유 `formula/` 파일에 **아직 미민팅** → priced_by/has_component 그래프 배선은 **통합 단계 mint 대기**
(needed_shared_nodes 반환·형제 025 PRF_PHOTOCARD_CLEAR 동일 패턴). 값은 아래 전사표가 권위.

## 상품 요소 전사 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_039.py`가 live-snapshot에서 결정론 전사(사람 손전사
> 아님·D-9). 원천=`_workspace/_foundation/live-snapshot/latest`(snap_20260702_1119).

#### 정체·수량

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000039 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 100 | 10000 | 100 | QTY_UNIT.02 | Y | N | Y |

#### 카테고리

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000039 @ 2026-07-03 -->
| cat_cd | 분류명 | main_cat | lvl |
|---|---|---|---|
| CAT_000003 | 인쇄홍보물 | Y | 1 |
| CAT_000313 | 명함 | N | 2 |

#### 사이즈

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000039 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt |
|---|---|---|---|---|
| SIZ_000008 | 90x50mm | 92.00x52.00 | 90.00x50.00 | Y |

사이즈 **단일 1종**(90×50mm·명함 기본). 형제 032/033은 2종(90×50·86×52)이나 투명명함은 90×50만 등록.
치수(작업/재단)는 공유 [[axis/sizes#size-SIZ_000008]] 축 노드 권위. 전 1행 `has_size`로 연결.

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000039 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 100 | 10000 | 100 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). `t_prd_product_bundle_qtys`
0행은 정상(팩 §3.4 STALE 함정 회피). 별도 `bundle_qty` 노드(E8) 미생성·`has_qty_rule` 엣지 없음(정상·명함 baseline과 동일).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (전 행·del 표기) PRD_000039 @ 2026-07-03 -->
전 1행 (활성 1행) · usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | mat_typ | usage | dflt | del | 축노드 |
|---|---|---|---|---|---|---|
| MAT_000178 | PET | MAT_TYPE.08 | USAGE.07 | Y | N | X(미민팅) |

활성 자재 **1종**(MAT_000178 "PET"·MAT_TYPE.08). ★관찰: 형제 019 투명엽서·025 투명포토카드는 MAT_000144/147
(투명/반투명 PET 260g·MAT_TYPE.01)을 쓰는 반면, 투명명함은 **평량·규격 없는 bare "PET"(MAT_TYPE.08) 단일 슬롯**을
등록했다(자재축 명세 상이·현재값 그대로 기록·판정은 검증 레인). 가격은 "자재 무관 동일가"라 자재 선택이 가격에
영향하지 않는다. 공유 [[axis/materials]] 미민팅(종이 용지 대표만 보유·PET 미보유)이라 `uses_material` 그래프 배선은
mint 대기(needed_shared_nodes 반환·값은 이 BOM 표가 권위). ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000039 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 proc | mand | 축노드 |
|---|---|---|---|---|
| PROC_000027 | 직각 | PROC_000026 | N | O |
| PROC_000028 | 둥근 | PROC_000026 | N | O |

공정 **2행(직각/둥근 모서리·둘 다 mand_proc_yn=N 선택 후가공)**. 공유 [[axis/processes#process-PROC_000027]]·
[[axis/processes#process-PROC_000028]] 축 노드 실재→`has_process` 배선. ★관찰: 형제 019 투명엽서·025 투명포토카드는
**디지털인쇄 base(PROC_000004)·화이트인쇄(PROC_000008)** 공정을 갖지만, 투명명함은 **둘 다 미보유**(모서리 공정만).
고정가 공식(PRF_NAMECARD_CLEAR·용지포함)이 인쇄비를 내부에 접었기 때문일 수 있으나, 화이트인쇄 부재는 투명 소재
특성상 정직 선언 대상 → [[#gap-039-white-print-absent]].

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (전 행·del 표기) PRD_000039 @ 2026-07-03 -->
| siz_cd | 규격(전지) | output_paper_typ_cd | note | del |
|---|---|---|---|---|
| SIZ_000522 | 315.00x467.00 | OUTPUT_PAPER_TYPE.01 |  | N |
| SIZ_000144 | 92.00x52.00 | OUTPUT_PAPER_TYPE.03 | 파일사양 | Y |

`has_plate_size`는 활성 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]]·SIZ_000522 "투명소재 전지"
315×467·OUTPUT_PAPER_TYPE.01)로 배선. 판형=종이류만·고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·
[[rule/rules#RULE_pansu_db_function]]). SIZ_000144(파일사양 PDF(W)·OUTPUT_PAPER_TYPE.03)는 2026-06-30 논리삭제(del_yn=Y)—현재값 아님.

#### 인쇄옵션

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options+t_clr_color_counts PRD_000039 @ 2026-07-03 -->
| print_opt_cd | 라벨 | print_side | 앞도수 | 뒷도수 |
|---|---|---|---|---|
| POPT_000001 | 단면 | 단면 | CMYK 4도 | 인쇄 안 함 |

인쇄옵션 **단면 1행만**(POPT_000001·앞 CMYK 4도 CLR_000005·뒷면 인쇄안함 CLR_000001). 양면(POPT_000002) 없음—투명 낱장
단면 특성(형제 019/025와 동일). `has_print_option`→[[axis/print-options#printopt-POPT_000001]]. 도수=인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]).

#### 옵션그룹 / 제약 / 추가상품

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000039 @ 2026-07-03 -->
활성 옵션그룹 0행 (없음 — CPQ 옵션 레이어 미구성)

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000039 @ 2026-07-03 -->
활성 제약 0행 (없음)

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons PRD_000039 @ 2026-07-03 -->
추가상품 0행 (없음)

투명명함은 **CPQ 옵션그룹 0행**(형제 032/033/025의 인쇄/종이/모서리 옵션그룹 없음)·제약 0행·추가상품 0행이다.
손님 선택 축(사이즈 1종·단면 고정·자재 1종)이 사실상 단일값이라 옵션 레이어가 미구성된 상태(`has_option_group`·
`constrains`·`has_addon` 엣지 없음·정상·오누락 아님). 모서리(직각/둥근)는 옵션그룹 없이 `has_process`(mand=N)로만 표현된다.

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000039 @ 2026-07-03 -->
| frm_cd | apply_bgn | note |
|---|---|---|
| PRF_NAMECARD_CLEAR | 2026-06-27 | namecard-special: 투명명함 CLEAR_S1. 단면만·자재무관. (고정단가·값은 evaluate_price 권위) |

<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_formulas+t_prc_formula_components (배선) PRD_000039 @ 2026-07-03 -->
공식 PRF_NAMECARD_CLEAR = 투명명함 수량별 단가(용지포함) (use_yn=Y)

| comp_cd | disp_seq | addtn |
|---|---|---|
| COMP_NAMECARD_CLEAR_S1 | 1 | Y |

`priced_by`→[[formula/digital-formulas#formula-PRF_NAMECARD_CLEAR]](고정가). 구성요소 1종
COMP_NAMECARD_CLEAR_S1(단면 완제품가·용지포함)이 addtn_yn=Y로 배선(라이브 t_prc_formula_components 1행). 값 계산은
evaluate_price(D-18 경계). 공식/구성요소 노드는 공유 formula 파일 미민팅→통합 단계 mint 대기(needed_shared_nodes).

## 이 상품 전용 하위 노드 (gap)

### [gap-039-white-print-absent] 투명 소재이나 화이트인쇄 공정/구성요소 미보유 {unknown}
- type: gap
- anchor: none  # 사유: 투명명함에 화이트인쇄(PROC_000008·백색 별색) 공정 행·가격 구성요소가 라이브에 없음(존재 부재는 스냅샷 실측·의도/누락 판정 원천 없음)
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000039 공정 2행(PROC_000027/028 모서리만)·PROC_000008 부재", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 별색=공정(화이트인쇄=투명 소재 밑판)·§3.6 proc 이원화", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "투명명함(PRD_000039)은 투명 PET 소재인데 화이트인쇄(흰토너 밑판·PROC_000008·상위 proc_grp PROC_000007 별색) 공정 행도, 가격 구성요소(예 COMP_PRINT_SPOT_WHITE_S1)도 라이브에 없다. 형제 019 투명엽서는 화이트인쇄 mand 공정, 025 투명포토카드는 화이트인쇄 공정+옵션을 갖는다. 고정가 PRF_NAMECARD_CLEAR(용지포함·자재무관)에 백색 밑판 인쇄가 접혀 있는지(의도) 아니면 공정 배선 누락인지 원천으로 판정 불가"
- gap_fill_from: "실무진 확인(투명명함 제작 시 화이트 밑판 유무) + 형제 019/025 화이트인쇄 모델 대조. 견적/제작 정합 문제이므로 검증 레인·§31/§27 라우팅"
- gap_owner: staff
- 본문: 투명 소재의 핵심 차별 요소(백색 밑판)가 투명명함에는 공정·가격 양쪽에 없다. 형제 019/025는 보유·투명명함은 미보유라는 사실을 지어내지 않고 정직 선언한다(현재값=미보유). 가격 경로 자체는 PRF_NAMECARD_CLEAR로 끊기지 않으나, 투명 인쇄물 제작 정합상 화이트 처리 여부는 확인 필요.

## 끊긴 경로·미해결 (정직 선언)

- **공유 축 미민팅(mint 대기)**: ① 자재 MAT_000178 "PET"(MAT_TYPE.08)가 공유 [[axis/materials]] 미보유 → `uses_material`
  그래프 배선 대기 ② 공식 PRF_NAMECARD_CLEAR·구성요소 COMP_NAMECARD_CLEAR_S1가 공유 [[formula/digital-formulas]]·
  [[formula/digital-components]] 미보유 → `priced_by`/`has_component` 배선 대기. 셋 다 **값은 위 전사표가 권위**이고
  통합 단계가 일괄 mint(needed_shared_nodes 반환·형제 025 동일 패턴). 지금은 결정론 빌드에서 끊긴 링크(I-2)로 나타나나
  통합 mint 후 해소되는 인터림 상태.
- **화이트인쇄 부재 GAP**: 위 [[#gap-039-white-print-absent]] — 투명 소재인데 백색 밑판 공정/가격 미보유(⚪).
- **CPQ 옵션 레이어 부재**: `t_prd_product_option_groups`/options/items 0행 → 옵션그룹·제약 노드 미생성. 손님 선택 축이
  단일값(사이즈 1·단면 고정·자재 1)이라 정상(오누락 아님·모서리는 has_process로 표현).
- **추가상품 없음**: `t_prd_product_addons` 0행 → `has_addon` 없음(정상).

## Sources
- live-snapshot 20260702_1119 실측(del_yn=N): `t_prd_products`(PRD_000039 정체·수량)·`t_prd_product_categories`(CAT_000003/313)·
  `t_prd_product_sizes`(SIZ_000008 1행)·`t_prd_product_materials`(MAT_000178 1행 USAGE.07)·`t_prd_product_print_options`(POPT_000001 단면)·
  `t_prd_product_processes`(PROC_000027/028 mand=N)·`t_prd_product_plate_sizes`(SIZ_000522 활성·SIZ_000144 del)·`t_prd_product_price_formulas`(PRF_NAMECARD_CLEAR)·
  `t_prc_formula_components`(PRF_NAMECARD_CLEAR→COMP_NAMECARD_CLEAR_S1 1행)·`t_prd_product_bundle_qtys`(0행)·`t_prd_product_option_groups`(0행)·`t_prd_product_constraints`(0행)·`t_prd_product_addons`(0행).
- `01_curation/pack-digital-print.md` §3.1(명함 정체)·§3.3(도수=print_opt_cd·별색=공정)·§3.10(가격공식)·§3.5(자재 USAGE.07). `01_curation/worklist-digitalprint-remaining.md` §1(명함 8·PRD_000039 PRF_NAMECARD_CLEAR).
- 공유 축·공식 노드(재사용): `axis/categories.md`(CAT_000003/313)·`axis/sizes.md`(SIZ_000008)·`axis/print-options.md`(POPT_000001)·`axis/processes.md`(PROC_000027/028)·`axis/plate-sizes.md`(OUTPUT_PAPER_TYPE_01)·`rule/rules.md`·`rule/decisions.md`(DEC_qty_audit_260702). 미민팅(needed_shared_nodes)=material-MAT_000178·formula-PRF_NAMECARD_CLEAR·component-COMP_NAMECARD_CLEAR_S1.
- 수치 전사: `_meta/scripts/transcribe_product_039.py`(정체·카테고리·사이즈·수량·자재·공정·판형·인쇄옵션·옵션/제약/추가상품·가격바인딩).
