# CPQ 종단 실증 — 일반현수막(PRD_000138) 인스턴스화 + 자체 설계검증

> **상태/이력** 작성 2026-06-06 · WIP · `cpq-design.md` 설계를 실상품 1종에 종단 인스턴스화.
> **권위 입력(인라인 인용):** `silsa.md`(도메인 권위) · `silsa-l1.csv`(L1 무손실 추출) · `ref-*.csv`(라이브 추출 스냅샷, **stale 주의** — 등록/존재 판정은 라이브 권위) · `price-engine-ddl.md`(기존 DDL).
> 식별자/코드/SQL/JSON = English, 설명 = Korean. 불확실 코드는 `[CONFIRM]` 표기(발명 금지).

---

## 1. 대상 상품 실데이터 (ground truth)

### 1.1 상품 마스터 (라이브 = `ref-products.csv` PRD_000138)

| 컬럼 | 값 | 출처 |
|---|---|---|
| `prd_cd` | `PRD_000138` | silsa.md §① "일반현수막(138)" / ref-products.csv |
| `prd_nm` | 일반현수막 | L1 row_seq 108 |
| `prd_typ_cd` | `PRD_TYPE.04` (디자인상품) | ref-products.csv |
| `nonspec_yn` | `Y` | ref-products.csv. 단 width/height_min/max = **NULL** (silsa.md G-SL-6) |
| `min_qty / max_qty / qty_incr` | `1 / 10000 / 1` | L1 제작수량 / ref-products.csv |
| `qty_unit_typ_cd` | **NULL** | silsa.md G-SL-9 (272 전상품 NULL) |
| `constraint_json` | NULL (현재) | ref-products.csv. → §3.6에서 compile 캐시로 채움 |

### 1.2 실제 옵션 캐스케이드 (L1 무손실, 일반현수막 5행)

`silsa-l1.csv` row_seq 108~114 (prd_nm=일반현수막):

| L1 컬럼 | 추출 값(전 행 합집합) | 정규화 대상 |
|---|---|---|
| `사이즈(필수)` | `5000x900mm`(규격) · `사용자입력`(비규격) | size + nonspec |
| `비규격(최소/최대)_가로` | `500~1750` (row 109) | nonspec width range |
| `비규격(최소/최대)_세로` | `500~5000` (row 109) | nonspec height range |
| `소재(필수)` | `현수막천` (row 108) | material |
| `화이트별색(옵션)` | (공백 — 일반현수막은 없음) | — |
| `코팅(옵션)` | (공백 — 일반현수막은 없음) | — |
| `가공(옵션)_가공` | `열재단`·`타공(4개)`·`타공(6개)`·`타공(8개)`·`양면테입`·`봉미싱` | process (079/080/081/053) |
| `추가(옵션)_추가` | `추가없음`·`큐방(4개)추가`·`끈(4개)추가`·`각목(900이하)+끈(4개) 추가`·`각목(900초과)+끈(4개) 추가` | process(부착 081) / addon |
| `제작수량` | 최소 1 / 최대 10000 / 증가 1 | products.qty 필드 |

> **검증 주의(L1 직접 인용):** 일반현수막에는 **화이트별색·코팅 옵션이 없다**(공백). 코팅은 PET배너(row 100~102)·미니배너(142~143)에만 존재. 프롬프트가 "코팅 무광/유광 confirm 일반현수막" 요청 → **일반현수막은 코팅 미보유로 확정**(false 옵션 인스턴스화 금지).

### 1.3 기존 DB 적재 실태 (라이브 = ref-*.csv 스냅샷)

| 차원 | 적재 행 | 코드 / 출처 |
|---|---|---|
| size | `SIZ_000322` (5000x900, work=cut=5000×900, dflt=Y) | ref-product-sizes.csv / ref-sizes.csv |
| material | `MAT_000182` (현수막천, MAT_TYPE.08, usage=USAGE.07 공통, dflt=Y) | ref-product-materials.csv / ref-materials.csv |
| plate_size | `SIZ_000322` (output JPG) | ref-product-plate-sizes.csv |
| process | `PROC_000079`(타공) · `PROC_000080`(봉제) · `PROC_000081`(부착) — 전부 mand_proc_yn=N, excl_grp_cd 공백 | ref-product-processes.csv (silsa.md G-SL-5 "MATCH·권위반전") |
| process_excl_group | 0행 | ref 없음 (silsa.md §③: 전 28상품 택일그룹 부재) |
| bundle_qty / page_rule / print_option | 0행 | silsa.md §③ |
| addon | **0행** (일반현수막) | ref-product-addons.csv에 PRD_000138 부재 (silsa.md G-SL-4: 거치대/끈 미적재) |

**공정 detail opt 스키마 (ref-processes.csv `prcs_dtl_opt` — option_items 파라미터의 권위):**
- `PROC_000079 타공`: `{"구수": int, min:1, max:8, unit:"개"}`
- `PROC_000080 봉제`: `{"유형": enum[오버로크,말아박기,봉미싱], "폭": number mm}`
- `PROC_000081 부착`: `{"대상": enum[라벨,맥세이프,**끈**,테입]}` ← **끈이 부착 공정 enum 값으로 이미 존재**
- `PROC_000053 완칼`: `{"모양": string}` — 열재단을 완칼/부착으로 환원 시 후보
- (참고 거치대 addon: 우드거치대 `PRD_000012` / 우드봉 `PRD_000013` / 우드행거 `PRD_000014` — ref-product-addons.csv)

> **핵심 도메인 긴장(silsa.md G-SL-4):** 같은 "부가물"이 축이 갈린다 — 거치대=완제 addon, 타공/봉제=process, 끈/큐방/각목=모호(부착 081 OR addon). §5(a)에서 polymorphic으로 통일 표현 + 자의적 축 선택 지점 플래그.

---

## 2. 관리자 셋업 시나리오 (단계별 — 테이블+실행 행 명시)

관리자가 일반현수막(PRD_000138)을 CPQ에 등록하는 흐름. 각 단계가 어느 테이블에 어떤 행을 쓰는지 명시.

**Step 0 — 차원 행은 이미 적재됨(전제).** size(SIZ_000322)·material(MAT_000182)·process(079/080/081)는 라이브에 존재(silsa.md). 옵션 레이어는 *이미 등록된 차원 행만* 참조하므로 추가 차원 적재 불요. (예외: 거치대 addon은 미적재 → §2 Step 5에서 template로 신설.)

**Step 1 — 옵션 그룹 생성** → `t_prd_product_option_groups`
- 가공(택일, 필수) 그룹 / 추가(택일, 선택) 그룹. (일반현수막은 화이트별색·코팅 그룹 없음.)

**Step 2 — 옵션 생성** → `t_prd_product_options`
- 가공 그룹: 열재단 / 타공(4개) / 타공(6개) / 타공(8개) / 양면테입 / 봉제(봉미싱).
- 추가 그룹: 추가없음 / 큐방(4개) / 끈(4개) / 각목(900이하)+끈(4개) / 각목(900초과)+끈(4개).

**Step 3 — 옵션 재료(polymorphic) 등록** → `t_prd_product_option_items`
- 단일 옵션은 1행, **복합 옵션(각목+끈)은 2행**. ref_dim_cd로 process/addon/material 통일 표현.

**Step 4 — 제약 등록** → `t_prd_product_constraints` (JSONLogic rule 행)
- 사용자입력 사이즈 범위 검증, 각목(900이하/초과)×사이즈 정합 등.

**Step 5 — 거치대 템플릿 등록** → `t_prd_templates` + `t_prd_template_selections` → `t_prd_product_addons`
- 일반현수막엔 L1상 거치대가 없으나(추가없음/끈/큐방/각목만), **add-on 템플릿 메커니즘 실증**을 위해 배너군 공통 거치대(L1 메쉬배너 row 104~106: 실내 +10000 / 실외 +23000)를 일반현수막에 연결하는 시나리오로 인스턴스화. (실데이터상 거치대는 PET/메쉬배너 소속 — `[CONFIRM]` 일반현수막 거치대 적용 여부.)

**Step 6 — 제약 compile** → `t_prd_products.constraint_json` 갱신 (활성 rule들을 단일 JSON으로).

---

## 3. 테이블별 실제 행 인스턴스화

> 아래 `opt_grp_cd`/`opt_cd`/`tmpl_cd`/`rule_cd`는 본 설계가 부여한 신규 값(라이브 미존재 — 신규 적재 대상). `prd_cd`/`siz_cd`/`mat_cd`/`proc_cd`/`addon_prd_cd`는 **라이브 실코드**.

### 3.1 `t_prd_product_option_groups` (옵션 그룹)

| prd_cd | opt_grp_cd | opt_grp_nm | sel_typ_cd | min_sel_cnt | max_sel_cnt | mand_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_000138 | `OG-GAGONG` | 가공 | SEL_TYPE.01 (단일/택일) | 1 | 1 | Y | 1 | Y |
| PRD_000138 | `OG-CHUGA` | 추가 | SEL_TYPE.01 (단일/택일) | 0 | 1 | N | 2 | Y |

> 출처: L1 가공/추가 컬럼은 각각 단일 선택(엑셀 1셀=1값) → SEL_TYPE.01. 가공=필수(mand_yn=Y, 열재단이 기본), 추가=선택(추가없음 기본). **이 두 그룹이 기존 `t_prd_product_process_excl_groups`의 일반화 형태** — 일반현수막엔 excl_group 0행이었으나(silsa.md §③), 가공 택일이 곧 process excl-group의 일반 옵션그룹 표현.

### 3.2 `t_prd_product_options` (옵션)

| prd_cd | opt_cd | opt_grp_cd | opt_nm | dflt_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|
| PRD_000138 | `OP-GAGONG-YEOLJAEDAN` | OG-GAGONG | 열재단 | Y | 1 | Y |
| PRD_000138 | `OP-GAGONG-TAGONG4` | OG-GAGONG | 타공(4개) | N | 2 | Y |
| PRD_000138 | `OP-GAGONG-TAGONG6` | OG-GAGONG | 타공(6개) | N | 3 | Y |
| PRD_000138 | `OP-GAGONG-TAGONG8` | OG-GAGONG | 타공(8개) | N | 4 | Y |
| PRD_000138 | `OP-GAGONG-YANGMYEONTAPE` | OG-GAGONG | 양면테입 | N | 5 | Y |
| PRD_000138 | `OP-GAGONG-BONGMISING` | OG-GAGONG | 봉제(봉미싱) | N | 6 | Y |
| PRD_000138 | `OP-CHUGA-NONE` | OG-CHUGA | 추가없음 | Y | 1 | Y |
| PRD_000138 | `OP-CHUGA-QBANG4` | OG-CHUGA | 큐방(4개)추가 | N | 2 | Y |
| PRD_000138 | `OP-CHUGA-STRING4` | OG-CHUGA | 끈(4개)추가 | N | 3 | Y |
| PRD_000138 | `OP-CHUGA-GAKMOK-LE900` | OG-CHUGA | 각목(900이하)+끈(4개) 추가 | N | 4 | Y |
| PRD_000138 | `OP-CHUGA-GAKMOK-GT900` | OG-CHUGA | 각목(900초과)+끈(4개) 추가 | N | 5 | Y |

> 출처: silsa-l1.csv row 108~112 가공/추가 값 1:1. 열재단=가공 기본(row 108), 추가없음=추가 기본(row 108).

### 3.3 `t_prd_product_option_items` (옵션 재료 — polymorphic 핵심)

> **`ref_dim_cd`가 process vs addon(set) vs material을 한 레이어에서 통일 표현.** 복합 옵션(각목+끈)은 **item_seq 2행**.

| prd_cd | opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | ref_param_json | qty |
|---|---|---|---|---|---|---|---|
| PRD_000138 | OP-GAGONG-YEOLJAEDAN | 1 | `process` | `PROC_000053` `[CONFIRM]` | — | `{"모양":"열재단"}` | 1 |
| PRD_000138 | OP-GAGONG-TAGONG4 | 1 | `process` | `PROC_000079` | — | `{"구수":4}` | 1 |
| PRD_000138 | OP-GAGONG-TAGONG6 | 1 | `process` | `PROC_000079` | — | `{"구수":6}` | 1 |
| PRD_000138 | OP-GAGONG-TAGONG8 | 1 | `process` | `PROC_000079` | — | `{"구수":8}` | 1 |
| PRD_000138 | OP-GAGONG-YANGMYEONTAPE | 1 | `process` | `PROC_000081` | — | `{"대상":"테입"}` | 1 |
| PRD_000138 | OP-GAGONG-BONGMISING | 1 | `process` | `PROC_000080` | — | `{"유형":"봉미싱"}` | 1 |
| PRD_000138 | OP-CHUGA-NONE | 1 | (없음 — 재료 0행. 옵션 자체가 "선택안함" 센티넬) | — | — | — | — |
| PRD_000138 | OP-CHUGA-QBANG4 | 1 | `process` | `PROC_000081` | — | `{"대상":"큐방"}` `[CONFIRM]` | 4 |
| PRD_000138 | OP-CHUGA-STRING4 | 1 | `process` | `PROC_000081` | — | `{"대상":"끈"}` | 4 |
| PRD_000138 | **OP-CHUGA-GAKMOK-LE900** | **1** | `process` | `PROC_000081` | — | `{"대상":"끈"}` | 4 |
| PRD_000138 | **OP-CHUGA-GAKMOK-LE900** | **2** | `set` (or addon) `[CONFIRM]` | `각목(900이하)` `[CONFIRM 코드]` | — | `{"규격":"900이하"}` | 1 |
| PRD_000138 | **OP-CHUGA-GAKMOK-GT900** | **1** | `process` | `PROC_000081` | — | `{"대상":"끈"}` | 4 |
| PRD_000138 | **OP-CHUGA-GAKMOK-GT900** | **2** | `set` (or addon) `[CONFIRM]` | `각목(900초과)` `[CONFIRM 코드]` | — | `{"규격":"900초과"}` | 1 |

**해설 (polymorphic이 3축을 한 레이어로):**
- **process 축:** 타공/봉제/부착이 `ref_dim_cd='process'` + `ref_key1=proc_cd` + `ref_param_json`(공정 detail opt). 타공의 4/6/8개는 *별도 공정행이 아니라* 동일 PROC_000079에 `{"구수":N}` 파라미터 차이 → 공정 마스터 1행을 옵션 3개가 재사용. **이것이 polymorphic+ref_param_json의 핵심 이득.**
- **끈/큐방 = 부착 공정(081)으로 환원** — `대상` enum에 `끈`이 이미 있음(ref-processes.csv). 즉 G-SL-4 모호성의 한쪽(공정)은 **이미 마스터가 지원**. `큐방`은 enum에 없음 → `[CONFIRM]`(enum 확장 or addon).
- **복합 각목+끈 = 2행:** seq1=끈(부착 공정 081), seq2=각목(부품 set/addon). **같은 옵션 안에 process+set 두 차원이 공존** → polymorphic이 typed FK로는 불가능한 이종 결합을 자연 표현.
- **각목 = `set` or `addon` `[CONFIRM]`:** 각목은 완제 부속(나무 막대)이라 set/addon 성격. ref에 각목 상품코드 미존재 → 코드 발명 금지(`[CONFIRM 코드]`). §5(a)에서 권고 규약 제시.

### 3.4 `t_prd_templates` + `t_prd_template_selections` (거치대 add-on 템플릿)

거치대 3종(L1 메쉬배너 row 104~106 가격: 실내 +10000 / 실외 +23000 / 없음 0). 거치대=완제 addon → 각각을 SKU(=template)로 등록. base_prd_cd는 거치대 완제상품 코드(우드거치대 PRD_000012 외 실내/실외 배너거치대는 ref 미존재 → `[CONFIRM]`).

**`t_prd_templates`:**

| tmpl_cd | base_prd_cd | tmpl_nm | dflt_qty | price | use_yn | note |
|---|---|---|---|---|---|---|
| `TMPL-STAND-NONE` | (없음) | 거치대없음 | 0 | 0 | Y | 센티넬(선택안함) |
| `TMPL-STAND-INDOOR` | `[CONFIRM]` 실내배너거치대 prd_cd | 실내용배너거치대 | 1 | 10000 | Y | L1 메쉬배너 row 105 +10000 |
| `TMPL-STAND-OUTDOOR` | `[CONFIRM]` 실외배너거치대 prd_cd | 실외용배너거치대 | 1 | 23000 | Y | L1 메쉬배너 row 106 +23000 |

**`t_prd_template_selections`** (거치대는 base 상품의 옵션/차원 freeze가 단순 — 수량만):

| tmpl_cd | seq | ref_dim_cd | ref_key1 | value | qty |
|---|---|---|---|---|---|
| TMPL-STAND-INDOOR | 1 | (base 상품 자체, 옵션 없음) | — | — | 1 |
| TMPL-STAND-OUTDOOR | 1 | (base 상품 자체, 옵션 없음) | — | — | 1 |

> 참고: 거치대는 옵션 freeze가 단순(수량 1) → selections가 빈약. 봉투류(OPP봉투+사이즈+50장) 같은 복합 add-on에서 selections가 진가 발휘(예: PRD_000016→PRD_000001 "OPP접착봉투 110x160 50장", ref-product-addons.csv). 일반현수막 거치대는 template 메커니즘의 *최소 사례*.

### 3.5 `t_prd_product_addons` (변경: addon_prd_cd → tmpl_cd)

| prd_cd | tmpl_cd | disp_seq | note |
|---|---|---|---|
| PRD_000138 | TMPL-STAND-NONE | 1 | 거치대없음 (기본) |
| PRD_000138 | TMPL-STAND-INDOOR | 2 | 실내거치대 |
| PRD_000138 | TMPL-STAND-OUTDOOR | 3 | 실외거치대 |

> **AS-IS 대비:** 기존 ref-product-addons.csv는 `(prd_cd, addon_prd_cd)` 직접 상품링크 (예: `PRD_000133, PRD_000014` 우드행거). 변경 후 `addon_prd_cd`→`tmpl_cd`. 마이그레이션 시 기존 직접링크는 "옵션 freeze 없는 1행 template"으로 자동 변환(우드행거 PRD_000014 → `TMPL-WOODHANGER`(base=PRD_000014, selections 0행)).

### 3.6 `t_prd_product_constraints` (JSONLogic rule 행, 2+)

> data 키 규약: 고객 선택을 `{ "size_mode": "...", "width": int, "height": int, "gagong": opt_cd, "chuga": opt_cd, "stand": tmpl_cd }` 형태로 평가에 전달. rule이 true면 "유효", false면 err_msg 노출.

**Rule 1 — 사용자입력 사이즈 범위 검증** (L1 row 109: 가로 500~1750, 세로 500~5000)

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn | disp_seq |
|---|---|---|---|---|---|---|
| PRD_000138 | `R-SIZE-NONSPEC` | 사용자입력 치수 범위 | compatible | 가로 500~1750mm, 세로 500~5000mm 범위로 입력하세요 | Y | 1 |

```json
{ "or": [
    { "!=": [ { "var": "size_mode" }, "nonspec" ] },
    { "and": [
        { ">=": [ { "var": "width" },  500  ] },
        { "<=": [ { "var": "width" },  1750 ] },
        { ">=": [ { "var": "height" }, 500  ] },
        { "<=": [ { "var": "height" }, 5000 ] }
    ] }
] }
```
> 규격 선택(size_mode≠nonspec)이면 무조건 통과, 사용자입력이면 4변 범위 검사. 출처: silsa-l1.csv row 109 `비규격_가로=500~1750`, `_세로=500~5000`.

**Rule 2 — 각목(900이하) ↔ 세로 정합 (필수동반/금지 조합)** — 각목 규격이 현수막 세로(짧은 변)와 정합해야 함

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn | disp_seq |
|---|---|---|---|---|---|---|
| PRD_000138 | `R-GAKMOK-HEIGHT` | 각목 규격×세로 정합 | forbidden | 세로 900mm 이하는 각목(900이하), 초과는 각목(900초과)를 선택하세요 | Y | 2 |

```json
{ "and": [
    { "if": [
        { "==": [ { "var": "chuga" }, "OP-CHUGA-GAKMOK-LE900" ] },
        { "<=": [ { "var": "height" }, 900 ] },
        true
    ] },
    { "if": [
        { "==": [ { "var": "chuga" }, "OP-CHUGA-GAKMOK-GT900" ] },
        { ">":  [ { "var": "height" }, 900 ] },
        true
    ] }
] }
```
> 출처: silsa-l1.csv row 111/112 각목 `900이하`/`900초과` 분기 = 세로 치수 의존. 도메인: 각목은 현수막 폭(세로변)에 맞춰 절단되므로 치수 정합 필수.

**Rule 3 (보조) — 봉제×사용자입력 시 폭 필요** (봉제 공정의 `폭` 파라미터, ref-processes PROC_000080)

| prd_cd | rule_cd | rule_nm | rule_typ | err_msg | use_yn |
|---|---|---|---|---|---|
| PRD_000138 | `R-BONGJE-PARAM` | 봉제 선택 시 사이즈 필수 | required | 봉제 가공은 사이즈 확정이 필요합니다 | Y |

```json
{ "if": [
    { "==": [ { "var": "gagong" }, "OP-GAGONG-BONGMISING" ] },
    { "and": [ { ">": [ { "var": "width" }, 0 ] }, { ">": [ { "var": "height" }, 0 ] } ] },
    true
] }
```

**`t_prd_products.constraint_json` (compile 캐시 — 활성 rule AND 결합):**

```json
{ "and": [
    { "or": [ {"!=":[{"var":"size_mode"},"nonspec"]},
              {"and":[{">=":[{"var":"width"},500]},{"<=":[{"var":"width"},1750]},
                      {">=":[{"var":"height"},500]},{"<=":[{"var":"height"},5000]}]} ] },
    { "and": [ {"if":[{"==":[{"var":"chuga"},"OP-CHUGA-GAKMOK-LE900"]},{"<=":[{"var":"height"},900]},true]},
               {"if":[{"==":[{"var":"chuga"},"OP-CHUGA-GAKMOK-GT900"]},{">":[{"var":"height"},900]},true]} ] },
    { "if": [ {"==":[{"var":"gagong"},"OP-GAGONG-BONGMISING"]},
              {"and":[{">":[{"var":"width"},0]},{">":[{"var":"height"},0]}]}, true ] }
] }
```
> POD는 이 단일 JSON 1건만 로드해 `json-logic-js`로 매 선택마다 평가. 관리자 rule on/off 시 재compile.

---

## 4. 고객 선택 → MES 환원 트레이스

**고객 선택 (구체):** 일반현수막 / 사용자입력 `4000×900` / 타공(6개) / 각목(900이하)+끈(4개) / 실내거치대 ×1, 제작수량 5장.

**선택 → 옵션 행:**
```
size_mode = nonspec, width=4000, height=900
gagong    = OP-GAGONG-TAGONG6     (OG-GAGONG 그룹 택1)
chuga     = OP-CHUGA-GAKMOK-LE900 (OG-CHUGA 그룹 택1)
stand     = TMPL-STAND-INDOOR     (addon)
qty       = 5
```

**제약 평가 (constraint_json, json-logic-js):**
- R-SIZE-NONSPEC: width 4000 ∈ [500,1750]? → **4000 > 1750 → FALSE** ⚠️
  → **검증 실패!** err_msg "가로 500~1750mm" 노출. (의도된 결함 노출 — §5(e) 참조: L1 비규격 가로 500~1750과 규격 5000×900이 **모순**. 사용자입력 가로가 규격 5000보다 좁음 → L1 데이터 자체 갭.)
- 트레이스 계속을 위해 **유효 선택으로 정정**: 사용자입력 `1500×900` 가정 → R-SIZE-NONSPEC PASS, R-GAKMOK-HEIGHT(height 900 ≤ 900) PASS.

**환원 (resolve) — option_items → material+process:**

| 선택 | option_items 행 | ref_dim_cd | 환원 결과 |
|---|---|---|---|
| 소재(고정) | (material 차원) | material | MAT_000182 현수막천 |
| 사이즈 | nonspec | size | 1500×900 (work=cut) |
| 타공(6개) | OP-GAGONG-TAGONG6/seq1 | process | PROC_000079 타공, `{"구수":6}` |
| 끈(4개) | OP-CHUGA-GAKMOK-LE900/seq1 | process | PROC_000081 부착, `{"대상":"끈"}`, qty=4 |
| 각목 | OP-CHUGA-GAKMOK-LE900/seq2 | set/addon | 각목(900이하) `[CONFIRM 코드]`, qty=1 |
| 실내거치대 | TMPL-STAND-INDOOR | addon(template) | 별도 주문라인, base=실내배너거치대 `[CONFIRM]`, +10000 |

**MES 주문 페이로드 (resolved JSON):**
```json
{
  "order_lines": [
    {
      "line_type": "MAIN",
      "prd_cd": "PRD_000138",
      "prd_nm": "일반현수막",
      "qty": 5,
      "size": { "mode": "nonspec", "width": 1500, "height": 900, "unit": "mm" },
      "materials": [ { "mat_cd": "MAT_000182", "mat_nm": "현수막천", "usage_cd": "USAGE.07" } ],
      "processes": [
        { "proc_cd": "PROC_000079", "proc_nm": "타공", "params": { "구수": 6 }, "consume_qty": 1 },
        { "proc_cd": "PROC_000081", "proc_nm": "부착", "params": { "대상": "끈" }, "consume_qty": 4 }
      ],
      "parts": [
        { "ref_dim_cd": "set", "ref_key1": "각목(900이하)", "params": { "규격": "900이하" }, "consume_qty": 1, "note": "[CONFIRM 코드]" }
      ]
    },
    {
      "line_type": "ADDON",
      "tmpl_cd": "TMPL-STAND-INDOOR",
      "tmpl_nm": "실내용배너거치대",
      "base_prd_cd": "[CONFIRM]",
      "qty": 1,
      "addon_price": 10000
    }
  ]
}
```

**설계 원칙 #1 증명:** 고객이 화면에서 고른 모든 선택(소재·타공·끈·각목·거치대)이 **material(MAT_000182) + process(079/081) + part(각목) + addon라인(거치대)** 으로 100% 환원되어 MES 페이로드에 실렸다. 옵션 레이어의 `ref_dim_cd`가 환원 라우터 역할 — process는 본 라인의 processes[]로, set/addon은 parts[]/별도 ADDON 라인으로 분기. **단 각목 코드·거치대 base_prd_cd가 `[CONFIRM]`으로 미완** = 환원 완전성이 마스터 적재(G-SL-4)에 의존함을 노출.

---

## 5. 설계 검증 — 적정성·허점·개선점 (자체 평가, 정직)

### 5.1 잘 동작하는 부분 ✅
- **polymorphic ref_dim_cd가 3축(process/set/addon)을 한 레이어로 통일** — 타공·봉제·부착(process), 각목(set), 거치대(addon)가 동일 option_items/template 메커니즘으로 표현됨(§3.3). typed FK였다면 3종 자식 테이블 필요.
- **타공 4/6/8개를 공정 1행 + ref_param_json으로 재사용** — 공정 마스터(PROC_000079) 1행을 옵션 3개가 `{"구수":N}` 파라미터로 공유. 마스터 비대화 방지.
- **택일그룹 일반화** — 일반현수막은 process_excl_group 0행이었지만(silsa.md §③), 가공 택일이 OG-GAGONG(SEL_TYPE.01)로 자연 표현. **단 이는 "공백에서 신규 표현"이지 기존 excl-group의 변환 실증이 아님**(독립 검증 GAP-2 — §5.4). 기존 GRP-BOOK-제본 패턴과 동형으로 보이나, excl_grp_cd 실재 상품으로의 마이그레이션은 별도 실증 필요.
- **공정 detail opt(`prcs_dtl_opt`) 스키마와 ref_param_json이 정확히 짝** — 끈이 부착 enum에 이미 존재(ref-processes.csv) → G-SL-4의 process 쪽은 마스터가 이미 지원.

### 5.2 긴장·결함 지점 ⚠️

**(a) 끈/큐방/각목 addon-vs-process 축 모호 (G-SL-4) — 모델이 자의적 선택을 강요하는가?**
- **부분적으로 강요한다.** 모델은 `ref_dim_cd`로 process/set/addon 어느 쪽이든 표현 가능하나, **"끈은 process, 각목은 set" 같은 귀속 결정 자체는 모델이 정해주지 않는다** — 관리자가 등록 시 선택해야 함.
- **객관적 신호:** 끈은 부착 공정(081) `대상` enum에 **이미 존재** → process 귀속이 마스터 권위와 정합. 각목은 enum에 없고 물리 부품(나무) → set/addon 귀속이 자연.
- **권고 규약(convention):** **"가공(변형) = process / 부속물(물리 자재 부착) = set·addon"** 으로 1차 분기하되, **부착 공정(081)의 `대상` enum에 있으면 무조건 process 우선**. 즉 끈/테입=process(081), 각목/거치대=set/addon, 큐방=enum 확장 후 process(`[CONFIRM]`). 이 규약을 base-code note 또는 등록 UI 가이드로 명문화.
- **잔존 자의성:** 복합 "각목+끈"에서 끈(process)+각목(set)이 한 옵션에 공존 — 정당하나, 가격/BOM 소비 계산 시 두 축을 별도 처리해야 함(혼합 옵션의 비용 합산 책임이 가격엔진으로 이연).

**(b) 복합 option_items 순서/그룹 의미**
- `item_seq`는 **표시·처리 순서**이지 우선순위가 아님 — 명문화 필요. 각목+끈에서 seq1=끈/seq2=각목은 임의(둘 다 동반 생산).
- **개선:** 복합 내 항목 간 관계(동반필수 vs 택일)가 현재 표현 안 됨. 각목+끈은 "둘 다 필수 동반"인데 모델상 단순 2행 나열 → "이 둘은 AND 결합"임을 별도 플래그(`item_combine_typ`) 또는 constraint로 보강 권고. 현 모델은 "한 옵션의 모든 item은 동반"으로 암묵 가정.

**(c) nonspec(사용자입력) 사이즈 — option_items인가 products nonspec 범위인가?**
- **권고: products nonspec 범위 유지(option_items에 넣지 말 것).** 사용자입력은 *연속 수치 범위*(가로 500~1750)이지 *이산 선택지*가 아님 → 차원 행(option_items)으로 열거 불가. `t_prd_products.nonspec_width/height_min/max`(현재 NULL, G-SL-6)에 적재하고, **사이즈 옵션그룹은 [규격행 / 사용자입력 토글]만 표현**, 실제 범위 검증은 constraint(R-SIZE-NONSPEC)가 담당.
- 즉 사이즈는 **하이브리드**: 규격(SIZ_000322)=option_item(ref_dim_cd=size), 사용자입력=products 범위+constraint. 이 이원성을 설계 문서에 명시 필요.

**(d) polymorphic 참조의 검증 트리거 부담**
- ref_dim_cd 7종마다 다른 차원 테이블 EXISTS 검사 → 트리거 분기 7개(§cpq-design §4). 차원 추가 시 트리거 수정 필요(확장성 비용).
- `ref_param_json`이 공정 `prcs_dtl_opt` 스키마와 맞는지는 트리거로 검증 과함 → 앱 검증으로 분담 → **DB 단독 무결성 미보장**(잘못된 param JSON이 DB에 들어갈 수 있음). 위험 완화: 관리자 UI에서 공정 detail opt 스키마 기반 폼 생성(잘못된 param 입력 원천 차단).
- 비용 vs 이득: typed FK 7종 자식테이블 대신 트리거 1개로 통합 — **순효익은 polymorphic 쪽**이나, 무결성이 "FK 강제"에서 "트리거+앱 검증"으로 약화됨을 인정.

**(e) 일반현수막이 드러낸, size×set-count 시대 설계가 예상 못한 것들**
1. **공정 파라미터(`구수`/`유형`/`대상`)가 옵션의 1급 시민** — size×set-count 모델엔 "공정 detail opt" 개념이 없었음. ref_param_json 신규 컬럼이 필수가 됨(없으면 타공 4/6/8을 공정 3행으로 복제해야 함 = 마스터 오염).
2. **한 옵션 안에 이종 차원 결합(끈+각목 = process+set)** — set는 보통 "상품 묶음"인데 여기선 "옵션 재료"로 차용. set 차원의 의미가 확장됨.
3. **nonspec 연속범위 vs 이산옵션의 이원성** — size×set-count는 둘 다 이산 열거였으나, 현수막 사용자입력은 연속. 옵션 레이어가 연속값을 표현 못 함 → constraint+products로 우회.
4. **L1 데이터 자체 모순 노출:** 규격 5000×900 vs 사용자입력 가로 500~1750(§4) — 규격이 사용자입력 상한보다 큼. CPQ가 이 모순을 검증 시점에 드러냄(설계 강점이자, 마스터 데이터 정합 필요 신호 — G-SL-6 적재 시 해소 필요).
5. **거치대=addon이 일반현수막엔 실데이터상 없음** — 배너군 공통이나 L1상 일반현수막은 끈/큐방/각목만. template 메커니즘은 검증됐으나 일반현수막 거치대 적용은 `[CONFIRM]`.

### 5.3 개선 권고 (concrete)
1. **`OPT_REF_DIM` base-code 그룹 신설** — ref_dim_cd 7종을 코드 사전화(현재 잠정). polymorphic 무결성 트리거의 dispatch 키.
2. **`ref_param_json` 컬럼을 option_items에 정식 추가** — 공정 파라미터(구수/유형/대상) 보존 필수. 없으면 공정 마스터 복제 불가피.
3. **복합 옵션 항목 결합 의미 명문화** — `item_combine_typ`(AND동반 / OR택일) 또는 "한 옵션 내 전 item은 동반필수" 규약 확정.
4. **G-SL-4 귀속 규약 명문화** — "부착 enum(081)에 있으면 process, 물리 부품이면 set/addon" → base-code note 또는 등록 가이드.
5. **사이즈 이원성(규격=option_item / 사용자입력=products범위+constraint) 설계 명시** + G-SL-6 nonspec 범위 적재(가로/세로 min/max).
6. **각목·실내/실외 거치대 상품코드 마스터 적재** — `[CONFIRM]` 다수 = 환원 완전성이 마스터에 의존. 옵션 등록 전 부품/완제 상품 선등록 필요.
7. **큐방 처리 결정** — 부착 enum(`라벨/맥세이프/끈/테입`)에 `큐방` 없음 → enum 확장 vs addon `[CONFIRM]`.

### 5.4 독립 적대검증 반영 (`banner-walkthrough-validation.md` · 판정 CONDITIONAL-GO)

dbm-validator 독립 적대검증 결과: 인용 실코드·값·도메인 주장 **MISMATCH 0 / INVENTED 0**, JSONLogic 손계산 전건 일치, `[CONFIRM]` 정직성 확인(라이브 실부재 기반). 단 **배너 1종이 행사하지 못한 실증 공백**을 발견 — 본 워크스루의 "종단 실증"은 배너 1종 한정임을 명시한다.

| GAP | 등급 | 내용 | 보정 방향 |
|---|---|---|---|
| GAP-1 | MAJOR | pick-N/max-N(SEL_TYPE.02) 미행사 — 일반화 절반 미실증 | SEL_TYPE.02 케이스 보조 인스턴스 |
| GAP-2 | MAJOR | excl_groups 마이그레이션 미실증(배너 0행 = 신규생성 ≠ 변환) | excl_grp 실재 상품(제본류)으로 변환 실증 |
| GAP-5 | MINOR | 열재단→PROC_000053 미적재 차원 → §cpq-design §4 EXISTS 트리거 충돌 | 053 선적재 or "가공없음" 센티넬 규약 |
| GAP-3 | MINOR | template_selections 빈약(거치대 수량만) — 복합 add-on freeze 미실증 | OPP봉투 등 복합 selections 1건 곁들임 |
| GAP-4 | MINOR | 양면테입→`테입` 동일시는 도메인 해석(엑셀 명시 아님)인데 `[CONFIRM]` 누락(큐방과 비대칭) | 해석값 표기 |
| GAP-6 | 참고 | gp/calendar류 비치수·공정택일 round-3 BLOCKER를 배너가 미자극 | 별도 인스턴스 필요(범위 밖) |

**종합:** 배너 1종으로 **polymorphic 3축 통일 · 복합옵션(각목+끈) · 공정 param 재사용(타공 4/6/8) · JSONLogic 제약 · MES 환원**은 종단 입증됐다. 그러나 **다중선택(pick-N) · excl-group 변환 · 복합 add-on freeze · 비치수 난제**는 미실증으로, 설계 일반화의 완전한 검증은 SEL_TYPE.02 / excl_grp 실재 / 복합 add-on 상품의 보조 인스턴스를 요한다.

---

## 부록 — 인용 출처 색인 (검증용)

| 코드/값 | 출처 |
|---|---|
| PRD_000138 일반현수막 | silsa.md §① / ref-products.csv |
| SIZ_000322 5000x900 | ref-product-sizes.csv / ref-sizes.csv |
| MAT_000182 현수막천 MAT_TYPE.08 | ref-product-materials.csv / ref-materials.csv |
| PROC_000079 타공 {구수 1~8} | ref-processes.csv (prcs_dtl_opt) |
| PROC_000080 봉제 {유형,폭} | ref-processes.csv |
| PROC_000081 부착 {대상:라벨/맥세이프/끈/테입} | ref-processes.csv |
| PROC_000053 완칼 {모양} (열재단 환원 후보) | ref-processes.csv `[CONFIRM]` |
| 일반현수막 적재 공정 079/080/081 | ref-product-processes.csv PRD_000138 |
| 우드거치대 PRD_000012 / 우드봉 013 / 우드행거 014 | ref-product-addons.csv |
| 거치대 가격 실내+10000/실외+23000 | silsa-l1.csv 메쉬배너 row 105/106 |
| nonspec 가로 500~1750 세로 500~5000 | silsa-l1.csv 일반현수막 row 109 |
| 가공/추가 옵션 값 | silsa-l1.csv row 108~112 |
| addon 직접링크 AS-IS shape | ref-product-addons.csv |
| SEL_TYPE.01 단일/.02 다중 | code-values.md |
</content>
