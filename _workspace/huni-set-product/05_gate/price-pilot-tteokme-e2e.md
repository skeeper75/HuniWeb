# S4 가격 e2e 종단 재현 — 떡메모지(PRD_000097) [돈 크리티컬]

검증: hsp-set-gate 독립 재계산 · 엔진 = `raw/webadmin/webadmin/catalog/pricing.py` evaluate_set_price(L718) · 라이브 단가 verbatim(2026-06-25 SELECT) · 허용오차 0.

> 한 셋트 완전 재계산(구성원 합산 → 셋트공식 → 할인 → final_price). 골든 2건 독립 재현 + SQL 트랜잭션 내 재현 이중 확인.

---

## 0. 엔진 계약 핵심 (직접 Read)

| 함수 | 라인 | 역할 |
|---|---|---|
| `evaluate_set_price` | L718 | 구성원 합산(L759-786) + 셋트 자기공식 set_eval(L789) + 할인 1회(L807) |
| 구성원 qty<1 처리 | L766-773 | "[label] 유효수량 산출 실패 — 합산 제외"·contribution=0·included=False |
| `evaluate_price` 소스 우선 | L405-419 | ① 직접단가 → ② 공식(`_evaluate_formula`) |
| `_evaluate_formula` | L537 | formula_components 순회·comp별 match → Σ |
| `match_component` | L122-178 | NON_QTY 정확매칭(NULL=와일드카드)·min_qty 티어(이하 최대)·ambiguous/duplicate 가드 |
| `NON_QTY_DIMS` | L42-43 | siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·**bdl_qty** |
| `TIER_DIMS` | L49 | siz_width·siz_height·min_qty (min_qty=수량 하한·이하 최대) |
| `component_subtotal` | L181-196 | 단가형(PRICE_TYPE.01): unit_price × qty |

→ **`bdl_qty`가 NON_QTY_DIMS에 포함**(L43)되어 정확매칭됨. COMP_TTEOKME use_dims=["siz_cd","bdl_qty","min_qty"]는 엔진 차원 처리와 정합(siz_cd·bdl_qty=정확매칭·min_qty=티어).

---

## 1. 골든1 — 90x90 / 50장1권 / 30권 → 기대 60,000원

```
호출: evaluate_set_price(
        set_prd_cd = PRD_000097,
        members    = [{sub_prd_cd: PRD_000098, qty: (098 가격공식 0 → 유효수량 미산출)}],
        set_selections = {siz_cd: SIZ_000119(90x90), bdl_qty: 50},
        copies = 30 )

[A] 구성원 098 평가 (L759-786)
    098 t_prd_product_price_formulas = 0행 (라이브 실측)
    098 t_prd_product_prices         = 0행
    → evaluate_price(098) base.amount = 0
    → contribution = 0 · included = False · "[내지] 합산 제외" warning
    구성원 합산 기여 = 0

[B] 셋트 자기공식 set_eval = evaluate_price(PRD_000097, {siz_cd:119, bdl_qty:50}, 30) (L789)
    097 직접단가 0행 → 공식 분기 (L411-419)
    바인딩 PRF_TTEOKME_FIXED (검증 대상 INSERT, apply_bgn_ymd=2026-06-01 ≤ as_of)
    _evaluate_formula → formula_components 1건: COMP_TTEOKME(addtn_yn=Y, 단가형)
      _component_rows(COMP_TTEOKME) → 112행
      match_component(rows, {siz_cd:119, bdl_qty:50}, qty=30, as_of):
        _row_matches: siz_cd=SIZ_000119 ✓ · bdl_qty=50 ✓
                      plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·dim_vals
                      = 전부 NULL/공란 → 와일드카드 통과
        후보 = 28행(siz=119·bdl=50의 min_qty 28티어)
        combo 키 = 모두 동일(NON_QTY 전부 NULL) → 단일 combo → ambiguous 0
        min_qty 티어(하한·이하 최대): 30 이하 최대 임계 = 30
          → unit_price = 2,000.00  (comp_price_id=3925 · 단일 티어행 · duplicate 0)
      component_subtotal(PRICE_TYPE.01) = 2,000 × 30 = 60,000  · included = True
    set_eval.base.amount = 60,000

[C] base_total = 0(구성원) + 60,000(셋트) = 60,000

[D] 할인 (L807, 합산 후 셋트 1회)
    _quantity_discount(097, 60,000, 30) → t_prd_product_discount_tables(097) = 0행 → 없음
    grade_cd 없음 → 등급할인 없음
    running = 60,000

[E] final_price = round_won(60,000) = 60,000   ✅  PRICE ≠ 0
```

**골든1 = 60,000원** (설계 일치·SQL 재현 g1_subtotal=60000.00 일치).

---

## 2. 골든2 — 70x120 / 100장1권 / 6권 → 기대 19,200원

```
set_selections = {siz_cd: SIZ_000266(70x120), bdl_qty: 100}, copies = 6

[A] 구성원 098 = 0 (동일)
[B] match_component({siz_cd:266, bdl_qty:100}, qty=6):
      siz=266 ✓ · bdl=100 ✓ · 기타 NON_QTY NULL 와일드카드 → 단일 combo
      min_qty ≤ 6 최대 = 6 → unit_price = 3,200.00 (comp_price_id=3912 · 단일 · duplicate 0)
    component_subtotal = 3,200 × 6 = 19,200
[C] base_total = 19,200
[D] 할인 0
[E] final = 19,200   ✅  PRICE ≠ 0
```

**골든2 = 19,200원** (설계 일치·SQL 재현 g2_subtotal=19200.00 일치).

---

## 3. 돈 크리티컬 점검 (이중합산·날조)

| 점검 | 결과 |
|---|---|
| 이중합산(comp간 중복) | COMP_TTEOKME 단일 comp → 0 |
| 구성원-셋트 이중계상 | 098 가격공식 0행 → 구성원 기여 0 → 0 |
| silent 다중매칭 | 단일 combo·단일 티어행(라이브 검산) → ambiguous/duplicate 0 |
| 단가 verbatim | 2,000(3925)·3,200(3912)·3,000(3909)·850(4017) 라이브 실측 = 설계표 일치·날조 0 |
| PRICE=0 위험 | 양 골든 PRICE≠0 입증 |

---

## 4. 재현 SQL (트랜잭션 내·롤백전용·이미 실행 검증)

```sql
-- 골든1 단가(엔진 티어 로직 동치)
SELECT unit_price, unit_price*30 AS subtotal
FROM t_prc_component_prices
WHERE comp_cd='COMP_TTEOKME' AND siz_cd='SIZ_000119' AND bdl_qty=50
  AND min_qty<=30 AND apply_ymd<='2026-06-25'
ORDER BY min_qty DESC LIMIT 1;          -- → 2000.00 | 60000.00

-- 골든2
SELECT unit_price, unit_price*6 AS subtotal
FROM t_prc_component_prices
WHERE comp_cd='COMP_TTEOKME' AND siz_cd='SIZ_000266' AND bdl_qty=100
  AND min_qty<=6 AND apply_ymd<='2026-06-25'
ORDER BY min_qty DESC LIMIT 1;          -- → 3200.00 | 19200.00
```

**S4 = ✅ PASS** (허용오차 0·PRICE≠0·이중합산 0·날조 0).
