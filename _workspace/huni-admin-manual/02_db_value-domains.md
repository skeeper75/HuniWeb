# 후니 Admin DB 값 도메인·제약 실측표 (라이브 권위)

> **산출자:** ham-db-verifier · **권위:** 라이브 Railway PostgreSQL 18.4 `railway` DB (읽기전용 SELECT 실측, 2026-06-10)
> **목적:** `01_source_admin-screen-map.md`가 도출한 admin 입력 항목이 **실제로 어떤 값을 받는지**를 라이브 DB로 확정.
>   소스(Django admin.py 선언) ↔ 라이브 실제값을 대조해 운영자 입력 가이드의 근거를 제공.
> **재현:** `scripts/db-value-domains.sh <counts|codes|columns|checks|fks|pks|domains|samples|all>`
> **접속 성공 여부:** ✅ 성공 (railway DB, 비표준 포트, 자격증명 `.env.local RAILWAY_DB_*`).

---

## 0. 핵심 발견 (운영·작성 영향 큰 순)

1. **`pg_stat_user_tables.n_live_tup`는 stale → 행수 권위는 `count(*)`.** stat은 여러 테이블을 0으로 보고했으나 실제로는 적재됨(예: `t_prd_product_print_options` stat=0 → 실제 **166행**, `t_dsc_discount_tables` stat=0 → 실제 **7행**, `t_prc_component_prices` stat=2562 → 실제 **3481행**). 본 문서의 모든 행수는 count(*) 기준.
2. **자유텍스트 입력 2종(코드값 아님)** — 운영자가 드롭다운이 아니라 **직접 타이핑**:
   - `t_prd_product_plate_sizes.output_file_typ` — `JPG`·`PDF`·`AI`·`*AI(칼선)`·`AI_CS5 (칼선)`·`JPG #1`·`PDF(W)`·`*아이마크`·`*파일재작업 후 주문` 등 **16종 변형**(표기 불일치 존재 → 운영자 입력 가이드에 표준 표기 권장 필요).
   - `t_prd_product_print_options.print_side` — `단면`(62)·`양면`(41)·`투명테두리`(21)·`배면양면`(21)·`풀빼다`(21) **5종 자유 한글 라벨**(VARCHAR(20), FK 아님).
3. **소스 코드값 부록과 라이브 불일치(라이브 권위)** — 화면 맵 부록(MAT_TYPE .01~.11)과 라이브 일치하나, 라이브 `MAT_TYPE.10=악세사리`·`MAT_TYPE.11=스티커`가 명시 확인됨(맵 §부록엔 .10/.11 코멘트 없었음). **코드값 권위 = 라이브 `t_cod_base_codes`**.
4. **빈(미적재) 테이블 4종** = `t_cus_customers`(0)·`t_dsc_grade_discount_rates`(0)·`t_prd_product_prices`(0)·`t_prd_template_prices`(0). 운영자가 해당 화면을 열면 빈 목록을 보게 됨.
5. **`RULE_TYPE.01 호환`은 `use_yn='N'`(라이브 비활성)** + 실제 제약도 호환 미사용(`RULE_TYPE.02 금지`×3, `RULE_TYPE.03 필수동반`×1). 운영자 제약 폼빌더에서 "호환" 규칙유형은 드롭다운에 안 뜰 수 있음(use_yn 필터 시).
6. **모든 `*_yn`은 CHECK = Y/N 고정**(아래 §2). 소스 admin이 YN 드롭다운으로 처리하는 것과 정확히 일치. `t_dsc_discount_tables`·`t_dsc_discount_details`만 YN_ENHANCE_EXCLUDE(소스)이나 DB CHECK는 동일.

---

## 1. 코드값 그룹 사전 — `t_cod_base_codes` (총 72행 = 그룹 17 + 하위값 55)

운영자가 `*_typ_cd`·`grade_cd`·`usage_cd`·`ref_dim_cd` 등 FK 드롭다운에서 보게 될 **전체 선택지**. 모두 `t_cod_base_codes`를 FK 참조(ON DELETE RESTRICT — 사용 중이면 삭제 불가). 그룹코드(예 `MAT_TYPE`)는 루트, 하위값(`MAT_TYPE.NN`)이 실제 선택지.

| 그룹코드 (한글) | 하위 코드값 (코드 = 의미) | 비고 |
|---|---|---|
| **PRD_TYPE** (상품유형) | .01 완제품 · .02 반제품 · .03 기성상품 · .04 디자인상품 · .05 추가상품 | `t_prd_products.prd_typ_cd` |
| **QTY_UNIT** (수량단위) | .01 EA · .02 매 · .03 권 · .04 세트 | `qty_unit_typ_cd`, `bdl_unit_typ_cd` 공용 |
| **SEMI_ROLE** (반제품역할) | .01 내지 · .02 표지 · .03 면지 · .04 간지 · .05 투명커버 | `t_prd_products.semi_role_cd` (반제품만) |
| **MAT_TYPE** (자재유형) | .01 종이 · .02 필름 · .03 아크릴 · .04 금속 · .05 원단 · .06 가죽 · .07 부속 · .08 실사소재 · .09 파우치 · .10 악세사리 · .11 스티커 | `t_mat_materials.mat_typ_cd` |
| **SEL_TYPE** (선택유형) | .01 단일 · .02 다중 | `sel_typ_cd` (자재·옵션그룹) |
| **USAGE** (용도) | .01 내지 · .02 표지 · .03 면지 · .04 간지 · .05 투명커버 · .06 표지타입 · .07 공통 | `t_prd_product_materials.usage_cd` (PK 일부, 필수) |
| **OUTPUT_PAPER_TYPE** (출력용지유형) | .01 국전계열 · .02 46계열 · .03 기타 | `t_prd_product_plate_sizes.output_paper_typ_cd` |
| **OPT_REF_DIM** (옵션참조차원유형) | .01 사이즈 · .02 판형 · .03 자재 · .04 공정 · .05 묶음수 · .06 도수 · .07 셋트 | CPQ `ref_dim_cd` (옵션항목·템플릿선택값) |
| **FRM_TYPE** (공식유형) | .01 합산형 · .02 단순형 | `t_prc_price_formulas.frm_typ_cd` |
| **PRC_COMPONENT_TYPE** (가격구성요소유형) | .01 인쇄비 · .02 코팅비 · .03 용지비 · .04 후가공비 · .05 박형압비 · .06 완제품비 | `t_prc_price_components.comp_typ_cd` |
| **DSC_TYPE** (할인유형) | .01 정률 · .02 정액 | 할인상세·등급할인율 (정률↔정액 택일, CHECK) |
| **RULE_TYPE** (제약규칙유형) | .01 호환 **(use_yn=N)** · .02 금지 · .03 필수동반 | `t_prd_product_constraints.rule_typ_cd` |
| **CUS_GRADE** (고객등급) | .01 VIP · .02 일반 | `t_cus_customers.grade_cd` |

> **그룹 17종 전체(루트 코드):** PRD_TYPE · QTY_UNIT · SEMI_ROLE · MAT_TYPE · SEL_TYPE · USAGE · OUTPUT_PAPER_TYPE · OPT_REF_DIM · FRM_TYPE · PRC_COMPONENT_TYPE · DSC_TYPE · RULE_TYPE · CUS_GRADE (+ 위 표에 펼쳐진 13개 그룹). 자기참조 FK `upr_cod_cd → t_cod_base_codes(cod_cd)`.
> **자동채번(소스):** 기초코드는 상위코드 선택 + 코드 비움 → `{GROUP}.NN`(그룹 내 max+1). 둘 다 비면 폼 오류.

### 도수(`t_clr_color_counts`) — 코드성 마스터 5종 (FK 대상)
| clr_cd | clr_nm | chnl_cnt |
|---|---|---|
| CLR_000001 | 인쇄 안 함 | 0 |
| CLR_000002 | 1도(흑백) | 1 |
| CLR_000003 | 2도 | 2 |
| CLR_000004 | 3도 | 3 |
| CLR_000005 | CMYK 4도 | 4 |
> `t_prd_product_print_options.front_colrcnt_cd`·`back_colrcnt_cd`가 FK 참조(NOT NULL). 운영자는 이 5개 중 선택.

---

## 2. 횡단 제약 — `*_yn` CHECK (모두 Y/N 고정)

DB CHECK로 강제되는 Y/N 컬럼. 소스 admin의 **YN 드롭다운**과 일치. 운영자가 Y/N 외 값 저장 시도 시 **CHECK 위반으로 저장 실패**.

| 컬럼 (의미) | 보유 테이블 | DEFAULT(라이브) |
|---|---|---|
| `use_yn` (사용여부) | 거의 모든 마스터/차원/CPQ | 일부 `'Y'`(constraints·option_*·templates·tmpl_sel), 그 외 명시 입력 |
| `del_yn` (삭제여부=논리삭제) | 소프트삭제 보유 모델 전부 | `'N'` |
| `nonspec_yn` (비규격) `editor_yn` `file_upload_yn` | t_prd_products | 명시 입력(NOT NULL, default 없음) |
| `dflt_yn`·`dflt_plt_yn` (기본값) | sizes·materials·print_options·bundle_qtys·plate_sizes·options | 명시 |
| `main_cat_yn` (주카테고리) | product_categories | 명시 |
| `mand_yn`·`mand_proc_yn` (필수) | option_groups·processes | option_groups는 nullable |
| `impos_yn` (조판판형여부) | t_siz_sizes | 명시 NOT NULL |
| `addtn_yn` (가산여부) | t_prc_formula_components | nullable, 라이브 전부 `Y`(85행) |

> **DEFAULT 함정(메모리 [[dbmap-round5-load-execution]]):** `reg_dt`는 전 테이블 NOT NULL DEFAULT `now()`. 명시 NULL 전송 시 DEFAULT 미발화 → 저장 실패. 소스 admin은 reg_dt를 readonly + python default(timezone.now)로 회피.
> **할인 정률/정액 배타 CHECK:** `t_dsc_discount_details`·`t_dsc_grade_discount_rates` → `(dsc_rate IS NULL OR dsc_amt IS NULL)`. 운영자가 할인율과 할인액을 **동시 입력하면 저장 실패**(둘 중 하나만).

---

## 3. 모델별 컬럼 → 타입·필수·도메인·제약 (standalone 13 + 주요 차원/CPQ)

표기: **필수**=NOT NULL(default 없음) · `default`=DEFAULT 보유 · 타입은 라이브 `information_schema` 권위.
감사컬럼 `reg_dt`(NOT NULL default now)·`upd_dt`(nullable)는 모든 표에서 생략(소스 admin readonly).

### 3-1. 상품정보 `t_prd_products` (275행, PK=prd_cd, 자동채번 PRD_)
| 컬럼 | 타입 | 필수 | 도메인/제약 | 라이브 실제 사용값 |
|---|---|---|---|---|
| prd_cd | varchar(50) | PK | 자동채번 `PRD_000000` | PRD_000001~ |
| MES_ITEM_CD | varchar(30) | 선택 | — | 대부분 NULL(메모리: 전부 NULL) |
| prd_nm | varchar(200) | **필수** | — | OPP접착봉투, 카드봉투… |
| prd_typ_cd | varchar(50) | **필수** | FK→PRD_TYPE | .02 반제품×28 · .03 기성상품×123 · .04 디자인상품×121 · .05 추가상품×3 (※.01 완제품 라이브 미사용) |
| semi_role_cd | varchar(50) | 선택 | FK→SEMI_ROLE | NULL×247 · .01 내지×3 · .02 표지×10 · .03 면지×15 (반제품에만) |
| nonspec_yn | char(1) | **필수** | CHECK Y/N | N×250 · Y×25 |
| nonspec_width_min/max, height_min/max | numeric | 선택 | 비규격 상품만 | nonspec_yn=Y일 때 채움 |
| file_upload_yn | char(1) | **필수** | CHECK Y/N | Y×219 · N×56 |
| editor_yn | char(1) | **필수** | CHECK Y/N | N×158 · Y×117 |
| min_qty/max_qty/qty_incr/dflt_qty | integer | 선택 | — | — |
| qty_unit_typ_cd | varchar(50) | 선택 | FK→QTY_UNIT | .01 EA×172 · .02 매×52 · .03 권×21 · NULL×30 |
| constraint_json | jsonb | 선택 | 제약 캐시(컴파일 산출) | — |
| use_yn | char(1) | **필수** | CHECK Y/N | Y×247 · N×28 |

### 3-2. 자재정보 `t_mat_materials` (340행, PK=mat_cd, 자동채번 MAT_)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| mat_cd | varchar(50) | PK | 자동채번 MAT_ | |
| mat_nm | varchar(200) | **필수** | | 화이트면지, 블랙면지… |
| mat_typ_cd | varchar(50) | **필수** | FK→MAT_TYPE | .01 종이×107 · .09 파우치×75 · .10 악세사리×43 · .07 부속×33 · .08 실사소재×22 · .04 금속×19 · .03 아크릴×14 · .11 스티커×11 · .05 원단×7 · .02 필름×5 · .06 가죽×4 |
| upr_mat_cd | varchar(50) | 선택 | 자기참조 FK(트리) | 트리 드롭다운(parents_only) |
| sel_typ_cd | varchar(50) | 선택 | FK→SEL_TYPE | NULL×307 · .01 단일×31 · .02 다중×2 |
| max_sel_cnt | integer | 선택 | | |
| width/height/depth/weight | numeric | 선택 | 가로/세로/높이·두께/무게 | |
| bdl_qty | integer | 선택 | 묶음수 | |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-3. 사이즈정보 `t_siz_sizes` (510행, PK=siz_cd, 자동채번 SIZ_)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| siz_cd | varchar(50) | PK | 자동채번 SIZ_ | |
| siz_nm | varchar(50) | **필수** | | 73x98, 100x150… |
| work_width/height, cut_width/height | numeric | 선택 | 작업·재단 치수 | |
| margin_top/bot/lft/rgt | numeric | 선택 | 여백 4방 | |
| impos_yn | char(1) | **필수** | CHECK Y/N (조판판형여부) | N×431 · Y×79 |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-4. 도수정보 `t_clr_color_counts` (5행, 자동채번 CLR_) → §1 도수표 참조
`clr_nm`(필수), `chnl_cnt`(필수 integer), `use_yn`(필수 CHECK), `del_yn` default N.

### 3-5. 공정정보 `t_proc_processes` (84행, PK=proc_cd, 자동채번 PROC_)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| proc_cd | varchar(50) | PK | 자동채번 PROC_ | |
| proc_nm | varchar(200) | **필수** | | 인쇄, UV, 옵셋, 디지털, 실크, 실사, 별색인쇄, 화이트… |
| upr_proc_cd | varchar(50) | 선택 | 자기참조 FK(트리, parents_only) | 인쇄(PROC_000001) 하위에 UV/옵셋/디지털… |
| prcs_dtl_opt | jsonb | 선택 | 공정상세옵션 | |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-6. 카테고리 `t_cat_categories` (306행, PK=cat_cd, 자동채번 CAT_)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| cat_cd | varchar(50) | PK | 자동채번 CAT_ | |
| cat_nm | varchar(100) | **필수** | | |
| upr_cat_cd | varchar(50) | 선택 | 자기참조 FK(트리, exclude_leaf_level) | |
| cat_lvl | integer | **필수** | 레벨 | lvl1×12 · lvl2×121 · lvl3×173 |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-7. 기초코드정보 `t_cod_base_codes` (72행) → §1 사전이 권위
`cod_cd`(PK), `cod_nm`(필수), `upr_cod_cd`(선택 자기참조, 루트만 드롭다운), `use_yn`(필수 CHECK). 자동채번 `{GROUP}.NN`.

### 3-8. 가격공식 `t_prc_price_formulas` (16행, PK=frm_cd, 자동채번 아님→직접 입력)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| frm_cd | varchar(50) | PK | 수동 입력(시리얼 대상 아님) | PRF_DGP_A, PRF_POSTER_FIXED… |
| frm_nm | varchar(200) | **필수** | | 디지털인쇄 원자합산형A… |
| frm_typ_cd | varchar(50) | **필수** | FK→FRM_TYPE | .01 합산형×8 · .02 단순형×8 |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-9. 가격구성요소 `t_prc_price_components` (144행, PK=comp_cd, 수동 입력)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| comp_cd | varchar(50) | PK | 수동 | |
| comp_nm | varchar(200) | **필수** | | |
| comp_typ_cd | varchar(50) | 선택 | FK→PRC_COMPONENT_TYPE | .06 완제품비×91 · .04 후가공비×33 · .01 인쇄비×15 · .02 코팅비×2 · .05 박형압비×2 · .03 용지비×1 |
| use_yn | char(1) | **필수** | CHECK Y/N | |

### 3-10. 구성요소 다차원 단가 `t_prc_component_prices` (3481행, PK=comp_price_id BigAuto)
| 컬럼 | 타입 | 필수 | 도메인 |
|---|---|---|---|
| comp_price_id | bigint | PK | DB 자동(BigAutoField) |
| comp_cd | varchar(50) | **필수** | FK→price_components |
| apply_ymd | varchar(10) | **필수** | 적용일자(YYYYMMDD 문자열) |
| siz_cd / clr_cd / mat_cd | varchar(50) | 선택 | 차원 키(FK→각 마스터, CASCADE) |
| coat_side_cnt / bdl_qty / min_qty | integer | 선택 | 코팅면수·묶음수·수량구간하한 |
| unit_price | numeric | 선택 | 단가 |
> UNIQUE(8키: comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty 조합) — 중복 차원조합 저장 불가.

### 3-11. 수량구간할인 마스터 `t_dsc_discount_tables` (7행, PK=dsc_tbl_cd, 수동)
`dsc_tbl_nm`(필수), `use_yn`(필수 CHECK). 상세는 인라인 아님(§4 미접근 모델).

### 3-12. 고객 `t_cus_customers` (0행 — 빈 테이블)
`cus_cd`(PK 수동), `cus_nm`(필수), `grade_cd`(선택 FK→CUS_GRADE), `reg_ymd`(varchar10), `use_yn`(필수 CHECK). **라이브 0행 → 운영자는 빈 목록을 봄.**

### 3-13. 구성템플릿 `t_prd_templates` (9행, PK=tmpl_cd, 자동채번 TMPL_)
| 컬럼 | 타입 | 필수 | 도메인 |
|---|---|---|---|
| tmpl_cd | varchar(50) | PK | 자동채번 TMPL_(첫행 TMPL_000001 폴백) |
| base_prd_cd | varchar(50) | **필수** | FK→products |
| tmpl_nm | varchar(200) | **필수** | |
| dflt_qty | integer | 선택 | |
| use_yn | char(1) | **필수** | default 'Y', CHECK |
| del_yn | char(1) | **필수** | default 'N'(논리삭제) |
| tags | jsonb | 선택 | (소스 table-spec 누락 가능 컬럼 — 라이브 존재) |
| usr_def_cd/usr_def_nm | varchar | 선택 | 사용자정의 |

---

## 4. CPQ 옵션 레이어 (커스텀 드릴다운 편집) — 폴리모픽 ref_dim_cd

### 4-1. 상품옵션그룹 `t_prd_product_option_groups` (5행, PK=prd_cd+opt_grp_cd)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| opt_grp_nm | varchar(100) | **필수** | | |
| sel_typ_cd | varchar(50) | 선택 | FK→SEL_TYPE | .01 단일×4 · .02 다중×1 |
| min_sel_cnt/max_sel_cnt | integer | 선택 | 다중일 때 N | |
| mand_yn | char(1) | 선택 | CHECK Y/N | N×3 · Y×2 |
| use_yn | char(1) | **필수** | default Y | |
| usr_def_nm | varchar(100) | 선택 | 사용자정의명 | |

### 4-2. 상품옵션 `t_prd_product_options` (16행, PK=prd_cd+opt_cd)
`opt_grp_cd`(필수 FK→option_groups), `opt_nm`(필수), `dflt_yn`(선택 CHECK), `use_yn`(default Y), `tags` jsonb(선택), `usr_def_cd/nm`(선택).

### 4-3. 상품옵션항목 `t_prd_product_option_items` (18행, PK=prd_cd+opt_cd+item_seq)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| item_seq | integer | PK | 자동채번(스코프 max+1) | |
| ref_dim_cd | varchar(50) | **필수** | FK→OPT_REF_DIM | .03 자재×8 · .04 공정×10 (※라이브엔 자재·공정만 사용) |
| ref_key1 | varchar(50) | **필수** | 폴리모픽 참조(차원행 코드) | 자재=mat_cd |
| ref_key2 | varchar(50) | 선택 | 자재일 때 usage_cd(`mat_cd__usage_cd` 분리) | |
| qty | integer | 선택 | 수량 | |
| use_yn | char(1) | **필수** | default Y | |
> 트리거 `fn_chk_opt_item_ref`: ref_dim_cd별로 ref_key1/2가 해당 차원행에 실재해야 INSERT 통과(무결성 강제). 운영자가 미등록 차원행을 참조하면 거부됨.

### 4-4. 상품제약규칙 `t_prd_product_constraints` (4행, PK=prd_cd+rule_cd)
| 컬럼 | 타입 | 필수 | 도메인 | 라이브 |
|---|---|---|---|---|
| rule_nm | varchar(200) | **필수** | | |
| rule_typ_cd | varchar(50) | 선택 | FK→RULE_TYPE | .02 금지×3 · .03 필수동반×1 (※.01 호환 미사용·use_yn=N) |
| logic | jsonb | **필수** | JSONLogic(폼빌더 생성) | |
| err_msg | varchar(500) | 선택 | 위반시 메시지 | |
| use_yn | char(1) | **필수** | default Y | |

### 4-5. 템플릿선택값 `t_prd_template_selections` (9행, PK=tmpl_cd+sel_seq)
`ref_dim_cd`(선택 FK→OPT_REF_DIM, 라이브 .01 사이즈×7·.05 묶음수×2), `ref_key1/2`(선택), `opt_cd`(선택), `sel_val`(varchar100), `qty`(선택), `use_yn`(default Y).

---

## 5. 상품 차원 인라인(section_edit) 모델 — 필수·코드값 요약

| 모델 (행수) | PK | 핵심 필수컬럼 | 주요 코드 도메인(라이브) |
|---|---|---|---|
| 상품별카테고리 `t_prd_product_categories` (275) | prd_cd+cat_cd | main_cat_yn(CHECK) | cat_cd FK→categories |
| 상품별사이즈 `t_prd_product_sizes` (448) | prd_cd+siz_cd | dflt_yn(CHECK) | siz_cd FK→sizes |
| 상품별인쇄옵션 `t_prd_product_print_options` (166) | prd_cd+opt_id | print_side, front/back_colrcnt_cd, dflt_yn | **print_side 자유텍스트**: 단면62·양면41·투명테두리21·배면양면21·풀빼다21 / colrcnt FK→color_counts(5종) |
| 상품별판형사이즈 `t_prd_product_plate_sizes` (424) | prd_cd+siz_cd | dflt_plt_yn | output_paper_typ_cd FK→OUTPUT_PAPER_TYPE(.01 국전×32·.03 기타×33·NULL×359) / **output_file_typ 자유텍스트 16종** |
| 상품별자재 `t_prd_product_materials` (722) | prd_cd+mat_cd+usage_cd | usage_cd, dflt_yn | usage_cd FK→USAGE(.07 공통×596·.02 표지×66·.01 내지×43·.03 면지×15·.05 투명커버×2) / dep_proc_cd FK→processes(SET NULL) |
| 상품별공정 `t_prd_product_processes` (261) | prd_cd+proc_cd | mand_proc_yn(CHECK) | proc_cd FK→processes |
| 상품별묶음수 `t_prd_product_bundle_qtys` (27) | prd_cd+bdl_qty | bdl_qty, dflt_yn | bdl_unit_typ_cd FK→QTY_UNIT(.01 EA×15·.02 매×8·.03 권×2·.04 세트×2) |
| 상품별추가상품 `t_prd_product_addons` (1) | prd_cd+tmpl_cd | tmpl_cd | tmpl_cd FK→templates |
| 상품별페이지룰 `t_prd_product_page_rules` (11) | prd_cd | page_min/max/incr 모두 **필수** | OneToOne PK |

---

## 6. 어느 화면에도 직접 안 나오는 모델(소스 §6 F-2)의 실데이터 상태

복합PK라 standalone skip + 인라인 미부착 + 메뉴 미등록(소스 화면 맵 F-2) → admin UI 미접근. 데이터는 DB에만 존재(직접 SQL/로더로만 적재). 라이브 행수:

| 모델 | 행수 | 상태 |
|---|---|---|
| `t_dsc_discount_details` (수량구간할인상세) | **35** | 적재됨, UI 미접근 |
| `t_dsc_grade_discount_rates` (등급별할인율) | 0 | 빈 |
| `t_prc_formula_components` (공식별구성요소) | **85** | 적재됨, UI 미접근 (addtn_yn 전부 Y) |
| `t_prd_product_discount_tables` (상품별할인테이블) | **98** | 적재됨, UI 미접근 |
| `t_prd_product_price_formulas` (상품별가격공식) | **64** | 적재됨, UI 미접근 |
| `t_prd_product_prices` (상품단가) | 0 | 빈 |
| `t_prd_product_sets` (상품셋트정보) | **28** | 적재됨, UI 미접근 |
| `t_prd_template_prices` (템플릿단가) | 0 | 빈 (소스 화면 맵에 미열거된 테이블 — 라이브 존재) |

> **작성 시사점:** 이 8종(특히 가격사슬: formula_components·product_price_formulas·discount_tables)은 운영자가 admin에서 편집할 수 없음. 매뉴얼은 "이 데이터는 admin 화면이 없으며 DB 직접 작업 영역"임을 명시해야 함.

---

## 7. 소스 ↔ 라이브 불일치 노트

| # | 소스 선언(화면 맵/admin.py) | 라이브 실측 | 판정 |
|---|---|---|---|
| M-1 | 화면 맵 부록 MAT_TYPE 최대 `.10 악세사리`까지 추정(.11 미기재) | `MAT_TYPE.11=스티커` 실재(11행 사용) | 라이브 권위 — 코드 11종 |
| M-2 | `t_prd_product_print_options` 소스상 차원(인라인) | pg_stat=0이나 **실제 166행** + print_side 자유텍스트 5종 | stat stale, count 권위 |
| M-3 | `print_side`를 코드값 FK로 오해 가능 | **VARCHAR(20) 자유 한글 라벨**(FK 없음) | 자유텍스트 — 표준화 필요 |
| M-4 | `output_file_typ` | **VARCHAR(30) 자유텍스트 16종 변형**(표기 불일치: `*AI(칼선)` vs `AI (칼선)` vs `AI_CS5 (칼선)`) | 자유텍스트 — 입력 표준 가이드 권장 |
| M-5 | RULE_TYPE 3종(호환/금지/필수동반) 모두 사용 가정 | `.01 호환 use_yn=N`(비활성) + 실데이터 미사용 | 호환 규칙 드롭다운 누락 가능 |
| M-6 | `t_prd_template_prices` 화면 맵 미열거 | 라이브 존재(0행, PK=tmpl_cd+apply_ymd, FK→templates) | 소스 누락 테이블 — 라이브 권위 |
| M-7 | PRD_TYPE 5종 전부 사용 가정 | `.01 완제품` 라이브 0행(반제품/기성/디자인/추가만) | 완제품 상품 미등록 |
| M-8 | t_cus_customers·grade_discount_rates·product_prices·template_prices | 라이브 0행 | 4종 빈 화면 |

---

## 부록 A. 운영 언어로 번역한 제약(운영자 저장 실패 원인)

- **NOT NULL = 필수입력** — prd_nm·prd_typ_cd·mat_typ_cd·cat_lvl·page_min/max/incr 등 비우면 저장 불가.
- **CHECK Y/N** — 모든 `*_yn`은 Y 또는 N만. 그 외 값 거부.
- **CHECK 배타(할인)** — 할인율·할인액 동시 입력 거부(둘 중 하나만).
- **FK = 마스터 선등록 필요** — `*_typ_cd`/mat_cd/siz_cd/cat_cd/proc_cd 등은 참조 마스터(t_cod_base_codes·각 마스터)에 먼저 존재해야 함. ON DELETE RESTRICT 다수 → 사용 중인 코드/마스터는 삭제 거부.
- **UNIQUE(복합PK·8키)** — 같은 차원조합 중복 저장 거부(component_prices·각 차원 테이블).
- **CPQ 트리거** — `fn_chk_opt_item_ref`로 옵션항목의 ref_key가 실제 차원행에 없으면 거부.
- **reg_dt 함정** — NOT NULL DEFAULT now(); 명시 NULL 전송 시 저장 실패(admin은 readonly로 회피).
