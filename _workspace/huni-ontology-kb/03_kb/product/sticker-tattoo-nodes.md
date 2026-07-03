<!-- companion nodes for sticker-tattoo 타투스티커(PRD_000067) — 공유 축(axis/*·formula/*·rule/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*·rule/*에 없는 것만 여기 신설(052 방식). -->
<!-- ★재사용(중복 mint 금지·L-3): category-CAT_000002(052 등 정의)·printopt-POPT_000001(axis/print-options)·plate-OUTPUT_PAPER_TYPE_03(030 정의)·RULE_*(rule/rules)는 참조만 → needed_shared_nodes 반환. -->
<!-- ★수치(치수·사양·단가행수·배선)는 전사 스크립트 transcribe_sticker_tattoo.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# sticker-tattoo 전용 노드 (타투스티커 — 상품 전용 마스터 축)

[[sticker-tattoo]]가 연결하는 축 중, 공유 축(axis/*·formula/*)에 있는 것(printopt-POPT_000001 단면·
plate-OUTPUT_PAPER_TYPE_03 기타 출력용지·category-CAT_000002 스티커 root)은 재사용하고 여기 중복
신설하지 않는다(L-3). 타투스티커 전용(전사 계열·합가형·특수스티커 sub·1사이즈·1자재·용지 옵션 1)
축은 아래 신설(공유 승격 후보=needed_shared_nodes).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_sticker_tattoo.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_sticker_tattoo.py` 재실행 시 동일 출력(멱등). 캐시=`cache/transcribed-sticker-tattoo-260703.json`.

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories PRD_000067 @ 2026-07-03 -->
| cat_cd | 이름 | lvl | 상위 | main |
|---|---|---|---|---|
| CAT_000002 | 스티커 | 1 |  | Y |
| CAT_000311 | 특수스티커 | 2 | CAT_000002 | N |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (del_yn=N) PRD_000067 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |
|---|---|---|---|---|---|---|
| SIZ_000060 | 90x190 | 94x194 | 90x190 | Y | 1 | N |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (활성+은퇴·재키잉 167->594 문서화) PRD_000067 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 평량(g) | junction_del | dflt | disp | usage |
|---|---|---|---|---|---|---|---|---|
| MAT_000594 | 타투스티커 | MAT_TYPE.11 | MAT_000167 | ? | N | Y | 1 | USAGE.07 |
| MAT_000167 | 타투전용지 | MAT_TYPE.11 |  | ? | Y | Y | 1 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes (067 = 0행·순수 인쇄물·커팅 없음) PRD_000067 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| (없음) | 타투스티커=순수 인쇄물(전사 계열)·커팅/라미 공정 0행 | — | — | — |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000067 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes (del_yn=N) PRD_000067 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | dflt_plt | note |
|---|---|---|---|
| SIZ_000050 | OUTPUT_PAPER_TYPE.03 | Y |  |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000067 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_STK_TATTOO | COMP_STK_TATTOO | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components (use_dims·prc_typ) PRD_000067 @ 2026-07-03 -->
| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|
| COMP_STK_TATTOO | 타투스티커 완제품가(3장세트) | PRICE_TYPE.02 | PRC_COMPONENT_TYPE.06 | `["siz_cd", "mat_cd", "min_qty"]` |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_TATTOO 행수요약 (067 siz×mat·값 나열 아님·D-22 접기) PRD_000067 @ 2026-07-03 -->
| siz_cd | mat_cd | 단가행수 | 역할 |
|---|---|---|---|
| SIZ_000060 | MAT_000167 | 333 | 레거시(구 자재코드·룩업 미노출) |
| SIZ_000060 | MAT_000594 | 333 | 활성(옵션 노출) |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups+options+option_items PRD_000067 @ 2026-07-03 -->
**OPT-000042 용지** (sel=SEL_TYPE.01·min/max=0/1·mand=N·disp=1)
| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|---|---|
| OPV-000088 | 타투스티커 | N | OPT_REF_DIM.03 | MAT_000594 | USAGE.07 |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) 연당가 대조 (067 자재가 260702 substantive 연당가 변경 대상인가·pack §4-A) PRD_000067 @ 2026-07-03 -->
| mat_cd | 자재명 | 상위 | substantive 연당가 변경? |
|---|---|---|---|
| MAT_000594 | 타투스티커 | MAT_000167 | NO(diff에 타투 0행·무관) |
| MAT_000167 | 타투전용지 |  | NO(diff에 타투 0행·무관) |

<!-- transcribed-by: _meta/scripts/transcribe_sticker_tattoo.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000067 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|
| 3 | 1000 | 3 | QTY_UNIT.02 | PRD_TYPE.01 | Y | N | Y | N |

---

## 카테고리 (category) — 특수스티커 sub 1행 (CAT_000002는 재사용)

스티커 root(CAT_000002)는 052 등이 이미 정의 → 재사용(참조만·중복 mint 금지·L-3). 067 sub는 052의
자유형스티커(CAT_000309)와 다른 **특수스티커(CAT_000311)** 라 여기 신설.

---

## 사이즈 (size) — 타투스티커 전용 1행

타투 사이즈 = 단일 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 판걸이수(UP수)는 사이즈 컬럼이 아니라
파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]). SIZ_000060 note "판걸이=6.0"은 라이브
사이즈 note 실측(전사표 근거)이나 판걸이수 산정 자체는 엔진 함수 소관.

---

## 자재 (material) — 타투스티커 전용 1종 (MAT_TYPE.11 점착지·재키잉 167→594)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). 067 활성 자재 = 타투스티커 MAT_000594
(자식·상위 MAT_000167). 구 부모 타투전용지 MAT_000167은 06-03 원 자재였으나 07-01 067
product_materials에서 논리삭제되고 자식 594로 재키잉(COMP_STK_TATTOO 격자도 594행 실재). ★[HARD]
IMPORT 시트 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-067] 타투스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000067
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000067 min_qty/max_qty/qty_incr(3/1000/3·QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(상품 3/1000/3)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "★3장 단위(incr 3)=타투 '3장 1세트' 판매단위·수량 UI 규칙(주문)이지 가격 격자(min_qty)와 역할 분리"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 3·max 1000·incr 3·단위 "매"). `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4). ★수량구간 단가(min_qty)는 완제품가 격자(COMP_STK_TATTOO)의 가격 차원(3장세트 합가형)이고 수량 UI 규칙과 역할 분리(가격구간≠주문 수량규칙).

---

## 가격공식·구성요소 (타투 전용 — 상품-local mint·needed_shared_node)

타투 = 완제품가 합가형 룩업(원자합산형 아님·팩 §3.10). 052 스티커 고정가 공식(PRF_STK_FIXED/
COMP_STK_PRINT·PRICE_TYPE.01)과 다른 **합가형 .02** 공식이라 타투 전용 공식/구성요소를 여기 신설
(향후 타투/전사 계열 승격 후보).

---

## 옵션그룹 (CPQ) — 용지 1그룹 (택1 선택·mand=N)

옵션 = 자재 BUNDLE(팩 §3.9). 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 차원에 실재 필수
(`fn_chk_opt_item_ref` 트리거·L-18). 067 용지 옵션은 활성 자재 MAT_000594를 가리켜 정합(052 커팅
매달린 참조 같은 결함 없음).

### [optgroup-067-paper] 용지(자재) 택1 선택 {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000067
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000067,OPT-000042) opt_grp_nm=용지·sel_typ=SEL_TYPE.01·min/max=0/1·mand=N·disp 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:(PRD_000067,OPT-000042) 용지 택1 선택·mand_yn=N·min_sel 0·07-01 신코드", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_items.csv", source_locator: "테이블:t_prd_product_option_items 그룹 OPT-000042 옵션값 1(OPV-000088 타투스티커)·OPT_REF_DIM.03 ref_key1=MAT_000594·ref_key2=USAGE.07", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {sel_typ_cd: "SEL_TYPE.01", mand: "N", min_sel: 0, items: "타투스티커→MAT_000594", note: "★052(종이/인쇄/커팅 3그룹·mand=Y)와 달리 용지 1그룹만·mand=N(선택 필수 아님·단일 자재라 사실상 고정)·GAP-HIDDEN 후보(단일값 그룹)"}
- rel: {rel: option_refs, target: material-MAT_000594, note: "타투스티커(OPV-000088·ref_key1=MAT_000594·활성 자재·부모 has_material 실재→L-18 정합)"}
- 본문: 1 옵션값이 067 활성 자재 MAT_000594를 가리킨다(부모 has_material 실재 → L-18 정합·fn_chk_opt_item_ref 준수). mand=N·min_sel 0이라 손님이 안 골라도 dflt 자재로 진행(단일 자재라 선택폭 없음·C-S1 GAP-HIDDEN 후보). 052 커팅 옵션의 매달린 참조(삭제된 PROC_000054 지목) 같은 결함 없음.

---

## 정직 GAP (원천 부재·열린 질문·범위 밖)

### [gap-067-mattype-transfer-paper] 타투전용지 자재유형 .11 vs .01 열린 질문 (표본 컨펌) {unknown}
- type: gap
- anchor: none  # 사유: live 067 자재=MAT_TYPE.11(스티커) vs 팩 §3.5 "타투전용지(전사)=종이 .01 정당 가능(표본 컨펌)" — 260702 권위가 .01 미확정이라 정답 단정 불가(양면 아님·firm authority_value 부재)
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000594/MAT_000167 mat_typ_cd=MAT_TYPE.11(현재값)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.5 GAP '타투전용지(전사·067)=종이(.01) 정당 가능(표본 컨펌)'", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "타투전용지/타투스티커(MAT_000167/594)가 라이브에서 MAT_TYPE.11(스티커 점착지)로 적재됐으나, 팩 §3.5는 전사(열전사) 타투전용지가 종이(.01)일 수 있다고 열어둠(표본 컨펌 필요). 두 값 중 어느 것이 정답 자재유형인지 미확정"
- gap_fill_from: "실무진 표본 컨펌(전사 타투전용지의 물성=점착지인가 종이인가). 260702 권위에 확정 없음 → firm authority_value 부재라 양면 defect 대신 GAP. 현재값 .11 채택(단정 금지)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000594, note: "자재유형 미확정 대상(활성)"}
- 본문: current(.11)만 라이브에 실재하고 authority(.01)는 "정당 가능" 수준의 열린 가설이라 양면 노드(current_value/authority_value 둘 다 firm) 요건을 못 채운다(L-9 회피). 정직 GAP으로 표기하고 현재값 .11 채택. 표본 컨펌 후 .01 확정되면 그때 교정(라이브 소관·인간 승인).

### [gap-067-liandan-out-of-scope] 소재 연당가 재적재 — 067 범위 밖 (돈-크리티컬 워크리스트 포인터) {unknown}
- type: gap
- anchor: none  # 사유: 260702 substantive 연당가 대개편(투명/홀로/크라프트/투명후지)은 067 소재(타투전용지/타투스티커)와 무관 — price-diff에 "타투" 0행·067 완제품가는 260702 무변경(dual 금지·false-defect 방지)
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "문서:출력소재(IMPORT) 연당가 substantive 변경행=투명스/홀로그램/크라프트/투명투(신규)·'타투' 소재 diff 0행(무관)·구체 단가는 diff L19~33 및 pack §4-A", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-A/§4-B/§4-D(연당가 양면 노드는 원가/속성 축 국한·retail 완제품가 dual 금지·067 타투 소재 무관)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
<!-- lint-allow: L-12 src=SR-2.2-diff 연당가/국4절=권위 인용(067 무관 포인터·양면 아님) -->
- gap_what: "팩 §4-A 돈-크리티컬 연당가/국4절가 대개편은 투명스티커(백색후지)·홀로그램·크라프트·투명스티커(투명후지) 4소재 몫이다. 067(타투)은 타투전용지/타투스티커만 써서 이 4소재 무관(price-diff에 타투 0행·전사표 연당가 대조 전행 NO). 067 완제품가(COMP_STK_TATTOO)도 260702 무변경 → 067에는 연당가 양면 defect 노드 없음(false-defect 방지). 진짜 연당가 워크리스트는 투명/홀로/크라프트 베이스 스티커(053 반칼투명·054 홀로 등) 노드에서 양면 defect로 표기됨"
- gap_fill_from: "053/054 등 투명/홀로/크라프트 사용 스티커 상품 노드의 4소재 양면 노드(matcost-053-*·matcost-054-* 등·current=원가미저장 vs authority=260702 연당가)가 재적재 워크리스트. 소재 원가 저장처 신설 여부는 실무진+인간 승인(§4-D 돈-크리티컬). 067은 이 워크리스트 밖(clean)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_TATTOO, note: "067 완제품가=260702 무변경(retail dual 금지)"}
- 본문: 067은 연당가 관점에서 clean(재적재 대상 아님)임을 정직 선언하고, 진짜 연당가 워크리스트(투명/홀로/크라프트/투명후지)가 어느 상품에서 다뤄지는지 포인터를 남긴다. 팩 §4-D "retail 노드 dual 금지·양면은 원가/속성 축 국한" 준수. 067에 억지 양면 노드 신설 시 false-defect(팩 명시 금지).
