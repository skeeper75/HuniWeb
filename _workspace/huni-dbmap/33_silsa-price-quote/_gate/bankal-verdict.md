# 062/063 반칼팬시 가격 연결 (BK-1/BK-2) — Phase D 독립 검증 verdict · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-18 · 생성자(load-builder)와 독립.
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. COMMIT 0·비밀값 비노출.

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

INSERT 2·2-pass delta 0·골든 G1/G2 재현·가격행 추가 0·FK고아 0·PK충돌 0·BLOCKED 3 정당 분리 전건 라이브 실측. BLOCKER 0·불일치 0.

---

## R1 멱등성 — **PASS**
2-pass: PASS1 INSERT 2 · **PASS2 INSERT 0**(PK=(prd_cd,apply_bgn_ymd) NOT EXISTS). 재실행 안전.

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 라이브 premise 확인: PRD_000062(반칼팬시스티커)·PRD_000063(반칼팬시투명스티커)·PRF_STK_FIXED 실존·062/063 기존 바인딩 0(충돌 0). 단일 스텝(바인딩만)·FK 단순.

## R4 영향행수 — **PASS (보고와 일치)**
독립 실측 **INSERT 2**(PRD_000062·PRD_000063 → PRF_STK_FIXED·apply_bgn_ymd 2026-06-01). 가격행(component_prices) INSERT 0.

## R6 ★골든 + 가격행 추가 0 — **PASS (핵심)**
- **G1 실측**: 062 124x186(SIZ_000059) 유포153(MAT_000153) mq3 = **5,900.00**(기존 COMP_STK_PRINT 행 재사용).
- **G2 실측**: 063 124x186(SIZ_000059) 투명162(MAT_000162) mq1 = **7,000.00**(기존 행 재사용).
- **가격사슬 해소 입증**: PRF_STK_FIXED가 COMP_STK_PRINT(disp1) 배선 → 062/063 바인딩 후 엔진이 (siz_cd, mat_cd, min_qty) 매칭으로 즉시 산출.
- **가격행 추가 0**: COMP_STK_PRINT **1074 → 1074 불변**(형상=팬시 칼틀·가격축 아님·같은 사이즈/소재면 B01 동일가). 형상 무관 동일가 입증.
- 동시매칭 0(062=1·063=1 바인딩·PK 충돌 0)·orphan_bind_frm 0(FK 고아 0).

## BLOCKED 분리 정당성 — **PASS**
`BK_bindings.sql`은 PRD_000062/063만 INSERT(SQL 본문 확인). BLOCKED 3건 apply.sql 미포함:
- BK-3(058~061 A5/A4 격자 미보유·A4=B02 낱장완칼 잘못된 가격)·BK-4(064 소형반칼 단가 부재)·BK-5(062/063 100x140 SIZ_058 B01 미적재). 전부 가격 출처 미확정(컨펌 대기)·추측 적재 금지 — 정당.

## undo / 안전성 — **충분**
바인딩 INSERT 2만(가격행·comp 무변경). undo = 신규 2 바인딩 DELETE(PK 식별). 물리 손실 0. apply.sh `^ROLLBACK;` 1건 sed 치환(SAFE)·비밀값 비노출.

## 생성자 주장 vs 검증자 실측
| 항목 | 생성자 | 실측 | 판정 |
|------|--------|------|:--:|
| INSERT 2·가격행 0 | 보고 | 동일 | 일치 |
| G1 5900·G2 7000(B01 재사용) | 주장 | **라이브 단가행 실측 일치** | 일치 |
| COMP_STK_PRINT 1074 불변·동시매칭0·FK고아0·2-pass0 | 주장 | 확인 | 일치 |
| 불일치 | — | 없음 | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·골든 단가행 실측·형상 무관 동일가·BLOCKED SQL 본문 확인.

### 최종: **GO — 실 COMMIT 가능**. 인간 승인 시 `apply.sh --commit`. BLOCKED 3건(058~061·064·100x140)은 가격 출처 컨펌 후 별 트랙(round-13 매핑 정합 의심).
