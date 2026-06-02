---
name: huni-widget-qa
description: >
  후니 인쇄 자동견적 위젯의 통합 정합성을 경계면 교차 비교로 검증하는 QA 스킬. API↔훅, 캡처데이터↔구현, DESIGN.md↔렌더, 동작명세↔구현, Edicus프로토콜↔핸들러의 shape 일치를 모듈 완성 직후 점진적으로 검증한다.
  '위젯 QA', '경계면 검증', '정합성 검증', '위젯 통합 테스트', 'API 훅 shape 비교', 'DESIGN 규칙 검증', 'Edicus 프로토콜 검증' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, mcp__claude-in-chrome__*
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-02"
  tags: "huni, widget, qa, integration, boundary-test, design-system, incremental"
---

# Huni Widget — QA Skill

## 목적

`hw-qa`가 위젯 구현의 경계면 정합성을 검증한다. 핵심 통찰: 결함은 대개 "각 모듈은 멀쩡한데 경계면 shape이 안 맞을 때" 발생한다. 따라서 "파일 존재 확인"이 아니라 **"경계면 교차 비교"**가 본질이며, 전체 완성 후가 아니라 **모듈 완성 직후 점진적으로** 검증한다(빠른 피드백 + 결함 조기 격리).

## 경계면 교차 비교 매트릭스

각 경계면에서 "한쪽이 생산하는 shape"과 "다른 쪽이 소비하는 shape"을 동시에 읽고 비교한다.

| 경계면 | 생산측 | 소비측 | 검증 항목 |
|--------|--------|--------|----------|
| API ↔ 훅 | api-contract.md 응답 타입 | 위젯 fetch 훅 기대 타입 | 필드명·타입·optional·중첩 일치 |
| 캡처 ↔ 구현 | body-log.json 실응답 | 구현 파서/매퍼 | 실데이터로 파싱 성공·null 처리 |
| DESIGN ↔ 렌더 | DESIGN.md 8 Rules·토큰 | 실제 렌더 DOM/CSS | 선택상태·색·치수·폰트·자간 |
| 동작명세 ↔ 구현 | 02_analysis 시퀀스·캐스케이드 | 구현 이벤트/상태 | 호출 순서·상태전이·제약 적용 |
| Edicus ↔ 핸들러 | editor-bridge-protocol.md | postMessage 핸들러 | origin 검증·페이로드 키·라이프사이클 |

## 검증 방법

1. **정적 shape diff**: 명세 타입 vs 구현 타입을 동시에 읽고 필드 단위 비교. 불일치는 파일:라인으로 기록
2. **실데이터 구동**: `body-log.json` 실응답을 구현 파서에 통과시켜 런타임 검증(스크립트 실행)
3. **라이브 비교**: widget_monitor(localhost:3001) 레퍼런스 동작 vs 후니 위젯 동작을 claude-in-chrome으로 비교
4. **DESIGN 실측**: 렌더된 DOM의 computed style을 8 Critical Rules와 대조

## 점진적 QA 루프

```
hw-builder 모듈 완성 통지 → 해당 경계면만 즉시 검증 → 결함을 SendMessage 회신
(파일:라인 + 기대 shape + 실제 shape + 재현법) → builder 수정 → 재검증
```

전체 완성을 기다리지 않는다. 컴포넌트/가격엔진/에디터 브리지 각각 완성 시점에 검증.

## 산출물 (`_workspace/huni-widget/05_qa/`)

- `qa-report.md`: 경계면별 PASS/FAIL + 증거 + 결함 목록(심각도 Critical/High/Med/Low)
- `boundary-matrix.md`: 각 경계면 셀에 기대 vs 실제 shape
- `regression-checklist.md`: DESIGN.md 8 Critical Rules 실측 결과

## 작업 규칙

- 결함은 증거(실행 출력·shape diff·스크린샷)로 입증. 추정 금지
- FAIL 보고는 재현법·기대값·실제값·파일:라인 포함 (builder가 바로 수정 가능하게)
- 통과 합리화 금지 — 회의적 검증가로서 결함을 적극적으로 찾는다
- 명세 자체 결함(공백·모순)은 구현 결함과 구분하여 hw-architect에 보고

## DESIGN.md 8 Critical Rules 체크 (필수)

RULE-1 native select 금지 / RULE-2 선택=흰배경+보라테두리 2px / RULE-3 CounterInput 3-part / RULE-4 ColorChip 50×50 원형 / RULE-5 옵션 라벨 동적(하드코딩 금지) / RULE-5-EXT PriceSlider Radix / RULE-6~8-EXT 칩 ring·grid / 공통 Noto Sans -5%.
