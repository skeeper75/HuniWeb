# post-verify.md — V1 교정 사후검증 (별도 연결·영속·멱등·엔진)

> §21 · 2026-06-23 · COMMIT 후 새 연결로 영속·멱등·가격엔진 재실측.

## 1. 영속 (fresh connection SELECT)
| comp_cd | print_opt_cd | rows | sum | use_dims |
|---------|:--:|:--:|:--:|---|
| COMP_NAMECARD_STD_S1 | POPT_000001 | 2 | 7,300.00 | ["mat_cd","min_qty","print_opt_cd"] |
| COMP_NAMECARD_STD_S2 | POPT_000002 | 2 | 9,300.00 | ["mat_cd","min_qty","print_opt_cd"] |
| COMP_PCB_S1_20P | POPT_000001 | 117 | 505,980.00 | ["siz_cd","min_qty","print_opt_cd"] |
| COMP_PCB_S2_20P | POPT_000002 | 117 | 526,540.00 | ["siz_cd","min_qty","print_opt_cd"] |

GRAND 238행 / 1,049,120.00 — **불변 확인**(verbatim).

## 2. 멱등 (apply.sql 재실행)
전 UPDATE **0행** (IS DISTINCT 가드로 수렴) · VERBATIM/FK 가드 PASS · ROLLBACK.

## 3. 가격엔진 재실측 (COMMIT 후 라이브 evaluate_price)
| 케이스 | 결과 | 기대 |
|--------|:--:|:--:|
| 명함 031 단면 | 3,500 | 3,500 ✅ |
| 명함 031 양면 | 4,500 | 4,500 ✅ |
| 명함 032 단면 | 3,500 | 3,500 ✅ |
| 명함 033 단면 | 3,500 | 3,500 ✅ (공유 comp 동시 해소) |
| 엽서북 094 단면 | 11,000 | 11,000 ✅ (이중합산 제거) |
| 엽서북 094 양면 | 11,500 | 11,500 ✅ (이중합산 제거) |

→ 전 항목 PASS. silent 이중합산 해소·단가값 불변·무관 상품 영향 0.

## 4. FK·무결성
- 충전 print_opt_cd 전부 t_prt_print_options 실재(고아 0)·del_yn=N.
- 마스터 무변경·기초코드 무변경·webadmin 코드 무변경.
