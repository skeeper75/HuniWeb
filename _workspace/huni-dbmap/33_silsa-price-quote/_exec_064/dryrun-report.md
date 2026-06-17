# 064 소량자유형 가격 적재 — 롤백전용 DRY-RUN 리포트 (R1~R6) — round-23 항목 7

> **실행** 2026-06-18 · 라이브 `railway` DB read-only(BEGIN…ROLLBACK·COMMIT 0) · psql.
> 입력 권위 = 사용자 결정(B01 col1 규격가 사이즈무관 동일 적용·우선 등록 후 추후 변경) + 라이브 B01 col1(SIZ_059) verbatim + 라이브 실측.

## 1. 영향행수 (PASS 1)

```
S064a 단가  INSERT 1260  (소형 7siz × 5소재 × 36mq · B01 col1 복사 · 잠정 note)
S064b 바인딩 INSERT 1     (064 → PRF_STK_FIXED)
ROLLBACK (COMMIT 0)
```
**영향행 1261** (INSERT만). 라이브 무변경.

## 2. 멱등 2-pass (단일 트랜잭션·delta 0)

| 스텝 | PASS 1 | PASS 2 | 판정 |
|------|:--:|:--:|:--:|
| S064a 단가 | INSERT 1260 | INSERT **0** | 멱등 ✅ (자연키 NOT EXISTS) |
| S064b 바인딩 | INSERT 1 | INSERT **0** | 멱등 ✅ (PK NOT EXISTS) |

**delta 0 전건 — 재실행 안전.**

## 3. 골든 (B01 col1 사이즈무관 동일가)

| # | 룩업 | 기대 | 실측 | 출처 |
|---|------|------|------|------|
| G1 | 064 50x70(SIZ_061) 유포153 mq1 | 6000 | **6000.00** | B01 col1 verbatim |
| G2 | 064 94x94(SIZ_036) 무광155 mq1 | 7000 | **7000.00** | B01 col1 verbatim |
| G3 | 7siz 모두 유포 mq1 동일가 (distinct) | 1 | **1** | 사이즈무관 동일 적용 |
| G4 | B01 col1(SIZ_059) vs 064 단가 mismatch | 0 | **0** | INSERT…SELECT verbatim 복사 |

## 4. note 잠정 표기 (사용자 "추후 변경")

| 검사 | 결과 |
|------|------|
| 1260행 전부 `[잠정]…` note | provisional_rows = **1260** ✅ |
| note 내용 | `[잠정] 소형반칼 B01 규격가(col1·124x186) 사이즈무관 적용·실측 단가 미수령·추후 변경 (064 소량자유형)` |

→ 실무진이 잠정임을 식별·추후 064 실측 단가 수령 시 교체 가능(round-17 가독성).

## 5. 무결성

| 검사 | 결과 |
|------|------|
| 동시매칭 0 (7siz 같은 siz/mat/min_qty 단가행 1개) | dup = **0** ✅ |
| 소재 5종만 (058~063 동형·투명/홀로 미적재·과적재 0) | 5 ✅ |
| FK 고아 0 (단가 siz_cd → t_siz_sizes·7종 기존) | orphan_siz = **0** ✅ |
| FK 고아 0 (바인딩 frm → price_formulas) | orphan_bind = **0** ✅ |
| siz 채번 0 (064 7종 라이브 실존·search-before-mint) | ✅ |
| COMMIT 0 / ROLLBACK | ✅ 라이브 무변경 |

## 6. R1~R6 판정

| 게이트 | 항목 | 판정 |
|--------|------|:--:|
| R1 | 멱등 INSERT (NOT EXISTS·ON CONFLICT 미사용=PK 시퀀스/조합PK) | ✅ |
| R2 | 단일 트랜잭션 (BEGIN…ROLLBACK·ON_ERROR_STOP·중간 COMMIT 0) | ✅ |
| R3 | 로더 (apply.sh·.env.local·DRY-RUN 기본·비밀값 비노출·백업 2 CSV) | ✅ |
| R4 | FK 위상(단가→바인딩)·고아 0·채번 0 | ✅ |
| R5 | 멱등 2-pass delta 0 | ✅ |
| R6 | 단가 verbatim(B01 col1 복사·mismatch 0)·골든 재현·잠정 note·COMMIT 0 | ✅ |

**DRY-RUN GO** — 실 COMMIT 인간 승인. ★단가는 잠정(B01 규격가 차용·064 실측 아님). `dbm-validator` 독립 R1~R6 게이트 후 비준(자체승인 금지).
