# 고정가형 15상품 정정 마이그레이션 (`_migrate_fixedprice`)

> **이것은 COMMITTED 프로덕션 데이터에 대한 정정 마이그레이션입니다.**
> 실제 반영은 **인간 승인**(`apply.sh --commit`)일 때만. 본 하네스는 절대 자동 COMMIT 하지 않습니다.

## 1. 무엇을 / 왜 (What & Why)

round-2 가격 매핑에서 **고정가형 15상품**(완제품 통가격: 규격×색상/수량구간 룩업)을
**면적-좌표형 공식 `PRF_POSTER_FIXED`** 에 잘못 바인딩한 채 GO 적재본이 라이브에 커밋되었습니다.
면적-좌표 모델은 이 15상품의 "규격별 완제품 정찰가" 의미를 표현하지 못합니다(오모델).

본 마이그레이션은 그 오바인딩을 **상품별 고정가형 공식**으로 정정합니다.

| 구분 | 내용 |
|------|------|
| **정정 대상** | PRD_000129·130·131·132·133·134·135·136·137·140·141·142·143·144·145 (15) |
| **유지(미포함)** | 면적형 13상품은 `PRF_POSTER_FIXED` 그대로 — 본 마이그레이션은 건드리지 않음 |
| **추가** | 고정가형 공식 15(`PRF_*_FIXED`) + 구성요소(색상 variant 포함) + 와이어링 17 + 단가 **73행** |
| **재바인딩** | 15상품의 `PRF_POSTER_FIXED` **DELETE** → 상품별 `PRF_*_FIXED` **INSERT** |

## 2. 선행 broken-partial 상태 처리 (중요)

라이브 검증 결과, **이전의 깨진 통합 시도**가 이미 커밋되어 있었습니다:

- `t_prc_price_components` 에 포스터 구성요소 13종 + 단가 **55행**(reg_dt 2026-06-06 11:30)이 존재.
- 그러나: ① 액자/족자/배너/시트커팅/아크릴스티커/미니 일부만 적재되고 **FOAM/FOMEX 4종은 전혀 없음**,
  ② ACRYLSTK/SHEETCUT **14행은 `min_qty=NULL`** 인데 권위 CSV는 `min_qty=1` → 자연키 불일치.
- 고정가형 공식·와이어링·재바인딩은 **하나도 적용되지 않음**(15상품은 여전히 `PRF_POSTER_FIXED`).

자연키 UNIQUE(`ux_t_prc_comp_prices_nat_key`)는 **NULLS DISTINCT**(기본)이므로,
단순 `ON CONFLICT DO NOTHING` append 시 `min_qty=NULL` 기존행과 `min_qty=1` 신규행이
**중복**으로 공존합니다(같은 규격 2개 가격). 따라서 단가는 **DELETE-then-INSERT** 방식:

> **STEP 3**: 17개 comp_cd 의 기존 단가 행(55) 전부 **DELETE** → 권위 CSV **73행 INSERT**.
> 결과: 라이브 = 정확히 73행 (중복 0, stale `min_qty=NULL` 행 제거).
> (단가 테이블을 FK로 참조하는 테이블 없음 — DELETE 안전 검증 완료.)

> **이전 깨진 시도가 73 중 18(혹은 55)만 넣은 것과 달리, 본 마이그레이션은 73행 전부를 권위 적재합니다.**

## 3. 멱등성 설계 (Idempotency)

| STEP | 테이블 | 방식 | 근거 |
|------|--------|------|------|
| 1 | `t_prc_price_formulas` | `INSERT … ON CONFLICT (frm_cd) DO NOTHING` | 15개 PRF_*_FIXED 신규 |
| 2a | `t_prc_price_components` | `INSERT … ON CONFLICT (comp_cd) DO NOTHING` | 13종 기존→skip, FOAM/FOMEX 4종 신규 |
| 2b | `t_prc_formula_components` | `INSERT … ON CONFLICT (frm_cd,comp_cd) DO NOTHING` | 17개 신규 |
| 3 | `t_prc_component_prices` | **DELETE(17 comp) → INSERT 73** (+ `ON CONFLICT (nat_key) DO NOTHING` 안전망) | 정정: 라이브=정확히 73 |
| 4 | `t_prd_product_price_formulas` | **DELETE(15× PRF_POSTER_FIXED) → INSERT 15× PRF_*_FIXED** | 재바인딩(정정 핵심) |

마이그레이션 전후로 가드(`DO $$ … RAISE EXCEPTION`)가 PRF_POSTER_FIXED=15 → 고정가형=15·잔존=0 을 강제합니다.

## 4. 안전 절차 (Safe Procedure)

```
1) ./backup.sh                 # 읽기전용 — 15상품의 PRF_POSTER_FIXED 바인딩(+partial 단가)을 CSV로 백업
2) ./apply.sh                  # DRY-RUN(롤백) — 영향 카운트만 확인, DB 무변경
3) [인간 검토] 카운트·뷰어로 의미 확인
4) ./apply.sh --commit         # ★인간 승인★ — 실제 정정 반영 (단일 트랜잭션 COMMIT)
5) 뷰어에서 15상품 가격이 고정가형(규격별 정찰가)으로 보이는지 확인
6) 이상 시: ./undo.sh          # DRY-RUN 확인 후
            ./undo.sh --commit # ★인간 승인★ — PRF_POSTER_FIXED 복원 + 고정가형 엔티티 제거
```

- `apply.sh`/`undo.sh` 기본은 **DRY-RUN(ROLLBACK)**. `--commit` 인자 + 인간 승인일 때만 반영.
- 자격증명은 `.env.local`(chmod 600) 에서만 읽으며, 비밀번호는 어떤 출력에도 노출하지 않습니다.
- DDL 변경 없음 — 신규 테이블/컬럼/타입 생성 없이 기존 라이브 스키마·기존 siz_cd 재사용만.

## 5. undo 주의사항

`undo.sql` 은 PRF_POSTER_FIXED 바인딩을 복원하고 본 마이그레이션이 추가한 고정가형 엔티티
(공식15·FOAM/FOMEX 구성4·와이어링17·단가73)를 제거합니다. **단, 정정으로 지운 broken-partial
55행은 복원하지 않습니다**(그것이 정정의 목적). 완전 복원이 필요하면
`backup_partial_component_prices.csv` 를 수동 참조하십시오.

## 6. 라이브 DRY-RUN 실증 결과 (NEVER COMMIT)

`migrate.sql` 을 라이브 `BEGIN … ROLLBACK` 으로 1회 실행해 검증(롤백으로 무변경):

| 검증 | 기대 | 실측 |
|------|------|------|
| 고정가형 바인딩 | 15 | **15** |
| `PRF_POSTER_FIXED` 잔존 | 0 | **0** |
| component_prices(17 comp) | 73 | **73** |
| price_formulas 신규 | 15 | **15** |
| formula_components 신규 | 17 | **17** |
| siz FK orphan | 0 | **0** |
| comp FK orphan | 0 | **0** |
| 중복 자연키 | 0 | **0** |
| 제약 위반 | 0 | **0** |

`DELETE 55`(broken-partial) → `INSERT 73` 확인. ROLLBACK 후 라이브 무변경 재확인(15 on PRF_POSTER_FIXED).
`undo.sql` 도 migrate→undo 체인 DRY-RUN 으로 복원(PRF_POSTER_FIXED=15·신규엔티티 0) 검증 완료.

## 7. 파일

| 파일 | 역할 |
|------|------|
| `gen_migrate_sql.py` | 생성기 (입력 CSV verbatim → SQL, 손수정 금지·재현가능) |
| `migrate.sql` | 정정 마이그레이션 (단일 BEGIN…COMMIT) |
| `undo.sql` | 역마이그레이션 (단일 BEGIN…COMMIT) |
| `backup.sql` / `backup.sh` | 읽기전용 백업 스냅샷 |
| `apply.sh` | 실행기 (기본 DRY-RUN, `--commit`=인간 승인) |
| `undo.sh` | 역실행기 (기본 DRY-RUN, `--commit`=인간 승인) |
| `migrate.provenance.csv` | 출력행 → 입력 출처 추적 (137행) |

**입력 권위:** `02_mapping/load_price_correction/fixedprice-component-prices.csv`(73행) +
`fixedprice-formulas.csv`. `_exec_price`(커밋된 GO 적재본)는 **건드리지 않음**.
