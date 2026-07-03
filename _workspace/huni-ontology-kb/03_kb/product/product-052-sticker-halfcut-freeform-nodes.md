<!-- companion nodes for product-052 반칼 자유형 스티커 — 공유 축(axis/*·formula/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(023 방식). -->
<!-- ★스티커 첫 상품이라 스티커 공유 축(카테고리 CAT_000002·완제품가 공식 PRF_STK_FIXED·구성요소 COMP_STK_PRINT·반칼커팅 PROC_000122·46전지 판형)은 여기 mint→needed_shared_nodes로 반환(향후 16 스티커 승격 후보). -->
<!-- ★수치(치수·사양·단가행수·배선)는 전사 스크립트 transcribe_product_052.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-052 전용 노드 (반칼 자유형 스티커 — 상품 전용 마스터 축)

[[product-052-sticker-halfcut-freeform]]가 연결하는 축 중, 디지털 파일럿 공유 축(axis/*)에 있는 것
(printopt-POPT_000001 단면·process-PROC_000013 라미코팅 parent·process-PROC_000014 유광라미·
process-PROC_000015 무광라미)은 재사용하고 여기 중복 신설하지 않는다(L-3). 나머지 스티커 전용
축은 아래 신설(공유 승격 후보=needed_shared_nodes).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_052.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_052.py` 재실행 시 동일 출력(멱등).

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (del_yn=N) PRD_000052 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |
|---|---|---|---|---|---|---|
| SIZ_000057 | A6 (105X148) | 105x148 | 105x148 | N | 1 | N |
| SIZ_000520 | A4(210x297mm) 반칼 | ?x? | ?x? | N | 1 | N |
| SIZ_000170 | A5(148x210mm) | 148x210 | 148x210 | Y | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (del_yn=N) PRD_000052 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 평량(g) | dflt | disp | usage |
|---|---|---|---|---|---|---|---|
| MAT_000584 | 유포스티커 80g | MAT_TYPE.11 | MAT_000153 | ? | Y | 1 | USAGE.07 |
| MAT_000585 | 무광코팅스티커 (아트지 90g + 무광라미네이팅) | MAT_TYPE.11 | MAT_000155 | ? | Y | 4 | USAGE.07 |
| MAT_000586 | 유광코팅스티커 (아트지 90g +유광라미네이팅) | MAT_TYPE.11 | MAT_000156 | ? | Y | 5 | USAGE.07 |
| MAT_000609 | 미색스티커 (모조 80g) | MAT_TYPE.11 | MAT_000242 | ? | N | 2 | USAGE.07 |
| MAT_000611 | 아트스티커 90g | MAT_TYPE.11 | MAT_000610 | ? | Y | 3 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes (del_yn=N) PRD_000052 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000014 | 유광라미네이팅 | PROC_000013 | N | 3 |
| PROC_000015 | 무광라미네이팅 | PROC_000013 | N | 2 |
| PROC_000122 | 반칼커팅 | PROC_000121 | Y | 1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000052 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (del_yn=N) PRD_000052 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | dflt_plt | note |
|---|---|---|---|
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 | Y |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000052 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_STK_FIXED | COMP_STK_PRINT | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components (use_dims·prc_typ) PRD_000052 @ 2026-07-03 -->
| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|
| COMP_STK_PRINT | 스티커 완제품가(소재·규격) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | `["siz_cd", "mat_cd", "min_qty"]` |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT 행수요약 (052 활성 siz×mat·값 나열 아님·D-22 접기) PRD_000052 @ 2026-07-03 -->
| siz_cd | mat_cd | 단가행수 |
|---|---|---|
| SIZ_000057 | MAT_000584 | 36 |
| SIZ_000057 | MAT_000585 | 36 |
| SIZ_000057 | MAT_000586 | 36 |
| SIZ_000057 | MAT_000609 | 36 |
| SIZ_000057 | MAT_000611 | 36 |
| SIZ_000170 | MAT_000584 | 36 |
| SIZ_000170 | MAT_000585 | 36 |
| SIZ_000170 | MAT_000586 | 36 |
| SIZ_000170 | MAT_000609 | 36 |
| SIZ_000170 | MAT_000611 | 36 |
| SIZ_000520 | MAT_000584 | 36 |
| SIZ_000520 | MAT_000585 | 36 |
| SIZ_000520 | MAT_000586 | 36 |
| SIZ_000520 | MAT_000609 | 36 |
| SIZ_000520 | MAT_000611 | 36 |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items PRD_000052 @ 2026-07-03 -->
**OPT_000006 종이** (sel=SEL_TYPE.01·min/max=1/1·mand=Y·disp=1)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV_000017 | 유포스티커 | Y | OPT_REF_DIM.03 | MAT_000584 | USAGE.07 |
| OPV_000018 | 아트스티커 | N | OPT_REF_DIM.03 | MAT_000611 | USAGE.07 |
| OPV_000019 | 무광코팅스티커 | N | OPT_REF_DIM.03 | MAT_000585 | USAGE.07 |
| OPV_000020 | 유광코팅스티커 | N | OPT_REF_DIM.03 | MAT_000586 | USAGE.07 |
| OPV_000021 | 미색스티커 | N | OPT_REF_DIM.03 | MAT_000609 | USAGE.07 |

**OPT_000007 인쇄** (sel=SEL_TYPE.01·min/max=1/1·mand=Y·disp=2)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV_000022 | 단면 | Y | OPT_REF_DIM.06 | 1 |  |

**OPT_000008 커팅** (sel=SEL_TYPE.01·min/max=1/1·mand=Y·disp=4)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV_000023 | 반칼(자유형) | Y | OPT_REF_DIM.04 | PROC_000054 |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) 연당가 대조 (052 활성 자재가 260702 substantive 연당가 변경 대상인가·pack §4-A) PRD_000052 @ 2026-07-03 -->
| mat_cd | 자재명 | 상위 | substantive 연당가 변경? |
|---|---|---|---|
| MAT_000584 | 유포스티커 80g | MAT_000153 | NO(N2 라벨 or 무변) |
| MAT_000585 | 무광코팅스티커 (아트지 90g + 무광라미네이팅) | MAT_000155 | NO(N2 라벨 or 무변) |
| MAT_000586 | 유광코팅스티커 (아트지 90g +유광라미네이팅) | MAT_000156 | NO(N2 라벨 or 무변) |
| MAT_000609 | 미색스티커 (모조 80g) | MAT_000242 | NO(N2 라벨 or 무변) |
| MAT_000611 | 아트스티커 90g | MAT_000610 | NO(N2 라벨 or 무변) |

<!-- transcribed-by: _meta/scripts/transcribe_product_052.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000052 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|
| 8 | 10000 | 8 | QTY_UNIT.02 | PRD_TYPE.01 | Y | N | Y | N |

---

## 카테고리 (category) — 스티커 전용 2행 (공유 축 미등재 → 승격 후보)

---

## 사이즈 (size) — 반칼 자유형 스티커 전용 3행

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 판걸이수(UP수)는 사이즈 컬럼이 아니라
파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]). SIZ_000057 note "판걸이=8.0"·SIZ_000520
note "판걸이=2.0"는 라이브 사이즈 note 실측(전사표 근거)이나 판걸이수 산정 자체는 엔진 함수 소관.

---

## 자재 (material) — 반칼 자유형 스티커 전용 5종 (전부 MAT_TYPE.11 점착지)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). 정답 자재유형 = MAT_TYPE.11(스티커).
구 부모코드(153/155/156/242)는 06-30~07-01 자식코드로 재키잉되며 052 product_materials에서
논리삭제·자식이 활성(COMP_STK_PRINT 격자도 자식코드로 재키잉). ★[HARD] IMPORT 시트 등록 자재는
"배선 안 됐다"고 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 반칼 자유형 스티커 전용 1종 (라미 013/014/015는 공유 재사용)

반칼 자유형 스티커 라우트 = 반칼커팅(PROC_000122·mand) + 유광/무광 라미(014/015·opt·코팅). 라미
공정 013(parent)/014/015는 공유 axis/processes에 실재 → 재사용(중복 신설 금지). 반칼커팅 PROC_000122만
스티커 전용 신설.

---

## 판형 (plate_size) — 46계열 출력용지 (공유 축 미등재 → 승격 후보)

판형 = 출력용지규격(작업사이즈 아님·고객 미선택·`fn_best_plate` 자동선택·종이류만 유효·
[[rule/rules#RULE_plate_paper_only]]). 스티커 점착지=종이류 → 판형 대상. 052 판형=46계열(국전 아님).

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-052] 반칼 자유형 스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000052
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000052 min_qty/max_qty/qty_incr(8/10000/8·QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(상품 8/10000/8)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 8·max 10000·incr 8·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4). ★수량구간 단가(min_qty)는 완제품가 격자(COMP_STK_PRINT)의 가격 차원이고 수량 UI 규칙과 역할 분리(가격구간≠주문 수량규칙).

---

## 가격공식·구성요소 (스티커 첫 상품 — 상품-local mint·needed_shared_node)

스티커 = 완제품가 고정가 룩업(원자합산형 아님·팩 §3.10). 디지털 공유 공식(PRF_DGP_*)과 다르므로
스티커 전용 공식/구성요소를 여기 신설(6,498행 완제품가를 공유하는 16 스티커 향후 승격 후보).

---

## 옵션그룹 (CPQ) — 3그룹 전부 택1 필수

옵션 = 자재/공정/도수 BUNDLE(팩 §3.9). 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 차원에 실재 필수
(`fn_chk_opt_item_ref` 트리거·L-18). 종이·인쇄 그룹은 정합·커팅 그룹은 매달린 참조(GAP).

### [optgroup-052-paper] 종이(자재) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000052
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000052,OPT_000006) opt_grp_nm=종이·sel_typ=SEL_TYPE.01·min/max=1/1·mand=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000052,OPT_000006) 종이 택1 필수·SEL_TYPE.01·mand_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 그룹 OPT_000006 옵션값 5(OPV_017/018/019/020/021)·전부 OPT_REF_DIM.03(자재)+usage USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", items: "유포584·아트611·무광585·유광586·미색609"}
- rel: {rel: option_refs, target: material-MAT_000584, note: "유포스티커(OPV_000017·ref_key1=MAT_000584·dflt)"}
- rel: {rel: option_refs, target: material-MAT_000611, note: "아트스티커(OPV_000018·ref_key1=MAT_000611)"}
- rel: {rel: option_refs, target: material-MAT_000585, note: "무광코팅스티커(OPV_000019·ref_key1=MAT_000585)"}
- rel: {rel: option_refs, target: material-MAT_000586, note: "유광코팅스티커(OPV_000020·ref_key1=MAT_000586)"}
- rel: {rel: option_refs, target: material-MAT_000609, note: "미색스티커(OPV_000021·ref_key1=MAT_000609)"}
- 본문: 5 옵션값이 052 활성 자재 5종을 1:1로 가리킨다(전부 부모 has_material에 실재 → L-18 정합). 코팅(무광/유광)이 여기 종이 옵션값으로 흡수됨=BATCH-3 CONFLICT의 자재측([[gap-052-coating-conflict]]).

### [optgroup-052-print] 인쇄(도수) 택1 필수 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000052
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000052,OPT_000007) opt_grp_nm=인쇄·min/max=1/1·mand=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_grp OPT_000007 옵션값 1(OPV_000022 단면)·OPT_REF_DIM.06 ref_key1=1(opt_id 1=POPT_000001)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", items: "단면 단일", note: "GAP-HIDDEN 후보(단일값 필수 그룹·C-S1)"}
- rel: {rel: option_refs, target: printopt-POPT_000001, note: "단면(OPV_000022·OPT_REF_DIM.06 ref_key1=1=opt_id→POPT_000001)"}
- 본문: 도수 옵션값 1개(단면)가 부모 has_print_option(POPT_000001)을 가리킨다(L-18 정합). 단일값 필수 그룹=사실상 고정(선택폭 없음·C-S1 GAP-HIDDEN 후보).

### [optgroup-052-cut] 커팅(공정) 택1 필수 {candidate}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000052
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000052,OPT_000008) opt_grp_nm=커팅·min/max=1/1·mand=Y·note:커팅(공정) 택1 필수 반칼 PROC_000054", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "opt_grp OPT_000008 옵션값 1(OPV_000023 반칼자유형)·OPT_REF_DIM.04 ref_key1=PROC_000054(★활성 공정 아님)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "Y", items: "반칼(자유형)", note: "★option_refs 미배선(대상 PROC_000054가 부모 활성 공정 아님=매달린 참조) → [[gap-052-cut-optref-dangling]]. badge=candidate(참조 정합 미확정)"}
- 본문: 커팅 옵션값(반칼 자유형)이 OPT_REF_DIM.04 ref_key1=PROC_000054를 가리키는데, 052 활성 공정은 이관된 PROC_000122다(PROC_000054는 052에서 del_yn=Y). fn_chk_opt_item_ref 정합 위반 신호라 **option_refs 엣지를 청정 배선하지 않고** GAP으로 정직 선언(같은 부모 차원 미실재 → L-18 위반 회피). 그룹 자체는 has_option_group으로 상품과 연결(고아 아님).

---

## 정직 GAP (원천 부재·미해소 CONFLICT·범위 밖)

### [gap-052-coating-conflict] 코팅 = 자재 vs 공정 미해소 (BATCH-3·Q-ST-A) {unknown}
- type: gap
- anchor: none  # 사유: 라이브 코팅=자재(585/586) + 공정(014/015) 이중 표현 vs Q9 코팅=공정 vs 260702 가격표 코팅=가격컬럼축 — 3원천 CONFLICT 미해소(정답 단정 불가)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 052 무광코팅 MAT_000585·유광코팅 MAT_000586(자재측)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 052 PROC_000014 유광라미·PROC_000015 무광라미(공정측·opt)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9·T-4·§0 특성3(코팅 자재 오적재 BATCH-3 CONFLICT 미해소·단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "반칼 자유형 스티커 코팅이 라이브에서 자재(무광 585·유광 586 종이 옵션값)와 공정(유광라미 014·무광라미 015 opt)으로 이중 표현됨. 실무진 Q9 권위=코팅=공정(PROC_000013). 260702 가격표=코팅을 가격컬럼축(비코팅/무광/유광)으로 취급(자재 흡수 지지). 어느 것이 정답 모델인지 미해소(양립 곤란)"
- gap_fill_from: "실무진 Q-ST-A(코팅=공정 통일 여부·BATCH-3) + §31 제약/모델링 하네스 결정. 권위 순서상 260702 가격표(top)는 가격컬럼축=자재측을 지지, SOT Q9는 공정측 — 상충"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000585, note: "코팅 자재측(무광)"}
- rel: {rel: references, target: material-MAT_000586, note: "코팅 자재측(유광)"}
- rel: {rel: references, target: process-PROC_000014, note: "코팅 공정측(유광라미)"}
- rel: {rel: references, target: process-PROC_000015, note: "코팅 공정측(무광라미)"}
- 본문: 팩 §3.9/T-4 지침대로 양면(자재/공정) 둘 다 기록·단정 금지. 라이브가 이중 표현이라 evaluate_price에서 코팅비 이중 가산 위험도 관찰 대상(값 판정은 엔진 소관). 어느 표현도 삭제 금지(재모델링 워크리스트).

### [gap-052-cut-optref-dangling] 커팅 옵션참조 PROC_000054 매달림 (fn_chk_opt_item_ref) {unknown}
- type: gap
- anchor: none  # 사유: 커팅 옵션값 OPV_000023이 삭제된 PROC_000054를 참조·활성 공정 PROC_000122 미참조 — 옵션참조 정합 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 키:(PRD_000052,OPV_000023) ref_dim_cd=OPT_REF_DIM.04·ref_key1=PROC_000054", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 052 활성 커팅=PROC_000122(PROC_000054는 del_yn=Y)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "커팅 옵션그룹(OPT_000008)의 반칼 옵션값(OPV_000023)이 OPT_REF_DIM.04 ref_key1=PROC_000054를 가리키나, 052 활성 커팅 공정은 이관된 PROC_000122다(PROC_000054는 052 product_processes에서 del_yn=Y). 옵션참조가 부모 활성 차원에 미실재(fn_chk_opt_item_ref 정합 위반 신호)"
- gap_fill_from: "옵션참조 ref_key1을 PROC_000054→PROC_000122로 재키잉(§27 배선/§31 소관)·라이브 교정 인간 승인 후 dbmap"
- gap_owner: 개발
- rel: {rel: references, target: optgroup-052-cut, note: "이 그룹의 매달린 옵션참조"}
- rel: {rel: references, target: process-PROC_000122, note: "재키잉 대상(활성 반칼커팅)"}
- 본문: 반칼 커팅 공정 이관(PROC_000054→122) 시 옵션참조 ref_key1이 함께 갱신되지 않아 매달린 참조가 남음. 청정 option_refs 엣지를 만들지 않고(부모 차원 미실재·L-18 회피) 정직 GAP으로 선언. 교정은 라이브 소관.

### [gap-052-liandan-out-of-scope] 소재 연당가 재적재 — 052 범위 밖 (돈-크리티컬 워크리스트 포인터) {unknown}
- type: gap
- anchor: none  # 사유: 260702 substantive 연당가 대개편(투명/홀로/크라프트/투명후지)은 052 소재(유포/아트/미색/코팅)와 무관 — 052 완제품가는 260702 무변경(dual 금지·false-defect 방지)
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "문서:연당가 substantive 변경=투명(149,500)/홀로(253,700)/크라프트(81,500)/투명후지(신규 222,000)·052 소재는 N2 라벨 or 무변만", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-A/§4-B/§4-D(연당가 양면 노드는 원가/속성 축 국한·retail 완제품가 dual 금지·052 소재 무관)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "팩 §4-A 돈-크리티컬 연당가/국4절가 대개편은 투명스티커(백색후지)·홀로그램·크라프트·투명스티커(투명후지) 4소재 몫이다. 052(반칼 자유형)는 유포/아트/미색/무광코팅/유광코팅만 써서 이 4소재 무관(전사표 연당가 대조 전행 NO). 052 완제품가(COMP_STK_PRINT)도 260702 무변경 → 052에는 연당가 양면 defect 노드 없음(false-defect 방지). 단 4소재 연당가는 라이브 저장처 부재(원가 미저장·MAT_000162 명/평량 stale)로 재적재 대기 — 이 워크리스트는 투명 베이스 스티커(063 반칼팬시투명 등) 노드에서 양면 defect로 표기해야 함"
- gap_fill_from: "063 등 투명/홀로/크라프트 사용 스티커 상품 노드에서 4소재 양면 노드(current=원가미저장/MAT_000162 평량105·명 구값 vs authority=260702 연당가 149,500 등) 신설. 소재 원가 저장처 신설 여부는 실무진+인간 승인(§4-D 돈-크리티컬)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "052 완제품가=260702 무변경(retail dual 금지)"}
- 본문: 052는 연당가 관점에서 clean(재적재 대상 아님)임을 정직 선언하고, 진짜 연당가 워크리스트(투명/홀로/크라프트/투명후지)가 어느 상품에서 다뤄져야 하는지 포인터를 남긴다. 팩 §4-D "retail 노드 dual 금지·양면은 원가/속성 축 국한" 준수.
