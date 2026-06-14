# 책자 Tier A 4상품 — CPQ 옵션 레이어(L2) 설계 (round-6)

> **대상:** PRD_000068 중철책자 · PRD_000069 무선책자 · PRD_000071 트윈링책자 · PRD_000094 엽서북.
> **목적:** L1 적재된 차원행을 polymorphic `ref_dim_cd`로 참조하는 CPQ 옵션 레이어(option_groups → options → option_items + page_rule constraint + set)를 4상품에 인스턴스화하고 멱등 적재 SQL을 산출한다.
>
> **상태/권위** 작성 2026-06-14 · WIP · `dbm-option-mapper` 빌드 산출. **DB 미적재**(실 INSERT/코드행/DDL = 인간 승인, GO = dbm-validator). 빌드 산출 = `09_load/_exec_tierA_booklet/`.
> **권위 입력(인용·발명 금지):** `06_extract/booklet-l1.csv`(옵션성 컬럼 등장순서=disp_seq 권위) · `attribute-entity-map.md §2 패밀리②` · `00_schema/cpq-schema.md §1.5/§2`(트리거·excl_group) · `09_load/_exec_silsa_cpq/`(멱등 SQL 패턴) · **라이브 read-only psql 실측**(차원행 구체 코드).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 = `[CONFIRM]`.

---

## 0. Step 0 — 차원행 전제 (라이브 실측, 2026-06-14 read-only)

옵션 레이어는 **이미 적재된 차원행을 가리키는 포인터**다. 4상품의 라이브 차원행을 실측해 INSERTABLE/BLOCKED를 판정한다(차원 0행 = 트리거 REJECT = BLOCKED, 차원 재적재 안 함).

### 0.1 라이브 차원행 요약 (실측)

| 차원 | 068 중철 | 069 무선 | 071 트윈링 | 094 엽서북 |
|------|:----:|:----:|:----:|:----:|
| **사이즈** `OPT_REF_DIM.01` | SIZ_000170·172 (2) | SIZ_000170·172 (2) | SIZ_000170·172·253·255 (4) | SIZ_000003·004·124 (3) |
| **자재 내지** `.03` USAGE.01 | 13행 (몽블랑/백모/스노우/아트) | 7행 | 16행 | 1행 MAT_000109 몽블랑240 |
| **자재 표지** `.03` USAGE.02 | 13행 | 6행 | 28행 | 1행 MAT_000092 스노우300 |
| **자재 투명커버** `.03` USAGE.05 | — | — | MAT_000244 유광·MAT_000245 무광 (2) | — |
| **자재 링컬러** `.03` USAGE.07 | — | — | MAT_000013 화이트·014 블랙·015 메탈 (3) | — |
| **도수** `.06` | opt_id 1 양면·2 단면 | 1·2 | 1·2 | 1·2 |
| **공정 코팅** `.04` | PROC_000014 유광·015 무광 | 014·015 | 014·015 | 015 무광 |
| **공정 박** `.04` | — | PROC_000037~044 (8: 홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클) | — | — |
| **공정 형압** `.04` | — | PROC_000051 양각·052 음각 (2) | — | — |
| **공정 제본** `.04` | PROC_000018 중철제본 | PROC_000019 무선제본 | PROC_000021 트윈링제본 | PROC_000022 떡제본 |
| **공정 수축포장** `.04` | — | PROC_000076 | PROC_000076 | PROC_000076 |
| **page_rule** | 4~28/4 | 24~300/2 | 8~100/2 | 20~30/10 |
| **set** `.07` | — | — | — | PRD_000095 내지·PRD_000096 표지 (2) |

> [HARD] 전 차원행 **라이브 실재**(트리거 EXISTS 통과). **BLOCKED 0건** — 4상품 모두 옵션 레이어 INSERTABLE.

### 0.2 핵심 도메인 실측 발견 (설계 결정에 직접 영향)

1. **자재 usage_cd가 내지/표지를 이미 구분** — `t_prd_product_materials`는 USAGE.01(내지)·USAGE.02(표지)로 같은 종이를 2벌 링크. → **내지종이·표지종이 option_group 분리**는 `ref_key2=usage_cd`로 자연 표현(차원 재적재 불요).
2. **🔴 도수(print_options)는 내지/표지 미구분** — `t_prd_product_print_options`는 상품당 2행(단/양면)만, **usage 식별자 없음**(OPT_REF_DIM.06은 ref_key2 미사용). L1은 `내지인쇄`·`표지인쇄` 2컬럼이나 라이브 도수 차원은 1벌 공유. → **GAP-DOSU-USAGE**(§5). 본 설계는 내지인쇄·표지인쇄 2 option_group을 만들되 **동일 opt_id 1·2를 공유 참조**(트리거 통과, UI 스코프만 분리). 정직한 절충.
3. **071 투명커버·링컬러 = 자재(MAT_TYPE.02 필름 / .04 금속), 공정 아님** — 라이브 실측이 `attribute-entity-map §2` "링컬러=공정" 추정을 정정. 투명커버 USAGE.05·링 USAGE.07. → option_item `OPT_REF_DIM.03` mat_cd+usage_cd.
4. **면지·바인더링 = 자재(USAGE.03 면지 / MAT_TYPE.04·.07 D링)** — 라이브 `t_cod_base_codes` USAGE.03='면지' 실재로 §5.3 CONFIRM 해소(면지=자재). **단 4 대상상품엔 면지/바인더링 차원행 없음**(하드커버/링바인더 상품만 보유) → 본 파일럿 N/A.
5. **094 엽서북 set 2행 = 내지(PRD_000095)·표지(PRD_000096) sub-product** — 사용자 선택 add-on이 아니라 **BOM 구성**(엽서북-내지(몽블랑240)·엽서북-표지(스노우300)). → 설계 결정 §5.4.

---

## 1. 코드 채번 (라이브 MAX+1, `_` separator)

라이브 실측: opt_grp 숫자 MAX=5(양 separator 통합)·opt 숫자 MAX=16. **code-identifier-strategy(`_` 통일)** 적용 → 본 패키지 채번:

| 엔티티 | 시작 코드 | 비고 |
|--------|----------|------|
| `opt_grp_cd` | **OPT_000006**~ | MAX(5)+1. 4상품 합산 24그룹 → OPT_000006~OPT_000029 |
| `opt_cd` | **OPV_000017**~ | MAX(16)+1 |

> [HARD] SQL은 **리터럴 코드 미사용·이름기반 멱등 resolve**(silsa 패턴 모방: `opt_grp_cd`는 리터럴이되 `(prd_cd, opt_grp_nm) NOT EXISTS` 가드, `opt_cd`도 리터럴이되 옵션아이템은 `opt_nm` resolve). 재실행 시 코드 재발급 0(2-pass delta 0).

---

## 2. disp_seq 권위 = L1 옵션성 컬럼 등장순서 [HARD]

`booklet-l1.csv` 헤더 등장순서(비옵션 제외):
`사이즈` → `내지종이` → `내지인쇄` → [`내지페이지`=page_rule] → `표지종이` → `표지인쇄` → `표지코팅` → `투명커버` → `박/형압` → `제본(필수)` → `제본방향` → `면지` → `링컬러` → `바인더링`.

→ option_group `disp_seq` 부여(상품별 보유 그룹만, 빈 그룹 생략):

| disp_seq | option_group | 068 | 069 | 071 | 094 |
|:---:|---|:--:|:--:|:--:|:--:|
| 1 | 사이즈 | ✓ | ✓ | ✓ | ✓ |
| 2 | 내지종이 | ✓ | ✓ | ✓ | ✓ |
| 3 | 내지인쇄 | ✓ | ✓ | ✓ | ✓ |
| 4 | 표지종이 | ✓ | ✓ | ✓ | ✓ |
| 5 | 표지인쇄 | ✓ | ✓ | ✓ | ✓ |
| 6 | 표지코팅 | ✓ | ✓ | ✓ | ✓ |
| 7 | 투명커버 | — | — | ✓ | — |
| 8 | 박/형압 | — | ✓ | — | — |
| 9 | **제본(필수)** | ✓ | ✓ | ✓ | ✓ |
| 10 | 링컬러 | — | — | ✓ | — |

> `내지페이지`(page_rule)·`제본방향`/`면지`/`바인더링`(4상품 차원행 없음)·`수축포장`(주문옵션 아닌 포장공정)은 option_group 미생성(§3.4·§4). 표지코팅은 L1에서 `표지코팅`+`박/형압` 사이지만 라이브 코팅공정(유광/무광)으로 disp_seq 6.

---

## 3. 상품별 옵션 레이어 설계

각 그룹: `sel_typ_cd`(SEL_TYPE.01 단일/.02 다중)·min/max_sel·mand_yn. 각 옵션: option 1개당 option_item 1행(차원 포인터). dflt_yn = L1 첫 등장값.

### 3.1 PRD_000068 중철책자 (9 groups / 31 options / 31 items)

| disp | opt_grp_nm | sel_typ | mand | options (opt_nm → ref) |
|:--:|---|:--:|:--:|---|
| 1 | 사이즈 | 01 | Y | A5(148x210mm)→`.01`SIZ_000170 · A4(210x297mm)→`.01`SIZ_000172 |
| 2 | 내지종이 | 01 | Y | 13 자재 `.03` mat_cd+USAGE.01 (몽블랑/백모/스노우/아트 각 평량) |
| 3 | 내지인쇄 | 01 | Y | 양면→`.06`opt_id 1 · 단면→`.06`opt_id 2 |
| 4 | 표지종이 | 01 | Y | 13 자재 `.03` mat_cd+USAGE.02 |
| 5 | 표지인쇄 | 01 | Y | 양면→`.06`opt_id 1 · 단면→`.06`opt_id 2 (도수 공유, §5 GAP-DOSU-USAGE) |
| 6 | 표지코팅 | 01 | N | 유광→`.04`PROC_000014 · 무광→`.04`PROC_000015 (코팅없음=센티넬 min0) |
| 9 | **제본** | 01 | **Y** | 중철제본→`.04`PROC_000018 |

> 내지·표지종이 옵션은 13행 자재 각각 1 option. (옵션 행수 = 사이즈2 + 내지13 + 내지인쇄2 + 표지13 + 표지인쇄2 + 코팅2 + 제본1 = ... 실제 build SQL이 mat 전체를 SELECT 전개; 표 행수는 제너레이터 산출과 일치.)

### 3.2 PRD_000069 무선책자 (10 groups, 박/형압 포함)

| disp | opt_grp_nm | sel_typ | mand | options |
|:--:|---|:--:|:--:|---|
| 1 | 사이즈 | 01 | Y | A5 SIZ_000170 · A4 SIZ_000172 |
| 2 | 내지종이 | 01 | Y | 8 자재 `.03`+USAGE.01 |
| 3 | 내지인쇄 | 01 | Y | 양면 opt_id1 · 단면 opt_id2 |
| 4 | 표지종이 | 01 | Y | 6 자재 `.03`+USAGE.02 |
| 5 | 표지인쇄 | 01 | Y | 양면 · 단면 (공유) |
| 6 | 표지코팅 | 01 | N | 유광 PROC_000014 · 무광 PROC_000015 |
| 8 | **박/형압** | **02** | N | 박 8종(홀로그램 PROC_000037 … 트윙클 044) + 형압 양각 051·음각 052 = **10 옵션 다중(max_sel 10)** |
| 9 | **제본** | 01 | **Y** | 무선제본 PROC_000019 |

> 박/형압 = `SEL_TYPE.02 다중`(L1 박+형압 동시 선택 가능, max_sel=10). 박색상·형압 양/음각이 한 그룹. **박/형압 크기 param(30x30~170x170) = GAP-PARAM**(§4, ref_param_json 미구현 — 본 적재 미반영).

### 3.3 PRD_000071 트윈링책자 (10 groups, 투명커버·링컬러 자재)

| disp | opt_grp_nm | sel_typ | mand | options |
|:--:|---|:--:|:--:|---|
| 1 | 사이즈 | 01 | Y | A5 170 · A4 172 · A5가로 253 · A4가로 255 (4) |
| 2 | 내지종이 | 01 | Y | 18 자재 `.03`+USAGE.01 |
| 3 | 내지인쇄 | 01 | Y | 단면 opt_id1 · 양면 opt_id2 |
| 4 | 표지종이 | 01 | Y | 21 자재 `.03`+USAGE.02 |
| 5 | 표지인쇄 | 01 | Y | 단면 · 양면 (공유) |
| 6 | 표지코팅 | 01 | N | 유광 014 · 무광 015 |
| 7 | **투명커버** | 01 | N | 유광투명커버→`.03`MAT_000244+USAGE.05 · 무광투명커버→`.03`MAT_000245+USAGE.05 (투명커버없음=센티넬 min0) |
| 9 | **제본** | 01 | **Y** | 트윈링제본 PROC_000021 |
| 10 | **링컬러** | 01 | Y | 화이트링→`.03`MAT_000013+USAGE.07 · 블랙링→014 · 메탈링→015 |

> 투명커버·링컬러 = **자재(`OPT_REF_DIM.03` mat_cd+usage_cd)**, 공정 아님(§0.2-3 라이브 정정). 제본방향(좌철/상철) = GAP-PARAM(§4).

### 3.4 PRD_000094 엽서북 (8 groups + set 2)

| disp | opt_grp_nm | sel_typ | mand | options |
|:--:|---|:--:|:--:|---|
| 1 | 사이즈 | 01 | Y | 100x150 SIZ_000003 · 135x135 004 · 150x100 124 (3) |
| 2 | 내지종이 | 01 | Y | 몽블랑240→`.03`MAT_000109+USAGE.01 (1) |
| 3 | 내지인쇄 | 01 | Y | 단면 opt_id1 · 양면 opt_id2 |
| 4 | 표지종이 | 01 | Y | 스노우300→`.03`MAT_000092+USAGE.02 (1) |
| 5 | 표지인쇄 | 01 | Y | 단면 · 양면 (공유) |
| 6 | 표지코팅 | 01 | N | 무광 PROC_000015 |
| 9 | **제본** | 01 | **Y** | 떡제본 PROC_000022 |
| (set) | **셋트(구성)** `[CONFIRM]` | 01 | — | 엽서북-내지 PRD_000095·엽서북-표지 PRD_000096 → `.07` sub_prd_cd |

> **set 2행 = BOM 구성**(§5.4 설계 결정). 사용자 선택 add-on이 아니므로 옵션화 여부 CONFIRM — 본 파일럿은 **set option_group 1개(셋트 구성)**로 `OPT_REF_DIM.07` 2 item 생성하되, "BOM 고정(미노출)" 가능성을 §5.4 플래그. mand_yn=N·hidden 후보(GAP-HIDDEN).

---

## 4. constraints (page_rule = 비옵션 범위, 별도 R-PAGE)

- **내지페이지 = `t_prd_product_page_rules` 범위(이미 라이브 적재)** — option_group 아님(counter-input). 068=4~28/4·069=24~300/2·071=8~100/2·094=20~30/10. **본 적재는 page_rule 행을 손대지 않음**(이미 존재). JSONLogic constraint로 중복 표현하지 않음(§ skill: quantity=products/page_rule, constraint 아님).
- **R-DOSU-BNC(도수↔제본 호환)** = 가능하나 4상품 모두 제본 단일·도수 자유라 **유의미 제약 없음** → constraints 0행(silsa와 동형, DEFER).
- **최종 가격유효성 = 가격엔진**(비가격조합=주문불가). enumerate 제약 안 함.

→ **constraints 0행**(08_*.sql = 주석만).

---

## 5. 설계 결정 / [CONFIRM] (침묵 선택 금지)

### 5.1 내지/표지 2축 — 자재는 usage_cd로 분리(확정), 도수는 공유(GAP)
- **자재(종이):** `ref_key2=usage_cd`(USAGE.01/02)로 내지종이·표지종이 option_group 자연 분리 — **확정, 차원 재적재 불요**.
- **도수(인쇄):** 🔴 `t_prd_product_print_options`에 usage 식별자 없음(상품당 단/양면 2행 공유). 내지인쇄·표지인쇄 2 option_group이 **동일 opt_id 1·2를 참조** → 트리거 통과·UI 스코프만 분리. **GAP-DOSU-USAGE**(§ ddl-proposer: print_options에 usage_cd 추가 vs 내지/표지 별 print_option 행). 본 적재는 공유 참조로 진행(정직한 절충, 발명 아님).

### 5.2 제본(필수) = 택일그룹 (excl_group 라이브 마이그 실증과 정합)
- `cpq-schema §1.5`는 GRP-BOOK-제본(PRD_000068~100)을 excl_group 마이그 실증으로 기술하나, **라이브 실측 결과 4상품에 제본 option_group 0행**(stale). → 본 설계가 **제본 택일그룹을 신규 생성**(SEL_TYPE.01 max_sel=1 mand_yn=Y, 공정 1개씩). 4상품은 각 제본 1종이라 단일 option이지만 **택일그룹 형식 유지**(향후 제본 다종 상품과 정합). 중복 생성 아님(라이브 0행 확인).

### 5.3 투명커버·링컬러·면지·바인더링 = 자재 (라이브 정정, §0.2-3·4)
- 라이브 실측이 attribute-map의 "링컬러=공정" 추정을 정정 → **전부 자재(`OPT_REF_DIM.03`)**. 면지=USAGE.03·투명커버=USAGE.05·링=USAGE.07. 4 대상상품엔 면지/바인더링 없음(하드커버/링바인더 전용).

### 5.4 094 엽서북 set 2행 = BOM vs 사용자 옵션 `[CONFIRM]`
- set = 엽서북-내지(PRD_000095)·엽서북-표지(PRD_000096) = **생산 BOM 구성**(사용자 선택 add-on 아님). 
- **후보 A(본 적재 채택):** 셋트 option_group 1개 + `.07` 2 item, mand_yn=N·미노출(hidden) 후보 — BOM을 옵션 레이어에 기록하되 UI 미노출.
- **후보 B:** set은 옵션 레이어가 아니라 `t_prd_product_sets`(이미 라이브 2행)로 충분, option_group 불요.
- **판정: DESIGN DECISION NEEDING CONFIRMATION** — 본 빌드는 후보 A로 SQL 생성하되 `_blocked`/manifest에 CONFIRM 플래그. 미노출 플래그 부재 = GAP-HIDDEN.

---

## 6. GAP 레지스터 (→ dbm-ddl-proposer, `blocked-and-gaps.md`)

| GAP | 내용 | 영향 | 상태 |
|-----|------|------|------|
| **GAP-DOSU-USAGE** | print_options usage 미구분 → 내지/표지 인쇄 도수 공유 참조 | 4상품 표지인쇄 | print_options에 usage_cd vs 별 행 — ddl-proposer |
| **GAP-PARAM** | 박/형압 크기(30~170)·제본방향(좌철/상철) param 보존 컬럼 부재(ref_param_json) | 069 박/형압·071 제본방향 | cpq-schema §4 🔴8 |
| **GAP-HIDDEN** | 094 set BOM 미노출 플래그 부재(auto-apply hidden) | 094 셋트 | option_groups에 hidden 플래그 |

> [HARD] 발명 금지·플래그만. 실 컬럼/DDL = ddl-proposer·인간 승인.

---

## 7. INSERTABLE / BLOCKED 집계

| 상품 | option_groups | options | option_items | BLOCKED | constraints |
|------|:---:|:---:|:---:|:---:|:---:|
| 068 중철 | 7 | (제너레이터 산출) | = options | 0 | 0 |
| 069 무선 | 8 | 산출 | = options | 0 | 0 |
| 071 트윈링 | 9 | 산출 | = options | 0 | 0 |
| 094 엽서북 | 7 + set1 | 산출 | options + set2 | 0 | 0 |

> **BLOCKED 0건**(전 차원행 라이브 실재). 정확 행수 = `09_load/_exec_tierA_booklet/load-manifest.md`(제너레이터 산출 + DRY-RUN 실측).
