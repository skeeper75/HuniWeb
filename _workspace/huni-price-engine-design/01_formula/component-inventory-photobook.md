# component-inventory-photobook — 포토북 가격구성요소 통합 인벤토리

> 포토북(반제품 세트) 가격구성요소·차원·단가소스·재사용 후보 vs 신규 mint. search-before-mint. 라이브 읽기전용 실측(2026-06-22).

---

## 1. 재사용 가능 (기존 PRF_*/COMP_* — 신규 mint 0)

| 구성요소 | comp_cd | prc_typ | use_dims | 라이브 상태 | 재사용 근거 |
|----------|---------|---------|----------|-----------|-------------|
| **표지/내지 인쇄비** | **COMP_PRINT_DIGITAL_S1** | PRICE_TYPE.01 단가형 | proc_cd·plt_siz_cd·print_opt_cd·min_qty·proc_grp:PROC_000001 | ✅ 212행(단/양면·국4절 tier 실재) | 디지털·캘린더 직계 동형(PRF_DGP·PRF_CAL 공유) |
| **표지/내지 용지비** | **COMP_PAPER** | PRICE_TYPE.01 단가형 | siz_cd·mat_cd | 🟡 몽블랑130 1행(SIZ_499=77.03)·아트250 0행 | 내지 몽블랑130 재사용·표지 아트250 단가행 추가 적재 필요 |
| **제본비 PUR** | **COMP_BIND_PUR** | PRICE_TYPE.01 단가형 | proc_cd·min_qty·proc_grp:PROC_000017 | ✅ 8행(5000~1500/부·PROC_000020) | 책자 PUR책자(PRD_000070·PRF_BIND_SUM) 동일 comp 직계 재사용 |

> ★3 comp 전부 라이브 실재 — 디지털/캘린더/책자가 공유하는 chassis. 포토북 신규 comp 최소.

### 1.1 COMP_BIND_PUR 단가행 (라이브 verbatim·proc_cd=PROC_000020)

| min_qty(부) | unit_price |
|------------:|-----------:|
| 1 | 5,000 |
| 4 | 5,000 |
| 10 | 5,000 |
| 30 | 4,000 |
| 50 | 3,000 |
| 70 | 2,500 |
| 100 | 2,000 |
| 1,000 | 1,500 |

> 출처: 라이브 SQL `t_prc_component_prices WHERE comp_cd='COMP_BIND_PUR'`. 부당가(.01 단가형 ×부수). 확신도 **높음**.

### 1.2 COMP_PRINT_DIGITAL_S1 국4절(SIZ_499) tier (라이브 verbatim·발췌)

| print_opt | proc | q1 | q10 | q100 | q300 |
|-----------|------|---:|----:|-----:|-----:|
| POPT_000001 단면 | PROC_000004 | 3,000 | 500 | 200 | 110 |
| POPT_000002 양면 | — | 4,000 | 1,000 | (생략) | — |

> 출처: 라이브 SQL. 내지=양면(POPT_000002)·표지=단면(POPT_000001). 확신도 **높음**.

---

## 2. 신규 mint 후보

| 구성요소 | 후보 코드 | 사유 | search-before-mint |
|----------|-----------|------|--------------------|
| **포토북 세트 공식** | **PRF_PHOTOBOOK_SUM** | 부모 PRD_000100 부품합산 공식 부재 | 책자 PRF_BIND_SUM 공유 검토→부품집합 상이(표지 variant 택1+per2p 페이지)면 신설. designer E5 결정 |
| **표지비 comp**(소재 분기) | (COMP_PRINT_DIGITAL_S1+COMP_PAPER로 충당 가능) | 표지 mat_cd(아트250/레더) 분기·코팅 가산 | 가급적 기존 comp + mat_cd 차원 분기(신규 comp 회피) |
| **base24 상품단가 comp** | **COMP_PHOTOBOOK_BASE?** (또는 product_prices base) | variant 고정 상품단가(15000 등)를 어떻게 담나 | designer 결정(base comp vs 부품 분해)·Q-PB-GOLDEN |
| **표지 코팅(무광)** | (코팅 comp 탐색) | 아트250+무광코팅 가격기여 | 라이브 코팅 comp 검색 필요(Q-PB-COAT) |

> ★권고: 신규 comp 최소화. 표지/내지=기존 3 comp + mat_cd/print_opt/페이지 차원으로 충당. base24만 처리 방식(base comp vs 부품 Σ) designer 결정.

---

## 3. 차원(use_dims) 후보 맵

| 가격구성요소 | 차원 | 비고 |
|--------------|------|------|
| 표지 인쇄 | print_opt(단면)·plt_siz·proc·min_qty | COMP_PRINT_DIGITAL_S1 |
| 표지 용지 | siz_cd·mat_cd(아트250/레더) | COMP_PAPER·표지소재 택1 |
| 내지 인쇄 | print_opt(양면)·plt_siz·**페이지수(수량배수)** | COMP_PRINT_DIGITAL_S1·G-PB-PAGE |
| 내지 용지 | siz_cd·mat_cd(몽블랑130)·**페이지수(수량배수)** | COMP_PAPER |
| 제본 PUR | proc_cd(PROC_000020)·min_qty·proc_grp:PROC_000017 | COMP_BIND_PUR·부당가 |
| 면지 | (가격기여 BLOCKED·Q-PB-FACE) | — |

> **★페이지수 = 수량배수**(캘린더 동형): comp 자체는 페이지 차원 미보유·앱이 총출력판수=주문수량×페이지수/판걸이수로 주입. G-PB-PAGE(페이지 곱 누락=내지비 소실).

---

## 4. 전 종단 재사용 누계 (search-before-mint 연속)

| 종단 | 재사용 핵심 | 신규 mint |
|------|------------|-----------|
| 캘린더(9번째) | COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_CAL_* | PRF_CAL_* 5·COMP_CALOPT 1 |
| **포토북(10번째)** | **COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_PUR**(3 comp 전부 재사용) | **PRF_PHOTOBOOK_SUM 1**(+base 처리 designer 결정) |

> 포토북 = 인쇄/용지/제본 3 comp 전부 재사용 = search-before-mint 10연속. 신규 comp 0~1(base24 처리 방식 designer).
