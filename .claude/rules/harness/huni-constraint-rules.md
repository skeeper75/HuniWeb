---
paths:
  - "_workspace/huni-constraint-rules/**"
---

# §31 Harness: Huni-Constraint-Rules — 제약규칙 거버넌스

CN-1~CN-6 규정 먼저→UI(폼빌더) 확인가능한 정형 shape만 제약 등록(raw JSONLogic 금지·오차단 0·CR1~CR7).
스킬=`huni-constraint-rules-orchestrator` (트리거: 제약규칙·제약조건 등록·옵션그룹 제약 이관).
산출=`_workspace/huni-constraint-rules/`. 핵심: 엔진이 크기/수량 구간차원 이미 처리→해당 제약 불필요.
변경이력: 최신 2026-07-03 사상기반 재검증 — 새 가격영향 제약 사실상 없음·실무진 질문서 통합
(`_meta/실무진-확인질문서-260703.md`) → `_workspace/huni-constraint-rules/CHANGELOG.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §31.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
