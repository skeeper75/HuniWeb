# ENV 봉투제작 적재본 (`_exec_env`)

> round-5 적재 실행본 — 봉투제작(ENV) 가격 40행. 검증 GO(`03_validation/price-foil-envelope-gate.md`).
> **HARD: DB 쓰기·COMMIT 0(인간 승인 전). 기본 DRY-RUN(롤백). 비밀번호 미출력.**

## 1. 무엇을 적재하는가
- **`t_prc_component_prices` 40행** (`comp_price_id` 1713~1752): 봉투제작 완제품가(.06).
- 봉투 4종(티켓/소/자켓/대) × 소재 2종(모조120g=MAT_000159 / 레자크=MAT_000168) × 수량 5구간(1000~5000).
- siz: `SIZ_000191`(티켓 225×193)·`SIZ_000192`(소 238×262)·`SIZ_000193`(자켓 262×238)·`SIZ_000194`(대 510×387).

## 2. 가장 단순한 적재본 — 신규 INSERT만
| 대상 | 행수 | 비고 |
|------|:----:|------|
| siz 등록 | **0** | 작업사이즈→라이브 siz EXACT 재사용(게이트 확인, mint 0) |
| 바인딩 INSERT | **0** | `PRD_000050`→`PRF_ENV_MAKING` 라이브 선존재 |
| 코드행 INSERT | **0** | `.06`·`FRM_TYPE.02`·`COMP_ENV_MAKING` 라이브 선존재 |
| **component_prices** | **40** | 빈 COMP_ENV_MAKING 슬롯을 채우는 순수 신규 적재 |

→ 후니 결정·신규등록 불필요. **COMMIT 승인만** 남음.

## 3. 멱등성
- 전 INSERT `ON CONFLICT (comp_price_id) DO NOTHING` (PK 충돌키, 단일컬럼). 2회 적용 시 2회차 행변경 0.
- `migrate.sql` 단일 `BEGIN…COMMIT`(원자성)·`ON_ERROR_STOP`. guard0(siz EXACT 재사용) + 적재 후 FK 고아 어서션(siz·comp·mat) + 멱등 카운트 내장.
- `reg_dt` 컬럼 생략 → DEFAULT 발화(round-5 NOT-NULL-DEFAULT 함정 회피, 명시 NULL 0).

## 4. 안전 절차
```
./backup.sh           # (권장) 읽기전용 백업 스냅샷 (COMP_ENV_MAKING 라이브=0 확증 = undo 권위)
./apply.sh            # DRY-RUN (migrate.sql 실행 후 강제 ROLLBACK). DB 무변경.
./apply.sh --commit   # ★인간 승인★ 실제 COMMIT (봉투 40 단가 반영)
./undo.sh             # DRY-RUN
./undo.sh --commit    # ★인간 승인★ comp_price_id 1713~1752 DELETE
```
- 자격증명 `.env.local`만. 비밀번호 stdout/로그/`_workspace` 미출력.
- DDL 변경 0 — 기존 라이브 스키마·기존 siz/comp/mat 재사용.

## 5. 파일
| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | 생성기(입력 CSV verbatim → SQL, 재현·손편집 금지) |
| `01_component_prices.sql` | 40행 멱등 INSERT (`ON CONFLICT (comp_price_id) DO NOTHING`) |
| `migrate.sql` | 단일 트랜잭션 래퍼(guard0+`\i 01`+FK 어서션 ×3+멱등 카운트) |
| `apply.sh` / `undo.sh` | 로더(기본 DRY-RUN/롤백, `--commit`=인간 승인) |
| `backup.sh` / `backup.sql` | 읽기전용 백업 스냅샷(undo 권위) |
| `undo.sql` | 역적재(DELETE comp_price_id 1713~1752) |
| `migrate.provenance.csv` | 출력행→source CSV 출처(검증 역대조) |
| `MIGRATION.md` | 상세 설계(무엇/왜·멱등성·안전절차·인간승인=COMMIT only) |

**입력 권위:** `02_mapping/load_price/t_prc_component_prices_ENV.csv`(40행). 잔여=R1~R6 로컬 게이트 + 라이브 롤백 DRY-RUN(승인) + 실제 COMMIT(승인).

## 6. 검증 핸드오프 (자기 승인 금지)
`dbm-validator`에게 R1~R6 + 라이브 롤백 DRY-RUN(2회 멱등·제약위반0) 검증 요청. 빌더는 자기 승인하지 않는다.
committed `_exec_price`/`_exec`/`_migrate_*`와 무간섭(별도 디렉터리).
