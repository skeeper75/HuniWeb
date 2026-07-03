<!-- companion nodes for product-064 소량자유형스티커 — 064 전용 마스터 노드(공유 축·피어 companion에 없는 것만 신설). -->
<!-- ★공유 파일(index.md·axis/*·formula/*·rule/*) 수정 금지. 스티커 공유 노드는 피어 companion/axis에 이미 실재 → 재사용(재-mint 없음·053 halfcut-clear 패턴). -->
<!-- ★재사용(중복 신설 금지·L-3): category-CAT_000002/309(052 companion)·material-MAT_000153/084/242/155/156(spec-rectangle-nodes)·process-PROC_000054(halfcut-hologram-nodes)·plate-OUTPUT_PAPER_TYPE_02(052 companion)·printopt-POPT_000001(axis/print-options)·formula-PRF_STK_FIXED·component-COMP_STK_PRINT(다수 정의)·size-SIZ_000043(product-045)·size-SIZ_000036(product-043). -->
<!-- ★064 전용 신설: size-SIZ_000061/062/063/064/065(064만 사용)·qty-064·gap 3(cpq-missing·coating-conflict·liandan-out-of-scope). -->
<!-- ★수치(치수·사양·단가행수·행수·부재)는 전사 스크립트 transcribe_product_064.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-064 전용 노드 (소량자유형스티커 — 상품 전용 마스터 축)

[[sticker-smallqty-freeform]]가 연결하는 축 중, 스티커 공유 노드(카테고리·자재·공정·판형·공식·구성요소·
043/036 사이즈)는 피어 companion/axis에 이미 실재 → 재사용하고 여기 중복 신설하지 않는다(L-3). 064
전용으로 새로 필요한 것은 **소형 사이즈 5행(061~065·live에서 064만 사용)·수량규칙·GAP 3**뿐이다.

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 `_meta/scripts/transcribe_product_064.py`가 live-snapshot에서 결정론 전사(손전사 아님).
> `python3 transcribe_product_064.py` 재실행 시 동일 출력(멱등·md5 검증). note 셀의 `|`는 `/`로 치환(표 보호).

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (del_yn=N) PRD_000064 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn | note(라이브) |
|---|---|---|---|---|---|---|---|
| SIZ_000061 | 50x70 | 50x70 | 50x70 | Y | 1 | N | 판걸이=32.0 / 전지=미지정 / 적용=소형반칼스티커 |
| SIZ_000062 | 70x50 | 70x50 | 70x50 | Y | 1 | N | 판걸이=32.0 / 전지=미지정 / 적용=소형반칼스티커 |
| SIZ_000063 | 50x94 | 50x94 | 50x94 | Y | 1 | N | 판걸이=24.0 / 전지=미지정 / 적용=소형반칼스티커 |
| SIZ_000064 | 94x50 | 94x50 | 94x50 | Y | 1 | N | 판걸이=24.0 / 전지=미지정 / 적용=소형반칼스티커 |
| SIZ_000065 | 65x65 | 65x65 | 65x65 | Y | 1 | N | 판걸이=24.0 / 전지=미지정 / 적용=소형반칼스티커 |
| SIZ_000043 | 80x80 | 84x84 | 80x80 | Y | 1 | N | 판걸이=15.0 / 전지=316x467 / 적용=인쇄해더택 |
| SIZ_000036 | 94x94 | 98x98 | 94x94 | Y | 1 | N | 판걸이=12.0 / 전지=316x467 / 적용=인쇄배경지 |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials (del_yn=N) PRD_000064 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위 | 평량(g) | dflt | disp | usage | note(라이브) |
|---|---|---|---|---|---|---|---|---|
| MAT_000153 | 유포스티커 | MAT_TYPE.11 |  | 80 | Y | 1 | USAGE.07 |  |
| MAT_000084 | 비코팅스티커 | MAT_TYPE.13 |  | 90 | Y | 1 | USAGE.07 | / 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000242 | 미색스티커 | MAT_TYPE.11 |  | ? | Y | 1 | USAGE.07 | / 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000155 | 무광코팅스티커 | MAT_TYPE.11 |  | 90 | Y | 1 | USAGE.07 |  |
| MAT_000156 | 유광코팅스티커 | MAT_TYPE.11 |  | 90 | Y | 1 | USAGE.07 |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes (del_yn=N) PRD_000064 @ 2026-07-03 -->
| proc_cd | 공정명 | 상위공정 | mand | disp |
|---|---|---|---|---|
| PROC_000054 | 반칼 |  | N | 1 |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts PRD_000064 @ 2026-07-03 -->
| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |
|---|---|---|---|---|
| 1 | 단면 | POPT_000001 | CLR_000005(CMYK 4도) | CLR_000001(인쇄 안 함) |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes 활성 (del_yn=N) PRD_000064 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | dflt_plt | note |
|---|---|---|---|
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 | Y |  |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes 삭제분 (del_yn=Y·파일사양 정리 이력·2026-06-30) PRD_000064 @ 2026-07-03 -->
| siz_cd | output_paper_typ_cd | output_file_typ | note | del_dt |
|---|---|---|---|---|
| SIZ_000036 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000043 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000061 | OUTPUT_PAPER_TYPE.03 | PDF | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000062 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000063 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000064 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |
| SIZ_000065 |  |  | 파일사양 | 2026-06-30 08:42:39.27075 |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components PRD_000064 @ 2026-07-03 -->
| frm_cd | comp_cd | disp_seq | addtn |
|---|---|---|---|
| PRF_STK_FIXED | COMP_STK_PRINT | 1 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prc_price_components (use_dims·prc_typ) PRD_000064 @ 2026-07-03 -->
| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |
|---|---|---|---|---|
| COMP_STK_PRINT | 스티커 완제품가(소재·규격) | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | `["siz_cd", "mat_cd", "min_qty"]` |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT 행수요약 (064 활성 siz×mat=35/35 조합·값 나열 아님·D-22 접기) PRD_000064 @ 2026-07-03 -->
| siz_cd | mat_cd | 단가행수 |
|---|---|---|
| SIZ_000036 | MAT_000084 | 36 |
| SIZ_000036 | MAT_000153 | 36 |
| SIZ_000036 | MAT_000155 | 36 |
| SIZ_000036 | MAT_000156 | 36 |
| SIZ_000036 | MAT_000242 | 36 |
| SIZ_000043 | MAT_000084 | 36 |
| SIZ_000043 | MAT_000153 | 36 |
| SIZ_000043 | MAT_000155 | 36 |
| SIZ_000043 | MAT_000156 | 36 |
| SIZ_000043 | MAT_000242 | 36 |
| SIZ_000061 | MAT_000084 | 36 |
| SIZ_000061 | MAT_000153 | 36 |
| SIZ_000061 | MAT_000155 | 36 |
| SIZ_000061 | MAT_000156 | 36 |
| SIZ_000061 | MAT_000242 | 36 |
| SIZ_000062 | MAT_000084 | 36 |
| SIZ_000062 | MAT_000153 | 36 |
| SIZ_000062 | MAT_000155 | 36 |
| SIZ_000062 | MAT_000156 | 36 |
| SIZ_000062 | MAT_000242 | 36 |
| SIZ_000063 | MAT_000084 | 36 |
| SIZ_000063 | MAT_000153 | 36 |
| SIZ_000063 | MAT_000155 | 36 |
| SIZ_000063 | MAT_000156 | 36 |
| SIZ_000063 | MAT_000242 | 36 |
| SIZ_000064 | MAT_000084 | 36 |
| SIZ_000064 | MAT_000153 | 36 |
| SIZ_000064 | MAT_000155 | 36 |
| SIZ_000064 | MAT_000156 | 36 |
| SIZ_000064 | MAT_000242 | 36 |
| SIZ_000065 | MAT_000084 | 36 |
| SIZ_000065 | MAT_000153 | 36 |
| SIZ_000065 | MAT_000155 | 36 |
| SIZ_000065 | MAT_000156 | 36 |
| SIZ_000065 | MAT_000242 | 36 |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) CPQ 레이어 + 셋트/추가상품/제약/묶음수 행수 (부재 확인·064) PRD_000064 @ 2026-07-03 -->
| 레이어 | 라이브 행수 |
|---|---|
| option_groups | 0 |
| options | 0 |
| option_items | 0 |
| product_sets | 0 |
| product_addons | 0 |
| product_constraints | 0 |
| bundle_qtys | 0 |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) 연당가 대조 (064 활성 자재가 260702 substantive 연당가 변경 대상인가·pack §4-A) PRD_000064 @ 2026-07-03 -->
| mat_cd | 자재명 | 상위 | substantive 연당가 변경? |
|---|---|---|---|
| MAT_000153 | 유포스티커 |  | NO(N2 라벨 or 무변) |
| MAT_000084 | 비코팅스티커 |  | NO(N2 라벨 or 무변) |
| MAT_000242 | 미색스티커 |  | NO(N2 라벨 or 무변) |
| MAT_000155 | 무광코팅스티커 |  | NO(N2 라벨 or 무변) |
| MAT_000156 | 유광코팅스티커 |  | NO(N2 라벨 or 무변) |

<!-- transcribed-by: _meta/scripts/transcribe_product_064.py from live-snapshot/latest (snap_20260702_1119) t_prd_products (수량·상태) PRD_000064 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |
|---|---|---|---|---|---|---|---|---|
| 32 | 1000 | 32 | QTY_UNIT.02 | PRD_TYPE.01 | N | N | Y | Y |

---

## 사이즈 (size) — 소량자유형스티커 소형 전용 5행 (061~065·064만 사용 → 신설)

소형반칼 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 판걸이수(UP수)는 사이즈 컬럼이 아니라
파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]). note "판걸이=32/24"는 라이브 사이즈 note
실측(전사표 근거)이나 판걸이수 산정 자체는 엔진 함수 소관. master del_yn 전행 N(양면 defect 없음).
80x80(SIZ_000043)·94x94(SIZ_000036)는 헤더택·배경지가 공유하는 사이즈 → 기존 노드 재사용(중복 신설 안 함).

---

## 수량규칙 (bundle_qty) — 상품 레벨

### [qty-064] 소량자유형스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000064
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000064 min_qty/max_qty/qty_incr(32/1000/32·QTY_UNIT.02)·use_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(상품 32/1000/32)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 32·max 1000·incr 32·단위 "매"). ★052(8/10000/8)보다 좁은 소량대 = "소량" 상품명 정합. `t_prd_product_bundle_qtys` 0행은 정상(수량 UI 권위=상품/사이즈 규칙·팩 §3.4). 수량구간 단가(min_qty)는 완제품가 격자(COMP_STK_PRINT)의 가격 차원이고 수량 UI 규칙과 역할 분리(가격구간≠주문 수량규칙).

---

## 정직 GAP (원천 부재·미해소 CONFLICT·미출시 준비 미완)

### [gap-064-cpq-missing] CPQ 옵션 레이어 전면 부재 (BATCH-6·GAP-ST-6) {unknown}
- type: gap
- anchor: none  # 사유: 064 option_groups/options/option_items 전부 0행 — 손님이 소재·도수·커팅을 CPQ로 고를 수단 부재(미출시 use_yn=N 정합·준비 미완)
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 필터:prd_cd=PRD_000064 — 0행(options·option_items도 0행·전사표 CPQ 부재 확인)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9·[STK-ST-006] CPQ 옵션 레이어 전면 미적재(BATCH-6)·GAP-ST-6", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "소량자유형스티커(064)는 자재/공정/도수 차원이 상품에 붙어 있으나(has_material 5·has_process 1·has_print_option 1) CPQ 옵션 레이어(option_groups/options/option_items)가 전무하다(0/0/0). 형제 052는 종이/인쇄/커팅 3그룹을 가진다. 064는 손님이 소재(유포/비코팅/미색/무광코팅/유광코팅)·단면·반칼을 선택할 UI 수단이 없어 CPQ상 견적 구성이 불가(가격 격자는 충전됐으나 옵션 입력이 없음). use_yn=N(미출시)와 정합 — 준비 미완 상태"
- gap_fill_from: "BATCH-6 CPQ 옵션 레이어 일괄 적재(§7 dbmap·§31 옵션그룹 설계)·052 옵션그룹(종이 OPT_000006/인쇄 OPT_000007/커팅 OPT_000008) 구조를 064에 동형 적재. 커팅 옵션참조는 064 활성 PROC_000054를 지목하면 정합(052의 매달림과 달리 064는 PROC_000054가 활성이라 fn_chk_opt_item_ref 통과 가능). 출시 전 인간 승인 후 라이브"
- gap_owner: 개발
- rel: {rel: references, target: material-MAT_000153, note: "옵션화 대상(종이 그룹 후보)"}
- rel: {rel: references, target: process-PROC_000054, note: "커팅 옵션참조 후보(064 활성 → 정합 가능)"}
- 본문: 팩 §3.9 REVERIFY(CPQ 미적재)를 live 실측 0/0/0으로 확정. 차원(자재/공정/도수)은 실재하나 옵션 레이어가 없어 손님 구성 불가. 지어내지 않고 정직 GAP으로 선언(옵션 노드를 날조 mint하지 않음). 052 옵션 구조가 동형 적재 청사진.

### [gap-064-coating-conflict] 코팅 = 자재(material-only) vs 공정 미해소 (BATCH-3·Q-ST-A) {unknown}
- type: gap
- anchor: none  # 사유: 라이브 코팅=자재(155/156)만·공정측 라미(014/015) 없음 vs Q9 코팅=공정 vs 260702 가격표 코팅=가격컬럼축 — 3원천 CONFLICT 미해소(정답 단정 불가) <!-- lint-allow: L-12 자재/공정 코드번호(가격 아님) -->
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 064 무광코팅 MAT_000155·유광코팅 MAT_000156(자재측·공정측 라미 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 064 활성 공정=PROC_000054(반칼) 1행뿐·라미 014/015 부재(052와 달리 코팅 공정 없음)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9·T-4·§0 특성3(코팅 자재 오적재 BATCH-3 CONFLICT 미해소·단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "064 코팅이 라이브에서 자재(무광 155·유광 156 점착지)로만 표현되고 공정측(라미 014/015)은 없다(052의 자재+공정 이중 표현과 다름·material-only). 실무진 Q9 권위=코팅=공정(PROC_000013). 260702 가격표=코팅을 가격컬럼축(비코팅/무광/유광)으로 취급(자재 흡수 지지). 어느 것이 정답 모델인지 미해소(양립 곤란). 단 064는 공정측이 없어 이중가산 위험은 052보다 낮음"
- gap_fill_from: "실무진 Q-ST-A(코팅=공정 통일 여부·BATCH-3) + §31 제약/모델링 하네스 결정. 권위 순서상 260702 가격표(top)는 가격컬럼축=자재측을 지지, SOT Q9는 공정측 — 상충. 064는 material-only라 자재측 표현이 실재값"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000155, note: "코팅 자재측(무광·064는 material-only)"}
- rel: {rel: references, target: material-MAT_000156, note: "코팅 자재측(유광·064는 material-only)"}
- 본문: 팩 §3.9/T-4 지침대로 양면(자재 vs Q9 공정) 둘 다 기록·단정 금지. 064는 코팅 공정이 없어(052와 대비) 코팅비 이중가산 위험 없음이 관찰점. 어느 표현도 삭제 금지(재모델링 워크리스트).

### [gap-064-liandan-out-of-scope] 소재 연당가 재적재 — 064 범위 밖 (돈-크리티컬 워크리스트 포인터) {unknown}
- type: gap
- anchor: none  # 사유: 260702 substantive 연당가 대개편(투명/홀로/크라프트/투명후지)은 064 소재(유포/비코팅/미색/무광코팅/유광코팅)와 무관 — 064 완제품가는 260702 무변경(dual 금지·false-defect 방지)
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "문서:연당가 substantive 변경=투명/홀로/크라프트/투명후지 4소재(단가값은 팩 §4-A 표=CSV 전사 권위)·064 소재는 N2 라벨 or 무변만(전사표 연당가 대조 전행 NO)", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-A/§4-B/§4-D(연당가 양면 노드는 원가/속성 축 국한·retail 완제품가 dual 금지·064 소재 무관)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "팩 §4-A 돈-크리티컬 연당가/국4절가 대개편은 투명스티커(백색후지)·홀로그램·크라프트·투명스티커(투명후지) 4소재 몫이다. 064(소량 자유형)는 유포/비코팅/미색/무광코팅/유광코팅만 써서 이 4소재 무관(전사표 연당가 대조 전행 NO). 064 완제품가(COMP_STK_PRINT)도 260702 무변경 → 064에는 연당가 양면 defect 노드 없음(false-defect 방지). 진짜 연당가 양면 워크리스트는 투명 베이스 스티커(053 반칼투명·063 반칼팬시투명 등)의 matcost-053-* 등에서 관리"
- gap_fill_from: "053 등 투명/홀로/크라프트 사용 스티커 상품 노드의 양면 노드(matcost-053-white-backing 등·current=원가미저장/구값 vs authority=260702 연당가)가 재적재 워크리스트. 소재 원가 저장처 신설 여부는 실무진+인간 승인(§4-D 돈-크리티컬). 064는 이 축에서 clean"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "064 완제품가=260702 무변경(retail dual 금지)"}
- 본문: 064는 연당가 관점에서 clean(재적재 대상 아님)임을 정직 선언하고, 진짜 연당가 워크리스트(투명/홀로/크라프트/투명후지)가 053/063 등에서 다뤄짐을 포인터로 남긴다. 팩 §4-D "retail 노드 dual 금지·양면은 원가/속성 축 국한" 준수 → 064 dual_nodes=0.

---

## 재사용 노드 관찰 (여기 재정의 금지·L-3) — MAT_000084 유형 드리프트

MAT_000084(비코팅스티커)는 spec-rectangle-nodes.md에 `[material-MAT_000084] {candidate} (유형 관찰)`로
이미 정의된 공유 노드다. 064 전사표 실측 = `mat_typ_cd=MAT_TYPE.13`인데 note는 "정정 종이(.01)→
스티커(.11)"로 **.11을 선언**(필드 .13 ≠ note .11·팩 §3.5 정답 .11). 여기서 재정의하지 않고(중복 id 금지)
관찰만 인계 — 재적재 시 유형 정합(.13→.11) 대상. 이 결함은 064 전용이 아니라 공유 자재 속성이라
material-MAT_000084 노드(candidate) 소관. 064는 이 자재를 소비(uses_material)만 한다.
