---
paths:
  - "_workspace/huni-price-table-integrity/**"
  - "_workspace/_foundation/live-snapshot/**"
---

# §26 Harness: Huni-Price-Table-Integrity — 가격테이블 적재 무결성

권위 엑셀 가격테이블의 차원+전 셀이 라이브에 이 빠짐 없이 적재됐는지 결정론 배치 diff 진단(I1~I7).
스킬=`huni-price-table-integrity-orchestrator` (트리거: 가격테이블 무결성·미적재 셀·차원 누락·sparse grid).
산출=`_workspace/huni-price-table-integrity/`. 라이브 실측=`_workspace/_foundation/live-snapshot/`.
변경이력: 최신 2026-07-06 가격구성요소 차원정합 감사+전 사슬 프레임워크(grid_diff N%≠정합)+순환고리 4계층 센서스+아크릴 mat_cd config 교정(79→100%)+옵션코드 정합 라이브 교정(키링 재배선·14중복 재번호·UNIQUE 인덱스·verify✅)
→ `_workspace/huni-price-table-integrity/HANDOFF.md`·`CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §26.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
