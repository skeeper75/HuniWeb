# dimension-to-price-trace.md — 종단 골든 e2e 추적 (디지털인쇄)

> **Phase 4 — hcc-price-engine-inspector** · 2026-06-22 · `huni-catalog-conformance/04_price_engine`
> 목적: `옵션 선택값 → polymorphic 차원 환원 → component_prices 단가행 매칭 → evaluate_price → final_price`를
> 대표 상품 1건에 대해 단계별로 추적해 **정합의 정석을 입증**하고, **끊기는 지점 = 가장 비싼 결함**을 표시한다.
> 권위 기준: `engine-contract.md`(evaluate_price 계약 인용·재조사 0)·`engine-design-digitalprint.md`(설계).
> 라이브 읽기전용 SELECT 실측 2026-06-22. 단가값 verbatim(날조 0).

---

## 추적 1 — ✅ 성공 사례: 스탠다드엽서 (PRD_000018, PRF_DGP_A 원자합산형)

원자합산형 디지털인쇄가 옵션→차원→단가행→final_price로 **끊김 없이 환원**되는 정석.

| 단계 | 내용 | 라이브 근거 |
|------|------|-------------|
| **① 옵션 선택** | 출력판형=3절(SIZ_000077)·인쇄=양면(POPT_000002·도수 4도)·용지=몽블랑(MAT_000xxx)·코팅=무광·수량 1,000매 | t_prd_product_option_groups→options→option_items(ref_dim_cd) |
| **② 차원 환원(polymorphic)** | option_item.ref_dim_cd → selections `{plt_siz_cd:SIZ_000077, print_opt_cd:POPT_000002, mat_cd:.., coat_side_cnt:1, min_qty=수량구간}` | NON_QTY_DIMS 매칭 (engine-contract §3.1) |
| **③ 단가행 매칭** | 공식 PRF_DGP_A 구성요소 disp_seq 순 자동매칭(P2-2): 인쇄 COMP_PRINT_DIGITAL_S1(212행) + 용지 COMP_PAPER(56행) + 코팅 COMP_COAT_MATTE(92행). 유광 미선택→COMP_COAT_GLOSSY 자연 제외 | t_prc_component_prices |
| **④ evaluate_price** | source=FORMULA(직접단가 0행·C1) → base = Σ included subtotal. 인쇄=[수량행단가]×출력매수(출력매수=수량/판걸이수=앱계산) + 용지 unit×qty + 코팅 unit×qty (단가형 P4-1) | pricing.py `_evaluate_formula` |
| **⑤ final_price** | round_won(Σ). 수량구간 할인 0건(디지털 미사용·단가가 min_qty 구간에 내장) → 등급할인 0행(C9) → final = base | E0-2 |

- **단가행 실측 verbatim**: 인쇄 SIZ_000077·POPT_000002·min_qty=1 → 4,500원(단면 3,500). 코팅 무광 SIZ_000077·1면·min_qty=1 → 3,000원. 용지 SIZ_000499·MAT_000074 → 70.64원/장.
- **판정: 종단 추적 성공.** 옵션 4축이 전부 단가행으로 환원되어 가격이 나온다. 원자합산 디지털(엽서·접지카드·배경지·전단류 20여 상품)은 이 경로로 견적 가능.

---

## 추적 2 — 🔴 끊긴 지점(가장 비싼 결함): 코팅명함 (PRD_000032, PRF_NAMECARD_FIXED)

고정가형 명함에서 **옵션 선택값이 올바른 단가행으로 환원되지 못하고 STD 단가로 misfire**하는 지점.

| 단계 | 기대(권위) | 라이브 실제 | 끊김 |
|------|-----------|-------------|------|
| **① 옵션 선택** | 코팅명함·단면·MAT_000081·100매 | 동일 | — |
| **② 차원 환원** | selections `{mat_cd:MAT_000081, print_opt_cd:단면, min_qty:100}` | 동일 | — |
| **③ 단가행 매칭** | COMP_NAMECARD_COAT_S1(MAT_000081·100매=**5,500**) 매칭 | 공식 PRF_NAMECARD_FIXED엔 **COAT comp 미배선** → COMP_NAMECARD_STD_S1만 존재 → **STD 단가(MAT_000074=3,500) 매칭** | 🔴 **D-A misfire** |
| **④ evaluate_price** | base=5,500/장 | base=3,500/장 (COAT comp는 orphan·평가에 안 들어옴) | 견적이 **틀린 값으로 성립**(깨지지 않음=더 위험) |
| **⑤ final_price** | 100매=550,000 | 100매=350,000 | **−200,000원 과소청구(회사 손해)** |

> **★끊긴 지점**: ③에서 옵션이 가리키는 variant 단가행(COAT 5,500)이 공식에 배선되지 않아, 엔진이 같은 공식의 STD comp(3,500)를 대신 매긴다. comp는 실재(orphan)하나 공식↔comp 배선이 끊겼다.

### 추가 끊김 — 🔴 D-B silent 이중합산 (같은 명함 공식)

| 단계 | 내용 | 끊김 |
|------|------|------|
| ③' 단가행 매칭 | STD_S1·STD_S2 **둘 다 print_opt_cd=NULL**(라이브 실측) → 단면 선택해도 양쪽 와일드카드 통과(P3-1) | — |
| ④' evaluate_price | 별 comp_cd라 ERR_AMBIGUOUS 안 걸림(P3-8 비해당) → S1(3,500)+S2(4,500) **둘 다 included 합산** | 🔴 **silent 이중합산** |
| ⑤' final_price | 단면 100매 = (3,500+4,500)×100 = **800,000** (정답 단면=350,000) | **+450,000원 과대청구·경고 없음** |

> D-A(과소)와 D-B(과대)가 같은 PRF_NAMECARD_FIXED에 공존. 어느 쪽이 발화하느냐는 옵션→차원 주입 레이어(option_items 매핑) 상태에 달림(현재 명함 옵션→POPT 매핑 0행). **둘 다 라이브 실재 결함** — 명함 견적은 정합 미달.

---

## 종단 추적 종합

| 경로 | 상품군 | 결과 |
|------|--------|------|
| **원자합산형(PRF_DGP_A/B/C/D/E/F)** | 엽서·접지카드·배경지·헤더택·전단·모양엽서·라벨택·상품권 | ✅ 종단 성공(코팅 유광 선택분만 V-4 0원 침묵) |
| **고정가형 명함(PRF_NAMECARD_FIXED)** | 명함류 | 🔴 끊김(D-A misfire 과소 + D-B silent 이중합산 과대) |
| **고정가형 포토카드(PRF_PHOTOCARD_FIXED)** | 포토카드 | ✅ 본체 SET 단가행 실재·종단 가능(BULK orphan은 미발화) |
| **미바인딩 10상품(frm_cd 공란)** | 투명엽서·지그재그엽서·명함7종·와이드접지리플렛 | 🔴 ④에서 source=NONE → final_price=0원/None(견적 자체 불가) |

**가장 비싼 결함 순위**: ① 미바인딩 10상품(견적 0원·아예 안 나옴) → ② 명함 D-A/D-B(틀린 값으로 성립) → ③ COMP_COAT_GLOSSY 0원 침묵(과소).
