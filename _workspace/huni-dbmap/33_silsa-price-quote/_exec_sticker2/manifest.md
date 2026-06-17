# 스티커 BLOCKED 마무리 적재 매니페스트 (manifest.md) — round-23 항목 7

> **작성** 2026-06-17 · 입력 = `sticker-blocked-resolution.md`(arbiter SB1~SB5) + `20_price-import/sticker/sticker-import.xlsx`(verbatim) + 라이브 read-only 실측.
> **설계+롤백전용 DRY-RUN GO 까지 — 실 COMMIT 인간 승인.** t_* 화이트리스트 전건 준수.

## 1. 적재 순서 (단일 트랜잭션·FK 위상)

| 스텝 | 대상 t_* 테이블 | 조치 | 행수 | FK 의존(고정 근거) |
|------|-----------------|------|:--:|--------------------|
| **SB3-채번** | t_siz_sizes | INSERT SIZ_000518(100x148)·SIZ_000519(90x110) | 2 | 부모 — 단가행보다 선행(component_prices.siz_cd→t_siz_sizes) |
| **SB3-단가** | t_prc_component_prices | INSERT B01 100x148/90x110 × 7mat × 36mq | 504 | siz 518/519 채번 후·comp COMP_STK_PRINT 기존 |
| **SB1 타투** | price_components·price_formulas·formula_components·component_prices·ppf | INSERT COMP_STK_TATTOO(.02)+PRF_STK_TATTOO+배선+단가행(min_qty=3·4000)+바인딩067 | 5 | comp→단가→frm→배선→바인딩 순 |
| **SB2 팩 교정** | price_components·component_prices·price_formulas·formula_components·ppf | UPDATE comp .01→.02 · DELETE 기존2행 · INSERT min_qty=54+PRF_STK_PACK+배선+바인딩065 | 1U+2D+4I | comp→단가→frm→배선→바인딩 |

**합계 영향행 = INSERT 515 + UPDATE 1 + DELETE 2 = 518.** COMMIT 0 (ROLLBACK 전용).

## 2. ★.02 합가형 min_qty NOT NULL (엔진 ValueError 회피)

`PRICE_TYPE.02`(합가형)는 엔진 `per_item = unit_price / tier_min_qty`(pricing.py:185) → `base<=0` 시 ValueError(:188).
- 타투: `min_qty=3`·unit=4000 → 4000÷3=1333.33/장
- 팩: `min_qty=54`·unit=4000 → 4000÷54=74.07/장
- DRY-RUN 검증: .02 단가행 NULL/<=0 min_qty = **0** ✅

## 3. insertable / blocked / GAP 집계

| 분류 | 단위 | 행/규모 |
|------|------|--------|
| **insertable (즉시 GO)** | SB1·SB2·SB3 | 518 (INSERT 515+UPDATE 1+DELETE 2) |
| **blocked-pending** | 타투 base2000·058~064·A4/A3 B01 단가·팩 환산단위 | `blocked-and-gaps.md` |
| **GAP** | 0 | — |

## 4. 산출물

- SQL: `SB3_codegen.sql`·`SB3_b01_prices.sql`·`SB1_tattoo.sql`·`SB2_pack_fix.sql`
- 통합: `apply.sql`(단일 txn·ROLLBACK 기본)·`apply.sh`(백업+`--commit`)
- 생성기: `gen_load_sql.py`(xlsx verbatim → SB3 단가행 byte-identical 재현)
- 검증: `dryrun-report.md`·차단: `blocked-and-gaps.md`

## 5. 미적재 원칙

DB 미적재 — 설계+DRY-RUN GO 까지. 실 COMMIT 은 `apply.sh --commit` + 인간 승인. `dbm-validator` R1~R6 후 자체승인 금지.
