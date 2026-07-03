---
paths:
  - "_workspace/huni-basedata-dedup/**"
---

# §17 Harness: Huni-Basedata-Dedup — 표시중복 정리·적재 (Claude+codex)

6축 기초데이터 표시명/내부값 중복·표시↔실제 불일치 검수→codex 교차→승인 후 적재(NO-OP 허용).
스킬=`huni-basedata-dedup-orchestrator` (트리거: 기초데이터 중복 정리·사이즈 중복·표시명 중복).
산출=`_workspace/huni-basedata-dedup/<axis>/`. 변경이력: 최신 2026-06-19 공정 파일럿 GO·COMMIT 9건 → CHANGELOG

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §17.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
