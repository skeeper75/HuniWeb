# 명함류 NAMECARD/PHOTOCARD .01 18개 밴드총액 ×qty 과대청구 — 무결성 게이트 verdict (I1~I7)

> 2026-06-29. integrity-gate(검증자) 독립 재실측. 생성측(load-inspector) 주장 **비신뢰**·직접 라이브+권위+엔진 재실측.
> 권위=인쇄상품가격표 260527(절대)·라이브 읽기전용 SELECT만·DB 미적재(COMMIT은 인간 승인 후 dbmap).
> 종합: **GO (18/18)** — 그룹C 입력단위 불확정 가정이 라이브로 해소되어 CONDITIONAL 0개.

---

## 종합 판정: GO (18개 전부)

| 게이트 | 결과 | 근거(재실측) |
|---|---|---|
| I1 격자 완전성 | PASS | 라이브 `.01` 명함/포토카드 comp = 정확히 18개(SELECT)·스코프와 1:1·false-negative 0 |
| I2 미적재 셀 실재 | N/A→PASS | 본 진단은 미적재가 아닌 prc_typ 오타이핑(정합 불일치 결)·미적재 셀 무 |
| I3 차원 누락 실재 | N/A→PASS | 차원 누락 아님(밴드/세트 단가행 전수 적재됨·SETUP 1행 적재됨) |
| I4 정합 불일치 실재 | **PASS** | 18개 전부 note=밴드총액/셋업/세트단가인데 prc_typ=.01(단가형×qty)=오적재 실재·false-positive 0 |
| I5 돈영향 정확 | **PASS** | 시뮬레이터 실호출로 교정 전 과대배수·엔진계약 재계산으로 교정 후 정답 전부 재현 |
| I6 codex 수렴 | PASS | codex gpt-5.5 high 4질문 전부 수렴(divergence 0) |
| I7 생성검증 독립성 | PASS | 생성측 복붙 0·라이브 SELECT·시뮬레이터 실호출·dryrun 실행·엔진 함수 재계산 직접 수행 |

**단일 FAIL 0 → NO-GO 아님.**

---

## I1 — 정답 격자 완전성 (PASS)
라이브 `t_prc_price_components`에서 `(comp_cd LIKE 'COMP_NAMECARD%' OR 'COMP_PHOTOCARD%') AND prc_typ_cd='PRICE_TYPE.01'` = **정확히 18행**. 스코프 18개와 1:1 — 놓친 결함(false-negative) 0. 단가행(`component_prices`) 전수 적재 확인:
- 그룹A: COAT(2행)·FOIL_HOLO/STD(각 9밴드)·PREMIUM(각 1)·WHITE(각 1)·BULK(50밴드 20~3000).
- 그룹B: SETUP_S1/S2 각 1행(min_qty NULL·up=5000).
- 그룹C: SET(min1·6000)·CLEAR_SET(min1·8500).

## I4 — 정합 불일치 실재 (PASS·false-positive 0)
note verbatim 재실측 — 18개 전부 prc_typ=.01이 의미와 불일치:
- **밴드총액(그룹A 14)**: "제작수량 N 이상" + (FOIL) "종이+동판+박가공비 합가 / 작업 1건 고정 금액". 예 FOIL_S1_HOLO: min200=24,800 → min1000=92,000(밴드별 총액). BULK per-unit 단조감소(250→42)=누진할인 밴드총액. → `.01`이면 총액×qty.
- **셋업비(그룹B 2)**: "(수량무관 셋업비)" min_qty=NULL up=5000.
- **세트단가(그룹C 2)**: "(20장1세트) 세트단가" min_qty=1.
- **false-positive 가드**: 진짜 per-매 .01 = **0개**(COAT/PREMIUM/WHITE도 "제작수량 N 이상" 밴드총액·per-장 아님). 휩쓸린 정상행 없음.

## I2/I3 — N/A(PASS)
미적재 셀·차원 누락 아님. 본 결함은 적재된 행의 prc_typ 오타이핑(정합 불일치 1종)뿐.

---

## I5 — 돈영향 정확 (PASS): 교정 전후 시뮬값 독립 재현

### 교정 전(현재 라이브 .01) — 시뮬레이터 인증 POST 실호출
| 상품 | qty | 실측 final | 정답 | 과대배수 | 분해(재실측) |
|---|---|---|---|---|---|
| PRD_037 오리지널박명함 | 200 | **1,019,200** | 24,200 | **×42** | 본체 FOIL_S1_STD(.02) 19,200 + SETUP(.01) **1,000,000**(=5,000×200) |
| PRD_037 | 1000 | **5,063,000** | 68,000 | **×74** | 본체 63,000 + SETUP **5,000,000** |
| PRD_024 포토카드 | 20 | **120,000** | 6,000 | **×20** | SET 6,000×20 |
| PRD_025 투명포토카드 | 20 | **170,000** | 8,500 | **×20** | CLEAR_SET 8,500×20 |

★037 폭증 원인 = **SETUP만**(.01). 본체 FOIL_S1_STD는 이미 .02 정상. → 생성측 진단과 완전 일치.

### 교정 후 — 엔진 계약(`component_subtotal`) 직접 재계산
| 상품 | qty | 교정후 | 정답 | 일치 |
|---|---|---|---|---|
| PRD_037 | 200 | 24,200(=19,200 .02 + 5,000 .03) | 24,200 | ✓ |
| PRD_037 | 1000 | 68,000(=63,000 + 5,000) | 68,000 | ✓ |
| PRD_024 | 20 | 6,000(=6,000/20×20) | 6,000 | ✓ |
| PRD_025 | 20 | 8,500(=8,500/20×20) | 8,500 | ✓ |

엔진 근거: pricing.py:203-204(`.03`=up 그대로 수량무관)·207-210(`.02`=up÷min_qty×qty)·212(`.01`=up×qty).

---

## 그룹B 확정: `.01 → .03` (수량무관 고정)
- **`.03` 분기 실재**: pricing.py:54·203-204 `if prc_typ==PRC_TYPE_FLAT: return up, up`. 직접 확인.
- **`.02` 불가 입증**: SETUP은 min_qty=NULL → component_subtotal에서 `base<=0` → **ValueError**("합가형 단가행에 수량구간 없어 환산 불가"). 재계산으로 실재 확인. min_qty=1 강제 주입해도 ×qty가 되어 의미 틀림.
- → **.03이 유일 정답.** codex 수렴.

## 그룹C 확정: 입력단위 = **장수(매)** → `.02 + min_qty 1→20` 정당
미확정 가정("장수 vs 세트수")을 **라이브로 해소**:
- PRD_024/025 `qty_unit_typ_cd` = **QTY_UNIT.02** = 코드마스터 `t_cod_base_codes`에서 **"매"**(장수). "세트"는 QTY_UNIT.04로 별도 존재하나 미사용.
- qty_rule = min**20**·incr**20** → 손님은 20장 단위(매)로 입력. 세트수면 incr=1이어야 함.
- → 손님 qty=장수 확정. 세트단가(20장총액)를 .02+min20으로 환산해야 `8500/20×20=8,500`. **.01 유지는 오답**(×20).
- `.02`만 바꾸고 min_qty=1 유지 시 `6000/1×20=120,000`(미해결) → **min1→20 재키잉 필수** 재계산으로 입증. codex 수렴.

---

## I6 — codex 수렴 (PASS)
codex gpt-5.5 high(read-only) 독립 2nd opinion: (a) 그룹B .02 실패(min_qty NULL→ValueError) 동의 (b) .03 정답 동의 (c) 그룹C min20 재키 필수 동의 (d) false-positive 0 동의. divergence 0.

## I7 — 생성검증 독립성 (PASS)
생성측 수치 복붙 없이 전부 직접 재실측: ① 18 comp prc_typ SELECT ② 단가행 note/min_qty/unit_price SELECT ③ BULK per-unit ladder SELECT ④ 바인딩(formula_components·product_price_formulas) SELECT ⑤ qty_rule·QTY_UNIT 코드마스터 SELECT ⑥ 시뮬레이터 simulate 실호출(교정 전) ⑦ component_subtotal 엔진계약 재계산(교정 후) ⑧ dryrun ROLLBACK 실행 ⑨ codex 독립 교차.

---

## dryrun 독립 재실행 (PASS)
`namecard-band-dryrun.sql`을 `psql -v ON_ERROR_STOP=1`로 직접 실행:
- 종결자 = **ROLLBACK**(bare COMMIT 없음·[[dryrun-vs-fix-script-commit-lesson]] 가드 통과).
- UPDATE 카운트 = **14 · 2 · 2 · 2**(기대치 정확 일치). 제약위반 0·rc=0.
- 멱등성: 각 UPDATE에 `AND prc_typ_cd='PRICE_TYPE.01'`(그룹A/B)·`AND min_qty=1`(그룹C) 가드 → 재실행 시 0행(멱등).

---

## 교정 명세 (승인 큐)

| # | comp_cd(들) | 교정 | 대상 t_* | 재현 | 우선순위 |
|---|---|---|---|---|---|
| A | 14개(COAT_S1/S2·FOIL_S1_HOLO·FOIL_S2_HOLO·FOIL_S2_STD·PREMIUM_S1/S2_MGA/MGB·WHITE_S1W/S2W_CL/NOCL·PHOTOCARD_BULK) | prc_typ .01→**.02** | t_prc_price_components | dryrun §그룹A(14행) | P1 예방(미바인딩) |
| B | FOIL_SETUP_S1_STD·FOIL_SETUP_S2_STD | prc_typ .01→**.03** | t_prc_price_components | dryrun §그룹B(2행) | **P0 active(S1=PRD_037)** / S2 예방 |
| C | PHOTOCARD_SET·PHOTOCARD_CLEAR_SET | prc_typ .01→**.02** + min_qty **1→20** | t_prc_price_components + t_prc_component_prices | dryrun §그룹C(2+2행) | **P0 active(024·025)** |

- **active 긴급(현재 과대청구 실증) 3건**: FOIL_SETUP_S1_STD(PRD_037 ×42~74)·PHOTOCARD_SET(PRD_024 ×20)·PHOTOCARD_CLEAR_SET(PRD_025 ×20).
- **예방(미바인딩) 15건**: 바인딩 시 즉시 과대청구 → 바인딩 전 선교정. (SETUP_S2도 어떤 공식에도 미포함 확인.)
- **라우팅**: dbm-load-execution / dbm-correctness-audit. 인간 승인 후 COMMIT(dryrun→fix 전환). webadmin 엔진 코드 미변경(read-only).
- **교정 후 검증 필수**: 시뮬레이터 재실증 037=24,200 · 024=6,000 · 025=8,500.

---

## GO 카운트 요약
- **GO: 18/18** (CONDITIONAL 0). 그룹C 입력단위(장수) 라이브 해소로 미확정 가정 0.
- **승인 큐**: 3 트랙(A 14행 .02 / B 2행 .03 / C 2행 .02+2행 min20) → 인간 승인 후 dbmap COMMIT.
- 이 GO는 §18 명함류 가격공식 설계의 신뢰 기반(밴드총액/셋업/세트 prc_typ 정합 확정).
