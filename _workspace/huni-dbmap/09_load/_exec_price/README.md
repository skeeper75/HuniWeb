# 가격(t_prc_*) 적재 실행본 — `_exec_price/` (round-5)

> round-4 GO 가격 적재본(`09_load/_assembled_price/`, 2,320행)을 **멱등 실행 SQL + 로더**로
> 완성한 산출물. 실제 `COMMIT`(영구 적재)·DDL은 **인간 승인** 대상 — 본 트랙은 산출 + 롤백 DRY-RUN까지.
> 권위: `docs/goal-2026-06-06-02.md`(round-5) · `_assembled_price/load-manifest.md`(GO) ·
> `03_validation/price-load-validation-final.md`(GO). 식별자/SQL 영어, 설명 한국어.

## 1. 무엇인가

가격 6테이블(t_prc_* 5 + 코드행 1)의 **즉시 적재가능 2,320행**을 라이브 FK 위상정렬 순서로
재실행 안전(멱등)하게 적재하는 SQL 스크립트와 로더다. **재매핑 0** — round-4 검증 CSV를 조립·순서화·
래핑만 했다. 모든 INSERT는 `ON CONFLICT … DO NOTHING` 가드를 가져 2회 실행해도 2회차 행변경 0(R1).

## 2. 실행 순서 (FK 위상정렬) + 충돌키(ON CONFLICT) — 라이브 제약 매핑

| 단계 | 파일 | 대상 테이블 | 행수 | ON CONFLICT 키 | 백킹 라이브 제약 |
|------|------|------------|------|----------------|-----------------|
| 00 | `00_prc_component_type.sql` | `t_cod_base_codes` | 1 | `(cod_cd)` | PK `pk_t_cod_base_codes` |
| 01 | `01_prc_price_formulas.sql` | `t_prc_price_formulas` | 10 | `(frm_cd)` | PK `pk_t_prc_price_formulas` |
| 02 | `02_prc_price_components.sql` | `t_prc_price_components` | 143 | `(comp_cd)` | PK `pk_t_prc_price_components` |
| 03 | `03_prc_formula_components.sql` | `t_prc_formula_components` | 13 | `(frm_cd, comp_cd)` | PK `t_prc_formula_components_pkey` |
| 04 | `04_prc_component_prices.sql` | `t_prc_component_prices` | 2,108 | `(comp_price_id)` | PK `t_prc_component_prices_pkey` |
| 05 | `05_prd_product_price_formulas.sql` | `t_prd_product_price_formulas` | 45 | `(prd_cd, frm_cd)` | PK `t_prd_product_price_formulas_pkey` |

상위 트랜잭션 래퍼 = `apply.sql`(`BEGIN; \i 00 … \i 05`). COMMIT/ROLLBACK은 로더가 주입.

### 04 단가 충돌키를 PK(`comp_price_id`)로 택한 이유 (검증자 확인 요망)

라이브에는 자연키 unique index `ux_t_prc_comp_prices_nat_key`
(`comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty`)가 존재한다.
그러나 이 인덱스는 **`NULLS DISTINCT`**(`indnullsnotdistinct=f`, 라이브 PG 18.4 확증)라,
자연키 컬럼에 NULL이 있는 행(clr_cd 2,108행 전건·coat_side_cnt 2,108행 전건·mat_cd 1,574행 등)에서는
`ON CONFLICT (자연키) DO NOTHING`이 **발화하지 않아** 2회차 재실행 시 중복/PK충돌을 일으킨다(R1 위배).
따라서 충돌키를 **PK `comp_price_id`**(CSV가 결정적 명시값 제공·라이브 live count=0)로 채택했다 —
"같은 스크립트 2회"의 멱등성을 NULL 분포와 무관하게 보장한다. 자연키 unique index는 의미중복(다른
comp_price_id·같은 차원) 방어로 **존속**한다(적재본 자연키 intra-file 중복 0 확인).

## 3. 멱등성·원자성·재현성

- **멱등(R1):** 모든 INSERT에 `ON CONFLICT … DO NOTHING`. 충돌키는 라이브 PK/제약에서 읽음(§2, 추측 0).
- **원자성(R2):** `apply.sql` 단일 `BEGIN`. `ON_ERROR_STOP=1` → 임의 문 실패 시 전체 롤백. 테이블별
  파일에 `BEGIN/COMMIT` 없음(중첩·부분커밋 경로 0). COMMIT/ROLLBACK은 로더가 단일 세션 종결로 주입.
- **재현성(R3·G8):** 전 SQL은 `gen_load_sql.py`가 CSV에서 생성(손편집 0). 같은 입력 → 같은 출력.
  행수 어서트(2,320) 내장. per-row provenance = `*.provenance.csv`(sql_stmt_seq → source_csv:row).

## 4. 실행법 (로더)

```bash
cd 09_load/_exec_price
./apply.sh            # DRY-RUN(기본) — 롤백전용. 적재 시도 후 ROLLBACK. 영구변경 0.
./apply.sh commit     # 영구 적재 — 인간 승인 시에만. 본 하네스 자동 실행 금지.
```

- `.env.local`(chmod 600)에서 `RAILWAY_DB_*` 로드 — 비밀번호 echo·로그·`_workspace` 기록 0.
- SQL 재생성: `python3 gen_load_sql.py` (멱등).

## 5. 제외 (차단/GAP — 적재 SQL 미포함, 재포장 금지)

`_assembled_price/blocked-and-gaps.md` 권위. 본 실행본은 **즉시 적재가능 2,320행만**.

| 제외 | 규모 | 사유 | 해소 조건 |
|------|------|------|----------|
| component_prices placeholder siz | 2,697행 | siz_cd=`SIZ_PENDING%`(후니 미등록) | 후니 siz 등록 후 builder 재조립 |
| 박 시트 2단 룩업 | GAP 1건 | 면적→분류→가격 중간키 무손실 표현 불가 | ddl-proposer 제안서(11_ddl_proposals) |

## 6. 인간 승인 체크포인트

1. **라이브 DRY-RUN 실행 직전** — lead 승인(롤백전용이라도 쓰기 트랜잭션).
2. **코드행 선적재 적용** — 후니가 `PRC_COMPONENT_TYPE.06` 라이브 등록.
3. **실제 COMMIT** — R1~R6 + G1~G9 PASS 후 인간 승인.

## 7. 검증 인계 (R6 — 자기승인 금지)

본 산출물은 `dbm-validator`의 R1~R6 게이트 + 롤백전용 라이브 DRY-RUN 대상이다. builder는 자기 승인하지
않는다. 게이트 결과 → `03_validation/load-execution-gate.md`.
