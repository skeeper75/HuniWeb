# e2e-golden-trace-batch4.md — 굿즈파우치 종단 e2e 골든 추적 (게이트 재현·허용오차 0)

> hcc-conformance-gate K5 · 2026-06-23 · 라이브 읽기전용 SELECT 재실측. §18 golden-cases-goods-pouch.md GC-GP2 재현.
> 정석: 옵션 선택 → 차원 환원 → 단가행 매칭 → evaluate_price → final_price. 단가 verbatim 불변.

## 1. 대표 골든 GC-GP2 — 틴거울(PRD_000183) qty=100 (GP-1 단일고정가 + DSC_GOODSB)

| 단계 | 권위 기대(§18 적재 후) | 라이브 게이트 재실측 | 정합 |
|------|----------------------|---------------------|------|
| ① 옵션 선택 | variant 없음(GP-1 단일) | option_groups 0행(범위) | (옵션 없음·해당없음) |
| ② 차원 환원 | 단일가(차원 0) | — | (차원 0) |
| ③ base 산출 | product_prices.unit 3,000 × 100 = **300,000** | **pp 0행·frm 0행 → source=NONE** | 🔴 **단절 재현**(base 산출 불가) |
| ④ 할인 적용 | DSC_GOODSB 100~499=5% → ×0.95 | DSC_GOODSB_QTY 바인딩 O·디테일 verbatim | ✅ 인프라 정합(base 없어 무력) |
| ⑤ final_price | **285,000**(골든) | **0원**(가격산출 불가) | 🔴 골든 미달(결함 입증) |

**재현 SQL(게이트 직접 실행):**
- `SELECT count(*) FROM t_prd_product_prices WHERE prd_cd='PRD_000183'` → **0**
- `SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000183'` → **0**
- `SELECT prd_cd,dsc_tbl_cd FROM t_prd_product_discount_tables WHERE prd_cd='PRD_000183'` → **PRD_000183 / DSC_GOODSB_QTY**

## 2. 할인 인프라 verbatim 재대조 (라이브 t_dsc_discount_details — 허용오차 0)

게이트 직접 SELECT → 골든 §0-3과 **완전 일치**(min_qty/max_qty/dsc_rate):

| 할인타입 | 라이브 게이트 재실측 verbatim | 골든 §0-3 | 정합 |
|----------|------------------------------|----------|------|
| DSC_GOODSB_QTY | 1~99=0 · 100~499=5 · 500~=10 | 동일 | ✅ |
| DSC_GOODSA_QTY | 1~49=0 · 50~99=5 · 100~499=10 · 500~999=15 · 1000~=20 | 동일 | ✅ |
| DSC_SQUISHY_QTY | 1~1=0 · 2~9=10 · 10~29=15 · 30~49=20 · 50~99=25 · 100~499=30 · 500~999=40 · 1000~=50 | 동일(8구간) | ✅ |

## 3. 단절 지점 = ③ base 산출 (진원: t_prd_product_prices unit_price 미적재)

- 단가값 결함 아님: §18 C열 3,000 verbatim 옳음·할인 바인딩·디테일 전부 라이브 실재·정합.
- **base만 채우면 ⑤ 자동 성립**: 300,000 × 0.95 = 285,000(골든 일치). qty=100 → DSC_GOODSB 100~499 구간 → 5% 정률.
- 가장 비싼 결함 — 견적 자체가 안 나옴([[huni-widget-red-price-never-zero]] 위반 신호).

## 4. GP-2 종단(GC-GP7 사각손거울 M) — 이중 단절

- 권위: FORMULA variant 단가행(siz_cd=M=5,500) 룩업 기대.
- 라이브 재실측: formula 0행·option_groups 0행 → ① variant 선택 불가 + ③ 단가행 부재 = **이중 단절**(CPQ+가격 동시 미적재).
- 적재 시 평탄화하면 M 주문에 S가(5,000) 또는 L가(6,000) 오선택 = G-GP-3 돈크리티컬 → use_dims=[siz_cd] 판별차원 충전 강제.

## 5. 검증 결론

종단 추적이 **단절을 정확히 재현**했고(base 0=source=NONE), 할인 인프라는 허용오차 0 verbatim 정합. 정석 e2e는 "base 적재 1건"만으로 GP-1 전건 자동 성립함을 보였다. GP-2는 base+CPQ+판별차원 동반 적재 필요(클래스 B). 실 적재는 인간 승인 후 dbm-load-execution/dbm-cpq-option-mapping 위임.
