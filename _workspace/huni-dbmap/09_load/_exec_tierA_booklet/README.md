# _exec_tierA_booklet — 책자 Tier A 4상품 CPQ 옵션레이어 적재본

> round-6 `dbm-option-mapper` 빌드 (2026-06-14). **DB 미적재**·**NEVER COMMIT**(인간 승인).
> 설계 정본 = `../../10_configurator/tierA/booklet-option-layer.md`.

## 대상
PRD_000068 중철책자 · PRD_000069 무선책자 · PRD_000071 트윈링책자 · PRD_000094 엽서북.

## 파일
| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | SQL 생성기 (라이브 실측 차원행 기준, 4상품 옵션 레이어 정의 내장) |
| `05_*.sql` | option_groups 32 (리터럴 OPT_000006~037, 이름 가드) |
| `06_*.sql` | options 140 (enum 24 DO + mat_usage 8 DO, opt_cd 동적채번) |
| `07_*.sql` | option_items 140 (enum 63 INSERT + mat_usage 8 DO, opt_nm resolve) |
| `08_*.sql` | constraints 0 (page_rule 비옵션·제약 DEFER) |
| `apply.sql` | 단일 트랜잭션 (05→06→07→08 + verify), 기본 ROLLBACK |
| `apply.sh` | psql 러너. `dryrun`(기본)·`commit`(인간 승인) |
| `load-manifest.md` | 적재 순서·행수·DRY-RUN 결과 |
| `blocked-and-gaps.md` | BLOCKED 0 + GAP 3(DOSU-USAGE/PARAM/HIDDEN) + CONFIRM 3 |
| `load.provenance.csv` | option_item → L1 source 컬럼 + 라이브 차원행 |

## 사용
```bash
./apply.sh dryrun     # DRY-RUN (롤백전용, 기본) — 트리거 통과·멱등 실증
./apply.sh commit     # [인간 승인 후에만] 실제 COMMIT
python3 gen_load_sql.py   # SQL 재생성
```

## 핵심 설계 (라이브 실측 기준)
- **내지/표지 2축**: 자재는 `usage_cd`(USAGE.01/02)로 분리 — 차원 재적재 불요. 도수는 print_options usage 미구분 → 공유 참조(GAP-DOSU-USAGE).
- **제본(필수)=택일그룹**: 라이브 4상품 제본 option_group 0행 확인 → 신규생성(cpq-schema §1.5 GRP-BOOK 기술은 stale).
- **071 투명커버·링컬러=자재**(MAT_TYPE.02 필름·.04 금속, USAGE.05·.07), 공정 아님(라이브 정정).
- **내지페이지=page_rule**(이미 라이브 적재, 손대지 않음), 옵션 아님.
- **094 셋트 2행=BOM**(내지 PRD_000095·표지 PRD_000096) → 셋트구성 그룹(CONFIRM §5.4).
- **opt_cd 동적채번**: 리터럴 0 → enum/mat_usage 충돌 0·재발급 0(2-pass delta 0 실증).

## DRY-RUN 실증 (2026-06-14)
- PASS 1: 32 groups / 140 options / 140 items, 트리거 위반 0, ERROR 0.
- PASS 2: delta 0 (멱등). 라이브 영속성 0 (ROLLBACK 후 live 0).
