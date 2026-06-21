# gate-verdict-calendar.md — 캘린더 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 재실측 — 생성자(hpe-engine-designer) 주장 비신뢰·라이브 직접 SELECT(2026-06-22 읽기전용)·권위 엑셀 절대.**
> 검증 대상: `03_design/engine-design-calendar.md`·`golden-cases-calendar.md`·`design-decisions.md`(D-CAL-1~8).
> 기준점: `01_formula/{formula-map,component-inventory,gap-board}-calendar.md`·`02_benchmark/absorption-candidates-calendar.md`.
> 라이브 권위: `pricing.py`(`raw/webadmin/webadmin/catalog/pricing.py`)·Railway t_prc_*/t_prd_*.

---

## 종합: **GO** (E1~E7 전건 PASS·차단 0·보정 0·LOW 1)

캘린더 종단 = 9번째 종단. designer 설계를 라이브 직접 SELECT + pricing.py 코드 + python 골든 재산출로 독립 재실측한 결과, **돈크리티컬 사안 전부 라이브로 입증되고 골든 9/9(제본 6 + 가공 3) 허용오차 0 재현**됐다. inline 합산 골든 BLOCKED는 독립 역산으로 **정당함(추측 단가 회피=정직)** 확인. 단일 LOW(WALL 단가행 행수 "42→24행" 오기·가격 무관).

| 게이트 | verdict | 핵심 근거(라이브 실측) |
|--------|---------|------------------------|
| E1 공식 추출 충실성 | **PASS** | calc-draft r94~98 원자합산 명문·두 시트 매핑 충실·v03 인용 0 |
| E2 구성요소 분해 정합 | **PASS** | 인쇄/용지/제본/가공 4비목 시트경계 안·proc 이원화 정합·페이지수 곱 차원 명시 |
| E3 경쟁사 흡수 타당성 | **PASS** | naming 유입 0(CLD_STD/RIN_/offset/vtmpl 흔적 0건)·새 축 0·갭헌팅만 |
| E4 엔진 설계 건전성 | **PASS** | pricing.py 계약 정합·제본비 .01 결판 코드 입증·search-before-mint(공식5+comp1만 신규) |
| E5 세트 조합 정합 | **PASS** | t_prd_product_sets 0행·본체 단일+가공 가산·이중계상 0·봉투=addon 위임 |
| E6 골든 재현 | **PASS** | 제본 6/6 + 가공 3/3 허용오차 0(python 재산출)·inline BLOCKED 정당(역산 비정수해) |
| E7 생성검증 독립성 | **PASS** | 직접 재실측·dodge 0(BLOCKED 정직 입증)·주장 무비판 수용 없음 |

---

## E1 — 공식 추출 충실성 · **PASS**

**검사**: cartographer 지도가 상품마스터 공식·가격표 차원을 충실히 담았나.

- calc-formula-draft r94 `[원자합산형: 캘린더]`·r95 `판매가=인쇄비+용지비+(제본비 or 캘린더가공비)`·r96~98 = formula-map §2 정본 인용. 셀 단위 충실.
- 두 시트(`캘린더`·`디자인캘린더(가격포함)`) 구조 정합: `캘린더`=업로드형 골격(variant enum), `디자인캘린더`=편집기형 대표 1행 inline. prd_cd·MES 007-0001~0005 1:1 일치(라이브 실측).
- 1차 가설(variant 고정가형=굿즈 GP-2) 반증 = calc-draft 명시 라벨 권위로 정확.
- **v03 인용 0**·STALE 0. 권위 순서(상품마스터>가격표>라이브>역공학) 준수.

증거 SQL: `SELECT prd_cd, prd_nm, prd_typ_cd, editor_yn FROM t_prd_products WHERE prd_cd IN ('PRD_000108'..'PRD_000112')` → 5상품 전부 PRD_TYPE.04·엽서캘린더만 editor_yn=N(업로드형)·나머지 Y. formula-map §1 인벤토리와 일치.

---

## E2 — 구성요소 분해 정합 · **PASS**

**검사**: 가격구성요소가 시트 차원경계(SOT 1) 안인가·silent 합산 오배선·이중 인코딩·완제품/반제품 오구분.

- **시트 차원경계(U-7)**: PRF_CAL_*=인쇄비+용지비+제본비+가공비 4비목만. 타 상품군 comp 침입 0(아크릴 면적·책자 부품 등 미혼입). SOT 1 준수.
- **페이지수(장수) 곱 차원**: 인쇄비·용지비의 load-bearing 차원으로 명시(§2.2·D-CAL-3). 출력매수 = 주문수량 × 페이지수 / 판걸이수. **누락 시 4~16배 과소청구 정확히 식별**(G-CAL-PAGE). comp 자체는 페이지수 차원 미보유(엽서 chassis 동형·수량 배수로 흡수)=정합.
- **proc_cd 이원화(GAP-5)**: 라이브 실측 — 상품 바인딩 proc(PROC_000021 트윈링/76 수축포장/79 타공)=생산BOM·MES vs 제본비 단가행 proc(99~102 캘린더제본)=가격룩업. **완전 별개로 정확히 분해**. 의미축 이중 인코딩 아님(생산축 vs 가격축 분리).
- **인쇄면/색=print_opt_cd 흡수**: 별도 도수 comp 분할 금지(별색=공정 동형). silent 합산 회피.
- **완제품/반제품 구분**: 캘린더 본체=완제품 단일 공식·세트 아님(E5).

증거 SQL:
```
-- proc 이원화: 상품 바인딩 vs 가격행 proc 별개
SELECT prd_cd, proc_cd FROM t_prd_product_processes
  WHERE prd_cd IN ('PRD_000108'..'PRD_000112') AND del_yn='N';
  → 108/109=PROC_000076·110=079·111=021+079·112=021  (생산BOM)
SELECT DISTINCT proc_cd FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_BIND_CAL%';
  → PROC_000099/100/101/102  (가격룩업·캘린더제본)  ★두 집합 disjoint
```

---

## E3 — 경쟁사 흡수 타당성 · **PASS**

**검사**: benchmark 흡수가 답습 아닌 흡수인가·naming/codes 유입 0·후니 표현력으로 담김.

- **AC-1(제본/거치대 부당×수량 매트릭스)**: RedPrinting 실측(삼각대 사이즈/수량 종속 단가)을 후니 B03 그릇(COMP_BIND_CAL_* use_dims=[proc_cd,min_qty])이 동형 표현. data/배선-gap이지 vessel-gap 아님 — 정확 판정.
- **AC-2(가공 inline 고정가 add-on)**: LINEN_FINISH opt_cd 그릇 재사용·평탄화 가드. 굿즈 GP-2·악세사리 AC-2 선례 동형.
- **새 가격축·t_prc_* 테이블 mint = 0**(price_gbn 4분기=frm_cd 라우팅 흡수). search-before-mint 9연속.
- **naming 유입 0(라이브 실측)**: `SELECT count(*) FROM t_prc_price_components WHERE comp_cd ~* 'CLD_|RIN_|HOL_|offset|vtmpl|edicus'` → **0건**. frm 동일 → **0건**. CLD_STD/RIN_DFT/offset2023 후니 유입 0.
- 권위 덮어쓰기 0: CQ-1(제본/가공 그릇 이중성)에서 "상품마스터+가격표 교차가 최종 권위·경쟁사=갭헌팅 보강" 명시.

---

## E4 — 엔진 설계 건전성 · **PASS**

**검사**: evaluate_price(pricing.py) 계약 정합·search-before-mint·채번·FK·차원 자동매칭.

### E4-a. ★제본비 prc_typ=.01 단가형 결판 (돈크리티컬·라이브+코드 독립 재확인)

라이브 직접 SELECT:
```
SELECT comp_cd, prc_typ_cd, use_dims, del_yn FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_BIND_CAL%';
COMP_BIND_CAL_DESK130|PRICE_TYPE.01|["proc_cd","min_qty","proc_grp:PROC_000017"]|Y
COMP_BIND_CAL_DESK220|PRICE_TYPE.01|...|Y
COMP_BIND_CAL_DESKMINI|PRICE_TYPE.01|...|Y
COMP_BIND_CAL_WALL|PRICE_TYPE.01|...|N
```
**4 comp 전부 PRICE_TYPE.01·use_dims=[proc_cd,min_qty,proc_grp:PROC_000017] — designer 주장 verbatim 일치.**

pricing.py 코드 입증(`component_subtotal` :177-188):
- 단가형(.01): `unit_price × qty`(:180·:186분기) — 부당가 ×수량 = 정답.
- 합가형(.02): `unit_price ÷ min_qty × qty`(:181), **min_qty 없으면 `ValueError`(:186-188)** — .02 오적용 시 ÷min_qty 1/N 붕괴 실재. G-CAL-BIND 돈크리티컬 입증.

### E4-b. PRODUCT_PRICE 선점 가드 (G-CAL-2·코드 입증)

pricing.py :315-330:
```
if cur_pp and cur_pp["unit_price"] is not None:   # product_prices 존재 시
    source = source or "PRODUCT_PRICE"            # FORMULA보다 선점
...
source = source or "FORMULA"                       # (:324)
if source != "FORMULA":                            # (:330) → components 미계산
```
**product_prices 1건이라도 INSERT하면 FORMULA(원자합산) 통째 우회 silent** — 코드로 입증. 라이브 캘린더 product_prices **0행**(`SELECT count(*) … WHERE prd_cd IN (108..112)` → 0)이라 선점 위험 0·자동 충족. designer "INSERT 금지·formula 바인딩만" 가드 정당.

### E4-c. search-before-mint

라이브 실측: COMP_PRINT_DIGITAL_S1(212행·.01)·COMP_PAPER(.01)·LINEN_FINISH·PRF_DGP_A~F **전부 실재**(재사용 대상). COMP_CALOPT_* **부재**(신규 mint 정당). 신규 = 공식5(PRF_CAL_*) + comp1(COMP_CALOPT_STAND) + opt_cd 채번뿐 — **불필요 mint 0·search-before-mint 9연속 통과**.

### E4-d. 차원 자동매칭·ERR_AMBIGUOUS 회피

pricing.py NON_QTY_DIMS(:38)에 proc_cd·opt_cd 포함·ERR_AMBIGUOUS(:54·비수량 2개 이상 동시매칭). designer의 제본방식별 전용 PRF + proc_cd 판별차원 분기 = 동시매칭 회피 정합. WALL 통합 comp에 proc_cd 주입으로 4 proc 중 정확 1행 매칭.

---

## E5 — 세트(반제품) 조합 정합 · **PASS**

**검사**: 세트 합성 무모순·이중계상·구성품 누락·번들 할인.

- 라이브 실측: `SELECT count(*) FROM t_prd_product_sets WHERE prd_cd IN (108..112)` → **0행**. 캘린더=본체 단일 prd(내지/표지 분리 행 없음). 책자 BOOKLET 부품합산 세트와 결정적 다름 — 정확.
- 본체 단일 공식 + 가공 add-on 가산(Σ)·이중계상 0.
- 캘린더봉투(PRD_000005·PRD_TYPE.03) = addon 경계·봉투제작 트랙 위임(엽서 봉투 동형). 본체 공식에 미혼입 — 정합.
- 엽서캘린더 우드거치대 `캘린더가공`(4000)과 `추가상품`(4000) 이중 표기를 **가공 add-on으로 단일화**(이중 합산 금지·GAP-4) — 정확.

---

## E6 — 골든 재현 (허용오차 0) · **PASS**

**검사**: 설계 공식으로 골든 실제 재계산(python·pricing.py 동치). 상세 = `recompute-log-calendar.md`.

### 제본비 골든 (단가형 .01 ×qty·라이브 verbatim)
| 골든 | tier 단가(라이브) | 재현값 | 기대 | 결과 |
|------|-------------------|--------|------|------|
| GC-CAL-1 탁상220 q1 | 5000 | 5,000 | 5,000 | **PASS** |
| GC-CAL-2 탁상220 q4 | 4000 | 16,000 | 16,000 | **PASS**(.02오답=4000 붕괴) |
| GC-CAL-3 탁상220 q100 | 2300 | 230,000 | 230,000 | **PASS** |
| GC-CAL-4 미니 q10 | 2500 | 25,000 | 25,000 | **PASS** |
| GC-CAL-5 벽걸이 q50 | 2500 | 125,000 | 125,000 | **PASS** |
| GC-CAL-6 탁상130 q1000 | 2000 | 2,000,000 | 2,000,000 | **PASS** |

### 가공 add-on 골든 (opt_cd 판별)
| GC-CAL-7 우드 q1 | 4000 → **4,000 PASS** | GC-CAL-8 타공 q10 | 1000 → **10,000 PASS**(우드4000 아님·평탄화 가드) | GC-CAL-9 2구타공 q1 | 1500 → **1,500 PASS** |

### 단가행 verbatim 대조
GC-CAL-10 국4절 단면 min1=3000·GC-CAL-11 용지 몽블랑190g=112.58·GC-CAL-12 3절 단면 min1=3500 — **전부 라이브 verbatim 일치**(날조 0).

### ★inline 합산 골든 BLOCKED 재판정 (독립 역산)
**designer 판정=BLOCKED(정직). 검증 결론=BLOCKED 정당(designer 오류 아님).**
독립 python 역산(qty=1·제본비 빼고 인쇄+용지 잔여가 출력판수 정수해를 주는지):
| 상품 | inline | 제본 | 인쇄+용지 잔여 | 출력판수(잔여÷판당) | 정수? |
|------|--------|------|----------------|---------------------|-------|
| 탁상220 | 10,400 | 5,000 | 5,400 | 1.313 | ❌ |
| 미니 | 6,500 | 4,500 | 2,000 | 0.486 | ❌ |
| 엽서 | 4,000 | 0 | 4,000 | 1.285 | ❌ |
| 벽걸이 | 9,900 | 5,000 | 4,900 | 1.574 | ❌ |
| 와이드 | 24,000 | 5,000 | 19,000 | (3절·종이단가 미상) | — |

**어느 케이스도 정수 출력판수 해 없음** → inline은 단가행 합산 결과가 아니라 에디터형 1부 정찰가 스냅샷. **추측 단가 product_prices INSERT 회피 = 정당한 honest-BLOCKED**(dodge 아님). 권위 충돌(단가행 산식 vs inline 정찰가)을 Q-CAL-GOLDEN 인간 컨펌으로 정직 표기 — 옳음.

---

## E7 — 생성-검증 독립성 · **PASS**

- 본 검증은 designer 산출값을 신뢰하지 않고 **라이브 직접 SELECT·pricing.py 코드 읽기·python 골든 독립 재산출**로 교차. self-approve 0.
- **dodge-hunt 결과**: designer가 회피한 inline 골든을 독립 역산으로 재판정 → BLOCKED 정당 확인(designer 산식 오류 아님). 회피 결함 0.
- designer 주장 중 **수치 1건(WALL 42행) 라이브 실측으로 24행 정정**(아래 LOW-1) — 주장 무비판 수용 안 함.

---

## 결함 보드

| ID | 등급 | 내용 | 라이브 실측 | 처리 |
|----|------|------|-------------|------|
| **LOW-1** | LOW | designer §0·§3.5 "WALL 통합 42행" | 실측 **24행**(4 proc × 6 tier) | 행수 오기·**가격 결과 무관**(단가 verbatim 동일·구조 판정[4 proc 통합]은 정확). 적재 시 행수 표기만 정정 |

**차단(NO-GO) 결함 0 · 보정 폐루프 항목 0.**

---

## 돈크리티컬 가드 실재성 (라이브+코드 입증 종합)

| 가드 | 실재성 | 입증 |
|------|--------|------|
| **G-CAL-BIND**(.01 유지) | ✅ 실재 | 라이브 4 comp .01·pricing.py :180/186 단가형 ×qty·GC-CAL-2 .02오답=4000 붕괴 |
| **G-CAL-PAGE**(페이지수 곱) | ✅ 실재 | calc-draft r96 명문·누락 시 4~16배 과소청구·comp 차원 미보유=수량 배수 흡수 정합 |
| **G-CAL-1 평탄화** | ✅ 실재 | GC-CAL-7(4000) vs 8(1000) opt_cd 판별·NON_QTY_DIMS에 opt_cd 포함 |
| **G-CAL-2 선점** | ✅ 실재 | pricing.py :315-330 product_prices 선점→FORMULA 우회 silent·라이브 0행 자동충족 |

---

## 컨펌큐 (차단 아님·인간/designer 라우팅)

designer가 정직 표기한 8건 전부 검증가 동의 — Q-CAL-GOLDEN(inline 권위·BLOCKED)·Q-CAL-BIND-DELYN(WALL통합 vs DESK부활)·Q-CAL-FIN(가공 ×수량 vs 정액)·Q-CAL-PROC-INJECT(option_items 적재)·Q-CAL-DESK130·Q-CAL-PLATE·Q-CAL-PKG·Q-CAL-ENVELOPE. 전부 차단 아님·추측 회피 정직.
