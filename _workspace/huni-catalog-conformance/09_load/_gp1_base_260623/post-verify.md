# post-verify.md — §21 R-GP4-1 사후 라이브 재실측

> 2026-06-23 · COMMIT 후 라이브 읽기전용 재실측. 모든 게이트 PASS.

## 재실측 결과

| # | 검증 | 기대 | 실측 | 판정 |
|---|------|------|------|------|
| 1 | 적재행 수(apply_ymd=2026-06-10) | 26 | 26 | ✅ |
| 2 | FK 고아(prd_cd→t_prd_products) | 0 | 0 | ✅ |
| 3 | verbatim 26건 mismatch | 0 | 0 | ✅ |
| 4 | G-GP-5: 반팔/후드 product_prices | 0 | 0 | ✅ |
| 5 | product_prices 전체 distinct prd | 26 | 26 | ✅ |
| 6 | 멱등 재실행 delta | 0 (INSERT 0 0) | 0 | ✅ |
| 7 | 견적 PRODUCT_PRICE unit×qty | 정상 | 정상 | ✅ |

## 견적 0→정상 실증 (라이브 최종)

| prd | unit_price | qty=1 | qty=10 |
|-----|-----------|-------|--------|
| PRD_000185 카드거울 | 2500 | 2500 | 25000 |
| PRD_000223 말랑포카홀더 | 14000 | 14000 | 140000 |
| PRD_000272 캔버스 포켓숄더백 | 58000 | 58000 | 580000 |

## 비대상 미오염 확인

- t_prd_product_prices 전체 = 26행 = 26 distinct prd (모두 GP-1 base). GP-2/PROC/COUNT/NOPRICE 오염 0.
- 보류 2건(반팔티셔츠 PRD_000206·후드티셔츠 PRD_000209) product_prices 0행 = G-GP-5 준수.

## 무손상

- 단가 verbatim(상품마스터260610 C열)·변경 0.
- 기초코드 마스터(t_mat/t_siz/t_prc) 미수정.
- component_prices 영향 0(가격종속 미접촉).
