# 인쇄옵션(print_option) 정합 재검증 v2

작성 2026-06-05 · expected = B 규칙(R-CLR-1) 코드화. DB read-only.
산출: `expected/print_option-expected.csv`(147행) · `print_option-mismatches-v2.csv`.

---

## 4분류

| 분류 | 행 | 상품 | 1차 대비 |
|------|:--:|:----:|---------|
| MATCH | 109 | 74(MATCH-only) | 1차 91 |
| MISSING | 3 | 3 | 1차 1 |
| EXTRA | 63 | 21 | 1차 0 |
| MISMATCH | 0 | 0 | 0 |

## expected 생성 근거

- **R-CLR-1**: 엑셀 `단면`→print_side='단면'(front CLR_000005·back CLR_000001), `양면`→print_side='양면'(front·back CLR_000005). 자연키=print_side.
- 별색은 인쇄옵션 아닌 **공정 라우팅**(R-PROC-3) — process 속성에서 검증(별색 거짓 MISSING 회피).

## MISSING 3

| 상품 | 결손 | 판정 |
|------|------|------|
| 접착투명포스터 | 단면 | 1차와 동일 진짜 MISSING |
| 벽걸이캘린더·와이드벽걸이캘린더 | 양면 | 캘린더 양면옵션 미적재(신규 검출) |

## EXTRA 63 — 플래그

DB print-options에 단면/양면 행이 있으나 엑셀 인쇄옵션 토큰이 없는 상품 21종. 엑셀 측 인쇄옵션 컬럼 미기재(기본 단/양면 자동부여) 가능 → 정당 적재. 삭제 단정 금지·플래그.

## 판정: **GO**

- 1차 GO 유지. 공통상품 거의 전건 정합, 별색 공정분기로 거짓 MISSING 회피. MISSING 3건만 적재 잔여.
