# Huni-Project-Plan 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §10의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §10 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-16 | 하네스 초기 구성 + 일정관리 엑셀 산출 — 경량 하네스(신규 에이전트 3 + 오케스트레이터 1·기존 hw/dbm/pq 재사용). 입력 IA 144기능 → **보강 162기능**(Shopby 표준 갭·주문 런타임·MES 생산브릿지 18행) + 신규 6시트(위젯·에디쿠스 22기능·주문→MES 안밖·고객준비물/최숙진실장·외부계약14·용어집·개발자상세). 실측 근거: 위젯 역공학·라이브 DB(주문 런타임 0개·MES_ITEM_CD 16/275)·Shopby OpenAPI. 주차 상대일정+병렬 레인+병목(쇼핑 공수 2배). 독립 QA Q1~Q5 GO(High 0·가상기능 0·집계 정합·비밀값 노출 0) | `.claude/agents/huni-project-plan/`·`.claude/skills/huni-project-plan-orchestrator`·`_workspace/huni-project-plan/`·CLAUDE.md §10 | 사용자(`/harness:harness` — 프로젝트 일정관리 문서) |
