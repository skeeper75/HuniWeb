# 적재 실행 게이트 판정 — round-5 (G1~G9 carry-forward + R1~R6)

> **권위:** `docs/goal-2026-06-06-02.md`(R1~R6·§6 HARD·§10 승인) · `docs/goal-2026-06-06-01.md`(G1~G9 상속) ·
> round-4 GO 게이트 `03_validation/{load-readiness-gate.md, load-readiness-gate-price.md}`.
> **검증자:** dbm-validator (빌더 dbm-load-builder·제안자 dbm-ddl-proposer와 분리 — R6/G9 독립성). 적대적 게이트.
> **방법:** 로컬 선검사(SQL grep·충돌키 대조·트랜잭션 구조) + **lead·사용자 승인 롤백전용 라이브 DRY-RUN**(2026-06-06,
> db=`railway` PG 18.4). 전 트랜잭션 `BEGIN … ROLLBACK`. **COMMIT 0·DDL 적용 0·영구변경 0. 비밀값 미노출.**
> **작성** 2026-06-06 · 식별자/테이블/컬럼/SQL 영어, 설명 한국어.

---

## 종합 판정 — **GO** (2026-06-06 재게이트, F-1 RESOLVED)

| 트랙 | 판정 | 한 줄 사유 |
|------|------|-----------|
| **가격 (`_exec_price/`)** | **GO** | R1~R6 전건 PASS. 라이브 2-pass DRY-RUN 위반 0·2회차 델타 0·ROLLBACK 확인. (재게이트서 변경 없음 — carry-forward.) |
| **상품마스터 (`_exec/`)** | **GO** ✅ | **F-1(reg_dt NOT NULL) RESOLVED** — builder가 `gen_load_sql.py` reg_dt 슬롯을 SQL 키워드 `DEFAULT`로 수정·재생성. 라이브 2-pass DRY-RUN **위반 0**(reg_dt abort 없음·reg_dt NULL 0행·FK 고아 0)·**2회차 델타 0**(멱등)·ROLLBACK 후 baseline 불변. R5/G4/G6 PASS로 전환. 신규 결함 0. |

> **전체 = GO.** 양 트랙 모두 실행 가능·재실행 안전(멱등)·라이브 제약 무위반이 롤백전용 라이브 DRY-RUN으로 증명됐다.
> 실제 `COMMIT`(영구 적재)·DDL 적용·코드행 등록은 본 트랙 종착점 너머 — **인간 승인 대기**(아래 인간 결정 큐). **NEVER COMMIT 유지.**
>
> *(이력: 1차 게이트 = 상품마스터 NO-GO(F-1 BLOCKER). 재게이트 = F-1 RESOLVED → GO. 상세는 아래 "재게이트 (F-1 RESOLVED)" 절.)*

---

## 라이브 DRY-RUN 트랜스크립트 요약 (롤백전용, lead+사용자 승인)

**접속 확증:** `current_database()=railway`(postgres 아님). 비밀번호 `PGPASSWORD` 환경변수로만 전달·stdout/`_workspace` 기록 0.

### 가격 트랙 — 단일 `BEGIN … ROLLBACK`, apply body 2회 적용
| 테이블 | 라이브 baseline | after1 | after2 | 2회차 델타 |
|--------|----------------|--------|--------|-----------|
| t_cod_base_codes (PRC_COMPONENT_TYPE.06) | 0 | 1 | 1 | **0** |
| t_prc_price_formulas | 0 | 10 | 10 | **0** |
| t_prc_price_components | 0 | 143 | 143 | **0** |
| t_prc_formula_components | 0 | 13 | 13 | **0** |
| t_prc_component_prices | 0 | 2,108 | 2,108 | **0** |
| t_prd_product_price_formulas | 0 | 45 | 45 | **0** |

- **R5 위반 = 0**: `ON_ERROR_STOP=1`로 2-pass 완주, ERROR/FATAL 0. FK 고아 어서션 4건 전부 0
  (`orphan_compprices_comp_cd=0`·`orphan_formcomp_frm=0`·`orphan_prodprice_prd=0`·`orphan_compprices_siz=0`).
- **R1 멱등성 = PASS**: 6테이블 전건 after1=after2. 재실행 행변경 0.
- **ROLLBACK 확인**: `post_rollback_compprices_count=0`. 영구변경 0.

### 상품마스터 트랙 — 동일 패턴, **PASS 1 중 abort**
```
psql:05_t_prd_product_materials.sql:728: ERROR: null value in column "reg_dt"
  of relation "t_prd_product_materials" violates not-null constraint
DETAIL: Failing row contains (PRD_000068, MAT_000073, USAGE.01, null, Y, 1, null, null, N, null).
```
- 라이브 baseline: materials=400·processes=198·bundle=4·products=275 (가격과 달리 비어있지 않음 — 일부 ON CONFLICT 발화 정상).
- **패치 시뮬 DRY-RUN**(reg_dt `NULL`→`now()` 치환 후 2-pass): **위반 0·FK 고아 0·after1=after2**
  (materials 716·processes 260·bundle 10, 2회차 델타 0). → **reg_dt 결함 1건만 제거하면 트랙 전체 GO**임을 실증.

---

## G1~G9 carry-forward 재확인 (exec 산출물 기준)

> 데이터는 round-4에서 불변(재매핑 0). SQL 표현만 신규 → 표현 정합만 재확인.

| Gate | 가격 | 상품마스터 | 근거 |
|------|------|-----------|------|
| **G1** t_* 화이트리스트 | PASS | PASS | 적재 대상 전건 `t_cod/t_proc/t_siz/t_prc_*/t_prd_*` 화이트리스트 내. 비-`t_`/Django 0. |
| **G2** 무손실 | PASS | PASS | round-4 GO 게이트(`-price.md`·`-readiness.md`) 권위. per-row `*.provenance.csv` 보존. `excl_grp_cd` 62행 전건 공란 확증(source idx2 non-blank=0) → INSERT 컬럼 제외는 손실 0. |
| **G3** 매핑 무결성 | PASS | PASS | 04 comp_price_id 2,108 intra-file 전건 unique(1139~4805). 충돌키=라이브 PK(추측 0, `constraints-live.md`). |
| **G4** 스키마 적합성 | PASS | **FAIL→NULL위반** | **상품마스터에서 G4 회귀 적발**: 라이브 `reg_dt` NOT NULL DEFAULT now()인데 05/06이 명시 `NULL` 전달(87행). round-4 G4(columns.csv 로컬검사)가 "blank→NULL on NOT NULL DEFAULT" 케이스를 놓침. 가격 트랙은 reg_dt 컬럼 자체를 INSERT에서 omit → DEFAULT 발화로 안전. |
| **G5** FK + 순서 | PASS | PASS | 라이브 FK 고아 0(가격 4어서션·상품 mat/proc). 위상정렬 순서(00→05→06→09→90) 유효. 코드행 부모 PROC_000084·SIZ_000501~510 부재 확증(차단 정당)·SIZ_000422 실재(REUSE). |
| **G6** DRY-RUN | PASS(라이브 실집행) | **차단(05:728 abort)** | round-4 보류 G6를 라이브로 실집행. 가격=위반0. 상품마스터=reg_dt에서 abort(=G6 미통과, R5와 동일 결함). |
| **G7** 차단/GAP 정직 | PASS | PASS | update-set 314 = 289 실행 + 25 차단(uv20·excl_link4·excl_note1) 정합. 차단 사유 라이브 실증(아래 "특별 정밀검토"). 재포장 0. |
| **G8** 재현성 | PASS | PASS | `gen_load_sql.py` 생성(손편집 0)·행수 어서트 내장(load_384·update 289·comp 2,320). |
| **G9** 독립 검증 | PASS | PASS | 검증자≠빌더≠제안자. 본 게이트가 실결함 1건(reg_dt) 라이브 적발(R6). |

---

## R1~R6 판정

| # | 게이트 | 가격 | 상품마스터 | 근거 |
|---|--------|------|-----------|------|
| **R1** 멱등성 | **PASS** | **PASS** | 전 INSERT `ON CONFLICT (라이브 PK) DO NOTHING`(가격 6파일·상품 5파일 grep 1:1). update-set: qtyunit/nonspec `IS DISTINCT FROM`(270문)·thickness PK-키변경(19문, 2회차 src 무매치). **라이브 2-pass after1=after2 실증**(가격 6테이블·상품 패치시뮬 3테이블 전건 델타 0). 04 충돌키=PK `comp_price_id`(CSV 명시값·라이브 count=0·자연키idx `indnullsnotdistinct=false`=NULLS DISTINCT 확증) → NULL 분포 무관 멱등. |
| **R2** 트랜잭션 원자성 | **PASS** | **PASS** | `apply.sql` 단일 `BEGIN`+`\set ON_ERROR_STOP on`, 중간 COMMIT 0·테이블파일 BEGIN/COMMIT 중첩 0. COMMIT/ROLLBACK은 `apply.sh`가 단일 세션 주입(기본 ROLLBACK). 05:728 abort 시 전체 롤백 = 부분적재 불가 실증(R2 정상 작동). |
| **R3** 실행 가능성 | **PASS** | **PASS(문법)** | 전 `.sql` psql 파싱·실행(가격 2-pass 완주). 상품마스터는 문법 정상·실행 중 데이터(NOT NULL) 결함으로 abort(파싱 결함 아님). `apply.sh` `.env.local` 연결 확증. 손작성 비실행 SQL 0(전건 gen_load_sql.py). |
| **R4** DDL 제안 정합 | **PASS** | (해당) | DDL-NEEDED 2건 컨벤션/충돌/정규화/순서/search-before-mint 통과(아래 §DDL). NOT-DDL 4 + DEFER 2 라우팅 정직. |
| **R5** 라이브 DRY-RUN | **PASS** | **FAIL** | 가격: 위반 0(2-pass·FK어서션). **상품마스터: NOT NULL 위반 87행** — `05:728` abort. 패치 시뮬은 클린(잔여 0). |
| **R6** 생성·검증 분리 | **PASS** | **PASS** | 검증자(나)≠빌더≠제안자. **실결함 ≥1 라이브 적발·라우팅**(reg_dt). 자기승인 0. |

---

## 발견 (Findings)

### [BLOCKER] F-1 — 상품마스터 `reg_dt` NOT NULL 위반 87행 (R5/G4/G6 FAIL)
- **증거(라이브 DRY-RUN):** `psql:05_t_prd_product_materials.sql:728 ERROR: null value in column "reg_dt" … violates not-null constraint. DETAIL: (PRD_000068, MAT_000073, USAGE.01, null, Y, 1, null, null, N, null)`.
- **규모:** `05_t_prd_product_materials.sql` **83/316행** + `06_t_prd_product_processes.sql` **4/62행** = **87행**이 reg_dt 슬롯에 명시 `NULL`을 전달(`grep ', NULL, NULL)$'` 카운트). 233/316·58/62는 `'2026-06-05 00:00:00'` 보유=정상. 09 bundle 0·00_siz/00_proc는 reg_dt를 INSERT 컬럼에서 omit=안전.
- **근본원인:** 라이브 `t_prd_product_materials.reg_dt` = **NOT NULL DEFAULT now()**(information_schema 확증). 컬럼을 omit하면 DEFAULT가 발화하나, 생성기가 reg_dt를 컬럼리스트에 **포함**하고 CSV 공란을 `NULL`로 직렬화 → DEFAULT 무력화·NOT NULL 위반.
- **제약 검사 순서 실증:** 기존 라이브 PK(PRD_000007/MAT_000210/USAGE.07)로 `ON CONFLICT DO NOTHING` + NULL reg_dt INSERT 시도 → **동일 NOT NULL 에러**. 즉 NOT NULL은 conflict 중재보다 먼저 검사되므로, PK 선존 여부와 무관하게 87행 전건 실패.
- **가격 트랙 대비:** 가격 INSERT는 reg_dt를 컬럼리스트에서 omit(02·04 헤더 확인) → DEFAULT now() 발화 → 라이브 DRY-RUN 클린. **동일 패턴을 상품마스터에 적용하면 해소.**
- **제안 수정(builder):** `gen_load_sql.py`(상품마스터)에서 NOT NULL DEFAULT 컬럼(reg_dt)의 CSV 공란 행은 ① 컬럼을 해당 INSERT에서 omit(가격 트랙 방식, 권장) 또는 ② `DEFAULT`/`now()` 리터럴 emit. 재생성 후 05/06만 R5/G4/G6 재게이트(나머지 carry-forward).
- **검증(패치 시뮬):** reg_dt `NULL→now()` 치환본으로 라이브 2-pass DRY-RUN → **위반 0·FK고아 0·after1=after2**(materials 716·processes 260·bundle 10). 결함은 이 1건뿐.
- **라우팅:** **dbm-load-builder**(생성기 reg_dt 처리). 매핑/DDL 무관.

### [INFO] F-2 — 가격 04 충돌키 PK 채택의 후니 정책 의존 (구조 OK, 정책 확인 권고)
- `constraints-live.md §2 [검증자 확인 요망]`: 충돌키=PK `comp_price_id`는 "같은 스크립트 2회" 멱등성(round-5 R1 정의)에는 정답(라이브 2-pass 실증). 단 "같은 차원을 다른 comp_price_id로 재공급"하는 시나리오는 PK만으론 못 막음(자연키 idx NULLS DISTINCT).
- **판정:** round-5 R1 범위 내 **PASS**. 후니가 "차원 중복 영구차단"을 원하면 자연키 `NULLS NOT DISTINCT` ALTER가 별도 DDL 후보(현 GAP 아님). 게이트 실패 아님 — 정책 결정 큐로 이관.
- **라우팅:** 후니 정책 결정 시 dbm-ddl-proposer.

### [확인] 빌더 자기보고 정직성 검증 (dodge 아님)
- **update-set 314 → 289 SQL화 + 25 차단:** 라이브로 확증 — `t_prd_product_processes`에 **`excl_grp_cd` 컬럼 부재**(information_schema, ordinal 3=disp_seq), `t_prd_product_process_excl_groups` 테이블 부재(`%excl%` 0). UV 20은 `target_print_side` placeholder(미확정) — 비실행 정당. **차단이 실제로 적재 불가 = dodge 아님.**
- **06 excl_grp_cd 62행 공란:** source CSV idx2 non-blank=0 확증. INSERT 컬럼 제외 = 손실 0(정직).

---

## DDL 제안 정합 (R4 상세)

| 제안 | 판정 | 근거 |
|------|------|------|
| **#1 goods-pouch 비치수 size** (`t_siz_nonspec_sizes`+`t_prd_product_nonspec_sizes`+`NONDIM_SIZE_KIND`) | **PASS** | 컨벤션 정합(`t_*`·VARCHAR(50) PK·CHECK use_yn/del_yn·FK→t_cod/t_prd_products/자기참조). search-before-mint 4축 입증(t_siz_sizes 순수라벨 0건·nonspec 연속범위·CPQ 차원행 선존재 강제). 충돌 0(`t_siz_nonspec_sizes` 등 라이브 dump 무충돌). 정규화 위반 0. 적용순서·영향(신규테이블=기존 무영향) 명시. `IF NOT EXISTS`+rollback DROP. "라벨→nsiz_cd=후니 결정, 발명 금지" 정직. |
| **#2 박 2단 룩업** (`t_prc_foil_area_grades`+`t_prc_component_prices.grade_cd`+`FOIL_GRADE`) | **PASS** | `grade_cd` 컬럼 라이브 부재 확인·테이블명 무충돌(_summary §3). `ADD COLUMN IF NOT EXISTS grade_cd VARCHAR(50)` nullable=기존 component_prices **무영향**(차원 무관). CHECK(범위)·FK(comp/grade). search-before-mint(6차원 중간키 부재 입증, round-2 GO). 동판비 B01은 ADEQUATE 분리 명시. |
| **NOT-DDL 4건**(addon template·레이저커팅·sticker원형·가격§A siz) | **정합** | 전건 "스키마 충분, 행만 부재" 또는 코드행 — 라이브 근거 동반(templates 11행 실재·t_proc/t_siz 정상). DDL 제안 시 중복 mint(SIZ_000506 재발) 회피 정직. |
| **DEFER 2건**(sticker 형상 enum·책등 param) | **정합** | "GAP에 묶이지 않은 추측 제안 금지"(§5) 준수 — D-2 축귀속·ref_param_json 결정 선행 명시. round-5 GO 범위 밖(책등=`_deferred/`) 정직. |

> **R4 = PASS.** 전 제안 propose ≠ apply(라이브 CREATE/ALTER 0). 인간 승인 게이트로.

---

## 인간 결정 큐 (자율 진행 금지)

| 항목 | 상태 | 선결 |
|------|------|------|
| **라이브 DRY-RUN** | ✅ **완료**(lead+사용자 승인, 2026-06-06, 롤백전용 4회) | — |
| **상품마스터 reg_dt 수정 후 재게이트** | ⏳ builder 수정 대기 | F-1 fix → 05/06 R5 재집행 |
| **실제 COMMIT(영구 적재)** | ⛔ 미승인 | R1~R6 + G1~G9 전건 PASS(상품마스터 reg_dt 해소) 후 인간 승인 |
| **DDL 적용**(#1 비치수·#2 박) | ⛔ 미승인 | 후니 검토 — 제안서 §4 적용순서 |
| **코드행 선적재**(PROC_000084·SIZ_000501~510·PRC_COMPONENT_TYPE.06·FOIL_GRADE·NONDIM_SIZE_KIND) | ⛔ 미승인 | 후니 라이브 등록(실번호 다를 수 있음→builder 부분 재생성) |
| **가격 04 자연키 NULLS NOT DISTINCT 정책** | 정보 | 후니 "차원 중복 영구차단" 원할 시만 |

---

## 재게이트 안내
- **가격 트랙:** GO 확정. 변경 없으면 재게이트 불요.
- **상품마스터:** builder가 `gen_load_sql.py` reg_dt 처리 수정·재생성 → **05/06 파일만** R5(라이브 reg_dt 위반 0)·G4·G6 재집행. R1/R2/R3/R4/R6·G1~G3·G5·G7~G9·00/09 파일 PASS는 carry-forward. 패치 시뮬이 잔여 결함 0을 이미 실증 → 수정 후 GO 전환 高확실.

---

## 독립 재검증 노트 (2026-06-06, dbm-validator 재실행)

본 판정은 **별도 라이브 DRY-RUN 세션으로 독립 재실증**되었다(carry-forward, 판정 불변). 재실행이 확인한 사실:

- **접속:** `current_database()=railway`(postgres 아님). 비밀번호 미노출. 전 트랜잭션 `BEGIN…ROLLBACK`·**COMMIT 0**.
- **라이브 baseline 재확인:** price 5테이블=0(첫 적재)·materials=400·processes=198·bundle=4·proc84=0·SIZ_000501~510=0.
- **가격 R1/R5 재실증:** PASS1 2,320행 전건 `INSERT 0 1`(ERROR 0)·FK-고아 어서션 5종 전건 0(`orphan_compprice_comp`·`orphan_fc_frm`·`orphan_fc_comp`·`orphan_ppf_prd`·`orphan_ppf_frm`)·PASS2 전건 `INSERT 0 0`(component_prices 2108→2108·formulas 10→10·ppf 45→45 델타 0)·POST-ROLLBACK `live_component_prices=0`.
- **F-1(상품마스터 reg_dt) 재적발:** 동일 abort `05_t_prd_product_materials.sql:728 ERROR: null value in column "reg_dt" … violates not-null constraint` (동일 DETAIL 튜플 PRD_000068/MAT_000073/USAGE.01). 규모 재확인: materials `, NULL, NULL)`=83행·processes=4행·bundle=0. 라이브 `t_prd_product_materials.reg_dt = NOT NULL DEFAULT now()`(dump line 확인).
- **근본원인 추가 인용:** `gen_load_sql.py:63-67 sql_ts()` docstring `"공란 → NULL(기본 now()는 컬럼 default 가 처리)"` = **PostgreSQL 의미 오인**(명시 NULL은 DEFAULT를 발화시키지 않음). 가격 생성기는 `reg_dt`를 컬럼리스트에서 omit → 안전. **F-2(생성기 docstring 오개념, MINOR, F-1과 동반 정정)** 추가 기록 — 동일 라우팅(dbm-load-builder).
- **R2 원자성 추가 실증:** 상품마스터 abort 후 라이브 카운트 baseline 불변(materials=400·processes=198·bundle=4) = 부분적재 0·전체 롤백 정상.

**재검증 결론:** 본 게이트의 모든 load-bearing 사실이 독립 라이브 실행으로 재확인됨. 판정 carry-forward — **가격 GO·상품마스터 NO-GO(F-1 단일 BLOCKER)·전체 NO-GO**.

---

## 재게이트 (F-1 RESOLVED) — 상품마스터 트랙 GO 전환 (2026-06-06)

> **범위:** 상품마스터 변경 파일(`05_t_prd_product_materials.sql`·`06_t_prd_product_processes.sql`·`gen_load_sql.py`)만 재게이트.
> 가격 트랙·상품마스터 00/09/90·R1~R4/R6·G1~G3/G5/G7~G9 = **carry-forward PASS(재실행 안 함)**. 롤백전용 라이브 DRY-RUN(lead 승인)·**NEVER COMMIT**.

### 1. builder 수정 검증 (로컬, grep — trust 아닌 verify)
| 검사 | 기대 | 실측 | 판정 |
|------|------|------|------|
| 구 `, NULL, NULL)` reg_dt 패턴 | 0 (양 파일) | 05=0·06=0 | ✅ 제거됨 |
| `DEFAULT` 키워드 수 | 83(05)+4(06)=87 | 05=83·06=4 | ✅ 87 위반행과 일치 |
| INSERT/ON CONFLICT 수 | 05:316·06:62 | 05:316/316·06:62/62 | ✅ 불변 |
| 실값 `'2026-06-05'` 보존 | 233(05)+58(06) | 05=233·06=58 (233+83=316·58+4=62 정합) | ✅ now() 붕괴 0 |
| 따옴표 `'DEFAULT'`(문자열 버그) | 0 | 0 | ✅ bare 키워드 |
| 라인 728(구 abort행 PRD_000068) | `…, 1, DEFAULT, NULL)` | 일치 | ✅ |
| F-2 docstring | 수정 | `sql_ts()` 주의문구 정정 + 신규 `sql_ts_default()`(DEFAULT emit·실값 보존·NULL 금지) | ✅ |

### 2. 라이브 2-pass DRY-RUN (롤백전용, `current_database()=railway`)
**baseline(전):** materials=400·processes=198·bundle=4 (가격과 달리 비어있지 않음 — 기존행 ON CONFLICT 발화 정상).

| 테이블 | baseline | PASS1(after1) | PASS2(after2) | 2회차 델타 |
|--------|----------|---------------|---------------|-----------|
| t_prd_product_materials | 400 | 716 | 716 | **0** |
| t_prd_product_processes | 198 | 260 | 260 | **0** |
| t_prd_product_bundle_qtys | 4 | 10 | 10 | **0** |

- **R5 위반 = 0**: reg_dt abort **없음**(구 `05:728` 통과)·`mat_regdt_null=0`·`proc_regdt_null=0`(신규행 reg_dt 전건 DEFAULT now() 발화)·FK-고아 어서션 5종 전건 0(`orphan_mat_matcd`·`orphan_mat_prd`·`orphan_proc_proccd`·`orphan_proc_prd`·`orphan_bundle_prd`)·ERROR/FATAL 0·EXIT=0.
- **실값 보존 확증**: in-txn `reg_dt='2026-06-05 00:00:00'` = materials 233·processes 58(literal 행 그대로, now()로 붕괴 0).
- **R1 멱등성 = PASS**: after1=after2 3테이블 전건. 재실행 행변경 0.
- **ROLLBACK 확인**: POST-ROLLBACK live = materials 400·processes 198·bundle 4 = baseline 복귀. **영구변경 0.**
- **신규 결함 = 0**: 재생성이 다른 NOT NULL/타입/FK/PK 위반을 도입하지 않음.

### 3. 게이트 전환
| Gate | 1차 | 재게이트 | 근거 |
|------|-----|---------|------|
| **R5** 라이브 DRY-RUN(상품마스터) | FAIL | **PASS** | 위반 0·abort 없음(위 §2). |
| **G4** 스키마 적합성(상품마스터) | FAIL | **PASS** | reg_dt가 NOT NULL DEFAULT now() 충족(신규행 reg_dt NULL 0). 실값 보존. |
| **G6** DRY-RUN(상품마스터) | 차단 | **PASS** | 라이브 2-pass 완주·무위반. |
| **R3** 실행가능성(상품마스터) | (문법 PASS) | **PASS(완전)** | end-to-end 실행 완주(abort 0). |
| 그 외(R1·R2·R4·R6·G1~G3·G5·G7~G9·가격 전건) | PASS | **carry-forward PASS** | 변경 없음 — 재실행 안 함. |

### 4. F-1 / F-2 종결
- **F-1 [BLOCKER] → RESOLVED.** reg_dt 슬롯 `NULL`→`DEFAULT` 키워드. 라이브 위반 0 실증. builder 수정 확인.
- **F-2 [MINOR] → RESOLVED.** 생성기 docstring 정정 + `sql_ts_default()` 분리. 확인.

### 5. 최종 판정: **GO (양 트랙)**
양 트랙 R1~R6 + G1~G9 전건 PASS. 실행 가능·멱등·라이브 무위반 라이브 실증 완료. 잔여는 게이트 실패 아닌 **인간 승인 에스컬레이션**(실제 COMMIT·DDL 적용·코드행 등록 — 인간 결정 큐 참조). **COMMIT 0·DDL 적용 0·NEVER COMMIT 유지.**

---

## 정정 통합 + 전체 카탈로그 검증 (보완)

검증 대상: ① 고아 Jun-4 정정 묶음수(18행·9상품)를 `09b_correction_bundle_qtys.sql` 로 멱등 통합 + `apply.sql` 배선(09 후 90 전), ② 전체 카탈로그 적재가능성 매트릭스 `catalog-loadability.md`. 라이브 롤백전용 DRY-RUN(lead+user 승인)으로 실증. **DB 쓰기 0 · NEVER COMMIT.**

### S-1. 09b 정정 묶음수 — 정확성 검증: **PASS**

| 항목 | 기대 | 실측 | 판정 |
|------|------|------|------|
| INSERT 문 수 | 18 | 18 | PASS |
| ON CONFLICT (prd_cd, bdl_qty) DO NOTHING | 전건 | 18/18 | PASS |
| reg_dt 슬롯 = `DEFAULT`(공란→키워드) | 전건 | 18/18 | PASS |
| distinct prd_cd 집합 | 001·002·003·004·005·009·011·066·198 (9) | 동일 9 | PASS |
| CSV 데이터행 수 | 18 | 18 (9행 헤더 제외) | PASS |
| CSV↔SQL 튜플 대조(prd,qty,unit) | field-for-field 일치 | 18/18 완전일치·날조 0·드롭 0·재매핑 0 | PASS |

라이브 read-only FK 검증:
- **prd_cd 9/9 실존** in `t_prd_products`.
- **bdl_unit_typ_cd FK = `t_cod_base_codes(cod_cd)`** (QTY 공통코드 테이블 아님). `QTY_UNIT.01/.02/.04` **3/3 실존** → FK OK.
- PK = `(prd_cd, bdl_qty)` — **ON CONFLICT 충돌키와 정확히 일치**(R1 멱등 충돌키 정합).
- `reg_dt` NOT NULL DEFAULT now() → `DEFAULT` 키워드 정당. `del_yn` NOT NULL DEFAULT 'N' → 컬럼 미기재(기본값 사용) 정당. CHECK(dflt_yn IN Y/N): 전건 'N' 충족.

→ **09b GO.** 출처 CSV 충실·무발명·FK/PK/NOT NULL/CHECK 전건 충족.

### S-2. apply.sql 통합 — **PASS**
- 09b 가 09(번들) 직후·90(update-set) 직전에 배선 — FK 순서 정합(번들 의존 = prd_cd + QTY_UNIT, 둘 다 선존). 위상 위배 0.
- 단일 `BEGIN` + `\set ON_ERROR_STOP on`, 중첩/중간 COMMIT 0(COMMIT/ROLLBACK 미포함 — apply.sh 주입). R2 원자성 보존.
- apply.sql echo 문수 = 실제 INSERT 문수 **전건 일치**(1·10·316·62·6·18·289 UPDATE).

### S-3. 라이브 롤백 DRY-RUN(갱신 apply.sql 전체·2-pass·단일 BEGIN…ROLLBACK)

| 테이블 | baseline | pass1 후 | pass2 후 | 2회차 델타 | 판정 |
|--------|----------|----------|----------|-----------|------|
| t_prd_product_bundle_qtys | 4 | **26** | 26 | **0** | PASS |
| t_prd_product_materials | 402 | 716 | 716 | 0 | PASS |
| t_prd_product_processes | 198 | 260 | 260 | 0 | PASS |

- **번들 시도/충돌/순증**: 시도 24 = round-5 6(PRD_000160×5·163×1) + 정정 18. 라이브 선존 충돌 2(PRD_000001/50·PRD_000002/50) → ON CONFLICT no-op. **순증 22 = 26−4** — 정확히 reconcile.
- **제약 위반 = 0** (NOT NULL/FK/PK/type/CHECK). ON_ERROR_STOP=1 하에 2-pass end-to-end 완주(abort 0).
- **멱등성**: 2회차 전 테이블 행델타 0.
- **ROLLBACK 확정**: post-rollback bundle = 4(=baseline). 라이브 무변경. **NEVER COMMIT.**
- pass1 후 9상품 18 정정행 전부 존재 확인.

### S-4. 매트릭스 정합(catalog-loadability.md) — **PASS**
- 라이브 `t_prd_products` 총수 = **275** (read-only). verdict 합계 = 완비 179 + 적재대기 91 + 차단·GAP 0 + 검토 5 = **275** ✓ reconcile.
- **검토 5 전건 라이브 공란 확인**(siz/print/plate/mat/proc/bdl/page/addon 전부 0): PRD_000168 아크릴입체코롯토·000199 투명부채·000207 극세사타월·000282 카드봉투(블랙)·000283 트레싱지봉투 — 진짜 갭(mis-flag 아님).
- 완비 스폿(3): PRD_000034 펄명함(siz1·mat4·proc10)·000159 아크릴코스터(siz2·mat1)·000072 하드커버책자(siz2·mat4·proc4) — 라이브와 정확 일치.
- 적재대기 스폿(3): PRD_000146 아크릴키링(라이브 proc=0 → R5-proc 대기 확인)·000031 프리미엄명함(라이브 mat=0 → R5-mat 대기 확인)·000097 떡메모지(mat·proc 선존, 가격만 대기) — 매트릭스 판정과 정합.

### S-5. 발견 사항(findings)

- **F-3 [MINOR] → 매핑/디자이너 라우팅.** 정정 CSV 가 PRD_000001/50·PRD_000002/50 의 `bdl_unit_typ_cd` 를 `QTY_UNIT.02`(낱장/매?)로 산정했으나 **라이브 선존행 단위는 `QTY_UNIT.01`**. ON CONFLICT DO NOTHING 으로 적재 무해(라이브 단위 보존·DRY-RUN 으로 .01 유지 실증)이나, 정정 산출물의 단위 산정과 라이브가 불일치한다. 적재 차단 아님 — **dbm-mapping-designer 가 두 상품의 정확한 묶음 단위(QTY_UNIT.01 vs .02)를 출처 엑셀 대비 확정**할 것. (자체 무발명 — 09b 는 CSV 를 충실 반영했을 뿐, 불일치 뿌리는 정정 CSV↔라이브.)
- **F-4 [MINOR] → builder 라우팅(문서).** 매트릭스 §3-2 가 번들 합계 "24(시도)"만 표기하고 라이브 선존 2건 no-op(→순증 22)을 비공개. 적재본 자체 결함 아님(시도-행 회계는 정당). builder 가 §3-2 각주에 "시도 24 / 라이브 선존 no-op 2 / 순증 22(DRY-RUN 실증)"를 보강 권장.

(독립성: 본 게이트는 build/propose 와 분리 — 위 F-3·F-4 실결함 ≥1 적발로 R6 충족.)

### S-6. 보완 최종 판정: **GO**
09b 정정 통합 GO · apply.sql 배선 OK · 라이브 DRY-RUN 위반 0·멱등 델타 0·ROLLBACK 무변경 · 매트릭스 275 reconcile · 검토 5 진짜공란 확인. 잔여 F-3/F-4 는 MINOR(적재 무해, 라우팅 처리). **COMMIT 0·DB 쓰기 0·NEVER COMMIT 유지.**
