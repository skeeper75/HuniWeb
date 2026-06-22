# Huni-Price-Engine-Diag 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §14의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §14 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | **전 하네스 전수 감사 + 정리(운영/유지보수·문서·배선만·코드/DB/삭제 0)** — 2 감사관 병렬(인벤토리·드리프트 / 가격 클러스터). ★결론: 가격 4하네스(§7·§13·§14·§15)=**중복 아닌 의도적 상보 레이어**(이해→게이트→온디맨드→적재·재병합 금지). 실행: A-1 STALE 정정("evaluate_price 미구현"→실재·§13/§15 실호출·dbm-price-engine-verifier/verify·dbm 오케스트레이터 round-18 4곳·prcx01 STALE 가드) · A-2 dbm-schema-analyst 29→44테이블 · B-1 round-24 dbm-category 오케스트레이터 등재 · B-3 방법론 스킬 12 에이전트 durable 배선 · C 경계 명문화(cartographer↔mechanism·§13↔§15). ★B-2 유령토큰=오탐(grep `pq-`가 `cpq-` 부분매칭). 보류: frm_typ/clr_cd는 dbm-price-formula-audit 결판 후 | `_workspace/_harness-audit/`·dbm/hpq/hped/hqv/hbg 에이전트·스킬·CLAUDE.md §14·[[harness-audit-maintenance]] | 사용자(`/harness:harness` — 전수 감사·중복/이전버전 정리) |
| 2026-06-18 | U-7 트랙 추가 — 에이전트 `hped-binding-validity-designer` + 스킬 `hped-binding-validity-mapping`. 오적재 단일병인(formula_components prd_cd 부재→시트밖 구성요소 silent 합산)을 닫는 구성요소↔상품군 유효성 정합 설계(Phase 3). ★초점=코드(트리거/DDL) 구현 아닌 데이터 정합(제대로된 가격 결과)·SOT 1 권위·DDL은 dbm-ddl-proposer 위임 | `.claude/agents/huni-price-engine-diag/hped-binding-validity-designer`·`.claude/skills/hped-binding-validity-mapping`·오케스트레이터 Phase3·CLAUDE.md §14 | 사용자(`/harness:harness` — U-7 배선레벨 제약 데이터 정합 설계) |
| 2026-06-18 | 하네스 초기 구성 — 2 에이전트(hped-mechanism-researcher·code-schema-auditor) + 3 스킬(orchestrator + mechanism-research·code-schema-audit). §13 검증 트랙의 선행 이해·진단 레이어(5장치 역할 원리 정의·코드↔DB 속성 정합·아는것/모르는것 분리). 신규 독립 하네스 | `.claude/agents/huni-price-engine-diag/`·`.claude/skills/{huni-price-engine-diag-orchestrator,hped-*}`·CLAUDE.md §14 | 사용자(`/harness:harness` — 5장치 역할 정의+코드/DB 정합 진단+지식격차) |
