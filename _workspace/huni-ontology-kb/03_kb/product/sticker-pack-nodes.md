<!-- product-local sub-nodes: E2 category·E3 size·E9 price_formula·E10 price_component·E8 qty·gap for PRD_000065 스티커팩. -->
<!-- ★공유 노드(category-CAT_000002·material-MAT_000084/242·printopt-POPT_000001·plate-OUTPUT_PAPER_TYPE_02)는 -->
<!--   이미 존재(spec-rectangle-nodes·axis/print-options·052-nodes)라 재정의 금지 — [[sticker-pack]]가 relation으로 재사용. -->
<!-- ★category-CAT_000312·size-SIZ_000068·formula-PRF_STK_PACK·component-COMP_STK_PACK은 신규(어디에도 미정의)라 여기 product-local mint. -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관 — index_entries/needed_shared로 반환. -->
<!-- ★수치(치수·평량·연당가·단가행)는 아래 "전사표" 섹션(transcribed-by 스크립트) 또는 노드 field에만(손전사 금지). -->

# sticker-pack 하위 노드 (스티커팩 PRD_000065 전용 축 원자)

스티커팩(PRD_000065)이 쓰는 카테고리 1(스티커팩)·사이즈 1(75x110)·공식 1(합가형)·구성요소 1(팩 완제품가)·
수량 1·GAP 5. (스티커 root 카테고리·비코팅/미색 자재·단면 인쇄옵션·46전지 판형은 이미 존재해 재사용.)
상품→축 연결(in_category·has_size·uses_material·has_print_option·has_plate_size·has_qty_rule·priced_by·references)은
[[sticker-pack]]가 건다. 수치 원본은 아래 전사표(transcribed-by)가 권위.

## 카테고리 노드 (product-local — 축 승격 대기)

## 사이즈 노드 (product-local — 축 승격 대기)

## 가격공식 노드 (product-local·스티커 합가형 첫 등재)

## 가격구성요소 노드 (완제품가 합가형·단가행 접기 D-22)

## 수량 노드

### [qty-065] 스티커팩 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000065
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000065(min_qty=1·max_qty=1000·qty_incr=1·qty_unit_typ_cd=QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 수량규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표 수량규칙(상품 1/1000/1)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행. ★단 가격 격자는 min_qty=54 필수(합가형 54장1세트) — 제품 수량단위(1~1000)와 가격 밴드(54)의 관계는 [[gap-065-pack-qty-band]](evaluate_price 소관). 수량 UI 권위=상품 규칙([[rule/decisions#DEC_qty_audit_260702]])"}
- 본문: 수량 그릇 = 상품 마스터 컬럼(min 1·max 1000·incr 1·QTY_UNIT.02). 사이즈별 오버라이드·bundle_qtys 0행([[sticker-pack]] has_qty_rule). 가격 격자 54장1세트 밴드와의 정합은 GAP.

## GAP 노드 (원천 부재·미확정 — 정직 선언)

### [gap-065-set-composition] 스티커팩=세트 여부·구성품 미적재 (GAP-ST-4·Q-ST-E) {unknown}
- type: gap
- anchor: none  # 사유: 팩이 반제품 구성원을 갖는 셋트여야 하는지 정답 원천 부재(실무진 Q-ST-E·인간 승인 대기)
- src: {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 키:PRD_000065 부모/구성원 0행(sets 미적재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.12·§5 [GAP-ST-4] 스티커팩 065 세트 구성(Q-ST-E)·sets=0", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "상품명·카테고리(스티커팩)는 여러 스티커를 묶는 세트를 시사하나 t_prd_product_sets 부모/구성원 0행. 현재는 세트 조립이 아니라 합가형 완제품가(54장1세트 4,000) 단일 룩업으로 구현 — 팩이 반제품 구성원(sub_prd_cd)을 갖는 셋트여야 하는지, 그렇다면 구성품 데이터가 무엇인지 미적재"
- gap_fill_from: "실무진 확정(Q-ST-E) + 인간 승인 후 셋트 설계 트랙(§23 huni-set-product). 그 전까지 065=단일 완제품(현재값) 유지·세트 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: sticker-pack, note: "세트 여부가 미결인 상품"}
- 본문: 팩=세트 여부는 지어내지 않고 GAP으로 등재. 현재 라이브는 단일 완제품+합가형 룩업(sets 0행)이며, 세트 재설계는 실무진·인간 승인 후 §23 소관.

### [gap-065-liandan-out-of-scope] 065 소재 연당가 재적재 범위 밖 (clean·false-defect 방지) {unknown}
- type: gap
- anchor: none  # 사유: 065 소재(비코팅/미색)는 260702 substantive 연당가 변경 4소재에 미포함 — 양면 노드 대상 아님을 정직 기록
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "sheet:출력소재(IMPORT) substantive 연당가 변경=투명스/홀로스/크라프/투명후지 4소재(065 소재 비코팅/미색 미포함·065 언급은 스티커 시트 N2 좌표 라벨뿐·단가 무영향)", captured_at: "2026-07-03", badge: unknown, src_id: SR-2.2-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§4-A(돈-크리티컬 4소재)·§4-D(양면 노드 필요 X — 완제품가 축·false-defect 방지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "065 완제품가(COMP_STK_PACK)는 260702 무변경·065 소재(비코팅스티커 084·미색스티커 242)는 §4-A 돈-크리티컬 연당가 변경 4소재(투명/홀로/크라프트/투명후지)에 미포함 → 065는 연당가 양면(defect) 노드 대상이 아님(clean). 워크리스트는 053/056/063 등 투명·홀로·크라프트 소재 몫"
- gap_fill_from: "N/A(범위 밖 정직 지연) — 연당가 재적재 워크리스트는 [[matcost-053-white-backing]] 등 4소재. 065는 clean이라 dual 노드 미생성(false-defect 방지·052 선례)"
- gap_owner: staff
- rel: {rel: references, target: component-COMP_STK_PACK, note: "260702 무변경 완제품가(연당가 급변 무관)"}
- 본문: 연당가 돈-크리티컬 재적재는 065 소재에 해당하지 않는다(비코팅/미색은 substantive 변경 아님). 지어내 defect를 만들지 않고 범위 밖을 정직 선언(§4-D)·양면 노드는 4소재 몫.

### [gap-065-material-type-label] 비코팅스티커 자재유형 라벨 .13 vs note .11 (기초코드 nuance) {unknown}
- type: gap
- anchor: none  # 사유: MAT_TYPE.13(field) vs note 주장 .11 중 어느 라벨이 정답인지 기초코드 거버넌스 판정 원천 부재(§12)
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000084(mat_typ_cd=MAT_TYPE.13·note '정정 2026-06-14 종이(.01)→스티커(.11) 점착지') + MAT_TYPE.13 실사용 6소재(은/투명데드롱·비코팅 variant)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.5 정답 자재유형 MAT_TYPE.11(스티커)·C-ST-09 자재유형 오염 상당수 교정·round-13 '혼재' 부분 STALE", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "비코팅스티커 MAT_000084의 live mat_typ_cd=MAT_TYPE.13인데 자기 note는 '종이(.01)→스티커(.11)'로 .11을 주장. .13은 은/투명데드롱 등 6개 점착지 variant가 공유하는 실사용 유형(재분류 본질=종이 이탈은 달성)이나, 팩 §3.5 정답 축은 .11 — .11↔.13 라벨 통일 여부 미판정. 미색스티커 242는 .11로 note와 일치"
- gap_fill_from: "기초코드 등록 거버넌스(§12 huni-basecode) 판정 — MAT_TYPE.13이 스티커 하위 정규 유형인지, .11로 통일할지. 그 전까지 .13/.11 중 어느 쪽도 오적재 단정 금지(honest 관찰)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000084, note: "라벨 nuance 대상 자재(공유 노드·재정의 금지)"}
- 본문: 비코팅스티커 자재유형 라벨 불일치(field .13 vs note .11)를 지어내 defect로 단정하지 않고 GAP으로 등재. .13은 실사용 유형(6소재)이라 오류 단정 부적절 — 기초코드 거버넌스(§12) 판정 대상.

### [gap-065-pack-qty-band] 제품 수량단위(1~1000) vs 가격 격자 min_qty=54 (합가형 밴드 정합) {unknown}
- type: gap
- anchor: none  # 사유: 손님 수량 선택과 54장1세트 룩업의 견적 정합은 evaluate_price 실호출로만 확증(정적 원천 부재)
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000065 min_qty=1 max_qty=1000 qty_incr=1 QTY_UNIT.02", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "comp_cd=COMP_STK_PACK 단가행 min_qty=54 필수(note '54장1세트 min_qty=54 필수')·54 미만 밴드 없음", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "제품 수량 그릇은 1~1000(incr 1·QTY_UNIT.02)인데 가격 격자는 min_qty=54 단일 밴드(54장1세트 4,000)뿐. 손님이 54 미만/54 배수 아닌 수량을 고르면 합가형 룩업이 어떻게 환원되는지(1세트=54장 단위인지·견적 0/최소가인지) 정적으로 불명 — evaluate_price 실호출로만 확증"
- gap_fill_from: "evaluate_price 골든(§13/§15) 실호출 + 실무진 수량 단위 확정(QTY_UNIT.02=세트인지 매인지). 그 전까지 수량↔가격밴드 정합 단정 금지"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_STK_PACK, note: "54장1세트 밴드 격자"}
- 본문: 합가형 팩의 제품 수량단위와 가격 밴드(54)의 관계는 evaluate_price 소관 — 정적으로 단정하지 않고 GAP으로 등재(검증 레인).

### [gap-065-cpq-option-layer] 스티커팩 CPQ 옵션 레이어 미적재 (BATCH-6) {unknown}
- type: gap
- anchor: none  # 사유: 스티커 CPQ 옵션 일괄 적재(BATCH-6) 대기 — 065 옵션그룹 0행이 정답인지 미적재인지 판정 원천 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000065 0행(CPQ 옵션 미등록)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 [GAP-ST-6] CPQ 옵션 레이어 일괄 적재(BATCH-6)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-sticker}
- gap_what: "스티커팩 065는 옵션그룹/옵션값/옵션아이템 0행 — 자재(비코팅/미색)·도수를 손님이 CPQ로 고를 수 없음. 고정 팩(단일 사이즈·소재무관 가격)이라 옵션이 실제로 불필요한지, 아니면 스티커 CPQ 일괄 적재(BATCH-6) 누락인지 미판정"
- gap_fill_from: "CPQ 옵션 매핑(§7 dbm-cpq-option-mapping) + 팩 설계 확정 — 팩이 자재/사이즈 선택을 노출할지. 그 전까지 옵션 부재를 결함/정상 어느 쪽도 단정 금지"
- gap_owner: staff
- rel: {rel: references, target: sticker-pack, note: "CPQ 옵션 0행 상품"}
- 본문: 065 CPQ 옵션 0행이 고정 팩이라 정상인지 BATCH-6 미적재인지 미결. 지어내지 않고 GAP으로 등재(§7/팩 설계 소관).

---

## 전사표 (권위=라이브 스냅샷·스크립트 전사)

> 아래 표는 전부 `_meta/scripts/transcribe_sticker_065.py`가 `live-snapshot/latest`(snap_20260702_1119) +
> 260702 price-diff CSV에서 스크립트 전사(transcribed-by 마커)한 것 — LLM 손전사 아님(§4·[HARD]).
> 재현: `python3 _meta/scripts/transcribe_sticker_065.py`. JSON 캐시=`cache/transcribed-065-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000065 @ 2026-07-03 -->
| prd_nm | prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|---|
| 스티커팩 | PRD_TYPE.01 | 1 | 1000 | 1 | QTY_UNIT.02 | N | Y | Y | N |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 상위 | cat_lvl | main_cat_yn | disp |
|---|---|---|---|---|---|
| CAT_000002 | 스티커 |  | 1 | Y | 15 |
| CAT_000312 | 스티커팩 | CAT_000002 | 2 | N |  |

### 사이즈 치수 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes(del_yn=N)+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt | 마스터 note |
|---|---|---|---|---|---|
| SIZ_000068 | 75x110 | 75x110 | 75x110 | Y | 판걸이=16.0 / 전지=미지정 / 적용=스티커팩 |

> 삭제 사이즈행: 없음

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | output_paper_typ | dflt |
|---|---|---|---|---|
| SIZ_000521 | 330x470 | 330x470 | OUTPUT_PAPER_TYPE.02 | Y |

> 삭제 판형행(del_yn=Y): SIZ_000068(OUTPUT_PAPER_TYPE.03·PDF 파일사양)

### 자재 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials(del_yn=N)+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위 | 평량 | usage | dflt | 마스터 note |
|---|---|---|---|---|---|---|---|
| MAT_000084 | 비코팅스티커 | MAT_TYPE.13 |  | 90.00 | USAGE.07 | Y | \| 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000242 | 미색스티커 | MAT_TYPE.11 |  |  | USAGE.07 | Y |  \| 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |

### 인쇄옵션 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

### 가격 배선 + 팩 격자 전행 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components+t_prc_component_prices @ 2026-07-03 -->

**PRF_STK_PACK** — 스티커팩 합가형(54장1세트 4000) (use_yn=Y·note: )

| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |
|---|---|---|---|---|---|---|
| 1 | COMP_STK_PACK | Y | PRICE_TYPE.02 | PRC_COMPONENT_TYPE.06 | 스티커 완제품가 팩(54장1세트) | `["siz_cd", "min_qty"]` |

> COMP_STK_PACK 전체 단가행 = 1행(전행 전사·팩은 합가형 소수행):

| siz_cd | mat_cd | min_qty | unit_price | note |
|---|---|---|---|---|
| SIZ_000068 | (무·소재무관) | 54 | 4000.00 | 스티커팩 54장1세트 4000(합가형·min_qty=54 필수) |

> ★소재 연당가 절가(COMP_PAPER) 065 소재 행수(0=원가 절가 미저장·완제품가 모델):

| mat_cd | COMP_PAPER 행수 |
|---|---|
| MAT_000084 | 0 |
| MAT_000242 | 0 |

### 미보유/미적재 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes/option_groups/constraints/bundle_qtys/addons/sets/prices @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| processes | 0 |
| option_groups | 0 |
| constraints | 0 |
| bundle_qtys | 0 |
| addons | 0 |
| sets | 0 |
| direct_prices | 0 |

### 260702 연당가/국4절 diff — 스티커 소재행 (전사·065 소재=비코팅/미색 substantive 판정)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_065.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv @ 2026-07-03 -->
| sheet | key | column | before | after |
|---|---|---|---|---|
| 스티커 | (좌표) | A6(8판)/100*148(8판) / 유포/비코팅/미색 | 100*148(8판) | A6(8판)/100*148(8판) |
| 출력소재(IMPORT) | 크라프 | 연당가 | 156000 | 81500 |
| 출력소재(IMPORT) | 크라프 | 가격 (국4절) | 312 | 272 |
| 출력소재(IMPORT) | 투명스 | 평량 | 105 | 50 |
| 출력소재(IMPORT) | 투명스 | 연당가 | 130000 | 149500 |
| 출력소재(IMPORT) | 투명스 | 가격 (국4절) | 1300 | 499 |
| 출력소재(IMPORT) | 홀로스 | 연당가 | 360000 | 253700 |
| 출력소재(IMPORT) | 홀로스 | 가격 (국4절) | 936 | 846 |

> 판정: 위 diff에 065 소재(비코팅스티커·미색스티커)의 **연당가/국4절 substantive 변경 없음**(N2 좌표 라벨만·§4-A 4소재=투명/홀로/크라프트/투명후지에 065 소재 미포함) → 065 완제품가·소재 원가 clean(false-defect 방지·052 선례).
