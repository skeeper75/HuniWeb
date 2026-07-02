# Huni-Constraint-Rules 변경 이력 (최신이 위)

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-07-02 | 하네스 초기 구성 — 에이전트 5(hcr-scenario-curator·hcr-cpq-researcher·hcr-rule-designer·hcr-gate-validator·hcr-ui-registrar) + 스킬 5(오케스트레이터·scenario-spec·rule-authoring·ui-register-verify·gate-validation). CN-1~CN-6 필요상황 분류·CR1~CR7 게이트·UI 역파싱 정형 shape [HARD]·파일럿=129/130 데모 수정 | 전체 | 사용자 요청: 전 상품 제약규칙을 UI-확인가능 형태로 등록 + 옵션그룹 오용 해소 + CPQ 베스트프랙티스 개발자 전달 |

## 진행 상태 스냅샷
- 하네스 구축 완료, 첫 실행 전. 다음 시작점 = `huni-constraint-rules-orchestrator` 실행(Phase 1 팬아웃 → 129/130 파일럿).
- 선행 사실(재발견 금지): 129 폼보드·130 포맥스보드에 R_DEMO_MATSIZ 데모 COMMIT됨(undo=`_foundation/batch/wiring/constraint-demo-260702-undo.sql`). 구조 계약·한계는 [[constraint-builder-contract-demo-260702]].
