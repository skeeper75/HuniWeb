# Huni-Recipe-Viz 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §16의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §16 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | 디지털인쇄 파일럿 완주(GO·운영검증) + R7 freshness 게이트 추가(진화). codex가 31상품 레시피·mermaid 4·이미지 3·연결진단 생성, Claude 검증, **메인 원천 재측정이 라이브 드리프트 적발**(PRF_DGP_A 배선 upd_dt 2026-06-18 21:11 변경=S2 제거·del_yn=Y). ★교훈: 라이브는 작업 중 변하는 표적·upd_dt freshness 필수·검증자도 드리프트를 "날조"로 오인 가능 | `04_validation/divergence-final-adjudication.md`·`hrv-recipe-validation`(R7)·[[huni-recipe-viz-harness]] | 파일럿 운영검증 + 진화 |
| 2026-06-18 | 하네스 초기 구성 — 4 에이전트(hrv-recipe-builder·component-visualizer·connection-auditor·validator) + 5 스킬(orchestrator + recipe-build·component-visualize·connection-audit·recipe-validation). codex 중심(codex-cli 레시피·연결검증 + codex-imgage mermaid→이미지 2단계)·생성=codex/검증=Claude. 디지털인쇄 파일럿 | `.claude/agents/huni-recipe-viz/`·`.claude/skills/{huni-recipe-viz-orchestrator,hrv-*}`·CLAUDE.md §16 | 사용자(`/harness:harness` — 상품 구성요소 시각화·레시피·codex 중심) |
