# gate-verdict-stationery.md — 문구 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 검증 (생성≠검증).** engine-designer 설계 주장을 라이브 t_prc_*·t_prd_*·권위 엑셀로 직접 재실측해 결판.
> 라이브 읽기전용 SELECT 실측 2026-06-20(Railway `db railway`) · pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`·569줄) 코드 직접 검증 · 골든 충실 재구현.
> 검증 대상: `03_design/engine-design-stationery.md`·`golden-cases-stationery.md`(GC-ST1~15)·`design-decisions.md` 문구 절(DT-1~6·DT-BIND).
> 기준점: `01_formula/formula-map-stationery.md`·`02_benchmark/absorption-candidates-stationery.md`.

---

## 0. 종합 판정: **GO** (E1~E7 전건 PASS · 차단 결함 0 · 보정 요구 0)

문구는 **첫 게이트부터 GO**(디지털 NO-GO·보정 폐루프와 대조, 아크릴 GO와 동류). 핵심 충돌점 2종(DT-2 떡메모 ×qty·DT-4 DSC 링크)을 라이브 실측으로 독립 결판 → **둘 다 designer 정확**. 골든 15/15 허용오차 0 재현. 신규 mint 0.

| 게이트 | 판정 | 핵심 근거(라이브 실측) |
|--------|------|------------------------|
| E1 공식 추출 충실성 | **PASS** | AC열 단가 9/9 권위 엑셀 verbatim 일치(날조·누락 0)·떡메모 *가격표참고 정합 |
| E2 구성요소 분해 정합 | **PASS** | COMP_TTEOKME 1배선·use_dims 3차원·본체 product_prices 차원없음=시트경계 침입 불가 |
| E3 경쟁사 흡수 타당성 | **PASS** | 신규 가격축 0·naming 유입 0·책자 부품합산형 스코프 분리 적절 |
| E4 엔진 설계 건전성 | **PASS** | 소스 우선순위 코드 일치·search-before-mint(mint 0)·DSC 링크 경로 정확. ★option_items 전역 stale 1건(가격 무영향) |
| E5 세트 조합 정합 | **PASS** | 반제품 sets=생산 BOM(가격 비기여)·이중계상 가드·책자 스코프 밖 기록만 |
| E6 골든 재현 | **PASS** | GC-ST1~15 **전건 15/15 일치(허용오차 0)**·라이브 단가행·DSC 구간 사용 |
| E7 생성검증 독립성 | **PASS** | 충돌 2종 독립 라이브 결판(re-derive 없이 실측)·dodge 없음 |

---

## E1 — 공식 추출 충실성 (cartographer 지도 ↔ 권위 엑셀 셀 재대조) · **PASS**

**재대조 SQL/추출** — 권위 엑셀 `24_master-extract-260610/stationery-l1.csv` AC열(가격 col35) 전수:

| 상품 | 권위 엑셀 AC열 | 설계 §2-2 단가행 | 골든 | 판정 |
|------|---------------|------------------|------|------|
| 만년다이어리(소프트) PRD_000172 | 9000 | 9,000 | GC-ST1 | ✓ |
| 만년다이어리(하드) PRD_000173 | 12000 | 12,000 | GC-ST3 | ✓ |
| 만년다이어리(레더하드) PRD_000174 | 15000 | 15,000 | GC-ST4 | ✓ |
| 만년다이어리(레더소프트) PRD_000175 | 15000 | 15,000 | — | ✓ |
| 먼슬리플래너 PRD_000176 | 12000 | 12,000 | GC-ST5 | ✓ |
| 스프링노트 PRD_000177 | 4500 | 4,500 | GC-ST6 | ✓ |
| 스프링수첩 PRD_000178 | 3000 | 3,000 | GC-ST7 | ✓ |
| 메모패드 144x206 PRD_000179 | 5000 | 5,000 | GC-ST9 | ✓ |
| 메모패드 182x257 | 6000 | 6,000 | — | ✓ |
| 중철노트 PRD_000181 | 2500 | 2,500 | GC-ST8 | ✓ |
| 떡메모지 PRD_000097 | *가격표참고 | 매트릭스(COMP_TTEOKME) | GC-ST10~15 | ✓ |

- **날조 0·누락 0.** designer 값 창작 0 — 전부 cartographer 지도가 상품마스터에서 추출한 verbatim과 일치.
- **떡메모 매트릭스 권위**: 라이브 `t_prc_component_prices`(COMP_TTEOKME) 112행 = `엽서북떡메` 가격표 verbatim. siz 2(90x90/70x120)·bdl 2(50/100)·min_qty 28구간 = 112 = 가격표 차원 충실.
- **v03 인용 차단**: 설계는 v03 미인용·상품마스터(260610)+가격표(260527)+라이브만 인용. ✓
- **LOW 비고**(가격 무영향): 설계 §2-2 사이즈 표기 일부가 권위 엑셀과 다름(먼슬리 권위=A5 148x210 vs 설계 "28P 고정"·중철노트 권위=A6 105x148·스프링수첩 권위=90x145). 단가가 가격축이고 사이즈는 본체 비고이므로 충실성 결함 아님. 사이즈 표기는 정밀화 권고.

---

## E2 — 구성요소 분해 정합 (시트 차원경계 SOT 1·완제품/반제품) · **PASS**

**재현 SQL:**
- COMP_TTEOKME: `comp_typ=PRC_COMPONENT_TYPE.06`(완제품)·`prc_typ=PRICE_TYPE.01`(단가형)·`use_dims=["siz_cd","bdl_qty","min_qty"]` ✓
- PRF_TTEOKME_FIXED formula_components: `COMP_TTEOKME` 1배선·disp_seq=1·addtn_yn=Y ✓

**판정 근거:**
- **silent 합산 오배선 부재**: 공식당 comp 1개·use_dims 3차원 명시·NULL 와일드카드 없음(NULL min_qty 0건/112행). 디지털 인쇄면 S1+S2 이중합산 구조 **구조적 부재**. ✓
- **시트 밖 침입 부재**: 본체 9는 `t_prd_product_prices`(차원 컬럼 없음·라이브 0행) → 디지털/제본 comp 침입 자체가 구조적으로 불가. ✓
- **완제품/반제품 구분**: 떡메모=완제품(comp_typ .06)·본체=반제품 구조이나 가격 단일가(§5에서 다룸). 의미축 이중 인코딩 없음. ✓

---

## E3 — 경쟁사 흡수 타당성 (답습 아닌 흡수·naming 유입·책자 스코프) · **PASS**

- **신규 가격축 0**: C-ST1~8 전부 후니 기존 그릇 매핑(t_prd_product_sets·page_rules·제본 comp 11종·bundle_qtys). vessel-gap 아닌 data/배선-gap. rpmeta TP distinct #18 부결 정합.
- **naming 유입 0**: book2025_price·MTRL_CD·INN_PAGE·paperno3/4/5·seneca·jobqty0/jobcost0·TPBLMEO 후니 유입 없음. 후니 frm_cd/comp_cd/mat_cd 컨벤션만 사용. ✓
- **책자 스코프 분리 적절**: C-ST1(부품 합성·표지+내지+제본 Σ)·C-ST6(jobqty→jobcost 2단 부결)은 책자 종단(DT-BIND-SCOPE)으로 분리. 문구 본체=단일 고정가(부품 합산 아님)라 책자 흡수를 문구에 끌어들이지 않음=과적용 회피. ✓
- **떡메모 흡수**: C-ST7(풀제본 묶음) → 후니 COMP_TTEOKME 단일 완제품가로 이미 담김(풀제본비 별 comp 신설 부결). WowPress 떡메모=미관측 정직 기록. ✓

---

## E4 — 엔진 설계 건전성 (evaluate_price 계약·search-before-mint·채번·FK·할인 링크) · **PASS**

**pricing.py 코드 직접 검증 (라인 재확인):**

| 계약 | 코드 라인 | 설계 인용 | 검증 |
|------|-----------|-----------|------|
| 가격 소스 우선순위 TEMPLATE→PRODUCT_PRICE→FORMULA | :285-326 | 정확 | ✓ 코드 일치 |
| 본체 PRODUCT_PRICE 경로 unit×qty | :315-317 `base_amount = unit_price × qty` | 정확 | ✓ |
| 떡메모 FORMULA 경로 | :320-326 | 정확 | ✓ |
| frm_typ 미참조(C7) | :8 "공식유형 frm_typ 폐기" | 정확 | ✓ |
| ÷min_qty 분기 = 합가형(.02)만 | **:185-190**(`if prc_typ==PRC_TYPE_TOTAL: per=up/base`) / **:192**(단가형 `return up*q`) | 정확 | ✓ ★핵심 |
| min_qty TIER '이상' 하한 선택 | :42·:144·:156-162 | 정확 | ✓ |
| 수량구간할인 연결 prd_cd→dsc_tbl_cd | :360 `_quantity_discount(eff_prd_cd…)`·:478-504 | 정확 | ✓ |

- **★component_subtotal 결정타(:177-192)**: 단가형(.01)은 `return up * q`로 **÷min_qty 미발생**·합가형(.02)만 `up/tier_min_qty`. COMP_TTEOKME=.01이므로 ÷min_qty가 일어나지 않음 → DT-2 designer 결론 코드로 확정.
- **search-before-mint(mint 0)**: 라이브 SELECT — 본체=`t_prd_product_prices` INSERT(공식/comp 신설 0)·떡메모=바인딩만(PRF_TTEOKME_FIXED·COMP_TTEOKME·단가행 전부 실재)·DSC_STAT_QTY 재사용(링크 INSERT만). 신규 공식 0(`PRF` ilike STAT/TTEOK/MEMO/NOTE/DIARY = PRF_TTEOKME_FIXED 1건만, 본체용 신규 없음). ✓
- **DSC 링크 경로 정확**: `_quantity_discount`가 `eff_prd_cd`로 `t_prd_product_discount_tables` 조회(:482) → 링크 누락=할인 0. 설계가 지목한 링크 테이블 정확. ✓

**★E4 결함 1건(LOW·가격 무영향·정정 권고):**
- 설계 §6·formula-map §6은 "**라이브 CPQ 옵션 전무**(option_items 전역 0행)"이라 기술. **라이브 재실측 반증**: `t_prd_product_option_items` 전역 **477행**(stale). 단 **문구 본체 9·떡메모(097)·메모패드(179)에는 option_items 0행**(굿즈/악세사리 PRD_000118~145 등에만 존재). 따라서 **문구 상품 결론(떡메모 사이즈/권당장수 옵션→차원 주입 레이어 미연결·Q-ST-OPT1)은 유효**. "전역 0행" 표현만 stale → "문구 상품 0행"으로 정정 권고. 가격 결과 영향 없음(NO-GO 아님).

---

## E5 — 세트(반제품) 조합 정합 (이중계상·구성품 누락·번들 할인) · **PASS**

- **반제품 가격 분리**: 만년다이어리 하드/레더(173/174=표지 sub_prd·면지 sets)·먼슬리·노트류는 구조상 반제품(생산 BOM `t_prd_product_sets`)이나 **가격=단일 고정가 1건**. 내지단가+표지단가 합산 세트 레이어 불요. ✓
- **이중계상 가드**: product_prices가 차원 없는 단일가라 내지·표지·면지 comp를 별도 합산할 그릇 자체가 없음 → 구조적으로 이중계상 불가. ✓
- **책자(부품 합산형) 스코프 밖**: 중철책자/무선/PUR/하드커버무선·엽서북은 표지+내지+제본 Σ(calc-draft row 63~91·세트 그릇 28행)로 문구 단일고정과 가격 클래스 이질. **설계는 기록만(DT-BIND-SCOPE)·이번에 설계 안 함** = 적절한 스코프 분리. ✓
- **번들 할인 적용 오류 부재**: 본체는 DSC_STAT_QTY 단일 적용(이중할인 위험 없음). 떡메모는 unit 사다리(내장 볼륨할인) + DSC_STAT_QTY 곱 가능성 → designer가 Q-ST-DSC-DOUBLE로 정직하게 컨펌큐 올림(이중할인 미확정). ✓ (실무 확인 큐로 적절)

---

## E6 — 골든 재현 (설계 공식으로 실제 재계산·허용오차 0) · **PASS**

**pricing.py 충실 재구현**(component_subtotal·apply_discount·tier 선택·round_won)으로 **라이브 단가행·DSC 구간 verbatim** 사용. `recompute-log-stationery.md` 전 단계 기록.

**본체 고정가형 (GC-ST1~9·PRODUCT_PRICE·링크 보완 후 기대):**
| ID | unit × qty | base | DSC | 재계산 | 골든 | 일치 |
|----|-----------|------|-----|--------|------|------|
| GC-ST1 | 9000×1 | 9,000 | 0% | 9,000 | 9,000 | ✓ |
| GC-ST2 | 9000×50 | 450,000 | 5% | 427,500 | 427,500 | ✓ |
| GC-ST3 | 12000×1 | 12,000 | 0% | 12,000 | 12,000 | ✓ |
| GC-ST4 | 15000×100 | 1,500,000 | 10% | 1,350,000 | 1,350,000 | ✓ |
| GC-ST5 | 12000×1 | 12,000 | 0% | 12,000 | 12,000 | ✓ |
| GC-ST6 | 4500×10 | 45,000 | 0% | 45,000 | 45,000 | ✓ |
| GC-ST7 | 3000×500 | 1,500,000 | 15% | 1,275,000 | 1,275,000 | ✓ |
| GC-ST8 | 2500×1000 | 2,500,000 | 20% | 2,000,000 | 2,000,000 | ✓ |
| GC-ST9 | 5000×1 | 5,000 | 0% | 5,000 | 5,000 | ✓ |

**떡메모 매트릭스 (GC-ST10~15·FORMULA·.01 단가형·÷min_qty 미발생):**
| ID | siz/bdl/qty | tier min_qty | unit(라이브) | sub=unit×qty | DSC | 재계산 | 골든 | 일치 |
|----|-------------|--------------|--------------|--------------|-----|--------|------|------|
| GC-ST10 | 90x90/100/6 | 6 | 3200 | 19,200 | 0% | 19,200 | 19,200 | ✓ |
| GC-ST11 | 90x90/100/30 | 30 | 2200 | 66,000 | 0% | 66,000 | 66,000 | ✓ |
| GC-ST12 | 90x90/100/600 | 600 | 1050 | 630,000 | 15% | 535,500 | 535,500 | ✓ |
| GC-ST13 | 90x90/50/6 | 6 | 3000 | 18,000 | 0% | 18,000 | 18,000 | ✓ |
| GC-ST14 | 70x120/50/6 | 6 | 3000 | 18,000 | 0% | 18,000 | 18,000 | ✓ |
| GC-ST15 | 70x120/100/12 | 12 | 2500 | 30,000 | 0% | 30,000 | 30,000 | ✓ |

- **전건 15/15 일치 (허용오차 0).** 단가행(F 쿼리)·DSC 구간(I 쿼리)·tier 선택(min_qty '이상' 하한)·round_won 전부 라이브·코드 충실.
- **양면 입증(과청구 결함 실증)**: GC-ST4 링크 누락 시 1,500,000(+150,000 과청구)·떡메모 바인딩 0 시 source=NONE(가격계산 불가). 진원=링크/바인딩 미적재이지 단가값 오류 아님(verbatim 옳음). ✓

---

## E7 — 생성-검증 독립성 (self-approve·dodge-hunt·충돌 독립 결판) · **PASS**

- **★cartographer↔designer 충돌 독립 결판**: designer 결론(DT-2 ×qty 안전)을 신뢰하지 않고 라이브 COMP_TTEOKME 112행 단가 사다리를 직접 SELECT(F 쿼리). **단조 하락(6권 3200→600권 1050) 실측이 unit=권당가를 증명**(묶음총액이면 권수↑에 단가↑/불변이어야 함). pricing.py :177-192 component_subtotal 코드를 직접 읽어 단가형(.01)이 ÷min_qty 미발생임 확정. **양면 계산**(÷min_qty 적용 시 GC-ST10이 3,200≠19,200으로 골든 모순)으로 cartographer 가설 반증·designer 비준.
- **DT-4 충돌 독립 결판**: DSC 링크 6/9 실재·누락 4건(173/174/175/097)을 전수 SELECT로 직접 확인(G 쿼리). designer 주장 정확.
- **dodge 없음**: 본체 0행·바인딩 0·option_items "전역 0행" 주장을 전부 라이브로 재실측(B/C/M 쿼리). option_items 전역 477행 stale를 적발(dodge 아닌 검증가 발굴).
- **self-approve 없음**: 검증가가 설계를 재유도하지 않고 라이브·코드·골든 재계산으로만 판정.

---

## 라이브 freshness (드리프트 점검)

| 객체 | upd_dt(라이브) | 설계 기술 | 정합 |
|------|----------------|-----------|------|
| PRF_TTEOKME_FIXED | 2026-06-13 | "upd_dt 2026-06-13" | ✓ |
| COMP_TTEOKME | 2026-06-17 | "use_dims 실재" | ✓(드리프트 없음) |
| 단가행 112 apply_ymd | 전건 2026-06-01 | "112행 verbatim" | ✓ |
| 본체 9 product_prices | 0행 | "0행" | ✓ |
| DSC 링크 | 6건(172/176/177/178/179/181) | "6/9 실재·4 누락" | ✓ |

설계 ↔ 라이브 어긋남 0(option_items 전역 0행 표현만 stale·E4 LOW). 날조 아닌 정합 드리프트도 없음.

---

## 컨펌큐 (designer 큐 6건 유지 + 검증 보강 1)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-ST-DSC-LINK | ★본체 173/174/175 + 떡메모 097 DSC 링크 누락=과청구. 권위 상품마스터 "구간할인적용테이블" 컬럼 재대조 후 링크 INSERT | dbmap round-1·상품마스터 | 돈크리티컬·검증 실증됨 |
| Q-ST-DSC-DOUBLE | 떡메모 unit 사다리(내장 볼륨할인) 위 DSC_STAT_QTY 곱=이중할인 의도 여부 | 실무·dbm-price-arbiter | 이중할인 방지·돈크리티컬 |
| Q-ST-MEMO1 | 메모패드(179) 2사이즈 2가격(5000/6000)=사이즈 차원 공식 vs 별 prd_cd. 라이브=단일 prd_cd 확인(별 상품 아님) | 실무·상품마스터 | 메모패드 그릇(DT-3·확신도 중) |
| Q-ST-OPT1(+정정) | 떡메모 사이즈/권당장수 옵션→차원 주입(문구 상품 option_items 0행). ★설계 "전역 0행"→"문구 상품 0행"으로 표현 정정 | round-6 dbm-option-mapper | 떡메모 매칭(0원 침묵 회피) |
| Q-ST-SIZE-LABEL(검증 보강·LOW) | 설계 §2-2 본체 사이즈 표기(먼슬리/중철노트/스프링수첩)를 권위 엑셀 실사이즈로 정밀화(A5/A6/90x145) | designer | 가격 무영향·비고 정확성 |
| DT-BIND(다음 종단) | 책자(부품 합산형)·D-BIND-SCOPE(제본비 단일 vs 부품 합산) | dbm-price-arbiter·사용자 | 이번 스코프 밖 |

---

## 라우팅

- **본체 9 product_prices INSERT(AC열 verbatim) + DSC 링크 보완 3(173/174/175)** → 인간 승인 후 dbmap(dbm-load-execution·dbm-price-arbiter). 돈크리티컬·링크 미적재 = 과청구.
- **떡메모 바인딩(PRD_000097→PRF_TTEOKME_FIXED) + DSC 링크 1(097)** → 인간 승인 후 dbmap. Q-ST-DSC-DOUBLE 이중할인 arbiter 심의 선결.
- **설계 LOW 정정 2건**(option_items "전역 0행"→"문구 0행"·사이즈 표기) → designer 폐루프(가격 무영향·문서만).
- **codex 2차(Phase 5.5)** → 오케스트레이터 reconcile(본 판정은 독립·codex 비참조).
