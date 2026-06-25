# 072 하드커버책자 하이브리드 — S4 셋트 가격 종단 재현 (독립 손계산)

검증: hsp-set-gate · 2026-06-25 · evaluate_set_price(pricing.py:718) 엔진 pure-helper 직접 재현 · 단가 verbatim(라이브 SELECT) · COMMIT 0

## 골든 케이스 (설계 §5.1과 동일)
- 셋트 PRD_000072 / 완제(내지)사이즈 A5(SIZ_000170) / 표지펼침 ≈SIZ_000326(390x290) → 출력판형 국4절(SIZ_000499)
- 내지 양면칼라(POPT_000002·S2) / 표지 단면칼라(POPT_000002·S1) / 100p / 무광단면(PROC_000015·coat_side_cnt=1) / 제본 PROC_000023 / copies=50

## 라이브 실측 단가 (verbatim)
| comp | dim | min_qty tier | unit |
|---|---|---|---|
| S1 표지인쇄 | 국4절·POPT_000002 | 50 | 550 |
| COMP_COAT_MATTE | 국4절·coat_side_cnt=1 | 50 | 700 |
| COMP_PAPER | 국4절·MAT_000078(아트150) | (단가형·min1) | 46.65 |
| S2 내지인쇄 | 국4절·POPT_000002 | 10→1600 / 1200→326 | — |
| SSABARI 제본 | PROC_000023 | 50 | 9,000 |
| fn_calc_pansu(국4절,SIZ_000326)=1 · (국4절,A5)=4 · (국4절,국4절)=0 · (국4절,A4)=2 (라이브) |

## [A] 구성원 표지 073 → evaluate_price(073, sel, qty=50) → PRF_HC_COVER
```
needs_plate=True (S1·COAT·PAPER 전부 plt_siz_cd 보유)
pansu = _calc_pansu(국4절, 표지펼침SIZ_000326) = 1
seq1 표지인쇄 S1: comp_qty=plate_qty(50,1)=50 · tier@50=550 → 550×50 = 27,500
seq2 표지코팅 COAT 단면: comp_qty=plate_qty(50,1)=50 · tier@50=700 → 700×50 = 35,000
seq3 표지용지 PAPER: comp_qty=plate_qty(50,1)=50 · 단가형 46.65 → 46.65×50 = 2,332.5
표지 contribution = 64,832.5
```
✅ 펼침 siz로 pansu=1 → 출력매수=copies=50 정합(완제 A5 4-up 과소청구 회피 확인).

## [A'] 면지 074/075/076(택1) → 무료
COMP_PAPER 면지색 MAT_000001/2/3 단가행 0행(실측) → has_formula 없음·기여 0.

## [B] 셋트 본체 072 → evaluate_price(072, set_sel, copies=50) → PRF_HC_BODY
```
pansu_inner = _calc_pansu(국4절, A5) = 4 (내지 4-up)
seq1 내지인쇄 S2: comp_qty=plate_qty(50,4)=⌈50/4⌉=13 · tier@13→10=1600 → 1600×13 = 20,800   ← ★copies모델·페이지곱 미반영
seq2 내지용지 PAPER: 072 내지자재 미등록·MAT_000246 PAPER행 0 → no-match = 0   ← ★자재 미등록
seq3 제본 SSABARI: use_dims에 plt_siz 없음 → comp_qty=copies=50 · tier@50=9000 → 9000×50 = 450,000
본체 contribution = 20,800 + 0 + 450,000 = 470,800
```

## [C] base_total = 64,832.5 + 0 + 470,800 = **535,632.5원** ✅ PRICE≠0
## [D] 할인: 072 discount_tables 0행 → 없음 → final = **535,632.5원**

---

## ★CFM-INNER-TOTSHEET 영향 (돈 크리티컬·게이트 독립 정량)
현 본체모델 vs 권위 정석(총내지매수):
```
정석 per_book 인쇄장수 = ⌈pages/pansu⌉ = ⌈100/4⌉ = 25
정석 총내지매수 = copies × per_book = 50 × 25 = 1,250매
정석 내지인쇄 = S2 tier(1250)→1200=326 × 1,250 = 407,500
현 본체모델 내지인쇄 = 20,800
과소청구 = 407,500 − 20,800 = 386,700원 (19.6배 과소)
```
→ 골든 정합 base_total은 정석 기준 **약 922,300원**이어야 함(535,632.5 + 386,700 + 내지용지). 현 모델은 약 42% 저청구. **본체 072 바인딩은 이 결함 해소 전 금지.**

## 이중합산 검사 — 0
표지(PRF_HC_COVER)·본체(PRF_HC_BODY) frm_cd 분리 → match_component 공식별 독립·코팅 표지1회·제본 본체1회·동일 comp 중복 가산 없음. ✅
