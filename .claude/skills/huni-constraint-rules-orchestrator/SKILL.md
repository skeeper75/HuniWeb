---
name: huni-constraint-rules-orchestrator
description: 후니프린팅 제약규칙 거버넌스 하네스(Huni-Constraint-Rules) 오케스트레이터. 전 상품의 제약조건이 되는 부분을 찾아 webadmin 제약규칙(t_prd_product_constraints·JSONLogic)으로 등록하되, ★규칙·차원을 UI(폼빌더)에서 확인·조정 가능한 정형 shape로만 작성(raw JSON 금지)하고, 제약이 필요한 상황을 CN-1~CN-6으로 먼저 규정한 뒤 작성한다. 파일럿=129 폼보드·130 포맥스보드 데모 수정→전 상품 데모형 전파, 옵션그룹 오용(옵션그룹의 제약 역할 대행) 이관, CPQ 베스트프랙티스 리서치→개발자 전달 문서(잘된점·개선/보완/강화/수정·시각화 보완강화) 산출. 5인 팀(hcr-scenario-curator ∥ hcr-cpq-researcher → hcr-rule-designer → hcr-gate-validator CR1~CR7 → 인간 승인 → hcr-ui-registrar 등록+실화면). '제약규칙', '제약조건 등록', '제약규칙 작성/수정/등록', '포맥스 제약', '제약조건데모', '전 상품 제약', '옵션그룹 제약 이관', 'CPQ 베스트프랙티스', '제약 시각화', '제약 개발자 전달', '제약 하네스 실행/재실행/업데이트/보완', '특정 상품만 제약', '제약규칙 다시' 작업 시 반드시 이 스킬을 사용. 제약 정합 "검증만"은 §21 hcc-cpq-link, 위젯 validate 강제 구현은 §6 위임. 단순 질문은 직접 응답.
---

# Huni-Constraint-Rules 오케스트레이터

## 목표
전 상품 제약조건을 "규정→설계→검증→승인→UI-확인가능 등록"으로 완주하고, 개발자 전달 문서(개선점·시각화 강화)까지 산출한다.

## 핵심 원칙 [HARD]
- **UI-확인가능** — logic은 폼빌더 역파싱 가능한 정형 shape만. 완료 정의=DB 행이 아니라 "UI에서 규칙·차원을 읽고 조정 가능한 상태".
- **규정 먼저** — CN-1~CN-6 규정(`hcr-scenario-spec`) 없이 규칙 작성 금지.
- **오차단 0** — 정당한 조합을 막으면 매출 차단. CR2가 최우선 게이트.
- **생성≠검증** — designer 산출은 gate-validator가 독립 재실측.
- **라이브 안전** — 읽기전용 기본, COMMIT은 t_prd_product_constraints만·게이트 GO+인간 승인 후·백업/DRY-RUN/undo/실화면(§1 규칙).
- **제약≠가격** — evaluate_price는 제약 미참조. 견적 0원 자체는 가격 트랙(§26/§27), 위젯/주문 validate 강제는 §6/§24로 라우팅.

## 실행 모드
**서브 에이전트** (Agent 도구·`model: "opus"` 명시). 팀 통신 불필요 — 파일 기반 전달(`_workspace/huni-constraint-rules/`)로 충분. Phase 1만 병렬 팬아웃.

## Phase 0: 컨텍스트 확인
- `_workspace/huni-constraint-rules/` 부재 → 초기 실행(전체).
- 존재 + 부분 수정 요청(예: "특정 상품만", "게이트만 다시", "포맥스만") → 해당 에이전트만 재호출.
- 존재 + 새 입력(권위 엑셀 갱신 등) → 기존을 `_workspace_prev/`로 이동 후 새 실행.
- 사용자가 등록 승인 의사를 밝힌 상태인지 확인(승인 없으면 Phase 5는 대기).

## Phase 1: 기준점 팬아웃 (병렬)
- `hcr-scenario-curator` → `01_scenario/`(CN 규정·후보 체크리스트·옵션그룹 오용 보드)
- `hcr-cpq-researcher` → `02_research/`(베스트프랙티스·dev-handoff 초안)

## Phase 2: 규칙 설계
- `hcr-rule-designer` → `03_rules/`. **파일럿=129/130 데모 수정 먼저** → 파일럿 게이트 통과 후 동형 전파(상품군 단위 wave).

## Phase 3: 게이트
- `hcr-gate-validator` → `05_gate/gate-report.md`(CR1~CR7)·`dev-handoff-final.md`. NO-GO → Phase 2 라우팅 루프(규칙 단위).

## Phase 4: 인간 승인
- GO분 요약(상품·규칙 수·막는 조합 수·undo 경로)을 AskUserQuestion으로 승인 요청(wave 단위).

## Phase 5: 등록 + UI 실화면
- `hcr-ui-registrar` → `04_register/<wave>/`. 실화면 4항 FAIL → undo 후 Phase 2 반송. wave 통과 후 다음 wave.

## Phase 6: 종합·진화
- 진척판(상품×CN 커버리지) 갱신·CHANGELOG PREPEND·CLAUDE.md §31 변경이력 포인터 갱신. 피드백 수집(스킬/에이전트 갱신).

## 데이터 전달
파일 기반: `01_scenario`→`03_rules`→`05_gate`→`04_register` 순 의존. dev-handoff는 `02_research`(초안)→`05_gate`(확정). 중간 산출물 보존(감사 추적).

## 에러 핸들링
- 에이전트 실패=1회 재시도 후 해당 산출 없이 진행(보고서에 누락 명시). 라이브 접속 실패=UNVERIFIED 명시(통과 위장 금지). 상충 데이터=출처 병기(삭제 금지). codex 미가용="Claude 단독" 명시.

## 테스트 시나리오
- **정상**: "포맥스 제약 수정하고 전 상품 데모 등록해줘" → Phase 0(기존 129/130 감지)→1→2(파일럿)→3(GO)→4(승인)→5(실화면 PASS)→6.
- **에러**: 게이트 CR2에서 실존 조합 오차단 발견 → NO-GO·재현 쿼리와 함께 designer 재설계 → 재게이트 → GO. 실화면에서 raw 폴백 발견 → 즉시 undo → shape 재설계.

## 산출물 루트
`_workspace/huni-constraint-rules/` (01_scenario·02_research·03_rules·04_register·05_gate·_meta). 자격증명: `.env.local` `RAILWAY_DB_*`(SELECT+승인된 COMMIT)·`HUNI_ADMIN_*`(gstack 읽기 탐색만).
