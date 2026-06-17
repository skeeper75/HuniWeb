# 반칼 058~061 가능분 — 롤백전용 DRY-RUN 리포트 (R1~R6) — round-23 항목 7 (BK6)

> **실행** 2026-06-18 · 라이브 `railway` DB read-only(BEGIN…ROLLBACK·COMMIT 0) · psql.
> 입력 권위 = arbiter `bankal-058-064-deepcheck.md`(BK6) + 사용자 컨펌(A5=124x186 동일가·A4 반칼 분리) + `sticker-import.xlsx`(verbatim) + 라이브 실측.

## 1. 영향행수 (PASS 1)

```
BK6a 채번        INSERT 1    (SIZ_000520 A4 반칼)
BK6b A5 단가     INSERT 180  (SIZ_170 · 5소재 × 36mq · col1)
BK6c A4 단가     INSERT 180  (SIZ_520 · 5소재 × 36mq · col2)
BK6d siz 교정    UPDATE 4    (058~061 SIZ_172 → SIZ_520)
BK6e 바인딩      INSERT 4    (058~061 → PRF_STK_FIXED)
ROLLBACK (COMMIT 0)
```
**영향행 369** (INSERT 365 + UPDATE 4). 라이브 무변경.

## 2. 멱등 2-pass (단일 트랜잭션·delta 0)

| 스텝 | PASS 1 | PASS 2 | 판정 |
|------|:--:|:--:|:--:|
| BK6a 채번 | INSERT 1 | INSERT **0** | 멱등 ✅ (siz_cd PK NOT EXISTS) |
| BK6b A5 | INSERT 180 | INSERT **0** | 멱등 ✅ (자연키 NOT EXISTS) |
| BK6c A4 | INSERT 180 | INSERT **0** | 멱등 ✅ |
| BK6d 교정 | UPDATE 4 | UPDATE **0** | 멱등 ✅ (WHERE siz=172 → 교정 후 520이라 매칭 0) |
| BK6e 바인딩 | INSERT 4 | INSERT **0** | 멱등 ✅ (PK NOT EXISTS) |

**delta 0 전건 — 재실행 안전.**

## 3. 골든 (A5 동일가·A4 반칼 분리)

| # | 룩업 | 기대 | 실측 | 출처 |
|---|------|------|------|------|
| G1 | 058 A5(SIZ_170) 유포153 mq1 | 6000 | **6000.00** | B01 col1 verbatim |
| G2 | A5(SIZ_170) vs 124x186(SIZ_059) 5소재 동일가 | mismatch 0 | **0** | 사용자 컨펌 A5=124x186 |
| G3 | 058 A4 반칼(SIZ_520) 유포153 mq1 | 5000 | **5000.00** | B01 col2 verbatim |
| **G4 ★오청구 회피** | A4 반칼 SIZ_520 vs B02 낱장 SIZ_172 | 5000 ≠ 4000 | **5000 / 4000** | 반칼 전용가 분리 입증 |

## 4. 무결성

| 검사 | 결과 |
|------|------|
| 058~061 product_sizes 교정 (SIZ_172 → SIZ_520) | 058~061 = SIZ_170+SIZ_520 ✅ |
| ★완칼 낱장(055/056) SIZ_172 무접촉 | 055/056 여전히 SIZ_172 ✅ |
| 동시매칭 0 (SIZ_170/520 같은 siz/mat/min_qty 1행) | dup = **0** ✅ |
| A5/A4 소재 5종만 (062/063 동형·투명/홀로 미적재) | 170=5·520=5 ✅ |
| FK 고아 0 (단가 siz→t_siz_sizes) | orphan_price_siz = **0** ✅ |
| FK 고아 0 (product_sizes siz→t_siz_sizes) | orphan_ps_siz = **0** ✅ |
| FK 고아 0 (바인딩 frm→price_formulas) | orphan_bind = **0** ✅ |
| COMMIT 0 / ROLLBACK | ✅ 라이브 무변경 |

## 5. R1~R6 판정

| 게이트 | 항목 | 판정 |
|--------|------|:--:|
| R1 | 멱등 INSERT/UPDATE (NOT EXISTS·조건부 UPDATE·ON CONFLICT 미사용=PK 시퀀스/조합PK) | ✅ |
| R2 | 단일 트랜잭션 (BEGIN…ROLLBACK·ON_ERROR_STOP·중간 COMMIT 0) | ✅ |
| R3 | 로더 (apply.sh·.env.local·DRY-RUN 기본·비밀값 비노출·백업 4 CSV) | ✅ |
| R4 | FK 위상(siz 채번→A4 단가→product_sizes 교정→바인딩)·고아 0·완칼 무접촉 | ✅ |
| R5 | 멱등 2-pass delta 0 | ✅ |
| R6 | 단가 verbatim·골든 재현·★오청구 회피(A4 5000≠4000)·COMMIT 0 | ✅ |

**DRY-RUN GO** — 실 COMMIT·blocked 해소는 인간 승인. `dbm-validator` 독립 R1~R6 게이트 후 비준(자체승인 금지).
