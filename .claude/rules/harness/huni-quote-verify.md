---
paths:
  - "_workspace/huni-quote-verify/**"
---

# §15 Harness: Huni-Quote-Verify — 단일 상품 가격검증 (Claude+Codex)

"상품군+상품명" 온디맨드 3축 검증(SOT 일치·공식↔구성요소 매핑·차원 매칭)+codex 독립 교차.
스킬=`huni-quote-verify-orchestrator` (트리거: 가격계산 검증·상품 가격 검증·codex 병행 검증).
산출=`_workspace/huni-quote-verify/<product>/`. 변경이력: 최신 2026-06-18 초기 구성 → CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §15.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
