# CODEBUG — 링제본 책자 표지 cover_mult ×2 미지원 (저청구)

**트랙:** C트랙(엔진 코드 결함 — 개발팀 수정 대상)
**심각도:** 🔴 HIGH — 돈 크리티컬(표지비 50% 누락, 저청구)
**대상 상품:** 트윈링(071·`PRD_000071`)·하드커버링(082·`PRD_000082`), 향후 모든 무책등 링제본 책자
**무영향:** 펼침 표지 책자(068 중철·069 무선·070 PUR·072 하드커버무선) — cover_mult=1, 현행 엔진과 정합
**상태:** 데이터로 해결 불가 → 엔진/호출자 수정 필요. 본 문서 = 개발팀 전달 명세(코드 미수정·DB 미적재)

청중: 개발팀. 모든 주장은 `파일:라인` 코드 인용 또는 라이브 SELECT 재현 수치로 뒷받침.

---

## 1. 한 줄 요약

무책등 링제본 책자(트윈링·하드커버링)는 표지가 **물리 2장(앞표지·뒤표지 따로)**이지만, 현행 가격엔진은 표지 출력매수를 **부수(copies)에 1배(×1)로만** 계산한다. 표지 평가 어디에도 `cover_mult(×2)` 곱셈 경로가 없어, 표지비가 정확히 **50% 누락**된다.

| 표지 분기 | cover_mult | 물리 표지 | 해당 상품 | 현행 엔진 |
|-----------|:--:|----------|-----------|:--:|
| 펼침(책등 O) | ×1 | 앞+책등+뒤 = 한 펼침면(1-up) | 068·069·070·072 | ✅ 정합 |
| **개별(책등 X)** | **×2** | 앞·뒤 물리 2장 | **071·082** | ❌ ×1만 계산(저청구) |

분기 권위 = 제본 `proc_cd`의 책등 유무(자동 파생, 손님 선택 아님). 출처: `_workspace/huni-price-engine-design/03_design/booklet-cover-branch-design.md`, 메모리 [[booklet-cover-branch-design-260630]].

---

## 2. 코드 한계 — 라인 근거 (임무 1)

### 2.1 `cover_mult`/`cover_sheets` 변수 자체가 코드에 없다 (phantom)

```
$ grep -rn "cover_mult\|cover_sheets\|cover_qty" raw/webadmin/   →  0건
```

표지 배수 개념이 엔진(`pricing.py`)·호출자(`price_views.py`) 어디에도 존재하지 않는다. 표지를 펼침/개별로 구분하는 신호가 코드에 전무하다.

### 2.2 plate_qty = 나눗셈 전용 (곱셈 경로 없음)

`raw/webadmin/webadmin/catalog/pricing.py:215-229`

```python
def plate_qty(order_qty, pansu):
    ...
    return -(-order_qty // pansu)   # ceil division  (:229)
```

판형기준 구성요소(인쇄·코팅·용지)의 유효수량은 `⌈주문수량 ÷ 판걸이수⌉`(판수)뿐이다. **나눗셈(÷)만 있고 곱셈(×)이 없다.** 표지가 물리 2장이어도 이 함수는 그 사실을 알 수 없다.

### 2.3 component_subtotal = unit_price × qty (배수 인자 없음)

`pricing.py:193-212`

```python
def component_subtotal(prc_typ, unit_price, tier_min_qty, qty):
    ...
    return up * q, up      # 단가형: 장당가 × 수량  (:212)
```

구성요소 소계는 `단가 × qty`. 여기 들어오는 `qty`는 상위(`_evaluate_formula`)가 넘긴 `comp_qty`(판형기준이면 판수, 아니면 주문수량)이다 — `pricing.py:680-692`. 표지 배수를 곱할 자리가 없다.

### 2.4 표지 출력매수가 결정되는 실제 경로 (호출자 → 엔진)

표지는 셋트 구성원(반제품 member)으로 평가된다. **표지 member의 qty는 호출자(`price_views.py`)가 산출해 엔진에 넘긴다** — 엔진은 그 qty를 그대로 쓴다.

**(엔진 측)** `pricing.py:885-917` — 구성원 루프:
```python
mqty = mb.get("qty")                       # :887  호출자가 넣은 유효수량
...
mqty_i = int(mqty) ...                      # :893
res = evaluate_price({"prd_cd": sub_cd}, mb.get("selections") or {}, mqty_i, ...)  # :904
```
docstring `pricing.py:851`: *"qty 는 호출자가 산출한 유효수량(총내지매수/출력매수/부수)."* → 엔진은 표지 배수를 모르고, 받은 qty를 신뢰한다.

**(호출자 측)** `price_views.py:1849-1913` — 셋트 시뮬 member 조립. 표지는 `pages`가 없으므로 `qty_mode == "manual"` 분기:
```python
else:                                                            # :1900  manual
    eff_qty = int(mb.get("qty")) if mb.get("qty") not in (None,"") else copies   # :1902
    ...
    breakdown = {"mode": "manual", "qty": eff_qty}              # :1907
members.append({ ... "qty": eff_qty, ... })                     # :1908-1911
```
표지 member의 `eff_qty = copies`(부수) **그대로**. **cover_mult 곱셈이 없다.** (내지만 `derive_inner_sheets`로 파생: `price_views.py:1889`, `pricing.py:820-841` — 표지/면지는 manual 경로.)

### 2.5 왜 ×2 경로가 없는가 (결론)

```
표지 member.qty = copies            (price_views.py:1902, 곱셈 없음)
   → evaluate_price(qty=copies)     (pricing.py:904)
   → comp_qty = plate_qty(copies, pansu) = ⌈copies/pansu⌉   (pricing.py:682, 나눗셈만)
   → subtotal = unit_price × comp_qty                       (pricing.py:212)
```
전 사슬에 **부수의 정수배(×2)를 표지에만 적용하는 지점이 단 한 곳도 없다.** cover_mult 변수도, 그것을 주입할 호출자 로직도 부재. 따라서 무책등 링제본 표지는 구조적으로 ×1로만 계산된다.

---

## 3. 라이브 데이터로 저청구 재현 (임무 2 · 핵심)

### 3.1 셋트 구성 실측 (라이브 SELECT)

```sql
SELECT s.prd_cd, s.sub_prd_cd, sp.prd_nm, sp.semi_role_cd, s.disp_seq
FROM t_prd_product_sets s JOIN t_prd_products sp ON sp.prd_cd=s.sub_prd_cd
WHERE s.prd_cd IN ('PRD_000068','PRD_000082') ORDER BY s.prd_cd, s.disp_seq;
```
| 셋트 | 구성원 | 역할 |
|------|--------|------|
| 068 중철 | PRD_000288 중철책자-표지 / PRD_000287 내지 | 표지(펼침 ×1)·내지 |
| 082 하드커버링 | **PRD_000083 표지(전용지)** / PRD_000286 내지 / PRD_000084~087 면지 | 표지(**개별 ×2여야 함**)·내지·면지 |

- **071 트윈링은 셋트 미구성(`t_prd_product_sets`에 행 0)** — 배경의 "BLOCKED" 상태를 라이브에서 재확인. 082(이미 구성됨)를 동형 기준으로 재현.

### 3.2 표지 가격공식·구성요소 (라이브 SELECT)

068 표지(PRD_000288) → 공식 `PRF_BOOK_COVER`. 082 표지(PRD_000083) → **공식 바인딩 0행**(BLOCKED 재확인, `t_prd_product_price_formulas`).

`PRF_BOOK_COVER` 구성요소 3종 (모두 판형기준 `plt_siz_cd`):
| disp | comp_cd | 이름 | prc_typ | use_dims |
|--|--|--|--|--|
| 1 | COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 | 단가형 | proc_cd, **plt_siz_cd**, print_opt_cd, min_qty, proc_grp:PROC_000001 |
| 2 | COMP_COAT_MATTE | 무광코팅비 | 단가형 | proc_cd, **plt_siz_cd**, coat_side_cnt, min_qty, proc_grp:PROC_000013 |
| 3 | COMP_PAPER | 용지비 | 단가형 | **plt_siz_cd**, mat_cd |

표지 판형 = 표지 사이즈 `SIZ_000499`(316×467, 1-up). 단가행이 `plt_siz_cd='SIZ_000499'`로 직접 적재됨(인쇄비 `comp_price_id` 38665~, 코팅비 1~, 용지비 5402~). 즉 표지 1매 = 1판 경로.

### 3.3 저청구 산정 (표지 1매 라이브 골든 = 88,688원 기준)

068 표지 member 라이브 실측 기여액 = **88,688원** (배경 골든, cover_mult=1 정합). 082/071 표지는 068과 동형 적재되므로 표지 member 단위 기여액 동일 구조.

엔진 동작(§2.4-2.5)상 표지 member subtotal은 호출자가 넣은 qty(=copies)에 선형이고 cover_mult를 모른다. 따라서:

| | 표지비 계산 | 표지 기여액 | 비고 |
|--|--|--|:--|
| **현행 엔진 (×1)** | 표지 출력 = copies × 1 | **88,688원** | cover_mult 미인지 → 부수만큼만 |
| **정답 (×2)** | 표지 출력 = copies × 2 (앞·뒤 물리 2장) | **177,376원** | 무책등 링제본 물리 현실 |
| **저청구액** | 차액 | **−88,688원/건** | **표지비 50% 누락** |

> ※ 88,688원은 표지 1매분 전체(디지털인쇄비 + 무광코팅비 + 용지비)의 라이브 실측 합. ×2는 이 합 전체에 2배(앞장+뒤장 출력·코팅·용지). 단가행 자체는 1매 기준이 권위이므로 1매값을 바꾸지 않고 **표지 출력매수를 2배**로 줘야 정답.

### 3.4 071 트윈링 총액 ×1 vs ×2 (제본비 포함)

071 트윈링 제본 = COMP_BIND_TWINRING (proc_cd=PROC_000024), 라이브 단가행:
```
PROC_000024  min_qty=1 → 30,000 / 4 → 20,000 / 10 → 15,000 / 50 → 10,000 / 100 → 8,000 / 1000 → 7,000
```
제본비·내지비는 표지 배수와 무관(영향 없음). 표지비만 ×2 차이.

**예: 트윈링 1부 견적 (표지 88,688 + 내지 X + 제본 30,000 가정)**
| | 표지 | 내지 | 제본 | 합계 | 저청구 |
|--|--|--|--|--|--|
| 현행(×1) | 88,688 | X | 30,000 | 118,688 + X | — |
| 정답(×2) | 177,376 | X | 30,000 | 207,376 + X | **−88,688원** |

표지비가 총액에서 차지하는 비중이 클수록(소부수일수록) 저청구 비율이 크다.

### 3.5 082 하드커버링 동형

082는 셋트 구성됨이나 표지(PRD_000083) 공식 바인딩이 0행(BLOCKED). 동작화 시 068 동형으로 표지 member가 ×1 계산될 것이므로 **071과 동일한 표지비 50% 저청구 결함을 그대로 상속**한다. 082는 하드커버 제본비(COMP_BIND_HC_TWINRING, PROC_000017 그룹)가 더해질 뿐, 표지 ×2 누락은 동일.

---

## 4. 개발팀 해결안 3택 (임무 3)

표지 단가행(1매 기준)이 권위 = **verbatim 보존**이 원칙. 표지 "출력매수"를 2배로 만드는 방법이 정도(正道).

### (a) 엔진 use_dims/배수 로직 확장 — `pricing.py`

`evaluate_set_price`(`pricing.py:844`)가 member별 `cover_mult`(int, 기본 1)를 받아, 표지 member 평가 시 표지 구성요소의 comp_qty에 곱한다.

```python
# 시그니처: members[i]에 "cover_mult": int 추가 (기본 1)
# evaluate_price 호출(:904) 또는 _evaluate_formula(:642~)에서
#   comp_qty = plate_qty(qty, pansu)  →  comp_qty = plate_qty(qty, pansu) * cover_mult
```
- **장점:** 엔진이 "표지 물리장수"를 1급 개념으로 가짐. 향후 N-up 표지·접지 표지 확장에 견고.
- **단점:** 엔진 시그니처 변경 → 회귀 표면 넓음(전 호출자 영향). cover_mult를 어디까지 전파할지(인쇄·코팅·용지 전부 vs 일부) 정책 결정 필요.
- **회귀 가드:** `cover_mult` 미지정 시 기본 1 → cover_mult=1 상품(068·069·070·072·전 단일상품) **수치 무변(× 1)** 보장.

### (b) ★권고 — 호출자가 표지 member.qty에 cover_mult 주입 — `price_views.py`

`price_views.py:1900-1911` manual 분기에서 표지 member의 `eff_qty`에 cover_mult를 곱한다. 엔진 무수정.

```python
# :1902 부근
eff_qty = ... or copies
cover_mult = int(mb.get("cover_mult") or 1)        # 신규: 제본 proc_cd 책등여부로 파생
if role == SEMI_ROLE_COVER:                        # SEMI_ROLE.02 (price_views.py:1610)
    eff_qty = eff_qty * cover_mult
breakdown = {"mode": "manual", "qty": eff_qty, "cover_mult": cover_mult}
```
cover_mult는 셋트 제본 proc_cd(set_procs)의 책등 유무로 서버에서 자동 파생(손님 선택 아님): 무책등(트윈링 PROC_000024·하드커버링 PROC_000017군) → 2, 그 외 → 1.

- **장점:** 엔진 계약 불변(silent 합산 방지 U-7 유지)·변경 범위 최소(셋트 시뮬 호출자 1곳)·표지 단가행 verbatim 보존·`breakdown`에 cover_mult 표면화로 추적 가능.
- **단점:** 표지 출력매수 산정 책임이 호출자에 분산(엔진은 여전히 표지 배수 모름).
- **회귀 가드:** cover_mult 기본 1·표지 역할(SEMI_ROLE.02)에만 적용 → 내지·면지·셋트공식·cover_mult=1 책자 **무영향**.
- **권고 이유:** booklet-cover-branch 종단 결정과 일치(표지 단가행은 1매 권위 유지, 출력매수만 호출자가 조정). 돈 크리티컬 영역에서 엔진 시그니처를 흔들지 않음.

### (c) 데이터 우회 — 표지 단가행을 2매분 내재 (비권고)

표지 component_prices의 unit_price를 2배로 적재(엔진·호출자 무수정).
- **장점:** 코드 0수정.
- **단점:** ❌ **표지 단가 verbatim 위반**(권위 엑셀 1매 기준과 불일치)·다른 ×1 표지와 단가행 공유 시 오염·"왜 2배인지" 의도 불명(미래 세션 혼란)·소부수 수량구간 단가(min_qty별 차등)와 충돌. **권고하지 않음.**

---

## 5. 영향 범위 · 회귀

**영향(저청구 해소 대상):**
- 071 트윈링(현재 BLOCKED → 동작화 시 즉시 ×1 저청구)
- 082 하드커버링(동작화 시 동형 저청구 상속)
- 향후 등록되는 모든 무책등 링제본 책자(트윈링·하드커버링·스프링 등 책등 없는 제본)

**회귀 위험(반드시 무영향 보장):**
- cover_mult=1 펼침 책자(068 중철·069 무선·070 PUR·072 하드커버무선) → 수치 **무변**
- 전 단일(비셋트) 상품 → cover_mult 미적용 → **무변**
- 내지·면지 member → 표지 역할(SEMI_ROLE.02)에만 곱하므로 **무변**
- **검증:** 수정 전후 068 중철 시뮬 표지 기여액 = 88,688 동일 유지가 회귀 게이트.

---

## 부록 — 재현 SQL 출처
- 셋트 구성: `t_prd_product_sets ⋈ t_prd_products` (068/071/082)
- 표지 공식: `t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000288','PRD_000083')`
- 표지 구성요소: `t_prc_formula_components ⋈ t_prc_price_components WHERE frm_cd='PRF_BOOK_COVER'`
- 표지 단가행: `t_prc_component_prices WHERE comp_cd IN ('COMP_PRINT_DIGITAL_S1','COMP_COAT_MATTE','COMP_PAPER') AND plt_siz_cd='SIZ_000499'`
- 트윈링 제본: `t_prc_component_prices WHERE comp_cd='COMP_BIND_TWINRING' (PROC_000024)`
- 사이즈: `t_siz_sizes WHERE siz_cd IN ('SIZ_000077','SIZ_000499')`

코드 출처: `raw/webadmin/webadmin/catalog/pricing.py`(:193,212,215-229,680-692,820-841,844-917)·`price_views.py`(:1610,1849-1919). cover_mult grep 0건.
