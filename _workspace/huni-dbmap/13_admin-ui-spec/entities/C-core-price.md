# C군 — 코어/가격/할인/카테고리/코드/고객 admin 입력 명세

> round-8 산출물. admin product-viewer + catalog 의 각 화면·각 항목을 빠짐없이 정의해
> round-7 미적재 매핑 데이터를 라이브 admin에 입력할 수 있게 한다(명세 only, 실 적재 없음).
>
> **권위 3원**: ① 컬럼 스펙 = `docs/huni/table-spec_260608.html`(2026-06-07, 34테이블/332컬럼)
> ② admin change-form = `13_admin-ui-spec/_raw/forms/<model>.json`(위젯·필수·옵션) ③ 라이브 DB
> 코드값·행수 = read-only psql(2026-06-08 실측). 미적재 갭 = `12_coverage/gap-board.md`.
>
> **표 컬럼**: UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면.
> `reg_dt`/`upd_dt` 는 전 테이블 공통 시스템 컬럼 — admin form에 노출 안 됨(서버 자동, reg_dt NOT NULL
> DEFAULT now). 각 표 말미에 1행으로 명기하되 "자동(입력 불가)" 로 표시한다(누락 점검 대상).

## 라이브 실측 요약 (2026-06-08, read-only)

| 테이블 | 행수 | 의미 |
|--------|----:|------|
| t_prd_products | 275 | 상품 마스터 |
| t_cat_categories | 306 | 카테고리(라이프/기념품 등 계층) |
| t_cod_base_codes | 72 | 13 그룹(PRD_TYPE 5·SEMI_ROLE 5·QTY_UNIT 4·CUS_GRADE 2·FRM_TYPE 2·PRC_COMPONENT_TYPE 6·DSC_TYPE 2 …) |
| t_cus_customers | **0** | 미적재(고객 데이터 없음) |
| t_prc_price_formulas | 16 | 공식(합산형 9·단순형 7) |
| t_prc_price_components | 144 | 구성요소 |
| t_prc_component_prices | 3,481 | 다차원 단가(시계열) |
| t_dsc_discount_tables | 7 | 구간할인 마스터(round-1) |
| t_prd_product_categories | 275 | 상품↔카테고리 |
| t_prd_product_price_formulas | 64 | 상품↔공식 바인딩(**64 상품만 가격사슬 보유, 188 상품 미바인딩**) |
| t_prd_product_prices | **0** | 미적재(상품 단가직접 미사용 — 공식엔진이 가격담당) |
| t_prc_formula_components | 85 | 공식↔구성요소 |
| t_prd_product_discount_tables | 98 | 상품↔할인테이블 바인딩 |
| t_dsc_discount_details | 35 | 구간상세(시계열) |
| t_dsc_grade_discount_rates | **0** | 미적재(등급할인 미사용) |

---

## 1. t_prd_products — 상품정보 (catalog: tprdproducts change form, 26필드)

**입력 화면**: catalog `상품정보` 등록/수정 폼. inline으로 `t_prd_product_categories`(상품별카테고리) 다중행 포함.
**FK 선행**: 코드행(PRD_TYPE/SEMI_ROLE/QTY_UNIT)은 t_cod_base_codes에 이미 적재(72행) — select 드롭다운. 카테고리 inline은 t_cat_categories 선행 필요.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인(라이브) | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|------------------|----------------|----------|
| 상품코드 | `prd_cd` | input/text | (자동) | varchar(50) PK | — | 비워두면 서버 자동 채번(PRD_xxxxxx); 신규 상품 시 공란 | catalog |
| MES품목코드 | `mes_item_cd` | input/text | N | varchar(30) | — (전부 NULL) | 입력 안 함(라이브 전부 NULL) | catalog |
| 상품명 | `prd_nm` | input/text | **Y** | varchar(200) | — | 엑셀 master `상품명` 그대로. **JOIN KEY=prd_nm only** | catalog |
| 상품유형 | `prd_typ_cd` | select | **Y** | varchar(50) FK→t_cod_base_codes | PRD_TYPE: 01완제품/02반제품/03기성상품/04디자인상품/05추가상품 | master 상품성격으로 선택(인쇄완제=완제품, 머그=기성상품) | catalog |
| 반제품역할 | `semi_role_cd` | select | N | varchar(50) FK→t_cod_base_codes | SEMI_ROLE: 01내지/02표지/03면지/04간지/05투명커버 | 반제품(책자 내지/표지)만; 완제품은 공란 | catalog |
| 비규격여부 | `nonspec_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 사이즈 자유입력 상품(현수막)=Y, 규격선택=N | catalog |
| 비규격가로최소 | `nonspec_width_min` | input/number | N | numeric(8,2) | — | nonspec_yn=Y일 때 가로 하한(mm). 규격상품 공란 | catalog |
| 비규격가로최대 | `nonspec_width_max` | input/number | N | numeric(8,2) | — | 가로 상한(mm) | catalog |
| 비규격세로최소 | `nonspec_height_min` | input/number | N | numeric(8,2) | — | 세로 하한(mm) | catalog |
| 비규격세로최대 | `nonspec_height_max` | input/number | N | numeric(8,2) | — | 세로 상한(mm) | catalog |
| 파일업로드지원 | `file_upload_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | master `주문방법_파일업로드`=Y/N | catalog |
| 편집기지원 | `editor_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | master `주문방법_편집기`=Y/N | catalog |
| 최소수량 | `min_qty` | input/number | N | integer | — | master `수량_최소` | catalog |
| 최대수량 | `max_qty` | input/number | N | integer | — | master `수량_최대` | catalog |
| 증가단위 | `qty_incr` | input/number | N | integer | — | master `수량_증가단위` | catalog |
| 기본수량 | `dflt_qty` | input/number | N | integer | — | master `수량_기본` | catalog |
| 제약조건JSON | `constraint_json` | (form 미노출) | N | jsonb | — | CPQ 제약(JSONLogic) — admin 폼 미노출, **GAP**(아래 ④) | (미노출) |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 수량단위유형 | `qty_unit_typ_cd` | select | N | varchar(50) FK→t_cod_base_codes | QTY_UNIT: 01EA/02매/03권/04세트 | master 수량단위로 선택 | catalog |
| (inline)주카테고리 | `tprdproductcategories_set-N-cat_cd` 외 | select+number | N | — (FK→t_cat_categories) | 카테고리 트리 | 아래 §2 inline; main_cat_yn/disp_seq/note 동반 | catalog inline |
| 등록일시 | `reg_dt` | (자동) | (스펙 NOT NULL) | timestamp | — | 자동(입력 불가, DEFAULT now) | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동(입력 불가) | — |

**시계열 컬럼 없음**(상품 마스터는 비-시계열). **constraint_json은 admin change form에 없음 → GAP**(CPQ 제약은 product-viewer 별도 화면 또는 DDL 경유).

---

## 2. t_prd_product_categories — 상품별카테고리 (inline within tprdproducts)

**입력 화면**: tprdproducts 폼 내부 inline formset(`tprdproductcategories_set-*`). 독립 화면 아님.
**FK 선행**: `prd_cd`(부모 상품), `cat_cd`(t_cat_categories 선행).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 상품코드 | `prd_cd` | (부모 자동) | Y | varchar(50) PK FK→t_prd_products | — | 부모 상품에서 자동 상속 | inline |
| 카테고리코드 | `cat_cd` | select | N(스펙 PK NOT NULL) | varchar(50) PK FK→t_cat_categories | 카테고리 트리(306행) | master 카테고리 경로로 선택 | inline |
| 주카테고리여부 | `main_cat_yn` | select N/Y | N(스펙 NOT NULL) | char(1) | N/Y | 대표 카테고리 1개만 Y | inline |
| 표시순서 | `disp_seq` | input/number | N | integer | — | 노출 순서(미지정 가능) | inline |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | inline |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 3. t_cat_categories — 카테고리 (catalog: tcatcategories, 6필드)

**입력 화면**: catalog `카테고리` 등록/수정. **FK 선행**: `upr_cat_cd`(자기참조) — 상위 카테고리 먼저 등록 후 자식.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 카테고리코드 | `cat_cd` | input/text | (자동) | varchar(50) PK | — | 공란→자동 채번 | catalog |
| 카테고리명 | `cat_nm` | input/text | **Y** | varchar(100) | — | master 카테고리명 | catalog |
| 상위카테고리 | `upr_cat_cd` | select | N | varchar(50) FK→t_cat_categories(자기참조) | 기존 카테고리(라이프/기념품·액세서리 등) | 최상위=공란, 자식=상위 선택 | catalog |
| 카테고리레벨 | `cat_lvl` | input/number | **Y** | integer | — | 루트=1, 자식은 부모+1 | catalog |
| 표시순서 | `disp_seq` | input/number | N | integer | — | 노출 순서 | catalog |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 4. t_cod_base_codes — 기초코드 (catalog: tcodbasecodes, 6필드)

**입력 화면**: catalog `기초코드`. **FK 선행**: `upr_cod_cd`(자기참조) — 그룹 루트(PRD_TYPE 등) 먼저, 자식 코드 후.
**라이브 13그룹 보유**(아래 코드값 컬럼) — 신규 코드행 추가 시에만 입력. round-7 미적재 갭 중 CODE-ROW(siz/proc/mat 코드행)는 이 화면이 아닌 각 도메인 마스터 화면에서.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인(라이브 그룹) | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------------------|----------------|----------|
| 기초코드 | `cod_cd` | input/text | (자동) | varchar(50) PK | — | 그룹.NN 규칙(예 DSC_TYPE.03) 수동 부여 | catalog |
| 기초코드명 | `cod_nm` | input/text | **Y** | varchar(100) | — | 코드 한글명 | catalog |
| 상위기초코드 | `upr_cod_cd` | select | N | varchar(50) FK→t_cod_base_codes(자기참조) | 13그룹 루트: PRD_TYPE/SEMI_ROLE/QTY_UNIT/CUS_GRADE/FRM_TYPE/PRC_COMPONENT_TYPE/DSC_TYPE/MAT_TYPE/OPT_REF_DIM/OUTPUT_PAPER_TYPE/RULE_TYPE/SEL_TYPE/USAGE | 그룹 루트 선택(루트 자체=공란) | catalog |
| 표시순서 | `disp_seq` | input/number | N | integer | — | 그룹 내 순서 | catalog |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 5. t_cus_customers — 고객 (catalog: tcuscustomers, 5필드)

**입력 화면**: catalog `고객`. **라이브 0행**(미적재). **FK 선행**: `grade_cd`→t_cod_base_codes(CUS_GRADE 적재 완료).
등급별 할인(§15 grade_discount_rates)을 쓰려면 고객 + CUS_GRADE 코드가 선행돼야 한다.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 고객코드 | `cus_cd` | input/text | **Y** | varchar(50) PK | — | 수동 부여(자동채번 아님) | catalog |
| 고객명 | `cus_nm` | input/text | **Y** | varchar(100) | — | 고객명 | catalog |
| 등급코드 | `grade_cd` | select | N | varchar(50) FK→t_cod_base_codes | CUS_GRADE: 01VIP/02일반 | 등급 선택 | catalog |
| 등록일자 | `reg_ymd` | input/text | N | varchar(10) | — | YYYY-MM-DD 문자열(시스템 reg_dt와 별개) | catalog |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 6. t_prc_price_formulas — 가격공식 (catalog: tprcpriceformulas, 5필드)

**입력 화면**: catalog `가격공식`. 가격사슬 1단계(최상위). **FK 선행**: `frm_typ_cd`→t_cod_base_codes(FRM_TYPE 적재 완료).
**라이브 16공식**(예: PRF_DGP_A~F 디지털, PRF_POSTER_FIXED, PRF_STK_FIXED, PRF_PCB_FIXED…).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 공식코드 | `frm_cd` | input/text | **Y** | varchar(50) PK | — | 수동 부여(예 PRF_ACRYLIC_FIXED) | catalog |
| 공식명 | `frm_nm` | input/text | **Y** | varchar(200) | — | 공식 설명명 | catalog |
| 공식유형 | `frm_typ_cd` | select | **Y** | varchar(50) FK→t_cod_base_codes | FRM_TYPE: 01합산형/02단순형 | 합산형(원자합산)·단순형(룩업) 중 택 | catalog |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | catalog |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 7. t_prc_price_components — 가격구성요소 (catalog: tprcpricecomponents, 5필드)

**입력 화면**: catalog `가격구성요소`. 가격사슬 2단계. **FK 선행**: `comp_typ_cd`→t_cod_base_codes(PRC_COMPONENT_TYPE 적재).
**라이브 144행**.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 구성요소코드 | `comp_cd` | input/text | **Y** | varchar(50) PK | — | 수동 부여(예 COMP_ACR_3T) | catalog |
| 구성요소명 | `comp_nm` | input/text | **Y** | varchar(200) | — | 구성요소명 | catalog |
| 구성요소유형 | `comp_typ_cd` | select | N | varchar(50) FK→t_cod_base_codes | PRC_COMPONENT_TYPE: 01인쇄비/02코팅비/03용지비/04후가공비/05박형압비/06완제품비 | 비용 성격 선택 | catalog |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | catalog |
| 사용여부 | `use_yn` | select Y/N | N(스펙 NOT NULL) | char(1) | Y/N | 기본 Y | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 8. t_prc_formula_components — 공식별구성요소 (table-spec 권위; admin form 미등록 → product-viewer/inline)

**입력 화면**: 독립 change form 없음(form dump 미존재). 공식↔구성요소 매핑은 product-viewer 가격사슬 화면의 inline 또는 직접 DML. 가격사슬 3단계(공식 구성). **FK 선행**: `frm_cd`(§6), `comp_cd`(§7) 둘 다 선행. **라이브 85행**.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 공식코드 | `frm_cd` | select | Y | varchar(50) PK FK→t_prc_price_formulas | 16공식 | 대상 공식 선택 | product-viewer |
| 구성요소코드 | `comp_cd` | select | Y | varchar(50) PK FK→t_prc_price_components | 144구성요소 | 공식에 포함할 구성요소 선택 | product-viewer |
| 표시순서 | `disp_seq` | input/number | N | integer | — | 합산 순서 | product-viewer |
| 가산여부 | `addtn_yn` | select Y/N | N | char(1) | Y/N | 합산형=Y(가산 항목), 단순형=N/단일 | product-viewer |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> **GAP-FORM**: 이 테이블의 catalog change form dump가 _raw/forms에 없음 → admin 직접 등록 경로 불명확.
> product-viewer 가격사슬 편집탭 또는 DB 직접 적재(인간 승인)로 처리 가정. C군에서 admin 입력 경로 미확정 1건.

---

## 9. t_prc_component_prices — 구성요소 다차원 단가 (catalog: tprccomponentprices, 10필드) — **시계열**

**입력 화면**: catalog `구성요소단가`. 가격사슬 4단계(실 단가). **시계열**: `apply_ymd`(적용일자, PK 아님이나 사실상 버전키).
**FK 선행**: `comp_cd`(§7), 차원키 `siz_cd`(t_siz_sizes)·`clr_cd`(t_clr_color_counts)·`mat_cd`(t_mat_materials) 각 마스터 선행. **라이브 3,481행**.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 구성요소단가ID | `comp_price_id` | (자동) | (PK NOT NULL) | bigint PK IDENTITY | — | 자동(시퀀스). **stale 시 setval 재동기화 주의** | catalog |
| 구성요소코드 | `comp_cd` | select | **Y** | varchar(50) FK→t_prc_price_components | 144구성요소 | 단가가 속한 구성요소 선택 | catalog |
| 적용일자 | `apply_ymd` | input/text | **Y** | varchar(10) | — | YYYY-MM-DD(시계열 버전). 통상 '2025-01-01' 등 | catalog |
| 사이즈코드 | `siz_cd` | select | N | varchar(50) FK→t_siz_sizes | 사이즈 마스터 | 면적/규격 차원이면 선택, 비차원이면 공란 | catalog |
| 도수코드 | `clr_cd` | select | N | varchar(50) FK→t_clr_color_counts | 도수 마스터 | 인쇄 도수 차원이면 선택. **별색=공정(clr_cd=NULL)** | catalog |
| 자재코드 | `mat_cd` | select | N | varchar(50) FK→t_mat_materials | 자재 마스터 | 소재 차원이면 선택 | catalog |
| 코팅면수 | `coat_side_cnt` | input/number | N | integer | — | 코팅비 단가의 면수 차원 | catalog |
| 묶음수 | `bdl_qty` | input/number | N | integer | — | 묶음 차원키(STK 등) | catalog |
| 수량구간하한 | `min_qty` | input/number | N | integer | — | 수량구간 단가의 하한 | catalog |
| 단가 | `unit_price` | input/number | N | numeric(12,2) | — | 해당 차원조합의 단가(원) | catalog |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> **시계열 주의**: apply_ymd 가 단가 버전키. 가격 개정 시 같은 차원조합을 새 apply_ymd 로 추가(덮어쓰지 않음).
> 런타임은 조회시점 ≤ apply_ymd 최신본을 사용. off-grid 사이즈는 한 단계 큰 siz_cd 의 단가를 ceiling으로 적용(앱 계산).

---

## 10. t_prd_product_price_formulas — 상품별 가격공식 바인딩 (product-viewer)

**입력 화면**: product-viewer 상품 편집의 `가격공식` 바인딩(또는 catalog inline — form dump 미존재). 가격사슬을 상품에 연결하는 마지막 고리. **FK 선행**: `prd_cd`(§1), `frm_cd`(§6). **라이브 64행**(= 64 상품만 가격사슬 보유, 188 미바인딩).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 상품코드 | `prd_cd` | select | Y | varchar(50) PK FK→t_prd_products | 275상품 | 대상 상품 | product-viewer |
| 공식코드 | `frm_cd` | select | Y | varchar(50) PK FK→t_prc_price_formulas | 16공식 | 상품에 적용할 공식 | product-viewer |
| 적용시작일자 | `apply_bgn_ymd` | input/text | N(스펙 NULL허용) | varchar(10) | — | YYYY-MM-DD(시계열 시작) | product-viewer |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | product-viewer |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> **GAP-FORM**: catalog change form dump 미존재. product-viewer 가격탭 바인딩 또는 적재 SQL(인간 승인) 경로.

---

## 11. t_prd_product_prices — 상품단가 (table-spec; **라이브 0행, 미사용**) — **시계열**

**입력 화면**: 미사용(가격은 공식엔진 t_prc_* 가 담당). table-spec 컬럼은 정의하나 라이브 0행. **FK 선행**: `prd_cd`(§1).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 상품코드 | `prd_cd` | — | Y | varchar(50) PK FK→t_prd_products | — | (미사용 — 단일 고정단가 상품 도입 시에만) | (미사용) |
| 적용일자 | `apply_ymd` | — | Y | varchar(10) PK | — | YYYY-MM-DD(시계열) | (미사용) |
| 단가 | `unit_price` | — | N | numeric(12,2) | — | 단일가 | (미사용) |
| 비고 | `note` | — | N | varchar(500) | — | — | — |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> 가격사슬 미적재 6 상품군(§아래 ④)은 이 테이블이 아니라 §6~§10 공식엔진 경로로 채운다.

---

## 12. t_dsc_discount_tables — 수량구간할인 마스터 (catalog: tdscdiscounttables, 4필드)

**입력 화면**: catalog `할인테이블`. **라이브 7행**(DSC_ACR_QTY 등 round-1). FK 없음(루트 마스터).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 할인테이블코드 | `dsc_tbl_cd` | input/text | **Y** | varchar(50) PK | — | 수동 부여(예 DSC_ACR_QTY) | catalog |
| 할인테이블명 | `dsc_tbl_nm` | input/text | **Y** | varchar(100) | — | 할인표 설명명 | catalog |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | catalog |
| 사용여부 | `use_yn` | input/text | **Y**(form req=true) | char(1) | Y/N | 'Y' 직접 입력(이 form은 text 위젯) | catalog |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## 13. t_dsc_discount_details — 수량구간할인상세 (table-spec; admin form 미등록 → inline/product-viewer) — **시계열**

**입력 화면**: 독립 form dump 미존재. 할인테이블의 구간행 — catalog 할인테이블 inline 또는 직접 DML. **시계열**: `apply_ymd`(PK). **FK 선행**: `dsc_tbl_cd`(§12), `dsc_typ_cd`→t_cod_base_codes(DSC_TYPE). **라이브 35행**.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 할인테이블코드 | `dsc_tbl_cd` | select | Y | varchar(50) PK FK→t_dsc_discount_tables | 7테이블 | 대상 할인테이블 | inline/viewer |
| 적용일자 | `apply_ymd` | input/text | Y | varchar(10) PK | — | YYYY-MM-DD(시계열) | inline/viewer |
| 수량구간하한 | `min_qty` | input/number | Y | integer PK | — | 구간 시작 수량 | inline/viewer |
| 수량구간상한 | `max_qty` | input/number | N | integer | — | 구간 끝(무제한=NULL/큰값) | inline/viewer |
| 할인유형 | `dsc_typ_cd` | select | N | varchar(50) FK→t_cod_base_codes | DSC_TYPE: 01정률/02정액 | 정률(%)·정액(원) 택 | inline/viewer |
| 할인율 | `dsc_rate` | input/number | N | numeric(5,2) | — | 정률 시 %값 | inline/viewer |
| 할인액 | `dsc_amt` | input/number | N | numeric(12,2) | — | 정액 시 원값 | inline/viewer |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | inline/viewer |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> **GAP-FORM**: 독립 change form 없음. 할인테이블 화면 inline 또는 적재 SQL(인간 승인). dsc_rate/dsc_amt 는 dsc_typ_cd에 따라 택일 입력.

---

## 14. t_prd_product_discount_tables — 상품별 할인테이블 바인딩 (product-viewer) — **시계열(시작일)**

**입력 화면**: product-viewer 상품 편집의 `할인테이블` 바인딩(form dump 미존재). **FK 선행**: `prd_cd`(§1), `dsc_tbl_cd`(§12). **라이브 98행**.

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 상품코드 | `prd_cd` | select | Y | varchar(50) PK FK→t_prd_products | 275상품 | 대상 상품 | product-viewer |
| 할인테이블코드 | `dsc_tbl_cd` | select | Y | varchar(50) PK FK→t_dsc_discount_tables | 7테이블 | 적용할 할인표 | product-viewer |
| 적용시작일자 | `apply_bgn_ymd` | input/text | Y(스펙 PK NOT NULL) | varchar(10) PK | — | YYYY-MM-DD(시계열 시작) | product-viewer |
| 비고 | `note` | input/text | N | varchar(500) | — | 선택 | product-viewer |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

> 권위: 상품마스터 `구간할인적용테이블` 컬럼(행별). 파우치/아크릴은 카테고리 단위([[dbmap-discount-authority]]).

---

## 15. t_dsc_grade_discount_rates — 등급별할인율 (table-spec; **라이브 0행, 미사용**) — **시계열**

**입력 화면**: 미사용(0행). table-spec 정의만. **FK 선행**: `grade_cd`→t_cod_base_codes(CUS_GRADE), `cat_cd`→t_cat_categories, `dsc_typ_cd`→t_cod_base_codes(DSC_TYPE).

| UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약 | 코드값 도메인 | 미적재 시 입력법 | 입력 화면 |
|--------|------|------|:--:|----------|--------------|----------------|----------|
| 등급코드 | `grade_cd` | select | Y | varchar(50) PK FK→t_cod_base_codes | CUS_GRADE: 01VIP/02일반 | 등급할인 도입 시 등급 선택 | (미사용) |
| 카테고리코드 | `cat_cd` | select | Y | varchar(50) PK FK→t_cat_categories | 306카테고리 | 적용 카테고리 | (미사용) |
| 적용일자 | `apply_ymd` | input/text | Y | varchar(10) PK | — | YYYY-MM-DD(시계열) | (미사용) |
| 할인유형 | `dsc_typ_cd` | select | N | varchar(50) FK→t_cod_base_codes | DSC_TYPE: 01정률/02정액 | 정률/정액 | (미사용) |
| 할인율 | `dsc_rate` | input/number | N | numeric(5,2) | — | 정률 %값 | (미사용) |
| 할인액 | `dsc_amt` | input/number | N | numeric(12,2) | — | 정액 원값 | (미사용) |
| 비고 | `note` | input/text | N | varchar(500) | — | — | — |
| 등록일시 | `reg_dt` | (자동) | (NOT NULL) | timestamp | — | 자동 | — |
| 수정일시 | `upd_dt` | (자동) | N | timestamp | — | 자동 | — |

---

## ③ 시계열 컬럼 입력 주의 (전 테이블 횡단)

| 테이블 | 시계열 컬럼 | 입력 규칙 |
|--------|-----------|----------|
| t_prc_component_prices | `apply_ymd` | 단가 개정 시 같은 차원조합을 **새 일자로 추가**(덮어쓰기 금지). 런타임 ≤ 조회시점 최신본 적용 |
| t_prd_product_price_formulas | `apply_bgn_ymd` | 공식 교체 시작일. NULL 허용(상시) |
| t_prd_product_prices | `apply_ymd` (PK) | 미사용. 도입 시 일자별 누적 |
| t_dsc_discount_details | `apply_ymd` (PK) | 할인율 개정 일자별 누적 |
| t_prd_product_discount_tables | `apply_bgn_ymd` (PK) | 할인표 바인딩 시작일(PK 일부 — 필수 입력) |
| t_dsc_grade_discount_rates | `apply_ymd` (PK) | 미사용 |

> 공통 함정: 명시 NULL 입력은 reg_dt DEFAULT를 발화시키지 않음 → reg_dt는 form 미노출(서버 자동). apply_ymd 류 문자열 일자는 varchar(10) 'YYYY-MM-DD' 형식 준수.

## ④ round-7 미적재 갭 연결

### (가) 가격사슬 미적재 6 상품군 → admin 입력 순서 (gap-board §3)
대상: **포토북·캘린더·디자인캘린더·아크릴·굿즈파우치·상품악세사리**(formula+component_prices 0행). 채우는 순서:

1. **공식 등록** — catalog `가격공식`(§6): `frm_cd`/`frm_nm`/`frm_typ_cd`(합산형 or 단순형). 예: 아크릴=면적매트릭스 → `PRF_ACRYLIC_FIXED`(단순형 룩업).
2. **구성요소 등록** — catalog `가격구성요소`(§7): 공식이 합산할 항목(인쇄가공비/코팅비 등) `comp_cd`+`comp_typ_cd`.
3. **공식-구성요소 매핑** — `t_prc_formula_components`(§8): frm_cd↔comp_cd, addtn_yn(합산형=Y). **GAP-FORM**: 독립 폼 없음 → product-viewer 또는 SQL.
4. **단가 등록** — catalog `구성요소단가`(§9): comp_cd + 차원키(siz_cd/clr_cd/mat_cd/min_qty 등) + `apply_ymd` + `unit_price`. 차원행(siz/mat)이 미적재면 해당 마스터 선행(CODE-ROW/SIZ-REG).
5. **상품 바인딩** — `t_prd_product_price_formulas`(§10): prd_cd↔frm_cd. 이게 있어야 188 미바인딩 상품이 가격사슬을 획득. **GAP-FORM**.

> 선행 종속: siz_cd/clr_cd/mat_cd 차원행이 component_prices의 FK이므로, 차원행 미적재(굿즈 sizes 87·아크릴 sizes 2 등)는 §9 입력 전에 각 마스터 화면(D군/E군 스코프)에서 먼저 채워야 한다.

### (나) DB-ONLY 17셀 외부권위 판별 — 확인할 컬럼/값 (gap-board §6)
- **discount_tables(아크릴/굿즈/문구 6~81행)**: 정당성 확인 = 상품마스터 `구간할인적용테이블` 컬럼 존재 여부 + `t_prd_product_discount_tables`(§14) 바인딩 행이 round-1 배정([[dbmap-discount-authority]])과 일치하는지. 굿즈파우치는 master 컬럼 보유 → 정당.
- **plate_sizes(EXT-LOAD)**: D군 스코프이나 가격사슬 관점 — 가격표 `판걸이수`(출력판형) 권위. C군에서는 component_prices `siz_cd`가 출력판형 siz를 참조하는지 확인.
- **product-accessory opt_groups/options/constraints(OPP비접착봉투 잔재)**: C군 t_prd_products `constraint_json` 컬럼이 비어있는지 + 해당 상품 가격사슬(§10 바인딩) 유무로 "의도된 옵션 vs 테스트 잔재" 1차 판별. 발명 금지 — OVER-LOAD 후보로 남김.

---

## 누락 점검 (table-spec 전 컬럼 = 1행씩 매핑 확인)

| 엔티티 | table-spec 컬럼수 | 본 명세 행수 | 누락 |
|--------|----:|----:|:--:|
| t_prd_products | 21 | 21 (+inline 1요약) | 0 |
| t_prd_product_categories | 7 | 7 | 0 |
| t_cat_categories | 8 | 8 | 0 |
| t_cod_base_codes | 8 | 8 | 0 |
| t_cus_customers | 7 | 7 | 0 |
| t_prc_price_formulas | 7 | 7 | 0 |
| t_prc_price_components | 7 | 7 | 0 |
| t_prc_formula_components | 6 | 6 | 0 |
| t_prc_component_prices | 13 | 13 | 0 |
| t_prd_product_price_formulas | 6 | 6 | 0 |
| t_prd_product_prices | 6 | 6 | 0 |
| t_dsc_discount_tables | 6 | 6 | 0 |
| t_dsc_discount_details | 10 | 10 | 0 |
| t_prd_product_discount_tables | 6 | 6 | 0 |
| t_dsc_grade_discount_rates | 9 | 9 | 0 |
| **합계** | **127** | **127** | **0** |

> 전 컬럼 누락 0. `reg_dt`/`upd_dt`(테이블당 2)는 form 미노출 시스템 컬럼이나 명세에 "자동(입력 불가)"로 1행씩 포함.

## GAP 요약 (admin 입력 경로 불명확)
- **GAP-FORM ×4**: `t_prc_formula_components`·`t_prd_product_price_formulas`·`t_dsc_discount_details`·`t_prd_product_discount_tables` — catalog change form dump 미존재. product-viewer inline 또는 적재 SQL(인간 승인) 가정.
- **GAP(constraint_json)**: t_prd_products `constraint_json`(jsonb) admin change form 미노출 → CPQ 제약 입력 경로는 product-viewer 별도 또는 DDL.
- **미사용 2테이블**: t_prd_product_prices(0행)·t_dsc_grade_discount_rates(0행) — 가격은 공식엔진, 등급할인 현행 미사용.
