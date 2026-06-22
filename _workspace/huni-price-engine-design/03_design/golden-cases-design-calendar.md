# golden-cases-design-calendar.md — 디자인캘린더 설계 대표 케이스 + 기대 골든값

> **핵심 설계가(hpe-engine-designer) 산출 — 디자인캘린더 종단 골든(11번째·최종).** 설계 공식으로 계산되는 대표 케이스와 기대 골든값.
> 검증가(hpe-validator)·codex가 라이브 `evaluate_price`를 실호출/재구현해 **이 골든값을 재현**한다(허용오차 0).
>
> **★순환참조 금지[HARD]**: 골든값은 **상품마스터 inline 정찰가 verbatim·상품마스터 추가가격 verbatim**에서 가져온다. 설계가 만든 값이 아니다(비정수 역산 산식 단가 날조 0).
> 출처 = 상품마스터260610 디자인캘린더 inline(`design-calendar-l1.csv` row 2/3/6/7/8/10/11 verbatim) · 우드거치대=상품마스터 추가가격 · 단가값 verbatim.
> 계산 규칙 = engine-contract(P3~P4): 고정가형(.01 단가형·min_qty=1·라이브 .03 부재) `subtotal = inline 정찰가 룩업(siz_cd)` · 단가형(.01) `subtotal = unit_price × qty`.
> ★**prc_typ 표기 [validator 라이브 재실측 2026-06-22]**: 라이브 PRICE_TYPE enum = `.01·.02`뿐(`.03` 부존재). "고정가형 정찰가"는 **.01 단가형 + min_qty=1 단일 단가행**(정찰가=1부 단가)으로 표현. ★**qty 의미 [codex D1]**: `.01 단가형`은 항상 `1부 정찰가 × qty`(min_qty=1은 티어 키이지 qty-불변 아님)·견적가=정찰가×qty(G-DCAL-QTY).

---

## 0. 골든 케이스 도출 원칙 — 디자인캘린더 (★inline=권위·정찰가형·산식 합산 골든은 BLOCKED)

- **본체 정찰가 골든** = 상품마스터 inline 정찰가 직독(siz_cd 룩업·.01 단가형 min_qty=1 고정가). **inline verbatim 재현 가능**(허용오차 0·정찰가 채택 ① 경로).
- **우드거치대 add-on 골든** = COMP_CALOPT_STAND opt_cd 단가행(4000)·캘린더 종단 신규 mint comp 선행 의존(현 라이브 0행). 단가형 .01 ×qty.
- **★inline 합산 산식 골든**(인쇄+용지+제본으로 inline 재구성) = **재현 불가**(BLOCKED 정직·아래 §3). inline은 단가행 합산 결과가 아닌 정찰가 스냅샷(유효판수 비정수)이므로, "산식으로 inline을 맞추는" 골든은 **존재하지 않음**(추측 단가 INSERT 금지).

★ **양면표 원칙**(디지털 R-1·캘린더 선례): 골든 = ① **설계 기대값**(inline verbatim·옳은 값) vs ② **현 라이브 산출**(WIRE 결함=공식·바인딩·product_prices 전부 0행이라 0원/source=NONE). 진원 = WIRE 결함(미배선)이지 단가값 오류 아님.

---

## 1. ★본체 정찰가 골든 (고정가형 .01 단가형·1부 정찰가 ×qty·inline verbatim·허용오차 0 — 정찰가 채택 ① 경로)

> 정찰가 채택(G-DCAL-DUAL ①)을 인간이 비준할 경우의 골든. 단가=상품마스터 inline verbatim 직독·엔진 .01 단가형 `subtotal = 1부 정찰가 × qty`(siz_cd 룩업). ★**GC-DCAL-1~7은 qty=1 기준**(qty>1이면 ×qty·아래 G-DCAL-QTY).

### GC-DCAL-1. 탁상형캘린더 220x145 (대표 사이즈·qty=1)
| 항목 | 값 | 출처 |
|------|-----|------|
| comp | COMP_DCAL_FIXED · siz_cd=220x145 | prc_typ .01 단가형(1부 정찰가 ×qty) |
| 공식 | PRF_DCAL_DESK | siz_cd 룩업 |
| **설계 기대값**(qty=1) | **10,400원** (10,400 × 1) | `design-calendar-l1.csv` row2 가격 칸 verbatim |
| ★qty=10 | **104,000원** (10,400 × 10) | ★G-DCAL-QTY·×qty(10,400 고정 시 93,600 저청구) |

### GC-DCAL-2. 탁상형캘린더 130x220 (★사이즈별 정찰가 분기 입증)
| comp | COMP_DCAL_FIXED · siz_cd=130x220 |
| **설계 기대값** | **9,700원** | row3 verbatim |
| ★가드 입증 | 탁상형이 220→10400·130→9700 siz_cd로 정확 분기(G-DCAL-SIZE-PRICE·단일가 뭉개면 700원 오차) |

### GC-DCAL-3. 미니탁상형캘린더 90x100
| comp | COMP_DCAL_FIXED · siz_cd=90x100 | 공식 PRF_DCAL_DESKMINI |
| **설계 기대값** | **6,500원** | row6 verbatim |

### GC-DCAL-4. 미니탁상형캘린더 148x60 (★동일가 다른 사이즈·정상)
| comp | COMP_DCAL_FIXED · siz_cd=148x60 |
| **설계 기대값** | **6,500원** | row7 verbatim |
| ★정보 | 두 사이즈 동일 정찰가(G-DCAL-MINI-FLAT·결함 아님·정찰가 단순화) |

### GC-DCAL-5. 엽서캘린더 145x145 (본체만·add-on 미선택)
| comp | COMP_DCAL_FIXED · siz_cd=145x145 | 공식 PRF_DCAL_POSTCARD |
| **설계 기대값** | **4,000원** | row8 verbatim |

### GC-DCAL-6. 벽걸이캘린더 210x297
| comp | COMP_DCAL_FIXED · siz_cd=210x297 | 공식 PRF_DCAL_WALL |
| **설계 기대값** | **9,900원** | row10 verbatim |

### GC-DCAL-7. 와이드벽걸이캘린더 300x625 (★최대 정찰가·3절)
| comp | COMP_DCAL_FIXED · siz_cd=300x625 | 공식 PRF_DCAL_WALLWIDE |
| **설계 기대값** | **24,000원** | row11 verbatim |

★ GC-DCAL-1~7 = **inline 정찰가(1부 단가) verbatim 직독·허용오차 0 재현 가능**(qty=1 기준·정찰가 채택 ① 경로·인간 컨펌 후). 검증가가 COMP_DCAL_FIXED에 siz_cd selection·qty로 `_component_subtotal` 호출 시 `1부 정찰가 × qty`. .01 단가형 = **1부 정찰가 × qty**(엔진계약 ④·굿즈 GP-1·악세사리 inline과 per-unit ×qty 동일 계약·"qty 무관" 아님). **단 ① 비준 전에는 BLOCKED — 추측 단가 0**.

---

## 2. 우드거치대 add-on 골든 (COMP_CALOPT_STAND · 캘린더 종단 mint 선행 의존 · 상품마스터 verbatim)

> 캘린더 종단 신규 mint comp 선행 의존(현 라이브 component·단가행 0행)·단가=상품마스터 `추가상품_추가가격` verbatim.

### GC-DCAL-8. 엽서캘린더 + 우드거치대 qty=1 (★add-on 가산·formula 합산 입증)
| 본체 | COMP_DCAL_FIXED(145x145) = 4,000 (1부 정찰가 × qty=1) |
| add-on | COMP_CALOPT_STAND · opt_cd=우드거치대 · unit=4000 · ×qty=1 |
| **설계 기대값**(qty=1) | **8,000원** (본체 4,000×1 + 우드거치대 4,000×1) | row8 가격 4000 + 추가가격 4000 verbatim |
| ★가드 입증 | **G-PRODPRICE**: 본체를 product_prices에 박았으면 우드거치대 가산이 silent 우회→4,000원만 출력. formula 합산 유지로 8,000 정확(add-on 가산 보존) |
| ★단가행 전제 | 우드거치대 단가행(COMP_CALOPT_STAND·4000)은 **캘린더 종단 신규 mint 선행 의존(현 라이브 0행·validator 재실측 2026-06-22)** — 캘린더 종단 mint 적재 후에야 본 골든 재현 가능(디자인캘린더 독자 mint 금지) |

### GC-DCAL-9. 엽서캘린더 + 우드거치대 qty=10 (★본체·add-on 둘 다 ×qty·G-DCAL-QTY 입증·개당 가산 가설)
| 본체 | COMP_DCAL_FIXED(145x145) = **1부 정찰가 4,000 × qty=10 = 40,000** (.01 단가형 ×qty·qty 무관 아님) |
| add-on | COMP_CALOPT_STAND · unit=4000 · ×10 = 40,000 (개당 가산 가설·Q-DCAL-FIN) |
| **설계 기대값(개당 가산)** | **80,000원** (본체 40,000 + 우드 40,000) | ★본체·add-on 둘 다 ×qty(엔진계약 ④) |
| ★저청구 오답 | 44,000(본체 4,000 qty-불변 오모델링·codex D1 적발) — **금지**(G-DCAL-QTY) |
| ★Q-DCAL-FIN | 우드거치대 개당 vs 주문당 정액(주문당이면 우드 4,000·합계 44,000) — 컨펌 |

★ GC-DCAL-8(qty=1) = G-PRODPRICE 가드의 핵심 입증(정찰가형이라도 add-on 있으면 formula 합산 유지). 본체 정찰가는 .01 단가형 **1부 정찰가 ×qty**(qty=1이면 4000·qty=10이면 40,000)·우드거치대는 .01 ×qty. **본체를 product_prices로 적재하면 8,000→4,000 붕괴**(add-on silent 우회). **GC-DCAL-9(qty=10) = G-DCAL-QTY 입증**(본체 ×qty 80,000 정답 vs qty-불변 44,000 저청구).

---

## 3. ★inline 합산 산식 골든 — BLOCKED (정직 표기 · 추측 단가 금지 · 산식 골든 부재)

> 디자인캘린더 inline 정찰가를 인쇄비+용지비+제본비 단가행 합산으로 **재구성해 inline과 허용오차 0 재현 가능한지** 검증. 결과 = **재현 불가**(정직 BLOCKED·inline-authority-evidence §1.3 python 역산).

### 3.1 inline 역산 결과 (실측 2026-06-22 verbatim 인용)

| 상품(siz·종이·가공) | inline | 제본비(q1 verbatim) | 인쇄+용지 잔여 | per_plate(인쇄+용지) | **유효판수** | 페이지 | 재현? |
|---------------------|-------:|--------------------:|---------------:|---------------------:|-----------:|------:|------|
| 탁상220 양면 | 10,400 | DESK220=5,000 | 5,400 | 4,112.58 | **1.313** | 30 | ❌ |
| 미니 양면 | 6,500 | DESKMINI=4,500 | 2,000 | 4,112.58 | **0.486** | 26 | ❌ |
| 엽서 단면 | 4,000 | 0 | 4,000 | 3,112.58 | **1.285** | 12 | ❌ |
| 벽걸이 단면 | 9,900 | WALL=5,000 | 4,900 | 3,112.58 | **1.574** | 13 | ❌ |
| 와이드 단면 | 24,000 | WALL=5,000 | 19,000 | 3,112.58 | **6.104** | 13 | ❌ |

★ **판정 = BLOCKED(산식 골든 부재·정직)**:
- 유효판수 전부 비정수 + 페이지수와 정수 배수 관계 없음(미니 0.486판으로 26P 물리 불가).
- inline = 에디터형 1부 정찰가 스냅샷(소비자 표시가)·단가행 합산 결과 아님.
- **추측 단가 INSERT 금지** — inline 10,400을 산식 단가로 역산해 component_prices에 박으면 ① 비정수 날조 단가(거짓 견적) ② product_prices 적재 시 PRODUCT_PRICE 선점 FORMULA 우회 → **이중 위험**(GC-AC15·booklet 088·calendar §3 선례 동형).
- ∴ **"산식으로 inline을 맞추는 골든"은 존재하지 않는다.** inline 자체가 골든(§1 정찰가 .01 단가형 min_qty=1 룩업).

### 3.2 두 가격 그릇 권위 정리 (G-DCAL-DUAL 골든 함의)

| 그릇 | 값 | 권위 |
|------|----|------|
| **디자인캘린더 inline 정찰가**(.01 단가형 min_qty=1·PRF_DCAL_*) | 10,400 등 | 상품마스터·1부 대표 정찰가(편집기 주문) |
| **일반 캘린더 단가행 산식**(PRF_CAL_* 원자합산) | ≠10,400(수량·페이지수 종속) | 가격표 단가행(업로드 주문·engine-design-calendar 별 골든) |

→ **두 값이 안 맞음**(정찰가≠산식 합산). G-DCAL-DUAL 결판 ①(정찰가 채택·주문방법 분기)으로 충돌 회피 — 편집기 주문은 정찰가(§1 골든)·업로드 주문은 산식(캘린더 골든). **inline은 PRF_CAL_*의 골든이 될 수 없다**(합산 미재현).

`확신도: 높음(inline-authority-evidence §1.3 python 역산 verbatim·2026-06-22)` · **산식 골든 부재 정직 — 추측 단가 0**.

---

## 4. 골든 종합표 (검증가 재현 대상)

| 골든 | 대상 | 설계 기대값(verbatim) | 재현 방법 | 상태 |
|------|------|-----------------------|-----------|------|
| GC-DCAL-1~7 | 본체 정찰가 .01 단가형 1부 정찰가 ×qty(siz_cd 룩업) | 10,400 / 9,700 / 6,500 / 6,500 / 4,000 / 9,900 / 24,000 (qty=1) | inline verbatim siz_cd 직독 × qty | ✅ 허용오차 0(qty=1 기준·정찰가 채택 ①·컨펌 후) |
| GC-DCAL-8 | 본체 + 우드거치대 가산(formula 합산·qty=1) | 8,000 (4,000×1 + 4,000×1) | .01 ×qty 본체 + .01 add-on Σ | ✅(G-PRODPRICE 입증·컨펌 후·우드거치대 단가행=캘린더 종단 mint 선행) |
| GC-DCAL-9 | 본체+우드거치대 둘 다 ×qty(qty=10) | **80,000** (본체 40,000 + 우드 40,000·개당 가산) | .01 ×qty 둘 다 | 🟡 개당/주문당 컨펌(Q-DCAL-FIN)·★G-DCAL-QTY(44,000=저청구 오답) |
| **inline 합산 산식** | inline을 인쇄+용지+제본으로 재구성 | (재현 불가·산식 골든 부재) | — | **❌ BLOCKED**(정직·추측 금지) |

★ **핵심 입증**:
1. GC-DCAL-1 vs GC-DCAL-2(10400 vs 9700)가 **siz_cd 정찰가 분기**를 입증(단일가 뭉개면 700원 오차·G-DCAL-SIZE-PRICE).
2. GC-DCAL-8(8000 vs product_prices 박을 시 4000)이 **G-PRODPRICE 선점 가드**를 입증(정찰가형이라도 add-on formula 합산 유지).
3. **GC-DCAL-9(qty=10·80,000 vs qty-불변 44,000)가 G-DCAL-QTY 돈크리티컬 가드를 입증** — `.01 단가형`은 항상 ×qty(1부 정찰가)·qty-불변 모델링 시 저청구(codex D1 적발).
4. inline 합산은 BLOCKED 정직(날조 0). 검증가는 GC-DCAL-1~9를 재현하고, inline 산식 BLOCKED·G-DCAL-DUAL 권위 분기를 확인.

---

## 5. 돈크리티컬 가드 요약 (검증가 pricing.py 재계산 입증 대상)

| 가드 | 결함 시나리오 | 입증 골든 |
|------|---------------|-----------|
| **G-DCAL-QTY**(돈크리티컬·저청구) | 본체 정찰가를 qty-불변으로 모델링 → ×qty 누락 저청구 | GC-DCAL-9(본체 10부=40,000 정답 vs 4,000 고정 오답·탁상 10부=104,000 vs 10,400 고정=93,600 저청구) |
| **G-PRODPRICE 선점** | 본체 정찰가 product_prices INSERT → FORMULA 우회 silent → add-on 가산 누락 | GC-DCAL-8(8,000 정답 vs 4,000 우회 오답) |
| **G-DCAL-SIZE-PRICE 평탄화** | 사이즈별 정찰가를 단일가로 뭉갬 | GC-DCAL-1 vs 2(10,400 vs 9,700·siz_cd 분기) |
| **G-DCAL-DUAL 비결정** | 동일 prd_cd가 DCAL+CAL 동시 바인딩 → ERR_AMBIGUOUS/silent 임의 1건 | 주문방법 분기(편집기→DCAL·업로드→CAL)로 1 prd 1 공식 |
| **inline 산식 날조** | 비정수 역산 단가로 component_prices INSERT → 거짓 견적 | inline 합산 BLOCKED(산식 골든 부재·정찰가 verbatim만) |
