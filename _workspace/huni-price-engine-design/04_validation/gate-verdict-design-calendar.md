# gate-verdict-design-calendar.md — 디자인캘린더 E1~E7 게이트 판정 (hpe-validator·11번째·최종 종단)

> **검증가(hpe-validator) 독립 판정 — 2026-06-22 라이브 읽기전용 SELECT + python 독립 역산 + L1 CSV verbatim 대조.**
> 방법론=`hpe-design-validation`. designer 주장 비신뢰·직접 재실측. codex(Phase 5.5) 비참조(독립성). DB 쓰기 0.
> 검증 대상: `03_design/engine-design-design-calendar.md`·`golden-cases-design-calendar.md`·`design-decisions.md`(D-DCAL-1~5).
> 재계산 상세=`recompute-log-design-calendar.md`.

---

## 종합 판정: **GO** (E1~E7 전건 PASS · 2차 재게이트 2026-06-22 codex D1/D2 반영)

> **[2차 재게이트 2026-06-22]** codex Phase5.5가 돈크리티컬 2건(D1 본체 qty 의미·D2 엽서 editor_yn=N 라우팅) 적발 → designer 폐루프 보정 → **검증가 1차가 놓친 부분을 엔진 코드·라이브 직접 재실측으로 재검증**. 두 보정 정합 확인·1차 GO 항목 전건 불변 → **E4·E6 재판정 PASS 유지·종합 GO**.
> - **D1**: `.01 단가형`은 엔진계약상 항상 `unit_price × qty`(pricing.py:191 `return up*q` 직접 Read·W-3 min_qty=티어키). 본체 정찰가 "qty 무관" = 계약 위반 저청구였음 → 본체도 ×qty·GC-DCAL-9 **44,000→80,000** 교정·신규 가드 G-DCAL-QTY. ★1차 검증의 누락 시정(GC-DCAL-9를 설계값 재유도만 함).
> - **D2**: 엽서 PRD_000110 editor_yn=N 라이브 확인 → editor_yn 단독 라우팅 시 엽서 누락(내부 모순). 라우팅 키=가격포함 시트 등재+상품별 PRF_DCAL_* 명시 바인딩(엽서 포함 5상품)으로 교정·누락 해소.
>
> **[1차 재게이트 2026-06-22]** E2 CONDITIONAL→PASS(C-DCAL-1/2/3 표기 보정·.03→.01+min_qty=1·COMP_CALOPT_STAND "신규 mint 선행 의존").
> 1차 판정(보존): CONDITIONAL-GO.

단일 FAIL 없음. 전 게이트 PASS. 보정은 qty/라우팅/표기에 국한·inline BLOCKED·G-DCAL-DUAL·G-PRODPRICE·정찰가 verbatim(qty=1)·신규 mint(공식5+comp1) 전건 불변.

### 2차 재게이트 독립 재실측 (D1/D2·codex 판정 비참조·직접 재확인)

| 검증 | 직접 재확인 | 결과 | 판정 |
|------|------------|------|------|
| D1 엔진계약 .01=×qty | `pricing.py:180-192` 직접 Read | 단가형 `return up*q`(min_qty 무관)·합가형 `up/base*q` | ✅ 본체 정찰가는 ×qty(qty 무관 오류) |
| D1 GC-DCAL-9 재계산 | python 독립(엔진 up*q) | 본체 4000×10 + 우드 4000×10 = **80,000** | ✅ designer 교정 정합·44,000=저청구 |
| D1 qty=1 골든 불변 | python | GC-DCAL-1~7/8 = 정찰가×1 | ✅ 값 불변 |
| D2 엽서 editor_yn | `SELECT editor_yn ... WHERE prd_cd='PRD_000110'` | **N**(타 4상품=Y) | ✅ editor_yn 단독 라우팅 누락 확인 |
| D2 라우팅 교정 | engine-design §2.4/§3.1·바인딩표 110 | 시트 등재+5상품 명시 바인딩 | ✅ 엽서 누락 해소 |

### 재게이트 라이브 재실측 (2026-06-22·보정 표기 정합·결판 불변 확인)

| 재확인 | 재현 SQL | 라이브 결과 | 보정 정합 |
|--------|----------|------------|-----------|
| PRICE_TYPE enum(.03 부재) | `SELECT cod_cd FROM t_cod_base_codes WHERE cod_cd LIKE 'PRICE_TYPE%'` | .01·.02만(.03 없음) | C-DCAL-1 ".01+min_qty=1" 표현이 라이브 코드 정합 ✅ |
| .01+min_qty=1 고정가 선례 | `... WHERE prc_typ_cd='PRICE_TYPE.01' AND cp.min_qty=1` | COMP_ACRYL_COROTTO/KEYRING 등 실작동 | 보정 표현이 라이브 패턴 동형(자의적 신규 아님) ✅ |
| COMP_CALOPT_STAND·COMP_DCAL_FIXED | `SELECT count(*) ... comp_cd IN (...)` | 둘 다 0행 | C-DCAL-2 "신규 mint 선행 의존(0행)" 표기 정합 ✅ |
| product_prices·PRF_DCAL·바인딩 | `SELECT count(*) ...` | pp 0·prf_dcal 0·바인딩 0 | G-PRODPRICE 가드·G-DCAL-DUAL 결판 불변 ✅ |

★ 보정 4파일(engine-design·golden-cases·design-decisions D-DCAL·set-product-design §15) 전수 재검토: ".03"→".01 단가형+min_qty=1"·"COMP_CALOPT_STAND 재사용/실재"→"캘린더 종단 신규 mint 선행 의존(현 라이브 0행)" 일관 전환. **골든값(10400/9700/6500/6500/4000/9900/24000·8000·44000)·inline 역산 비정수(1.313/0.486/1.285/1.574/6.104)·BLOCKED 결판·G-DCAL-DUAL 결판 전건 불변**(가격/계산/결판 무변경·표기만 정정).

---

## E1 — 공식 추출 충실성 : **PASS**

7 inline 정찰가 + add-on가 L1 CSV verbatim과 전건 일치(designer/골든 인용 = L1 직독).

| 항목 | L1 CSV verbatim(셀) | 설계/골든 인용 | 일치 |
|------|--------------------:|---------------:|------|
| 탁상220x145 | 10,400 (row2 `가격`) | 10,400 | ✅ |
| 탁상130x220 | 9,700 (row3 `가격`) | 9,700 | ✅ |
| 미니90x100 | 6,500 (row6 `가격`) | 6,500 | ✅ |
| 미니148x60 | 6,500 (row7 `가격`) | 6,500 | ✅ |
| 엽서145x145 | 4,000 (row8 `가격`) | 4,000 | ✅ |
| 벽걸이210x297 | 9,900 (row10 `가격`) | 9,900 | ✅ |
| 와이드300x625 | 24,000 (row11 `가격`) | 24,000 | ✅ |
| 캘린더봉투240x230 10장 | 2,500 (row3 `추가가격`) | 2,500 | ✅ |
| 캘린더봉투150x310 10장 | 2,400 (row6 `추가가격`) | 2,400 | ✅ |
| 우드거치대 | 4,000 (row8 `추가가격`) | 4,000 | ✅ |

- 차원=사이즈(siz_cd)가 유일 가격축임을 CSV로 재확인(인쇄/종이/페이지=부모행 상속·가격 비기여 spec).
- v03 인용 0·날조 0·누락 0. cartographer 지도(formula-map §1)의 7행도 L1과 일치.
- **판정: PASS** — L1 셀 단위 재대조 전건 통과.

---

## E2 — 구성요소 분해 정합 : **CONDITIONAL** ⚠️

설계의 시트 차원경계(SOT 1) 준수·완제품 구분은 정합이나, **comp 그릇 2건이 라이브에 부존재**(설계가 "재사용·실재"로 표현).

### E2-a 정합 항목 (PASS)
- 본체 정찰가 use_dims=[siz_cd]·사이즈가 유일 가격축 = L1 정합(인쇄/종이/페이지 baked·디자인비 별 comp 분리 안 함 = 과분화 회피).
- 시트 차원경계 안: 디자인캘린더 공식=정찰가+우드거치대만·타 상품군 comp 침입 0·봉투=외부 트랙(U-7 준수).
- 완제품(5 prd 단일 본문·sets 0행) — 반제품/세트 오구분 없음(라이브 sets 0행 실측 정합).
- 의미축 이중 인코딩 없음(도수/면적 차원 미노출·정찰가에 baked).

### E2-b ★결함 (CONDITIONAL 근거·라이브 실측)

**결함 1 — PRICE_TYPE.03(고정가형) 코드값 라이브 부존재.**
설계가 §1·§3.2·§5·§7·골든 전반에서 "본체 정찰가 = .03 고정가형"을 반복했으나:
```sql
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'PRICE_TYPE%';
-- 결과: PRICE_TYPE(단가유형)·PRICE_TYPE.01(단가형)·PRICE_TYPE.02(합가형) — .03 없음
SELECT prc_typ_cd, count(*) FROM t_prc_price_components GROUP BY prc_typ_cd;
-- 결과: PRICE_TYPE.01=145·PRICE_TYPE.02=4 — .03 사용 comp 0건
```
→ **라이브 enum·실사용 모두 .03 부재.** 설계의 ".03 고정가형"은 라이브에 없는 코드값.
※ 단 엔진 계약상 frm_typ/prc_typ "고정가형"은 별 분기가 아니라 **min_qty=1 단가형(.01)의 특수형**(D-4·D-CAL/GP-1 등 타 종단 일관). 즉 본체 정찰가는 실제로는 **.01 단가형 + min_qty=1**(qty 무관 룩업)으로 적재돼야 정합 — designer 표기 ".03"은 라이브 코드 부재로 **오표기**(가격 영향은 .01+min_qty=1이면 동일하나 코드값 정정 필요).

**결함 2 — COMP_CALOPT_STAND(우드거치대 comp)·우드거치대 4000 단가행 라이브 부존재.**
```sql
SELECT comp_cd FROM t_prc_price_components WHERE comp_cd='COMP_CALOPT_STAND';  -- 0행
SELECT * FROM t_prc_component_prices WHERE comp_cd='COMP_CALOPT_STAND';        -- 0행
```
→ 설계 §4.1/§5/§6·골든 §2가 "캘린더 COMP_CALOPT_STAND **직계 재사용**·단가 4000 **실재**"로 표현했으나 **라이브 0행**. 진상: COMP_CALOPT_STAND는 **캘린더 종단(engine-design-calendar §4/golden-cases-calendar §2)이 "신규 mint comp"로 명시한 미적재 그릇**(캘린더 종단도 DB 미적재). 즉 "라이브 재사용"이 아니라 "캘린더 종단이 mint 예정인 comp에 의존". 단가 4000은 L1 row8 verbatim(날조 아님)이나 그릇이 아직 없음.

### E2 판정 근거 (1차)
- 두 결함 모두 **단가 날조·가격 오류 아님**(단가는 L1/라이브 verbatim·계산 의미 정합). 전부 **인간 컨펌 후 신규 mint** 대상(설계도 "인간 컨펌 후" 단서 부착).
- ∴ NO-GO 아님(가격 오배선 없음). 그러나 설계 표현이 **신규 mint 의존성을 "재사용/실재/.03"으로 가려** 검증가·dbmap이 오인할 위험 → **CONDITIONAL·보정 표기 요구**.

### ★E2 재판정 (2026-06-22) — **CONDITIONAL → PASS**
designer C-DCAL-1/2/3 폐루프 보정을 검증가가 라이브 독립 재실측으로 재검토:
- **결함 1 해소**: engine-design(§0·§1·§3.2·§5·§7)·golden-cases·design-decisions D-DCAL·set-product-design §15 전반에서 ".03 고정가형" → **".01 단가형 + min_qty=1"** 로 일관 정정 + "라이브 .03 부재(validator 재실측)" 단서 명기. 라이브 재실측 재확인: PRICE_TYPE enum=.01/.02만·.03 부재 / .01+min_qty=1 고정가 선례(COMP_ACRYL_COROTTO/KEYRING 등) 실작동 → **보정 표현이 라이브 코드/패턴 정합**.
- **결함 2 해소**: 우드거치대 "COMP_CALOPT_STAND 직계 재사용·실재" → **"캘린더 종단 신규 mint 선행 의존(현 라이브 0행·디자인캘린더 독자 mint 금지·캘린더 종단 소관)"** 로 일관 정정(§4.1·§5·§6·골든 §2). 라이브 재실측: COMP_CALOPT_STAND 0행 불변 → 표기가 라이브 사실 정합.
- **결함 3 해소(LOW)**: GC-DCAL-8에 "★단가행 전제: 우드거치대 단가행은 캘린더 종단 mint 적재 후에야 본 골든 재현 가능" 주석 추가.
- **불변 확인[HARD]**: 골든값(10400/9700/6500/6500/4000/9900/24000·8000·44000)·inline 역산 비정수(1.313/0.486/1.285/1.574/6.104)·BLOCKED 결판·G-DCAL-DUAL 결판·G-PRODPRICE 가드 **전건 무변경**(가격/계산/결판 불변·표기만 정정).
- **추가 결함 없음**: 보정 4파일 전수 재검토에서 가격 오배선·새 mint 누락·결판 변형 0건.
- ∴ **E2 PASS** — 설계가 신규 mint 의존성·라이브 코드 부재를 정확히 표기(검증가/dbmap 오인 위험 제거).

---

## E3 — 경쟁사 흡수 타당성 : **PASS**

- 정찰가 유지(고정가형 완제 SKU) 결론이 **권위 엑셀 덮어쓰기 없이 흡수**(흡수=RedPrinting tmpl_price "디자인 제공 완제품=정찰가" 메커니즘만·DC-1).
- inline 정찰가를 산식으로 재분해(②안)하면 권위 엑셀 덮어쓰기 위험 → designer가 정확히 부결(권위 보존).
- naming/codes(tmpl_price/edicus_item/STA_CLD/vTmpl) 후니 유입 0 — 설계 frm_cd(PRF_DCAL_*·한글의미)·comp_cd로 번역 명시.
- 후니 표현력 초과 mint 없음(신규 가격축 0·11연속 search-before-mint).
- **판정: PASS**.

---

## E4 — 엔진 설계 건전성 (★inline=정찰가 BLOCKED 독립 재역산) : **PASS**

★directive 핵심 — 7 inline을 라이브 단가행으로 분해해 정수해 재현되는지 **독립 재계산**(recompute §1):

| 상품 | inline | per_plate(라이브 verbatim) | **유효판수(검증가 재산출)** | 정수? |
|------|-------:|---------------------------:|---------------------------:|------|
| 탁상220 | 10,400 | 4,112.58(양면) | **1.313** | ❌ |
| 미니 | 6,500 | 4,112.58(양면) | **0.486** | ❌ |
| 엽서 | 4,000 | 3,112.58(단면) | **1.285** | ❌ |
| 벽걸이 | 9,900 | 3,112.58(단면) | **1.574** | ❌ |
| 와이드 | 24,000 | 3,112.58(단면) | **6.104** | ❌ |

- **5건 전부 비정수** + 페이지수와 정수 배수 관계 없음(미니 0.486판으로 26P 물리 불가) → inline=정찰가·**BLOCKED 정당**(designer 오판 아님).
- 역산 입력 단가(3000/4000/112.58/5000/4500) = **라이브 verbatim 일치**(별도 SELECT 확인) → designer가 비정수 역산으로 단가를 날조하지 않음.
- ★**포토북 대비**: 포토북 per2p는 imposition cost-driven 정수 선형 → FORMULA. 디자인캘린더는 비정수 → 정찰가. **두 inline 시트 분기 판정이 독립 재계산으로 타당**.
- engine-contract 정합: frm_typ 미참조(C7)·상품별 전용 PRF로 ERR_AMBIGUOUS 회피·차원 자동매칭(siz_cd)·search-before-mint(신규 가격축 0).
- **판정: PASS** — inline 역산 비정수 독립 재현·BLOCKED 결판 지지·엔진 계약 정합.

### ★E4 2차 재판정 (2026-06-22·codex D1/D2·PASS 유지)
- **D1 본체 qty 의미(1차 누락 시정)**: `pricing.py:180-192` 직접 Read — `.01 단가형 = return up*q`(unit_price×qty·min_qty는 티어선택만·W-3). 1차 설계의 "본체 정찰가 qty 무관"은 **엔진계약 위반 저청구**였음. designer 교정 = 본체도 ×qty(견적가=정찰가×qty·G-DCAL-QTY 신규 가드)이 **엔진계약 정합**. 검증가 1차가 GC-DCAL-9를 설계값 재유도만 한 누락을 시정.
- **D2 라우팅 키**: 엽서 PRD_000110 editor_yn=N 라이브 SELECT 확인 → editor_yn 단독 라우팅 시 엽서 정찰가 PRF_DCAL 누락(내부 모순). designer 교정(가격포함 시트 등재+상품별 PRF_DCAL_* 명시 바인딩·editor_yn 보조)이 5상품(엽서 포함) 전건 라우팅 → **ERR_AMBIGUOUS/누락 회피·엔진계약 정합**(1 prd 1 공식 보장).
- **판정: PASS 유지** — D1/D2 교정으로 엔진 건전성 강화(저청구 가드·라우팅 누락 해소). 추가 결함 없음.

★ E2 결함(.03/COMP_CALOPT_STAND 부존재)은 "건전성"이 아니라 "그릇 실재성·표기 정확성" 문제라 E2로 귀속(E4는 산식/매칭 건전성).

---

## E5 — 세트(반제품) 조합 정합 : **PASS**

- 세트 불요 결정 = 라이브 `t_prd_product_sets` 캘린더 0행 실측 정합(이중계상 위험 0).
- 봉투 add-on 귀속: PRD_000005(012-0008·캘린더봉투·PRD_TYPE.03·use_yn=Y) 독립 PRD 실재 → 봉투제작 트랙 위임이 정합(본체 가격공식에 봉투 합산 안 함 = 오과금 회피·G-DCAL-ENVELOPE).
- 봉투 사이즈별 변형가(2500 vs 2400) use_dims 충전 가드 = 평탄화 함정 방지 정합(봉투 트랙에서·본체 미합산).
- 우드거치대 add-on = formula 합산(별 comp 가산)·세트 분해 아님 = 정합. 단 그릇 실재성은 E2 결함과 연동(우드거치대 comp 미적재).
- **판정: PASS**(세트 모델 무모순·이중계상/구성품 누락 없음).

---

## E6 — 골든 재현(허용오차 0) : **PASS** (조건부 항목 명시)

설계 공식/정찰가로 골든 9건을 실제 재계산(recompute §2):

| 골든 | 기대값 | 재현(검증가) | 대조 |
|------|-------:|-------------|------|
| GC-DCAL-1~7 본체 정찰가 | 10400/9700/6500/6500/4000/9900/24000 | L1 verbatim 직독 siz 룩업 | ✅ **허용오차 0** |
| GC-DCAL-8 본체+우드거치대 | 8,000 | 4000(본체 L1)+4000(우드 L1) | ✅ 산술 0·🟡 우드 그릇 mint 선행 의존 |
| GC-DCAL-9 본체+우드 ×qty=10 | **80,000**(2차 교정·1차 44,000) | 본체 4000×10 + 우드 4000×10 | ✅ 엔진 up*q 독립 재현·🟡 Q-DCAL-FIN 가설 |
| inline 합산 산식 | (재현 불가) | 비정수(§1) | ❌ BLOCKED 정직 |

- **GC-DCAL-8 G-PRODPRICE 가드 독립 재현**: 라이브 product_prices 0행 실측 → 본체를 product_prices에 박으면 FORMULA 우회 silent → **4,000만 출력(우드 누락)**. formula 합산 유지 시 **8,000 정답**. designer 결정(본체도 formula 바인딩·product_prices 금지)이 이 가드 충족. **8,000 vs 4,000 갈림을 독립 재현**.
- 본체 정찰가 골든은 L1 verbatim 직독으로 허용오차 0(GC-DCAL-1 vs 2의 10400≠9700 siz 분기 재확인).
- ★갈린 지점: GC-DCAL-8 우드거치대 4000은 **캘린더 COMP_CALOPT_STAND 신규 mint 선행 의존**(현 라이브 0행)이라 add-on 부분은 mint 후 재현(단가값 오류 아님·그릇 미적재). 본체 정찰가 부분은 즉시 재현.
- ★**E6 2차 재판정 (codex D1·1차 누락 시정)**: GC-DCAL-9를 1차에 44,000(설계 자체값)으로 재유도했으나 엔진계약상 본체도 ×qty → **80,000 정답**(엔진 `up*q` python 독립 재계산). 44,000은 본체 qty-불변 가정 저청구. GC-DCAL-1~7/8(qty=1)은 ×1이라 **값 불변**(정찰가 verbatim 보존). designer 골든 교정(80,000·G-DCAL-QTY 입증) 정합.
- **판정: PASS** — 본체 정찰가 허용오차 0(qty=1)·GC-DCAL-9 80,000 ×qty 독립 재현·G-PRODPRICE 가드 골든 독립 재현·inline 산식 BLOCKED 정직. 조건부 항목(우드 mint 의존·Q-DCAL-FIN 가설)은 정직 표기됨.

---

## E7 — 생성-검증 독립성 : **PASS**

- G-DCAL-DUAL 결판(product_prices 0·바인딩 0·PRF_CAL_*/PRF_DCAL_* 부존재)을 **라이브 직접 SELECT 7건**으로 재실측(recompute §5) — designer 결론 무비판 베끼기 없음.
- inline 역산을 라이브 단가 verbatim으로 **python 독립 재산출**(designer echo 아님·입력 단가 별도 SELECT 확인).
- ★독립 적발: .03 코드값·COMP_CALOPT_STAND 라이브 부존재(designer가 "재사용/실재"로 표현한 것을 라이브로 반증) = self-approve·dodge 없음.
- codex(Phase 5.5) 결과 비참조·자기 실측으로만 판정.
- **판정: PASS**.

---

## 보정 지시 (designer 폐루프·E2 CONDITIONAL 해소)

| # | 보정 항목 | 근거(라이브) | 폐루프 |
|---|-----------|-------------|--------|
| **C-DCAL-1** | ★본체 정찰가 prc_typ ".03 고정가형" 표기를 **".01 단가형 + min_qty=1(qty 무관 룩업)"** 로 정정 — 라이브 PRICE_TYPE enum에 .03 부재(.01/.02만)·실사용 0건 | `t_cod_base_codes` PRICE_TYPE.03 없음·distinct prc_typ_cd=.01/.02 | designer engine-design §1·§3.2·§5·§7·golden 전반 ".03"→".01+min_qty=1" 표기 정정(가격 무영향·코드 정합) |
| **C-DCAL-2** | ★우드거치대 add-on "COMP_CALOPT_STAND **직계 재사용·단가 4000 실재**" 표현을 **"캘린더 종단이 신규 mint 예정인 미적재 comp에 의존(현 라이브 0행)"** 로 정정 | `COMP_CALOPT_STAND` comp 0행·단가행 0행·거치 comp는 POSTER 계열뿐 | designer §4.1/§5/§6·golden §2 "재사용/실재"→"캘린더 종단 신규 mint 선행 의존" 명기. 우드거치대 4000은 L1 verbatim(날조 아님)이나 그릇 mint 선행 필수 |
| C-DCAL-3(LOW) | GC-DCAL-8 골든에 "우드거치대 단가행이 캘린더 COMP_CALOPT_STAND mint 후에만 재현 가능" 의존성 주석 추가 | 위 동일 | golden-cases §2 의존성 주석 |

★ 위 보정은 **표기 정확성** 교정이며 **가격 계산 결과·BLOCKED 결판·G-DCAL-DUAL 결판은 불변**(전건 라이브 정합). 단가 날조·가격 오배선 없음 → NO-GO 아님. 실 적재는 인간 컨펌(Q-DCAL-AUTHORITY) 후 dbmap 위임·webadmin 코드 직접수정 금지.

★ **[보정 완료 2026-06-22] C-DCAL-1/2/3 전건 폐루프 적용·검증가 라이브 재실측 확인 → E2 PASS·종합 GO**(상기 E2 재판정 참조). 잔여 보정 항목 없음.

---

## 컨펌큐 (인간 결판·carry-forward)

| ID | 사안 | 검증가 메모 |
|----|------|-------------|
| Q-DCAL-AUTHORITY(최우선) | inline 정찰가 채택(① PRF_DCAL_*) vs 견적 비대상 BLOCKED 유지 | 채택 시에만 §3~§6 적재(.01+min_qty=1로·C-DCAL-1) |
| Q-DCAL-ROUTE (codex D2) | DCAL vs CAL 라우팅 — ★엽서(110) editor_yn=N 포함 | 라우팅 키=가격포함 시트 등재+상품별 PRF_DCAL_* 명시 바인딩(editor_yn 단독 금지·엽서 누락 회피)·option_groups 0행 의존 |
| Q-DCAL-DSC (codex D1·돈크리티컬) | 본체 정찰가 ×qty base에 수량구간할인(DSC) 별 레이어 존재 여부 | 미확인 시 단순 ×qty(할인 0)·견적가=정찰가×qty(±DSC) |
| Q-DCAL-FIN | 우드거치대 4000 개당(×qty) vs 주문당 정액 | GC-DCAL-9 가설 의존(개당이면 80,000·주문당이면 44,000) |
| Q-DCAL-WOODSTAND-MINT | 캘린더 종단 COMP_CALOPT_STAND mint가 디자인캘린더 add-on의 선행 조건 | C-DCAL-2 연동·캘린더 종단과 mint 순서 조율 |

---

## 게이트 종합표

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| E1 공식 추출 충실성 | **PASS** | 7 inline + add-on L1 verbatim 전건 일치 |
| E2 구성요소 분해 정합 | **PASS** (1차 CONDITIONAL→보정 후 PASS) | .03→.01+min_qty=1·COMP_CALOPT_STAND "신규 mint 선행 의존" 표기 정정·라이브 정합 재확인 |
| E3 경쟁사 흡수 타당성 | **PASS** | 정찰가 유지·권위 무덮어쓰기·naming 유입 0 |
| E4 엔진 설계 건전성 | **PASS** (2차 D1/D2 재판정) | inline 역산 비정수 독립 재현·★D1 본체 ×qty(pricing.py:191 직접 Read)·D2 엽서 editor_yn=N 라우팅 교정 정합 |
| E5 세트 조합 정합 | **PASS** | 세트 0행·봉투 독립 PRD 실재·이중계상 0·라우팅 5상품 명시 바인딩 정합 |
| E6 골든 재현 | **PASS** (2차 GC-DCAL-9 재판정) | 본체 정찰가 허용오차 0(qty=1)·★GC-DCAL-9 **80,000** ×qty 독립 재현·G-PRODPRICE 가드 독립 재현 |
| E7 생성-검증 독립성 | **PASS** | 라이브 7 SELECT·엔진 코드 직접 Read·독립 적발(1차)·1차 누락 시정(2차) |
| **종합** | **GO** (2차 재게이트 2026-06-22) | E1~E7 전건 PASS·codex D1/D2 반영·1차 GO 항목(BLOCKED·DUAL·PRODPRICE·verbatim·mint) 전건 불변 |
