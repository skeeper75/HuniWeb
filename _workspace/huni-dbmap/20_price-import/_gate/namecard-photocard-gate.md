# 명함포토카드 import 게이트 (namecard-photocard-gate) — round-16 (B) 독립 검증

> **검증자** dbm-validator (생성자 아님·빌더 의심·직접 실측) · 2026-06-13
> **대상** `_workspace/huni-dbmap/20_price-import/namecard-photocard/`(structure·decomposition·import.xlsx·mapping-flow)
> **권위** 원본 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 시트 `명함포토카드`(openpyxl `data_only`·R1:R134, max_row 1067은 빈 꼬리) + 라이브 `t_prc_*`·`t_mat_materials` information_schema(`.env.local` `RAILWAY_DB_*` 읽기전용·`db railway`·port 45948·host __RAILWAY_DB_HOST__).
> **방법** openpyxl 직접 재카운트 + 라이브 psql 실측. 빌더 주장은 재현하지 않고 원천에서 독립 산출.

---

## 0. 종합 평결: **CONDITIONAL-GO** (빌더 카운트 1건 뒤집힘 + 산출물 결함 2건)

가격표↔라이브 round-trip은 무손실(14/14), 가격사슬 단절 진단(24 고아)도 라이브 실측과 일치하나, **빌더가 줄곧 주장한 "27 구성요소"는 라이브 실측상 28개**(분모 오류)이고, **import.xlsx의 PEARL/WHITE 소재 전개에 정합 결함 2건**이 있다. 그릇·차원·BLOCKED 분리는 정당. 결함 보정 후 GO.

---

## 1. 게이트 P1~P6 판정표

| 게이트 | 판정 | 핵심 근거(라이브/openpyxl 실측) |
|--------|------|------------------------------|
| **P1** 그릇=라이브 컬럼 1:1 | ✅ PASS | `t_prc_price_formulas` 컬럼 = `frm_cd,frm_nm,note,use_yn,reg_dt,upd_dt` — **`frm_typ_cd`·`prd_cd` 부존재 확정**(빌더 주장 일치). 바인딩은 별 테이블 `t_prd_product_price_formulas`(prd_cd,frm_cd,apply_bgn_ymd) 실재. |
| **P2** Phase11 10차원·BLOCKED NULL회귀0 | ✅ PASS | `t_prc_component_prices` 매칭차원 = siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·proc_cd·opt_cd(8) + apply_ymd + unit_price = 10차원. PREMIUM·SHAPE·CLEAR 미확정분을 NULL 강제 적재하지 않고 `4b_BLOCKED` 34행으로 분리 — NULL 회귀 0. |
| **P3** 무손실(카운트) | 🟡 PASS-with-correction | 라이브 단가행 **115 정확**(openpyxl 단가셀 재카운트 115 = `t_prc_component_prices` 명함/포토카드 115 일치). 소재전개 **16 정확**(import `4_component_prices` 131 = 115+16). BLOCKED **34 정확**. round-trip **14/14 일치**(검증 1건 MISS는 검증측 mat 누락 탓·실값 WHITE_S2W_CL mat137·19000 정상). |
| **P4** 단가/합가(prc_typ) | 🟡 CONDITIONAL | 라이브 명함/포토카드 28 comp **전부 PRICE_TYPE.01**(빌더 주장 일치). 빌더가 "명함 본문 .01 vs .02 미정(Q-NC-1)·박/대량 .02 합가형이 정합" 판정 — **원본 거동상 타당**(가격표 전부 "100매/세트/구간 총액" 표기 → 합가형 후보). 단 명함 min_qty=100 고정이라 .01 유지도 가능 → **Q-NC-1 미해소·추정 금지 정당**. CONDITIONAL. |
| **P5** 동시매칭0 + 소재 collapse | 🔴 FAIL(보정필요) | 동시매칭0은 확인(BULK 50구간 min_qty 유니크·PREMIUM 그룹대표 mat=null은 BLOCKED와 별 시트). 로츠쿼츠 오적재(MAT_000130) 적발은 정확. **그러나 import.xlsx가 ① PEARL에 로즈쿼츠(130)와 로츠쿼츠(241)를 둘 다 적재(정정 주장과 모순) ② WHITE NOCL은 5색·CL은 1색 비대칭 전개** = 소재 전개 결함 2건. |
| **P6** 🔴 가격사슬 | ✅ PASS(진단 정확·분모만 정정) | 라이브 `formula_components` 배선 comp = **4개**(STD_S1/S2→PRF_NAMECARD_FIXED, PHOTOCARD_SET/CLEAR_SET→PRF_PHOTOCARD_FIXED). 고아 = **24개**(빌더 일치). 바인딩 = PRD_31/32/33→NAMECARD_FIXED, PRD_24/25→PHOTOCARD_FIXED. **프리미엄(31)/코팅(32) 선택 시 STD 단가 오출 확정**(FIXED에 STD만 배선). PRD_34~40(펄·모양·미니·박·형압·투명·화이트) **7상품 바인딩 부재 확정**. |

---

## 2. 빌더 주장 ↔ 라이브 실측 대조표 (뒤집힘/보정)

| 빌더 주장 | 라이브/openpyxl 실측 | 판정 |
|-----------|---------------------|------|
| 구성요소 **27개** 중 24 고아 | 라이브 `t_prc_price_components` 명함/포토카드 = **28개** 중 4 배선·**24 고아** | 🔴 **뒤집힘** — 분모 27→**28**. 고아 24는 정확하나 배선 4(STD_S1·STD_S2·PHOTOCARD_SET·CLEAR_SET)를 빌더는 "3.5"로 셈(structure §4) — 정수 4. structure §0/§3의 "27 구성요소·144 단가행"도 오류(실측 28 comp·115 단가행) |
| 라이브 단가행 115 | `t_prc_component_prices` 명함/포토카드 = **115** | ✅ 일치 (structure §0의 "144 단가행"은 stale 오류·실측 115) |
| 소재전개 16 | import `4_component_prices` 131 − 라이브 115 = **16** | ✅ 일치 |
| BLOCKED 34 | import `4b_BLOCKED` data rows = **34** | ✅ 일치 |
| round-trip 14/14 | 14셀 전부 가격표=import 일치(WHITE_S2W_CL 포함) | ✅ 일치 |
| prc_typ 전부 .01 | `prc_typ_cd` GROUP BY = PRICE_TYPE.01 ×28 | ✅ 일치 |
| 소재 collapse(STD 라이브 2종→전개 5) | 라이브 STD_S1 = MAT_074·082(2종) → import 5종(074/081/082/091/092) | ✅ 일치 |
| 로츠쿼츠 라이브 MAT_000130 오적재→241 정정 | 라이브 PEARL_S1/S2 = MAT_000127·**MAT_000130**(로즈쿼츠) 적재. MAT_000241=로츠쿼츠 별존재 | 🔴 **부분 뒤집힘** — 오적재 적발은 정확하나 import.xlsx가 **130을 제거 안 하고 130·241 둘 다 적재**(정정 미반영, §3 결함-1) |
| 명함 바인딩 STD만 배선→프리미엄도 STD 단가 오출·7상품 미바인딩 | PRD_31/32 바인딩됨·FIXED엔 STD만 배선 / PRD_34~40 바인딩 부재 | ✅ 일치 |

---

## 3. 산출물 결함 (import.xlsx — 보정 라우팅: dbm-price-import-builder)

**결함-1 (P5·MAJOR) PEARL 소재 전개 모순**
- 가격표 R24: "다이아240/실버240/골드240"(동가 9000) + "로츠쿼츠240"(10000) = **4종**.
- import `4_component_prices` PEARL_S1 = 5행: MAT_127(다이아)·128(실버)·129(골드)·**130(로즈쿼츠, 가격표 부재)**·**241(로츠쿼츠)**.
- decomposition §3은 "MAT_000130 오적재 → 241 정정(Q-NC-7)"이라 명시했으나 import.xlsx는 **130을 빼지 않고 130·241 둘 다 적재** → 가격표에 없는 로즈쿼츠(130, 10000) 잔존. **정정 주장과 산출물 불일치**.
- 보정: PEARL는 4종(127/128/129/241)으로. MAT_000130 행 제거 또는 round-13 트랙 교정 항목으로 격리.

**결함-2 (P5·MAJOR) WHITE 소재 전개 비대칭**
- 가격표 R38: "A: 큐리어스스킨 화이트/레드/타크블루/바이올렛/블랙" = 5색 동가 소재그룹(클리어 조합과 무관).
- import: `WHITE_S1W_NOCL` 5색(137~141)·`WHITE_S2W_NOCL` 1색·`WHITE_S1W_CL` 1색·`WHITE_S2W_CL` 1색 = **NOCL_S1만 5색, 나머지 3 comp는 화이트(137) 1색만**.
- 5색 소재는 4개 화이트/클리어 조합 전부에 적용되어야 정합 → S2W_NOCL·S1W_CL·S2W_CL도 5색이어야. 현재 비대칭 누락(소재전개 16 중 일부가 WHITE 한 조합에만 편중).
- 보정: WHITE 4 comp 각각 5색 전개(라이브 collapse 확장 일관) 또는 비대칭 사유를 note 명시.

> 두 결함 모두 **데이터 정합(소재 fidelity)** 결함으로 P5 영역. 그릇 구조(P1·P2)·가격사슬 진단(P6)·round-trip(P3)은 무손실.

---

## 4. insertable / BLOCKED / GAP 집계

| 분류 | 행수 | 비고 |
|------|------|------|
| **insertable**(4_component_prices) | 131 | 단 결함-1(130 1행 제거)·결함-2(WHITE 보정) 반영 후. prc_typ는 .01 유지(Q-NC-1 미해소) |
| **BLOCKED**(4b) | 34 | PREMIUM 그룹대표 개별소재 미확정(MGA/MGB 각 7×4=28)·CLEAR 2·MINISHAPE 2·SHAPE 2. NULL 강제 회피 정당 |
| **GAP / 컨펌**(미해소) | 7 | Q-NC-1(prc_typ .01/.02)·Q-NC-2(세트 환산)·Q-NC-3(모양 mat 미기입)·Q-NC-4(형압명함 가격블록 부재)·Q-NC-5(박 종이자재)·Q-NC-6(공식분리 방식)·Q-NC-7(로츠쿼츠) |
| **가격사슬 복구**(미적재·인간승인) | 24 고아 comp + 7 미바인딩 상품 | 공식 배선·바인딩은 round-5 인간승인 |

---

## 5. 라우팅

- **dbm-price-import-builder**: 결함-1(PEARL 130 제거)·결함-2(WHITE 5색 대칭 전개)·문서 "27 구성요소/144 단가행" → **28 comp·115 단가행** 카운트 정정(structure §0·§3·§4, decomposition §0).
- **인간 승인 대기(round-5)**: 가격사슬 복구(공식 분리·배선·7상품 바인딩)·prc_typ 재판정(Q-NC-1)·로츠쿼츠 round-13 교정.

---

## 6. 한 줄 결론

CONDITIONAL-GO — 그릇(라이브 컬럼 1:1·10차원·BLOCKED 분리) 정당, round-trip 무손실(14/14·115 단가행·16 전개·34 BLOCKED 전건 일치), 가격사슬 단절 진단(24 고아·프리미엄→STD 오출·7 미바인딩) 라이브 실측 일치. **단 빌더의 "27 구성요소" 분모 오류(실측 28)와 import.xlsx PEARL 로즈쿼츠 잔존·WHITE 비대칭 전개 2건은 보정 필수**.
