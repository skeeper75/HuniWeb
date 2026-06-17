# 스티커 누락 채움 — 롤백전용 DRY-RUN 리포트 (R1~R6) — round-23 항목 7

> **실행** 2026-06-17 · 라이브 `railway` DB read-only(BEGIN…ROLLBACK·COMMIT 0) · psql.
> 입력 권위 = arbiter `sticker-3axis-design.md` + `sticker-import.xlsx`(verbatim) + 라이브 실측.

## 1. 영향행수 (PASS 1)

```
S1: B01 소재 4미적재          INSERT 0 288
S2: 투명 오매핑 170→162       UPDATE 90
S3: B4/B3 단가행              INSERT 0 24
S8: 바인딩 054/056/057        INSERT 0 3
ROLLBACK (COMMIT 0)
```
**영향행 405** (INSERT 315 + UPDATE 90). 라이브 무변경.

## 2. 멱등 2-pass (단일 트랜잭션·delta 0)

PASS 1 → PASS 2 재실행 결과(같은 BEGIN 내):

| 스텝 | PASS 1 | PASS 2 | 판정 |
|------|:--:|:--:|:--:|
| S1 | INSERT 288 | INSERT **0** | 멱등 ✅ (자연키 NOT EXISTS) |
| S2 | UPDATE 90 | UPDATE **0** | 멱등 ✅ (WHERE mat=170 → 교정 후 매칭 0) |
| S3 | INSERT 24 | INSERT **0** | 멱등 ✅ |
| S8 | INSERT 3 | INSERT **0** | 멱등 ✅ (PK (prd,apply_bgn_ymd) NOT EXISTS) |

**delta 0 전건 — 재실행 안전.**

## 3. 소재축 verbatim 대조 (가격표 ↔ SQL)

가격표 그룹단가가 소재별 개별 행으로 무손실 전개됐는지(같은 가격이라도 mat_cd 분리):

| 소재 | 그룹 출처 | 가격표 단가(124x186 mq=1) | SQL 적재 | 일치 |
|------|----------|---------------------------|----------|:--:|
| 비코팅(084) | 유포/비코팅/미색 6000 | 6000 | 6000 | ✅ |
| 미색(242) | 〃 | 6000 | 6000 | ✅ |
| 유광코팅(156) | 무광/유광 7000 | 7000 | 7000 | ✅ |
| 홀로그램(163) | 투명/홀로 7000 | 7000 | 7000 | ✅ |
| 투명(162·S2) | 투명/홀로 7000 | 7000 | 7000(170→162 후 가격 불변) | ✅ |

**170→162 relabel 무손실 입증**: 라이브 170행 90개 가격 == xlsx 투명 verbatim 가격 → **price mismatch 0** (gen 단계 대조). 순수 mat_cd 교정.
**과교정 0**: `MAT_000170` 라이브 사용처 = `COMP_STK_PRINT` 90행 **전부**(타 comp 0). 합판도무송 PRD_000066 은 별 공식 `PRF_GANGPAN_FIXED`·별 comp → 우리 UPDATE(comp_cd='COMP_STK_PRINT' 한정) 미접촉.

## 4. 골든 (소재×수량×판형 룩업 재현)

| # | 룩업 (siz × mat × min_qty) | 기대 | 실측 | 출처 |
|---|----------------------------|------|------|------|
| G1 | 124x186 · 유포153 · 3 | 5900 | **5900** | 라이브 기존 verbatim(불변 확인) |
| G2 | 124x186 · 홀로163(S1) · 1 | 7000 | **7000** | 투명그룹가 verbatim |
| G3 | 124x186 · 투명162(S2) · 1 | 7000 | **7000**(mat=162) | 170→162 후 |
| G4 | B4(515) · 투명162 · 1 | 10500 | **10500** | 가격표 verbatim |
| G5 | B3(514) · 투명162 · 1 | 21000 | **21000** | 가격표 verbatim |
| G6 | B4(515) · 유포153 · 1 | 6000 | **6000** | 가격표 verbatim |

## 5. 무결성

| 검사 | 결과 |
|------|------|
| 동시매칭 0 (같은 siz/mat/min_qty 단가행 1개) | dup_groups = **0** ✅ |
| FK 고아 0 (신규 mat_cd → t_mat_materials) | orphan_mat = **0** ✅ |
| FK 고아 0 (siz_cd → t_siz_sizes) | orphan_siz = **0** ✅ |
| 바인딩 FK 고아 0 (frm/prd 실존) | orphan_bind = **0** ✅ |
| 170 잔존 0 (COMP_STK_PRINT 내) | leftover_170 = **0** ✅ |
| COMMIT 0 / ROLLBACK | ✅ 라이브 무변경 |

## 6. R1~R6 판정

| 게이트 | 항목 | 판정 |
|--------|------|:--:|
| R1 | 멱등 INSERT/UPDATE (NOT EXISTS·조건부 UPDATE·ON CONFLICT 미사용=PK 시퀀스) | ✅ |
| R2 | 단일 트랜잭션 (BEGIN…ROLLBACK·ON_ERROR_STOP·중간 COMMIT 0) | ✅ |
| R3 | 로더 (apply.sh·.env.local·DRY-RUN 기본·비밀값 비노출·백업 CSV) | ✅ |
| R4 | FK 위상·고아 0 | ✅ |
| R5 | 멱등 2-pass delta 0 | ✅ |
| R6 | 단가 verbatim·골든 재현·COMMIT 0 | ✅ |

**DRY-RUN GO** — 실 COMMIT·blocked 해소는 인간 승인. `dbm-validator` 독립 R1~R6 게이트 후 비준(자체승인 금지).
