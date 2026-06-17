# 스티커 BLOCKED 마무리 — 롤백전용 DRY-RUN 리포트 (R1~R6) — round-23 항목 7

> **실행** 2026-06-17 · 라이브 `railway` DB read-only(BEGIN…ROLLBACK·COMMIT 0) · psql.
> 입력 권위 = arbiter `sticker-blocked-resolution.md`(SB1~SB3) + `sticker-import.xlsx`(verbatim) + 라이브 실측.

## 1. 영향행수 (PASS 1)

```
SB3 채번  INSERT 2    (SIZ_000518·SIZ_000519)
SB3 단가  INSERT 504  (B01 100x148/90x110 × 7mat × 36mq)
SB1 타투  INSERT 5    (comp + frm + 배선 + 단가행 + 바인딩)
SB2 팩    UPDATE 1 · DELETE 2 · INSERT 4  (comp교정 + 기존2행폐기 + min_qty54 + frm + 배선 + 바인딩)
ROLLBACK (COMMIT 0)
```
**영향행 518** (INSERT 515 + UPDATE 1 + DELETE 2). 라이브 무변경.

## 2. 멱등 2-pass (단일 트랜잭션·delta 0)

| 스텝 | PASS 1 | PASS 2 | 판정 |
|------|:--:|:--:|:--:|
| SB3 채번 | INSERT 2 | INSERT **0** | 멱등 ✅ (siz_cd PK NOT EXISTS) |
| SB3 단가 | INSERT 504 | INSERT **0** | 멱등 ✅ (자연키 NOT EXISTS) |
| SB1 타투 (5) | 각 INSERT 1 | 각 INSERT **0** | 멱등 ✅ |
| SB2 comp UPDATE | UPDATE 1 | UPDATE **0** | 멱등 ✅ (WHERE .01 → 교정 후 매칭 0) |
| SB2 단가 DELETE | DELETE 2 | DELETE **0** | 멱등 ✅ (기존 2행 1회 삭제) |
| SB2 INSERT (4) | 각 INSERT 1 | 각 INSERT **0** | 멱등 ✅ |

**delta 0 전건 — 재실행 안전.**

## 3. ★.02 합가형 min_qty NOT NULL 검증 (엔진 ValueError 회피)

| comp | prc_typ | min_qty | unit_price | 환산 |
|------|---------|:--:|:--:|------|
| COMP_STK_TATTOO | PRICE_TYPE.02 | **3** | 4000 | 4000÷3=1333.33/장 |
| COMP_STK_PACK | PRICE_TYPE.02 | **54** | 4000 | 4000÷54=74.07/장 |

- .02 단가행 중 `min_qty IS NULL OR min_qty<=0` 행수 = **0** ✅ (pricing.py:188 base<=0 ValueError 미발생)

## 4. 골든 (합가형·세트·채번 룩업 재현)

| # | 룩업 | 기대 | 실측 | 출처 |
|---|------|------|------|------|
| G1 | 타투 수량9 = 4000÷3×9 | 12000 | **12000.00** | 가격표 A81/B81 verbatim·엔진 합가형 |
| G2 | 팩 수량54(장) = 4000÷54×54 | 4000 | **4000.00** | 세트총액 복원(54장 1세트 4000) |
| G3 | B01 100x148(518)·유포153·mq1 | 6700 | **6700.00** | 가격표 B01 verbatim |
| G4 | B01 90x110(519)·홀로163·mq1 | 7700 | **7700.00** | 가격표 B01 verbatim |

## 5. 무결성

| 검사 | 결과 |
|------|------|
| 팩 단가행 = min_qty 54 단일행 (기존 1·1000 폐기·중복 0) | min_qty 54 → 1행 ✅ |
| 동시매칭 0 (518/519 같은 siz/mat/min_qty 단가행 1개) | dup = **0** ✅ |
| FK 고아 0 (518/519 단가 → t_siz_sizes·채번 후) | orphan_siz = **0** ✅ |
| FK 고아 0 (배선 comp → price_components) | orphan_wire = **0** ✅ |
| FK 고아 0 (바인딩 frm → price_formulas) | orphan_bind = **0** ✅ |
| FK 고아 0 (타투 mat_167 → t_mat_materials) | orphan_tat_mat = **0** ✅ |
| search-before-mint (max=SIZ_000517 → 518/519 무충돌) | ✅ |
| COMMIT 0 / ROLLBACK | ✅ 라이브 무변경 |

## 6. R1~R6 판정

| 게이트 | 항목 | 판정 |
|--------|------|:--:|
| R1 | 멱등 INSERT/UPDATE/DELETE (NOT EXISTS·조건부·ON CONFLICT 미사용=PK 시퀀스/조합PK) | ✅ |
| R2 | 단일 트랜잭션 (BEGIN…ROLLBACK·ON_ERROR_STOP·중간 COMMIT 0) | ✅ |
| R3 | 로더 (apply.sh·.env.local·DRY-RUN 기본·비밀값 비노출·백업 4 CSV) | ✅ |
| R4 | FK 위상(siz 채번→단가·comp→배선→바인딩)·고아 0 | ✅ |
| R5 | 멱등 2-pass delta 0 | ✅ |
| R6 | 단가 verbatim·골든 재현·.02 min_qty NOT NULL·COMMIT 0 | ✅ |

**DRY-RUN GO** — 실 COMMIT·blocked 해소는 인간 승인. `dbm-validator` 독립 R1~R6 게이트 후 비준(자체승인 금지).
