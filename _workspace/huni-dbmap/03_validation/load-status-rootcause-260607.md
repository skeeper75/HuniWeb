# 미적재 근본원인 원장 (Load-Status Root-Cause Ledger) — 2026-06-07

> **작성/권위:** `dbm-validator` 독립 산출(2026-06-07). 본 문서는 "무엇이 라이브 DB에 아직 적재되지 않았으며, 정확히 왜인가"의 정본 원장이다.
> **방법:** 경계면 교차검증 + 라이브 read-only SELECT(`BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK;` — 쓰기 0·COMMIT 0). "loaded = 라이브 행 실재"로만 판정(GO≠적재).
> **권위 순서(HARD):** LIVE DB > `08_remediation` 기록 라이브결과 > `ref-*.csv`(stale 2026-06-04). Excel/가격표 명시값 > 추출 스냅샷 > 설계 문서. 존재/등록/NULL 판정 = **라이브 권위**.
> **설계 권위(사용자 필수 참조):** `docs/huni/2026-06-05-product-configurator-design.md`(루트 컨피규레이터 설계 — §0 시스템 경계, §1 세 축, §7 미해결) + `_workspace/huni-dbmap/10_configurator/cpq-design.md`(CPQ 설계 정본, 라이브 정합). **§0 시스템 경계가 본 원장의 1차 프레임**: 컨피규레이터 범위는 **가격 계산 엔진을 명시적으로 제외**하므로(§0 line13/17) 가격 트랙과 옵션 레이어(L2) 미적재는 **설계상 별개 사안** — 본 원장은 둘을 혼동하지 않고 분리 분석한다.

---

## 0. 라이브 그라운드 트루스 (2026-06-07, 권위 — read-only)

| 도메인 | 테이블 | 라이브 행수 | 적재 상태 한 줄 |
|--------|--------|:----------:|----------------|
| 가격 엔진 | t_prc_price_formulas | 16 | 공식 16개 적재(15 use_yn=Y, PRF_DGP_F=N) |
| | t_prc_price_components | 144 | 적재 |
| | t_prc_formula_components | 85 | 배선 적재 |
| | t_prc_component_prices | **3,481** | 적재(round-2 area/fixed + 디지털/ENV/GP GO분) |
| | t_prd_product_price_formulas | 64 | **상품 64개만 공식 바인딩** |
| | **t_prd_product_prices** | **0** | **직접단가(가격포함) 전무 — EMPTY** |
| | t_prd_product_bundle_qtys | 26 | 적재 |
| 할인 | t_dsc_discount_tables / details | 7 / 35 | round-1 적재 |
| | t_dsc_grade_discount_rates | 0 | 등급할인 미사용(설계 여지) |
| | t_prd_product_discount_tables | 98 | round-1 적재 |
| CPQ L2 | t_prd_product_option_groups | 17 | **seed/test 4 + excl 마이그 13** (파일럿 0) |
| | t_prd_product_options | **2** | 사용자 관리자 UI 테스트행 2건(PRD_000097, 이번 세션 19:43 생성·사용자 확인·보존). 세션 시작 시 0 → 작업 중 동시 생성. 운영 옵션 0 |
| | t_prd_product_option_items | **0** | **EMPTY — 옵션 레이어 본체 전무** |
| | t_prd_templates | 11 | 헤더만(selections 0) |
| | t_prd_template_selections | 0 | EMPTY |
| | t_prd_product_constraints | 4 | **seed/test 4행**(PRD_000002·016) |
| | t_prd_products.constraint_json | 2 non-null | seed/test 2행 |
| 차원 (L1) | t_prd_product_sizes | 447 | 적재 |
| | t_prd_product_materials | 716 | 적재 |
| | t_prd_product_processes | 260 | 적재 |
| | t_prd_product_print_options | 166 | 적재 |
| | t_prd_product_plate_sizes | 424 | 적재(국4절 등) |
| | t_prd_product_sets | 28 | 적재 |
| | t_prd_product_page_rules | 11 | 적재 |
| | t_prd_product_addons | 34 | 적재(tmpl_cd FK) |
| | t_prd_products | 275 | 적재 |
| 마스터 코드 | t_siz_sizes / t_mat_materials / t_proc_processes | 510 / 336 / 83 | proc max=**PROC_000083**(heat-cut 084 미등록) |

> **L1 차원은 거의 전건 적재 완료.** 미적재의 본질은 ① **가격 바인딩**(211 상품 무가격) ② **CPQ 옵션 레이어 L2 본체**(option_items=0) ③ **마스터 코드행 일부**(PROC_000084) ④ **설계 결정/GAP 대기분**이다.

---

## 1. 라이브 vs 의도 정합 (테이블별 4분류)

분류: **FULLY-LOADED**(의도 전건 적재) · **PARTIALLY-LOADED**(일부) · **EMPTY-BUT-INTENDED**(적재 의도 있으나 0) · **EMPTY-BY-DESIGN**(설계상 비움).

| 테이블 | 분류 | 근거 |
|--------|------|------|
| t_prc_component_prices | **PARTIALLY-LOADED** | 3,481행. round-4 계획(즉시 2,108 + 차단 2,697 = 원본 4,805)에서 차단 2,697 중 다수가 후속 GO분으로 해소됨(아래 §1.1). |
| t_prd_product_price_formulas | **PARTIALLY-LOADED** | 64/275 상품만 공식 바인딩. 나머지 211은 무가격(§2a). |
| **t_prd_product_prices** | **EMPTY-BUT-INTENDED** | DDL §5 (가격포함) 직접단가 경로 설계됨(`price-pilot-goods.md` 레더코스터 PRD_000188→product_prices 1행). **추출·적재 전무**(§2a). |
| t_dsc_* (할인) | **FULLY-LOADED** | round-1 GO·적재(tables 7·details 35·product_disc 98). grade_discount_rates=0은 EMPTY-BY-DESIGN(등급할인 미사용). |
| t_prd_product_{sizes,materials,processes,print_options,plate_sizes,page_rules,sets,addons,categories} | **FULLY-LOADED** (실용상) | GO분 실제 COMMIT 완료(CLAUDE.md §7 2026-06-06/07). 단 차단·코드행 의존분 일부 미적재(§4). |
| t_prd_product_option_groups | **PARTIALLY-LOADED** | 17행 = seed/test 4(PRD_000002) + excl_group 마이그 13(GRP-BOOK 10·GRP-CAL 3). **round-6 파일럿(엽서·현수막) 0행**. |
| t_prd_product_options | **PARTIALLY-LOADED** | 2행 = PRD_000097 "테스트옵션" 2건(seed). 운영 옵션 0. |
| **t_prd_product_option_items** | **EMPTY-BUT-INTENDED** | **0행**. 옵션 레이어의 본체(polymorphic 차원 포인터). round-6 파일럿 GO분 전혀 미적재(§3). |
| t_prd_template_selections | **EMPTY-BUT-INTENDED** | 0행. templates 11 헤더만, 구성내용 미투입(§3). |
| t_prd_product_constraints | **PARTIALLY-LOADED(seed only)** | 4행 전부 test("금지테스트"·"터져"·"테스트"). 설계 검증한 JSONLogic 운영 룰 0(§3). |

### 1.1 round-4 계획수치 → 현재 라이브 성장 화해 (가격 차단 2,697의 행방)

round-4 가격 적재본(`_load-readiness-summary.md §3`)은 **즉시 2,320 + 차단 2,697**(후니 siz 등록 대기 placeholder siz 7군: GUK4 870·POSTER 680·STK 456·3JEOL 304·ACRYL 237·GP 110·ENV 40)이었다. 현재 라이브 `component_prices=3,481`.

| 원본 차단군(2,697) | 현재 라이브 처리 | 근거 |
|---|---|---|
| GUK4 870·3JEOL 304 등 plate 의존 | **부분 해소** — 국4절 plate 32상품 실적재(2026-06-07 c722c24)·면적매트릭스/고정가 migrate 분 COMMIT | CLAUDE.md §7 plate·area/fixed 트랙 |
| ENV 40 | **해소** — `_exec_env` ENV 40행 COMMIT(2026-06-07) | CLAUDE.md §7 ENV |
| GP 110 | **부분 해소** — `_migrate_gp_circle` GP 121행 COMMIT(SIZ_000501~510 신규 siz 10 포함, 라이브 확인됨) | Q7c siz_501_510=10 |
| POSTER 680·ACRYL 237·STK 456 일부 | **일부 잔존** — 3절/투명 용지비·박 슬롯·바인딩 등은 여전히 차단(§2b) | `digital-print-engine` 잔존 차단 |

> **정량:** 원본 4,805(단가) 기준, 현재 3,481 적재 = 의도분의 **약 72%**. 잔존 미적재 가격 단가는 주로 **3절/투명/박/특정 plate 교정 의존분**(§2b) — 전부 인간승인/plate교정/DDL 대기.

---

## 2. 가격 트랙 미적재 (가격 권위로 분석 — 컨피규레이터 범위 밖)

> 설계 §0 line13/17: "**이번 범위 밖: 가격 계산 엔진**". 따라서 본 §2는 컨피규레이터(L2)와 **독립**으로, round-2/round-5 가격 권위(`price-engine-ddl.md`)로 분석한다.

### 2(a) t_prd_product_prices = 0 + 211 상품 무가격 — **최대 미해결 DATA-GAP**

**라이브 실측(Q1):**
```
total_products=275 · with_formula=64 · direct_price_rows=0 · neither_formula_nor_direct=211
```

- **64 상품만** 공식 바인딩(Q4): PRF_POSTER_FIXED 28 · PRF_DGP_A~F 19 · PRF_*_FIXED(명함3·스티커3·포토카드2·떡메1·합판1·엽서북1) · PRF_BIND_SUM 4 · PRF_FOLD_SUM 1 · PRF_ENV_MAKING 1.
- **0 상품** 직접단가(`t_prd_product_prices`). DDL §5는 `(가격포함)` 상품(문구/굿즈파우치/포토북 등)이 이 경로로 단가를 갖도록 설계했고, `price-pilot-goods.md`가 레더코스터(PRD_000188)→`product_prices` 1행, 손거울→`component_prices(siz_cd)`로 **경로를 실증**했다. 그러나:
  - `09_load/` 어디에도 `t_prd_product_prices` 적재 산출 **없음**(Q19 — 모든 가격 산출이 `component_prices`/`formula_components`/`price_formulas` 대상).
  - 굿즈/문구 가격은 `price-info-deferred.md`로 round-2 이연 라벨만 붙은 채 **엔진 적재 미착수**(goods-pouch `선택_가격`·`가격`·`가공_가격`, product-accessory `가격`, stationery `가격`, photobook `가격_기본(24P)` 등).
- **211 무가격 상품의 패밀리(Q8):** 하드커버책자 22 · 상품악세사리 15 · 단품형 14 · 스티커 13 · 조합형 11 · 말랑/레더/패브릭 파우치·에코백 다수 · 포토북 8 · 명함 7(FIXED 3 외 잔여) · 캘린더 일부. → **굿즈·파우치·에코백·책자·악세사리 패밀리**가 주류.

**분류:** **DATA-GAP (never-extracted)** — 매핑 자체는 경로를 설계·실증했으나(`price-pilot-goods.md`), **굿즈/문구/책자 전 시트의 가격 데이터를 엔진(component_prices/product_prices) 적재본으로 추출·조립한 적이 없다.** out-of-scope-by-design 아님(가격은 후니 운영 필수). extracted-but-blocked 아님(차단 placeholder siz와 무관 — 애초에 적재본 미생성).

> **이것이 본 원장에서 가장 큰 단일 미해결 항목이다.** round-2~5는 디지털인쇄/포스터/봉투/스티커 등 "공식형/면적형/고정가형" 상품에 집중했고, **(가격포함) 직접단가 패밀리(211 상품)는 가격 트랙이 닫지 못했다.**

### 2(b) 잔존 가격 차단(개별) — 인간승인/plate교정/모델링 의존

| 차단 대상 | 미적재 내용 | 근본원인 | 해소조건 |
|---|---|---|---|
| 3절/투명 용지비 9행 | COMP_PAPER 용지비(3절·투명 출력용지규격) | PLATE-CORRECTION — 작업사이즈 plate가 디지털인쇄비 커버 0(plate 미교정) | 3절/투명 plate 교정 후 적재(인간승인) |
| 박 2단룩업 | 박 면적→분류→가격 중간키 부재 | MODELING — 면적→등급 매핑이 앱 계산(중간키 DB 미저장) | 박 GAP 모델링 결정(매핑표 DB정착 아님 — 메모리 권위) |
| 048 재바인딩 1 | 엽서북 재바인딩 단가 | HUMAN-APPROVAL + plate교정 | plate 교정·승인 |
| 019·030·049 | plate 의존 가격행 | PLATE-CORRECTION | 해당 상품 plate 교정 |
| foil 슬롯 6·바인딩 3 | 박/바인딩 단가 | HUMAN-APPROVAL(plate교정/박모델) | 디지털인쇄 잔존 차단(설계 GO·미적재) |

> 가격 트랙 검증 권위: `03_validation/digital-print-engine-gate.md` · `digital-print-load-execution-gate.md`. 잔존 차단은 전부 **인간승인 또는 plate교정 또는 박모델링** 대기 — 매핑 결함 아님.

### 2(c) PRF_DGP_F 미출시 공식이 PRD_000051에 바인딩됨 (MINOR 발견)

라이브 실측(Q15·Q17): `PRF_DGP_F`(썬캡 미출시, use_yn='N')에 **component_prices 509행 + PRD_000051 바인딩**이 실재. 미출시 공식이 단가·바인딩을 가진 상태 = **운영상 무해하나(use_yn=N로 비활성) 정합 노이즈**. **분류: 정보(데이터 무결, 미적재 아님)** — 미출시 처리 시점(use_yn 일괄)에 정리 권고.

---

## 3. CPQ 옵션 레이어(L2) 미적재 (컨피규레이터 설계 권위로 분석)

> 설계 §1 원칙#1(line12/16): "모든 선택 가능한 옵션은 **자재/공정으로 환원** 가능해야 한다" → option_items가 *이미 적재된 차원행을 가리키는 polymorphic 포인터*인 이유. **따라서 option_items=0은 데이터 소실이 아니다** — L1 차원(sizes 447·materials 716·processes 260)은 적재되어 있고, **그 위에 얹는 L2 포인터 레이어만 미투입**이다.

### 3.1 라이브 L2 적재 정밀 판정 (Q9·Q12·Q16·Q20)

```
option_groups=17 · options=2 · option_items=0 · templates=11 · template_selections=0 · constraints=4 · constraint_json non-null=2
```

- **option_groups 17 = 운영 옵션 아님**: ① seed/test 4행(PRD_000002 "Test"·"제본방식"·"가공방식") ② excl_group 마이그 13행(`GRP-BOOK-제본` 10상품: PRD_068~100 · `GRP-CAL-가공` 3상품: PRD_110~112). 후자는 **설계 D-2 "택일그룹 흡수" 실증**(cpq-schema §1.5) — 정당 적재.
- **options 2 = 사용자 관리자 UI 테스트**: PRD_000097 "테스트옵션" 2건(이번 세션 19:43~19:50 생성, 사용자 확인·보존). 세션 시작 마스터카운트=0 → 작업 중 사용자 동시 생성("stale 스냅샷" 아님, dbm-validator는 read-only 준수). **운영 옵션 0**.
- **option_items 0 · template_selections 0**: 옵션 레이어 본체와 템플릿 구성내용 **전무**.
- **constraints 4 = seed/test only**: PRD_000002 "금지테스트"×2·"테스트", PRD_000016 "터져". **설계 검증 JSONLogic 운영 룰 0**.

### 3.2 round-6 GO 파일럿(엽서·현수막)은 라이브에 전혀 없다 (확정)

라이브 실측(Q10): **PRD_000016(엽서) option_groups=0 · PRD_000138(현수막) option_groups=0.** round-6가 설계·검증 GO한 파일럿(엽서 groups5/options13/items4 INSERTABLE, 현수막 items 9 INSERTABLE)은 **option_groups부터 0행** = **파일럿 전건 미적재**. (단 두 상품의 L1 차원은 적재됨: 엽서 sizes7·materials21·processes6.)

### 3.3 L2 미적재 근본원인 (정밀 enumerate)

| # | 근본원인 | 대상 | 라이브 근거 | 해소조건 |
|---|---------|------|------------|----------|
| (i) | **HUMAN-APPROVAL** | 엽서·현수막 파일럿 INSERTABLE 전건 + 운영 option_groups/options/items/constraints | 하네스 standing rule = DB 쓰기 인간승인(HANDOFF) | 인간 승인 후 멱등 적재본 적재 |
| (ii) | **DEP-선적재 (DATA-GAP)** | 파일럿 option_item이 참조하는 **미적재 차원행** | Q11 라이브 실측 | 차원행 선적재(FK-topo)·승인 |
| | — 부착 PROC_000081 on PRD_124/139 | **미적재**(124=0·139=0; 138만=1) | Q11 | 124/139에 PROC_081 선적재 |
| | — 열재단 PROC_000084 | **미적재**(proc max=PROC_083, 084 부재) | Q7·Q7c | 코드행 신설(§4) |
| | — 각목 셋트(현수막) | sets=0(PRD_138) | Q10 | 각목 완제상품 등록 + sets 적재 |
| | — 별색 PROC_000008 on PRD_122 | **이미 적재됨(1행)** | Q11 | **권위반전: HANDOFF "별색122 선적재 필요"는 stale** — 차단 아님 |
| (iii) | **DDL-GAP (충실 적재 차단)** | 파라미터·계층·자동적용 옵션 | cpq-schema §4 + 파일럿 실측 | DDL 제안 → 승인 |
| | — **GAP-PARAM** (`ref_param_json` 미구현) 🔴 | 타공 구수·오시/미싱 줄수·가변 개수·박 크기·조각수 보존처 없음 | cpq-schema §4 🔴8 + `cpq-option-gaps` 파일럿 실측(option_items 라이브 컬럼=qty만) | `ref_param_json jsonb` 컬럼 추가 vs qty 재사용(단일정수만) |
| | — **GAP-HIDDEN** | 자동적용·미표시(재단 CUT_DFT 등) 플래그 부재 | cascade-rules §5 | `auto_apply_yn` 컬럼 |
| | — **GAP-COMPOSITE** | 복합옵션 항목 관계(박색상⊂박 계층·각목+끈 동반) 표현 부재 | banner/postcard §5.2 | `item_combine_typ`/`parent_item_seq` |

> **핵심:** L2가 0인 1차 원인은 **HUMAN-APPROVAL**(설계·검증까지만 산출, 적재는 승인 대기)이며, 승인되어도 **DEP-선적재(미적재 차원행)와 DDL-GAP(파라미터 보존)**이 충실 적재의 추가 관문이다. **매핑 자체는 막혀있지 않다**(설계·검증 GO).

---

## 4. 마스터/코드행 선적재 대기 (HUMAN-APPROVAL channel)

| 코드행 | 라이브 상태 | 무엇을 풀까 | 미적재 사유 |
|--------|------------|------------|------------|
| **PROC_000084 열재단** | **미등록**(proc max=PROC_000083, 열재단/레이저 명 0건 — Q7) | 현수막 열재단 옵션·가격 3,000원 | 채번=`[CONFIRM-CHANNEL]`(라이브 MAX 확인 후 후니 배정) — 인간채널 |
| 레이저커팅 proc(아크릴 완칼) | 미등록(동일 — 열재단/레이저 명 0건) | 아크릴 완칼 14행 | 코드행 승인 |
| 원형 siz 10종(sticker 066) | **부분** — SIZ_000501~510 적재됨(GP), 원형35mm=기존 SIZ_000422 재사용 | sticker 원형 | round-4 search-before-mint 정정 반영(11→10), 잔여 승인 |
| **PRC_COMPONENT_TYPE.06 완제품비** | **이미 등록됨**(Q7b-2 — .01~.06 전건 실재) | 완제품 통가격 component | **권위반전: round-4 "코드선적재 제안 1"은 이미 적재 완료** |
| 디자인캘린더 5 신규상품 prd_cd | 미등록 | 18 연결행 | prd_cd 실번호 부여 + 출시 승인 |

> **권위반전 2건 적발:** ① PRC_COMPONENT_TYPE.06은 round-4가 "코드선적재 제안"으로 둔 항목이나 **라이브 이미 적재**. ② PROC_000008 별색 on PRD_122는 HANDOFF가 "선적재 필요"로 둔 항목이나 **라이브 이미 적재**. 두 stale 항목은 차단 목록에서 제외해야 한다.

---

## 5. 누락된 정보 / 미해결 매핑 (사용자 "누락된 정보 없는지 확인")

### 5(a) GAP 레지스터 (t_* 귀속처 없는 속성 — DDL 함의)

`cpq-option-gaps.md` 8건. 라이브 실측 강화분 반영:

| GAP | 내용 | DDL 함의 | 상태 |
|-----|------|---------|------|
| GAP-PARAM 🔴 | 공정 파라미터(구수/줄수/개수/박크기/조각수) 보존 = `ref_param_json` 미구현 | option_items에 jsonb 컬럼 추가 | **파일럿 실측 확정**(컬럼 부재) |
| GAP-DEFER 🔴 | 미적재 차원 옵션 등록 시 EXISTS 트리거 위반 | 적재순서/센티넬 규약(DDL 아님) | DEP-선적재로 해소 |
| GAP-BOARD 🆕 | 보드종류(폼보드/포맥스)=자재vs가공vs형태 모호 | 차원행 신설(자재 권고) | 설계 결정 선행(5상품 materials 0) |
| GAP-SHAPE | 비치수 형상/용량(원형/별/11온스) width/height 부재 | siz width/height NULL 허용 확인 | round-5 11_ddl_proposals 식별 |
| GAP-OPT | 포장/각인/자유옵션 그릇 부재 | 신규 OPT_REF_DIM vs 전용테이블 | 사다리 신중 |
| GAP-COMPOSITE | 복합옵션 관계 표현 부재 | item_combine_typ/parent_item_seq | 컬럼 |
| GAP-COUNT | 개수형 공정 N(구수) | GAP-PARAM과 통합 | — |
| GAP-HIDDEN | 자동적용 플래그 부재 | auto_apply_yn | Low |
| GAP-PANSU | 판수 전용축 없음 | 정보용(이미 size 부속·옵션 밖) | 결정완 |

### 5(b) 미해결 설계 결정 (DESIGN-DECISION — 침묵 선택 금지)

| 결정 | 후보 | 설계 §7 플래그 여부 | 영향 |
|------|------|:------:|------|
| 잉크색(만년스탬프) = 도수 vs 자유옵션그릇 | A 도수(.06) / B GAP-OPT | (가격연계 §7 후속) | goods-pouch 옵션화 |
| 용량(머그 11온스) = 비치수 size vs 규격 | A 규격(.01 비치수) / B 별 사양축 | round-5 식별 | GAP-SHAPE 종속 |
| 면지/바인더링(booklet) = 자재 vs 공정/셋트 | A 자재(.03) / B 공정·셋트 | `[CONFIRM]` 차원행 정체 미확인 | 책자 옵션화 |
| 보드종류(GAP-BOARD) = 자재vs가공vs형태 | 자재 권고 | 신규 | 보드/액자 5상품 |
| 실내/실외 거치대 = 1 base vs 2 SKU | — | — | 거치대 template |

> **설계 §7 직접 deferred(설계상 합법 미해결):** consume_qty/BOM, **옵션→가격 연계(후속)**, excl_groups 흡수 vs 병존 최종, 물리명 확정 — 이들은 **DESIGN-DEFERRED**(승인대기 아님, 설계가 후속으로 미룬 것).

### 5(c) 13시트 중 가격 데이터 미추출 (= 2(a)와 동근원)

13시트 옵션성/차원 속성은 L1 추출·적재 완료(attribute-entity-map 부록). **그러나 가격 컬럼**(goods-pouch·product-accessory·stationery·photobook·calendar·design-calendar의 `가격`/`선택_가격`/`가공_가격`/`가격_기본`)은 `price-info-deferred.md`로 이연 라벨만 붙은 채 **엔진 적재본 미생성** → 2(a) 211 무가격의 데이터 원천. **이것이 "누락된 정보"의 핵심**: 옵션/차원은 누락 없으나 **굿즈·문구·책자 가격 적재가 누락**.

### 5(d) 직접단가 ((가격포함)) — 2(a) 참조. EMPTY-BUT-INTENDED.

---

## 6. 미적재 근본원인 원장 (종합 — 1행 = 1 미적재 항목)

근본원인 분류: **HUMAN-APPROVAL** / **DDL-GAP** / **DATA-GAP** / **DESIGN-DECISION** / **DESIGN-DEFERRED**(설계 §7) / **DEP-선적재** / **PLATE-CORRECTION** / **MODELING**.

| 트랙 | 미적재 대상 | 행수(추정) | 근본원인 | 근본원인 상세 | 해소조건 |
|------|------------|:---------:|---------|--------------|----------|
| 가격 | **t_prd_product_prices (직접단가)** | 0→다수(굿즈/문구/책자 211 상품) | **DATA-GAP** | (가격포함) 경로 설계·실증(레더코스터)했으나 굿즈/문구/책자 가격 엔진 적재본 미생성 | 굿즈/문구/책자 가격 추출→component_prices/product_prices 조립→승인 |
| 가격 | 211 상품 공식·단가 무바인딩 | 211 상품 | **DATA-GAP** | round-2~5가 공식형/면적형/고정가형 64상품만 커버 | 위와 동일(시트별 가격 적재 트랙) |
| 가격 | 3절/투명 용지비 | 9 | **PLATE-CORRECTION** | 작업사이즈 plate가 디지털인쇄비 커버 0 | 3절/투명 plate 교정·승인 |
| 가격 | 박 2단룩업 | (다수) | **MODELING** | 면적→등급 중간키 앱계산(DB 미저장) | 박 GAP 모델링 결정 |
| 가격 | 048/019/030/049 | ~4 | **PLATE-CORRECTION + HUMAN-APPROVAL** | plate 교정 의존 | plate 교정·승인 |
| 옵션 L2 | option_items (옵션 레이어 본체) | 엽서 4 + 현수막 9 INSERTABLE + 운영 다수 | **HUMAN-APPROVAL** | 설계·검증 GO, 적재는 standing rule상 승인 대기 | 인간 승인 후 멱등 적재 |
| 옵션 L2 | options 운영행 | 다수(test 2 외) | **HUMAN-APPROVAL** | 동상 | 동상 |
| 옵션 L2 | template_selections | 11 헤더분 구성내용 | **HUMAN-APPROVAL** | 헤더만 적재, 구성 미투입 | 승인 |
| 옵션 L2 | constraints 운영 JSONLogic | 다수(test 4 외) | **HUMAN-APPROVAL** | 설계 검증 룰 미적재 | 승인 |
| 옵션 L2 | 부착 PROC_081 on 124/139 | 2 | **DEP-선적재** | 124/139에 차원행 미적재(라이브 0) | 차원행 선적재·승인 |
| 옵션 L2 | 각목 셋트(현수막) | (셋트행) | **DEP-선적재** | 각목 완제상품·sets 0 | 상품 등록 + sets 적재 |
| 옵션 L2 | ref_param_json 의존 옵션(타공/오시/박/조각수) | 다수 | **DDL-GAP** | 파라미터 보존 컬럼 부재 | ref_param_json 추가(승인) |
| 옵션 L2 | 보드 substrate(폼보드/포맥스 5상품) | 5상품 | **DESIGN-DECISION (GAP-BOARD)** | 자재vs가공vs형태 미확정·materials 0 | 설계 결정 후 차원행 신설 |
| 옵션 L2 | 복합옵션 계층/동반 | 다수 | **DDL-GAP (GAP-COMPOSITE)** | item 관계 컬럼 부재 | 컬럼 추가 |
| 옵션 L2 | 자동적용 후가공 | 다수 | **DDL-GAP (GAP-HIDDEN)** | auto_apply 플래그 부재 | 컬럼 추가 |
| 옵션 L2 | 잉크색·용량·면지 귀속 | (해당 상품) | **DESIGN-DECISION** | 도수vs옵션·size vs규격·자재vs공정 | 사용자/도메인 확정 |
| 옵션 L2 | 옵션→가격 연계 | — | **DESIGN-DEFERRED (§7)** | 설계가 후속 Phase로 미룸 | 후속 설계 |
| 마스터 | PROC_000084 열재단 | 1 | **HUMAN-APPROVAL (채번)** | `[CONFIRM-CHANNEL]` 후니 채번 | 채번·등록 |
| 마스터 | 레이저커팅 proc | 1 | **HUMAN-APPROVAL** | 코드행 승인 | 등록 |
| 마스터 | 디자인캘린더 5 신규상품 | 5상품(+18연결) | **HUMAN-APPROVAL** | prd_cd 부여·출시 승인 | 등록 |
| (참고) | grade_discount_rates | 0 | **EMPTY-BY-DESIGN** | 등급할인 미사용 | — |
| (참고·정정) | PRC_COMPONENT_TYPE.06 | — | **이미 적재됨(stale 차단)** | round-4 "제안"은 라이브 실재 | 차단 목록 제외 |
| (참고·정정) | 별색 PROC_008 on 122 | — | **이미 적재됨(stale 차단)** | HANDOFF "선적재 필요"는 stale | 차단 목록 제외 |

---

## 7. 왜 아직 미적재인가 — 시스템적 이유 (executive)

1. **standing 하네스 규칙 = DB 쓰기는 인간 승인.** L2 옵션 레이어·코드행·DDL·잔존 가격은 설계·검증(GO)까지만 산출하고 실제 INSERT/COMMIT은 보류 — 이것이 미적재의 1차 시스템 원인이다. **매핑/설계가 막힌 게 아니다.**
2. **GO분은 이미 적재되어 있다.** L1 차원(sizes/materials/processes/plate 등)·할인(round-1)·가격 엔진 3,481행(area/fixed + 디지털/ENV/GP)은 실제 COMMIT 완료. "DB 미적재 원칙"은 이미 **"GO분 적재됨, 차단/결정분만 미적재"**로 갱신됨(CLAUDE.md §7).
3. **컨피규레이터 §0 설계 경계가 가격 트랙과 옵션 레이어를 별개 미적재 트랙으로 가른다.** 가격(t_prc_*/product_prices)은 "범위 밖" 가격엔진 사안, 옵션 레이어(L2)는 컨피규레이터 사안 — 둘의 미적재 사유와 권위가 다르다(가격=DATA-GAP/plate/모델링 / L2=승인/DEP/DDL-GAP). 혼동 금지.
4. **가장 큰 미해결은 가격 측 DATA-GAP이다(승인 문제가 아님):** 굿즈·문구·책자 **211 상품이 공식·직접단가 어느 쪽도 없다.** round-2~5가 공식형/면적형/고정가형 64상품에 집중했고 `(가격포함)` 직접단가 패밀리는 가격 트랙이 닫지 못했다 — 이건 승인하면 풀리는 게 아니라 **추출·적재본을 새로 만들어야** 한다.
5. **L2 옵션 레이어는 본체(option_items)가 0이다(데이터 소실 아님).** 설계 §1 환원원칙대로 L1 차원은 적재돼 있고 polymorphic 포인터 레이어만 미투입 — 승인 + DEP-선적재 + GAP-PARAM(DDL) 3관문만 통과하면 충실 적재 가능.

---

## 8. 권위반전(live-vs-doc contradiction) — 명시

| # | 문서/스냅샷 주장 | 라이브 실측(권위) | 처리 |
|---|----------------|-----------------|------|
| 1 | (정정) 세션 시작 스냅샷 "options=0" | 작업 중 라이브 **options=2** | **권위반전 아님** — 스냅샷은 당시 정확. 2행은 사용자 관리자 UI 테스트가 세션 중(19:43) 동시 생성(사용자 확인·보존). dbm-validator는 read-only 준수(무결). 동시쓰기 아티팩트로 분류 |
| 2 | HANDOFF "별색 PROC_008(122) 선적재 필요" | **PRD_122에 PROC_008 이미 적재(1행)** | 차단 목록에서 제외 |
| 3 | round-4 "PRC_COMPONENT_TYPE.06 코드선적재 제안" | **.06 완제품비 이미 적재** | 차단 목록에서 제외 |
| 4 | schema-overview(과거) "t_prc_*=0" | component_prices=3,481 등 적재 | (기지) 스냅샷 stale |

> 본 4건은 "loaded=라이브 행 실재" 원칙으로만 적발됨 — stale 문서를 차단 근거로 쓰면 over-block 발생. 등록/존재 판정은 항상 라이브 권위.

---

## 9. GO / NO-GO (미적재 해소 관점)

본 원장은 적재본 게이트가 아니라 **미적재 상태 진단**이므로 verdict는 "다음 행동 우선순위"로 제시한다(아래 §10 TOP3). 데이터 무결성 측면 결함 0(라이브 적재분 검증 통과 이력) — 미적재는 결함이 아니라 **승인/추출/결정 대기**다.
