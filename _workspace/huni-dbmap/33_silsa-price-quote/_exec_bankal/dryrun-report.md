# 반칼 모양 062/063 가격 연결 — 롤백전용 DRY-RUN 리포트 (R1~R6) — round-23 항목 7

> **실행** 2026-06-18 · 라이브 `railway` DB read-only(BEGIN…ROLLBACK·COMMIT 0) · psql.
> 입력 권위 = arbiter `bankal-shapes-resolution.md`(BK-1/BK-2) + 라이브 실측.

## 1. 영향행수 (PASS 1)

```
BK-1/BK-2  INSERT 2  (PRD_000062·PRD_000063 → PRF_STK_FIXED 바인딩)
가격행 INSERT 0       (형상=칼틀·B01 단가 재사용)
ROLLBACK (COMMIT 0)
```
**영향행 2** (바인딩 INSERT만). COMP_STK_PRINT 1074행 불변. 라이브 무변경.

## 2. 멱등 2-pass (단일 트랜잭션·delta 0)

| 스텝 | PASS 1 | PASS 2 | 판정 |
|------|:--:|:--:|:--:|
| BK 바인딩 | INSERT 2 | INSERT **0** | 멱등 ✅ (PK (prd,apply_bgn_ymd) NOT EXISTS) |

**delta 0 — 재실행 안전.**

## 3. 골든 (062/063 = B01 단가 직접 공유·형상 무관 동일가)

| # | 룩업 | 기대 | 실측 | 출처 |
|---|------|------|------|------|
| G1 | 062 124x186(SIZ_059) 유포153 mq3 | 5900 | **5900.00** | B01 반칼 단가 재사용(형상=팬시 칼틀·동일가) |
| G2 | 063 124x186(SIZ_059) 투명162 mq1 | 7000 | **7000.00** | B01 투명 단가 재사용 |

→ 062/063 바인딩 후 124x186·90x190 사이즈 가격 즉시 산출(엔진 매칭). 형상(팬시) 가격 무관 입증.

## 4. 무결성

| 검사 | 결과 |
|------|------|
| 가격행 추가 0 (COMP_STK_PRINT 행수 불변) | 1074 → 1074 ✅ |
| 동시매칭 0 (062/063 각 1 바인딩·PK 충돌 0) | 062=1·063=1 ✅ |
| FK 고아 0 (바인딩 frm→price_formulas·prd→products) | orphan_bind = **0** ✅ |
| COMMIT 0 / ROLLBACK | ✅ 라이브 무변경 |

## 5. R1~R6 판정

| 게이트 | 항목 | 판정 |
|--------|------|:--:|
| R1 | 멱등 INSERT (PK NOT EXISTS·ON CONFLICT 미사용=조합PK) | ✅ |
| R2 | 단일 트랜잭션 (BEGIN…ROLLBACK·ON_ERROR_STOP·중간 COMMIT 0) | ✅ |
| R3 | 로더 (apply.sh·.env.local·DRY-RUN 기본·비밀값 비노출·백업 1 CSV) | ✅ |
| R4 | FK 고아 0·가격행 추가 0 | ✅ |
| R5 | 멱등 2-pass delta 0 | ✅ |
| R6 | 골든 재현(062/063=B01 단가)·COMMIT 0 | ✅ |

**DRY-RUN GO** — 실 COMMIT·blocked 해소는 인간 승인. `dbm-validator` 독립 R1~R6 게이트 후 비준(자체승인 금지).
