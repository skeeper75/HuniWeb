---
id: product-057-sticker-large-freeform
type: product
anchor: t_prd_products/PRD_000057
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000057", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(정답소스)·§1.1(prd_typ 재분류 PRD_TYPE.01)·§3.1 정체·§3.10 완제품가 고정가 룩업·§3.11 COMP_STK_PRINT·§4(연당가)", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-stk}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y·주 카테고리·disp 7·라이브 실측)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(main_cat_yn=N·부·상위 CAT_000002·depth 2)"}
  - {rel: has_size, target: size-SIZ_000199, note: "400x600 자유형 최대 바운딩 사이즈(t_prd_product_sizes 단일 행·work=cut·impos_yn=N)"}
  - {rel: uses_material, target: material-MAT_000153, note: "유포스티커(MAT_TYPE.11 스티커 정답유형·점착지·USAGE.07 단일 슬롯·비코팅·dflt Y)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면 단일(앞 CMYK4도 CLR_000005·뒤 인쇄안함 CLR_000001)·양면 미보유"}
  - {rel: has_process, target: process-PROC_000053, qualifier: {mand: "N"}, note: "완칼(die-cut·종이+후지 자름)·모양 string input·mand_proc_yn=N(완제품가에 출력+가공 포함이라 base print 공정 미필요)"}
  - {rel: has_plate_size, target: plate-057-SIZ_000199, note: "판형=SIZ_000199·output_paper_typ_cd=OUTPUT_PAPER_TYPE.03(기타)·note 파일사양(free-form 업로드 규격)·dflt Y"}
  - {rel: has_qty_rule, target: qty-057, note: "상품레벨 min 1·max 10000·incr 1·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "고정가 완제품가 룩업(원자합산형 아님)·COMP_STK_PRINT use_dims=[siz_cd,mat_cd,min_qty]"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측·round-13 .04 디자인상품 서술=STALE T-1)
  archetype: "고정가(완제품가 룩업·시트가격 by siz×mat×qty)"
  min_qty: 1               # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"      # 자유형=고객이 칼선(모양) 포함 파일 업로드
  editor_yn: "N"           # 에디터 미지원(자유형은 업로드 방식)
  use_yn: "Y"              # 출시 상태(063/064만 use_yn=N·pack §1.1)
standards: {schema_org: Product, xjdf: "Product(스티커)", config_ont: "component type"}
tags: [스티커, 자유형스티커, 완칼, 완제품가고정가, 유포스티커]
updated: 2026-07-03
---

# product-057-sticker-large-freeform — 대형 자유형 스티커 (PRD_000057)

스티커 상품군 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원 등록
없음 — [[product-type-classification-sot]] 준수). 유포스티커(점착지)를 **고객이 업로드한 칼선(모양)**
대로 완칼(die-cut) 재단하는 자유형 스티커. 주 카테고리는 **스티커**(CAT_000002·main_cat_yn=Y),
부 카테고리가 **자유형스티커**(CAT_000309). 가격은 **고정가 완제품가 룩업** 공식 `PRF_STK_FIXED`가
`COMP_STK_PRINT`(스티커 완제품가·소재·규격) 단가표에서 (사이즈×소재×수량구간) 시트가격을 조회한다
(값 계산=`evaluate_price` 권위·[[rule/rules#RULE_price_value_boundary]]).

- **★가격 모델 = 완제품가 고정가 룩업(원자합산형 아님):** 스티커는 출력비+소재비+가공비를 원자 합산하지
  **않는다.** `COMP_STK_PRINT`(완제품비 `PRC_COMPONENT_TYPE.06`·단가형 `PRICE_TYPE.01`)에 (siz_cd,
  mat_cd, min_qty)로 **완제품 시트가격이 통째로** 저장된다(출력+가공 포함·pack §3.10). 그래서 base
  인쇄공정(PROC_000004)이나 별도 용지비(COMP_PAPER) 배선이 없어도 견적이 성립한다 — 057은 완칼 공정
  (PROC_000053)만 등록(생산 스펙용·mand_proc_yn=N).
- **★소재 연당가는 이 가격 사슬에 직접 노드로 존재하지 않는다:** 소재 원가(연당가)는 완제품가 격자와
  **별개 축**이다(pack §4). `t_mat_materials`에 가격 컬럼이 없고(평량만 저장) COMP_PAPER에 유포
  mat_cd(MAT_000153) **0행**(실측) — 스티커는 원가를 절가 노드로 펼치지 않고 완제품가로 통째 저장한다
  ([[rule/rules#RULE_dataline_neq_wiring]]과 별개·구조 자체). 연당가 재적재 워크리스트는 [[gap-057-material-cost]].
- **★연당가 양면(defect) 노드 없음 — 정직 판정:** 057이 쓰는 **유포스티커(MAT_000153)는 260702 연당가
  diff에 미포함**이다(변경 4소재=투명스티커 백색후지 MAT_000162·홀로그램 163·크라프트 164·투명후지 372·
  pack §4-A). live 평량 80·규격 330×470 = 권위(출력소재 IMPORT row76 평량 80·전지 330×470) **일치**이고,
  완제품 retail(COMP_STK_PRINT)도 260702 무변경(pack §4-B·§4-D). 따라서 057 소재는 양면 defect 대상이
  아니다 — **false-defect를 만들지 않는다**(§4-D "retail dual 금지"). 4 defect 소재는 그것을 쓰는 다른
  스티커 상품(투명·홀로 계열)의 몫으로 공유 축에 dual 노드화(needed_shared).
- **자재유형 정답:** 유포스티커 = **MAT_TYPE.11(스티커)** — 라이브에서 이미 정확 분류(round-13 "종이(.01)↔
  스티커(.11) 혼재" 서술은 057에 대해 해소·pack §3.5·[[rule/rules#RULE_import_material_no_delete]]). 코팅 자재
  오적재(BATCH-3 CONFLICT)는 **057 무관**(057은 코팅 자재·옵션 미등록·유포 비코팅만).
- **판형(has_plate_size):** 스티커 점착지=종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객
  미선택(`fn_best_plate` 자동선택·[[harness-domain-rules-12-260701]]). 단 자유형은 물리 전지가 아니라
  **파일 규격(OUTPUT_PAPER_TYPE.03 기타·note "파일사양")** 판형이다(국전/46 아님). 최대 바운딩=400×600.
- **도수는 인쇄옵션(POPT_000001 단면)이지 색상코드가 아님**([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]).
  화이트 underbase(PROC_000008)는 057 미해당(유포=불투명·투명 베이스 아님). 057은 단면 칼라만.
- **완칼(PROC_000053·die-cut):** 종이+후지 자름·`모양`(string) input=고객 업로드 칼선. 단가형×판수 이중적용
  교정([[rule/decisions#DEC_diecut_260701]]) 계보의 완칼 공정과 동일 코드이나, 057 가격은 완제품가 룩업이라
  완칼 절가를 별도 합산하지 않는다(완제품가에 가공 포함).
- CPQ 옵션그룹·추가상품·제약규칙·묶음수(bundle_qtys)·셋트는 라이브 0행(전사 실측) — 없는 것을 지어내지
  않는다. 자유형은 손님 선택 축이 얕은 단순 완제품(단면·유포·업로드 칼선 고정).
- 끊긴 경로: 소재 연당가 저장처 부재 + 원가 급변(타 소재)이 완제품가로 전파돼야 하는지 열린 질문 →
  [[gap-057-material-cost]]로 정직 선언.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_057.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-057-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000057 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 10000 | 1 | QTY_UNIT.02 | Y | N | Y |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 상위 | main_cat_yn |
|---|---|---|---|
| CAT_000002 | 스티커 | - | Y |
| CAT_000309 | 자유형스티커 | CAT_000002 | N |

> 주 카테고리(main_cat_yn=Y)=스티커(CAT_000002·최상위)·부=자유형스티커(CAT_000309·상위 CAT_000002).
> 두 노드 다 스티커 16종 공유라 상품 노드가 **참조만** 한다(중복 선언 시 L-3 충돌·병렬 스티커 공통) →
> 공유 축(axis/categories.md) 단일 승격 후보(needed_shared·통합 단계).

### 사이즈 치수 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | impos_yn | tags | note |
|---|---|---|---|---|---|---|
| SIZ_000199 | 400x600 | 400x600 | 400x600 | N |  |  |

> SIZ_000199(400×600)=자유형 스티커 **최대 바운딩 사이즈**(work=cut·impos_yn=N). 규격형(058~062)의
> 형상=size 흡수(pack §3.2)와 달리, 자유형은 고객 업로드 칼선이라 단일 최대치수만 등록한다(형상 GAP-ST-3 무관).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 규격(w×h mm) | 평량(g) | usage_cd | dflt |
|---|---|---|---|---|---|---|
| MAT_000153 | 유포스티커 | MAT_TYPE.11 | 330x470 | 80 | USAGE.07 | Y |

> 유포스티커=점착지·**MAT_TYPE.11(스티커·정답유형)**·parent+usage_cd 단일 슬롯(USAGE.07·pack §3.5).
> live 평량 80·330×470 = 권위(IMPORT row76) 일치 → 260702 연당가 diff 미해당(양면 아님). 스티커 다상품
> 공유라 상품 노드가 **참조만** 한다(중복 선언 시 L-3 충돌) → 공유 축(axis/materials.md) 단일 승격 후보(needed_shared).

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

> 도수는 인쇄옵션(print_opt_cd) — 앞/뒤 색상수(clr)는 인쇄옵션 속성이지 별도 도수축이 아니다(pack §3.3·T-4 함정).
> 057=단면 칼라만(공유 [[axis/print-options#printopt-POPT_000001]] 재사용).

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | mand | prcs_dtl_opt(inputs) |
|---|---|---|---|
| PROC_000053 | 완칼 | N | `{"inputs": [{"key": "모양", "type": "string", "required": false}]}` |

> PROC_000053(완칼·die-cut)=자유형 스티커 정체 공정. `모양`(string) input=고객 업로드 칼선. mand_proc_yn=N —
> 완제품가에 출력+가공이 포함돼 가격이 공정에 의존하지 않기 때문(원자합산형과 대비). 공유
> [[axis/processes#process-PROC_000053]] 재사용. 반칼(PROC_000054)·도무송(PROC_000055)은 057 미해당.

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | note |
|---|---|---|---|---|
| SIZ_000199 | OUTPUT_PAPER_TYPE.03 | PDF | Y | 파일사양 |

> ★타 종이 상품 판형은 국전(OUTPUT_PAPER_TYPE.01)/46(.02)인데, 자유형 스티커는 **기타(.03)·"파일사양"**
> 판형이다 — 물리 전지가 아니라 고객 업로드 파일 최대규격(400×600). dflt_plt_yn=Y라 fn_best_plate가 자동선택.
> 종이류(점착지)라 판형 축 유효([[rule/rules#RULE_plate_paper_only]]).

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints/option_groups/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| sets(셋트 부모) | 0 |
| sets(셋트 구성원) | 0 |

> 수량은 상품레벨 규칙(min 1·max 10000·incr 1·QTY_UNIT.02)만 — 별도 묶음수 행 없음. CPQ 옵션그룹·추가상품·
> 제약규칙·셋트 미등록(정직 표기). 자유형은 손님 선택 축이 얕은 단순 완제품(단면·유포·업로드 칼선 고정).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-057-sticker-large-freeform` --priced_by--> `formula-PRF_STK_FIXED` --has_component-->
`component-COMP_STK_PRINT`. 두 노드는 스티커 16종 공유라 이 파일이 선언하지 않고 참조만 하며(공유 축
승격 대기·needed_shared), 프론트매터 `priced_by` 엣지로 배선한다. 스티커 완제품가 공식은 **고정가
룩업**(원자합산형 아님)이라 구성요소가 1개(COMP_STK_PRINT)뿐이다. 그 `use_dims`=[siz_cd, mat_cd,
min_qty]가 057 가격이 어떤 축으로 달라지는지 선언한다(값 계산은 엔진·D-18 경계).

### 가격 배선 PRF_STK_FIXED (전사·골든 스냅샷 20260702_1119)

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |
|---|---|---|---|---|---|---|
| 1 | COMP_STK_PRINT | Y | PRICE_TYPE.01 | PRC_COMPONENT_TYPE.06 | 스티커 완제품가(소재·규격) | `["siz_cd", "mat_cd", "min_qty"]` |

### 완제품가 격자 샘플 — 등록 사이즈×유포×수량구간 (전사)

> ★이 표는 KB "값 노드"가 아니라 **use_dims 실증**이다(단가행 접기·D-22·값 계산=evaluate_price 권위).
> retail(완제품가)은 260702 무변경 → 라이브=권위 일치(양면 아님·pack §4-D).

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT (siz_cd∈057등록 · mat_cd∈057등록) @ 2026-07-03 -->
| siz_cd | mat_cd | min_qty | unit_price | note |
|---|---|---|---|---|
| SIZ_000199 | MAT_000153 | 1 | 16000.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 1 이상 |
| SIZ_000199 | MAT_000153 | 20 | 15520.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 20 이상 |
| SIZ_000199 | MAT_000153 | 50 | 15200.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 50 이상 |
| SIZ_000199 | MAT_000153 | 100 | 14400.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 100 이상 |
| SIZ_000199 | MAT_000153 | 200 | 13600.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 200 이상 |
| SIZ_000199 | MAT_000153 | 300 | 12800.00 | 대형(완칼) 자유형 스티커/400x600 제작수량 300 이상 |

### 완제품가 격자의 소재 변형 (057 등록 사이즈 격자에 존재·057 미등록 포함) (전사)

> 400×600 격자에 유포 외 3 소재 변형(584 유포80g 재키잉 클론·593 유포+무광쿨코팅·611 아트스티커)이
> 존재하나 **057은 유포 비코팅(MAT_000153)만 등록**한다(코팅/아트 미노출). 이들은 §4-C 배선 복구
> (STK-RESTORE-260702·art611/쿨코팅593 grp1단가 클론) 산출로 다른 스티커 상품 몫이다. 057에 코팅 옵션을
> 노출할지는 상품설계 질문(원천 없는 데이터 GAP 아님) → 정직 표기만.

<!-- transcribed-by: _meta/scripts/transcribe_product_057.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT (siz_cd∈057등록) mat_cd별 행수 @ 2026-07-03 -->
| mat_cd | 격자행수 | 057 등록? |
|---|---|---|
| MAT_000153 | 6 | Y |
| MAT_000584 | 6 | N |
| MAT_000593 | 6 | N |
| MAT_000611 | 6 | N |

---

## 이 상품 전용/공유대기 하위 노드

> 상세 노드 정의는 자기 네임스페이스 [[product-057-sticker-large-freeform-nodes]]에 있다(공유 axis/·
> formula/ 파일 미수정 원칙·051 썬캡 선례). CAT_000002/309·MAT_000153·PRF_STK_FIXED·COMP_STK_PRINT는
> 다른 스티커 상품과 공유될 축이라 **needed_shared_nodes**로 반환(통합 단계 공유 축 승격 후보). 인쇄옵션
> (POPT_000001)·공정(PROC_000053)은 공유 축([[axis/print-options]]·[[axis/processes]]) 기존 노드로 해소된다
> (중복 노드 생성 금지). 소재 연당가 저장처 부재는 [[gap-057-material-cost]]로 정직 선언.
