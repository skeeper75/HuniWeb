---
paths:
  - "_workspace/huni-price-table-integrity/**"
  - "_workspace/_foundation/live-snapshot/**"
---

# §26 Harness: Huni-Price-Table-Integrity — 가격테이블 적재 무결성

권위 엑셀 가격테이블의 차원+전 셀이 라이브에 이 빠짐 없이 적재됐는지 결정론 배치 diff 진단(I1~I7).
스킬=`huni-price-table-integrity-orchestrator` (트리거: 가격테이블 무결성·미적재 셀·차원 누락·sparse grid).
산출=`_workspace/huni-price-table-integrity/`. 라이브 실측=`_workspace/_foundation/live-snapshot/`.
변경이력: 최신 2026-07-05 권위 260702 재고정+권위 이해 문서(25_)+엽서북/명함 격자 merge-tombstone 오탐 해소(스티커 보류)
→ `_workspace/huni-price-table-integrity/HANDOFF.md`·`CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §26.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
