# Huni-Price-Quote 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §13의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §13 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 5 에이전트(hpq-engine-cartographer·authority-curator·price-chain-inspector·option-constraint-mapper·quote-gate-validator) + 6 스킬(orchestrator + 5 방법론). 라이브 evaluate_price 권위 알고리즘 실측(공식 48·단가행 7,293·직접단가 0=전 상품 공식기반)·webadmin pricing.py/price_views.py 흐름 파악. 생성≠검증 분리(P1~P7 게이트)·권위 엑셀 절대 권위·DB 미적재·대표 상품군 파일럿 우선(사용자 4결정) | `.claude/agents/huni-price-quote/`·`.claude/skills/{huni-price-quote-orchestrator,hpq-*}`·CLAUDE.md §13 | 사용자(`/harness:harness` — 옵션 선택→가격계산 검증·뼈대 하네스) |
