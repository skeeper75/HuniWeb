---
paths:
  - "_workspace/excel-to-db/**"
---

# §32 Harness: Excel-to-DB — 범용 엑셀→DB 파이프라인

임의 업무 엑셀 → 프로파일→의미사전→스키마→적재코드→X1~X7 게이트(범용·후니 t_*는 전용 하네스 우선).
스킬=`excel-to-db-orchestrator` (트리거: 엑셀 분석해서 DB로·엑셀 DB화·x2d). ★LLM 숫자 전사 금지[HARD].
산출=`_workspace/excel-to-db/`. 플레이북=`_meta/best-practices-playbook.md`.
변경이력: 최신 2026-07-02 초기 구성(스모크 13시트 PASS) → `_workspace/excel-to-db/_meta/CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §32.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
