<!-- companion nodes for product-055 낱장 자유형 스티커 — 공유 축 노드(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙(index.md·axis/*·formula/*·rule/*)에 따라, 없는 것만 여기 신설(023 방식). -->
<!-- ★L-3 중복 회피: 이미 다른 파일에 정의된 노드(스티커 공유·기존 디지털 companion)는 여기서 재정의하지 않고 참조만 한다. -->
<!-- ★수치·배선은 전사 스크립트 transcribe_product_055.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-055 전용 노드 (낱장 자유형 스티커 — 상품 전용 마스터 축)

[[product-055-sticker-sheet-freeform]]가 연결하는 축 중, **오직 055에서만 실재하는** 것만 신설한다.
다음은 이미 다른 파일에 정의되어 **재사용(참조만·L-3 중복 금지)**:
- **단면** printopt-POPT_000001 = 공유 `axis/print-options.md`.
- **완칼커팅** process-PROC_000123 = `product-023-shaped-postcard-nodes.md`(2소비 상품 023/055).
- **A4/A3** size-SIZ_000172/174 = `product-047-small-flyer.md`(기존 디지털 companion·규격 공유).
- **A2** size-SIZ_000197 = 형제 스티커 companion.
- **출력용지 기타(.03)** plate-OUTPUT_PAPER_TYPE_03 = `product-030-zigzag-postcard-nodes.md`.
- **스티커 완제품가 공식/구성요소** formula-PRF_STK_FIXED·component-COMP_STK_PRINT = 형제 스티커
  companion(6,498행 완제품가를 공유하는 16 스티커 상품 공통).
- **카테고리** category-CAT_000002(스티커)·category-CAT_000309(자유형스티커) = 형제 스티커 companion.

**★needed_shared_nodes(통합 단계 공유 페이지 일괄 이관 대상):** formula-PRF_STK_FIXED·
component-COMP_STK_PRINT·plate-OUTPUT_PAPER_TYPE_03·process-PROC_000114·category-CAT_000002·
category-CAT_000309·size-SIZ_000172/174/197 — 여러 스티커/디지털 상품이 공유하므로 상품 companion
분산 정의(현재 L-3 다중정의) 대신 `axis/*`·`formula/sticker-*` 공유 페이지로 단일 정의 이관 필요.

**055 고유 신설분(아래 정의):** material-MAT_000593(유포+무광쿨코팅)·process-PROC_000114(쿨코팅)·
qty-055·optgroup-055-paper/print/cutting/jogaksu·gap-055-* 4종.

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사·del_yn!=Y 활성분)

> 아래 표는 `_meta/scripts/transcribe_product_055.py`가 live-snapshot에서 결정론 전사(손전사 아님).

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (정체·수량·상태) PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| prd_nm | prd_typ | nonspec | min | max | incr | 단위 | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|---|---|
| 낱장 자유형 스티커 | PRD_TYPE.01 | N | 1 | 10000 | 1 | QTY_UNIT.02 | Y | N | Y | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| cat_cd | 분류명 | 상위 | main | disp |
|---|---|---|---|---|
| CAT_000002 | 스티커 |  | Y | 3 |
| CAT_000309 | 자유형스티커 | CAT_000002 | N |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp |
|---|---|---|---|---|---|
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | N | 1 |
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | N | 1 |
| SIZ_000172 | A4(210x297mm) | 210x297 | 210x297 | Y | 1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage | dflt |
|---|---|---|---|---|---|---|---|
| MAT_000593 | 유포 + 무광쿨코팅 | MAT_TYPE.11 | MAT_000165 | ?x? | ? | USAGE.07 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000123 | 완칼커팅 | PROC_000121 | N | 1 |
| PROC_000114 | 쿨코팅 |  | N | 2 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| siz_cd | 라벨 | output_paper_typ_cd | dflt_plt | note |
|---|---|---|---|---|
| SIZ_000050 | A4 (210X297) | OUTPUT_PAPER_TYPE.03 | Y | 파일사양 |
| SIZ_000052 | A3 (297X420mm) | OUTPUT_PAPER_TYPE.03 | Y | 파일사양 |
| SIZ_000198 | A2 (420X594mm) | OUTPUT_PAPER_TYPE.03 | Y | 파일사양 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components(use_dims) PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn | prc_typ_cd | use_dims |
|---|---|---|---|---|---|
| PRF_STK_FIXED | COMP_STK_PRINT | 1 | Y | PRICE_TYPE.01 | ["siz_cd", "mat_cd", "min_qty"] |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (COMP_STK_PRINT 완제품가 룩업 커버리지·활성 사이즈×자재 행수·값 접기 D-22) PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| siz_cd | mat_cd | 단가행수 |
|---|---|---|
| SIZ_000172 | MAT_000593 | 6 |
| SIZ_000174 | MAT_000593 | 6 |
| SIZ_000197 | MAT_000593 | 6 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | min_sel | max_sel | mand | disp |
|---|---|---|---|---|---|---|
| OPT_000013 | 종이 | SEL_TYPE.01 | 1 | 1 | Y | 1 |
| OPT_000014 | 인쇄 | SEL_TYPE.01 | 1 | 1 | Y | 2 |
| OPT_000015 | 커팅 | SEL_TYPE.01 | 1 | 1 | Y | 4 |
| OPT-000039 | 조각수 | SEL_TYPE.01 | 0 | 1 | N | 5 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options (그룹별 선택값) PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| opt_cd | opt_grp_cd | 선택값 | dflt | disp |
|---|---|---|---|---|
| OPV-000076 | OPT-000039 | 5조각 | N | 1 |
| OPV-000077 | OPT-000039 | 6조각 | N | 2 |
| OPV-000078 | OPT-000039 | 7조각 | N | 3 |
| OPV-000079 | OPT-000039 | 8조각 | N | 4 |
| OPV-000080 | OPT-000039 | 9조각 | N | 5 |
| OPV-000081 | OPT-000039 | 10조각 | N | 6 |
| OPV_000029 | OPT_000013 | 유포지+엠포코팅 | Y | 1 |
| OPV_000030 | OPT_000014 | 단면 | Y | 1 |
| OPV_000031 | OPT_000015 | 완칼(자유형) | Y | 1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items (다형참조 ref_dim_cd) PRD_000055 (del_yn!=Y 활성분) @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|
| OPV_000030 | OPT_REF_DIM.06 | 1 |  | 1 |
| OPV_000031 | OPT_REF_DIM.04 | PROC_000053 |  | 1 |
| OPV_000029 | OPT_REF_DIM.03 | MAT_000593 | USAGE.07 | 1 |

---

## 사이즈·판형·카테고리·공식 — 공유 노드 참조 (재정의 금지·L-3)

낱장 자유형 스티커의 사이즈(A4 SIZ_000172·A3 SIZ_000174·A2 SIZ_000197)·판형(plate-OUTPUT_PAPER_TYPE_03)·
카테고리(category-CAT_000002·CAT_000309)·완제품가 공식/구성요소(formula-PRF_STK_FIXED·
component-COMP_STK_PRINT)는 위 목록대로 **다른 파일이 이미 정의**한다. 여기 재정의하면 L-3 중복이므로
전사표에 실재만 기록하고 [[product-055-sticker-sheet-freeform]]의 has_size/has_plate_size/in_category/
priced_by 엣지가 그 공유 노드로 해소된다. 통합 시 공유 페이지 승격(needed_shared_nodes).

- A4/A3 규격 사이즈는 기존 디지털 상품(047)과 **동일 siz_cd 공유** — 스티커 규격도 같은 A판 규격 재사용.
- 완제품가 격자(COMP_STK_PRINT·use_dims=[siz_cd,mat_cd,min_qty])는 16 스티커 상품이 6,498행을 공유.
- **A2 SIZ_000197은 공유 축·기존 companion 어디에도 미정의** → 055가 최초 소비이므로 여기서 정의(아래).
  향후 A2 쓰는 형제 스티커/상품이 이 노드 재사용(needed_shared_node).

---

## 자재 (material) — 낱장 자유형 스티커 고유 활성 1종

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). 자재유형 = MAT_TYPE.11(스티커 점착지).
★[HARD] 실무진이 IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지
([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 낱장 자유형 스티커 고유 활성 (완칼커팅은 023 companion 재사용·쿨코팅만 신설)

완칼커팅(PROC_000123)은 [[product-023-shaped-postcard-nodes#process-PROC_000123]]에 이미 신설된
공유 후보 노드 재사용(2소비 상품 023/055·L-3 중복 금지). 여기는 쿨코팅(PROC_000114)만 신설.

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-055] 낱장 자유형 스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000055
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000055 min_qty/max_qty/qty_incr", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(상품 1/10000/1)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 10000·incr 1·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4·[[rule/decisions#DEC_qty_audit_260702]]). 사이즈별 수량규칙 미설정. 완제품가 단가는 수량구간(min_qty 1·20·50…)으로 COMP_STK_PRINT에서 조회.

---

## CPQ 옵션그룹 (option_group) — 종이·인쇄·커팅·조각수 4종

손님 선택 축 4종. 옵션→차원 연결은 다형참조(OPT_REF_DIM.03 자재·.04 공정·.06 도수)로 option_item
단위 귀속(스키마 R11·한정자로 접음). ★option_refs 타깃은 같은 부모 product-055 활성 차원에 실재해야
함(L-18·fn_chk_opt_item_ref).

### [optgroup-055-paper] 종이 (자재 택1 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000055
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000055,OPT_000013) 종이·mand_yn=Y·SEL_TYPE.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000029 ref_dim_cd:OPT_REF_DIM.03 ref_key1:MAT_000593 ref_key2:USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000013", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "종이(자재) 택1 필수·유포 1종(OPV_000029 '유포지+엠포코팅'·dflt)→OPT_REF_DIM.03(자재)+USAGE.07"}
- rel: {rel: option_refs, target: material-MAT_000593, qualifier: {ref_dim_cd: "OPT_REF_DIM.03", ref_key1: "MAT_000593", ref_key2: "USAGE.07"}}

### [optgroup-055-print] 인쇄 (도수 택1 필수) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000055
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000055,OPT_000014) 인쇄·mand_yn=Y·SEL_TYPE.01", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_cd:OPV_000030 ref_dim_cd:OPT_REF_DIM.06 ref_key1:1(도수 opt_id)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000014", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "인쇄(도수) 택1 필수·단면 단일(OPV_000030·dflt)→OPT_REF_DIM.06 ref_key1=1(인쇄옵션 opt_id=POPT_000001 단면)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}}

### [optgroup-055-cutting] 커팅 (공정 택1 필수·option_item stale) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000055
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000055,OPT_000015) 커팅·mand_yn=Y·SEL_TYPE.01·note '완칼 PROC_000053'", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT_000015", sel_typ_cd: "SEL_TYPE.01", mand_yn: "Y", note: "커팅(공정) 택1 필수·완칼(자유형) 단일(OPV_000031·dflt). ★option_item ref_key1=PROC_000053이나 그 공정은 상품에서 논리삭제됨(활성=PROC_000123) → option_refs 엣지 미생성·정합 GAP"}
- rel: {rel: references, target: gap-055-cutting-optref-stale, note: "stale option_item 참조 정직 선언(fn_chk_opt_item_ref 위반 소지)"}

### [optgroup-055-jogaksu] 조각수 (5~10·선택·리터럴) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000055
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000055,OPT-000039) 조각수·mand_yn=N·min0/max1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "opt_cd:OPV-000076~081(5~10조각·option_items ref_dim 행 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000039", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "조각수 5~10(6값)·선택(비필수). 리터럴값 — 물리 차원(size/material/process) 미참조(option_items ref 행 없음). 조각수 저장처 스키마 부재(GAP-ST-2)"}
- rel: {rel: references, target: gap-055-jogaksu-storage, note: "조각수 저장처 부재 정직 선언"}

---

## GAP 노드 (원천 부재·정합 미해결 — 지어내지 않음)

### [gap-055-cutting-optref-stale] 커팅 옵션 stale 공정 참조 (fn_chk_opt_item_ref) {unknown}
- type: gap
- anchor: none  # 사유: 라이브 option_item이 논리삭제된 공정을 가리키는 정합 위반 — 정답(어느 공정을 가리켜야 하나)은 개발/실무진 확인 대기
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000055,OPV_000031) ref_dim_cd=OPT_REF_DIM.04 ref_key1=PROC_000053", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes PRD_000055 PROC_000053=del_yn=Y(활성=PROC_000123)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "커팅 옵션값 완칼(OPV_000031)의 option_item ref_key1=PROC_000053이나, PROC_000053은 PRD_000055 product_processes에서 논리삭제됨(활성 완칼=PROC_000123). 옵션참조가 상품 활성 차원에 미실재 → fn_chk_opt_item_ref 정합 위반 소지(스키마 L-18)"
- gap_fill_from: "실무진/개발 확인 — option_item ref_key1을 PROC_000123으로 갱신할지(재키잉 복구 후속 미반영) 판정 후 §7 dbmap 교정 위임(KB는 배선 사실만 기록)"
- gap_owner: 개발
- rel: {rel: references, target: process-PROC_000123, note: "정답 후보=활성 완칼커팅 PROC_000123"}
- 본문: 023/055 완칼 공정이 PROC_000053→PROC_000123으로 재구성됐으나 커팅 옵션의 option_item 참조는 구 코드(PROC_000053)로 남았다. option_refs 엣지를 만들면 L-18(부모 활성 차원 미실재)에 걸리므로 GAP으로 정직 선언(지어내지 않음). 교정은 KB 밖(§7 dbmap·인간 승인).

### [gap-055-jogaksu-storage] 조각수 저장처 부재 (GAP-ST-2·OM-7) {unknown}
- type: gap
- anchor: none  # 사유: 조각수(판당 개수)의 공정 param 저장처(prcs_dtl_opt.조각수)가 스키마 부재
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.4 GAP-ST-2(조각수 저장처 Q-ST-B·OM-7)·§5", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "opt_cd:OPV-000076~081 조각수 5~10(리터럴·ref_dim 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "조각수 옵션(5~10조각)이 CPQ 옵션값으로만 존재하고, 조각수의 공정 param 저장처(prcs_dtl_opt.조각수·상품레벨)가 스키마 부재(ref_param_json 미구현). 완칼 조각수가 물리 차원으로 환원되지 않음"
- gap_fill_from: "prcs_dtl_opt.조각수 상품레벨 저장처 신설(스키마 변경·architect 소관)·ref_param_json 구현 선결 — 실무진 Q-ST-B"
- gap_owner: 설계
- 본문: 조각수(판당 개수+제한)와 묶음수는 다른 축(팩 §3.4). 합판도무송 066만 bundle_qtys 형상별 EA 보유·낱장 자유형 055는 조각수를 리터럴 옵션값으로만 노출. 저장처 부재는 스키마 미실현이라 GAP.

### [gap-055-material-name-cst10] 자재명 유포지+엠보코팅 복원 컨펌 (C-ST-10) {unknown}
- type: gap
- anchor: none  # 사유: 자재 표시명 복원 목표가 컨펌 대기(권위 명 미확정)·정답값 미확정이라 dual 아님
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.5 GAP(055/057 자재명 '유포지+엠보코팅' 복원·C-ST-10·멱등키 영향·컨펌)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "MAT_000593 mat_nm='유포 + 무광쿨코팅' vs 상위 MAT_000165='유포지+엠보코팅'", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "낱장 자유형 스티커 자재 표시명이 live '유포 + 무광쿨코팅'(MAT_000593)인데 C-ST-10 복원목표는 '유포지+엠보코팅'(상위 MAT_000165 명). 055/057 자재명 복원이 멱등키 영향으로 컨펌 대기 — 어느 명이 권위인지 미확정"
- gap_fill_from: "실무진 컨펌(C-ST-10·자재명 복원 여부)·확정 후 §7 dbmap 교정. 권위 명 확정 전 dual 노드화 금지(정답값 미확정)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000593, note: "명칭 컨펌 대상 자재"}
- 본문: 명칭 불일치가 컨펌 대기라 양면(현재값 vs 정답) 노드가 아니라 GAP(정답 명 미확정)으로 정직 선언. 확정 시 dual 또는 교정으로 승격.

### [gap-055-material-cost-storage] 스티커 소재 연당가 원가 저장처 부재 (원가↔완제품가 열린질문) {unknown}
- type: gap
- anchor: none  # 사유: 스티커 소재 연당가(원자재 원가) 저장처가 라이브 가격사슬에 없음(완제품가만 저장)
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-B(연당가 저장처 부재·t_mat_materials 가격컬럼 없음·COMP_PAPER 스티커 mat_cd 0행)·§4-D·§5 GAP-ST(연당가)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "MAT_000593 유포=weight만·연당가/국4절가 컬럼 없음(소재 마스터 원가 미저장)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "스티커는 완제품가(COMP_STK_PRINT)로 통째 저장하고 소재 연당가(원자재 원가)를 절가 노드로 펼치지 않는다. 055 자재=유포(MAT_000593)는 260702 연당가 무변경이라 dual 미해당이나, 소재 원가 급변(투명/홀로/크라프트)이 완제품 시트가격으로 전파돼야 하는지·원가 저장처 신설 여부는 전(全) 스티커 공통 열린 질문"
- gap_fill_from: "실무진+인간 승인(팩 §4-D·§5) — 소재 원가 저장처 신설 여부·완제품가 전파 정책. 055 자체는 유포라 dual 워크리스트 비대상(연당가 defect 4소재는 형제 투명/홀로/크라프트 상품 소관)"
- gap_owner: staff
- 본문: 055는 유포(무변경)라 자기 노드에 연당가 양면(defect)이 없다. 이 GAP은 "스티커 원가↔완제품가 정합" 공통 열린질문을 정직 기록할 뿐(팩 §4-D "retail 무변경·dual 금지"·false-defect 회피). 연당가 재적재 워크리스트 4소재는 형제 상품 노드에서 dual로 표기될 대상.
