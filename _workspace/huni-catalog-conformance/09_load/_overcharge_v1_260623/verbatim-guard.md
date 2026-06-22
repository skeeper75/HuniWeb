# verbatim-guard.md — 단가값 불변 게이트 (V1 교정)

> §21 · 2026-06-23 · 교정 = 판별축(print_opt_cd) 충전 + use_dims 토큰 등재만. **unit_price SET 0개.**

## 정적 보장
- `apply.sql`에 `SET unit_price` 구문 **0개** (grep 검증). 교정 컬럼 = `print_opt_cd`(component_prices)·`use_dims`(price_components)뿐.

## 동적 게이트 (apply.sql G-1, 트랜잭션 내)
적재 전후 대상 comp별 단가행 **행수·합** 동일성 검증 → 불일치 시 `RAISE EXCEPTION`.

| comp_cd | 단가행 | sum(unit_price) (불변) |
|---------|:--:|:--:|
| COMP_NAMECARD_STD_S1 | 2 | 7,300.00 |
| COMP_NAMECARD_STD_S2 | 2 | 9,300.00 |
| COMP_PCB_S1_20P | 117 | 505,980.00 |
| COMP_PCB_S2_20P | 117 | 526,540.00 |
| **GRAND** | **238** | **1,049,120.00** |

- DRY-RUN·COMMIT·idempotency 재실행 전부 **VERBATIM GUARD PASSED**.
- 사후검증(fresh connection): GRAND 238행 / 1,049,120.00 **불변 확인**.

## 결론
단가 숫자 변경 0. 교정은 "둘 중 하나만 매칭되게" 판별축을 분화한 것뿐(8,000 합산 → 3,500 단일).
