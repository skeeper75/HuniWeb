# Huni-Constraint-Rules 변경 이력 (최신이 위)

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-07-02 | **첫 종단 실행 완료 — wave-1 파일럿 COMMIT + 실화면 4항 PASS.** ① Phase 1: 297 활성상품 전수 CN 체크(후보 35·CN-2 확정=129/130뿐·CN-5 High 19·옵션그룹 오용 "그룹 폭발"은 실재하지 않음—실체는 명명 비일관→§12 라우팅) ② Phase 2: 구 R_DEMO_MATSIZ가 실제 RAW-ONLY(빌더 역파싱 불가)임을 실증→자재별 8규칙 분할 재설계(단가행 자동 유도·오차단 0)·wave-2 CN-5 19건 전건 BLOCKED-UI(폼빌더 수치범위 조건 미지원=C-9 High 신설)·058 RULE_001 죽은 규칙 3중 결함→사용자 지시 "테스트 중이니 유지" ③ Phase 3: CR1~CR7 전 게이트 GO(병합 규칙집합 16셀 전수 평가·역파서 독립 재구현 대조) ④ Phase 4~5: 인간 승인→COMMIT(UPDATE 2+INSERT 8)→gstack 실화면 4항(역파싱·표시·조정·막힘/통과) 양 상품 PASS·스크린샷 10장·undo/백업 보유. ★registrar가 최종 보고 직전 API 오류로 중단→오케스트레이터가 라이브 재실측으로 완료 확정(ui-verify·postverify 보완) ⑤ 개발자 전달 확정본 산출(05_gate/dev-handoff-final.md — High 4·Med 3·Low 2·시각화 4·강제 로드맵 5·핵심="제약 레이어는 가격·주문 어디에도 연결 안 됨") | 전체 | 첫 실행 |
| 2026-07-02 | 하네스 초기 구성 — 에이전트 5(hcr-scenario-curator·hcr-cpq-researcher·hcr-rule-designer·hcr-gate-validator·hcr-ui-registrar) + 스킬 5(오케스트레이터·scenario-spec·rule-authoring·ui-register-verify·gate-validation). CN-1~CN-6 필요상황 분류·CR1~CR7 게이트·UI 역파싱 정형 shape [HARD]·파일럿=129/130 데모 수정 | 전체 | 사용자 요청: 전 상품 제약규칙을 UI-확인가능 형태로 등록 + 옵션그룹 오용 해소 + CPQ 베스트프랙티스 개발자 전달 |

## 진행 상태 스냅샷
- 하네스 구축 완료, 첫 실행 전. 다음 시작점 = `huni-constraint-rules-orchestrator` 실행(Phase 1 팬아웃 → 129/130 파일럿).
- 선행 사실(재발견 금지): 129 폼보드·130 포맥스보드에 R_DEMO_MATSIZ 데모 COMMIT됨(undo=`_foundation/batch/wiring/constraint-demo-260702-undo.sql`). 구조 계약·한계는 [[constraint-builder-contract-demo-260702]].
