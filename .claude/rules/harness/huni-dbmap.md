---
paths:
  - "_workspace/huni-dbmap/**"
---

# §7 Harness: Huni-DBMap — Railway DB 데이터 매핑·적재

t_* 34테이블 시트화 + 엑셀→라이브 매핑·검증·적재(실 INSERT=인간 승인·G1~G9). 5인 dbm-* 팀.
스킬=`huni-dbmap-orchestrator` (트리거: DB 매핑·가격표 매핑·적재 CSV/준비/실행·DRY-RUN·Railway DB).
산출=`_workspace/huni-dbmap/`. 권위 goal=`docs/goal-2026-06-06-01.md`. 진행=round-24+(CHANGELOG 스냅샷).
변경이력: 최신 2026-07-04(6) 판형 오배선 2차 전수교정(13상품 COMMIT·잔존0)+상시게이트
`_foundation/batch/plate_wiring_integrity_check.sql` → `_workspace/huni-dbmap/CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §7.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
