# 반칼 모양 062/063 가격 연결 매니페스트 (manifest.md) — round-23 항목 7

> **작성** 2026-06-18 · 입력 = `bankal-shapes-resolution.md`(arbiter BK-1~BK-5) + 라이브 read-only 실측.
> **설계+롤백전용 DRY-RUN GO 까지 — 실 COMMIT 인간 승인.** t_* 화이트리스트 준수(t_prd_product_price_formulas).

## 1. 적재 순서 (단일 트랜잭션)

| 스텝 | 대상 t_* 테이블 | 조치 | 행수 | FK 의존(고정 근거) |
|------|-----------------|------|:--:|--------------------|
| **BK-1** | t_prd_product_price_formulas | PRD_000062(반칼팬시) → PRF_STK_FIXED 바인딩 | 1 | 부모 PRF_STK_FIXED·PRD_062 실존 |
| **BK-2** | t_prd_product_price_formulas | PRD_000063(반칼팬시투명) → PRF_STK_FIXED 바인딩 | 1 | 부모 PRF_STK_FIXED·PRD_063 실존 |

**합계 영향행 = 2 (바인딩 INSERT만). 가격행 추가 0.** COMMIT 0 (ROLLBACK 전용).

## 2. 가격행 추가 0 — 형상=칼틀·가격 무관

062/063은 B01 반칼 사이즈(124x186=SIZ_059·90x190=SIZ_060·각 7소재×36mq=252행 적재됨)와 소재를 그대로 등록.
형상(팬시)은 반칼 칼틀(도무송 목형)이지 가격 차원이 아님 → 같은 사이즈·소재면 B01과 동일 단가.
→ **기존 B01 단가행 재사용**·바인딩만으로 가격 산출. component_prices INSERT 0(검증: COMP_STK_PRINT 1074행 불변).

## 3. insertable / blocked / GAP 집계

| 분류 | 단위 | 행/규모 |
|------|------|--------|
| **insertable (즉시 GO)** | BK-1·BK-2 | 2 (바인딩) |
| **blocked-pending** | 058~061(BK-3)·064(BK-4)·062/063 100x140(BK-5) | `blocked-and-gaps.md` |
| **GAP** | 0 | — |

## 4. 산출물

- SQL: `BK_bindings.sql` (062/063 바인딩)
- 통합: `apply.sql`(단일 txn·ROLLBACK 기본)·`apply.sh`(백업+`--commit`)
- 검증: `dryrun-report.md`·차단: `blocked-and-gaps.md`

## 5. 미적재 원칙

DB 미적재 — 설계+DRY-RUN GO 까지. 실 COMMIT 은 `apply.sh --commit` + 인간 승인. `dbm-validator` R1~R6 후 자체승인 금지.
