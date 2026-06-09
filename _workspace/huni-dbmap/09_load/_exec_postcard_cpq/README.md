# `_exec_postcard_cpq` — 프리미엄엽서(PRD_000016) CPQ 적재 실행본

round-6 CPQ 옵션레이어 → 적재 실행본(round-5 방법론). **가족 최초 TEMPLATE + 최초 CONSTRAINT 적재.**
**NEVER COMMIT** — 로더 기본 ROLLBACK. DDL 없음. 검증/GO 는 `dbm-validator` 소관(자가 GO 아님).

## 무엇을 적재하나
프리미엄엽서(PRD_000016) CPQ 옵션레이어 + 봉투 add-on template + 제약(JSONLogic) + constraint_json compile 캐시.
- option_groups 5 · options 13 · option_items **4 INSERTABLE**(도수2·모서리2) · templates 1(카드화이트 mint) ·
  template_selections 1 · addons 2(누적 3) · constraints 3 · constraint_json UPDATE 1 = **INSERT 29 + UPDATE 1**.
- BLOCKED 5 option_items(후가공4·종이1) = `_blocked/`(차원행 부재·적재 대상 아님).

## 코드 규약 (`00_schema/code-identifier-strategy.md` D1~D5)
- `_` 순차 surrogate, 라이브 MAX+1 리터럴. 멱등 = 이름/자연키 `WHERE NOT EXISTS`(코드 재발급 없음).
- opt_grp `OPT_000005~000009` · opt `OPV_000017~000029` · tmpl `TMPL_000010`(카드화이트) · rule `RULE_001~003`.
- 설계 시맨틱 코드(OG-*/OP-*/TMPL-ENV-*/R-*) = DEPRECATED → 전부 재코드.

## search-before-mint (템플릿 — 중요)
봉투 OPP접착=`TMPL-000005`·OPP비접착=`TMPL-000006` 라이브 실재(del_yn=N·selection 포함) → **reuse(mint 안 함)**.
카드봉투화이트만 활성 템플릿 부재(TMPL-000007 del_yn=Y) → `TMPL_000010` 신규 mint. PRD_000016 addon→TMPL-000005 기실재 → 멱등 흡수.

## 사용법
```bash
./apply.sh            # DRY-RUN (BEGIN…apply…ROLLBACK) — 기본, 아무것도 커밋 안 함
./apply.sh commit     # [인간 승인] 실제 COMMIT
python3 gen_load_sql.py   # SQL 재생성 (손편집 금지·CSV/설계 STRUCTURE 권위 위에서 생성)
```

## 파일
| 파일 | 역할 |
|---|---|
| `gen_load_sql.py` | 멱등 SQL 생성기(재현·provenance) |
| `apply.sql` | 단일 트랜잭션 FK 위상정렬 `\i` 오케스트레이션(00→05→06→07→08→09→10→11→12) |
| `apply.sh` | 로더(ROLLBACK 기본·`commit` 인자만 COMMIT·비밀번호 미echo) |
| `NN_*.sql` | 단계별 멱등 INSERT/UPDATE |
| `_blocked/07_*.sql` | BLOCKED option_items 5행(실행 금지·명세 보존) |
| `load.provenance.csv` | 행→권위 출처 추적(31행) |
| `load-manifest.md` | 적재 순서·코드 부여표·DRY-RUN 결과·OTC/C 결정 |
| `blocked-and-gaps.md` | BLOCKED/CONFIRM/GAP + 해제 조건 |

## DRY-RUN 실증 (2026-06-09·롤백전용·COMMIT 0)
- Pass1: INSERT 29 + UPDATE 1, 트리거/제약 위반 0(도수/모서리 차원행 EXISTS 통과). addons 첫 행 `INSERT 0 0`(기실재 멱등 흡수).
- Pass2(단일 트랜잭션 내 2회): 전 `INSERT 0 0`/`UPDATE 0`(delta 0·코드 재발급 0). 누적 = 목표치(addons 3·중복 0).
