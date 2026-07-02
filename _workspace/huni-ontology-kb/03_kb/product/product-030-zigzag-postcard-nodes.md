<!-- companion nodes for product-030 지그재그엽서 — 공유 축 노드(axis/*·formula/*)에 없는 상품 전용 마스터 노드 + CPQ 옵션그룹. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/sizes.md·materials.md·processes.md·plate-sizes.md·formula/*에 없는 것만 여기 신설(023/027 방식). -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·process-PROC_*·plate-*·component-*·formula-*)를 쓴다 — 향후 공유 축(axis/*·formula/*)으로 이관 후보(needed_shared_nodes로 반환·통합 단계 일괄 mint). -->
<!-- ★수치(치수·사양·배선)는 전사 스크립트 transcribe_product_030.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-030 전용 노드 (지그재그엽서 — 상품 전용 마스터 축 + CPQ)

[[product-030-zigzag-postcard]]가 연결하는 축 중, 디지털 파일럿 공유 축 노드(axis/*·formula/*)에
아직 없는 것만 신설한다. 공유에 있는 것(PROC_000004 base·POPT_000002 양면·카테고리 CAT_000021/001·
COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_CUT_PERF_1H6)은 재사용하고 여기 중복 신설하지 않는다(L-3).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_030.py`가 live-snapshot에서 결정론 전사(손전사 아님).

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000030 @ 2026-07-03 -->
| prd_nm | min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|---|
| 지그재그엽서 | 2 | 10000 | 2 | QTY_UNIT.02 | PRD_TYPE.01 | Y | N | Y | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000030 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | note |
|---|---|---|---|---|---|---|
| SIZ_000031 | 600x150 | 604x154 | 600x150 | Y | 1 | 판걸이=2.0 / 전지=미지정 / 적용=지그재그카드 |
| SIZ_000032 | 150x600 | 154x604 | 150x600 | Y | 1 | 판걸이=2.0 / 전지=미지정 / 적용=지그재그카드 |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (pm_del=상품자재 논리삭제여부) PRD_000030 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage | pm_del |
|---|---|---|---|---|---|---|---|
| MAT_000105 | 몽블랑 130g | MAT_TYPE.01 | MAT_000103 | 316x467 | 130 | USAGE.07 | Y |
| MAT_000110 | 몽블랑 130g (3절) | MAT_TYPE.01 | MAT_000103 | 316x467 | 130 | USAGE.07 | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes PRD_000030 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000073 | 6단오시접지 | PROC_000056 | N | 1 |
| PROC_000074 | 6단미싱접지 | PROC_000056 | N | 1 |
| PROC_000004 | 디지털인쇄 | PROC_000001 | Y | -1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000030 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 양면 | POPT_000002 | CLR_000005(CMYK 4도) | CLR_000005(CMYK 4도) |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (del=판형 논리삭제여부) PRD_000030 @ 2026-07-03 -->
| siz_cd | 라벨 | output_paper_typ_cd | dflt_plt | del |
|---|---|---|---|---|
| SIZ_000142 | 604x154 | OUTPUT_PAPER_TYPE.03 | Y | Y |
| SIZ_000143 | 154x604 | OUTPUT_PAPER_TYPE.03 | Y | Y |
| SIZ_000475 | 330x660 | OUTPUT_PAPER_TYPE.03 | Y | N |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_price_formulas PRD_000030 @ 2026-07-03 -->
| frm_cd | frm_nm | note |
|---|---|---|
| PRF_DGP_C_6CR | 디지털인쇄 원자합산형C-6단접지 지그재그엽서 | PRF_DGP_C 복제+6단접지(COMP_FOLD_CARD_6CR) 교체. 인쇄비+용지비+6단접지비+타공비(미등록시0). 260701 지그재그엽서(030) 전용 신설. |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prc_formula_components+t_prc_price_components PRD_000030 @ 2026-07-03 -->
| frm_cd | comp_cd | 구성요소명 | prc_typ | use_dims | disp_seq | addtn |
|---|---|---|---|---|---|---|
| PRF_DGP_C_6CR | COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 | PRICE_TYPE.01 | ["proc_cd", "plt_siz_cd", "print_opt_cd", "min_qty", "proc_grp:PROC_000001"] | 0 | Y |
| PRF_DGP_C_6CR | COMP_PAPER | 용지비(종이별 절가) | PRICE_TYPE.01 | ["plt_siz_cd", "mat_cd"] | 1 | Y |
| PRF_DGP_C_6CR | COMP_FOLD_CARD_6CR | 접지비 카드 6크리즈 | PRICE_TYPE.01 | ["min_qty"] | 2 | Y |
| PRF_DGP_C_6CR | COMP_CUT_PERF_1H6 | 타공비 (6mm) | PRICE_TYPE.01 | ["proc_cd", "min_qty", "proc_grp:PROC_000079"] | 3 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups PRD_000030 @ 2026-07-03 -->
| opt_grp_cd | 그룹명 | sel_typ | mand | disp |
|---|---|---|---|---|
| OPT-000028 | 인쇄 | SEL_TYPE.01 | N | 1 |
| OPT-000029 | 종이 | SEL_TYPE.01 | N | 2 |
| OPT-000030 | 접지 | SEL_TYPE.01 | N | 3 |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options+t_prd_product_option_items PRD_000030 @ 2026-07-03 -->
| opt_cd | 옵션값 | 소속그룹 | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV-000055 | 양면 | OPT-000028(인쇄) | OPT_REF_DIM.06 | 1 |  |
| OPV-000056 | 몽블랑 130g | OPT-000029(종이) | OPT_REF_DIM.03 | MAT_000105 | USAGE.07 |
| OPV-000057 | 6단오시접지 | OPT-000030(접지) | OPT_REF_DIM.04 | PROC_000073 |  |
| OPV-000058 | 6단미싱접지 | OPT-000030(접지) | OPT_REF_DIM.04 | PROC_000074 |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons+t_prd_templates PRD_000030 @ 2026-07-03 -->
| tmpl_cd | 템플릿명 | base_prd_cd | disp |
|---|---|---|---|
| TMPL-000005 | OPP접착봉투 110x160 mm  50장 | PRD_000001 | 1 |
| TMPL-000006 | OPP비접착봉투 110x160 mm 50장 | PRD_000002 | 2 |

---

## 사이즈 (size) — 지그재그엽서 전용 2행 (방향 택일)

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 지그재그는 가로(600×150)/세로(150×600)
방향 택일이라 두 행 모두 dflt_yn=Y다(방향만 다르고 펼침 치수 604×154 동일). 판걸이수(UP수)는 사이즈
컬럼이 아니라 파생(`fn_calc_pansu`·라이브 note "판걸이=2.0"·[[rule/rules#RULE_pansu_db_function]]).

### [size-SIZ_000031] 600x150 지그재그 가로 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000031
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000031 (tags 지그재그엽서·note 판걸이=2.0)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000031", note: "600x150 가로 지그재그(작업 604x154·재단 600x150)·dflt=Y. 공유 axis/sizes 미등재 → 승격 후보(needed_shared_node)"}

### [size-SIZ_000032] 150x600 지그재그 세로 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000032
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000032 (tags 지그재그엽서·note 판걸이=2.0)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000032", note: "150x600 세로 지그재그(작업 154x604·재단 150x600)·dflt=Y. SIZ_000031과 방향 택일·펼침 치수 동일. 공유 axis/sizes 미등재 → 승격 후보"}

---

## 자재 (material) — 지그재그엽서 활성 1종 (구자재 MAT_000105는 삭제)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). 3절 판형이관 시 몽블랑 130g가 105→110
교체됐다(105 논리삭제). ★종이 옵션(OPV-000056)이 삭제된 105를 참조하는 불일치는
[[gap-030-paper-optref-mismatch]] 관찰. 삭제 노드(MAT_000105)는 민팅하지 않는다(닫힌세계·L-17/L-3).

### [material-MAT_000110] 몽블랑 130g (3절) {verified}
- type: material
- anchor: t_mat_materials/MAT_000110
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000110", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000030,MAT_000110) del_yn=N (활성·07-01 교체)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000103", 사양_ref: "전사표 MAT_000110(316x467·130g)", note: "몽블랑 계열(상위 MAT_000103)·3절 판형이관 활성 자재·공유 축 승격 후보. 구자재 MAT_000105(삭제)는 미민팅"}

---

## 공정 (process) — 지그재그엽서 전용 2종 (공유 PROC_000004 base 제외)

6단접지 상품 라우트 = 디지털출력(PROC_000004·base·공유) + 6단오시접지(PROC_000073)/6단미싱접지
(PROC_000074) 택일. 두 접지 공정 모두 상위=PROC_000056(접지·공유 axis/processes 등재)이나 6단
자식 자체는 공유 축 미등재 → companion 민팅·승격 후보(needed_shared_node). 접지는 도수 아닌 공정
(팩 §3.3)이며, 가격측에서 6단접지비 구성요소(COMP_FOLD_CARD_6CR)로도 표현된다(공정행=생산 라우팅·
구성요소=가격·역할 분리).

### [process-PROC_000073] 6단오시접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000073
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000073 (upr_proc_cd=PROC_000056 접지·note 복합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000030(mand N·접지 옵션)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "6단오시접지", upr_proc_cd: "PROC_000056", role: "6단 지그재그 접지(오시=접는 자국식)·접지(PROC_000056)의 자식", note: "공유 axis/processes 미등재 → 승격 후보(needed_shared_node)"}

### [process-PROC_000074] 6단미싱접지 {verified}
- type: process
- anchor: t_proc_processes/PROC_000074
- src: {source_file: "live-snapshot/latest/t_proc_processes.csv", source_locator: "테이블:t_proc_processes 키:PROC_000074 (upr_proc_cd=PROC_000056 접지·note 복합)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 소비:PRD_000030(mand N·접지 옵션)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {proc_nm: "6단미싱접지", upr_proc_cd: "PROC_000056", role: "6단 지그재그 접지(미싱=절취선식 접기)·접지(PROC_000056)의 자식", note: "PROC_000073과 접지 방식 택일·공유 축 승격 후보"}

---

## 판형 (plate_size) — 3절(기타·OUTPUT_PAPER_TYPE.03)

디지털 대다수는 국전(.01)이나 030은 3절 판형이관(06-30 SIZ_000142/143→SIZ_000475 330×660 교체).
판형 = 출력용지규격(작업사이즈 아님)·종이류만 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택
(`fn_best_plate` 자동선택). 공유 axis/plate-sizes에 국전(.01)만 있고 3절(.03) 미등재 → companion
민팅·승격 후보(needed_shared_node).

### [plate-OUTPUT_PAPER_TYPE_03] 3절 (기타) {verified}
- type: plate_size
- anchor: t_cod_base_codes/OUTPUT_PAPER_TYPE.03
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "테이블:t_cod_base_codes 키:OUTPUT_PAPER_TYPE.03 cod_nm=기타 (upr OUTPUT_PAPER_TYPE·disp 3)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000030,SIZ_000475) del_yn=N (330x660 3절 활성·06-30 이관)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md", source_locator: "문서:판형·판걸이수 규칙(종이류만·fn_best_plate)", captured_at: "2026-07-03", badge: verified, src_id: SR-4-domrules}
- props: {cod_nm: "기타", 규격: "3절(전사표 SIZ_000475 330x660)", 적용: "지그재그엽서 등 3절 라인 출력용지", note: "구 SIZ_000142/143(604x154·154x604)은 06-30 논리삭제 후 SIZ_000475로 이관. 공유 축(국전 .01)에 .03 미등재 → 승격 후보"}

---

## 가격구성요소 (price_component) — 6단접지비 (공유 축 미등재 1종)

공식의 부품. use_dims = 이 구성요소 가격이 어떤 축으로 달라지는가(차원 선언)까지만 — **가격 값 계산은
evaluate_price 단일 권위**(온톨로지 밖·D-18). 인쇄/용지/타공 구성요소는 공유 [[formula/digital-components]]
재사용, 6단접지비만 여기 신설(공유 축은 COMP_FOLD_CARD_2H 2단만 보유).

### [component-COMP_FOLD_CARD_6CR] 접지비 카드 6크리즈 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_FOLD_CARD_6CR
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "테이블:t_prc_price_components 키:COMP_FOLD_CARD_6CR comp_typ=PRC_COMPONENT_TYPE.04", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {prc_typ_cd: "PRICE_TYPE.01", use_dims: '["min_qty"]', role: "6단(6크리즈) 접지비·접지 종류·주문수량 구간별 작업 1건 고정 금액(수량 미곱). 공유 축 COMP_FOLD_CARD_2H(2단)의 6단 대응·승격 후보(needed_shared_node)"}

---

## 가격공식 (price_formula) — 6단접지 지그재그 전용 (공유 축 미등재)

디지털 = 원자합산형(인쇄비+용지비+공정비). 030은 PRF_DGP_C(배경지·헤더택 접지+타공)를 복제해 접지
구성요소를 6단(COMP_FOLD_CARD_6CR)으로 교체한 전용 공식(07-01 신설). has_component 배선은 아래
relations(disp_seq·addtn 한정자·전사표 권위). 공유 [[formula/digital-formulas]]에 미등재 → 승격 후보.

### [formula-PRF_DGP_C_6CR] 원자합산형C-6단접지 지그재그엽서 {verified}
- type: price_formula
- anchor: t_prc_price_formulas/PRF_DGP_C_6CR
- src: {source_file: "live-snapshot/latest/t_prc_price_formulas.csv", source_locator: "테이블:t_prc_price_formulas 키:PRF_DGP_C_6CR (use_yn=Y·07-01 신설·note 3절 판형이관+6단접지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "테이블:t_prc_formula_components frm_cd:PRF_DGP_C_6CR (4행)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: has_component, target: component-COMP_PRINT_DIGITAL_S1, qualifier: {disp_seq: 0, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_PAPER, qualifier: {disp_seq: 1, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_FOLD_CARD_6CR, qualifier: {disp_seq: 2, addtn: Y}}
- rel: {rel: has_component, target: component-COMP_CUT_PERF_1H6, qualifier: {disp_seq: 3, addtn: Y}}
- props: {archetype: "원자합산형", note: "030 지그재그엽서 전용 신설(PRF_DGP_C 복제+6단접지 교체)·인쇄+용지+6단접지비+타공(미등록시0)·공유 축 승격 후보"}

---

## CPQ 옵션그룹 (option_group) — 3그룹

손님이 고르는 선택 축 3종. 각 옵션값이 가리키는 실물 차원은 다형참조 `ref_dim_cd`(OPT_REF_DIM.03=자재·
.04=공정·.06=인쇄옵션)+`ref_key1`으로 option_item에 귀속(R11). option_refs 타깃은 같은 부모
product-030 차원에 실재해야 한다(L-18·`fn_chk_opt_item_ref`).

### [optgroup-OPT-000028] 인쇄 (양면 고정) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000030
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000030+OPT-000028", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000028", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "옵션값 '양면' 1개(OPV-000055)→OPT_REF_DIM.06 ref_key1=1(인쇄옵션 opt_id). 양면 전용 상품이라 사실상 고정"}
- rel: {rel: option_refs, target: printopt-POPT_000002, qualifier: {ref_dim_cd: "OPT_REF_DIM.06", ref_key1: "1"}}

### [optgroup-OPT-000029] 종이 (몽블랑 130g·★삭제자재 참조) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000030
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000030+OPT-000029", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000030,OPV-000056) ref_dim_cd:OPT_REF_DIM.03 ref_key1:MAT_000105(삭제) ref_key2:USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000029", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "종이 1종 '몽블랑 130g'(OPV-000056)→OPT_REF_DIM.03 ref_key1=MAT_000105. ★MAT_000105는 07-01 논리삭제(활성 자재=MAT_000110)라 option_refs 엣지 유보(삭제 노드 미민팅·L-15/L-18 오염 회피)"}
- rel: {rel: references, target: gap-030-paper-optref-mismatch, note: "종이 옵션이 삭제 자재(MAT_000105) 참조 — 활성 MAT_000110과 불일치 관찰(정직 GAP)"}

### [optgroup-OPT-000030] 접지 (6단오시/6단미싱) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000030
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000030+OPT-000030", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(OPV-000057→PROC_000073·OPV-000058→PROC_000074) ref_dim_cd:OPT_REF_DIM.04", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000030", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", note: "접지 방식 단일선택·6단오시접지(PROC_000073)/6단미싱접지(PROC_000074)→OPT_REF_DIM.04(공정)"}
- rel: {rel: option_refs, target: process-PROC_000073, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000073"}}
- rel: {rel: option_refs, target: process-PROC_000074, qualifier: {ref_dim_cd: "OPT_REF_DIM.04", ref_key1: "PROC_000074"}}
