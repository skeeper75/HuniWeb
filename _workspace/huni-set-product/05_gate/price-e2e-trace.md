# S4 가격 e2e 종단 재현 — 엽서북(PRD_000094) 20P 골든 (게이트 직접 재계산)

생성: hsp-set-gate · 라이브 읽기전용 SELECT 실측 · evaluate_set_price/evaluate_price(`raw/webadmin/webadmin/catalog/pricing.py`) 로직 재현 · DB 미적재.
**생성측(set-designer/codex) 주장 비신뢰 — 아래는 게이트가 라이브 단가행으로 직접 손계산한 증거.**

---

## 0. 골든 케이스 정의

| 항목 | 값 | 근거 |
|---|---|---|
| 셋트 완제품 | PRD_000094 엽서북 | 라이브 실재(prd_typ_cd=04) |
| 가격공식 | PRF_PCB_FIXED (apply_bgn_ymd=2026-06-01·use_yn=Y) | t_prd_product_price_formulas·t_prc_price_formulas |
| 선택 | siz_cd=SIZ_000003(100×150) · print_opt_cd=POPT_000001(단면) · 페이지=20P · copies=100 | 94 등록 사이즈·단가행 차원 |
| 구성원 | 95(내지 몽블랑240)·96(표지 스노우300) — 둘 다 가격공식 0 | t_prd_product_price_formulas 실측 |

---

## 1. evaluate_set_price 종단 재현 (pricing.py:718)

```
evaluate_set_price(PRD_000094, members=[95,96], set_selections={siz_cd,print_opt_cd}, copies=100)

[A] 구성원별 evaluate_price (각자 공식, 할인 미적용) — pricing.py:759-786
    · 95(내지): evaluate_price({prd_cd:PRD_000095}, …, qty) → 가격공식 0건 → base.amount=0
              warning "[내지] 유효수량/매칭 없음" · contribution=0 · included(qty 없으면 False)
    · 96(표지): evaluate_price({prd_cd:PRD_000096}, …, qty) → 가격공식 0건 → base.amount=0
    → 구성원 합산 기여 = 0  (실측: 95/96 t_prd_product_price_formulas=0행)

[B] 셋트 완제품 자기 공식 set_eval — pricing.py:789
    set_eval = evaluate_price({prd_cd:PRD_000094}, {siz_cd:SIZ_000003, print_opt_cd:POPT_000001, min_qty=100}, 100)
      _evaluate_formula(PRF_PCB_FIXED) → formula_components 2건:
        · COMP_PCB_S1_20P (addtn_yn=Y · prc_typ=PRICE_TYPE.01 단가형 · use_dims=[siz_cd,min_qty,print_opt_cd])
            match_component: _row_matches(단면 POPT_000001) → siz_cd=SIZ_000003·print_opt=POPT_000001 매칭
            tier 선택 min_qty: 후보 14행(2..100) 중 ≤100 최대 = 100 → unit_price=4,500 (실측)
            component_subtotal(단가형) = 4,500 × 100 = 450,000 · included=True
        · COMP_PCB_S2_20P (양면 POPT_000002 전용)
            _row_matches(단면 선택) → print_opt_cd=POPT_000002 ≠ POPT_000001 → 매칭 0행 → included=False
      included_sum = 450,000  →  set_eval.base.amount = 450,000 · set_contrib=450,000

[C] base_total = 0(구성원) + 450,000(set_eval) = 450,000

[D] 할인 (합산 후 셋트 1회) — pricing.py:804-814
    _quantity_discount(PRD_000094, 450,000, 100) → t_prd_product_discount_tables(94)=0행(실측) → 할인 없음
    grade_cd 없음 → 등급할인 없음
    running = 450,000

[E] final_price = round_won(450,000) = 450,000  ✅  PRICE ≠ 0
```

**게이트 손계산 결과값 = 450,000원** (20P·단면·SIZ_000003·100부). PRICE≠0 입증.

---

## 2. 단가행 직접 실측 (verbatim·골든 sanity)

| comp | siz_cd | print_opt | min_qty | unit_price | note(라이브) |
|---|---|---|---|---|---|
| COMP_PCB_S1_20P | SIZ_000003 | POPT_000001 | 2 | 11,000 | 엽서북/100*150/단면/20P 수량 2 이상 |
| COMP_PCB_S1_20P | SIZ_000003 | POPT_000001 | 100 | **4,500** | 엽서북/100*150/단면/20P 수량 100 이상 ← 골든 매칭행 |

- S1_20P print_opt 분포 = **POPT_000001(단면) 전용** · S2_20P = **POPT_000002(양면) 전용** (실측).
- 단면 선택 시 S2 매칭행 = **0** (이중합산 불가 직접 입증).

---

## 3. 이중합산 점검 (돈크리티컬)

- S1/S2 둘 다 addtn_yn=Y(가산형)이나 **print_opt_cd로 배타 매칭** — 단면 선택→S1만 included, S2 no_match.
- 라이브 검증: `S2_20P rows matching 단면(POPT_000001 or NULL) = 0` → **silent 이중합산 0**.
- 구성원가 0이라 셋트공식과 이중 계상 위험도 0(셋트공식 단독형).

→ **이중합산 = 0** (입증).

---

## 4. ★ 30P 결함 재진단 (게이트 독립 발견 — 생성측 진단 정정)

설계/codex 진단: "30P comp·단가행 라이브 부재 → 30P 선택 시 매칭0 견적불가(BLOCKED)".
**게이트 라이브 실측 = 다른 사실:**

| 실측 항목 | 결과 |
|---|---|
| COMP_PCB_S1_30P / S2_30P (price_components) | **존재** (use_dims=[siz_cd, min_qty]) |
| 30P 단가행 (component_prices) | **존재** — S1_30P 117행 · S2_30P 117행 (note "…/30P 수량 N 이상") |
| 30P comp의 formula_components 바인딩 | **0행** — 어떤 공식에도 미바인딩(고아) |
| PRF_PCB_FIXED formula_components | COMP_PCB_S1_20P·S2_20P **2건만** |
| 전 comp use_dims에 page 차원 | **0건** (페이지는 comp 식별자 _20P/_30P로만 구분) |
| 30P vs 20P 단가 | **30P가 더 비쌈** (SIZ_000003 단면 수량4~20: +800/장) |

**결론(정정)**: 30P는 "데이터 부재 → 견적불가"가 **아니다**. 실제 라이브 동작은:
- page 차원이 use_dims에 없으므로, 사용자가 30P를 선택해도 evaluate_price는 **PRF_PCB_FIXED에 바인딩된 20P comp를 매칭**해 견적을 낸다.
- 즉 **30P 선택 → 20P 단가(저렴)로 견적 = 과소청구(under-charge)**. 100부 단면 SIZ_000003 기준 20P 4,500 vs 30P 정답 5,xxx → 장당 수백원 저청구.
- 이는 "견적불가(매칭0)"가 아니라 **오청구 돈결함**이며, 교정 경로도 다르다: 신규 단가 데이터 생성이 아니라 **이미 존재하는 30P comp를 PRF_PCB_FIXED에 배선 + 페이지 차원 선택→공식 분기 로직** 필요.

> 단, 이 30P 결함은 **가격엔진/공식 영역**이며, 본 게이트 대상인 엽서북 셋트 보정 적재본(95/96 행 + 94 유형)에는 30P comp/단가/공식 변경이 일절 포함돼 있지 않다 → 적재본 자체엔 영향 없음. remediation-spec.md RM-1로 §18/dbmap 라우팅.
