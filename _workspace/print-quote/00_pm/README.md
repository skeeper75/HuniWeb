# Print Quote PM Workspace

이 디렉토리는 pq-pm이 Phase 1에서 자동 생성하는 PM 산출물 위치입니다.

오케스트레이터 실행 시 다음 파일이 자동 생성됩니다:

- `milestones.md` — M1~M5 마일스톤
- `raci.md` — 책임 매트릭스
- `task-graph.md` — 의존성 그래프
- `decisions.md` — 의사결정 로그(ADR 경량)
- `status.md` — 진행 상태
- `consistency-report.md` — 교차검증 결과

오케스트레이터 호출:
```
Skill("print-quote-orchestrator")
```
또는 자연어: "후니프린팅 자동견적 사이트 설계 시작"
