# 가격 파일럿 종단 설계 — 떡메모지(PRD_000097) load-ready

생성: hsp-set-designer · 권위=set-price-authority §1.4(고정가형 [수량행][옵션열])·round-16 postcard-book-memo 분해·라이브 실측(2026-06-25) · 단가=가격표(260527) verbatim·날조 0 · **DB 미적재**(실 COMMIT 별도 인간 승인) · search-before-mint(신규 mint 0).

---

## 0. 파일럿 선정 근거 (5건 중 097)

| 기준 | 097 떡메 | 책자류(072/077/082) | 포토북(100) |
|---|---|---|---|
| 민팅 준비도 | 🟢 READY | 🔴 BLOCKED | 🔴 BLOCKED |
| 신규 mint 수 | **0** | 다수 | 다수 |
| 선행 의존 | 없음 | W1·W2(돈 크리티컬) | 표지5종·단가 평면화 |
| 작업량 | 바인딩 **1행** | comp+단가+공식+배선 | comp+평면화 |
| 위험도 | 최저(고정가·이중합산 0) | 높음(부품 합산·이중계상 가드) | 높음(base24+per2p) |
| 대표성 | 고정가형 대표(엽서북 094 동형 검증된 패턴) | 원자합산형 대표(077/082 전파) | 통합형 단독 |

**선정 = 097 떡메모지.** orchestrator 후보 우선순위(097 또는 072) 중, 072는 BLOCKED(comp 0행·신규 mint 다수·선행 W1/W2 미해소)이므로 **즉시 적재 가능한 유일 READY 셋트인 097**을 파일럿으로 종단 설계. 검증된 고정가 패턴(094 엽서북 S4 게이트 450,000 PRICE≠0 입증)과 동형이라 저위험·돈 안전.

---

## 1. 가격 모델 (set-price-authority §1.4 고정가형)

```
판매가 = [수량행][옵션열]   (calc-formula L72 · *(가격포함))
```

- 떡메모지 = **단일 완제품 통합단가**(COMP_TTEOKME)가 내지·표지·제본·용지 전부 내장하는 고정가형.
- evaluate_set_price 종단:
  - 구성원 098(떡메모지-내지) = 가격공식 0 → **비기여**(BOM 구성만·가격 0).
  - 셋트 완제품 097 자기 공식 PRF_TTEOKME_FIXED → COMP_TTEOKME 단가 = 곧 판매가.
- **이중합산 0**: 단일 comp·구성원 비기여(고정가형 정합·엽서북 094 동형).

---

## 2. load-ready 설계 (신규 mint 0 — 전부 라이브 실재 재사용)

### 2.1 PRF formula 정의 — ✅ 재사용 (신규 0)

| frm_cd | frm_nm | use_yn | 상태 |
|---|---|---|---|
| PRF_TTEOKME_FIXED | 떡메모지 사이즈/권당장수/장수별 단가 | Y | **라이브 실재** — 손대지 않음 |

### 2.2 formula_components (비목별) — ✅ 재사용 (신규 0)

| frm_cd | comp_cd | disp_seq | addtn_yn | prc_typ(comp) | use_dims | 상태 |
|---|---|---|---|---|---|---|
| PRF_TTEOKME_FIXED | COMP_TTEOKME | 1 | Y | PRICE_TYPE.01 단가형 | ["siz_cd","bdl_qty","min_qty"] | **라이브 실재** |

- 단일 비목(addtn_yn=Y·Σ 1개). 고정가형이라 비목 분해 없음(엽서북은 S1/S2 면별 4 comp이나 떡메는 권당장수를 bdl_qty 차원으로 흡수해 1 comp — round-16 §1 권위).

### 2.3 price_components — ✅ 재사용 (신규 0)

| comp_cd | comp_nm | comp_typ_cd | prc_typ_cd | use_dims | use_yn |
|---|---|---|---|---|---|
| COMP_TTEOKME | 떡메모지 완제품가(권당장수) | PRC_COMPONENT_TYPE.06 | PRICE_TYPE.01 | ["siz_cd","bdl_qty","min_qty"] | Y |

### 2.4 component_prices (verbatim 단가·출처) — ✅ 재사용 (신규 0)

- COMP_TTEOKME **112행** 라이브 실재. 출처 = 인쇄상품 가격표(260527) 엽서북/떡메 시트 → round-16 `20_price-import/postcard-book-memo/postcard-book-memo-import.xlsx` `4_component_prices_RU`(B2 떡메 112행) → 라이브 적재됨. 무손실 round-trip 28수량×4열=112 검산(decomposition §6).
- verbatim 단가 샘플(라이브 SELECT·날조 0):

| siz_cd | siz_nm | bdl_qty | min_qty | unit_price | 출처(가격표 셀) |
|---|---|---|---|---|---|
| SIZ_000119 | 90x90 | 50 | 6 | 3,000 | 90x90 / 50장 / 6권 |
| SIZ_000119 | 90x90 | 50 | 30 | **2,000** | 90x90 / 50장 / 30권 ← 골든 매칭행 |
| SIZ_000119 | 90x90 | 50 | 600 | 850 | 90x90 / 50장 / 600권 |
| SIZ_000266 | 70x120 | 100 | 6 | **3,200** | 70x120 / 100장 / 6권 ← 골든2 매칭행 |

→ **단가행 신규 생성 0** — 적재 작업 일절 없음(이미 라이브).

### 2.5 셋트 바인딩 (유일 작업) — 1행 INSERT

| prd_cd | frm_cd | apply_bgn_ymd | note |
|---|---|---|---|
| PRD_000097 | PRF_TTEOKME_FIXED | 2026-06-01 | 떡메모지 셋트 완제품 고정가 공식 바인딩(round-16 단절2 해소·CFM-097) |

- 대상 테이블 `t_prd_product_price_formulas`. **실 PK = (prd_cd, apply_bgn_ymd)**(라이브 pg_constraint 실측 — frm_cd는 PK 아님·인덱스 ix만). reg_dt NOT NULL DEFAULT now().
- ★PK 함의: 한 상품은 같은 적용일에 공식 1개만 가능. 097 현재 0행이라 충돌 0.
- apply_bgn_ymd=2026-06-01 = 엽서북 094 바인딩·COMP_TTEOKME 단가행 apply_ymd 전건과 동일(추정 회피·CFM-097 인간 확인 대기).
- **멱등 키** = (prd_cd, apply_bgn_ymd). ON CONFLICT DO NOTHING. 롤백전용 DRY-RUN 멱등 delta 0 입증(before 0→after_1st 1→after_2nd 1[INSERT 0 0]→rollback 후 0).

---

## 3. evaluate_set_price 종단 재현 (골든·price-e2e-trace 패턴·손계산)

### 골든1 — 90x90 / 50장1권 / 30권

```
evaluate_set_price(PRD_000097, members=[{sub_prd_cd:PRD_000098, qty:?}],
                   set_selections={siz_cd:SIZ_000119, bdl_qty:50}, copies=30)

[A] 구성원 098(떡메모지-내지) — pricing.py:759-786
    evaluate_price({prd_cd:PRD_000098}, …) → 가격공식 바인딩 0행 → base.amount=0
    warning "[내지] 유효수량 산출 실패 — 합산 제외" · contribution=0 · included=False
    → 구성원 합산 기여 = 0  (098 t_prd_product_price_formulas=0행 실측)

[B] 셋트 완제품 자기 공식 set_eval — pricing.py:789
    set_eval = evaluate_price({prd_cd:PRD_000097}, {siz_cd:SIZ_000119, bdl_qty:50}, 30)
      바인딩(신규 1행) → PRF_TTEOKME_FIXED
      _evaluate_formula → formula_components 1건: COMP_TTEOKME(addtn_yn=Y)
        match_component(COMP_TTEOKME rows, {siz_cd:SIZ_000119,bdl_qty:50}, qty=30):
          _row_matches: NON_QTY_DIMS 정확매칭 → siz_cd=SIZ_000119·bdl_qty=50 매칭
                        (proc/opt/clr/mat/coat NULL=와일드카드)
          min_qty 티어: 30 이하 최대 임계 = 30 → unit_price=2,000 (라이브 실측·1행·모호성 0)
        component_subtotal(단가형 .01) = 2,000 × 30 = 60,000 · included=True
      included_sum = 60,000 → set_eval.base.amount = 60,000

[C] base_total = 0 + 60,000 = 60,000

[D] 할인 (합산 후 셋트 1회) — pricing.py:804
    _quantity_discount(PRD_000097, 60,000, 30) → t_prd_product_discount_tables(097)=0행(실측) → 없음
    grade_cd 없음 → 등급할인 없음
    running = 60,000

[E] final_price = round_won(60,000) = 60,000  ✅  PRICE ≠ 0
```

**골든1 = 60,000원** (90x90·50장·30권). PRICE≠0 입증.

### 골든2 — 70x120 / 100장1권 / 6권 (최소구간 경계)

```
set_selections={siz_cd:SIZ_000266, bdl_qty:100}, copies=6
  match_component: siz_cd=SIZ_000266·bdl_qty=100 매칭·min_qty 티어 6 이하 최대=6 → unit_price=3,200
  component_subtotal = 3,200 × 6 = 19,200
  base_total=19,200 · 할인0 → final = 19,200  ✅
```

**골든2 = 19,200원**.

### 이중합산 점검 (돈 크리티컬)

- COMP_TTEOKME = **단일 comp**(완제품 통합단가). 다른 비목 comp 없음 → comp간 중복 0.
- 구성원 098 가격공식 0행 → 구성원 기여 0 → 셋트공식과 이중계상 0.
- bdl_qty가 NON_QTY_DIMS(정확매칭)이고 단가행 1행만 매칭(모호성 0·라이브 COUNT=1 실측) → silent 다중매칭 0.
→ **이중합산 = 0** (입증).

---

## 4. search-before-mint · FK 위상 · 멱등 키

- **search-before-mint**: PRF·comp·formula_components·component_prices 전부 라이브 실재(신규 mint 0). 작업=바인딩 1행 INSERT(상품↔공식 연결·mint 아님).
- **FK 위상**: t_prd_product_price_formulas는 prd_cd(t_prd_products·097 실재)·frm_cd(t_prc_price_formulas·PRF_TTEOKME_FIXED 실재) 양 FK 선행 충족. 신규 선행 적재 불요.
- **멱등 키** = 복합 PK(prd_cd, frm_cd, apply_bgn_ymd). ON CONFLICT DO NOTHING(현 0행·충돌 0·재실행 안전).
- **셋트 구성행(t_prd_product_sets)**: 097→098 이미 라이브 실재(disp_seq=1·sub_prd_qty=1·del_yn=N). **본 가격 파일럿은 t_prd_product_sets 변경 없음**(구성행은 이전 §23 세션 COMMIT 완료). 본 트랙=가격 바인딩 전용.

---

## 5. 적재 경계 (DB 미적재)

- 본 산출 = 바인딩 1행 load-ready 설계 + 골든 손계산까지. **실 INSERT/COMMIT은 게이트 GO + 인간 승인 후 hsp-load-executor**.
- CFM-097(apply_bgn_ymd=2026-06-01 적정성) 인간 확인 후 COMMIT 권고.
- 게이트(hsp-set-gate) S4 = evaluate_set_price 재계산으로 골든1=60,000·골든2=19,200 독립 재현 검사 대상.

---

## 6. 출처 (날조 0)

- 권위 공식: set-price-authority.md §1.4(calc-formula L72 고정가형)·`24_master-extract-260610/stationery-l1.csv` L14(떡메 *가격표참고)·`booklet-l1.csv` L56-57(90x90·70x120·백모조120·단면·떡제본).
- 단가 분해: `20_price-import/postcard-book-memo/postcard-book-memo-decomposition.md`(B2 떡메 §1~6·무손실 580=580·단절2 바인딩 누락).
- 라이브 실측(2026-06-25 읽기전용 SELECT): PRF_TTEOKME_FIXED 정의·COMP_TTEOKME comp+112 단가행·097 바인딩 0행·098 가격공식 0행·097 discount 0행·골든 티어 매칭(min_qty=30→2,000·min_qty=6→3,200·각 1행).
- 엔진 계약: `raw/webadmin/webadmin/catalog/pricing.py:718`(evaluate_set_price)·:82(_row_matches)·:122(match_component 티어)·:181(component_subtotal 단가형).
