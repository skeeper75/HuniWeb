<!-- companion nodes for sticker-gangpan-diecut 합판도무송스티커 PRD_000066 — 공유 축(axis/*)에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일(index.md·axis/*·formula/*·rule/*) 수정 금지 규칙에 따라, 공유에 없는 것만 여기 신설(023/058 companion 방식). -->
<!-- ★master-id(size-SIZ_*·material-MAT_*·process-PROC_*·formula-*·component-*)를 쓴다 — 스티커 그룹 통합 시 공유 축 이관 후보(needed_shared_nodes로 반환). -->
<!-- ★수치(치수·사양·배선·격자·연당가 diff)는 전사 스크립트 transcribe_sticker_066.py 출력만(transcribed-by 마커). LLM 손전사 금지(§4·L-16). -->

# sticker-gangpan-diecut 전용 노드 (합판도무송스티커 PRD_000066 — 상품 전용 마스터 축)

[[sticker-gangpan-diecut]]가 연결하는 축 중, 파일럿 공유 축 노드(axis/*·formula/*)에 아직 없는 것만
신설한다. 공유에 있는 것(단면 인쇄옵션 [[axis/print-options#printopt-POPT_000001]]·규칙 RULE_*·결정
DEC_*)은 재사용하고 여기 중복 신설하지 않는다(L-3). ★합판도무송스티커는 **형상=size 아키타입의 정본** —
037 형상행(정사각/직사각/원형)을 `siz_nm`으로 흡수하고, 완제품가 격자는 **COMP_GANGPAN_PRINT**(058의
COMP_STK_PRINT와 별 구성요소·PRICE_TYPE.02)에 산다. 카테고리(스티커)·인쇄옵션(단면)은 058 companion과
동일 코드라 스티커 그룹 통합 시 공유 축 승격 1순위(needed_shared_nodes).

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사·손전사 금지)

> 아래 표는 `_meta/scripts/transcribe_sticker_066.py`가 live-snapshot(snap_20260702_1119) +
> 26_change-tracking price-diff에서 결정론 전사(손전사 아님). 재현: `python3 transcribe_sticker_066.py`.
> JSON 캐시 = `_meta/scripts/cache/transcribed-066-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000066 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1000 | 5000 | 1000 | QTY_UNIT.02 | Y | N | Y | N |

> ★058과 다른 점: `editor_yn=N`(합판도무송은 **파일 업로드 전용**·에디터 없음)·`min_qty=1000·incr=1000`(058은 4/4). 합판(gang) 인쇄라 최소 1,000매.

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 상위 | main_cat_yn | disp |
|---|---|---|---|---|
| CAT_000002 | 스티커 |  | Y | 4 |
| CAT_000037 | 규격스티커 | CAT_000002 | N |  |

### 사이즈=형상 active 37행 (형상 흡수·전사) — 요약 + 샘플

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes(del_yn=N)+t_siz_sizes @ 2026-07-03 -->
> ★형상=size 아키타입(팩 §3.2·C-ST-03·Q7): siz_nm이 형상+치수+EA를 흡수. 형상 family = 정사각 12 · 직사각 14 · 원형 11 = 37. per-size min_qty 전부 공란(수량 UI 권위=상품레벨·아래 bundle_qtys).

| siz_cd | 라벨(형상) | 작업(mm) | dflt | per-size min/incr |
|---|---|---|---|---|
| SIZ_000212 | 정사각10x10mm(8EA) | 10x10 | Y | (공란)/(공란) |
| SIZ_000213 | 정사각15x15mm(8EA) | 15x15 | Y | (공란)/(공란) |
| SIZ_000214 | 정사각20x20mm(6EA) | 20x20 | Y | (공란)/(공란) |
| SIZ_000215 | 정사각25x25mm(3EA) | 25x25 | Y | (공란)/(공란) |
| SIZ_000216 | 정사각30x30mm(2EA) | 30x30 | Y | (공란)/(공란) |
| SIZ_000217 | 정사각35x35mm(2EA) | 35x35 | Y | (공란)/(공란) |
| SIZ_000508 | 원형50x50 | 50x50 | N | (공란)/(공란) |
| SIZ_000509 | 원형55x55 | 55x55 | N | (공란)/(공란) |
| SIZ_000510 | 원형60x60 | 60x60 | N | (공란)/(공란) |

> 위는 37행 중 앞6·뒤3 샘플(전체 37 형상은 JSON 캐시·전사 재현). 삭제행: 없음. 대표 노드 = 아래 size 절 3 family rep.

### 판형 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes(del_yn=N) @ 2026-07-03 -->
> 066 판형 = 26행(전부 output_paper_typ_cd **공란**·작업사이즈 규격 목록). 앞4 샘플:

| siz_cd | 라벨 | 작업(mm) | output_paper_typ | dflt |
|---|---|---|---|---|
| SIZ_000203 | 72x46 | 72x46 | (공란) | Y |
| SIZ_000204 | 79x43 | 79x43 | (공란) | Y |
| SIZ_000205 | 77x53 | 77x53 | (공란) | Y |
| SIZ_000206 | 91x35 | 91x35 | (공란) | Y |

> 삭제 판형행: 없음. ★058(판형 SIZ_000521·OUTPUT_PAPER_TYPE.02 명시)과 달리 066 판형은 output_paper_typ_cd 전부 공란 → 판형 유형 미지정([[sticker-gangpan-diecut#gap-066-plate-otyp]]).

### 자재 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials(del_yn=N)+t_mat_materials+t_cod_base_codes(MAT_TYPE) @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 유형명 | 평량 | usage | dflt | 마스터 note |
|---|---|---|---|---|---|---|---|
| MAT_000153 | 유포스티커 | MAT_TYPE.11 | 스티커용지 | 80.00 | USAGE.07 | Y |  |
| MAT_000084 | 비코팅스티커 | MAT_TYPE.13 | 합판스티커용지 | 90.00 | USAGE.07 | Y | \| 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000155 | 무광코팅스티커 | MAT_TYPE.11 | 스티커용지 | 90.00 | USAGE.07 | Y |  |
| MAT_000156 | 유광코팅스티커 | MAT_TYPE.11 | 스티커용지 | 90.00 | USAGE.07 | Y |  |
| MAT_000170 | 투명데드롱스티커 | MAT_TYPE.13 | 합판스티커용지 | 25.00 | USAGE.07 | Y |  |
| MAT_000171 | 은데드롱스티커 | MAT_TYPE.13 | 합판스티커용지 | 25.00 | USAGE.07 | Y |  |

> 삭제행(product_materials del_yn=Y): 없음. ★066은 **parent 코드 직접 참조**(153/155/156) — 058 계열의 07-01 재키잉(child variant 584/585/586)이 **066엔 미적용**([[sticker-gangpan-diecut#gap-066-rekeying-skew]]). ★MAT_TYPE.13=합판스티커용지(06-16 신설·정당 유형)로 084/170/171 배정 → 팩 §3.5 일괄 ".11"은 합판 소재엔 부분 stale.

### 인쇄옵션 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

> ★공유 노드 [[axis/print-options#printopt-POPT_000001]] 재사용(중복 신설 안 함).

### 공정 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes(del_yn=N)+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 상위 | mand |
|---|---|---|---|
| PROC_000055 | 스티커완칼 | (없음) | N |

> 삭제 공정행: 없음. ★합판=**스티커완칼(도무송) PROC_000055**(팩 §3.6 "합판=도무송"). 058(반칼 PROC_000122)과 다른 커팅 정체. base 인쇄공정(PROC_000004) 없음(완제품가 룩업 모델).

### 수량규칙 — bundle_qtys (전사·058은 0행·066만 5행)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys(del_yn!=Y) @ 2026-07-03 -->
| bdl_qty | 단위 | dflt |
|---|---|---|
| 8 | QTY_UNIT.01 | N |
| 6 | QTY_UNIT.01 | N |
| 3 | QTY_UNIT.01 | N |
| 2 | QTY_UNIT.01 | N |
| 1 | QTY_UNIT.01 | N |

> ★팩 §3.4 "합판도무송 066만 bundle_qtys 5행" 실측 정합. bdl_qty 8/6/3/2/1(QTY_UNIT.01)=형상별 시트당 EA(정사각10x10=8EA·30x30=2EA…siz_nm의 (NEA)와 대응). 수량 UI 2층 = 상품레벨(min 1000·incr 1000 매) + bundle_qtys(EA 조각수).

### CPQ 옵션그룹 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_groups @ 2026-07-03 -->
| opt_grp_cd | 이름 | sel_typ | mand | disp | del_yn |
|---|---|---|---|---|---|
| OPT-000004 | 원형 | SEL_TYPE.01 | N | 1 | Y |
| OPT_000016 | 종이 | SEL_TYPE.01 | Y | 1 | N |
| OPT_000017 | 인쇄 | SEL_TYPE.01 | Y | 2 | N |

> ★OPT-000004(원형)=빈 그룹(옵션값 1개도 del_yn=Y)·**del_yn=Y로 이미 논리삭제**(팩 §3.9 C-ST-12 "066 빈 옵션그룹 논리삭제 제안" = 라이브 이미 반영). ★058과 달리 **커팅/형상 옵션그룹 없음** — 형상=size이므로 형상은 사이즈에서 고름(모델 정합).

### CPQ 옵션값 (전사·del 표기)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_options @ 2026-07-03 -->
| opt_cd | 그룹 | 이름 | disp | del |
|---|---|---|---|---|
| OPV-000006 | OPT-000004 | 옵션1 | 1 | Y |
| OPV_000032 | OPT_000016 | 유포스티커 | 1 | N |
| OPV_000033 | OPT_000016 | 비코팅스티커 | 2 | N |
| OPV_000034 | OPT_000016 | 무광코팅스티커 | 3 | N |
| OPV_000035 | OPT_000016 | 유광코팅스티커 | 4 | N |
| OPV_000036 | OPT_000016 | 투명데드롱스티커 | 5 | N |
| OPV_000037 | OPT_000016 | 은데드롱스티커 | 6 | N |
| OPV_000038 | OPT_000017 | 단면 | 1 | N |

### CPQ 옵션아이템 참조 active (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_option_items(del_yn!=Y) @ 2026-07-03 -->
| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |
|---|---|---|---|
| OPV_000032 | OPT_REF_DIM.03 | MAT_000153 | USAGE.07 |
| OPV_000033 | OPT_REF_DIM.03 | MAT_000084 | USAGE.07 |
| OPV_000034 | OPT_REF_DIM.03 | MAT_000155 | USAGE.07 |
| OPV_000035 | OPT_REF_DIM.03 | MAT_000156 | USAGE.07 |
| OPV_000036 | OPT_REF_DIM.03 | MAT_000170 | USAGE.07 |
| OPV_000037 | OPT_REF_DIM.03 | MAT_000171 | USAGE.07 |
| OPV_000038 | OPT_REF_DIM.06 | 1 |  |

### 제약규칙 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_constraints @ 2026-07-03 -->
> 066 제약규칙 = 0행(constraints 미적재). ★058(RULE_001 A5 커팅)과 달리 066은 제약 없음.

### 가격 배선 + 격자 충전 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->

**PRF_GANGPAN_FIXED** — 합판도무송 사이즈/소재/수량별 단가 (use_yn=Y·note: 합판도무송 단가. 수량×(사이즈·소재) 표에서 단가 조회.)

| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_GANGPAN_PRINT | Y | PRICE_TYPE.02 | 합판도무송 완제품가(형상·소재별) | `["siz_cd", "mat_cd", "min_qty"]` |

> COMP_GANGPAN_PRINT 전체 단가행 = 1,110행. 066 active 6소재별 격자 충전(실측·각 185행 = 완전 충전·silent-0 아님):

| mat_cd | 격자 행수 | 샘플(siz_cd·min_qty·단가·note) |
|---|---|---|
| MAT_000153 | 185 | SIZ_000422·1000·27200.00·원형 35mm/유포/투명데드롱/은데드롱 제작수량 1000 이상 |
| MAT_000084 | 185 | SIZ_000422·1000·20600.00·원형 35mm/비코팅/무광코팅/유광코팅 제작수량 1000 이상 |
| MAT_000155 | 185 | SIZ_000212·1000·20000.00·정사각 10x10mm/비코팅/무광코팅/유광코팅 |
| MAT_000156 | 185 | SIZ_000212·1000·20000.00·정사각 10x10mm/비코팅/무광코팅/유광코팅 |
| MAT_000170 | 185 | SIZ_000212·1000·26100.00·정사각 10x10mm/유포/투명데드롱/은데드롱 |
| MAT_000171 | 185 | SIZ_000212·1000·26100.00·정사각 10x10mm/유포/투명데드롱/은데드롱 |

> ★단가 2그룹: 유포/투명데드롱/은데드롱(고가·예 정사각10x10 1,000매 26,100) vs 비코팅/무광코팅/유광코팅(저가·20,000). 수량구간 5단(1000/2000/3000/4000/5000·정사각10x10 유포=26,100→39,200→52,200→65,300→78,300). 값 raw는 이 전사표 권위(손전사 금지·D-22 단가행 접기).

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_addons/sets/prices/constraints @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| addons | 0 |
| sets | 0 |
| direct_prices | 0 |
| constraints | 0 |

### 260702 연당가/국4절 diff — 스티커 소재행 (전사·066 소재 교집합 대조)

<!-- transcribed-by: _meta/scripts/transcribe_sticker_066.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv @ 2026-07-03 -->
> ★066 소재(유포/비코팅/무광코팅/유광코팅/투명데드롱/은데드롱)와 260702 연당가 변경 4소재(투명스티커·홀로그램·크라프트·투명후지)의 **교집합 = 0행**. 즉 066 소재는 260702 연당가 변경분 아님 → 양면(defect) 노드 불요(팩 §4-D "retail 무변경 dual 금지"·058 선례 정합). 아래는 대조용 참조(066 소재 아님).

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

## 카테고리 (category) — 스티커 (058 companion과 동일 코드·공유 축 승격 후보)

스티커 카테고리 = 스티커(CAT_000002·main·066 disp 4) + 규격스티커(CAT_000037·상위 CAT_000002·부). 058
companion과 같은 코드 → 스티커 그룹 통합 시 공유 axis/categories 이관(needed_shared_node·중복 신설이나
delta 갱신은 코디네이터 몫).

---

## 사이즈 (size) — 형상=size 아키타입 3 family 대표 (전체 37 = 전사표 권위)

★스티커 특유·정본(팩 §3.2·C-ST-03·Q7): 066의 t_prd_product_sizes 37행이 **형상(정사각/직사각/원형) 자체를
size로 흡수**(siz_nm에 형상+치수+시트당 EA 인코딩). 058(형상=CPQ 커팅 옵션값)과 달리 066은 **형상=size 1:1**
→ 형상 저장처 정본. 아래는 형상 family 대표 3 노드(전체 37 형상은 전사표·JSON 캐시가 권위·D-22 사이즈 접기).
판걸이수(UP수)는 사이즈 컬럼이 아니라 파생(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

---

## 자재 (material) — 합판 점착지 6종 (parent 코드 직접 참조·MAT_TYPE.11/.13 혼재)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★066은 **parent 코드 직접 참조**(153/155/156/084/
170/171) — 058 계열의 07-01 재키잉(child variant 584/585/586/609/611)이 **066엔 미적용**([[sticker-gangpan-diecut#gap-066-rekeying-skew]]).
★자재유형 혼재 = 유포/무광코팅/유광코팅(153/155/156)=MAT_TYPE.11(스티커용지)·비코팅/투명데드롱/은데드롱
(084/170/171)=MAT_TYPE.13(**합판스티커용지**·06-16 신설 정당 유형). 팩 §3.5 일괄 ".11"은 합판 소재엔 부분 stale
(정본 = 합판=MAT_TYPE.13). ★[HARD] 실무진 IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

---

## 공정 (process) — 스티커완칼 (도무송·합판 정체 공정)

★합판 정체 공정(팩 §3.6): 커팅 = 반칼 Kiss Cut·완칼 Die Cut·**스티커완칼(도무송) PROC_000055**. 066 active
공정 = **PROC_000055 스티커완칼**(상위 없음·mand_proc_yn=N·조각수만 input). 058(반칼 PROC_000122·상위 PROC_000121)과
다른 커팅 정체 → 합판도무송의 정체 공정. ★**base 인쇄 공정(PROC_000004) 없음** — 스티커는 완제품가 고정가
룩업(COMP_GANGPAN_PRINT에 출력+가공 내장)이라 원자합산 base 인쇄 바인딩 불필요(디지털인쇄와 다른 가격
모델·결함 아님·팩 §3.10).

---

## 가격공식·구성요소 (formula·component) — 합판도무송 완제품가 고정가

★스티커 특유(팩 §3.10): 원자합산형 **아님** — **완제품가(시트가격) 고정가 룩업**. 공식 PRF_GANGPAN_FIXED가
단일 구성요소 COMP_GANGPAN_PRINT(use_dims=[siz_cd, mat_cd, min_qty]·**PRICE_TYPE.02**)로 배선(058 COMP_STK_PRINT는
.01). 소재 연당가(원가)는 이 완제품가 격자에 직접 없음(§4-B·[[sticker-gangpan-diecut#gap-066-yeondangga]]).
값 계산은 evaluate_price 권위([[rule/rules#RULE_price_value_boundary]]). ★단가행(COMP_GANGPAN_PRINT 1,110행)은
노드로 펼치지 않고 구성요소 속성으로 접음(D-22).
