# `_exec_tierA_digitalprint` — 디지털인쇄 Tier A 14상품 CPQ 옵션레이어 (적재 실행본)

round-6 CPQ 옵션레이어를 디지털인쇄 Tier A 14상품으로 확장한 멱등 적재 패키지.
`_exec_silsa_cpq` 멱등 패턴 계승. **차원행 mint 없음**(14상품 sizes/materials/print_options/processes 라이브 적재 실측 완료).

## 실행 (기본 = DRY-RUN·롤백전용·NEVER COMMIT)

```bash
cd 09_load/_exec_tierA_digitalprint
bash apply.sh            # DRY-RUN: BEGIN…apply…ROLLBACK (기본, 아무것도 커밋 안 함)
bash apply.sh commit     # [인간 승인만] 실제 COMMIT — 영구 적재
```
- `.env.local`의 `RAILWAY_DB_*` 사용. 비밀번호 stdout/_workspace 기록 금지.
- 기본 모드는 항상 ROLLBACK. `commit`은 인간 승인 게이트.

## 파일

| 파일 | 역할 |
|---|---|
| `gen_load_sql.py` | 생성기(라이브 실측/L1→멱등 SQL, 재현성). 손편집 금지 — 변경은 생성기 경유 |
| `apply.sql` | 단일 트랜잭션 래퍼(`\i` FK 위상순). 00→05→06→07→08 |
| `apply.sh` | psql 로더(기본 dryrun/ROLLBACK) |
| `00·05~08_*.sql` | 단계별 멱등 INSERT(이름기반 NOT EXISTS) |
| `load-manifest.md` | 순서·행수·채번표·멱등 기제·DRY-RUN 결과·설계결정 |
| `blocked-and-gaps.md` | BLOCKED(접지/화이트별색)·[CONFIRM]·GAP·더미 |
| `load.provenance.csv` | 각 적재 행 → 권위 출처 추적 |
| `_blocked/07_*.sql` | 접지/화이트별색 option_items(차원행 부재 DEFER) — 본 트랜잭션 미포함 |
| `_cleanup_dummy.sql` | 016/025 테스트 더미 정리 — **인간 승인 전용**(apply.sql 미포함) |

## 적재 행수 (INSERTABLE)

option_groups 58 · options 267 · option_items 252 = **577행**. BLOCKED 6(접지4+화이트별색2). constraints 0.

## 멱등성 (핵심)

모든 INSERT = `INSERT … SELECT … WHERE NOT EXISTS (… 이름/자연키 …)`. surrogate 코드(OPT_000005+/OPV_000017+)는
라이브 MAX+1 리터럴이지만 **존재검사는 이름**이라 2회차 delta 0. 라이브 2-pass DRY-RUN 실증(manifest §5).

## 경계 (HARD)

- **NEVER COMMIT** (기본 ROLLBACK). 실제 COMMIT·더미 정리·BLOCKED 적재·[CONFIRM] 해소 = 인간 승인.
- CPQ 행 INSERT 만 (CREATE/ALTER 없음·DDL 아님·mint 없음).
- GO 판정은 `dbm-validator`(별도 에이전트) 소관. 본 패키지는 빌드 산출 — 자가 승인 금지.
