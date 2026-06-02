# Huni Widget — 인쇄 자동견적 위젯 구현 하네스 작업공간

후니프린팅 인쇄 자동견적 위젯(React-in-Shadow-DOM)을 **역공학 보강 → 구현** end-to-end로 산출하는 하네스의 산출물 루트.

## 파이프라인 산출물 (단계별)

| 디렉토리 | 단계 | 담당 에이전트 | 내용 |
|---------|------|--------------|------|
| `01_reverse/` | ① 역공학 보강 | hw-reverse-engineer | 위젯 런타임·가격엔진·에디터 브리지·S3·옵션스키마 완성 명세 (라이브 검증) |
| `02_analysis/` | ② 동작 분석 | hw-runtime-analyst | 동작 구조·시퀀스 다이어그램·상태머신·캐스케이드·이벤트 계약 |
| `02_research/` | ② 베스트프랙티스 | hw-researcher | 임베드 위젯·Shadow DOM·실시간 가격 UX·에디터 통합 BP (출처 검증) |
| `03_spec/` | ③ 위젯 명세 | hw-architect | 컴포넌트 트리·상태관리·가격엔진·Shadow DOM 전략·API 계약·build-plan |
| `04_build/` | ④ 구현 | hw-builder (worktree) | React-in-Shadow-DOM 위젯 코드 |
| `05_qa/` | ⑤ QA | hw-qa | 경계면 교차 검증·DESIGN 규칙 체크 |

## 입력 자산 (read-only 참조)

- `docs/reversing/red_reverse_engineer/` — RedPrinting 위젯 역공학 (난독화 해제 86/100)
- `docs/reversing/*.html` — Widget/SDK 심층 분석 리포트 2종 (가격 API 실측 계약·브릿지 17함수·45 에디터 메서드). 정독 추출본: `01_reverse/seed-redprinting-sdk-analysis.md`
- `raw/widget_monitor/local/` — **동작 검증된 라이브 위젯 테스트베드** (`node server.js` → localhost:3001)
- `_workspace/print-quote/04_design/DESIGN.md` — 14 componentType 디자인 시스템
- `.env.local` — RedPrinting(RP_*)·Edicus·Shopby·Neon 자격증명

## 실행

오케스트레이터 스킬 `huni-widget-orchestrator` 가 6인 에이전트 파이프라인을 조율한다. "후니 위젯 구현", "위젯 하네스 실행" 등으로 트리거. 단계별 재실행·부분 갱신 지원.

## 규칙

- 중간 산출물 보존(감사 추적). 비밀값 평문 기록 금지
- 라이브 캡처는 저트래픽 안전 모드. 주문·결제·계정변경 API 호출 금지
- 모든 명세에 근거 표기: `[라이브 검증]` / `[정적 분석]` / `[추정]`
- **데이터 의존**: 후니 DB 미정 → 위젯은 정규화 계약(`03_spec/data-contract.md`)에만 의존. Red 캡처→정규화 어댑터(`data-adapter.md`)로 fixture 구현·검증 후, DB 확정 시 후니 어댑터 교체로 무손실 컨버전(위젯 코드 불변)
