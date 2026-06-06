# live-dry-run — 롤백전용 라이브 DRY-RUN + 멱등성 증명 (dbm-validator)

> round-5 적재 실행본의 **R1(멱등성)·R5(라이브 DRY-RUN)**을 라이브에서 쓰기 없이 실증하는 절차.
> 권위: `docs/goal-2026-06-06-02.md` §8·R1/R2/R5·§10(인간 승인). **NEVER COMMIT.** 식별자·SQL 영어, 설명 한국어.

## 목차 (ToC)

1. 안전 규칙 (HARD)
2. 단계 0 — 로컬 선검사 (무쓰기, 기본)
3. 단계 1 — 라이브 DRY-RUN (롤백전용, lead 승인 시)
4. R5 — 제약 위반 캡처
5. R1 — 멱등성 2회 적용 증명
6. R2 — 원자성(부분적재 불가) 증명
7. 결과 기록 + 라우팅

---

## 1. 안전 규칙 (HARD)

- **COMMIT 절대 금지.** 모든 DRY-RUN은 `BEGIN … ROLLBACK`. 성공·실패 무관하게 ROLLBACK으로 끝낸다.
- **lead 승인 후 1회.** 롤백전용이라도 쓰기 트랜잭션이다 — 오케스트레이터/사용자 승인 없이 실행하지 않는다(GOAL §10.1).
- **기본은 로컬 선검사(단계 0).** 라이브 접속 없이 잡을 수 있는 결함을 먼저 모두 잡는다. 라이브 DRY-RUN은 잔여 실증용.
- **비밀값 보호.** `RAILWAY_DB_*`는 `.env.local`에서만. `PGPASSWORD` 환경변수로만 전달, stdout/`_workspace` 기록 금지.
- **읽기 최소화.** 필요한 제약·존재 확인만 read-only로. 반복 풀스캔 금지.

## 2. 단계 0 — 로컬 선검사 (무쓰기, 기본)

라이브 접속 전에 스크립트·CSV만으로 검사한다(R1~R4의 대부분을 여기서 PASS):
- **SQL 파싱(R3):** 각 `.sql`을 `psql -f … -c '\q'` 또는 파서로 문법 확인(실행 아님). 또는 `EXPLAIN`은 쓰기 전이라 부적합 — 구문 검사는 dry parse.
- **ON CONFLICT 존재(R1):** 모든 `INSERT`에 `ON CONFLICT` 절이 있는지 grep. 없는 INSERT 0건이어야 PASS.
- **충돌키 정합(R1):** 각 `ON CONFLICT (cols)`의 cols가 라이브 PK/UNIQUE와 일치하는지 대조(§sql 패턴 3절 쿼리 결과와).
- **트랜잭션 구조(R2):** `apply.sql`이 단일 `BEGIN`으로 열리고 중간 `COMMIT`이 없는지, 테이블별 파일에 `BEGIN/COMMIT` 중첩이 없는지.
- **타입/길이/NOT NULL/CHECK(R5 예비):** round-4 `columns.csv`+라이브 DDL 기준 값 적합성 로컬 계산(round-4 G4 carry-forward).

단계 0에서 FAIL이 잡히면 라이브 DRY-RUN 전에 builder/proposer로 라우팅 — 라이브 호출을 아낀다.

## 3. 단계 1 — 라이브 DRY-RUN (롤백전용, lead 승인 시)

단계 0 PASS 후, 잔여 실증(실제 FK 충족·PK 중복·CHECK)을 위해 라이브에서 1회.
```bash
set -a; source "$(git rev-parse --show-toplevel)/.env.local"; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PSQL="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -v ON_ERROR_STOP=1 -q"
$PSQL <<'SQL'
BEGIN;
  \i 00_code_preload.sql
  \i 01_prc_price_formulas.sql
  -- … 전 단계 …
  \i 04_prc_component_prices.sql
  \i 05_prd_product_price_formulas.sql
  -- 적재 후 어서션(아래 §4·§5) 실행
ROLLBACK;     -- 무조건 롤백 — 아무것도 커밋되지 않음
SQL
unset PGPASSWORD
```
- `ON_ERROR_STOP=1`: 첫 제약 위반에서 중단 → abort. 위반 메시지가 R5 증거.
- 신규 DDL 의존 행은 **제외**(DDL 미적용 — 차단 유지). DDL 적용을 전제한 DRY-RUN은 후니 적용 후 별도.

## 4. R5 — 제약 위반 캡처

목표: 위반 0 입증. 위반이 있으면 유형별로 분류해 보고.
- 트랜잭션 안에서 적재 후 어서션 쿼리로 확인(롤백 전):
```sql
-- FK 고아 (예: component_prices.siz_cd 가 t_siz_sizes 에 없는지)
SELECT cp.comp_cd, cp.siz_cd FROM t_prc_component_prices cp
LEFT JOIN t_siz_sizes s ON s.siz_cd = cp.siz_cd
WHERE s.siz_cd IS NULL;       -- 0행이어야 PASS
-- PK/자연키 중복 (적재분 내부 + 라이브 기존과)
SELECT prd_cd, mat_cd, usage_cd, count(*) FROM t_prd_product_materials
GROUP BY 1,2,3 HAVING count(*) > 1;   -- 0행
```
- 유형: 타입/길이 · NOT NULL · CHECK · FK 고아 · PK/자연키 중복. 각 위반은 file·row·column·제약명을 적는다.
- ON_ERROR_STOP으로 첫 위반에서 멈추면, 그 행을 고치고 재실행해 다음 위반을 순차 수집(또는 어서션으로 일괄).

## 5. R1 — 멱등성 2회 적용 증명 (핵심)

같은 롤백 트랜잭션 안에서 적재를 **2회** 실행하고, 2회차가 행을 바꾸지 않음을 보인다.
```sql
BEGIN;
  -- 1회차: 적재 (ON CONFLICT 가드)
  \i apply_body.sql
  -- 1회차 후 카운트 스냅샷
  CREATE TEMP TABLE _snap AS
    SELECT 't_prd_product_materials' t, count(*) c FROM t_prd_product_materials
    UNION ALL SELECT 't_prc_component_prices', count(*) FROM t_prc_component_prices;
  -- 2회차: 동일 적재 재실행
  \i apply_body.sql
  -- 2회차 후 카운트가 1회차와 동일해야 멱등 (델타 0)
  SELECT s.t, s.c AS after1,
         (CASE s.t WHEN 't_prd_product_materials' THEN (SELECT count(*) FROM t_prd_product_materials)
                   WHEN 't_prc_component_prices'   THEN (SELECT count(*) FROM t_prc_component_prices) END) AS after2
  FROM _snap s;     -- after1 = after2 모든 행 → R1 PASS
ROLLBACK;
```
- 2회차에 PK 충돌 에러가 나면 `ON CONFLICT` 누락/잘못된 충돌키 → R1 FAIL, builder 라우팅.
- `DO UPDATE` 행은 카운트만으론 부족 — 2회차에 갱신 컬럼이 안 바뀌는지(`xmin` 불변 또는 값 비교)도 확인.

## 6. R2 — 원자성(부분적재 불가) 증명

중간 단계에 의도적 실패를 주입하면 전체가 롤백되는지(앞 단계도 안 남는지) 확인.
```sql
BEGIN;
  \i 01_prc_price_formulas.sql
  -- 주입: 일부러 실패하는 문 (예: 존재하지 않는 컬럼) → ON_ERROR_STOP 으로 abort
  INSERT INTO t_prc_price_formulas (nonexistent_col) VALUES (1);
ROLLBACK;
-- 이후 read-only로 t_prc_price_formulas 에 01 단계 행이 남지 않았는지 확인 (트랜잭션 abort로 0)
```
- 실제로는 `ON_ERROR_STOP=1` + 단일 트랜잭션 구조면 구조적으로 보장 — 코드 리뷰로 R2 PASS 가능. 주입 테스트는 보강.

## 7. 결과 기록 + 라우팅

- `03_validation/load-execution-gate.md`에 R1~R6 PASS/FAIL을 근거(쿼리·결과·라인)와 함께 기록.
- 멱등성 증명(§5)의 after1=after2 표, 라이브 DRY-RUN 위반 목록(0이면 "위반 0" 명시)을 첨부.
- FAIL은 builder(SQL/순서)·proposer(DDL)·designer(매핑)로 라우팅, 변경분만 재게이트. 오독은 정직하게 철회.
- 라이브 DRY-RUN을 실행하지 못한 경우(미승인): R5를 "보류(lead 미승인)"로 정직 표기 — round-4 G6처럼 PASS* 처리하되 잔여 선결로 명시.
