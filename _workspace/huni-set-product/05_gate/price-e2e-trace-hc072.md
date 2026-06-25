# 072 하드커버책자 S4 가격 종단 재현 (evaluate_set_price 손계산·PRICE≠0)

생성: hsp-set-gate · 2026-06-25 라이브 verbatim 단가 직접 재실측 + pricing.py:718 evaluate_set_price 계약 재현 · **DB 미적재** · 부분 골든(READY 4비목·내지 BLOCKED 누락 명시)

> ★내지인쇄·내지용지비 BLOCKED → 완전 6비목 합산 불가. 본 trace는 READY 4비목(제본+표지인쇄+표지코팅+표지용지비)의 **부분 골든** — PRICE≠0·이중합산0·코팅1회 입증 + 내지 누락이 완제가 미달임을 명시.

---

## 1. 골든 케이스

| 항목 | 값 | 근거(라이브/권위) |
|---|---|---|
| 셋트 | PRD_000072 하드커버책자 | sets 4구성원(073/074/075/076 전부 PRD_TYPE.02) |
| 완제사이즈 | A5(SIZ_000170) → 표지 출력판형 국4절(SIZ_000499) | 판걸이수 row64 A5 표지 390x268→국4절 |
| 도수 | 단면(POPT_000001) | booklet 표지인쇄=단면 |
| 페이지 | 100p | booklet page_rule |
| 제본 | 하드커버무선(PROC_000023) | 072 process 실재 |
| 코팅 | 무광 단면(PROC_000015·coat_side_cnt=1) | 072 process PROC_000015 무광 실재 |
| 부수 copies | 50권 | — |

## 2. evaluate_set_price 종단 (pricing.py:718)

```
evaluate_set_price(
  set_prd_cd = PRD_000072,
  members    = [073, 074, 075, 076(택1 무료)],
  set_selections = {proc_cd:PROC_000023, plt_siz_cd:SIZ_000499,
                    print_opt_cd:POPT_000001, coat_side_cnt:1,
                    mat_cd:MAT_000078(아트150), siz_cd:<표지 출력 환원값>},
  copies   = 50,
  set_procs = [{PROC_000023},{PROC_000004},{PROC_000015}])

[A] 구성원 평가 (pricing.py:759~786)
    073/074/075/076 evaluate_price → t_prd_product_price_formulas 0행(라이브 실측)
    → 각 contribution = 0  → member base_total 기여 0

[B] 셋트공식 평가 (pricing.py:789~792)
    evaluate_price(PRD_000072, set_selections, copies=50)
    → 072 직접단가 없음 → 공식 PRF_HC_MUSEON_SUM(바인딩 후) → _evaluate_formula
    → formula_components disp_seq 순 Σ (verbatim 라이브 단가):
```

| seq | comp | comp_qty 산출 (pricing.py:573~581) | 단가형 subtotal (line 196: up×qty) |
|---|---|---|---|
| 1 제본 | COMP_BIND_SSABARI | plt_siz 미사용 → comp_qty=copies=**50** | tier(min_qty≤50 max)=**9,000** × 50 = **450,000** |
| 2 표지인쇄 | COMP_PRINT_DIGITAL_S1 | plt_siz 사용 → plate_qty(50,pansu) | tier 단가 × 출력매수 (>0) |
| 3 표지코팅 | COMP_COAT_MATTE | plate_qty(50,pansu) | tier 단가 × 출력매수 (>0) |
| 4 표지용지 | COMP_PAPER(아트150) | plate_qty(50,pansu)·절가 46.65 | 46.65 × 출력매수 (>0) |
| (미배선)5 내지인쇄 | 🔴 BLOCKED | — | **누락 = 완제가 미달** |
| (미배선)6 후가공박 | ⚪ N/A | — | — |

```
[C] base_total = member(0) + set_contrib(included_sum) ≥ 450,000   ✅ PRICE≠0
[D] 할인: _quantity_discount(PRD_000072) → discount_tables 0행 → 할인 0
[E] final_price = round_won(base_total) (할인 없음)
```

## 3. 두 pansu 시나리오 (출력매수 차원 의존)

게이트 라이브 단가 직접 매칭(50권·SIZ_000499·POPT_000001·무광 단면):

| 비목 | 단가행(verbatim) | pansu=1 (plate_qty 50) | pansu=4 (plate_qty ⌈50/4⌉=13) |
|---|---|---|---|
| 제본(copies 50) | 9,000 (min_qty 50) | 9,000 × 50 = **450,000** | 동일 **450,000** |
| 표지인쇄 | 250(@50) / 500(@10) | 250 × 50 = **12,500** | 500 × 13 = **6,500** |
| 표지코팅 | 700(@50) / 1,000(@10) | 700 × 50 = **35,000** | 1,000 × 13 = **13,000** |
| 표지용지 | 46.65 (절가) | 46.65 × 50 = **2,332.5** | 46.65 × 13 = **606.45** |
| **부분 골든 합** | | **499,832.5** | **470,106.45** |

> fn_calc_pansu('SIZ_000499','SIZ_000170')=4(게이트 실측). 표지는 펼침면(390x268)을 출력하므로 siz_cd 주입값에 따라 pansu가 1(펼침 사이즈코드)/4(완제 A5 주입)로 갈림 → CFM-HC-COVER-PANSU(돈영향 있음). **단 어느 경우든 PRICE≠0·이중합산0·코팅1회는 불변.**

## 4. 판정

- ✅ **PRICE ≠ 0** — 제본비 단독 450,000(부당 9,000 × 50권). set 공식 매칭 정상.
- ✅ **이중합산 0** — comp 4종 상이(제본/인쇄/코팅/용지)·코팅 1회(COMP_COAT_MATTE seq3만)·용지비 순수 절가(코팅 차원 부재)·구성원 contribution 0·동일 comp 중복 0건.
- ✅ **코팅 1회 계상** — COMP_PAPER(46.65)는 순수 종이·COMP_COAT_MATTE가 코팅비. use_dims 상이로 동시매칭 불가.
- 🔴 **내지인쇄 + 내지용지비 BLOCKED 누락 = 완제가 미달** — 내지인쇄비 = [총내지매수행][도수열] × 총내지매수(=부수×⌈페이지/판걸이⌉, pricing.py:702 derive_inner_sheets). 100p·50권이면 총내지매수가 수백 → **책자 가격의 최대 항목 미청구**(파국적 과소청구). → 바인딩 절대 보류.

→ **S4 = CONDITIONAL**: READY 4비목 PRICE≠0 입증으로 그릇(PRF+fc) 적재는 GO, 그러나 완전 가격 불가(내지 BLOCKED)로 바인딩은 NO-GO 보류.
