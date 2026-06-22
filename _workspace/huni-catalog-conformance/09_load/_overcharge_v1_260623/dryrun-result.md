# dryrun-result.md — V1 과대청구 교정 DRY-RUN (라이브 evaluate_price 실호출)

> §21 · 2026-06-23 · `dryrun_evaluate.py`(Django 부트스트랩·transaction.atomic + 강제 ROLLBACK).
> 교정을 트랜잭션 내 적용 → **실 가격엔진 evaluate_price 호출**로 택일 분리 실증 → ROLLBACK(미커밋).

## 실증 결과 (BEFORE 이중합산 → AFTER 택일 단일)

| 상품 | BEFORE (print_opt_cd NULL=와일드카드) | 단면(POPT_000001) | 양면(POPT_000002) |
|------|:---:|:---:|:---:|
| 명함 PRD_000031 (qty=100·MAT_000074) | **8,000** (3500+4500 둘 다) | **3,500** ✅ | **4,500** ✅ |
| 엽서북 PRD_000094 (qty=2·SIZ_000003) | **22,500** (11000+11500 둘 다) | **11,000** ✅ | **11,500** ✅ |

- 택일 분리 **SUCCESS** · verbatim **PASS** (단가행 합 불변).
- ★094 codex 신규(양방향) 확증: BEFORE는 양면 선택 시에도 단면(11,000)이 합산되던 **양방향 과대**.
  → S1=단면·S2=양면 양방향 충전으로 단면=11,000·양면=11,500 **각 방향 모두** 올바른 단일값.

## 엔진 인과 (pricing.py 근거)
- `print_opt_cd` ∈ `NON_QTY_DIMS`(:42) → `_row_matches`(:82-94)가 행의 비-NULL print_opt_cd를 선택값과 정확매칭 요구.
- BEFORE: 전 행 print_opt_cd=NULL → 와일드카드(:87-88) → S1·S2 둘 다 매칭 → P2-3 included 합산(silent).
- AFTER: S1행=POPT_000001·S2행=POPT_000002 충전 → 단면 선택 시 S2행이 `_row_matches` False(:89) → 자연 탈락.
- use_dims 토큰은 `_match_entry`(:505-508)의 "판별차원 없음" 경고를 제거(문서화·정합). 실 필터링은 행값이 구동.

## 사후 라이브(COMMIT 후) 재확인
- 031/032/033 단면=3,500·031 양면=4,500 · 094 단면=11,000·양면=11,500 — 영속 확인.
