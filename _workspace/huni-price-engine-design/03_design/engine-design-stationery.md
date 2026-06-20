# engine-design-stationery.md — 문구 고정가형+수량구간할인 / 매트릭스형 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 산출 — 문구 종단(4번째·디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치] 다음).**
> cartographer 지도(`formula-map-stationery.md`)+benchmark 흡수(`absorption-candidates-stationery.md`·`set-pricing-patterns.md` P-6)를 종합해,
> 문구 **고정가형(본체 9)** + **매트릭스형(떡메모지 1)** 완제품의 가격공식+가격구성요소+t_prc_*/t_prd_* 단가 그릇+바인딩+수량구간할인 연결을
> 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — 데이터 그릇/바인딩/링크 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-20 · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털인쇄·아크릴·실사현수막 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).
> **★이번 스코프: 문구 시트 11상품(고정가형 본체 9 + 매트릭스형 떡메모지 1 + 준비중 PRD_000180 제외). 책자(반제품 세트·내지+표지+제본 합산)는 스코프 밖 — 다음 종단 큐(design-decisions D-BIND-SCOPE).**

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나

라이브 실측(2026-06-20)이 cartographer 지도를 거의 전부 확인했다. 문구는 **두 가격 클래스**가 명확히 분리된다.

| 클래스 | 상품 | 가격 소스 | 라이브 baseline | 핵심 작업 |
|--------|------|-----------|-----------------|-----------|
| **(A) 고정가형 + 수량구간할인** | 본체 9(만년다이어리 4·먼슬리·스프링노트/수첩·메모패드·중철노트) | 상품마스터 AC열 inline 고정가 → `t_prd_product_prices.unit_price` | **product_prices 0행·바인딩 0·DSC 링크 6/9** | 고정가 단가행 INSERT(verbatim) + DSC_STAT_QTY 링크 누락 3 보완 |
| **(B) 매트릭스형(묶음 단가)** | 떡메모지(PRD_000097) | 가격표 `엽서북떡메` → `PRF_TTEOKME_FIXED`·COMP_TTEOKME 112행 | **공식·comp·단가행 실재·바인딩 0·DSC 링크 0** | PRD_000097→PRF_TTEOKME_FIXED 바인딩 + DSC_STAT_QTY 링크 |

| 라이브 실측 (2026-06-20·읽기전용) | 값 | 설계 함의 |
|----------------------------------|----|-----------|
| **t_prd_product_prices** | PK=(prd_cd,apply_ymd)·unit_price·note·**0행** | 본체 고정가 그릇=이 테이블(차원 없음·prd_cd당 적용일별 단가 1건). 9상품 전무 → INSERT 대상 |
| **본체 9상품** | 전건 활성(use_yn=Y)·prd_typ .02(스프링노트 PRD_000177만 반제품)/.03(기성) | 바인딩 0·product_prices 0 = 가격계산 불가(source=NONE) |
| **PRF_TTEOKME_FIXED** | use_yn=Y·upd_dt 2026-06-13·COMP_TTEOKME 1배선(disp_seq=1·addtn_yn=Y) | 떡메모 공식·실재(배선됨) |
| **COMP_TTEOKME** | comp_typ=`PRC_COMPONENT_TYPE.06`(완제품)·prc_typ=`PRICE_TYPE.01`(단가형)·use_dims=`[siz_cd,bdl_qty,min_qty]`·112행·**min_qty NULL 0건**·unit 850~3200 | 매트릭스 본체·실재(값결손 0) |
| **t_prd_product_price_formulas (TTEOKME)** | **0행** | ★G-ST-2: 떡메모지 바인딩 0=가격계산 불가 |
| **t_prd_product_discount_tables (본체)** | 172/176/177/178/179/181 → DSC_STAT_QTY 실재 / **173·174·175·097 누락** | DSC 링크 부분 적재(만년다이어리 하드/레더 3 + 떡메모 누락) |
| **DSC_STAT_QTY** | "문구상품 수량별 구간할인"·use_yn=Y·DSC_TYPE.01(정률)·5구간(1~49=0%·50~99=5%·100~499=10%·500~999=15%·1000~=20%) | 본체·떡메모 공통 곱 |

**∴ 문구 설계의 핵심 3가지:**
1. **본체 9 = product_prices 직접 고정가 INSERT**(AC열 verbatim) + DSC_STAT_QTY 링크 보완. 신규 공식/comp 불요(PRODUCT_PRICE 경로는 공식 없이 작동).
2. **떡메모 = 바인딩만**(공식·comp·단가행 전부 실재·신규 mint 0). + DSC_STAT_QTY 링크.
3. **★돈크리티컬 재판정: 떡메모 ×qty 폭발 위험 없음**(§3) — cartographer의 "÷min_qty 교정안 A 적용" 가설을 라이브가 반증. unit_price=권당 단가(볼륨할인)·.01 단가형·×qty가 정답. 디지털 명함 결함(unit=묶음총액)과 단가 의미 정반대.

★ **골든 라이브 재현 확인(2026-06-20)**: COMP_TTEOKME 90x90(SIZ_000119) 100장1권(bdl_qty=100) 6권(min_qty=6)=**3,200**/권 · 600권(min_qty=600)=**1,050**/권. 70x120(SIZ_000266) 50장1권 6권=**3,000**/권. **min_qty 사다리가 내려갈수록 unit_price 하락=권당 단가의 볼륨디스카운트**(묶음총액이면 600권에서 1,050으로 떨어질 이유 없음 → 권당가 입증).

---

## 1. 계산방식 2종 — 둘 다 별 엔진 분기 아님 (frm_typ 미참조)

| 계산방식 | 정의 | 문구 상품 | 엔진 처리(engine-contract·pricing.py) |
|----------|------|----------|---------------------------------------|
| **(A) 고정가형** | 판매가 = [상품 고정단가] × 수량 − 수량구간할인 | 본체 9 | **PRODUCT_PRICE 경로**(pricing.py:312-317) — `t_prd_product_prices.unit_price × qty`(공식·comp 없이 작동). 그 후 ② `_quantity_discount`(:360) |
| **(B) 매트릭스형** | 판매가 = [사이즈][권당장수][주문권수tier] 룩업 권당단가 × 수량 − 할인 | 떡메모지 1 | **FORMULA 경로**(:320-326) — PRF_TTEOKME_FIXED·comp 1개(.01 단가형)·면적 아닌 묶음 매트릭스 차원 |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·pricing.py:8 "공식유형 frm_typ 폐기"). "고정가형"·"매트릭스형"은 별 엔진 분기가 아니라 **가격 소스 경로(PRODUCT_PRICE vs FORMULA)의 차이**일 뿐. 디지털·아크릴·실사 설계 §1과 동형(frm_typ 미참조 계약 동일).

★ **두 경로의 결정적 차이**: 본체는 공식·comp **불요**(product_prices가 곧 단가). 떡메모는 공식·comp **필요**(차원별 단가 룩업). 같은 "고정가" 어휘이나 엔진 그릇이 다르다.

---

## 2. ★(A) 본체 9상품 고정가 그릇 설계 — PRODUCT_PRICE 경로 (G-ST-1·최우선)

### 2-1. 가격 소스 결정 = t_prd_product_prices 직접 고정가 (공식 신설 불요)

라이브 pricing.py 가격 소스 우선순위(:296-326): **① TEMPLATE_PRICE → ② PRODUCT_PRICE(`t_prd_product_prices`) → ③ FORMULA**. 본체 문구는 **AC열 단일 고정가**(차원 없음·만년다이어리 1종당 1가)이므로 **② PRODUCT_PRICE 경로가 정답 그릇**이다.

- **t_prd_product_prices** 구조(라이브 실측): `prd_cd`·`apply_ymd`(PK)·`unit_price`·`note`. **차원 컬럼 없음** → 상품당 적용일별 단가 1건. 본체 문구처럼 옵션·사이즈로 단가가 안 갈리는 단일 고정가에 정확히 맞음.
- 엔진 처리(:315-317): `base_amount = unit_price × qty`. 그 후 §4 수량구간할인 자동 적용.

★ **search-before-mint 결론**: 명함/포토카드(PRF_NAMECARD_FIXED·PRF_PHOTOCARD_FIXED) "고정가형 공식+완제품 통합단가 comp" 패턴을 본체 문구에 **적용하지 않는다**. 이유:
- 명함/포토카드는 **소재(mat_cd)·사이즈(siz_cd)·세트(bdl_qty) 차원으로 단가가 갈린다** → comp+단가행 매트릭스가 필요(고정가형 공식 정당).
- 본체 문구는 **단일 고정가**(만년다이어리 소프트=9000 단 1가·차원 분기 없음) → comp/공식 그릇은 **과설계**. product_prices 1행이 무손실 표현.
- ∴ 본체 문구 = product_prices 직접가. 명함식 공식 신설 **부결**(디지털 D-4 "고정가형=comp 1배선 합산형"이 명함엔 맞으나 문구 본체엔 product_prices가 더 단순·무손실).

### 2-2. 본체 9상품 고정가 단가행 명세 (t_prd_product_prices INSERT·AC열 verbatim)

| prd_cd | 상품 | siz | unit_price(AC열 verbatim) | apply_ymd | 비고 |
|--------|------|-----|---------------------------|-----------|------|
| PRD_000172 | 만년다이어리(소프트커버) | 130x190 | **9,000** | 2026-06-01 | 미싱제본+PVC커버(BOM·가격 비기여) |
| PRD_000173 | 만년다이어리(하드커버) | 130x190 | **12,000** | 2026-06-01 | 하드커버=B셋트 표지 sub_prd·면지(생산 BOM·§5) |
| PRD_000174 | 만년다이어리(레더하드커버) | 130x190 | **15,000** | 2026-06-01 | 레더 표지·면지 |
| PRD_000175 | 만년다이어리(레더소프트커버) | 130x190 | **15,000** | 2026-06-01 | 레더+미싱제본 |
| PRD_000176 | 먼슬리플래너 | (28P 고정) | **12,000** | 2026-06-01 | page_rule 28~28~0(라이브 실재) |
| PRD_000177 | 스프링노트 | (좌철) | **4,500** | 2026-06-01 | prd_typ .02 반제품(라이브)·트윈링 |
| PRD_000178 | 스프링수첩 | (상철) | **3,000** | 2026-06-01 | 트윈링 |
| PRD_000179 | 메모패드 | 144x206 / 182x257 | **5,000 / 6,000** | 2026-06-01 | ★2 사이즈 2가격 → §2-3 분기 |
| PRD_000181 | 중철노트 | (중철) | **2,500** | 2026-06-01 | 중철제본 |

- **단가값 출처**: 상품마스터 260610 문구(가격포함) 시트 AC열 inline(formula-map-stationery §3). **designer 값 창작 0** — 위 값은 cartographer 지도가 상품마스터에서 추출한 verbatim. dbmap 적재 시 상품마스터 원본 셀 재대조 필수(검증가 E1).
- **apply_ymd**: 라이브 DSC 링크 apply_bgn_ymd=2026-06-01과 정합(동일 적용일). [[dbmap-live-load-transition-260615]] 적용일 시계열 구조 준수(2026-06-01 유지 UPSERT·신 단가행 분기 금지).

### 2-3. ★메모패드 2사이즈 2가격 (PRD_000179) — product_prices 한계와 처리

메모패드는 144x206=5,000·182x257=6,000으로 **사이즈에 따라 단가가 갈린다**. t_prd_product_prices는 **차원 없는 단일가** 그릇이라 한 prd_cd에 2가를 못 담는다. 처리 후보 2:

- **후보 ① (사이즈=차원·공식 경로)**: 메모패드만 PRODUCT_PRICE가 아니라 **FORMULA 경로**(comp use_dims=[siz_cd]·단가행 2)로 설계. 떡메모처럼 comp 1개에 siz_cd 차원으로 5,000/6,000 2행. (명함식 고정가형 공식과 동형.)
- **후보 ② (별 prd_cd)**: 144x206·182x257이 라이브에서 별 prd_cd면 각자 product_prices 1행. (라이브 PRD_000179 단일 → 현재는 1상품.)

★ **설계 권고 = 후보 ①**(사이즈 차원 공식). 근거: 메모패드는 사이즈가 가격축(5,000≠6,000)이고, product_prices는 그걸 못 담음. **컨펌큐 Q-ST-MEMO1**(메모패드 사이즈가 주문 선택축인지·별 상품인지 라이브/상품마스터 재확인). 나머지 8상품은 단일가 → product_prices 직접가. **본 설계는 메모패드를 별도 표기**(8상품 product_prices + 메모패드 1상품 사이즈 공식 후보).

### 2-4. 본체 바인딩·소스 유효성 가드 (U-7 binding-validity 계승)

- **product_prices 경로는 product_price_formulas 바인딩 불요**(공식 안 씀). 단 **메모패드(후보①·공식)는 product_price_formulas 바인딩 필요**.
- **시트 차원경계(SOT 1)**: 본체 문구 product_prices에 디지털/제본 comp 침입 없음(차원 없는 단일가라 구조적으로 불가). ✅
- **반제품 BOM ≠ 가격축[HARD]**: 하드커버(173/174)의 표지 sub_prd·면지는 `t_prd_product_sets`(생산 BOM·MES)이고 **가격은 단일 고정가 1건**. 디지털 엽서북식 내지+표지 합산 세트 레이어 **불요**(§5·set-product-design 문구 절). designer는 sets를 가격에 끌어들이지 말 것.

---

## 3. ★(B) 떡메모지 매트릭스형 — 바인딩 + ×qty 폭발 재판정 (G-ST-2/3)

### 3-1. 떡메모 가격사슬 (라이브 실재·바인딩만 0)

```
PRD_000097 떡메모지 (활성·prd_typ .04)
  └─[바인딩 0행 ← 신규]→ PRF_TTEOKME_FIXED (use_yn=Y·upd_dt 2026-06-13)
       └─ COMP_TTEOKME (disp_seq=1·addtn_yn=Y)
            comp_typ=PRC_COMPONENT_TYPE.06(완제품)·prc_typ=PRICE_TYPE.01(단가형)
            use_dims=[siz_cd, bdl_qty, min_qty] · 단가행 112(verbatim·min_qty NULL 0건)
            siz_cd: SIZ_000119(90x90)·SIZ_000266(70x120)
            bdl_qty: 50·100 (권당장수=50장1권/100장1권)
            min_qty: 6~600 (★주문 권수 tier·아래 §3-2)
            unit_price: 850~3,200 (★권당 단가)
```

**바인딩 명세 (신규 INSERT into t_prd_product_price_formulas)**:

| 바인딩 | 공식 | 근거 |
|--------|------|------|
| **PRD_000097 떡메모지 → PRF_TTEOKME_FIXED** | (apply_bgn_ymd 2026-06-01) | 공식·comp·단가행 전부 실재·바인딩만 0(명함 WIRE 동근·배선이 아니라 바인딩) |

★ **신규 mint 0** — 공식·comp·단가행·차원 전부 라이브 실재. search-before-mint 강하게 충족(아크릴 G-A1 본체 바인딩과 동형·디지털 명함보다 더 막힘이 적음).

### 3-2. ★돈크리티컬 재판정 — min_qty=주문권수 tier·unit=권당가·×qty 폭발 없음 [HARD]

> **★cartographer 가설 반증 [HARD]**: cartographer/gap-board는 "unit_price=묶음(권) 총액(3200=100장1권 6장 묶음가)·디지털 교정안 A `(unit÷min_qty)×qty` 후보"라 했다. **라이브 단가 사다리 + pricing.py 코드 검증이 이를 반증한다.**

**라이브 증거(반증불가):**

| 증거 | 값 | 출처 | 함의 |
|------|----|------|------|
| **min_qty 의미** | 한 (siz,bdl) 그룹에 28 tier(6/12/18/24/.../600) | 라이브 `t_prc_component_prices` SELECT | min_qty는 "장수구간"이 아니라 **주문 권수(주문량 tier)** |
| **unit_price 사다리** | 90x90 100장1권: 6권=3,200 → 12권=2,500 → ... → 600권=1,050 (단조 하락) | 라이브 SELECT | **min_qty↑ → unit↓ = 권당 단가의 볼륨디스카운트**. 묶음총액이면 600권에서 1,050으로 떨어질 수 없음(총액은 증가해야) → **unit=권당 단가** 확정 |
| **prc_typ** | `PRICE_TYPE.01`(단가형) | 라이브 SELECT | component_subtotal(:191-192) 단가형 분기 = `unit × qty`(÷min_qty **미발생**) |
| **min_qty TIER 방향** | min_qty='이상' 하한(pricing.py:42·:144-164)·주문수량 이하 최대 임계 선택 | pricing.py 코드 | min_qty는 **단가행 선택용**(÷ 아님)·siz_width/height '이하' ceiling과 반대 |

**∴ 확정 결론[HARD]: 떡메모 unit_price = 권당 단가, subtotal = unit × qty. ×qty 폭발 위험 없음.**

근거:
1. **min_qty는 TIER 차원(line 42·144)**: `_match_entry`가 "주문량 이하 최대 min_qty 행"을 선택(주문 30권 → min_qty=24 행 선택). component_subtotal에 들어가는 건 `prc_typ=.01`이라 `unit × qty`(÷min_qty **없음**·line 191).
2. **디지털 명함 결함과 단가 의미 정반대**: 디지털 명함(3500→350,000)은 unit=**"100매 1세트 총액"**인데 min_qty=100·.01이라 ×100 폭발. 떡메모는 unit=**"권당 단가"**(볼륨할인 사다리 입증)이고 min_qty는 ÷에 안 쓰임 → ×qty가 곧 정답. **단가 의미가 정반대라 동형 결함 아님**(아크릴 COROTTO·실사 면적과 동류·개당/권당가).
3. **÷min_qty 자체가 발생 안 함**: .01 단가형은 component_subtotal line 191(`return up * q`)로 직행. cartographer의 "교정안 A ÷min_qty 적용" = **불필요**(÷가 일어나지 않으므로). NULL min_qty 0건이라 ValueError 위험도 없음.

★ **재판정 요지**: cartographer 지도(formula-map §7·gap-board G-ST-3)의 "×qty 폭발 위험 존재·교정안 A 동형 적용 후보"는 **라이브 단가 의미 확정으로 해소**(반증). 떡메모는 디지털이 아니라 아크릴/실사 종단(개당가·×qty 안전)과 동형. **교정 불요·바인딩만 하면 정상.**

### 3-3. 떡메모 신규 단가행 INSERT 가드 (LOW·해당사항 적음)

- COMP_TTEOKME는 `.01`(단가형)이라 ÷min_qty 미발생 → **신규 행 min_qty NULL이어도 ValueError 없음**(아크릴 CLEAR3T `.02`+NULL ValueError와 다름). 단 min_qty가 TIER 선택축이므로 **NULL이면 0 취급(line 42)** → 그 행이 모든 주문량에서 후보가 되어 오선택 가능. ∴ 신규 행도 min_qty 명시 권장(일관성).
- 떡메모 단가행은 라이브 112행 verbatim 완비 → 현재 신규 INSERT 불요(가격표 28구간×2siz×2bdl=112 완전 적재 확인).

### 3-4. 떡메모 use_dims 차원 매칭 정합 (silent 이중합산 부재)

- COMP_TTEOKME use_dims=`[siz_cd, bdl_qty, min_qty]` **3차원 명시**·comp 1개·addtn_yn=Y. 디지털 인쇄면 S1+S2 silent 이중합산 구조 **부재**(공식당 comp 1개·차원 명시·NULL 와일드카드 위험 없음).
- siz_cd·bdl_qty는 NON_QTY_DIMS(:38-39) 정확매칭 → 손님이 90x90·100장1권 선택 시 그 조합 28 tier만 후보 → min_qty TIER 1행 확정. ✅ 모호성 0.

---

## 4. ★수량구간할인 연결 [HARD·돈크리티컬·본체/떡메모 공통]

### 4-1. 할인 연결 경로 (라이브 코드 확정·pricing.py:478-504)

```
evaluate_price (:360) → _quantity_discount(prd_cd, amount, qty, as_of)
  └─ t_prd_product_discount_tables.filter(prd_cd) → dsc_tbl_cd 링크 (:482-483)
       └─ t_dsc_discount_tables(헤더·dsc_typ_cd) (:487-488)
            └─ t_dsc_discount_details.filter(dsc_tbl_cd) → 구간 (:491)
                 └─ pick_discount_detail(min_qty≤qty≤max_qty·최신) (:493)
                      └─ apply_discount(amount, dsc_typ, rate, amt) (:497)
```

★ **핵심[HARD]**: 할인은 **`t_prd_product_discount_tables`의 prd_cd→dsc_tbl_cd 링크**가 있어야 작동. **이 링크 누락 = 구간할인 0 적용 = 정가 과청구(돈크리티컬)**. component_prices/product_prices와 별개의 링크 테이블.

### 4-2. DSC_STAT_QTY 라이브 실측 (문구 공통 할인테이블)

- **dsc_tbl_cd=DSC_STAT_QTY** "문구상품 수량별 구간할인"·use_yn=Y·dsc_typ_cd=`DSC_TYPE.01`(정률).
- **구간 디테일(t_dsc_discount_details)**: 1~49=**0%** · 50~99=**5%** · 100~499=**10%** · 500~999=**15%** · 1000~=**20%**(apply_ymd 2026-06-01·정률).

### 4-3. ★본체/떡메모 링크 실상 + 보완 명세 (3 누락)

| prd_cd | 상품 | DSC_STAT_QTY 링크(라이브) | 작업 |
|--------|------|---------------------------|------|
| PRD_000172 만년다이어리(소프트) | ✅ 실재(2026-06-01) | — |
| **PRD_000173 만년다이어리(하드)** | ❌ **누락** | 링크 INSERT(DSC_STAT_QTY) |
| **PRD_000174 만년다이어리(레더하드)** | ❌ **누락** | 링크 INSERT |
| **PRD_000175 만년다이어리(레더소프트)** | ❌ **누락** | 링크 INSERT |
| PRD_000176 먼슬리 | ✅ 실재 | — |
| PRD_000177 스프링노트 | ✅ 실재 | — |
| PRD_000178 스프링수첩 | ✅ 실재 | — |
| PRD_000179 메모패드 | ✅ 실재 | — |
| PRD_000181 중철노트 | ✅ 실재 | — |
| **PRD_000097 떡메모지** | ❌ **누락** | 링크 INSERT(DSC_STAT_QTY) |

★ **돈크리티컬 보완 4건**: 173·174·175(만년다이어리 하드/레더 3) + 097(떡메모). 링크 미연결 시 그 상품은 **수량 늘려도 할인 0=정가 과청구**. dbmap round-1(구간할인 매핑·GO·미적재) 트랙 정합 — 링크 INSERT(prd_cd→DSC_STAT_QTY·apply_bgn_ymd 2026-06-01). **권위=상품마스터 "구간할인적용테이블" 컬럼**(상품명 추측 금지·[[dbmap-discount-authority]]).

### 4-4. 할인 적용 순서 (엔진 단일 경로·별 설계 불요)

```
① base_amount   (본체=product_prices unit×qty / 떡메모=comp subtotal Σ)
② 수량구간할인   (_quantity_discount: DSC_STAT_QTY·정률 rate% — 50권이면 5% 할인)
③ 등급할인       (_grade_discount: 선택적)
   → ②③ 순차 곱·final_price = round_won
```

- 본체·떡메모 둘 다 동일 엔진 경로(:356-369). 별도 분기 없음.
- ★**이중할인 가드[HARD]**: 떡메모 unit_price 사다리(min_qty=주문권수별 단가 하락)는 **comp 단가행 내장 볼륨할인**이다. 그 위에 DSC_STAT_QTY까지 곱하면 **이중 볼륨할인**(실사 미니류 DS-3 동형 위험). **단, DSC_STAT_QTY 구간(권수)은 명함/굿즈류 공통 정률이고 떡메모 unit 사다리는 권당가 자체의 하락**이라 의미가 다를 수 있음 → **컨펌큐 Q-ST-DSC-DOUBLE**(떡메모에 DSC_STAT_QTY 링크가 의도된 추가할인인지·이중할인인지 실무 확인). 본체 9상품은 단일 고정가라 이중할인 위험 없음(DSC 단일 적용 정상).

---

## 5. 완제품 vs 반제품(세트) — 가격축 경계 (G-ST-5)

| 구분 | 문구 상품 | 가격 처리 |
|------|----------|-----------|
| **반제품(구조)·단일 고정가(가격)** | 만년다이어리 하드/레더(173/174=표지 sub_prd·면지 sets)·먼슬리·스프링노트/수첩·메모패드·중철노트 | 구조는 내지+표지+제본 반제품(생산 BOM·`t_prd_product_sets`)이나 **가격은 product_prices 단일 고정가 1건**. 디지털 엽서북식 내지단가+표지단가 합산 세트 레이어 **불요** |
| **완제품(낱장 묶음)** | 떡메모지(097) | 표지 없음·내지만·권 단위. COMP_TTEOKME 단일 완제품가 |

★ **반제품 가격 주의[HARD] (디지털 엽서북 세트와 결정적 차이)**: 디지털 엽서북은 내지·표지가 별 SKU 행 분리단가 합산(세트조합 레이어 필요·D-5). **문구 반제품은 구조만 반제품(생산 BOM)이고 가격은 단일 고정가 1건** — 내지단가+표지단가 합산 세트 레이어가 **필요 없다**. 하드커버 표지 sub_prd는 가격축이 아니라 생산(sets) 정보. set-product-design.md 문구 절에 명시(이중계상 가드).

★ **책자(중철책자/무선책자/PUR/하드커버무선·엽서북)는 이번 스코프 밖** — 책자는 표지+내지+제본 **부품 합산형**(calc-draft row 63~91·세트 그릇 t_prd_product_sets 28행·page_rules 11행·제본 comp 11종 보유). 문구 반제품과 구조 동근이나 가격 클래스 이질(합산 vs 단일고정). 다음 종단 큐(design-decisions D-BIND-SCOPE·제본비 prc_typ).

---

## 6. CPQ 옵션 (G-ST-4·가격 비기여 대부분)

본체 문구 가격은 **단일 고정가**라 옵션(제본 택일·링컬러·면지·무지내지·page_rule)이 대부분 **가격 비기여**(생산 UI·MES). 떡메모는 사이즈/권당장수가 comp 차원(가격축).

| 항목 | 가격 처리 | 선택 처리 | 그릇 |
|------|----------|----------|------|
| **제본 택1(중철/미싱/트윈링/떡제본)** | 가격 비기여(고정가에 포함) | 생산 UI 택1 | round-6 CPQ option_group(택1)·가격 무관 |
| **트윈링 좌철/상철(스프링노트/수첩)** | 가격 비기여 | proc param | round-6 CPQ |
| **page_rule(먼슬리 28 고정·떡메모 장수 3)** | 가격 비기여(고정 책자) | 입력 차원 | t_prd_product_page_rules(라이브 실재) |
| **떡메모 사이즈(90x90/70x120)·권당장수(50/100)** | **가격축**(COMP_TTEOKME use_dims) | 택1 → siz_cd·bdl_qty 주입 | round-6 CPQ option→차원 주입 |
| **면지 색상(하드커버 화이트/블랙/그레이)** | 가격 비기여(단일 고정가) | sets sub_prd | t_prd_product_sets(생산 BOM) |

- **문구 상품 CPQ 옵션 전무**(본체 9·떡메모·메모패드 option_items 0행 — 라이브 전역은 477행[굿즈/악세사리류]이나 문구 상품엔 미연결·validator 2026-06-20 정정). 옵션→차원 자동주입은 option_items 미연결(디지털 G-7 동형) → 떡메모 사이즈/권당장수 선택값이 selections에 실리는 주입 레이어 선결(round-6 dbm-option-mapper). 미연결 시 떡메모는 디폴트 siz_cd/bdl_qty 필요(0원 침묵 회피). **컨펌큐 Q-ST-OPT1**.

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격 소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ 본체=PRODUCT_PRICE(차원 없는 단일가 무손실)·떡메모=FORMULA(차원 단가). 명함식 공식 본체 적용 부결(과설계) |
| C7 frm_typ 미참조·공식=합산 | ✅ 떡메모 comp 1배선 합산형(frm_typ 무참조)·본체는 공식 안 씀 |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이) | ✅ COMP_TTEOKME 3차원 정확매칭(siz_cd·bdl_qty NON_QTY_DIMS)+min_qty TIER 1행 → 모호성 0 |
| P3-DEF 판별차원 없음 / silent 이중합산 | ✅ 떡메모 comp 1개·use_dims 3차원 명시(addtn_yn=Y 단일)→구조적 이중합산 불가. 본체 product_prices 차원 없음(단일가)→침입 불가 |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ COMP_TTEOKME `.01` 단가형·unit×qty(÷ 미발생·min_qty NULL 0건). 본체 product_prices unit×qty. **÷min_qty 교정 불요**(§3-2 반증) |
| TIER min_qty '이상' 하한(:42·144) | ✅ 떡메모 min_qty=주문권수 tier·주문량 이하 최대 임계 선택(권당 단가) |
| 수량구간할인 연결(:478-504) | ✅ DSC_STAT_QTY 링크(t_prd_product_discount_tables)·본체 3+떡메모 1 누락 보완(§4-3)·돈크리티컬 |
| U-7 시트 차원경계(SOT 1) | ✅ 본체 product_prices=단일가(디지털/제본 comp 침입 불가)·떡메모 COMP_TTEOKME 1개(타 comp 침입 없음)·반제품 sets=가격축 아님(§5) |
| 할인 적용 순서(:356-369) | ✅ ① base → ② DSC_STAT_QTY → ③ 등급(엔진 단일 경로) |
| search-before-mint | ✅ **신규 mint 0** — 본체=product_prices INSERT(공식/comp 신설 0)·떡메모=바인딩만(공식/comp/단가행 재사용)·DSC_STAT_QTY 재사용(링크 INSERT만). 디지털 대형박·아크릴 미러/카라비너 같은 신규 comp/공식 **전무** |

---

## 8. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **G-ST-1 본체 9 product_prices INSERT**(§2·AC열 verbatim) + **DSC_STAT_QTY 링크 3 보완**(173/174/175) = 1순위(가격계산 불가·과청구 직결).
- **G-ST-2 떡메모 바인딩**(§3·신규 mint 0) + **DSC_STAT_QTY 링크 1**(097) = 1순위.
- **G-ST-3 ×qty 재판정**(§3-2) = 해소(반증·교정 불요)·골든으로 입증(golden-cases).
- **메모패드 2사이즈 2가격**(§2-3) → 컨펌큐 Q-ST-MEMO1(사이즈 차원 공식 vs 별 상품).
- **떡메모 이중할인**(§4-4) → 컨펌큐 Q-ST-DSC-DOUBLE(DSC_STAT_QTY가 unit 사다리 위 추가할인 의도인지).
- **CPQ 옵션 주입**(§6) → 컨펌큐 Q-ST-OPT1(round-6).
- **책자(부품 합산형)** → design-decisions D-BIND-SCOPE 다음 종단 큐(이번 스코프 밖).

실 적용(product_prices INSERT·떡메모 바인딩·DSC 링크 INSERT)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-axis-staged-load·dbm-price-arbiter).
