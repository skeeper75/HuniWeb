# 봉투제작(ENV) component_prices 적재 실행본

> **트랙**: round-5 적재 실행본 — 가격 트랙(봉투제작 ENV). round-4에서 GO 판정된 ENV 적재본(40행)을
> 실 적재 가능한 멱등 실행 SQL + 로더로 완성한 마이그레이션. **가장 단순한 GO 트랙**(가격행 ONLY).
> **권위(GO 입력)**: 설계 `02_mapping/price-envelope-mapping.md` · 적재 CSV `02_mapping/load_price/t_prc_component_prices_ENV.csv`(40행)
> · 독립 게이트 `03_validation/price-foil-envelope-gate.md` **TARGET 2 = GO**(전건 정합).
> **HARD**: DB 쓰기·DDL·COMMIT 0(인간 승인 전). 롤백전용 DRY-RUN까지만. 비밀번호 미출력.

---

## 1. 무엇을 적재하는가

| 산출 | 대상 테이블 | 행수 | 멱등 충돌키 |
|------|------------|:----:|------------|
| **봉투제작 가격** | `t_prc_component_prices` | **40** (4봉투종류×2소재×5수량밴드) | `ON CONFLICT (comp_price_id)` |

- **봉투 4종(작업사이즈)** → 라이브 siz **EXACT 재사용**(신규 등록 0, hidden mint 0):
  - 티켓봉투(225×193) → `SIZ_000191`
  - 소봉투(238×262) → `SIZ_000192`
  - 자켓봉투(262×238) → `SIZ_000193`
  - 대봉투(510×387) → `SIZ_000194`
- **소재 2종**: 모조 120g = `MAT_000159` · 레자크체크백색 110g(=레자크줄무늬 동일단가, 대표 mat) = `MAT_000168`.
- **수량밴드 5**: min_qty 1000 / 2000 / 3000 / 4000 / 5000.
- **comp_price_id 1713~1752**: source CSV surrogate PK 명시(라이브 미사용 확증). note 에 `[siz: ENV_종류→SIZ_xxx]` 접두 보존.
- comp_cd 전건 `COMP_ENV_MAKING`(완제품비 `.06`). clr/coat/bdl 전건 공란(NULL).

## 2. 왜 — 가장 단순한 GO 트랙 (신규 INSERT만, 마스터 변경 0)

게이트 TARGET 2가 라이브 read-only 로 전건 확인:

| 단계 | 행수 | 근거(게이트) |
|------|:----:|------|
| **siz 등록** | **0** | 봉투 4종 작업사이즈 → `SIZ_000191~194` work 치수 EXACT 매칭(impos=N·use=Y·del=N). mint 0. |
| **바인딩 INSERT** | **0** | `PRD_000050`(봉투제작) → `PRF_ENV_MAKING` 라이브 선존재(apply 2026-06-01). 신규 바인딩 불요. |
| **코드행 INSERT** | **0** | `.06`(완제품비)·`FRM_TYPE.02`(단순형)·`COMP_ENV_MAKING` 전부 라이브 선존재. |
| **component_prices** | **40** | `COMP_ENV_MAKING` component_prices 라이브 **0행** → 본 40행이 채울 **빈 슬롯**. |

→ GP 원형(siz 10 등록+가격 100+link 11)·면적매트릭스(siz 211 등록)·고정가(DELETE 재바인딩)와 달리
**ENV는 마스터 데이터 변경 0**. 후니 master-data 등록 결정·코드행 등록 결정 **없음**. **남은 인간 승인 = COMMIT 단 하나.**

## 3. placeholder → 실 siz_cd 치환 (게이트 EXACT 재사용표 verbatim)

생성기(`gen_load_sql.py`)는 source CSV의 `siz_cd`(이미 실값 `SIZ_000191~194`)를 verbatim 으로 쓰고,
placeholder 계보(`SIZ_PENDING_ENV_종류`)를 provenance·SQL 주석에 역추적 보존한다(발명 0):

| placeholder | 봉투 | 작업사이즈(좌표) | 실 siz_cd | 라이브 work 치수 | 판정(게이트) |
|-------------|------|-----------------|-----------|------------------|--------------|
| `SIZ_PENDING_ENV_TICKET` | 티켓봉투 | 225×193 | `SIZ_000191` | 225.00×193.00 | EXACT |
| `SIZ_PENDING_ENV_SMALL`  | 소봉투   | 238×262 | `SIZ_000192` | 238.00×262.00 | EXACT |
| `SIZ_PENDING_ENV_JACKET` | 자켓봉투 | 262×238 | `SIZ_000193` | 262.00×238.00 | EXACT |
| `SIZ_PENDING_ENV_LARGE`  | 대봉투   | 510×387 | `SIZ_000194` | 510.00×387.00 | EXACT |

- **자켓(192) ≠ 소봉투(193) reversal 보존**: 라이브가 이미 `SIZ_000192`(238×262)·`SIZ_000193`(262×238)을
  distinct 보유 → 봉투종류 정체성(소≠자켓) 보존. collapse 안 함(박 REVERSED 수렴과 대조적·정당, 게이트 FLAG-A PASS).

## 4. 멱등성 설계 (R1)

- **전 INSERT `ON CONFLICT (comp_price_id) DO NOTHING`** — 충돌키 = 라이브 PK(단일컬럼 `comp_price_id`,
  게이트 확인). 자연키 충돌·중복 없음. **2회 적용 시 2회차 행변경 0**(라이브 DRY-RUN 2-pass 검증 대상).
- `migrate.sql` 끝의 멱등 카운트 어서션: 본 적재 comp_price_id 라이브 선존재 수 = 1회차 0 / 2회차 40 기대.
- **bare INSERT 없음**, 충돌키 추측 없음(라이브 PK에서 읽음), 중간 COMMIT 없음.

## 5. 원자성 설계 (R2)

- `migrate.sql` 단일 `BEGIN…COMMIT`(`\set ON_ERROR_STOP on`). 임의 문 실패 → 전체 abort/롤백.
- `01_component_prices.sql`에 `BEGIN/COMMIT` 미포함(중첩 금지). 로더(`apply.sh`)가 DRY-RUN 시 끝 `COMMIT;`→`ROLLBACK;` 치환.
- 부분 커밋 경로 없음.

## 6. FK 위상순 (단일 단계 — 부모 전건 선존재)

```
(부모 전건 라이브 선존재 — 등록 단계 없음)
  COMP_ENV_MAKING (t_prc_price_components)  ─┐
  SIZ_000191~194  (t_siz_sizes)             ─┼─→ 01 component_prices (40)
  MAT_000159/168  (t_mat_materials)         ─┘
```
- `migrate.sql` guard0가 적재 **전** siz 4종 라이브 존재(EXACT 재사용 전제) 검증 — `<4`면 STOP(발명 금지).
- 적재 **후** 어서션 3종: siz FK 고아 0 · comp_cd 존재 1 · mat FK 고아 0. 위반 시 `RAISE EXCEPTION`→롤백.

## 7. reg_dt NOT NULL DEFAULT 처리 (round-5 교훈 준수)

- source CSV에 `reg_dt` 컬럼 자체가 없음 → INSERT 컬럼 목록에서 **생략** → DB `DEFAULT now()` 발화.
  committed `_exec_price/04` 패턴과 동일. (명시 NULL 금지 — round-5 라이브 DRY-RUN이 적발한 함정.)

## 8. 안전 절차 (재실행 안전·롤백전용)

```
# 0) (권장) 적재 전 백업 스냅샷 — 읽기전용
./backup.sh
#    → backup_env_component_prices_before.csv (COMP_ENV_MAKING 적재 전 = 0행 기대, 빈 슬롯 입증 = undo 권위)
#      backup_env_id_collisions.csv           (0행=정상, comp_price_id 1713~1752 라이브 부재 확증)
#      backup_env_reuse_siz.csv               (재사용 siz 191~194 선존재 스냅샷)

# 1) DRY-RUN (기본) — migrate.sql 실행 후 강제 ROLLBACK. DB 무변경.
./apply.sh
#    → [guard0] ENV 작업사이즈 siz(191~194) 라이브 존재(4=PASS, EXACT 재사용·mint 0): 4   ← 확인
#      [assert] ENV 가격 40행 FK 고아(siz 미해소, 0=PASS): 0                              ← 확인
#      [assert] comp_cd COMP_ENV_MAKING 라이브 존재(1=PASS): 1                            ← 확인
#      [assert] ENV 가격 40행 FK 고아(mat 미해소, 0=PASS): 0                              ← 확인
#      [assert] 본 적재 comp_price_id 라이브 선존재 수(1회차=0 기대): 0                    ← 확인

# 2) 실제 적재 (인간 승인 시에만 — 본 트랙 남은 유일 승인)
./apply.sh --commit          # 40 ENV 봉투 단가 COMMIT (siz 등록·바인딩·코드행 없음)

# 3) 되돌리기 (필요 시)
./undo.sh                    # DRY-RUN (롤백)
./undo.sh --commit           # comp_price_id IN(1713..1752) DELETE — siz/comp/mat 마스터는 보존(재사용분)
```

- `migrate.sql`은 단일 `BEGIN…COMMIT`(원자성). `apply.sh` DRY-RUN이 마지막 `COMMIT;`→`ROLLBACK;` 치환.
- 모든 INSERT는 `ON CONFLICT … DO NOTHING`(멱등) — 2회 적용 시 2회차 행변경 0 기대(라이브 DRY-RUN으로 검증 대상).
- 자격증명은 `.env.local`(`RAILWAY_DB_*`)에서만. 비밀번호는 어떤 스크립트도 stdout/로그/`_workspace`에 출력하지 않는다.
- undo는 가격 40행(`comp_price_id` PK)만 정밀 제거. **재사용 siz/comp/mat 마스터는 절대 건드리지 않음**(다른 상품 공유).

## 9. 인간 승인 게이트 (본 트랙은 단 하나)

| 게이트 | 대상 | 상태 |
|--------|------|------|
| **실제 COMMIT** | `./apply.sh --commit` (40행 라이브 반영) | **인간 승인 대기 (유일)** |
| ~~siz master-data 등록~~ | — | **없음** (EXACT 재사용) |
| ~~코드행 등록~~ | — | **없음** (전부 선존재) |
| ~~신규 바인딩~~ | — | **없음** (선존재) |
| ~~DDL 적용~~ | — | **없음** (스키마 변경 0) |

→ GP/면적/고정가 트랙과 달리 후니 master-data 결정이 **0건**. **가장 단순한 GO 트랙** — COMMIT 승인만으로 적재 완료.

## 10. 산출 파일

| 파일 | 내용 |
|------|------|
| `gen_load_sql.py` | 생성기(입력 CSV verbatim → 멱등 SQL, 재현성·정합 가드. 손편집 금지) |
| `01_component_prices.sql` | 40 ENV 가격 INSERT (`ON CONFLICT (comp_price_id) DO NOTHING`) |
| `migrate.sql` | 단일 트랜잭션 래퍼(BEGIN → guard0 → `\i 01` → assert ×3 + 멱등 카운트 → COMMIT) |
| `apply.sh` | 로더(기본 DRY-RUN/rollback, `--commit`=인간 승인). `.env.local`만. 비번 미출력 |
| `backup.sh` / `backup.sql` | 읽기전용 백업 스냅샷(undo 권위 — 빈 슬롯·충돌 부재 확증) |
| `undo.sh` / `undo.sql` | 역실행(가격 40행 DELETE, 마스터 보존) |
| `migrate.provenance.csv` | 생성행 → source CSV 출처(검증 역대조) |
| `README.md` | 한눈 요약·실행법 |

## 11. 검증 핸드오프 (자기 승인 금지)

`dbm-validator`에게 **R1~R6 + 라이브 롤백 DRY-RUN(2회 멱등성·제약위반0)** 검증을 요청한다. 빌더는 자기 승인하지 않는다.
별도 디렉터리이며 committed `_exec_price`/`_exec`/`_migrate_fixedprice`/`_migrate_areamatrix`/`_migrate_gp_circle`와 무간섭.
박(foil) 트랙은 게이트 BLOCKER-1(재사용 siz 혼합축) 미해소 = **BLOCKED**이므로 본 ENV 트랙과 분리(foil 설계 미수정).
