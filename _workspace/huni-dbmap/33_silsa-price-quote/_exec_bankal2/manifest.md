# 반칼 058~061 가능분 가격 연결 매니페스트 (manifest.md) — round-23 항목 7 (BK6)

> **작성** 2026-06-18 · 입력 = `bankal-058-064-deepcheck.md`(BK6) + 사용자 컨펌(A5=124x186 동일가 GO·A4 반칼 전용 분리 GO) + 라이브 실측.
> **설계+롤백전용 DRY-RUN GO 까지 — 실 COMMIT 인간 승인.** t_* 화이트리스트 준수.

## 1. 적재 순서 (단일 트랜잭션·FK 위상)

| 스텝 | 대상 t_* 테이블 | 조치 | 행수 | FK 의존(고정 근거) |
|------|-----------------|------|:--:|--------------------|
| **BK6a** | t_siz_sizes | INSERT SIZ_000520(A4 210x297 반칼 전용) | 1 | 부모 — A4 단가·product_sizes 교정보다 선행 |
| **BK6b** | t_prc_component_prices | INSERT A5(SIZ_170) 5소재×36mq (col1=124x186 동일가) | 180 | SIZ_170 기존·comp COMP_STK_PRINT 기존 |
| **BK6c** | t_prc_component_prices | INSERT A4 반칼(SIZ_520) 5소재×36mq (col2 5000/6000) | 180 | SIZ_520 채번 후(BK6a) |
| **BK6d** | t_prd_product_sizes | UPDATE 058~061 A4 등록 SIZ_172→SIZ_520 (오청구 교정) | 4 | SIZ_520 존재 후·058~061 한정(완칼 무접촉) |
| **BK6e** | t_prd_product_price_formulas | INSERT 058~061 → PRF_STK_FIXED 바인딩 | 4 | PRF_STK_FIXED·PRD 기존 |

**합계 영향행 = INSERT 365 + UPDATE 4 = 369.** COMMIT 0 (ROLLBACK 전용).

## 2. ★돈 크리티컬 — A4 반칼 siz 분리 (오청구 0)

- B02 낱장완칼 A4(SIZ_172) 단가 = **4000**(유포). B01 반칼 A4 = **5000**(col2·더 높음).
- 058~061이 SIZ_172 그대로 쓰면 **4000 오청구** + B01 반칼 단가 추가 시 ERR_DUPLICATE.
- → A4 반칼 전용 **SIZ_000520 신규 채번** + col2 단가(5000/6000) 적재 + 058~061 등록을 SIZ_520로 교정.
- 완칼 낱장(055/056)의 SIZ_172는 **무접촉**(교정 058~061 한정·DRY-RUN 검증).

## 3. 소재 5종 (058~061 라이브 등록분)

058~061 등록 소재 = 유포153·비코084·미색242·무광155·유광156 (투명162/홀로163 **미등록**).
→ A5/A4 단가행은 5소재×36mq=180 each (062/063 동형·과적재 0).

## 4. insertable / blocked / GAP 집계

| 분류 | 단위 | 행/규모 |
|------|------|--------|
| **insertable (즉시 GO)** | BK6a~BK6e | 369 (INSERT 365+UPDATE 4) |
| **blocked-pending** | 064 소량자유형 | `blocked-and-gaps.md` |
| **GAP** | 0 | — |

## 5. 산출물

- SQL: `BK6a_codegen.sql`·`BK6b_price_a5.sql`·`BK6c_price_a4.sql`·`BK6d_fix_product_sizes.sql`·`BK6e_bindings.sql`
- 통합: `apply.sql`(단일 txn·ROLLBACK 기본)·`apply.sh`(백업 4 CSV+`--commit`)
- 생성기: `gen_load_sql.py`(xlsx verbatim → A5/A4 단가행 byte-identical 재현)
- 검증: `dryrun-report.md`·차단: `blocked-and-gaps.md`

## 6. 미적재 원칙

DB 미적재 — 설계+DRY-RUN GO 까지. 실 COMMIT 은 `apply.sh --commit` + 인간 승인. `dbm-validator` R1~R6 후 자체승인 금지.
