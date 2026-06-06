# sql-idempotent-patterns — 멱등 적재 SQL + 로더 (dbm-load-builder)

> round-4 GO 적재본(`09_load/_assembled*/load/*.csv`)을 **재실행 안전한 실행 SQL + 로더**로
> 바꾸는 패턴. 권위: `docs/goal-2026-06-06-02.md` §8(작업 방법)·R1/R2/R3. 식별자·SQL 영어, 설명 한국어.

## 목차 (ToC)

1. 핵심 원칙 (멱등성·원자성·재현성)
2. ON CONFLICT UPSERT 패턴 (3 변형)
3. 충돌키(conflict target) 확정 — 라이브 제약에서 읽기
4. 단일 트랜잭션 래핑 (`apply.sql`)
5. FK 위상정렬 적재 순서
6. 코드행 선적재 + 신규 DDL 참조 배치
7. 적재 로더 (psql / Python) + `.env.local`
8. Provenance(출처) 추적
9. 산출 파일 레이아웃
10. 안티패턴 (하지 말 것)

---

## 1. 핵심 원칙

- **멱등성(R1):** 같은 스크립트를 2회 돌려도 2회차 행 변경 0. 모든 `INSERT`는 `ON CONFLICT` 가드를 가진다.
- **원자성(R2):** 적재 전체가 단일 `BEGIN…COMMIT`. 임의 단계 실패 → 전체 롤백. 부분 적재 경로 없음.
- **재현성(R3·G8):** SQL은 CSV 위에서 스크립트로 생성한다(손편집 금지). 같은 입력 → byte-identical 출력.
- **기본 모드 = 롤백:** 로더는 기본 DRY-RUN(ROLLBACK). 실제 `COMMIT`은 인간 승인 플래그(`--commit`)로만.

## 2. ON CONFLICT UPSERT 패턴 (3 변형)

대상 행의 의미에 따라 셋 중 하나를 선택한다. **기본은 변형 A(DO NOTHING)** — 적재는 "없으면 넣기"가 기본의미.

**변형 A — DO NOTHING (멱등 삽입, 기본):**
이미 있으면 건드리지 않는다. 코드행·마스터 참조·대부분의 `t_prd_product_*` 연결행.
```sql
INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, use_yn)
VALUES ('PRD_000138', 'MAT_000042', 'USE_07', 'Y')
ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;
```

**변형 B — DO UPDATE (의도된 갱신만):**
round-4가 `update-set`으로 분리한 컬럼 갱신(qty_unit·nonspec·두께·UV·excl_link 등). 갱신 컬럼을 명시한다.
`WHERE`로 실제 변경분만 — 같은 값이면 `EXCLUDED` 비교로 no-op(멱등 보강).
```sql
INSERT INTO t_prd_product_bundle_qtys (prd_cd, bundle_qty, qty_unit)
VALUES ('PRD_000016', 50, 'EA')
ON CONFLICT (prd_cd, bundle_qty) DO UPDATE
  SET qty_unit = EXCLUDED.qty_unit
  WHERE t_prd_product_bundle_qtys.qty_unit IS DISTINCT FROM EXCLUDED.qty_unit;
```

**변형 C — INSERT … WHERE NOT EXISTS (충돌제약이 없을 때):**
대상 테이블에 적합한 UNIQUE/PK 제약이 없어 `ON CONFLICT` 타겟을 못 잡는 경우. 차선책 — **먼저
validator에 "충돌키 부재"를 알리고**(R4 DDL 제안 후보일 수 있음) 임시로만 사용.
```sql
INSERT INTO t_prc_component_prices (comp_cd, siz_cd, qty_from, qty_to, unit_price)
SELECT 'COMP_POPT_...', 'SIZ_000336', 1, 49, 120.00
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_POPT_...' AND siz_cd='SIZ_000336' AND qty_from=1
);
```

## 3. 충돌키(conflict target) 확정 — 라이브 제약에서 읽기

`ON CONFLICT (cols)`의 `cols`는 **추측하지 않는다.** 라이브의 실제 PK/UNIQUE 제약에서 읽어 그대로 쓴다.
```sql
-- 대상 테이블의 PK/UNIQUE 컬럼 조회 (read-only)
SELECT con.conname, con.contype,
       string_agg(att.attname, ', ' ORDER BY u.ord) AS cols
FROM pg_constraint con
JOIN unnest(con.conkey) WITH ORDINALITY u(attnum, ord) ON true
JOIN pg_attribute att ON att.attrelid = con.conrelid AND att.attnum = u.attnum
WHERE con.conrelid = 't_prd_product_materials'::regclass
  AND con.contype IN ('p','u')
GROUP BY con.conname, con.contype;
```
- 자연키(예: `prd_cd, mat_cd, usage_cd`)가 UNIQUE면 그것이 충돌 타겟. 단순 surrogate PK(예: serial `id`)만
  있으면 자연키 UNIQUE 제약이 없는 것 → 변형 C 또는 **R4 DDL 제안**(UNIQUE 제약 추가)으로 라우팅.

## 4. 단일 트랜잭션 래핑 (`apply.sql`)

테이블별 `<NN>_<table>.sql`은 INSERT 본문만 담고, 최상위 `apply.sql`이 순서대로 `\i` 하며 트랜잭션으로 감싼다.
```sql
-- apply.sql  (기본 = DRY-RUN: 끝에서 ROLLBACK. --commit 시에만 COMMIT)
\set ON_ERROR_STOP on
BEGIN;
  \i 00_code_preload.sql        -- 코드행 선적재 (t_cod_base_codes 등)
  -- (신규 DDL은 여기 적용되지 않음 — 제안서. 적용은 별도 인간 승인 후 선행)
  \i 01_prc_price_formulas.sql
  \i 02_prc_price_components.sql
  -- … FK 위상정렬 순 …
  \i 04_prc_component_prices.sql
  \i 05_prd_product_price_formulas.sql
-- 기본은 ROLLBACK (apply.sh가 주입). 실제 적재는 --commit 플래그로만 COMMIT.
```
- `ON_ERROR_STOP on`: 임의 문 실패 시 즉시 중단 → 트랜잭션 abort → 전체 롤백(R2).
- **부분 커밋 경로를 만들지 않는다.** 중간 `COMMIT` 금지. 테이블별 파일에 `BEGIN/COMMIT`을 넣지 않는다(중첩 금지).

## 5. FK 위상정렬 적재 순서

순서는 round-4 `load-manifest.md`가 권위. 부모→자식. 요약:
- **상품마스터:** 00 코드행(레이저커팅 proc·원형 siz) → (03 `t_prd_products` 신규=차단) → 05 materials →
  06 processes → 09 bundle_qtys → (07 print_options·08 page_rules·10 addons) · update-set은 해당 단계 직후.
- **가격:** 00 `t_cod_base_codes`(.06) → 01 price_formulas → 02 price_components → 03 formula_components →
  04 component_prices → 05 product_price_formulas.
- 사이클·미해소 부모는 재정렬로 우회하지 말고 blocker로 보고(GOAL §6).

## 6. 코드행 선적재 + 신규 DDL 참조 배치

- **코드행 선적재:** round-4 `code-row-preload.md`를 `00_code_preload.sql`로 — 변형 A(DO NOTHING)로 멱등.
- **신규 DDL 의존 행:** 어떤 적재행이 proposer의 신규 엔티티에 의존하면, `apply.sql` 주석으로 "이 단계는
  `ddl-proposal-<gap>` 적용 후에만 유효"를 명시하고, **그 행은 차단 목록에 유지**(DDL은 제안일 뿐 미적용).
  DDL이 인간 승인·적용된 뒤에야 해당 적재행을 활성 단계로 승격한다.

## 7. 적재 로더 (psql / Python) + `.env.local`

**psql 로더 `apply.sh` (기본 DRY-RUN):**
```bash
#!/usr/bin/env bash
set -euo pipefail
set -a; source "$(git rev-parse --show-toplevel)/.env.local"; set +a   # RAILWAY_DB_* 로드
export PGPASSWORD="$RAILWAY_DB_PASSWORD"                                # stdout에 절대 echo 금지
MODE="${1:-dryrun}"   # dryrun(기본) | commit(인간 승인 시)
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1"
if [ "$MODE" = "commit" ]; then
  echo "[COMMIT MODE] 인간 승인 적재 — apply.sql 끝에 COMMIT"
  $PSQL -f apply.sql -c "COMMIT;"
else
  echo "[DRY-RUN] 롤백전용 — 아무것도 커밋되지 않음"
  $PSQL -f apply.sql -c "ROLLBACK;"
fi
unset PGPASSWORD
```
- `apply.sql`은 `BEGIN`으로 열고 `COMMIT`/`ROLLBACK`을 **로더가 주입**(파일 자체엔 미포함). 기본 ROLLBACK.
- 비밀번호는 `PGPASSWORD` 환경변수로만 전달, `echo`/로그/`_workspace` 기록 금지.

**Python 로더 `load.py` (psycopg, 대량·검증 동시 수행 시):**
```python
import os, psycopg
# .env.local 은 셸에서 export 후 실행하거나 python-dotenv 로 로드 (값 echo 금지)
dsn = f"host={os.environ['RAILWAY_DB_HOST']} port={os.environ['RAILWAY_DB_PORT']} " \
      f"dbname={os.environ['RAILWAY_DB_NAME']} user={os.environ['RAILWAY_DB_USER']} " \
      f"password={os.environ['RAILWAY_DB_PASSWORD']}"
commit = os.environ.get("LOAD_COMMIT") == "1"     # 기본 False = 롤백
with psycopg.connect(dsn) as conn:
    with conn.transaction() as tx:                # 컨텍스트 종료 시 commit; 예외 시 rollback
        with conn.cursor() as cur:
            for sql_file in ordered_sql_files():
                cur.execute(open(sql_file).read())
        if not commit:
            raise psycopg.Rollback                # 명시적 롤백 (DRY-RUN)
```

## 8. Provenance(출처) 추적

각 INSERT 생성 행이 어느 CSV 행에서 왔는지 추적 가능해야 한다(validator 역대조용).
- 생성 스크립트가 `<NN>_<table>.sql` 옆에 `<NN>_<table>.provenance.csv`(sql_line → source_csv:row)를 남긴다.
- 또는 SQL 주석으로 `-- src: load/04_prc_component_prices.csv:1207`을 각 VALUES 블록 위에 붙인다.

## 9. 산출 파일 레이아웃

```
09_load/_exec/            (상품마스터)
├ gen_load_sql.py         생성기(CSV→멱등 SQL, 재현성)
├ apply.sql               트랜잭션 래퍼(\i 순서)
├ apply.sh                psql 로더(기본 dryrun)
├ 00_code_preload.sql · 05_t_prd_product_materials.sql · 06_…processes.sql · 09_…bundle_qtys.sql
├ *.provenance.csv
└ README.md               실행법·기본 롤백·--commit 인간승인 명시
09_load/_exec_price/      (가격, 동형: 00_prc_component_type … 05_prd_product_price_formulas)
```

## 10. 안티패턴 (하지 말 것)

- ❌ `ON CONFLICT` 없는 bare INSERT (재실행 시 PK 충돌 → R1 FAIL).
- ❌ 충돌키 추측 — 라이브 제약에서 읽지 않고 `(prd_cd)`로 단정.
- ❌ 테이블별 파일에 `BEGIN/COMMIT` 중첩, 중간 `COMMIT`(원자성 깨짐 → R2 FAIL).
- ❌ 로더 기본 모드가 commit (사고 위험). 기본은 항상 dryrun/rollback.
- ❌ `DO UPDATE`를 무차별 적용 — 갱신 의도 없는 행까지 덮어쓰기. 변형 B는 update-set 분리 행에만.
- ❌ 비밀번호를 SQL/로그/`_workspace`에 기록.
- ❌ 손으로 SQL 편집(재현성 깨짐). 항상 생성기 경유.
