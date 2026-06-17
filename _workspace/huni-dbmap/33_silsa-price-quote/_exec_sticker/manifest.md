# 스티커 누락 채움 적재 매니페스트 (manifest.md) — round-23 항목 7

> **작성** 2026-06-17 · 입력 = `sticker-3axis-design.md`(arbiter S1~S8) + `20_price-import/sticker/sticker-import.xlsx`(verbatim) + 라이브 read-only 실측.
> **설계+롤백전용 DRY-RUN GO 까지 — 실 COMMIT 은 인간 승인.** t_* 화이트리스트 전건 준수(t_prc_component_prices·t_prd_product_price_formulas).

## 1. 적재 순서 (단일 트랜잭션·FK 위상)

| 스텝 | 대상 t_* 테이블 | 소스 | 조치 | 행수 | FK 의존(고정 근거) |
|------|-----------------|------|------|:--:|--------------------|
| **S1** | t_prc_component_prices | xlsx#4_component_prices | INSERT (비코팅084·미색242·유광156·홀로163 × SIZ_059/060 × 36mq) | 288 | 부모 comp COMP_STK_PRINT·mat 4종·siz 2종 전부 라이브 실존 |
| **S2** | t_prc_component_prices | 라이브 170행 + arbiter §4.1 | UPDATE mat_cd 170→162 (투명 오매핑 교정) | 90 | 기존 행만·comp COMP_STK_PRINT 한정(과교정 0) |
| **S3** | t_prc_component_prices | xlsx#4b_BLOCKED | INSERT B4/B3(SIZ_515/514) 유포153·투명162 | 24 | siz 515/514 라이브 실존(채번 0) |
| **S8** | t_prd_product_price_formulas | arbiter §4.4 | INSERT 바인딩 054/056/057 → PRF_STK_FIXED | 3 | 부모 PRF_STK_FIXED·PRD 3종 실존. S1 홀로 단가행 선행(같은 txn) |

**합계 영향행 = 405** (INSERT 315 + UPDATE 90). COMMIT 0 (ROLLBACK 전용).

FK 위상: component_prices(S1/S2/S3) → ppf(S8). 단 ppf↔component_prices 간 DB FK 없음(논리 매칭) — S1 홀로(163) 단가행이 054 바인딩 의미 충족을 위해 같은 트랜잭션에서 선행.

## 2. insertable / blocked / GAP 집계

| 분류 | 단위 | 행/규모 |
|------|------|--------|
| **insertable (즉시 GO)** | S1·S2·S3·S8 | 405 (288+90+24+3) |
| **blocked-pending** | S4·S5·S6·S7·058~064·065·066·067 | `blocked-and-gaps.md` 참조 |
| **GAP** | (없음 — 무손실 표현 불가 항목 0·전부 컨펌/채번 차단) | 0 |

## 3. 산출물

- SQL: `S1_b01_materials.sql` · `S2_clear_remap.sql` · `S3_b3b4_prices.sql` · `S8_bindings.sql`
- 통합: `apply.sql`(단일 txn·ROLLBACK 기본) · `apply.sh`(백업+`--commit` 게이트)
- 생성기: `gen_load_sql.py`(xlsx verbatim → S1/S3 byte-identical 재현·provenance)
- 검증: `dryrun-report.md` · 차단: `blocked-and-gaps.md`

## 4. 미적재 원칙

DB 미적재 — 본 번들은 설계 + 롤백전용 DRY-RUN GO 까지. 실 COMMIT 은 `apply.sh --commit` + 인간 최종 승인. `dbm-validator` R1~R6 게이트 후 자체승인 금지.
