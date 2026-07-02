---
id: product-019-transparent-postcard
type: product
anchor: t_prd_products/PRD_000019
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000019 (del_yn=N·투명엽서)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 도수(별색=공정)·§3.8 판형(019 자재종속 C트랙)·§4-E 잔여", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-dp}
  - {source_file: "_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md", source_locator: "§0 distinct 36표 투명엽서 (round-13 승계·재검증 2026-07-03)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-identity}
relations:
  - {rel: in_category, target: category-CAT_000307, note: "엽서(depth 4·main_cat_yn=Y)"}
  - {rel: has_size, target: size-SIZ_000002, note: "98x98"}
  - {rel: has_size, target: size-SIZ_000003, note: "100x150"}
  - {rel: has_size, target: size-SIZ_000004, note: "135x135"}
  - {rel: has_size, target: size-SIZ_000007, note: "148x210"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(CMYK 앞·뒷면 인쇄안함)·양면 옵션 없음"}
  - {rel: has_process, target: process-PROC_000004, qualifier: mandatory, note: "디지털인쇄 base(mand·CMYK 인쇄비 원천·DEC_baseproc_260701)"}
  - {rel: has_process, target: process-PROC_000027, note: "직각 모서리(옵션·귀돌이 PROC_000026 자식)"}
  - {rel: has_process, target: process-PROC_000028, note: "둥근 모서리(옵션·귀돌이 R)"}
  - {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(SIZ_000499·종이류 fn_best_plate 자동선택)"}
  - {rel: has_qty_rule, target: qty-019}
  - {rel: priced_by, target: formula-PRF_DGP_A}
  - {rel: has_option_group, target: optgroup-019-print}
  - {rel: has_option_group, target: optgroup-019-material}
  - {rel: has_option_group, target: optgroup-019-white}
  - {rel: has_option_group, target: optgroup-019-corner}
  - {rel: references, target: GAP_transparent019_pansu, note: "자재종속 판걸이수 C트랙(공유 GAP)"}
  - {rel: references, target: DEC_spotwhite_260630, note: "화이트인쇄=통합별색 COMP_PRINT_SPOT_WHITE_S1"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  min_qty: 12
  qty_unit_typ_cd: "QTY_UNIT.02"
  file_upload_yn: "Y"
  editor_yn: "N"
  구분: "엽서(디지털인쇄 완제품 단일·투명 PET 소재)"
standards: {schema_org: "Product", xjdf: "Product(엽서)", config_ont: "component type"}
answers_cq: ["구체 상품 질의(투명엽서 구성·가격 축)", "투명/반투명 소재 인쇄물(조건 탐색)", "화이트인쇄 되는 상품"]
tags: ["#디지털인쇄", "#엽서", "#투명PET", "#화이트인쇄", "#원자합산형"]
updated: 2026-07-03
---

# 투명엽서 (product-019-transparent-postcard)

투명엽서(PRD_000019)는 **디지털인쇄 완제품 단일**(prd_typ_cd=PRD_TYPE.01·[[axis/categories#category-CAT_000307]]
엽서). 상품유형 분류 SOT 정합 = 셋트 부모 아님(`t_prd_product_sets` 미등록)·기성/디자인 아님(제조 상품).
형제 [[product-016-premium-postcard]](프리미엄엽서)와 같은 엽서·같은 원자합산형 공식
[[formula/digital-formulas#formula-PRF_DGP_A]](PRF_DGP_A)을 공유하지만, **소재가 투명/반투명 PET**라는 점에서
갈린다. 투명 소재는 CMYK만 얹으면 비쳐 보이므로 **화이트인쇄(흰토너 밑판)를 필수 공정으로 함께 태운다**
(PROC_000008 mand + CMYK PROC_000004 mand 공존·[[rule/decisions#DEC_baseproc_260701]]).

- **정체**: 팩 §3.3/§3.8 + round-13 정체표(FRESH) + live-snapshot(prd_cd 실재). 형제 016과 대비되는 "투명 소재 변형" 엽서.
- **차별 특성**: ① 소재=투명/반투명 PET 260g(MAT_TYPE.01·종이 아님) ② 인쇄=**단면만**(양면 옵션 없음) ③ **화이트인쇄** 필수 공정+옵션 ④ 사이즈 4행(016은 7행).
- **가격 경계(D-18)**: 이 노드는 상품→공식→구성요소→차원(use_dims)까지만 잇는다. 최종 가격 값은 견적기(evaluate_price).
- **가격 경로 연결 확인**: `priced_by`→PRF_DGP_A(✅ 실재·원자합산형 11구성요소 배선)→`has_component`→COMP_PRINT_DIGITAL_S1(CMYK)+
  COMP_PRINT_SPOT_WHITE_S1(화이트/별색)+COMP_PAPER(PET 용지비)+후가공. 끊긴 가격 사슬 아님(O5 충족).
- **7월 교정 계보**: base 공정 PROC_000004 미바인딩→인쇄비 0 대발견 18건 COMMIT에 **019(흰토너008+CMYK004) 포함**
  ([[rule/decisions#DEC_baseproc_260701]]) · 통합별색 COMP_PRINT_SPOT_WHITE_S1로 화이트인쇄 발현([[rule/decisions#DEC_spotwhite_260630]]).
- **끊긴 경로(정직 선언)**:
  - 투명/반투명 PET 자재(MAT_000144/147)가 공유 [[axis/materials]] 미민팅 → `uses_material` 배선 대기 → [[gap-019-material]].
  - 화이트인쇄 공정(PROC_000008)이 공유 [[axis/processes]] 미민팅 → `has_process`(화이트) 배선 대기 → [[gap-019-white-process]].
  - 자재종속 판걸이수(같은 사이즈라도 투명 PET면 판수 달라짐)=코드 결함 C트랙 → 공유 [[rule/gaps#GAP_transparent019_pansu]] 참조.

## 차원·BOM·연결 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_019.py`가 live-snapshot에서 결정론 전사(사람 손전사 아님).

#### 사이즈

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000019 @ 2026-07-03 -->
| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |
|---|---|---|---|---|---|
| SIZ_000002 | 98x98 | Y |  |  |  |
| SIZ_000003 | 100x150 | Y |  |  |  |
| SIZ_000004 | 135x135 | Y |  |  |  |
| SIZ_000007 | 148x210 | Y |  |  |  |

사이즈 **4행**(016 엽서 7행의 부분집합·투명 PET 재단 제약). 치수(작업/재단)는 [[axis/sizes]] 축 전사표 권위.
전 4행 `has_size`로 연결(위 relations).

#### 수량 규칙(상품/묶음)

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys PRD_000019 @ 2026-07-03 -->
| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |
|---|---|---|---|---|---|
| 상품 마스터 | 12 | 10000 | 12 | QTY_UNIT.02 | 상품 레벨 수량규칙 |
| t_prd_product_bundle_qtys | - | - | - | - | 행수 0 (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |

수량 UI 권위 = 상품/사이즈 수량규칙(가격구간과 역할 분리·[[rule/decisions#DEC_qty_audit_260702]]). min/incr **12**(016은 15)로
투명엽서 고유. `t_prd_product_bundle_qtys` 0행은 정상(팩 §3.4 STALE 함정 회피).

#### 자재 BOM

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (전 행·del 표기) PRD_000019 @ 2026-07-03 -->
전 3행 (활성 2행) · 전부 usage_cd 단일 슬롯(팩 §3.5)

| mat_cd | 자재명 | mat_typ | usage | dflt | del | 축노드 |
|---|---|---|---|---|---|---|
| MAT_000144 | 투명 PET 260g | MAT_TYPE.01 | USAGE.07 | Y | N | X(미민팅) |
| MAT_000178 | PET | MAT_TYPE.08 | USAGE.07 | Y | Y | X(미민팅) |
| MAT_000147 | 반투명 PET 260g | MAT_TYPE.01 | USAGE.07 | N | N | X(미민팅) |

활성 자재 **2종**(투명 PET 260g·반투명 PET 260g·둘 다 MAT_TYPE.01). MAT_000178(구 "PET"·MAT_TYPE.08)은 2026-06-29
논리삭제(del_yn=Y)돼 현재 유효 아님. 활성 2종은 공유 [[axis/materials]] 미민팅(대표는 종이 용지만)이라
`uses_material`·optgroup-019-material option_refs 배선 불가 → [[gap-019-material]]로 정직 선언(값은 위 BOM 표가 권위).
★IMPORT 시트 등록 자재는 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

#### 공정 라우트

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000019 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 proc_grp | mand | 축노드 |
|---|---|---|---|---|
| PROC_000004 | 디지털인쇄 | PROC_000001 | Y | O |
| PROC_000008 | 화이트인쇄 | PROC_000007 | Y | X(미민팅) |
| PROC_000027 | 직각 | PROC_000026 | N | O |
| PROC_000028 | 둥근 | PROC_000026 | N | O |

> 축노드 열은 KB 상태 주석(라이브 열=proc_cd/공정명/proc_grp/mand는 스크립트 전사·불변).

공정 4행 중 **mand 2행(디지털인쇄+화이트인쇄)**이 핵심. 화이트인쇄(PROC_000008·상위 proc_grp PROC_000007 별색)는
투명 소재의 밑판 흰 잉크로, 도수(clr_cd)가 아니라 **공정**으로 들어온다([[rule/rules#RULE_dosu_is_printopt]]·팩 §3.3
"별색=공정"). PROC_000004/027/028은 공유 [[axis/processes]] 축 노드 실재→`has_process` 배선; **PROC_000008만 미민팅**
→ 배선 대기([[gap-019-white-process]]). 가격측 화이트인쇄비=통합별색 [[formula/digital-components#component-COMP_PRINT_SPOT_WHITE_S1]]
(proc_grp PROC_000007·[[rule/decisions#DEC_spotwhite_260630]]).

#### 판형

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (전 행·del 표기) PRD_000019 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | item_siz_cd | 비고 | del |
|---|---|---|---|---|
| SIZ_000499 | OUTPUT_PAPER_TYPE.01 |  |  | N |
| SIZ_000113 | OUTPUT_PAPER_TYPE.03 |  | 파일사양 | Y |
| SIZ_000114 |  |  | 파일사양 | Y |
| SIZ_000115 |  |  | 파일사양 | Y |
| SIZ_000118 |  |  | 파일사양 | Y |

`has_plate_size`는 활성 국전 출력용지([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]]·SIZ_000499)로 배선. 판형=종이류만·
고객 미선택·fn_best_plate 자동선택([[rule/rules#RULE_plate_paper_only]]·[[rule/rules#RULE_pansu_db_function]]). SIZ_000113~118
"파일사양(PDF+W)" 4행은 2026-06-28 논리삭제(del_yn=Y·판형 오적재 정리)—현재값 아님. ★단, **판걸이수(UP수)는 투명 PET
자재에 종속**돼 2인자 `fn_calc_pansu`로는 못 푸는 코드 결함(C트랙)이 남는다 → [[rule/gaps#GAP_transparent019_pansu]].

#### 인쇄옵션

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_prt_print_options+t_clr_color_counts PRD_000019 @ 2026-07-03 -->
| print_opt_cd | 라벨 | print_side | 앞도수 | 뒷도수 |
|---|---|---|---|---|
| POPT_000001 | 단면 | 단면 | CMYK 4도 | 인쇄 안 함 |

인쇄옵션 **단면 1행만**(POPT_000001·앞 CMYK 4도·뒷면 인쇄 안 함). 형제 016의 양면(POPT_000002)이 **없다**—투명 소재
단면 특성. `has_print_option`→[[axis/print-options#printopt-POPT_000001]]. 도수=인쇄옵션 코드([[rule/rules#RULE_dosu_is_printopt]]).

#### 옵션그룹

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000019 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min~max | mand | use | del |
|---|---|---|---|---|---|---|
| OPT-000021 | 인쇄 | SEL_TYPE.01 | 0~1 | N | Y | N |
| OPT-000022 | 소재 | SEL_TYPE.01 | 0~1 | N | Y | N |
| OPT-000023 | 화이트인쇄 | SEL_TYPE.01 | 0~1 | N | Y | N |
| OPT-000024 | 모서리 | SEL_TYPE.01 | 0~1 | N | Y | N |

활성 4그룹(전부 SEL_TYPE.01 단일선택·2026-07-01 신규 생성). 아래 optgroup 노드로 각각 선언. ★코드 접두사 하이픈(OPT-)=
016 형제와 동일 separator 비일관 관찰(팩 §3.12 C-17·GAP-DP-4).

#### 옵션아이템(ref_dim)

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options+t_prd_product_option_items PRD_000019 @ 2026-07-03 -->
| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 |
|---|---|---|---|---|
| 모서리 | OPV-000045 | 둥근 | OPT_REF_DIM.04 | PROC_000028 |
| 인쇄 | OPV-000039 | 단면 | OPT_REF_DIM.06 | 1 |
| 화이트인쇄 | OPV-000043 | 화이트인쇄 | OPT_REF_DIM.04 | PROC_000008 |

옵션값 중 option_items ref 행 미보유(차원 미배선·관찰): OPV-000040(투명PET 260g), OPV-000041(반투명PET 260g), OPV-000044(직각)

★관찰: 소재 옵션값 2개(투명/반투명 PET)와 모서리 "직각"(OPV-000044)이 `t_prd_product_option_items`에 ref 행을 안 갖는다
(차원 미배선). 손님 선택은 노출되나 옵션→차원(ref_dim_cd) 환원이 부분적—값은 위 전사표가 권위, 완전성 판정은 검증 레인.

#### 제약

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints PRD_000019 @ 2026-07-03 -->
활성 제약 0행 (없음)

제약규칙 **0행**(형제 016의 [DEMO] 2건도 없음). 투명엽서 고유 제약(예 화이트인쇄↔소재 동반)은 미등록—§31 거버넌스 범위.

#### 추가상품

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons PRD_000019 @ 2026-07-03 -->
추가상품 0행 (없음 — 형제 016은 봉투 5행 보유)

`has_addon` 없음(라이브 0행). 형제 016 엽서는 봉투 addon 5행이나 투명엽서는 미보유—`has_addon` 엣지 없음(정상·오누락 아님).

#### 가격공식 바인딩

<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas PRD_000019 @ 2026-07-03 -->
| frm_cd | apply_bgn | note |
|---|---|---|
| PRF_DGP_A | 2026-06-01 | 투명엽서 → PRF_DGP_A |

`priced_by` → [[formula/digital-formulas#formula-PRF_DGP_A]](원자합산형). 구성요소 사슬: CMYK 인쇄비(COMP_PRINT_DIGITAL_S1·
PROC_000004)+화이트인쇄비(COMP_PRINT_SPOT_WHITE_S1·PROC_000008)+용지비(COMP_PAPER·PET plt_siz×mat)+귀돌이/코팅. 값 계산은
evaluate_price(D-18 경계). ★2026-06 초 견적 0 이력(PET 용지비 미적재+판형 오적재 복합)은 base 공정 18건 COMMIT
([[rule/decisions#DEC_baseproc_260701]])으로 인쇄비 정상화—공식 사슬 자체는 형제 016과 동일 PRF_DGP_A.

---

## 이 상품 전용 하위 노드 (option_group·qty·gap)

### [qty-019] 투명엽서 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000019
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000019 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 12/10000/12)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 12·max 10000·incr 12·016보다 낮은 최소). 사이즈별 수량규칙 오버라이드 없음(4행 전부 공란). t_prd_product_bundle_qtys 0행은 정상(수량 UI 권위=상품/사이즈).

### [optgroup-019-print] 인쇄(도수·단면) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000019
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000019 키:(PRD_000019,OPT-000021)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000021", opt_grp_nm: "인쇄", sel_typ_cd: "SEL_TYPE.01", 옵션값: "단면(OPV-000039→OPT_REF_DIM.06 ref_key1=1=print_opt)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, ref_key1: "1", note: "단면(opt_id=1→POPT_000001)"}
- 본문: 도수·단면 선택 그룹(양면 없음). 도수=print_opt_cd(색상코드 아님·[[rule/rules#RULE_dosu_is_printopt]]). option_item OPV-000039가 OPT_REF_DIM.06(print_option)로 opt_id=1(=POPT_000001) 참조·부모 019 has_print_option 정합(fn_chk_opt_item_ref).

### [optgroup-019-material] 소재(투명/반투명 PET) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000019
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000019 키:(PRD_000019,OPT-000022)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000022", opt_grp_nm: "소재", sel_typ_cd: "SEL_TYPE.01", 옵션값: "투명PET 260g(OPV-000040)·반투명PET 260g(OPV-000041)", ref상태: "두 옵션값 다 option_items ref 미보유(차원 미배선·관찰)"}
- 본문: 소재(투명/반투명 PET) 선택 그룹. option_refs 대상 자재(MAT_000144/147)가 공유 [[axis/materials]] 미민팅 + 라이브 option_items ref 행도 미보유 → 차원 배선 이중 부재. 자재 값은 자재 BOM 전사표가 권위 → [[gap-019-material]]. 투명 소재라 CMYK만 얹으면 비쳐 화이트인쇄 필요(→ optgroup-019-white 동반).

### [optgroup-019-white] 화이트인쇄 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000019
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000019 키:(PRD_000019,OPT-000023)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000023", opt_grp_nm: "화이트인쇄", sel_typ_cd: "SEL_TYPE.01", 옵션값: "화이트인쇄(OPV-000043→OPT_REF_DIM.04 ref_key1=PROC_000008)·'화이트인쇄 없음'(OPV-000042 del_yn=Y)"}
- 본문: 화이트인쇄(흰토너 밑판) 선택 그룹. option_item OPV-000043이 OPT_REF_DIM.04(process)로 PROC_000008(화이트인쇄) 참조. 그러나 PROC_000008이 공유 [[axis/processes]] 미민팅 → option_refs 배선 불가 → [[gap-019-white-process]]. 가격측=통합별색 COMP_PRINT_SPOT_WHITE_S1([[rule/decisions#DEC_spotwhite_260630]]). 투명 소재의 핵심 차별 옵션.

### [optgroup-019-corner] 모서리(직각/둥근) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000019
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000019 키:(PRD_000019,OPT-000024)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000024", opt_grp_nm: "모서리", sel_typ_cd: "SEL_TYPE.01", 옵션값: "직각(OPV-000044·ref 미보유)·둥근(OPV-000045→OPT_REF_DIM.04 ref_key1=PROC_000028)"}
- rel: {rel: option_refs, target: process-PROC_000028, ref_key1: "PROC_000028", note: "둥근(option_item OPV-000045)"}
- rel: {rel: option_refs, target: process-PROC_000027, note: "직각(부모 has_process 실재·라이브 option_items ref 행은 미보유=관찰)"}
- 본문: 모서리 형태(직각/둥근) 선택 그룹. 둥근(OPV-000045)은 OPT_REF_DIM.04로 PROC_000028 참조(축 노드 실재→배선). 직각은 부모 019 has_process에 PROC_000027 실재하나 라이브 option_items ref 행 미보유(둥근만 배선)—차원 배선 부분적 관찰. 가격은 귀돌이비 COMP_PP_CORNER_RIGHT(.03 고정 교정).

### [gap-019-material] 투명/반투명 PET 자재 공유 축 미민팅 (그래프 배선) {unknown}
- type: gap
- anchor: none  # 사유: MAT_000144/147은 live-snapshot 실재·BOM 전사표 권위이나 공유 axis/materials 미민팅(종이 용지만)이라 uses_material·option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000019 활성 2행(MAT_000144 투명PET·MAT_000147 반투명PET·MAT_TYPE.01)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "투명엽서 활성 자재 2종(MAT_000144 투명 PET 260g·MAT_000147 반투명 PET 260g)이 공유 [[axis/materials]]에 미민팅 — uses_material·optgroup-019-material option_refs 미배선. 공유 축은 종이 용지 대표만 보유(PET 소재 미보유). BOM 전사표가 값 권위이나 그래프 탐색 시 침묵 누락"
- gap_fill_from: "architect 공유 축 mint 결정 — axis/materials에 material-MAT_000144/147(MAT_TYPE.01·USAGE.07·투명 소재 계열) 민팅 후 019 uses_material 2행 + optgroup-019-material option_refs 배선. needed_shared_nodes로 통합 단계 반환"
- gap_owner: 설계
- 본문: 값은 아는데(live·BOM 전사) 공유 축 노드가 없어 그래프 배선이 부재한 KB 커버리지 공백(016의 GAP_016_material 동류·이쪽은 활성 전량 미보유). 조용한 누락 대신 정직 선언. 채움=공유 축 PET 자재 mint.

### [gap-019-white-process] 화이트인쇄 공정(PROC_000008) 공유 축 미민팅 {unknown}
- type: gap
- anchor: none  # 사유: PROC_000008은 live-snapshot 실재(019 mand 공정)이나 공유 axis/processes 미민팅이라 has_process·option_refs 그래프 배선 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000019 PROC_000008 화이트인쇄(mand_proc_yn=Y·상위 proc_grp PROC_000007)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.3 별색=공정·§3.6 proc 이원화", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "투명엽서 필수 공정 화이트인쇄(PROC_000008·상위 proc_grp PROC_000007 별색)가 공유 [[axis/processes]]에 미민팅 — has_process(화이트)·optgroup-019-white option_refs 미배선. 공유 축은 PROC_000004/027/028 등 보유하나 화이트인쇄 미보유"
- gap_fill_from: "architect 공유 축 mint 결정 — axis/processes에 process-PROC_000008(화이트인쇄·상위 PROC_000007·투명 소재 밑판·가격측 COMP_PRINT_SPOT_WHITE_S1 연동) 민팅 후 019 has_process(mand)+optgroup-019-white option_refs 배선. needed_shared_nodes로 반환"
- gap_owner: 설계
- rel: {rel: references, target: component-COMP_PRINT_SPOT_WHITE_S1, note: "화이트인쇄 가격측 통합별색 구성요소(같은 019 공정풀)"}
- 본문: 화이트인쇄는 투명엽서의 핵심 차별 공정(mand)인데 공유 공정 축에 노드가 없어 has_process 배선이 CMYK/모서리 3종만 되고 화이트가 빠진다. 정직 선언(형제 016은 화이트인쇄 없음—019 고유). 채움=공유 축 PROC_000008 mint.
