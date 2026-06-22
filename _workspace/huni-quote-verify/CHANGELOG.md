# Huni-Quote-Verify 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §15의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §15 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 하네스 초기 구성 — 3 에이전트(hqv-product-decomposer·quote-verifier·codex-cross-verifier) + 4 스킬(orchestrator + product-decompose·quote-verification·codex-cross-verify) + codex-review.sh. Claude+Codex 병행 독립 교차검증(구독=ChatGPT OAuth 실측·종량과금 없음). 단일 상품 온디맨드 "가격계산 되는지" 3축 검증+개선. dbm-price-arbiter 재사용(개선 심의) | `.claude/agents/huni-quote-verify/`·`.claude/skills/{huni-quote-verify-orchestrator,hqv-*}`·CLAUDE.md §15 | 사용자(`/harness:harness` — codex 병행 단일상품 가격계산 검증+개선) |
