# _exec_bankal — 반칼 모양 062/063 가격 연결 실행본 (round-23 항목 7)

arbiter `../bankal-shapes-resolution.md`(BK-1~BK-5) 중 즉시 GO분 → 멱등 SQL + 롤백전용 DRY-RUN. **설계+DRY-RUN GO 까지 · 실 COMMIT 인간 승인.**
(스티커 058~064 반칼 모양 가격 연결 — `_exec_sticker`/`_exec_sticker2` 후속 BLOCKED 해소분)

## 파일
| 파일 | 내용 |
|------|------|
| `BK_bindings.sql` | 062 반칼팬시·063 반칼팬시투명 → PRF_STK_FIXED 바인딩 2 (가격행 0) |
| `apply.sql` | 단일 트랜잭션·`ROLLBACK` 기본 |
| `apply.sh` | 백업 1 CSV → DRY-RUN(기본) / `--commit`(인간 승인 후) |
| `manifest.md`·`dryrun-report.md`·`blocked-and-gaps.md` | 매니페스트·R1~R6·잔여 차단 |

## 실행
```bash
bash apply.sh dryrun     # 기본·라이브 무변경·COMMIT 0
bash apply.sh --commit   # 실 COMMIT (인간 최종 승인 후에만)
```

## 핵심
- 영향행 **2** (바인딩 INSERT만) · **가격행 추가 0** (형상=칼틀·B01 단가 재사용·COMP_STK_PRINT 1074 불변).
- 멱등 2-pass delta 0 · FK 고아 0 · COMMIT 0.
- 골든: 062 124x186 유포 mq3 = 5900 · 063 124x186 투명162 mq1 = 7000 (B01 verbatim·형상 무관 동일가).
- PK=(prd,apply_bgn_ymd) NOT EXISTS 가드 · apply_bgn_ymd='2026-06-01'(052~057 sibling).
- 검증은 `dbm-validator` R1~R6 (자체승인 금지).

## 잔여 BLOCKED (blocked-and-gaps.md)
058~061(A5/A4 격자 미보유·A4=B02 낱장가 오매칭·Q-BK-1)·064(소형반칼 단가 부재·Q-BK-2)·062/063 100x140(SIZ_058 미적재·Q-BK-3). ★공통=058~064 등록 siz ↔ 가격표 B01 siz 불일치(round-13 정합 의심).
