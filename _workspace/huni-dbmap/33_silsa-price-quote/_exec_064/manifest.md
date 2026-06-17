# 064 소량자유형 가격 적재 매니페스트 (manifest.md) — round-23 항목 7

> **작성** 2026-06-18 · 사용자 결정 = B01 규격가(col1) 사이즈 무관 동일 적용·우선 등록 후 추후 변경 + 라이브 실측.
> **설계+롤백전용 DRY-RUN GO 까지 — 실 COMMIT 인간 승인.** t_* 화이트리스트 준수.

## 1. 적재 순서 (단일 트랜잭션·FK 위상)

| 스텝 | 대상 t_* 테이블 | 조치 | 행수 | FK 의존(고정 근거) |
|------|-----------------|------|:--:|--------------------|
| **S064a** | t_prc_component_prices | INSERT 064 소형 7siz × 5소재 × 36mq (B01 col1 verbatim 복사·잠정 note) | 1260 | comp COMP_STK_PRINT·siz 7종·mat 5종 전부 기존(채번 0) |
| **S064b** | t_prd_product_price_formulas | INSERT 064 → PRF_STK_FIXED 바인딩 | 1 | PRF_STK_FIXED·PRD_064 기존 |

**합계 영향행 = 1261 (INSERT만).** COMMIT 0 (ROLLBACK 전용).

## 2. 가격 모델 — B01 col1 사이즈무관 동일 적용 (사용자 결정·잠정)

- 064 소형 7사이즈(SIZ_036 94x94·043 80x80·061 50x70·062 70x50·063 50x94·064 94x50·065 65x65) = 가격표 스티커 시트에 단가 부재.
- 사용자 결정: **B01 col1 규격가(124x186·SIZ_059)를 사이즈 무관 동일 적용**·우선 등록 후 추후 변경.
- 구현 = `INSERT … SELECT` 로 SIZ_059(B01 col1) 5소재×36mq 단가를 7 siz에 verbatim 복사(하드코딩 0·소재별/수량밴드별 그대로).
- **★잠정 note**: 전 1260행 note = `[잠정] 소형반칼 B01 규격가(col1·124x186) 사이즈무관 적용·실측 단가 미수령·추후 변경 (064 소량자유형)` → 실무진이 잠정임을 식별·추후 실측 단가로 교체 가능.

## 3. 소재 5종 (064 라이브 등록분)

064 등록 소재 = 유포153·비코084·미색242·무광155·유광156 (058~063 동형·투명/홀로 미등록). → 5소재×36mq×7siz=1260.

## 4. insertable / blocked / GAP 집계

| 분류 | 단위 | 행/규모 |
|------|------|--------|
| **insertable (우선 등록·잠정)** | S064a·S064b | 1261 |
| **blocked-pending** | (없음 — 사용자 결정으로 잠정 등록) | — |
| **GAP** | 0 | — |

## 5. 산출물

- SQL: `S064a_prices.sql`(INSERT…SELECT B01 col1 복사)·`S064b_binding.sql`
- 통합: `apply.sql`(단일 txn·ROLLBACK 기본)·`apply.sh`(백업 2 CSV+`--commit`)
- 검증: `dryrun-report.md`

## 6. 미적재 원칙 + 잠정 단가 주의

DB 미적재 — 설계+DRY-RUN GO 까지. 실 COMMIT 은 `apply.sh --commit` + 인간 승인.
★**단가는 잠정**(B01 규격가 차용·064 실측 단가 아님). 실무진 실측 단가 수령 시 note 식별로 교체. `dbm-validator` R1~R6 후 자체승인 금지.
