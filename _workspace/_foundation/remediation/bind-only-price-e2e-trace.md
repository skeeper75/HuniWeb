# BIND_ONLY S4 가격 e2e 종단 재현 (돈 크리티컬)

검증일 2026-06-26 · pricing.py `evaluate_price`→`_evaluate_formula`→`match_component`→`component_subtotal` 경로 재현(순수함수 verbatim 이식·드리프트 0).

## 가격 사슬 구조 (16건 공통)

```
evaluate_price(prd_cd, selections{siz_width,siz_height,mat_cd}, qty)
  └ 상품 직접단가 없음 → 상품 공식 PRF_CLR_ACRYL / PRF_COROTTO_ACRYL (FORMULA)
      └ _evaluate_formula: fc 1행 → 본체 comp 1개
          · CLR_ACRYL: COMP_ACRYL_CLEAR3T  use_dims=[siz_width,siz_height,mat_cd]  PRICE_TYPE.02
          · COROTTO  : COMP_ACRYL_COROTTO   use_dims=[siz_width,siz_height]         PRICE_TYPE.01
          └ match_component(단가행, sel, qty)
              · 비수량차원(mat_cd): CLR3T 행 mat_cd 채워짐→동일매칭 / COROTTO 행 mat_cd=NULL→와일드카드
              · 구간차원(siz_width,siz_height): ceiling = '주문값 이상 임계 중 최소'
              · ceiling (w,h) 쌍에 행 실재 → unit_price × qty = subtotal
              · 행 없으면(no_tier_row) → matched_row=None → subtotal=0 → 본체 PRICE=0
  └ 할인(수량구간·등급) → final_price
```

본체 comp 1개뿐 = subtotal이 곧 base_amount. 본체 PRICE=0이면 final_price=0(돈 결함).

## 종단 1셋 완전 재계산 — GO 예시 (160 아크릴자유형스탠드)

- 입력: siz_cd=120x120(cut 120×120·등록), mat_cd=MAT_000043(dflt), qty=1.
- ceiling: width 120→120(행존재), height 120→120(행존재). (120,120,MAT_043) 행 실재.
- match → unit_price(120x120 행) × 1 = subtotal ≠ 0. **PRICE≠0 → final_price 산출 가능. GO**.

## 종단 1셋 완전 재계산 — GO 예시 (164 COROTTO, 커버 구간)

- 입력: siz_width=30, siz_height=30, qty=1 (nonspec).
- ceiling: 30→30, 30→30. comp_price_id=24128 (30×30) unit_price=3,600 실재.
- subtotal = 3,600 × 1 = **3,600 ≠ 0**. → 생성가 스폿 주장(30x30→3600) **TRUE**(재현 일치).

## 종단 1셋 완전 재계산 — FAIL 예시 (164 COROTTO, 미커버 구간)

- 입력: siz_width=30, siz_height=80, qty=1 (nonspec 범위 내·정당한 주문).
- COROTTO 매트릭스 width=30 행의 height = {30,40,60,70} (80 없음·max=70).
- ceiling: width 30→30. height 80 → '80 이상 임계' 중 width-group 전체 height tier {30..80} 에서 80 존재(80x80 등 타 width). 그러나 **선택된 width=30 그룹엔 (30,80) 행 없음** → tier_rows=[] → **no_tier_row → 본체 PRICE=0**.
- final_price = 0. **돈 결함 — 30x80 코롯토는 견적 0원**.

## 종단 1셋 완전 재계산 — FAIL 예시 (166 아크릴카라비너, siz_cd 모드)

- 등록 사이즈 = 43×71mm(하트자물쇠) 1종. dflt MAT_043.
- ceiling: width 43→50(최소 ≥43), height 71→80(최소 ≥71). (50,80,MAT_043) 행?
- CLR3T MAT_043 width=50 행의 height = {30,50,60,70,90,140,160,180,200} — **80 없음** → no_tier_row → **PRICE=0**.
- 166은 등록 사이즈가 단 1종인데 그게 미커버 → 전건 견적불가. **NO-GO**.

## 생성가 스폿 주장 검증

| 생성가 주장 | 재현 결과 | 판정 |
|------------|----------|------|
| 147 50x50→4800 | comp_price_id=5249 (50,50,MAT_043) unit_price=4,800 실재 | TRUE(단 cherry-pick — 대칭점만) |
| 164 30x30→3600 | comp_price_id=24128 (30,30) unit_price=3,600 실재 | TRUE(단 cherry-pick) |
| "전 사이즈 covered" | 격자 스윕 결과 9 nonspec상품 24~57% 미커버 + 166 등록사이즈 미커버 | **REFUTED** |

생성가 스폿은 매트릭스에 **행이 있는 대칭/대각 점**만 선택해 PRICE≠0을 보였고, 희소 격자의 홀(비대칭·중간치수)은 검증 누락. 이중합산은 본체 comp 1개뿐이라 구조적으로 0.

## 이중합산 0 확인

- 16건 전부 t_prd_product_sets 부모 아님 → 셋트 합산 경로 미진입.
- 공식당 fc 1행(본체 comp 1개) → 동일 비용 중복 가산 불가. **이중합산 0**.
