# _exec_tierA_sticker — 스티커 Tier A 4상품 CPQ 옵션레이어 적재 패키지

> round-6 · `dbm-option-mapper` 산출 2026-06-14 · **DB 미적재**(DRY-RUN 롤백전용 실증·실 COMMIT 인간 승인).
> 설계 권위 = `../../10_configurator/tierA/sticker-option-layer.md`.

## 대상
PRD_000052(반칼 자유형)·PRD_000053(투명)·PRD_000055(낱장 자유형)·PRD_000066(합판도무송).

## 실행
```bash
./apply.sh            # DRY-RUN (BEGIN…apply…ROLLBACK) — 기본, 커밋 안 함
./apply.sh dryrun     # 동일(명시)
./apply.sh commit     # [인간 승인] 실제 COMMIT — 영구 적재
```
`.env.local` 의 `RAILWAY_DB_*` 로드. 비밀번호 stdout/_workspace 기록 금지.

## 파일
| 파일 | 역할 |
|---|---|
| `apply.sql` / `apply.sh` | 단일 트랜잭션 로더(05→06→07→08·기본 ROLLBACK) |
| `00_preload_markers.sql` | 적용 결정·stub 회피 마커(NO INSERT) |
| `05~08_*.sql` | option_groups(12)·options(22)·option_items(21)·constraints(0) 멱등 INSERT |
| `_cleanup_dummy.sql` | 066 고아 OPV-000006 정리(인간 승인·NEVER auto-run) |
| `gen_load_sql.py` | 행 구조 감사 참조(손저작 *.sql 이 권위) |
| `load-manifest.md` | 적재 매니페스트·DRY-RUN 결과 |
| `blocked-and-gaps.md` | BLOCKED 0·GAP 3·CONFIRM 5 |
| `load.provenance.csv` | 행→L1/라이브 권위 추적 |

## 적재 가능성 (DRY-RUN 실증 2026-06-14)
- INSERTABLE 55행(groups 12·options 22·items 21)·BLOCKED 0.
- PASS-1 트리거 전건 통과(REJECT 0)·PASS-2 멱등 delta 0·ROLLBACK 영구변경 0.

## 차원행 전제
전 차원(자재/공정/도수/사이즈) 라이브 적재 → mint 불요. option_item 은 라이브 차원행 포인터.

## 미적재 원칙
빌드 산출만(자가 승인 금지). GO 판정 = `dbm-validator`. 실 COMMIT·고아 정리·GAP DDL = 인간 승인.
</content>
