# `_exec_silsa_cpq` — 일반현수막(PRD_000138) CPQ 옵션레이어 v2 + 마스터 mint (적재 실행본)

round-6 CPQ 옵션레이어를 **2026-06-09 비준 코드 규약**(`_` 순차 surrogate·이름기반 멱등·신규 DDL 0)에
맞춰 재코딩하고 **마스터 mint**(자재 4·공정 1)를 포함한 멱등 적재 패키지.

## 실행 (기본 = DRY-RUN·롤백전용·NEVER COMMIT)

```bash
cd 09_load/_exec_silsa_cpq
bash apply.sh            # DRY-RUN: BEGIN…apply…ROLLBACK (기본, 아무것도 커밋 안 함)
bash apply.sh commit     # [인간 승인만] 실제 COMMIT — 영구 적재
```
- `.env.local`의 `RAILWAY_DB_*` 사용. 비밀번호 stdout/_workspace 기록 금지.
- 기본 모드는 항상 ROLLBACK. `commit`은 인간 승인 게이트.

## 파일

| 파일 | 역할 |
|---|---|
| `gen_load_sql.py` | 생성기(설계/CSV→멱등 SQL, 재현성). 손편집 금지 — 변경은 생성기 경유 |
| `apply.sql` | 단일 트랜잭션 래퍼(`\i` FK 위상순). 00→01→…→08 |
| `apply.sh` | psql 로더(기본 dryrun/ROLLBACK) |
| `00`~`08_*.sql` | 단계별 멱등 INSERT(이름기반 NOT EXISTS) |
| `load-manifest.md` | 순서·행수·mint 코드 부여표·멱등 기제·DRY-RUN 결과·설계결정 |
| `blocked-and-gaps.md` | BLOCKED(constraint)·[CONFIRM]·GAP |
| `load.provenance.csv` | 각 적재 행 → 권위 출처 추적 |
| `_blocked/08_*.sql` | R-GAKMOK constraint(siz 의존 DEFER) — 본 트랜잭션 미포함 |

## 적재 행수 (INSERTABLE)

자재 mint 4 · 공정 mint 1 · 자재 링크 6 · 공정 링크 1 · 옵션그룹 2 · 옵션 11 · 옵션아이템 18 = **43행**.
constraint 0(R-GAKMOK DEFER).

## 멱등성 (핵심)

모든 INSERT = `INSERT … SELECT … WHERE NOT EXISTS (… 이름/자연키 …)`. surrogate 코드(MAT_000337 등)는
라이브 MAX+1 리터럴이지만 **존재검사는 이름**이라 2회차 delta 0(코드 재발급 없음). 라이브 2-pass DRY-RUN으로 실증(manifest §5).

## 경계 (HARD)

- **NEVER COMMIT** (기본 ROLLBACK). 실제 COMMIT·R-GAKMOK·enum 확장·siz 등록 = 인간 승인.
- mint = master-data INSERT (CREATE/ALTER 없음·DDL 아님).
- GO 판정은 `dbm-validator`(별도 에이전트) 소관. 본 패키지는 빌드 산출 — 자가 승인 금지.
