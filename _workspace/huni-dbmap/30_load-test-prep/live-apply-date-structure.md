# 라이브 가격 적재 전 "적용일 기준" 구조 규명

> 작성 2026-06-15 · 읽기전용 SELECT만 실측(DB 쓰기 0) · round-19 가격 폐루프 실 적재 직전 안전 점검
> 사용자 단서: **"라이브 DB 구조가 적용일(시계열) 기준으로 개발돼 있으니 적재 테스트에 추가 고려사항이 있는지 먼저 확인하고 신중히"**
> 권위 = 라이브 information_schema/pg_constraint 실측 + webadmin 소스(`catalog/price_views.py`, `catalog/models.py`)

---

## 결론 요약 (먼저)

1. **라이브는 "적용일(apply_ymd) 시계열 누적형" 구조가 맞다.** 가격·할인 사슬의 핵심 테이블 4종이 **적용일 컬럼을 PK/자연키의 일부**로 포함한다 → 같은 가격이라도 적용일이 다르면 **새 행으로 누적**(덮어쓰기 아님)되도록 설계됨.
2. **그러나 현재 적재된 데이터는 단일 세대뿐이다.** 모든 적용일 값이 `2026-06-01` 하나로 통일돼 있고, 동일 자연키에 적용일만 다른 다중 버전은 **0건**. 즉 "구조는 시계열, 데이터는 현재값 1세대".
3. **가격엔진(webadmin `_latest`)은 "오늘 이하 가장 최신 apply_ymd 행"을 현재값으로 읽는다.** 미래 적용일은 활성화되지 않고, 과거/오늘 중 max를 고른다 → **신규 적재의 apply_ymd를 어떻게 잡느냐가 "기존 가격을 대체하느냐, 시계열에 추가되느냐, 충돌하느냐"를 결정**한다. 이것이 사용자 단서의 핵심.

---

## §1 적용일 / 시계열 구조 실측

### 1-1. 시점성 컬럼 전수 (information_schema 실측)

| 테이블 | 적용일 컬럼 | 타입 | NULL | DEFAULT | 자연키 포함? |
|--------|-----------|------|------|---------|------------|
| `t_prc_component_prices` | **`apply_ymd`** | varchar(10) | NOT NULL | (없음) | ✅ UNIQUE `ux_t_prc_comp_prices_nat_key` (10-컬럼) |
| `t_prd_product_price_formulas` | **`apply_bgn_ymd`** | varchar(10) | NOT NULL | (없음) | ✅ **PK = (prd_cd, apply_bgn_ymd)** |
| `t_dsc_discount_details` | **`apply_ymd`** | varchar(10) | NOT NULL | (없음) | ✅ **PK = (dsc_tbl_cd, apply_ymd, min_qty)** |
| `t_dsc_grade_discount_rates` | **`apply_ymd`** | varchar(10) | NOT NULL | (없음) | ✅ **PK = (grade_cd, cat_cd, apply_ymd)** |
| `t_prd_product_discount_tables` | `apply_bgn_ymd` | varchar(10) | NOT NULL | (없음) | ✅ PK 일부(모델 `CompositePrimaryKey('prd_cd','apply_bgn_ymd')`) |
| `t_prc_price_components` | (없음) | — | — | — | ❌ 적용일 없음. PK = `comp_cd` 단일 |
| `t_prc_price_formulas` | (없음) | — | — | — | ❌ 적용일 없음. PK = `frm_cd` 단일 |
| `t_prc_formula_components` | (없음) | — | — | — | ❌ 적용일 없음. PK = (frm_cd, comp_cd) |
| `t_dsc_discount_tables` | (없음) | — | — | — | ❌ 적용일 없음. PK = `dsc_tbl_cd` |

**감사 컬럼(전 테이블 공통):** `reg_dt` timestamp NOT NULL DEFAULT now() · `upd_dt` timestamp NULL(트리거가 UPDATE 시 갱신).

> **구조 해석 — 두 갈래로 갈린다:**
> - **"정의" 계층(공식·구성요소·할인테이블 헤더)** = `t_prc_price_formulas`, `t_prc_price_components`, `t_prc_formula_components`, `t_dsc_discount_tables` → **적용일 없음, 단일 현재 정의**. 신규/수정 = 그냥 그 행 INSERT/UPSERT.
> - **"값" 계층(단가행·공식 바인딩·구간 할인율)** = `t_prc_component_prices`, `t_prd_product_price_formulas`, `t_dsc_discount_details`, `t_prd_product_discount_tables` → **적용일이 키 → 시계열 누적**. 같은 상품/구성요소라도 적용일이 다르면 별도 행이 공존하고, 엔진이 그중 최신을 고른다.

### 1-2. 실제 데이터 분포 (현재 라이브)

| 테이블 | DISTINCT apply_ymd | 행수 | 동일 자연키 다중버전 |
|--------|-------------------|------|---------------------|
| `t_prc_component_prices` | `2026-06-01` (단일) | 3,481 | **0건** |
| `t_prd_product_price_formulas` | `2026-06-01` (단일) | 63 | **0건** |
| `t_dsc_discount_details` | `2026-06-01` (단일) | 35 | **0건** |
| `t_dsc_grade_discount_rates` | (비어 있음) | 0 | — |

- 적용일 포맷 = **`YYYY-MM-DD`** (varchar(10), len=10). webadmin 명명 규칙 `_ymd → varchar(10) 'yyyy-MM-dd'`와 일치. (주의: `YYYYMMDD` 8자리 아님 — 하이픈 포함 10자리.)
- **판정 = "시계열 누적 가능형 구조 + 현재값 1세대 데이터"**. 시계열 기능은 아직 한 번도 사용되지 않았고, 전부 단일 기준일 `2026-06-01`에 적재됨.

### 1-3. 엔진의 적용일 조회 로직 (webadmin `catalog/price_views.py:139`)

```python
def _latest(rows, key="apply_ymd"):
    """오늘 이하 최신 행 (미래분 제외). 없으면 None."""
    today = date.today().isoformat()
    past = [r for r in rows if (r.get(key) or "") <= today]
    return max(past, key=lambda r: r[key]) if past else None
```

- 단가행/공식 바인딩/템플릿가 모두 `order_by("-apply_ymd")` 후 `_latest`로 **오늘 이하 최신 1건**을 현재값으로 채택.
- 의미: **미래 적용일(예: `2099-01-01`)은 오늘 기준 비활성** → 미리 적재해도 노출 안 됨. **오늘 이하 중 max**가 항상 이긴다.
- 단, `_latest`는 `t_prd_product_prices`/`t_prd_product_price_formulas`/`t_prd_template_prices` 같은 "상품 직접 가격/공식 선택"에 적용된다. **`t_prc_component_prices`(단가행)는 `_latest` 미적용** — 공식이 가리키는 comp_cd의 단가행을 (현재 코드상) **apply_ymd 필터 없이 매칭**한다(아래 시사점 참조).

### 1-4. 적재 시사점 (구조가 적재를 어떻게 제약하나)

| 적재 대상 | apply_ymd 키? | 신규 적재 시 거동 |
|-----------|--------------|------------------|
| `t_prc_component_prices` 단가행 신규 INSERT | ✅ (자연키 10-컬럼) | apply_ymd를 `2026-06-01`로 = 기존 세대에 합류(자연키 충돌 시 UPSERT). **다른 날짜로 = 같은 키에 2세대 공존** → ⚠️ 엔진이 apply_ymd 필터 없이 매칭하면 **중복 행 매칭(가격 이중 계상/비결정)** 위험 |
| `t_prc_price_components` prc_typ UPDATE (D-1b) | ❌ | 적용일 무관, 단일 행 UPDATE. 시계열 영향 없음 — 안전 |
| `t_prc_price_formulas` 명함 공식 INSERT (WIRE) | ❌ | 적용일 무관, frm_cd 신규 INSERT. 시계열 영향 없음 |
| `t_prc_formula_components` 배선 INSERT (WIRE) | ❌ | 적용일 무관, (frm_cd,comp_cd) INSERT. 시계열 영향 없음 |
| `t_prd_product_price_formulas` 상품↔공식 바인딩 | ✅ PK | 신규 바인딩 = apply_bgn_ymd 필수. `2026-06-01`로 = 기존 세대 합류. 다른 날짜 = 같은 prd_cd에 2바인딩 공존(엔진은 `_latest`로 최신만 선택 → **안전하게 대체됨**) |

**핵심 비대칭:** 상품↔공식 바인딩(`product_price_formulas`)·상품 직접가(`product_prices`)는 `_latest`로 보호되므로 적용일을 신규로 줘도 안전하게 신구 교체가 된다. **그러나 단가행(`component_prices`)은 `_latest` 미적용 → 적용일을 분기하면 중복 매칭 위험**이 있어, **단가행은 기존 세대 apply_ymd(`2026-06-01`)와 동일하게 적재(UPSERT)하는 것이 안전**하다. → §4 신중 포인트 ②.

---

## §2 적재 대상 테이블 제약·함정

> round-19 폐루프가 건드릴 테이블: `t_cod_base_codes`(PRICE_TYPE.03 INSERT 권고) · `t_prc_price_components`(prc_typ_cd UPDATE) · `t_prc_price_formulas`(명함 공식 INSERT) · `t_prc_formula_components`(배선 INSERT) · `t_prc_component_prices`(단가행 INSERT)

### 2-1. NOT NULL / DEFAULT / 트리거 / 시퀀스

| 테이블 | 채번/PK | 감사컬럼 함정 | 트리거 | CHECK 제약 |
|--------|---------|--------------|--------|-----------|
| `t_cod_base_codes` | PK=`cod_cd`(문자) | reg_dt NOT NULL DEFAULT now() · upd_dt NULL | `trg_..._upd_dt` (BEFORE UPDATE만) | `use_yn ∈ {Y,N}` |
| `t_prc_price_components` | PK=`comp_cd`(문자) | 동일 | BEFORE UPDATE upd_dt | `use_yn ∈ {Y,N}` |
| `t_prc_price_formulas` | PK=`frm_cd`(문자) | 동일 | BEFORE UPDATE upd_dt | `use_yn ∈ {Y,N}` |
| `t_prc_formula_components` | PK=(frm_cd,comp_cd) | 동일 | BEFORE UPDATE upd_dt | `addtn_yn ∈ {Y,N}` |
| `t_prc_component_prices` | PK=`comp_price_id` **IDENTITY** | 동일 | BEFORE UPDATE upd_dt | (CHECK 없음) |
| `t_dsc_discount_details` | PK=(dsc_tbl_cd,apply_ymd,min_qty) | 동일 | BEFORE UPDATE upd_dt | `dsc_rate IS NULL OR dsc_amt IS NULL` (상호배타) |

**함정 정리:**
- **(F1) reg_dt NOT NULL DEFAULT 함정** [round-5 교훈 재확인] — INSERT에서 reg_dt에 **명시 NULL을 주면 DEFAULT가 발화하지 않아 NOT NULL 위반**. 컬럼을 **생략(omit)**하거나 `DEFAULT` 키워드를 써야 now()가 들어간다. 실측: 현재 comp_prices reg_dt NULL=0 / upd_dt NULL=3481(정상 — 한 번도 UPDATE 안 됨).
- **(F2) 트리거는 INSERT를 막지 않는다** — 적재 대상 6테이블의 트리거는 전부 `BEFORE UPDATE`(upd_dt 자동 now() 갱신)뿐. INSERT 차단 트리거(`fn_chk_opt_item_ref` 같은 RAISE EXCEPTION) **없음** → 신규 INSERT 안전. (그 트리거는 `t_prd_product_option_items`에만 존재, 본 적재 대상 아님.)
- **(F3) IDENTITY 시퀀스 stale — 현재는 안전** — `t_prc_component_prices.comp_price_id`는 GENERATED IDENTITY. 실측 `MAX(id)=4954`, 시퀀스 `last_value=5123` → **시퀀스 > MAX 이므로 다음 INSERT 충돌 없음**(stale 아님). 단, **INSERT 시 comp_price_id를 명시하지 말 것**(IDENTITY가 자동 채번 — 명시하면 `OVERRIDING SYSTEM VALUE` 필요 + 시퀀스 재동기 깨짐). [digitalprint setval 교훈 — 이번엔 setval 불필요하나, 만약 명시 id INSERT를 한다면 적재 후 `setval` 재동기 필수.]
- **(F4) prc_typ_cd FK** — `t_prc_price_components.prc_typ_cd → t_cod_base_codes(cod_cd)` FK 존재. **D-1b의 PRICE_TYPE.03 신설은 FK 부모(`t_cod_base_codes`)에 먼저 INSERT** 후에야 자식 UPDATE 가능(위상 순서). 현재 PRICE_TYPE 코드 = `.01 단가형` / `.02 합가형` 2종뿐, **`.03` 미존재**(D-1b 권고대로 신설 필요).
- **(F5) 할인 상호배타 CHECK** — `t_dsc_discount_details`: dsc_rate와 dsc_amt 중 **하나는 반드시 NULL**(둘 다 채우면 위반). round-19가 할인을 건드리진 않으나, 향후 적재 시 주의.

### 2-2. PRICE_TYPE 코드 현황 (D-1b 직결)

```
PRICE_TYPE      | 단가유형  | (root)
PRICE_TYPE.01   | 단가형    | upr=PRICE_TYPE   ← 현재 price_components 144행 전부 이 값
PRICE_TYPE.02   | 합가형    | upr=PRICE_TYPE
(PRICE_TYPE.03  | 미존재 — round-19 D-1b "구간고정총액형" 신설 권고분)
```
- 코드 그룹핑 = `upr_cod_cd` 컬럼(부모-자식). t_cod에 별도 그룹컬럼 없음(`cod_cd`,`cod_nm`,`upr_cod_cd`,`disp_seq`,`use_yn`,`note`,`reg_dt`,`upd_dt`).

---

## §3 적재 안전장치·백업 절차

### 3-1. 백업 권한 — 확인 결과: **가능**

- 실측: `current_user = postgres`, `rolsuper=true`, `has_create_on_public=true`.
- → 읽기전용이 아니라 **슈퍼유저**. `CREATE TABLE bak_* AS SELECT *` 스냅샷 백업 **권한 있음**(권한 재고 불필요).
- 단 본 규명 작업 자체는 SELECT만 수행(쓰기 0). 백업 CREATE는 실 적재 단계(인간 승인 후)에서.

### 3-2. 재사용 가능한 기존 패턴 — **있음, 그대로 재사용 권장**

기존 적재 실행이 검증된 패턴을 보유(`09_load/_exec_safeload_260614/apply.sh`·`23_remediation-apply/_APPLIED-*.md`):

```
apply.sh 거동:
  기본(인자 없음) = DRY-RUN — apply.sql 끝에 `ROLLBACK;` 주입 (롤백 전용)
  commit 인자     = apply.sql 끝에 `COMMIT;` 주입 (인간 승인 시에만)
  apply.sql       = BEGIN; … (단일 트랜잭션) … COMMIT/ROLLBACK 은 apply.sh 가 -c 주입
  ON_ERROR_STOP=1 — 오류 1건이라도 나면 전체 중단
```

검증된 절차(`_APPLIED-valid-6sheets.md` §2 발췌):
1. **백업 스냅샷** — 영향 테이블만 `pre_*.csv`로 SELECT 덤프(예: `_exec_tierA_backup_260614/pre_*.csv`).
2. **COMMIT 직전 DRY-RUN 미리보기** — BEGIN…ROLLBACK으로 변경량·오류0 확인.
3. **COMMIT** — 인간 승인 후 `apply.sh commit`.
4. **검증** — 적재 후 행수·값·FK 고아0 확인.
5. **멱등 2회차** — 값가드(`IS DISTINCT FROM`)·`ON CONFLICT`로 재실행 delta 0 확인.

### 3-3. 권장 백업 방식

- **1차(가벼움·git 추적):** 영향 테이블 6종을 `pre_<table>.csv`로 `\copy (SELECT * FROM …) TO …`. round-19가 건드리는 행수가 적으므로(comp_prices 일부·price_components 144·코드 1행 등) CSV로 충분.
- **2차(라이브 스냅샷·DB 내부):** 슈퍼유저 권한 있으므로 `CREATE TABLE bak_<table>_260615 AS SELECT * FROM <table>;`. 단 **이건 DB 쓰기**이므로 실 적재 인간 승인 시점에 함께 실행(본 규명 단계 금지).
- **롤백 안전망:** apply.sql이 단일 트랜잭션 + ON_ERROR_STOP=1 → 중간 실패 시 자동 전체 롤백. COMMIT 후 되돌리려면 bak_* 테이블에서 복구하는 undo 스크립트 별도 준비 권장.

---

## §4 "적재 테스트 추가 고려사항" 종합 (사용자 단서 직답)

### 사용자 단서 → 직답

> **"라이브 DB 구조가 적용일 기준으로 개발돼 있다"** = 가격·할인 사슬의 **값 계층(단가행·공식바인딩·구간할인)이 적용일을 키로 시계열 누적**되도록 설계됐다는 뜻이 맞습니다. 그러나 현재 데이터는 단일 기준일 `2026-06-01` 1세대뿐이고, 엔진은 "오늘 이하 최신 적용일"을 읽습니다. **따라서 적재 시 apply_ymd를 어떻게 잡느냐가 곧 "기존값 대체 / 시계열 추가 / 중복 충돌"을 결정**하며, 이것이 신중해야 할 핵심입니다.

### 가장 주의할 고려사항 3가지

**① apply_ymd 적재 전략을 명시적으로 결정하라 (가장 중요).**
- 시계열 키이므로 "그냥 INSERT"하면 안 된다. 선택지:
  - ⓐ **기존 세대 합류(`2026-06-01` 동일)** — UPSERT(`ON CONFLICT … DO UPDATE`)로 현재값을 정정. round-19 D-1b(prc_typ 정정)·WIRE(공식·배선)는 **이쪽 권장** — 시계열을 새로 열 이유가 없는 "정정/배선"이므로.
  - ⓑ **새 적용일로 시계열 추가(예: `2026-06-15`)** — 가격 인상/개정처럼 "기준일부터 새 가격" 의미일 때. `product_price_formulas`·`product_prices`는 `_latest`가 보호하므로 안전. **단 단가행(component_prices)은 ⓑ를 쓰면 위험**(②).
- → **컨펌 C-1:** round-19 폐루프 적재의 의미가 "정정(기존 6/1 세대 수정)"인가 "신규 개정일 가격(예: 6/15)"인가? 정정이면 ⓐ로 `2026-06-01` 유지가 안전.

**② 단가행(`t_prc_component_prices`)은 적용일을 분기하지 말고 기존 세대로 UPSERT하라.**
- `product_price_formulas`/`product_prices`와 달리 component_prices 단가행은 엔진이 `_latest`(오늘 이하 최신)로 거르지 **않는다**(현재 코드상 apply_ymd 무필터 매칭). 적용일을 새로 주면 같은 자연키에 2세대가 공존하고 **단가행 중복 매칭 → 가격 이중 계상·비결정** 위험.
- → 단가행 신규/정정은 **apply_ymd=`2026-06-01`(기존 세대)로 통일 + 자연키 UPSERT**가 안전.
- → **컨펌 C-2:** 엔진이 단가행을 정말 apply_ymd 무필터로 읽는지(evaluate_price 미구현이라 명세만 존재) — 향후 엔진 구현 시 `_latest`를 단가행에도 적용할 계획이면 ⓑ도 가능. 현 시점 보수적으로는 ⓐ.

**③ FK 위상 순서 + reg_dt 생략 + IDENTITY 비명시를 지켜라.**
- **위상 순서:** PRICE_TYPE.03(부모 `t_cod_base_codes`) → 그 다음 `price_components.prc_typ_cd` UPDATE. 명함 공식은 `price_formulas`(부모) → `formula_components`(자식) → 필요시 `component_prices`(단가행). 역순이면 FK 위반.
- **reg_dt:** INSERT에서 reg_dt를 **컬럼 목록에서 생략**(DEFAULT now() 발화). 명시 NULL 금지.
- **comp_price_id:** IDENTITY이므로 **INSERT 시 명시하지 말 것**(자동 채번). 명시하면 시퀀스 재동기(`setval`) 깨짐. (현 시퀀스 last_value=5123>MAX=4954라 비명시 INSERT는 안전.)
- **DRY-RUN 우선:** 기존 `apply.sh`(BEGIN…ROLLBACK 기본) 패턴 재사용 — 인간 승인 전 ROLLBACK 미리보기로 변경량·오류0·멱등 2회 검증.

### 미확정 → 컨펌 큐

| ID | 컨펌 사항 | 근거 |
|----|----------|------|
| **C-1** | round-19 적재 = "기존 6/1 세대 정정(ⓐ)" vs "신규 개정일 가격(ⓑ)"? | apply_ymd가 시계열 키 → 의미가 적재 전략을 가른다 |
| **C-2** | 엔진(미구현 evaluate_price)이 component_prices 단가행을 apply_ymd로 필터하나? `product_*`처럼 `_latest`를 적용할 계획인가? | 단가행은 현재 `_latest` 미적용 → 적용일 분기 시 중복 매칭 위험 |
| **C-3** | grade_discount_rates(현재 0행)는 round-19 범위 밖 확인 | 적재 대상 목록에 없으나 시계열 키 보유 — 향후 주의 |

---

## 부록: 실측 명령 출처(재현용)

- 시점성 컬럼: `information_schema.columns` WHERE table_name IN (가격·할인 8테이블) AND column_name ~* 'dt$|valid|ver|apply|...'
- 자연키 판정: `pg_indexes` WHERE indexdef ILIKE '%UNIQUE%' / `pg_constraint` contype IN ('p','u')
- 데이터 분포: `SELECT apply_ymd, COUNT(*) … GROUP BY apply_ymd` (각 테이블)
- 다중버전: `GROUP BY <자연키> HAVING COUNT(DISTINCT apply_ymd) > 1` → 0건
- 엔진 조회: `raw/webadmin/webadmin/catalog/price_views.py:139` `_latest()`
- 트리거/CHECK: `information_schema.triggers` / `pg_constraint` contype='c'
- 시퀀스 stale: `t_prc_component_prices_comp_price_id_seq.last_value=5123` vs `MAX(comp_price_id)=4954`
- 백업 권한: `current_user=postgres`, `rolsuper=true`, `has_schema_privilege('public','CREATE')=true`
