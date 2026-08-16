# D2 — 가격엔진(pricing.py / price_views.py) 구조 진단

> 대상: `raw/webadmin/webadmin/catalog/pricing.py`(1,003줄) · `raw/webadmin/webadmin/catalog/price_views.py`(3,099줄)
> 관점: 월드모델(world model) 4분류 — 뉴로 / 심볼릭 / 지식·온톨로지 / 행동→결과 예측
> [HARD] 읽기 전용 진단. raw/webadmin 무수정.
> 선행 산출물(`_workspace/huni-price-engine-design/HANDOFF.md`, `huni-price-engine-diag/CHANGELOG.md`)은 HANDOFF만 읽고 중복 회피 — 상품군별 공식 설계·게이트 판정은 재기술하지 않고, 본 문서는 **엔진 코드 자체의 구조·계약·설명능력**만 다룬다.

---

## 요약

후니 가격엔진은 **완전 결정론적 심볼릭 계산기**다. `evaluate_price`(pricing.py:428)는 순수 함수에 가깝고(요청/응답 객체 비의존, pricing.py:4), 금액 상수를 코드에 단 하나도 갖지 않으며(실측: pricing.py 전체에 금액 리터럴 0건), 모든 값·구조를 DB에서 읽는다. 계산 규칙(단가형/합가형/고정가·판수환산·할인·반올림)은 파이썬 60여 줄에 압축돼 있고, 기하 계산(판걸이수·최효율 판형)만 PostgreSQL 함수로 밀려 있다.

핵심 진단 세 가지:

1. **규칙의 위치가 3층으로 갈라져 있고, 그 경계가 코드 상수에 못 박혀 있다.** 차원 축 목록(`NON_QTY_DIMS`, pricing.py:45-46)은 매칭 의미론인 동시에 SQL SELECT 컬럼 목록이라(pricing.py:42-44 주석이 명시), 차원 하나를 늘리려면 DDL → 코드 배포 순서가 고정된다.
2. **엔진은 "얼마"는 완벽히 설명하지만 "왜 그 행이었는가"는 버린다.** 선택된 티어 임계값(`selected` dict, pricing.py:162-183)은 반환되지 않고, 탈락 후보·경쟁 행은 어디에도 실리지 않는다. 매칭 실패 사유는 구조화 코드(pricing.py:62-67)가 있으나, 최상위 `warnings`/`errors`는 한국어 문자열로 평탄화된다(pricing.py:638-649, 824-834).
3. **월드모델(행동→결과 예측)로서는 절반만 존재한다.** "이 선택이면 얼마"는 예측하지만, "이 주문이 생산 가능한가·왜 불가능한가"의 예측은 제약엔진(price_views.py:2701)이 별도로, 다른 데이터(JSONLogic)로, 다른 시점에 계산한다. 두 예측이 하나의 상태공간 위에서 결합되지 않는다.

---

## 실측 사실

### A. 계약(입력→출력)

| 사실 | 근거 |
|---|---|
| 단일 권위 진입점은 `evaluate_price(target, selections, qty, grade_cd, mode, as_of, only_comps, proc_sels, skip_plate)` | pricing.py:428-429 |
| 순수 모듈 선언 — 요청/응답 객체 비의존, Phase 13(위젯 API)·Phase 15(주문 재검증)가 동일 함수 재사용 | pricing.py:4-5 |
| 가격 우선순위: 템플릿단가 → 상품 직접단가 → 상품공식 → 없음 | pricing.py:13-14, 구현 pricing.py:468-514 |
| 공식 = 구성요소 합산. 호출자는 구성요소 목록을 넘기지 않고, 선택값↔차원 자동매칭으로 포함됨 | pricing.py:15-16, 구현 pricing.py:695-756 |
| 차원 컬럼이 NULL이면 와일드카드(무관) | pricing.py:16, 구현 `_row_matches` pricing.py:97-109 |
| 동시매칭(비수량 차원조합 2개 이상) = 데이터 오류로 취급, 흡수하지 않음 | pricing.py:24-25, 구현 pricing.py:151-157 |
| 세트(하이브리드)는 별도 진입점 `evaluate_set_price(set_prd_cd, members, set_selections, copies, …)` | pricing.py:889-890 |
| 세트 구성원 수량은 **엔진이 아니라 호출자가 산출해 주입** (fn_calc_pansu가 DB 함수라 뷰 레이어 계산) | pricing.py:860-862 |
| 할인은 구성원 단위가 아니라 합산 후 셋트 기준 1회 | pricing.py:863, 구현 pricing.py:979-990 |

### B. 계산 규칙(파이썬에 사는 것)

| 규칙 | 값 | 근거 |
|---|---|---|
| 비수량 차원 축(정확값 매칭) | 9개: `siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, spot_side_cnt, bdl_qty` | pricing.py:45-46 |
| 구간(티어) 차원 | 3개: `siz_width, siz_height, min_qty` | pricing.py:52 |
| 티어 방향이 둘로 갈림 — 사이즈는 '이하' 상한(NULL=∞ catch-all), 수량은 '이상' 하한(NULL=0) | pricing.py:48-53, 구현 pricing.py:167-181 |
| 단가형(PRICE_TYPE.01) = 장당가 × 수량 | pricing.py:55, 215 |
| 합가형(PRICE_TYPE.02) = 구간 총액 ÷ 구간 min_qty × 수량 | pricing.py:56, 209-213 |
| 고정금액(PRICE_TYPE.03) = 구간 금액 그대로, 수량 무관 | pricing.py:57, 206-207 |
| 판수 환산 = `⌈주문수량 ÷ 판걸이수⌉`, **나눗셈 경로만 존재**(곱셈 없음) | pricing.py:218-232 |
| 시계열 = 차원조합별 apply_ymd ≤ as_of 중 최신, 동일 apply_ymd 2건이면 `ERR_DUPLICATE` | pricing.py:188-192 |
| 할인 순서 = 수량구간 할인 → 등급 할인, 순차 곱 | pricing.py:28, 구현 pricing.py:545-553 |
| 금액 = 중간 Decimal 유지, 최종만 원 단위 ROUND_HALF_UP | pricing.py:29, 82-84 |
| 모드 2종 — `lenient`(0원 스킵+경고) / `strict`(계산불가 차단) | pricing.py:30-31 |
| strict 차단 대상 치명오류 6종 = 합산 누락(언더차지) 방지 | pricing.py:62-71 |
| **금액 상수 코드 하드코딩 0건** — 코드의 숫자 리터럴은 정률 할인 분모 `100`(pricing.py:249)뿐 | 실측: `grep -E '[^A-Za-z_0-9."]([0-9]{2,})' pricing.py` → 주석/독스트링 외 히트 0 |
| 코드값 문자열 하드코딩은 5건뿐(PRICE_TYPE 3 + DSC_TYPE 2) | pricing.py:55-59 (실측 `grep -c '"[A-Z_]\+\.[0-9]\{2\}"'` = 5) |

### C. SQL 함수에 사는 것

| 함수 | 역할 | 근거 |
|---|---|---|
| `fn_calc_pansu(판형, 아이템)` | 판걸이수. **① 권위 테이블 `t_siz_pansu` 조회 우선 → ② 없으면 기하 계산 폴백(정/회전 배치 중 큰 값)** | 호출 pricing.py:308 · 정의 `raw/webadmin/sql/32_fn_calc_pansu.sql` · 라이브 정의 백업 `sql/_backup_fn_calc_pansu_t_siz_pansu_20260701.json:3` |
| `fn_best_plate(상품, 아이템, 범위)` | 최효율 판형 추천. 정렬키 = 1장당 판면적 최소 → 판걸이수↑ → 판형↓ | `sql/33_fn_best_plate.sql:25-56` |
| `fn_best_plate_default(…)` | 위와 동일하되 `dflt_plt_yn='Y'` 후보 한정 | 호출 price_views.py:2200 · `sql/37_fn_best_plate_default.sql:22` |
| 세 함수 모두 예외 시 `None` degrade(시뮬레이터 500 방지) | pricing.py:309-311 · price_views.py:2167-2168, 2184-2185, 2202-2203 |
| pricing.py의 raw SQL은 **단 1줄**(fn_calc_pansu 호출) | 실측 `grep -n "cur.execute" pricing.py` → 308 단 1건 |

### D. DB 데이터에 사는 것 (pricing.py가 읽는 모델 15종)

실측 `grep -o "M\.T[A-Za-z]*" pricing.py | sort | uniq -c`:

`TPrdProducts`(2) · `TPrdProductCategories`(2) · `TSizSizes` · `TProcProcesses` · `TPrdTemplates` · `TPrdTemplatePrices` · `TPrdProductPrices` · `TPrdProductPriceFormulas` · `TPrdProductDiscountTables` · `TPrcPriceFormulas` · `TPrcFormulaComponents` · `TPrcComponentPrices` · `TDscGradeDiscountRates` · `TDscDiscountTables` · `TDscDiscountDetails`

이 중 가격 결정 자체를 지배하는 데이터 항목:

| 데이터 | 무엇을 지배하는가 | 근거 |
|---|---|---|
| `t_prc_price_components.use_dims` (JSON 배열) | 그 구성요소가 어떤 차원으로 단가를 조회할지 = **매칭 축 자체** | pricing.py:697-698, 714 |
| `t_prc_price_components.prc_typ_cd` | 단가형/합가형/고정가 산술 분기 | pricing.py:621, 664 |
| `t_prc_formula_components` (frm_cd → comp_cd, disp_seq) | 공식이 무엇을 합산하는가 = **구조** | pricing.py:695-698 |
| `t_prc_component_prices` 행 (차원조합 × 구간 × apply_ymd → unit_price) | **모든 금액** | pricing.py:291-293 |
| `t_prc_component_prices.dim_vals` (JSONB) | 공정 상세 파라미터 — 와일드카드 없는 정확매칭 | pricing.py:99, 106-108 |
| `t_proc_processes.prcs_dtl_opt.inputs[].price_dim/contrib` | 공정 상세값 → 가격차원 파생 규칙(`count_y`/`sum`/`passthrough`). **엔진은 코팅·별색 도메인을 모른 채 데이터 선언대로 따름** | pricing.py:373-399 (특히 375-379) |
| `t_dsc_discount_tables.dsc_typ_cd` + details | 정률/정액 및 구간 | pricing.py:768-778 |
| `t_prd_product_plate_sizes.dflt_plt_yn / item_siz_cd` | 판형 자동선택 5상태 분기의 입력 | price_views.py:2241-2284 |
| `t_prd_product_constraints.logic` (JSONLogic) | 선택 가능/불가 (가격 아님) | price_views.py:2519-2532 |

### E. 뷰 레이어(price_views.py)가 실제로 지고 있는 가격 책임

price_views.py는 "화면"이 아니라 **엔진의 전처리 계층**이다. 다음은 전부 가격 결과를 바꾸는 로직이다:

| 책임 | 근거 |
|---|---|
| 판형(plt_siz_cd) 자동 도출 — 사용자에게 묻지 않고 완제품 사이즈로 내부 결정 | price_views.py:2798-2806 |
| 판형 자동선택 5상태 분기(`no_plates`/`single`/`one_default`/`multi_default`/`auto_no_default`/`no_default`) + 사이즈별 판형 오버라이드 | price_views.py:2223-2284 |
| 인쇄옵션 → 면수(단면1/양면2) 판정 = `back_colrcnt_cd.chnl_cnt > 0` | price_views.py:2207-2220 |
| 세트 내지 총매수 파생 `copies × ⌈pages/(pansu×sides)⌉` | pricing.py:865-886 호출, 입력 조립 price_views.py:2962-2995 |
| 공식 없는 구성원은 `derived` → `manual` 강등 | price_views.py:2959-2960 |
| 수량규칙(min/max/incr) 해석 — 사이즈 묶음 우선, 필드 섞지 않음 | price_views.py:1567-1592 |
| 수량규칙 위반 방어선(위젯 우회 직접 호출 대비) | price_views.py:1615-1630 |
| 추가상품(끼워팔기) — 항목별 별도 `evaluate_price` 호출 후 합산 | price_views.py:2848-2874 |
| 건수(case_cnt) 곱셈은 `final_price`가 아니라 `grand_total`에만 반영 | price_views.py:2875-2879 |
| 제약 cascade — 각 차원 후보값을 대입해 JSONLogic 평가, 불가값 맵 산출 | price_views.py:2701-2735 |
| 부분선택 오탐 방지 — 규칙이 참조하는 다른 차원이 **전부 선택됐을 때만**(governed) 판정 | price_views.py:2727-2729 |

### F. 코드 규모 실측

| 파일 | 총줄 | 공백 | 주석 | 독스트링 | 실코드 |
|---|---:|---:|---:|---:|---:|
| pricing.py | 1,003 | 129 | 73 | ~171 | ~630 |
| price_views.py | 3,099 | 300 | 280 | ~368 | ~2,151 |

(측정: `tokenize` 기반 스크립트, 문장 시작 위치의 STRING 토큰을 독스트링으로 집계)

주목할 비율: pricing.py는 실코드 630줄 중 **주석+독스트링이 244줄(24%)** — 규칙의 근거·금지사항·회귀 이력이 코드 옆에 서술로 박혀 있다. 이는 (d)에서 다룰 "설명이 인간용 산문으로만 존재한다"의 첫 증거다.

---

## 구조 해설

### (a) 입력 → 출력 계약, 단계별

```
[입력] target{prd_cd|tmpl_cd} · selections{차원:값} · qty · grade_cd · mode · as_of · proc_sels · only_comps
   │
S0 사이즈 환원   siz_cd → cut_width/cut_height 를 siz_width/siz_height 로 주입
                 단, 직접입력 치수가 하나라도 있으면 덮지 않음(자유치수 보존)   [pricing.py:315-344]
   │
S1 타깃 해석     tmpl_cd 있으면 템플릿단가 → 없으면 base_prd_cd 로 강등
                 prd_cd 면 ① 상품 직접단가 → ② 상품 공식                        [pricing.py:468-514]
   │            (직접단가가 공식보다 우선 = 오버라이드)                          [pricing.py:14]
   │
S2 공식 평가     _evaluate_formula                                              [pricing.py:677]
   │  S2-1 공정 상세값 → 가격차원 파생(전역 setdefault)                          [pricing.py:691-693]
   │  S2-2 공식의 구성요소 목록 조회(disp_seq 순)                                 [pricing.py:695-698]
   │  S2-3 전 구성요소 단가행 1쿼리 벌크 조회(N+1 제거)                           [pricing.py:700]
   │  S2-4 판걸이수 1회 계산: fn_calc_pansu(plt_siz_cd, siz_cd)                   [pricing.py:705-710]
   │  S2-5 구성요소별 루프:
   │        · 판형기준(use_dims ∋ plt_siz_cd)이면 comp_qty = ⌈qty/판걸이수⌉      [pricing.py:719-732]
   │          판수 산출 불가 → ERR_NO_PLATE 로 표면화(조용히 빼면 언더차지)
   │        · 공정차원(use_dims ∋ proc_cd) + proc_sels 있으면 **공정마다 개별 평가·합산**
   │          sel 별 파생차원 오버레이(별색 누적 방지)                            [pricing.py:734-750]
   │        · 그 외 단일 평가                                                    [pricing.py:751-755]
   │
S3 행 매칭       match_component                                                [pricing.py:137]
   │  ① apply_ymd ≤ as_of + 비수량 차원 매칭(NULL=와일드카드)로 후보 필터        [pricing.py:146-147]
   │  ② 비수량 차원조합 그룹핑 → 2개 이상 = ERR_AMBIGUOUS(흡수 금지)             [pricing.py:151-157]
   │  ③ 티어 축별 임계 선택 — 사이즈=이하 최소, 수량=이하 최대                    [pricing.py:162-181]
   │     사이즈 초과 → ERR_ABOVE_MAX / 수량 미달 → ERR_BELOW_MIN
   │  ④ 티어 교차 행 없음 → no_tier_row(데이터 갭) → ERR_NO_TIER_ROW 로 승격      [pricing.py:184-187, 645-650]
   │  ⑤ 동일 (조합·구간) 내 최신 apply_ymd, 동률 2건 → ERR_DUPLICATE             [pricing.py:188-192]
   │
S4 소계 산출     prc_typ 별 분기 → (subtotal, per_item)                          [pricing.py:196-215]
   │
S5 합산          included=True 인 구성요소만 합산 = base_amount                  [pricing.py:532-538]
   │             strict 모드면 치명오류 있는 구성요소를 errors 로 승격            [pricing.py:527-530]
   │
S6 할인          수량구간 할인 → 등급 할인(주카테고리 기준), 순차                 [pricing.py:545-553]
   │
S7 반올림        round_won(ROUND_HALF_UP) → final_price                          [pricing.py:555]
   │
[출력] {ok, target, qty, as_of, mode,
        base{source, formula{frm_cd,frm_nm}, amount, components[], warnings[]},
        discounts[], final_price, warnings[], errors[]}                          [pricing.py:561-582]
```

세트 경로는 위를 재귀적으로 감싼다: 구성원마다 `evaluate_price`(할인 미적용) → 합산 → 세트 자기 공식(제본/조립, qty=부수) → 합산 → **합계 후 세트 기준 할인 1회** (pricing.py:928-990).

`components[]` 항목 하나의 형태(pricing.py:625-631, 667-673):

```
{comp_cd, comp_nm, disp_seq, prc_typ, use_dims[], included,
 matched_row{comp_price_id, apply_ymd, unit_price, min_qty, siz_width, siz_height, …9개 비수량차원},
 tier_min_qty, per_item, subtotal, comp_qty, pansu?, qty_order?,
 error, calc_error, note, data_gap[{dim,value}]}
```

### (b) 규칙이 어디에 사는가 — 실측 배분

측정 방법을 먼저 못 박는다. "규칙"을 **가격 1건을 결정하는 데 참여하는 결정점(decision point)** 으로 정의하고, 각 결정점이 물리적으로 어디에 저장돼 있는지(변경하려면 무엇을 건드려야 하는지)로 분류했다. 백분율은 결정점 개수 비율이며, 결정점 정의가 다르면 값도 달라진다 — 방법 의존적 수치임을 명시한다.

| # | 결정점 | 저장 위치 | 변경 시 건드리는 것 |
|---|---|---|---|
| 1 | 어떤 상품이 어떤 공식을 쓰는가 | **DB** `t_prd_product_price_formulas` | 데이터 |
| 2 | 공식이 무엇을 합산하는가 | **DB** `t_prc_formula_components` | 데이터 |
| 3 | 구성요소가 어떤 축으로 단가를 찾는가 | **DB** `t_prc_price_components.use_dims` | 데이터 |
| 4 | 구성요소가 단가형/합가형/고정가 중 무엇인가 | **DB** `.prc_typ_cd` | 데이터 |
| 5 | 실제 금액 | **DB** `t_prc_component_prices.unit_price` | 데이터 |
| 6 | 차원조합·구간·적용일 격자 | **DB** 같은 표의 차원 컬럼 | 데이터 |
| 7 | 공정 상세값 → 가격차원 파생 규칙 | **DB** `t_proc_processes.prcs_dtl_opt.inputs[].price_dim/contrib` | 데이터 |
| 8 | 할인 유형·구간·율 | **DB** `t_dsc_*` | 데이터 |
| 9 | 판걸이수(권위값) | **DB** `t_siz_pansu` | 데이터 |
| 10 | 판형 후보·기본판형 지정 | **DB** `t_prd_product_plate_sizes` | 데이터 |
| 11 | 선택 가능/불가 규칙 | **DB** `t_prd_product_constraints.logic` (JSONLogic) | 데이터 |
| 12 | 수량 min/max/incr | **DB** `t_prd_products` + `t_prd_product_sizes` | 데이터 |
| 13 | 차원 축이 무엇무엇 존재하는가 (9+3) | **Python** pricing.py:45-53 | 코드(+DDL) |
| 14 | NULL=와일드카드 의미론 | **Python** pricing.py:97-109 | 코드 |
| 15 | 동시매칭=오류 정책 | **Python** pricing.py:151-157 | 코드 |
| 16 | 티어 방향(이상/이하) 규칙 | **Python** pricing.py:48-53, 167-181 | 코드 |
| 17 | prc_typ 별 산술 | **Python** pricing.py:196-215 | 코드 |
| 18 | 판수 환산 = 나눗셈 올림 | **Python** pricing.py:218-232 | 코드 |
| 19 | 가격소스 우선순위 | **Python** pricing.py:468-514 | 코드 |
| 20 | 할인 순서·음수 클램프 | **Python** pricing.py:235-252, 545-553 | 코드 |
| 21 | 반올림 정책 | **Python** pricing.py:82-84 | 코드 |
| 22 | 세트 = 구성원합 + 세트공식, 할인 1회 | **Python** pricing.py:928-990 | 코드 |
| 23 | 판형 자동선택 5상태 분기 | **Python** price_views.py:2223-2284 | 코드 |
| 24 | 면수(단면/양면) 판정 | **Python** price_views.py:2207-2220 | 코드 |
| 25 | 내지 총매수 공식 | **Python** pricing.py:865-886 | 코드 |
| 26 | 판걸이수 기하 폴백 계산 | **SQL** `fn_calc_pansu` | SQL 함수 |
| 27 | 최효율 판형 선정 기준(1장당 판면적 최소) | **SQL** `fn_best_plate` | SQL 함수 |
| 28 | 기본판형 한정 추천 | **SQL** `fn_best_plate_default` | SQL 함수 |

**배분: DB 데이터 12/28 ≈ 43% · 파이썬 코드 13/28 ≈ 46% · SQL 함수 3/28 ≈ 11%.**

그러나 이 숫자는 "가짓수"이고, **부피(volume)로 보면 완전히 다르다**. 결정점 5·6(금액과 격자)은 단일 항목이지만 실제 데이터는 수천 행이다. 그래서 두 번째 측도를 같이 제시한다:

- **값(金額) 층: DB 100%.** pricing.py에 금액 리터럴 0건(실측). 코드에 남은 숫자는 정률 분모 `100`(pricing.py:249)뿐.
- **구조(무엇을 합산할지) 층: DB 100%.** 공식·구성요소·바인딩 모두 테이블.
- **의미론(어떻게 고르고 어떻게 곱할지) 층: 파이썬 ~100%.** 12개 차원 축 이름, 티어 방향, 산술, 우선순위, 할인 순서, 반올림 전부 코드 상수·분기.
- **기하 층: SQL 100%.** 판걸이수·판형 효율.

즉 **"규칙의 밀도는 데이터에, 규칙의 문법은 코드에, 규칙의 물리는 SQL에"** 있다. 이 3층 분리는 의도된 설계고(pricing.py:1-32 독스트링이 그대로 선언), 실제로 잘 지켜지고 있다.

### (c) 심볼릭 관점에서 이미 잘 하고 있는 것

1. **완전 결정론.** 같은 입력에 항상 같은 출력. 비결정성이 새어 들어올 수 있는 유일한 지점(동일 apply_ymd 2건에서 DB 반환순 의존)을 인지하고 **행 내용 기반 안정 tie-break**로 막았다 — pricing.py:272-281 (`tuple(sorted((str(k), str(v)) for k, v in r.items()))`). 이건 결정론에 대한 의식적 방어다.
2. **부동소수 배제.** 전 구간 `Decimal`, 최종만 ROUND_HALF_UP (pricing.py:29, 82-84). 합가형 나눗셈도 Decimal(pricing.py:212).
3. **모호성을 흡수하지 않고 오류로 승격.** 동시매칭 시 "아무거나 하나 고르기"를 명시적으로 거부(pricing.py:24-25). 심볼릭 시스템에서 가장 중요한 성질 — 규칙이 불완전하면 **답을 내지 않는다**.
4. **조용한 누락을 금지.** 판수 환산 불가·티어 행 없음처럼 "그냥 빼면 계산이 되는" 경우를 전부 오류 코드로 표면화한다. 근거 주석이 명시적: "조용히 빼면 언더차지"(pricing.py:645-649, 727), "합산 누락 = 언더차지 위험"(pricing.py:69). `_FATAL_ERRORS` 6종은 strict에서 차단(pricing.py:70-71).
5. **2모드 인식론.** `lenient`는 "데이터 구멍 발견 목적"(pricing.py:30) — 진단 모드와 집행 모드를 분리했다. 이건 심볼릭 KB의 완전성 검사와 추론을 분리한 것과 같은 구조다.
6. **엔진의 도메인 무지(data-driven).** "엔진은 코팅 등 도메인을 모른다(데이터 드리븐)"(pricing.py:375-376). 코팅면수·별색면수 같은 도메인 개념이 코드에 없고, 마스터의 `price_dim`/`contrib` 선언을 따른다. 새 도메인 축을 **데이터만으로** 추가할 수 있는 유일한 통로다.
7. **부분선택 오탐 방지(governed 판정).** 제약 평가에서 규칙이 참조하는 다른 차원이 전부 채워졌을 때만 판정(price_views.py:2727-2729). 미완성 상태를 "위반"으로 오판하지 않는 3-value 논리에 가깝다.
8. **회귀 사유가 코드 옆에 박제.** "왜 이렇게 했는가"의 근거가 주석에 사건 ID(260805-rob, D-07, T-rob-01 등)와 함께 남아 있다(pricing.py:402-416, 741-744). 심볼릭 규칙의 provenance를 인간이 읽을 수 있게 유지한 것.

### (d) 이 엔진이 '설명'을 못 하는 지점

**결론: 숫자만 내보내지는 않는다. 상당히 구조화된 내역을 내보낸다. 그러나 "왜 이 값인가"의 핵심 연결고리 3개가 구조에서 빠진다.**

내보내는 것(구조화됨):
- 어떤 공식을 썼는가 — `base.formula{frm_cd, frm_nm}` (pricing.py:509-510)
- 어떤 구성요소가 얼마씩 기여했는가 — `components[].subtotal/per_item` (pricing.py:667-673)
- 어떤 단가행이 매칭됐는가 — `matched_row` 전체(차원값·apply_ymd·unit_price·comp_price_id 포함, pricing.py:669-671)
- 판형기준 구성요소의 판수·주문수량 — `pansu`, `qty_order`, `comp_qty` (pricing.py:629, 748)
- 왜 매칭 실패했는가(부분적) — `data_gap[{dim, value}]` (pricing.py:599-614, 654-658)
- 할인 단계별 before/after/discount + 적용 구간 (pricing.py:779-786)
- 뷰 레이어가 코드에 사람 읽는 이름을 부착 — `matched_names` (price_views.py:2438-2442)

빠지는 것:

1. **티어 선택 근거가 반환되지 않는다.** `match_component`는 축별로 선택된 임계값을 `selected` dict에 담지만(pricing.py:162-183), 반환하는 건 `{"row", "tier_min_qty", "error"}`뿐(pricing.py:193). `siz_width`/`siz_height`로 어느 구간이 선택됐는지는 `matched_row` 안의 값으로 역추론해야 하고, **"주문값 210이 어떤 임계 250 구간에 들어갔다"는 관계 자체는 소실**된다.
2. **탈락 후보가 어디에도 없다.** 후보 `cand`(pricing.py:146), 그룹 `grp`(pricing.py:159), 티어 후보 `tiers`(pricing.py:167)는 전부 지역변수다. 오류일 때만 `rows`/`combos`를 실어 보내고(pricing.py:156-157, 172-180, 192), **정상 매칭 시 "왜 이 행이고 저 행이 아니었는가"는 반환되지 않는다**. 대조군(counterfactual)이 없으므로 "다른 자재를 골랐으면 얼마"를 답하려면 엔진을 다시 호출해야 한다.
3. **최상위 경고·오류가 한국어 산문으로 평탄화된다.** 구성요소 단위로는 `error` 코드(pricing.py:62-67)가 살아 있지만, `warnings[]`는 f-string 문장(pricing.py:638-649)이고 `errors[]`는 `_fatal_reason`이 코드→문장으로 바꾼 결과(pricing.py:824-834)다. **API 소비자가 프로그램적으로 분기하려면 문자열을 파싱해야 한다.** 세트 경로에서는 여기에 `[{label}] ` 접두까지 붙어(pricing.py:955, 969) 이중 평탄화된다.
4. **권위 출처(provenance)가 없다.** `matched_row.comp_price_id`는 DB 행 ID일 뿐, 그 값이 어느 권위 엑셀 어느 시트 어느 셀에서 왔는지는 엔진 응답에 없다. "이 가격이 맞는가"를 확인하려면 엔진 밖 하네스 산출물을 뒤져야 한다.
5. **판형 자동선택의 진단은 엔진이 아니라 뷰가 만들고, 단일상품 경로에서는 버려진다.** `_select_default_plate`는 `(plate, status, diag)` 3튜플로 사람이 읽는 사유를 만들지만(price_views.py:2258-2284), 단일상품 시뮬 경로는 `best`만 취하고 `_ps, _pd`를 버린다(price_views.py:2804). 세트 경로만 `breakdown`에 실어 보존한다(price_views.py:2991-2995). **같은 근거가 경로에 따라 있다가 없다.**
6. **설명의 상당량이 소스 주석에만 존재한다.** 실측 F절 — pricing.py 244줄(24%)이 주석·독스트링이고, 여기에 "왜 이 규칙인가"·"무엇을 하면 안 되는가"·회귀 사건 ID가 들어 있다. 이 지식은 **런타임에 접근 불가능하고, 기계가 읽을 수 없으며, 코드를 읽는 인간에게만 전달된다.**

한 줄 판정: **엔진은 "계산 내역(what)"은 잘 내보내고, "선택 근거(why-this)"와 "대안 대조(why-not-that)"는 내보내지 않는다.**

### (e) 조합·차원(use_dims)이 다뤄지는 방식

`use_dims`는 구성요소별 JSON 배열이며 **엔진의 매칭 축을 데이터로 지정하는 유일한 장치**다.

- 파싱: 비수량 축은 `NON_QTY_DIMS` 교집합, 티어 축은 `TIER_DIMS`로 자동 분리 (pricing.py:100, 163).
- **`use_dims`에 없는 축도 행 컬럼이 non-NULL이면 매칭에 참여한다.** `_row_matches`는 `use_dims`를 보지 않고 `NON_QTY_DIMS` 전부를 훑는다(pricing.py:100-105). `use_dims`는 매칭이 아니라 **진단·UI·그리드 컬럼 구성**에 쓰인다(pricing.py:632-635 `non_qty_dims` 판별차원 없음 경고, pricing.py:654 `_no_match_detail`, price_views.py:1022-1028 그리드 컬럼). 이 비대칭은 문서화돼 있지 않고, 데이터가 `use_dims`와 실제 행 컬럼을 어긋나게 채우면 **선언과 실행이 갈린다**.
- 확장 문법 2종: `"opt_grp:XXX"` 접두(pricing.py:633), `":"` 포함 스코프(pricing.py:715) — `split_scopes`/`split_opt_grp`(price_views.py:135-152)가 해석. 즉 `use_dims`는 순수 배열이 아니라 **미니 DSL**이다.
- 조합 판정 키 `_combo_key`는 9개 비수량 축 + `dim_vals` JSON 정규화 문자열(pricing.py:112-114). `dim_vals`는 와일드카드 없음(pricing.py:106-108) — 공정 상세 파라미터는 항상 정확매칭.
- 차원 값 정규화 `_norm`은 **전부 문자열로 통일**(pricing.py:87-89). 코드/정수 혼재를 흡수하는 대신, `bdl_qty=10`과 `"10"`이 같아지고 `"010"`은 달라진다.
- 차원 파생 3경로:
  - `siz_cd` → `siz_width/siz_height` 환원 (pricing.py:315-344) — 단 직접입력 치수가 있으면 보존.
  - `proc_sels` 상세값 → 가격차원 (pricing.py:373-399), 전역 setdefault (pricing.py:691-693).
  - sel 별 재파생 오버레이 (pricing.py:402-422) — 별색처럼 다중 선택 도메인에서 전역 집계가 축을 가로질러 누적되는 언더차지 버그를 막는 장치. 우선순위: 호출자 명시 > sel 별 파생 > 전역 파생.
  - `plt_siz_cd`는 **사용자 선택이 아니라 내부 도출** (price_views.py:2798-2806, 53-56).
- 조합 폭발 대응: 구성요소별 개별 조회를 1쿼리 벌크로 접었다(pricing.py:284-295, 700). 단 `_component_rows_bulk`는 comp_cd 전체 행을 메모리로 끌어온 뒤 파이썬에서 필터한다 — **차원 필터가 SQL에 내려가지 않는다.**
- 공정 다중선택은 **구성요소를 공정 개수만큼 반복 평가해 합산**(pricing.py:734-750). 즉 조합 차원 하나가 곱셈이 아니라 합산 반복으로 처리된다.

### (f) 확장할 때 깨지기 쉬운 곳

| 위험 | 실측 근거 | 왜 깨지는가 |
|---|---|---|
| **F1. 차원 축 1개 추가 = 코드·DDL 배포 순서 결합** | pricing.py:41-46 (주석이 명시: "이 튜플은 `_component_rows_bulk`의 SELECT 컬럼 목록이기도 해서, 컬럼 없는 DB에서는 엔진 전체가 ProgrammingError로 즉시 실패한다. 배포 순서 고정: sql/72 선적용 → 이 코드 배포") | `NON_QTY_DIMS`가 **의미론이자 SELECT 목록**이라는 이중 역할. 순서 하나 틀리면 전 상품 가격 산출 불능. |
| **F2. 차원 추가 시 동기화해야 할 상수가 최소 6곳** | pricing.py:45(`NON_QTY_DIMS`) · price_views.py:31-45(`DIM_META`/`DIM_ORDER`) · 2434(`_DIM_NAME_GRP`) · 2480(`_SIM_DIM_CONSTRAINT`) · 61(`WIDGET_EXTRA_DIMS`) · 2683-2691(`_sim_dim_candidates`) | 어느 하나 빠뜨려도 예외가 안 난다 — **조용히 기능만 빠진다**(그리드에 안 보임 / 제약 미평가 / 이름 미부착). |
| **F3. NULL 와일드카드 + 동시매칭 오류의 조합 취약성** | pricing.py:98(NULL=와일드카드) + 151-157(2개 이상=오류) | "공통가 NULL행 + 전용가 행 공존"이 곧바로 `ERR_AMBIGUOUS`(pricing.py:25). 새 전용 단가행을 넣는 순간 기존 공통행과 충돌해 **그 구성요소 전체가 합산에서 빠진다**. 데이터 추가가 회귀를 만드는 구조. |
| **F4. 판수 경로에 곱셈이 없다** | pricing.py:218-232 — `-(-order_qty // pansu)` 나눗셈 올림뿐 | 표지 펼침/개별처럼 **출력매수가 주문수량의 배수**인 모델을 판형기준 구성요소로 표현할 수 없다. HANDOFF에 동일 결론(`cover_mult ×2` 실행 트랙 BLOCKED, `pricing.py:680` 지목)이 이미 기록돼 있어 교차 확인된다. |
| **F5. 내지 매수 공식이 두 곳에 중복 구현** | pricing.py:885 `-(-pages // (pansu * sides))` / price_views.py:2990 `-(-pages // (pansu * sides))` | 같은 식이 엔진과 뷰에 각각 존재. 뷰 쪽은 `breakdown.per_book` 표시용이지만, 한쪽만 고치면 **표시값과 계산값이 갈린다**. |
| **F6. `use_dims` 선언과 실제 매칭 축의 비대칭** | `_row_matches`(pricing.py:100)는 `use_dims` 무시, `_no_match_detail`(pricing.py:605-606)은 `use_dims` 기준 | `use_dims`에 없는 축을 행에 채우면 **매칭엔 영향, 진단엔 미표시**. 데이터 담당자가 원인을 못 찾는 종류의 결함. |
| **F7. 판별차원 0인 구성요소는 항상 매칭** | pricing.py:632-635 (`"판별차원 없음 — 선택과 무관하게 항상 매칭"`) | `use_dims`가 비었거나 opt_grp만 있으면 그 구성요소는 **모든 주문에 상시 과금**된다. 새 구성요소를 차원 미충전 상태로 배선하는 순간 전 상품 과청구. |
| **F8. lenient가 기본값** | pricing.py:429 `mode="lenient"` · 436 · price_views.py:2824 `mode = "strict" if p.get("mode") == "strict" else "lenient"` | 호출자가 명시하지 않으면 **데이터 구멍이 0원으로 조용히 흡수**된다. 관리자 시뮬레이터·위젯 미리보기가 이 기본값을 탄다. |
| **F9. 세트 구성원 수량 산출이 엔진 밖** | pricing.py:860-862(설계 선언) · price_views.py:2962-3005(구현) | "fn_calc_pansu가 DB 함수라 뷰 레이어에서 계산"이라는 이유로 **수량 결정 로직이 엔진 계약 밖으로 나갔다**. `evaluate_set_price`를 다른 경로에서 부르면(예: 주문 재검증) 같은 수량 산출을 다시 구현해야 한다. |
| **F10. SQL 함수 실패가 조용한 degrade** | pricing.py:309-311 · price_views.py:2167-2168, 2184-2185, 2202-2203 — 전부 `except Exception: return None` | `fn_calc_pansu`가 미배포·오류여도 예외가 안 난다. 결과는 `ERR_NO_PLATE`로 나오지만 **"함수 문제"와 "판형 미선택"이 같은 증상**으로 합쳐진다. |
| **F11. `simulate_set_core`는 무검증 공용 함수** | price_views.py:2911-2916 주석이 직접 경고: "공용 함수다 — 관리자 전용이 아니다. 이 함수는 입력을 검증하지 않는다(공정 화이트리스트·detail 화이트리스트·side 유효성 전부 없음)" | 새 호출자가 `widget_api._prep_set_body` 없이 부르면 검증이 통째로 빠진다. 안전이 **호출 규약(문서)** 으로만 보장된다. |
| **F12. 제약(가능성)과 가격(금액)이 분리 평가** | 제약 price_views.py:2701-2735(JSONLogic) · 가격 pricing.py:428 | 제약을 위반한 조합도 `evaluate_price`는 기꺼이 계산한다. 두 계층을 잇는 것은 프런트/호출자 규약뿐. |

---

## 결함·공백

우선순위는 **금액 오류 위험** 기준.

| ID | 등급 | 결함 | 근거 |
|---|---|---|---|
| D2-1 | High | 판별차원 0 구성요소 상시 과금 경로가 열려 있음(경고만, 차단 없음) | pricing.py:632-635 — note만 달고 `included=True` 진행 |
| D2-2 | High | lenient 기본값이 데이터 구멍을 0원으로 흡수 | pricing.py:429, price_views.py:2824 |
| D2-3 | High | NULL 와일드카드행 + 전용행 공존 시 구성요소 전체 탈락(데이터 추가가 회귀 유발) | pricing.py:25, 151-157 |
| D2-4 | Med | 판수 경로 곱셈 부재로 표현 불가능한 가격 모델 존재 | pricing.py:218-232 (HANDOFF `cover_mult` 트랙과 일치) |
| D2-5 | Med | 차원 추가 시 6개 상수 동기화가 수동이며 실패가 조용함 | F2 표 |
| D2-6 | Med | 내지 매수 공식 2중 구현 | pricing.py:885 / price_views.py:2990 |
| D2-7 | Med | 세트 수량 산출이 엔진 계약 밖(재사용 시 재구현 강제) | pricing.py:860-862 |
| D2-8 | Med | `use_dims` 선언 ≠ 실제 매칭 축 | pricing.py:100 vs 605-606 |
| D2-9 | Low | 최상위 warnings/errors가 문자열 평탄화 — 기계 소비 불가 | pricing.py:638-649, 824-834, 955, 969 |
| D2-10 | Low | 판형 선택 사유(`diag`)가 단일상품 경로에서 폐기 | price_views.py:2804 vs 2991-2995 |
| D2-11 | Low | SQL 함수 실패와 데이터 미선택이 동일 증상으로 붕괴 | pricing.py:309-311 |
| D2-12 | Low | `_component_rows_bulk`가 comp_cd 전 행을 메모리로 끌어옴(차원 필터 미하강) | pricing.py:291-293 |

**공백(엔진에 아예 없는 것)**:
- 가격 결과의 **권위 출처(어느 엑셀 어느 셀)** 링크
- **대안 대조(counterfactual)** — "다른 값이었다면" 응답
- **설명 그래프의 기계 표현** — mermaid는 렌더링 시점에 문자열로 조립되고(price_views.py:987-1007) 재사용 가능한 구조로 남지 않는다
- **제약 × 가격 결합 상태공간** — 두 계층이 각자 평가

---

## 월드모델 관점 판정

4분류에 대한 증거 기반 판정.

### (1) 뉴로 — **0%. 존재하지 않는다.**

증거: pricing.py·price_views.py 전체에 학습·추론·임베딩·확률 요소가 없다. 유일한 "추천"인 판형 선정도 결정론적 정렬 기준(1장당 판면적 최소 → 판걸이수↑ → 판형↓)이다(`sql/33_fn_best_plate.sql:48-51`). 근사·확률·불확실성 표현이 코드 어디에도 없다.

판정: **부재하며, 이 영역에서는 부재가 정답이다.** 돈이 오가는 계산에 뉴로 요소를 넣을 이유가 없다. 뉴로가 있어야 할 자리가 있다면 이 엔진 내부가 아니라 **엔진 바깥의 매핑·진단·설명 생성** 쪽이다.

### (2) 심볼릭 — **강함. 이 엔진의 정체성.**

증거: 명시적 규칙 집합(pricing.py:11-31 독스트링이 그대로 규칙 명세), 결정론 보장(pricing.py:272-281 안정 tie-break), 모호성 거부(pricing.py:151-157), 불완전성 표면화(`_FATAL_ERRORS` pricing.py:70-71), 2모드 인식론(진단/집행, pricing.py:30-31), 정확 산술(Decimal 전 구간).

빠진 심볼릭 요소:
- **증명(proof) / 유도 추적(derivation trace)이 없다.** 결과는 있으나 유도 경로가 재구성 불가 — (d)의 1·2번. 심볼릭 시스템에서 가장 값진 산출물이 버려진다.
- **규칙 무모순성 검사가 런타임 1건 단위**다. 동시매칭은 "계산할 때" 발견되지, 데이터 적재 시점에 사전 검출되지 않는다(pricing.py:151은 계산 경로 안).

판정: **심볼릭 계산기로는 우수. 심볼릭 추론기(설명·증명)로는 미완.**

### (3) 지식 / 온톨로지 — **부분적. 데이터에는 있고 엔진에는 얕다.**

증거로 있는 것:
- 차원 온톨로지가 코드 상수로 존재 — 12개 축(pricing.py:45-53)에 라벨·타입·마스터 FK가 붙어 있다(price_views.py:31-44 `DIM_META`).
- 데이터 드리븐 도메인 확장 통로 — `prcs_dtl_opt.inputs[].price_dim/contrib`(pricing.py:373-399)는 **"엔진은 코팅을 모른다"**(pricing.py:375)를 실현한다. 이건 온톨로지를 데이터로 미는 정석 설계다.
- 반제품 역할 온톨로지 — `SEMI_ROLE.01~04`(내지/표지/면지/간지, price_views.py:2288-2291).
- 상품유형·옵션참조차원 등 코드값 체계가 DB 기초코드에 있음(price_views.py:2480-2486의 `OPT_REF_DIM.01~05` 매핑이 그 증거).

빠진 것:
- **축 사이의 관계가 코드에 없다.** `siz_cd`와 `siz_width/height`의 관계는 함수 하나(`_reduce_siz_dims`)로 하드코딩됐고(pricing.py:315-344), `plt_siz_cd`와 `siz_cd`의 관계는 SQL 함수에 있고, `print_opt_cd`와 면수의 관계는 뷰에 있다(price_views.py:2207-2220). **하나의 온톨로지 그래프가 아니라 흩어진 3개의 특수 규칙**이다.
- **엔진은 자기 축의 의미를 모른다.** `NON_QTY_DIMS`는 이름 문자열 튜플일 뿐, "자재는 물리적 재료이고 공정은 행위"라는 층위 구분이 없다. 그래서 F7(판별차원 0 = 상시 과금)이 구조적으로 막히지 않는다 — 엔진이 "이 구성요소는 자재비인데 자재 축이 없다"를 알 방법이 없다.
- **온톨로지의 상당 부분이 주석에 산다.** 예: 위젯 노출 제외 근거(price_views.py:52-60)는 "plt_siz_cd는 완제품 사이즈에서 내부 도출하는 생산 개념(사용자 선택 대상 아님)"이라는 **명백한 온톨로지 명제**인데, 실행 가능한 형태가 아니라 산문 주석이다.

판정: **온톨로지가 3곳(코드 상수 / DB 코드값 / 주석)에 분산돼 있고, 그중 관계 지식은 대부분 코드와 주석에 갇혀 있다.** 지식 층으로서는 존재하되 통합·질의 불가.

### (4) 월드모델(행동 → 결과 예측) — **절반. 가격축만 예측하고 생산·가능성 축은 예측하지 않는다.**

월드모델의 최소 요건을 "상태 + 행동 → 다음 상태·결과를 예측"으로 두면:

**있는 것:**
- 상태 = `selections{차원:값}` + `qty`. 행동 = 차원 값 하나 바꾸기. 결과 = `final_price` + 구성요소별 기여. → **가격축 예측기는 완전히 작동한다.**
- 시간축도 있다 — `as_of`로 임의 시점 가격 예측 가능(pricing.py:444, 147). 과거·현재 상태를 모두 재현한다.
- what-if 훅 존재 — `only_comps`(pricing.py:438-439)로 구성요소 부분집합만 합산 가능. 다만 주석이 "시뮬레이터 what-if 전용"으로 한정.
- 수량 tier 곡선 예측 — `with_tiers`로 수량 구간별 가격표 산출(price_views.py:2882-2884).
- 가능성 예측도 별도로 존재 — `_sim_disallowed`(price_views.py:2701)는 **각 차원의 각 후보값을 실제로 대입해 평가**한다. 이건 forward simulation 그 자체다.

**없는 것:**
1. **두 예측기가 결합되지 않는다.** 가격 예측(pricing.py)과 가능성 예측(price_views.py:2701)은 서로를 모른다. "이 선택은 불가능하다"와 "이 선택은 173,000원이다"가 하나의 상태 평가로 나오지 않는다. 결과적으로 **불가능한 조합의 가격이 태연히 계산된다**(F12).
2. **결과 예측이 가격 한 축뿐이다.** 납기·생산 가능성·손실률·판 낭비율 같은 다른 결과축이 없다. `fn_best_plate`가 "1장당 판면적"을 계산하지만(`sql/33_fn_best_plate.sql:48`) 그 값은 **선택에만 쓰이고 결과로 반환되지 않는다** — 생산 효율이라는 결과축이 계산되고도 버려진다.
3. **역방향 질의 불가.** "20만원 이하로 만들려면 무엇을 바꿔야 하나"에 답할 구조가 없다. 순방향 평가만 있고 상태공간 탐색이 없다.
4. **대조 예측(counterfactual) 미반환.** (d)-2와 동일 — 대안을 알려면 매번 엔진을 다시 호출해야 하고, 호출 비용이 comp_cd 전 행 조회(pricing.py:291-293)라 탐색이 비싸다.
5. **모델이 자기 불확실성을 표현하지 못한다.** lenient 모드의 0원 결과와 정당한 0원이 출력에서 같은 모양이다(`final_price=0`). 경고 문자열을 파싱해야 구분된다(D2-9).

판정: **가격축에 한정된 결정론적 forward model. 진짜 월드모델(다축 결과 예측 + 가능성 결합 + 역방향 탐색)로 보면 1/4 지점.** 다만 재료는 이미 다 있다 — 상태 표현(`selections`), forward 평가(`evaluate_price`), 가능성 평가(`_sim_disallowed`), 효율 계산(`fn_best_plate` 내부값). **없는 것은 이들을 하나의 상태공간 위에 얹는 층이다.**

### 종합 판정표

| 층 | 판정 | 근거 강도 |
|---|---|---|
| 뉴로 | 부재 (의도적·타당) | 확정 — 전 코드 실측 |
| 심볼릭 | 계산기 우수 / 추론기 미완 | 확정 — pricing.py:11-31, 151-193, 272-281 |
| 지식·온톨로지 | 분산 존재, 통합·질의 불가 | 확정 — pricing.py:45-53 vs 315-344 vs price_views.py:52-60, 2207-2220 |
| 월드모델 | 가격 단일축 forward model (≈1/4) | 확정 — pricing.py:428 계약 + price_views.py:2701 분리 |

[추정] 이 4층 중 후니 사업 관점에서 가장 큰 미실현 가치는 **(3)→(4) 연결**, 즉 흩어진 온톨로지(축 관계·역할·생산 개념)를 하나로 모아 가격·가능성·생산효율을 동시에 예측하는 층이다. 이는 코드 구조에서 도출한 추론이며, 사업 우선순위 자료로 검증되지 않았다.

---

## 미확인

1. **라이브 DB 실측 미수행.** `t_prc_component_prices` 실제 행 수, `use_dims` 실제 분포, 판별차원 0인 구성요소가 실제로 몇 개인지(F7/D2-1의 실제 노출 규모) 확인하지 않았다. 본 문서의 결함은 **코드 구조상 가능한 결함**이며, 실제 데이터에서 발생 중인지는 별도 실측이 필요하다. (`.claude/rules/moai/core/verification-claim-integrity.md` §1.1 surface 3 — 도메인 도구 미실행 상태이므로 가설로 표기)
2. **`widget_api.py` 미읽음.** `_prep_set_body`·`parse_case_cnt`·`_qty_tiers`·`api_price`가 price_views에서 호출되지만(price_views.py:2817, 2883) 해당 파일은 이번 진단 범위 밖. **공개 고객 주문 경로의 검증 강도(fail-closed 여부)는 미확인**이며, F11의 실제 위험도가 여기에 달려 있다.
3. **`views.py` `_var_value` / `VAR_KEY_MAP` 미읽음.** 제약 var 계약의 실제 매핑(price_views.py:2629, 2636)은 확인하지 않았다.
4. **`fn_calc_pansu` 라이브 정의는 백업 JSON으로만 확인.** `sql/_backup_fn_calc_pansu_t_siz_pansu_20260701.json:3`의 스냅샷을 근거로 삼았고, **현재 라이브 DB의 함수 정의가 이와 동일한지는 미검증**.
5. **`sql/72`(spot_side_cnt 컬럼 신설) 배포 여부 미확인.** pricing.py:42-44가 배포 순서 위험을 경고하지만, 실제 라이브에 컬럼이 있는지 확인하지 않았다. **없다면 엔진 전체가 ProgrammingError로 실패한다** — 최우선 확인 항목.
6. **성능 실측 없음.** D2-12(`_component_rows_bulk` 전 행 로드)의 실제 영향은 행 수에 비례하나 측정하지 않았다.
7. **프런트엔드(위젯 렌더러 JS) 미읽음.** 제약 즉시 평가(price_views.py:2739-2741)가 서버와 동일 결과를 내는지는 코드 대조 미수행.
8. 선행 하네스 산출물 중 HANDOFF만 읽었다. `01_formula`~`05_codex` 하위 상세 산출물과 `huni-price-engine-diag/02_code_schema` 결과는 읽지 않았으므로, 본 문서와 **중복 또는 상충하는 기존 판정이 있을 수 있다**.
