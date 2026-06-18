# Chain Defect Board — 라이브 가격사슬 정합 결함 보드 (생성측)

> **Phase 2 — hpq-price-chain-inspector** · 2026-06-18 · `huni-price-quote`
> 입력 기준점: `01_engine/engine-contract.md`(C1~C9·P-명제) · `02_authority/authority-golden.md`(가격축) · `02_authority/golden-cases.md` · `02_authority/authority-gaps.md`.
> **3원 정합:** ① 권위 엑셀 ② 엔진 계약(pricing.py) ③ 라이브 실측(읽기전용 psql, 2026-06-18).
> **생성측 — 판정은 `hpq-quote-gate-validator`가 독립 재실측.** 각 결함에 재현 SQL 동반. 직접 교정 금지.
> 파일럿: 엽서 PRD_000017→PRF_DGP_A · 현수막 PRD_000138→PRF_POSTER_BANNER_N · 아크릴 PRD_000146→PRF_CLR_ACRYL.

---

## 0. 기준점 정합 확인 (3원 OK 항목 — 결함 아님)

| 항목 | 라이브 실측 | 권위/엔진 정합 |
|------|------------|---------------|
| 상품-공식 바인딩 | PRD_000017→PRF_DGP_A(2026-06-01) · PRD_000138→PRF_POSTER_BANNER_N(2026-06-01) · PRD_000146→PRF_CLR_ACRYL(2026-06-15) | ✅ 권위 3구조(합산/면적/면적+두께)와 일치 |
| 직접단가(순위1·2) | product_prices=0 · template_prices=0 (3 파일럿 모두) | ✅ C1: 전 상품 FORMULA 평가. P1-2 오버라이드 미발화 |
| 아크릴 합가형 min_qty | COMP_ACRYL_CLEAR3T 165행 전부 min_qty=1 (NULL 0) | ✅ C3/P4-3 안전 (÷1, 골든 불변) |
| ERR_DUPLICATE | 파일럿 15 comp 전수 — 동일(차원·구간·apply_ymd) 중복행 0 | ✅ P3-9 클린 |
| 아크릴 두께축 | COMP_ACRYL_CLEAR3T mat_cd=MAT_000042(1.5mm)/MAT_000043(3mm) 통합 | ✅ use_dims=[siz_width,siz_height,mat_cd] 선언·충전 일치. 골든 1.5T=2480·3T=3100 재현 가능(메모리 [[dbmap-acrylic-price-chain-link]] 정합) |

---

## 1. 결함 요약 (상품별 · 심각도순)

| ID | 상품 | 공식 | 결함유형 | 심각도 | 한줄 |
|----|------|------|---------|:--:|------|
| **D-1** | 엽서·현수막 | PRF_DGP_A·PRF_DGP_D·PRF_POSTER_BANNER_N | 중복배선 과대합산(줄수) | 🔴 High | CREASE_1L이 줄수1·2·3 전부 보유 + CREASE_2L/3L 별도 배선 → 줄수=2/3 선택 시 이중 합산 |
| **D-2** | 엽서·현수막 | PRF_DGP_A·PRF_DGP_D·PRF_POSTER_BANNER_N | 중복배선 과대합산(개수) | 🔴 High | VARTEXT_1EA/VARIMG_1EA가 개수1·2·3 전부 보유 + 2EA/3EA 별도 배선 → 개수=2/3 이중 합산 |
| **D-3** | 엽서·현수막 | PRF_DGP_A·PRF_POSTER_BANNER_N | 오염 단가행 과대합산(귀돌이) | 🔴 High | CORNER_RIGHT(직각)가 PROC_000028(둥근) 행 9건 오보유 → 둥근 선택 시 RIGHT+ROUND 이중 합산 |
| **D-4** | 엽서 | PRF_DGP_A | 고아 배선(단가행 0) | 🟡 Med | COMP_COAT_GLOSSY 배선됐으나 단가행 0건 → 유광코팅 선택 무료(침묵 0원) |
| **D-5** | 엽서 | PRF_DGP_A | 이중 인쇄비 경로 위험(S1+S2) | 🟡 Med→CONFIRM | DIGITAL_S1(plt_siz)·S2(siz_cd) 동일 SIZ값 양쪽 배선 → selections가 두 키 동시 제공 시 이중 합산 |
| **D-6** | 현수막 | PRF_POSTER_BANNER_N | 불필요 배선(권위 외 차원) | 🟡 Med→CONFIRM | 별색인쇄비 SPOT_WHITE_S1 배선됐으나 현수막 권위 가격축에 별색 없음 + 차원(plt_siz/print_opt) 현수막 selections 미제공 |
| **D-7** | 아크릴 | PRF_CLR_ACRYL | 미사용 comp(바인딩 불명) | ⚪ Info→CONFIRM | COMP_ACRYL_MIRROR3T·COROTTO 존재하나 어느 공식에도 미배선 (authority-gap Q-ACR-MIRROR-BIND) |

---

## 2. 결함 상세 (위치·증상·권위정답·원인가설·재현SQL·라우팅)

### D-1 🔴 줄수(오시) 이중 합산 — 중복 배선

- **위치:** `t_prc_formula_components`(PRF_DGP_A seq16/17/18 = CREASE_1L/2L/3L; PRF_DGP_D 동일) · `t_prc_component_prices`(COMP_PP_CREASE_1L 30행).
- **증상:** COMP_PP_CREASE_1L의 단가행이 dim_vals `{"줄수":1}`·`{"줄수":2}`·`{"줄수":3}`을 **전부**(각 10행, 총 30행) 보유. 동시에 COMP_PP_CREASE_2L(줄수=2 10행)·COMP_PP_CREASE_3L(줄수=3 10행)이 **별도 구성요소로 같은 공식에 배선**. 세 comp 모두 proc_cd=PROC_000090(오시) 공유. 가격도 동일(줄수=2 → 1L과 2L 모두 6000/12000/…).
- **엔진 거동(P2-2/P8-1):** 엔진은 각 comp를 독립 자동매칭·합산. 오시 선택 + 상세 줄수=2 → `_match_entry`가 CREASE_1L의 줄수=2 행 매칭(included) **그리고** CREASE_2L의 줄수=2 행 매칭(included) → 두 subtotal 모두 합산 → **6000 대신 12000**(줄수=3은 1L+3L → 3배).
- **권위 정답:** [공식집:행10] 후가공비 = 제작수량행 1회. 오시 1종(줄수별 1단가). 줄수=N 오시는 단가 1건만 합산돼야 함.
- **원인 가설:** 오시 줄수를 ①별도 comp(1L/2L/3L) ②comp 내부 dim_vals(줄수 param) — **두 방식으로 동시 모델링**. 정합하려면 둘 중 하나만. 정상 설계 = CREASE_1L만 줄수 param으로 전 줄수 처리하고 2L/3L 배선 제거(권장), 또는 1L에서 줄수 2·3 행 제거.
- **재현 SQL:**
  ```sql
  SELECT comp_cd, count(*) FROM t_prc_component_prices
  WHERE comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_CREASE_2L','COMP_PP_CREASE_3L')
    AND dim_vals::text='{"줄수": 2}' GROUP BY comp_cd;
  -- CREASE_1L=10, CREASE_2L=10  → 둘 다 줄수=2 매칭 → 이중 합산
  SELECT frm_cd, comp_cd FROM t_prc_formula_components
  WHERE comp_cd IN ('COMP_PP_CREASE_1L','COMP_PP_CREASE_2L','COMP_PP_CREASE_3L') ORDER BY frm_cd,comp_cd;
  ```
- **경계(option-mapper):** CPQ option_items가 UI에서 줄수를 단일 선택으로 노출하더라도, 엔진 `_evaluate_formula`는 option 레이어를 조회하지 않고 배선된 comp를 전부 매칭(pricing.py:444-475). CPQ 택1은 **comp 매칭을 게이트하지 않음** → 데이터 레이어 결함 그대로 발화.
- **라우팅:** dbmap [[dbmap-price-component-grouping]](그룹핑=단가행 보존+배선축소 use_yn=N) → 2L/3L 배선 제거 트랙. 메모리 [[dbmap-price-chain-dwire-per-product-formula]] 동근.

---

### D-2 🔴 가변데이타 개수 이중 합산 — 중복 배선 (D-1과 동형)

- **위치:** `t_prc_formula_components`(PRF_DGP_A seq22~27; PRF_DGP_D) · COMP_PP_VARTEXT_1EA(69행)·COMP_PP_VARIMG_1EA(69행).
- **증상:** VARTEXT_1EA가 dim_vals `{"개수":1/2/3}` 전부(각 23행) 보유 + VARTEXT_2EA(개수=2)·VARTEXT_3EA(개수=3) 별도 배선. 모두 proc_cd=PROC_000031(가변텍스트) 공유. VARIMG도 동형(PROC_000032). VARTEXT(031)/VARIMG(032)는 proc_cd 달라 **교차** 이중합산은 없음 — 단 **family 내부**(1EA vs 2EA/3EA)는 D-1과 동일 이중합산.
- **엔진 거동:** 개수=2 선택 → VARTEXT_1EA 개수=2 행 + VARTEXT_2EA 개수=2 행 둘 다 included → 이중.
- **권위 정답:** 가변데이타 개수는 단일 가산. 1EA(개수 param) 단일 또는 2EA/3EA 별도 중 하나.
- **재현 SQL:**
  ```sql
  SELECT comp_cd, count(*) FROM t_prc_component_prices
  WHERE comp_cd IN ('COMP_PP_VARTEXT_1EA','COMP_PP_VARTEXT_2EA','COMP_PP_VARTEXT_3EA')
    AND dim_vals::text='{"개수": 2}' GROUP BY comp_cd;  -- 1EA=23, 2EA=23 (둘 다 매칭)
  ```
- **라우팅:** D-1과 동일(배선 축소). [[dbmap-price-component-grouping]].

---

### D-3 🔴 귀돌이 둥근 오염 단가행 — 과대합산

- **위치:** COMP_PP_CORNER_RIGHT(18행) — proc_cd=PROC_000027(직각) 9행 **+ PROC_000028(둥근) 9행**. COMP_PP_CORNER_ROUND(9행)=PROC_000028(둥근). 둘 다 PRF_DGP_A(seq28/29)·PRF_POSTER_BANNER_N(seq3/4) 배선.
- **증상:** "귀돌이 직각" 전용이어야 할 CORNER_RIGHT가 **둥근(PROC_000028) 단가행도 보유**. 귀돌이 둥근 선택 → CORNER_RIGHT의 PROC_000028 행 매칭 + CORNER_ROUND의 PROC_000028 행 매칭 → 이중 합산.
- **권위 정답:** 귀돌이(PROC_000026) 하위 = 직각(027)·둥근(028). 직각 comp는 027만, 둥근 comp는 028만 보유해야. CORNER_RIGHT의 PROC_000028 행 9건은 오염.
- **원인 가설:** 적재 시 CORNER_RIGHT에 둥근 단가까지 평면화 유입(직각/둥근 분리 누락). round-22 자재/공정 오염 패턴 동형.
- **재현 SQL:**
  ```sql
  SELECT comp_cd, proc_cd, count(*) FROM t_prc_component_prices
  WHERE comp_cd IN ('COMP_PP_CORNER_RIGHT','COMP_PP_CORNER_ROUND') GROUP BY comp_cd,proc_cd ORDER BY proc_cd;
  -- CORNER_RIGHT|PROC_000027|9, CORNER_RIGHT|PROC_000028|9(오염), CORNER_ROUND|PROC_000028|9
  ```
- **라우팅:** dbmap 정합 교정([[dbmap-correctness-audit-round13]]) — CORNER_RIGHT의 PROC_000028 행 9건 제거 또는 use_yn=N.

---

### D-4 🟡 유광코팅비 고아 배선 (단가행 0)

- **위치:** `t_prc_formula_components`(PRF_DGP_A seq13 COMP_COAT_GLOSSY) · `t_prc_component_prices`(COMP_COAT_GLOSSY=0행).
- **증상:** COMP_COAT_GLOSSY가 PRF_DGP_A에 배선됐으나 단가행 0건. COMP_COAT_MATTE는 92행 정상. → 유광 코팅 선택 시 매칭행 없음 → no-match 자연 제외(P2-2) → lenient에서 0원 침묵(코팅 무료).
- **권위 정답:** 가격표 `코팅`:B2~E3 = 무광단/무광양/유광단/유광양 4열 전부 단가 존재. 유광코팅비 단가행이 적재돼야 함.
- **원인 가설:** 코팅 적재 시 무광만 평면화·유광 누락(가격표 유광단/유광양 열 미추출). golden-cases 케이스1b(무광)는 정상이나 유광 케이스는 0원 결함.
- **재현 SQL:**
  ```sql
  SELECT comp_cd, count(*) FROM t_prc_component_prices
  WHERE comp_cd IN ('COMP_COAT_GLOSSY','COMP_COAT_MATTE') GROUP BY comp_cd;  -- GLOSSY=0(결함), MATTE=92
  ```
- **라우팅:** dbmap 가격표 import([[dbmap-price-import-round16]]) — `코팅` 유광 2열 추출·적재.

---

### D-5 🟡→CONFIRM 디지털 인쇄비 S1/S2 이중경로 위험

- **위치:** COMP_PRINT_DIGITAL_S1(212행, use_dims=[proc_cd,**plt_siz_cd**,print_opt_cd,min_qty,proc_grp]) · COMP_PRINT_DIGITAL_S2(212행, use_dims=[proc_cd,**siz_cd**,print_opt_cd,min_qty,proc_grp]). 둘 다 PRF_DGP_A(seq1/2) 배선·proc_grp=PROC_000001 공유.
- **증상:** S1은 SIZ_000077/SIZ_000499를 `plt_siz_cd`로, S2는 **같은 두 값**을 `siz_cd`로 보유(국4절·3절 판형). 단가는 다름(S1 국4절 3500 / S2 3절 5000). 두 comp는 출력판형(국4절 vs 3절) 분기로 보임. **위험:** 엔진은 두 comp 독립 매칭. selections가 plt_siz_cd와 siz_cd를 **동시에** 제공하고 둘 다 SIZ_000077이면 S1·S2 둘 다 매칭 → 인쇄비 이중(3500+5000) 합산.
- **CONFIRM 사유:** 정상 설계라면 selections는 판형에 따라 plt_siz_cd **또는** siz_cd 중 하나만 제공(상호배타). 라이브에서 selections 키 구성이 어떻게 만들어지는지(price_views가 판형별로 한 키만 세팅하는지)는 엔진계약 외 호출측 결정 → **결함 단정 불가**. 권위(국4절/3절 분기 = `판걸이수`:G/H열)는 분기 자체는 정당.
- **재현 SQL:**
  ```sql
  SELECT 'S1' c, string_agg(DISTINCT plt_siz_cd,',') FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S1'
  UNION ALL SELECT 'S2', string_agg(DISTINCT siz_cd,',') FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S2';
  -- 둘 다 SIZ_000077,SIZ_000499 (같은 값, 다른 차원키)
  ```
- **라우팅:** CONFIRM 큐. 검증자가 `evaluate_price`에 양쪽 키 동시 제공 케이스로 이중합산 발화 여부 실측 → 발화 시 D-5 결함 승격, 호출측 단일키 보장 시 정상.

---

### D-6 🟡→CONFIRM 현수막 별색인쇄비 불필요 배선

- **위치:** `t_prc_formula_components`(PRF_POSTER_BANNER_N seq7 = COMP_PRINT_SPOT_WHITE_S1) · COMP_PRINT_SPOT_WHITE_S1(530행, use_dims=[plt_siz_cd,proc_cd,print_opt_cd,min_qty,proc_grp:PROC_000007]).
- **증상:** 별색인쇄비 comp가 현수막 공식(PRF_POSTER_BANNER_N)에 배선. 그러나 권위(authority-golden §2) 현수막 가격축 = 소재·가로·세로(면적매트릭스)뿐 — **별색 축 없음**. SPOT_WHITE의 차원(plt_siz_cd/print_opt_cd)은 현수막 selections(siz_width/siz_height만)가 제공하지 않음.
- **엔진 거동:** 현수막 selections에 plt_siz_cd/print_opt_cd 없음 → SPOT_WHITE 행의 비수량 차원(plt_siz_cd≠NULL, print_opt_cd≠NULL)이 selections와 불일치 → `_row_matches` 탈락 → no-match → 합산 제외(현재는 무해 0원). **단, 손님이 어떤 경로로든 plt_siz_cd/print_opt_cd를 제공하면 별색비가 현수막에 부당 가산.**
- **권위 정답:** 현수막 공식에 별색인쇄비 불필요. 배선 제거 대상.
- **CONFIRM 사유:** 현수막에 별색 인쇄 옵션이 실무상 존재하는지(가격표 미열람분 행185+) authority-gap에 미확정. 권위 엑셀이 별색 부재를 명시하지 않아 **불필요 단정 불가**. 다만 차원 미스매치로 현재 무발화 = 실손해 없음.
- **재현 SQL:**
  ```sql
  SELECT frm_cd, comp_cd FROM t_prc_formula_components
  WHERE frm_cd='PRF_POSTER_BANNER_N' AND comp_cd='COMP_PRINT_SPOT_WHITE_S1';
  -- 배선 존재. SPOT_WHITE use_dims에 siz_width/height 없음(현수막 selections와 무교집합)
  ```
- **라우팅:** CONFIRM 큐 → 현수막 별색 도메인 확인(가격표 현수막 블록 전수 추출). 별색 부재 확정 시 배선 제거([[dbmap-price-chain-dwire-per-product-formula]]).

---

### D-7 ⚪→CONFIRM 미러아크릴/코롯토 미사용 comp

- **위치:** COMP_ACRYL_MIRROR3T·COMP_ACRYL_COROTTO 존재(`t_prc_price_components`). PRF_CLR_ACRYL에는 COMP_ACRYL_CLEAR3T만 배선.
- **증상:** 권위(authority-golden §3.1)는 미러3T 매트릭스·코롯토 매트릭스를 가격축으로 명시하나, 어느 공식에도 미배선 → 미러/코롯토 상품은 견적 불가(바인딩 상품 불명).
- **권위 정답:** authority-gap Q-ACR-MIRROR-BIND — 미러 단가만 권위, 바인딩 상품 미상.
- **CONFIRM 사유:** 미러/코롯토를 쓰는 상품(prd_cd)이 라이브에 바인딩됐는지 확인 필요. 본 파일럿(아크릴키링 PRD_000146)은 투명3T(CLEAR3T)만 사용 → 파일럿 범위에선 정상.
- **재현 SQL:**
  ```sql
  SELECT comp_cd, (SELECT count(*) FROM t_prc_formula_components fc WHERE fc.comp_cd=c.comp_cd) AS wired
  FROM t_prc_price_components c WHERE comp_cd IN ('COMP_ACRYL_MIRROR3T','COMP_ACRYL_COROTTO');
  -- wired=0 이면 미사용 comp
  ```
- **라우팅:** CONFIRM 큐(메모리 [[dbmap-acrylic-price-chain-link]] BLOCKED 미러 바인딩과 동일 이슈).

---

## 3. 검증자(P-게이트) 인계 요약

| ID | 즉시 재현 | 검증 의도 | 결함/CONFIRM |
|----|----------|----------|:--:|
| D-1 | CREASE_1L+2L 줄수=2 동시 매칭 → 12000 | 줄수 이중합산 발화 | 결함 |
| D-2 | VARTEXT_1EA+2EA 개수=2 동시 매칭 | 개수 이중합산 발화 | 결함 |
| D-3 | CORNER_RIGHT PROC_000028 오염행 | 둥근 이중합산 발화 | 결함 |
| D-4 | COMP_COAT_GLOSSY 0행 | 유광코팅 0원 침묵 | 결함 |
| D-5 | S1+S2 양키 동시 제공 시 인쇄비 이중 | 호출측 단일키 보장 여부 | CONFIRM |
| D-6 | 현수막 별색 배선 무발화 | 현수막 별색 도메인 존재 여부 | CONFIRM |
| D-7 | 미러/코롯토 wired=0 | 바인딩 상품 존재 여부 | CONFIRM |

> **돈 임팩트 순위:** D-1/D-2/D-3(과대청구, 손님 손해) > D-4(과소청구, 회사 손해) > D-5(조건부 과대) > D-6/D-7(현재 무발화).
> **공통 근본:** D-1/D-2는 "그룹핑 모델 미정리"(같은 의미축을 별 comp + dim_vals 이중 인코딩). [[dbmap-price-component-grouping]] 교훈 — 통합 시 단가행 보존 + 배선 축소(use_yn=N)로 처리. D-3는 적재 오염, D-4는 적재 누락.
