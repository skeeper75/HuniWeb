<!-- companion nodes for sticker-spec-circle 반칼원형스티커 PRD_000058 — 공유 축(axis/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일 수정 금지 규칙에 따라, axis/*·formula/*에 없는 것만 여기 신설(023 companion 방식). -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·process-PROC_*·formula-*·component-*)를 쓴다 — 스티커 그룹 통합 시 공유 축 이관 후보(needed_shared_nodes로 반환). -->
<!-- ★수치(치수·사양·배선·격자·연당가 diff)는 전사 스크립트 transcribe_sticker_058.py 출력만(transcribed-by 마커). LLM 손전사 금지(§4·L-16). -->

# sticker-spec-circle 전용 노드 (반칼원형스티커 PRD_000058 — 상품 전용 마스터 축)

[[sticker-spec-circle]]가 연결하는 축 중, 디지털 파일럿 공유 축 노드(axis/*·formula/*)에 아직
없는 것만 신설한다. 공유에 있는 것(단면 인쇄옵션 printopt-POPT_000001·규칙 RULE_*·결정 DEC_*)은
재사용하고 여기 중복 신설하지 않는다(L-3). ★반칼원형스티커는 **디지털·실사 파일럿의 첫 스티커** —
카테고리(스티커)·자재(점착지 5종)·공정(반칼커팅)·공식(PRF_STK_FIXED 완제품가)·구성요소(COMP_STK_PRINT)가
전부 신규 축이므로 스티커 그룹 통합 시 공유 축 승격 1순위(needed_shared_nodes).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사·손전사 금지)

> 아래 표는 `_meta/scripts/transcribe_sticker_058.py`가 live-snapshot(snap_20260702_1119) +
> 26_change-tracking price-diff에서 결정론 전사(손전사 아님). 재현: `python3 transcribe_sticker_058.py`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000058 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 4 | 10000 | 4 | QTY_UNIT.02 | Y | Y | Y | N |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 상위 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000002 | 스티커 |  | Y | 8 |
| CAT_000037 | 규격스티커 | CAT_000002 | N | 11 |

### 사이즈 치수 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes(del_yn=N)+t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | 재단(mm) | dflt |
|---|---|---|---|---|
| SIZ_000520 | A4(210x297mm) 반칼 | x | x | N |
| SIZ_000170 | A5(148x210mm) | 148x210 | 148x210 | Y |

> 삭제행(del_yn=Y·07-01 재키잉): SIZ_000426, SIZ_000258

### 판형 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes(del_yn=N) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(mm) | output_paper_typ | dflt |
|---|---|---|---|---|
| SIZ_000521 | 330x470 | 330x470 | OUTPUT_PAPER_TYPE.02 | Y |

> 삭제 판형행: SIZ_000007, SIZ_000050

### 자재 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials(del_yn=N)+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 상위 | usage | dflt | 마스터 note |
|---|---|---|---|---|---|---|
| MAT_000584 | 유포스티커 80g | MAT_TYPE.11 | MAT_000153 | USAGE.07 | Y |  |
| MAT_000611 | 아트스티커 90g | MAT_TYPE.11 | MAT_000610 | USAGE.07 | Y |  |
| MAT_000609 | 미색스티커 (모조 80g) | MAT_TYPE.11 | MAT_000242 | USAGE.07 | Y |  |
| MAT_000585 | 무광코팅스티커 (아트지 90g + 무광라미네이팅) | MAT_TYPE.11 | MAT_000155 | USAGE.07 | Y |  |
| MAT_000586 | 유광코팅스티커 (아트지 90g +유광라미네이팅) | MAT_TYPE.11 | MAT_000156 | USAGE.07 | Y |  |

> 삭제행(변경전 parent·07-01 재키잉): MAT_000153(유포스티커), MAT_000084(비코팅스티커), MAT_000242(미색스티커), MAT_000155(무광코팅스티커), MAT_000156(유광코팅스티커)

### 인쇄옵션 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

### 공정 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes(del_yn=N)+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 | mand |
|---|---|---|---|
| PROC_000122 | 반칼커팅 | PROC_000121 | N |

> 삭제 공정행: PROC_000055(스티커완칼)

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 이름 | sel_typ | mand | disp | del_yn |
|---|---|---|---|---|---|
| OPT-000033 | 원형 35mm (15ea) |  | N | 3 | Y |
| OPT-000037 | 원형 55mm (6ea) |  | N | 7 | Y |
| OPT-000038 | 원형 60mm (6ea) |  | N | 8 | Y |
| OPT-000031 | 커팅 | SEL_TYPE.01 | N | 1 | N |
| OPT-000032 | 원형 30mm (20ea) |  | N | 2 | Y |
| OPT-000034 | 원형 40mm (12ea) |  | N | 4 | Y |
| OPT-000035 | 인쇄 | SEL_TYPE.01 | N | 5 | N |
| OPT-000036 | 종이 | SEL_TYPE.01 | N | 6 | N |

### CPQ 옵션값 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options(del_yn!=Y) @ 2026-07-03 -->
| opt_cd | 그룹 | 이름 | disp |
|---|---|---|---|
| OPV-000066 | OPT-000031 | 원형 25mm (24ea) | 1 |
| OPV-000075 | OPT-000031 | 원형 90mm (6ea) | 10 |
| OPV-000067 | OPT-000031 | 원형 30mm (20ea) | 2 |
| OPV-000068 | OPT-000031 | 원형 35mm (15ea) | 3 |
| OPV-000069 | OPT-000031 | 원형 40mm (12ea) | 4 |
| OPV-000070 | OPT-000031 | 원형 45mm (8ea) | 5 |
| OPV-000071 | OPT-000031 | 원형 50mm (6ea) | 6 |
| OPV-000072 | OPT-000031 | 원형 55mm (6ea) | 7 |
| OPV-000073 | OPT-000031 | 원형 60mm (6ea) | 8 |
| OPV-000074 | OPT-000031 | 원형 80mm (6ea) | 9 |
| OPV-000060 | OPT-000035 | 단면 | 1 |
| OPV-000061 | OPT-000036 | 유포스티커 | 1 |
| OPV-000062 | OPT-000036 | 미색스티커 | 2 |
| OPV-000063 | OPT-000036 | 아트스티커 | 3 |
| OPV-000064 | OPT-000036 | 무광코팅스티커 | 4 |
| OPV-000065 | OPT-000036 | 유광코팅스티커 | 5 |

### CPQ 옵션아이템 참조 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items(del_yn!=Y) @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|
| OPV-000060 | OPT_REF_DIM.06 | 1 |  |
| OPV-000064 | OPT_REF_DIM.03 | MAT_000585 | USAGE.07 |
| OPV-000065 | OPT_REF_DIM.03 | MAT_000586 | USAGE.07 |
| OPV-000061 | OPT_REF_DIM.03 | MAT_000584 | USAGE.07 |
| OPV-000062 | OPT_REF_DIM.03 | MAT_000609 | USAGE.07 |
| OPV-000063 | OPT_REF_DIM.03 | MAT_000611 | USAGE.07 |

### 제약규칙 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints @ 2026-07-03 -->
| rule | 이름 | 유형 | logic(앞400자) |
|---|---|---|---|
| RULE_001 | A5 커팅 | RULE_TYPE.03 | `{"!": {"and": [{"===": [{"var": "siz_cd"}, "SIZ_000426"]}, {"in": ["OPV-000066", {"var": "sel_opts"}]}, {"in": ["OPV-000067", {"var": "sel_opts"}]}, {"in": ["OPV-000068", {"var": "sel_opts"}]}, {"in": ["OPV-000069", {"var": "sel_opts"}]}, {"in": ["OPV-000070", {"var": "sel_opts"}]}, {"in": ["OPV-000071", {"var": "sel_opts"}]}, {"in": ["OPV-000072", {"var": "sel_opts"}]}, {"in": ["OPV-000073", {"va` |

### 가격 배선 + 격자 충전 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

**PRF_STK_FIXED** — 스티커 규격/소재/수량별 단가 (use_yn=Y·note: 스티커 단가. 수량×(출력매수·소재) 표에서 단가 조회.)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_STK_PRINT | Y | PRICE_TYPE.01 | 스티커 완제품가(소재·규격) | `["siz_cd", "mat_cd", "min_qty"]` |

> COMP_STK_PRINT 전체 단가행 = 6498행. 058 active 소재별 격자 충전(실측):

| mat_cd | 격자 행수 | 샘플(siz_cd·min_qty·단가·note) |
|---|---|---|
| MAT_000584 | 540 | SIZ_000170·3·5900.00·B01 col1(A5) 유포 [mint260701 src=MAT_0001 |
| MAT_000585 | 504 | SIZ_000170·1·7000.00·B01 col1(A5) 무광코팅 [mint260701 src=MAT_00 |
| MAT_000586 | 504 | SIZ_000170·150·6000.00·B01 col1(A5) 유광코팅 [mint260701 src=MAT_00 |
| MAT_000609 | 504 | SIZ_000065·350·4200.00·[잠정] 소형반칼 B01 규격가(col1·124x186) 사이즈무관 적용 |
| MAT_000611 | 540 | SIZ_000170·3·5900.00·STK-RESTORE-260702 art-clone-from-153 |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/sets/prices @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys | 0 |
| addons | 0 |
| sets | 0 |
| direct_prices | 0 |

### 260702 연당가/국4절 diff — 스티커 소재행 (전사·058 소재 대조용)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_058.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv @ 2026-07-03 -->
| sheet | key | column | before | after |
|---|---|---|---|---|
| 출력소재(IMPORT) | 투명투 | (ADDED row) |  | C=투명스티커(투명후지) \| D=50 \| E=투명투 \| F=점착 투명데드롱 50mic (후지:투명 PE |
| 출력소재(IMPORT) | 크라프 | 연당가 | 156000 | 81500 |
| 출력소재(IMPORT) | 크라프 | 가격 (국4절) | 312 | 272 |
| 출력소재(IMPORT) | 투명스 | 종이명 | 투명스티커 | 투명스티커(백색후지) |
| 출력소재(IMPORT) | 투명스 | 평량 | 105 | 50 |
| 출력소재(IMPORT) | 투명스 | 연당가 | 130000 | 149500 |
| 출력소재(IMPORT) | 투명스 | 가격 (국4절) | 1300 | 499 |
| 출력소재(IMPORT) | 홀로스 | 연당가 | 360000 | 253700 |
| 출력소재(IMPORT) | 홀로스 | 가격 (국4절) | 936 | 846 |

---

## 카테고리 (category) — 스티커 신규 2종 (공유 axis/categories 미등재)

스티커 카테고리 = 스티커(CAT_000002·main) + 규격스티커(CAT_000037·상위 CAT_000002·부). 디지털 파일럿
카테고리(엽서 CAT_000307 등)와 별 트리 → 공유 축 승격 후보(needed_shared_node).

---

## 사이즈 (size) — 반칼원형스티커 active 2행 (시트 규격)

★스티커 특유(팩 §3.2): 058의 t_prd_product_sizes = **A4/A5 시트 규격만**(작업 사이즈). 손님이 고르는
**원형 형상(25~90mm)은 size 행이 아니라 CPQ 커팅 옵션값**(OPT-000031)에 산다 → 형상 저장처 불일치
([[sticker-spec-circle#gap-058-shape-storage]]·GAP-ST-3). 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생
(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

---

## 판형 (plate_size) — 출력용지규격 46계열 (종이류=점착지 → 판형 유효)

★도메인 [HARD]: 판형=출력용지규격(작업사이즈 아님)·고객 미선택·`fn_best_plate` 자동선택·종이류에만 유효
([[rule/rules#RULE_plate_paper_only]]). 스티커 점착지=종이류 → 판형 대상. 058 active 판형=SIZ_000521
(330x470·OUTPUT_PAPER_TYPE.02 "46계열"). 삭제 판형(SIZ_000007/050·OUTPUT_PAPER_TYPE.03 파일사양)은 07-01 정리.

### [plate-058-SIZ_000521] 330x470 (46계열 출력용지) {verified}
- type: plate_size
- anchor: t_siz_sizes/SIZ_000521
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000058,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02·dflt_plt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_cod_base_codes.csv", source_locator: "키:OUTPUT_PAPER_TYPE.02 (46계열)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000521(330x470)", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", dflt_plt_yn: "Y", note: "공유 plate-OUTPUT_PAPER_TYPE_01(.01 국전)과 다른 출력계열(.02 46계열)·fn_best_plate 자동선택·공유 축 승격 후보"}

---

## 자재 (material) — 반칼원형스티커 active 점착지 5종 (전부 MAT_TYPE.11 스티커)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★07-01 재키잉: parent 코드(153/242/155/156)는
del_yn=Y, child variant 코드(584/611/609/585/586) active — 사이즈 재키잉 파손 복구 COMMIT 계열
([[rule/decisions#DEC_wiring_round22_260702]]·팩 §4-C). ★자재유형 = **전부 MAT_TYPE.11(스티커용지)**
= 정답(팩 §3.5 C-ST-09 "종이(.01)→스티커(.11)" 정정 완료·라이브 마스터 note "정정 2026-06-14"가 실증).
★[HARD] 실무진 IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 반칼커팅 (스티커 정체 공정)

★스티커 정체 공정(팩 §3.6): 커팅 = **반칼 Kiss Cut**·완칼 Die Cut·도무송. 058 active 공정 =
**PROC_000122 반칼커팅**(상위 PROC_000121 커팅·mand_proc_yn=N). 삭제 공정 = PROC_000055 스티커완칼(도무송·07-01 제거).
★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가 고정가 룩업(COMP_STK_PRINT에 출력+가공 내장)이라
원자합산형 base 인쇄 바인딩이 불필요(디지털인쇄와 다른 가격 모델·결함 아님·팩 §3.10).
★반칼커팅(PROC_000122)은 공유 완칼(모양엽서 PROC_000123)처럼 **상위 PROC_000121 커팅 하위**의 생산 라우팅 공정.

---

## 가격공식·구성요소 (formula·component) — 스티커 완제품가 고정가

★스티커 특유(팩 §3.10): 원자합산형 **아님** — **완제품가(시트가격) 고정가 룩업**. 공식 PRF_STK_FIXED가
단일 구성요소 COMP_STK_PRINT(use_dims=[siz_cd, mat_cd, min_qty]·PRICE_TYPE.01)로 배선. 소재 연당가(원가)는
이 완제품가 격자에 직접 없음(§4-B·[[sticker-spec-circle#gap-058-yeondangga]]). 값 계산은 evaluate_price
권위([[rule/rules#RULE_price_value_boundary]]). ★단가행(COMP_STK_PRINT 6,498행)은 노드로 펼치지 않고
구성요소 속성으로 접음(D-22).
