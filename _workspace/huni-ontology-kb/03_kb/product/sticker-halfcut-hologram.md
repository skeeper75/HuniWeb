---
id: sticker-halfcut-hologram
type: product
anchor: t_prd_products/PRD_000054
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000054", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§1(정답소스)·§3.1 정체·§3.2 형상=size·§3.5 자재(홀로그램)·§3.6 공정(반칼/화이트)·§3.10 완제품가 격자·§4 연당가", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-sticker}
  - {source_file: "_workspace/huni-dbmap/17_correctness/sticker/product-identity.md", source_locator: "§0 시트구조·§1 16상품 정체(반칼 자유형·홀로그램)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-sticker}
relations:
  - {rel: in_category, target: category-CAT_000002, note: "스티커(main_cat_yn=Y 주 카테고리)"}
  - {rel: in_category, target: category-CAT_000309, note: "자유형스티커(main_cat_yn=N 부 카테고리·자유 칼틀)"}
  - {rel: has_size, target: size-054-SIZ_000170, note: "A5 148x210(주문 사이즈·마스터 del_yn=Y vs 링크 활성 불일치)"}
  - {rel: has_size, target: size-054-SIZ_000520, note: "A4 반칼 규격 래퍼(판걸이=2.0·반칼 전용가)"}
  - {rel: uses_material, target: material-MAT_000163, note: "홀로그램 점착지(MAT_TYPE.11·USAGE.07 단일 슬롯·dflt Y)"}
  - {rel: has_print_option, target: printopt-POPT_000001, note: "단면(앞 CMYK4도·뒤 인쇄안함)·양면 미보유"}
  - {rel: has_process, target: process-PROC_000054, qualifier: {mand: "N"}, note: "반칼 Kiss Cut(자유형 칼틀·모양+조각수 input)"}
  - {rel: has_process, target: process-PROC_000008, qualifier: {mand: "N"}, note: "화이트인쇄 underbase(별색 자식·홀로그램 위 흰 밑판·가격배선 GAP)"}
  - {rel: has_plate_size, target: plate-054-SIZ_000521, note: "46계열 전지 330x470(국전 아님)·반칼 표준전지·fn_best_plate 자동선택"}
  - {rel: has_qty_rule, target: qty-054, note: "상품레벨 min 8·max 10000·incr 8·QTY_UNIT.02(bundle_qtys 0행)"}
  - {rel: priced_by, target: formula-PRF_STK_FIXED, note: "완제품가 고정가 룩업(원자합산형 아님)·COMP_STK_PRINT 격자"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0 실측)
  archetype: "완제품가 고정가 룩업(PRF_STK_FIXED→COMP_STK_PRINT·형상×치수×수량 격자·pack §3.10)"
  min_qty: 8                # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  file_upload_yn: "Y"       # 파일 업로드 지원(자유형 칼선 업로드)
  editor_yn: "N"            # 에디터 미지원
  use_yn: "Y"               # 출시 상태(라이브 현재값)
standards: {schema_org: Product, xjdf: "Product(홀로그램 스티커)", config_ont: "component type"}
tags: [스티커, 자유형스티커, 홀로그램, 반칼, 완제품가룩업]
updated: 2026-07-03
---

# sticker-halfcut-hologram — 반칼 자유형 홀로그램스티커 (PRD_000054)

스티커 상품군 **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원 등록 없음 —
[[product-type-classification-sot]]·pack §1.1 준수). **홀로그램 점착지**(MAT_000163)에 CMYK 컬러를 단면
인쇄하고 **반칼(Kiss Cut·PROC_000054)** 로 자유형 칼틀 모양대로 절개하는 스티커. 주 카테고리는
**스티커**(CAT_000002·main_cat_yn=Y), 부 카테고리가 **자유형스티커**(CAT_000309). 파일 업로드로 자유형
칼선을 받는다(`file_upload_yn=Y`·`editor_yn=N`).

- **★가격 모델 = 완제품가(시트가격) 고정가 룩업**(원자합산형 **아님**·pack §3.10). `PRF_STK_FIXED`가
  단일 구성요소 `COMP_STK_PRINT`(use_dims=`[siz_cd, mat_cd, min_qty]`)에서 완제품가를 통째 조회한다.
  출력+가공이 이미 포함된 시트가격 격자라 소재 원가(연당가)를 절가로 펼치지 않는다(§3.11). 값 계산은
  `evaluate_price` 권위([[rule/rules#RULE_price_value_boundary]]). 홀로그램은 **코팅 축이 없어** 격자가
  (siz_cd, mat_cd, min_qty) 3키뿐(코팅 CONFLICT BATCH-3는 무광/유광 스티커 국한·054 무관).
- **★연당가 재적재 워크리스트(§4-D·돈-크리티컬):** 260702 권위 홀로그램 연당가·국4절가가 급락했으나
  (수치는 아래 '연당가 양면(defect)' 전사표 참조·손전사 금지) 라이브에 원가 저장처가 없다(t_mat_materials
  가격컬럼 부재·COMP_PAPER에 MAT_000163 0행). 이 원가/속성 축을 **양면(defect) 노드 [[matcost-054-hologram]]**
  로 분리 표기 — 이 노드가
  곧 재적재 워크리스트다. **완제품 retail 격자(COMP_STK_PRINT)는 260702 무변경**이라 dual 아님(false-defect
  방지·[[component-COMP_STK_PRINT]]). 원가 급락이 완제품가로 전파돼야 하는지는 열린 질문([[gap-054-yeondangga-repricing]]).
- **정체 공정:** 반칼(Kiss Cut·PROC_000054·mand=N)이 자유형 칼틀 정체 공정([[axis/processes]] 승격 대기).
  화이트 underbase(PROC_000008·mand=N)는 별색인쇄(PROC_000007) 자식 — 홀로그램 위 흰 밑판을 깔아 컬러가
  보이게 한다(도수 아님·`clr_cd=NULL`·[[rule/rules#RULE_dosu_is_printopt]]·pack §3.3). 화이트 가격 배선은
  불투명([[gap-054-white-underbase-price]]).
- **판형(has_plate_size):** 점착지=종이류라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택
  (`fn_best_plate` 자동선택·[[harness-domain-rules-12-260701]]). 단 054는 국전
  ([[axis/plate-sizes#plate-OUTPUT_PAPER_TYPE_01]])이 **아니라** **46계열 전지 SIZ_000521**
  (330×470·OUTPUT_PAPER_TYPE.02·반칼 표준전지)을 쓴다([[plate-054-SIZ_000521]]).
- 도수는 인쇄옵션(POPT_000001 단면)이지 색상코드가 아님([[axis/print-options]]·[[rule/rules#RULE_dosu_is_printopt]]). 홀로스티커=단면만.
- **★반칼 조각수:** PROC_000054는 모양+조각수 input을 갖지만 상품레벨 저장처가 스키마에 없다
  ([[gap-054-piece-count-storage]]·GAP-ST-2/OM-7). 자유형 스티커 공통 미결.
- CPQ 옵션그룹·추가상품·제약규칙·묶음수(bundle_qtys)는 라이브 0행(전사 실측) — 없는 것을 지어내지 않는다.
  화이트 underbase가 선택형(mand=N)이나 캐스케이드 제약(투명 베이스→화이트 requires)은 054에 미등록.
- 끊긴 경로: 연당가 완제품가 전파 여부·화이트 가격 배선·조각수 저장처 = 3 GAP으로 정직 선언.

## 상품 요소 전사 (권위 = 라이브 마스터·260702 diff·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_054.py`가 live-snapshot + 260702 price-diff에서
> 뽑은 값이다(LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-054-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000054 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |
|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 8 | 10000 | 8 | QTY_UNIT.02 | Y | N | Y |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 부모 | main_cat_yn |
|---|---|---|---|
| CAT_000002 | 스티커 | (root) | Y |
| CAT_000309 | 자유형스티커 | CAT_000002 | N |

> 주 카테고리(main_cat_yn=Y)=스티커(CAT_000002)·부=자유형스티커(CAT_000309). 둘 다 공유 axis/categories.md
> 미등재 — 이 상품군(스티커) 첫 노드라 companion이 임시 선언(승격 대기 → needed_shared).

### 사이즈 치수 (전사·주문 링크된 사이즈 + 판형)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes (linked+plate) @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 마스터 del_yn | tags | note |
|---|---|---|---|---|---|---|
| SIZ_000170 | A5(148x210mm) | 148x210 | 148x210 | Y |  |  |
| SIZ_000520 | A4(210x297mm) 반칼 | ?x? | ?x? | N |  | 판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가) |
| SIZ_000521 | 330x470 | 330x470 | 320x460 | N | ["46전지"] | 전지(46계열)·반칼 스티커 표준전지 / 출처: 상품마스터260610·출력소재IMPORT |

> ★SIZ_000170(A5)=주문 사이즈이나 마스터 del_yn=Y(논리삭제)와 상품-사이즈 링크 활성(del_yn=N)이 불일치
> (데이터 관찰·[[size-054-SIZ_000170]]). SIZ_000520(A4 반칼)=work/cut 마스터 컬럼 공백(치수는 라벨에 인코딩).
> SIZ_000521(330×470)=46계열 전지 출력용지(판형·[[plate-054-SIZ_000521]]).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | 평량(weight) | usage_cd | dflt |
|---|---|---|---|---|---|
| MAT_000163 | 홀로그램스티커 | MAT_TYPE.11 | 50.00 | USAGE.07 | Y |

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials upr_mat_cd=MAT_000163 @ 2026-07-03 -->
자식(부모=MAT_000163):
| mat_cd | 이름 | 평량 | 등록일 |
|---|---|---|---|
| MAT_000590 | 홀로그램 스티커 50g |  | 2026-06-30 19:06:42.179119 |

> 홀로그램 점착지 = parent + usage_cd 단일 슬롯(pack §3.5). 정답 자재유형 MAT_TYPE.11(스티커). 자재
> identity(명·평량 50)는 라이브=260702 권위 일치 — ★원가(연당가)만 미저장이라 별도 양면 노드로 분리([[matcost-054-hologram]]).

### ★연당가 양면(defect) — 260702 권위 vs 라이브 현재값 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv 홀로스(홀로그램) 연당가/국4절/구매정보 @ 2026-07-03 -->
| 항목(column) | 셀 | 260527(before) | 260702(after·권위) |
|---|---|---|---|
| 구매정보 | F | 홀로그램50g / 1박스당 500매 | 홀로그램50g / 1박스당 300매 |
| 연당가 | H | 360000 | 253700 |
| 가격 (국4절) | I | 936 | 846 |

> ★라이브 현재값: `t_mat_materials`에 가격(연당가/국4절) 컬럼 없음 + `COMP_PAPER`에 MAT_000163 **0행**
> → 연당가는 라이브 스티커 가격사슬에 **저장 안 됨**(원가 미반영). 평량·명은 일치(50·홀로그램스티커).
> 이 표 = 연당가 재적재 워크리스트(§4-D·[[matcost-054-hologram]]). 어느 쪽도 삭제 금지.

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

> 도수는 인쇄옵션(print_opt_cd)·앞/뒤 색상수(clr)는 인쇄옵션 속성이지 별도 도수축 아님(pack §3.3·T-4 함정). 홀로스티커=단면만.

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes @ 2026-07-03 -->
| proc_cd | 공정명 | 부모공정 | mand | note |
|---|---|---|---|---|
| PROC_000054 | 반칼 |  | N | Kiss Cut, 종이만 (스티커) |
| PROC_000008 | 화이트인쇄 | PROC_000007 | N |  |

> PROC_000054(반칼·Kiss Cut)=스티커 정체 커팅([[process-PROC_000054]]). PROC_000008(화이트 underbase)=별색인쇄
> (PROC_000007) 자식·홀로그램 밑판([[process-PROC_000008]]). 둘 다 mand=N(선택형). 코팅(PROC_000013) 없음.

### 판형 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | note |
|---|---|---|---|---|
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 |  | Y |  |

> ★타 디지털 상품 판형=OUTPUT_PAPER_TYPE.01(국전)인데 054는 46계열(OUTPUT_PAPER_TYPE.02·330×470 46전지).
> 반칼 스티커 표준전지·dflt Y라 fn_best_plate 자동선택([[plate-054-SIZ_000521]]). 삭제된 후보(SIZ_000007/050/057)는 제외.

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints/option_groups @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |

> 수량은 상품레벨 규칙(min 8·incr 8·QTY_UNIT.02)만. CPQ 옵션그룹·추가상품·제약규칙 미등록(정직 표기). 홀로스티커는
> 손님 선택 축이 없는 단순 완제품(단면·홀로그램 고정·모양은 자유형 파일 업로드).

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`sticker-halfcut-hologram` --priced_by--> [[formula-PRF_STK_FIXED]] --has_component-->
[[component-COMP_STK_PRINT]]. 스티커는 **완제품가 고정가 룩업**이라 공식이 단일 구성요소 하나로만 배선된다
(원자합산 아님·pack §3.10). COMP_STK_PRINT의 use_dims=`[siz_cd, mat_cd, min_qty]`가 홀로스티커 가격이 어떤
축으로 달라지는지 선언한다(값 계산은 엔진·D-18).

### 완제품가 격자 요약 COMP_STK_PRINT × MAT_000163 (전사·행수만·값은 KB 밖 D-18)

<!-- transcribed-by: _meta/scripts/transcribe_product_054.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT mat_cd=MAT_000163 @ 2026-07-03 -->
| siz_cd | 수량구간(min_qty) 행수 |
|---|---|
| SIZ_000059 | 36 |
| SIZ_000060 | 36 |
| SIZ_000170 | 36 |
| SIZ_000518 | 36 |
| SIZ_000519 | 36 |
| SIZ_000520 | 36 |

> 총 216행(6 siz_cd × 36 수량구간)·coat_side_cnt 공백(홀로그램=코팅축 없음). 격자 키=(siz_cd, mat_cd, min_qty)·
> 값=완제품 시트가격(출력+가공 포함). 값 절대치는 `evaluate_price` 권위(D-18). ★주문 링크 사이즈
> (SIZ_000170·SIZ_000520)는 격자에 실재 → **가격 경로 성립**. 나머지 siz_cd(059/060/518/519)는 타 스티커 상품과
> 공유하는 격자(MAT_000163이 여러 스티커 상품에 쓰임)·054 주문 대상 아님. 260702 완제품 가격표 무변경(retail dual 아님).

---

## 이 상품 전용 하위 노드

> 카테고리(CAT_000002 스티커·CAT_000309 자유형)·사이즈(SIZ_000170/520)·판형(SIZ_000521 46계열)·자재(MAT_000163 홀로그램)·
> 공정(PROC_000054 반칼·PROC_000008 화이트)·공식(PRF_STK_FIXED)·구성요소(COMP_STK_PRINT)·연당가 양면·수량규칙·GAP 3종은
> [[sticker-halfcut-hologram-nodes]]에 정의(스티커 첫 상품이라 공유 축 미수정·companion 임시 거처·051 썬캡 선례).
> 인쇄옵션(POPT_000001 단면)만 공유 축([[axis/print-options]])의 기존 노드로 해소(중복 mint 금지).
> ★대부분이 다상품 공유 성격(카테고리·자재·공정·공식·구성요소) → 2번째 스티커 집필 시 공유 축 승격(needed_shared).

### [qty-054] 반칼 홀로그램스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000054
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000054(min_qty/max_qty/qty_incr/qty_unit_typ_cd)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {min_max_incr_ref: "본문 전사표(min 8·max 10000·incr 8)", bdl_unit_typ_cd: "QTY_UNIT.02", note: "★상품레벨 수량규칙만 — t_prd_product_bundle_qtys 0행(별도 묶음수 없음). 수량 UI 권위=상품 규칙(pack §3.4·[[rule/decisions#DEC_qty_audit_260702]]). 완제품가 격자의 min_qty 구간(1~100000·36티어)과는 역할 분리(주문 최소=8·격자 구간=가격 조회 키)"}
- 본문: 홀로스티커 주문 수량규칙(min 8·incr 8). 조각수(반칼 판당 개수)와는 다른 축([[gap-054-piece-count-storage]]).
