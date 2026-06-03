---
name: huni-widget-design-fidelity
description: >
  이미 빌드된 후니 인쇄 자동견적 위젯(04_build)의 외형을 후니 디자인에 픽셀 단위로 정합시키는 시각재현 방법론 스킬.
  레이아웃·옵션 캐스케이드·인터랙션 흐름은 RedPrinting 구조 권위를 보존하고, 색·폰트·간격·컴포넌트 외형만 후니 스킨(huni-design-system 스펙 + DESIGN.md)으로 입힌다.
  베이스라인 스크린샷·computed style 추출 → 후니 기준 대조 → 외형 레벨 스킨 정합 → 구조 무변경 회귀 가드 → 스크린샷 diff + 수치 재대조 절차를 제공한다.
  '위젯 시각재현', '시각 정합', '디자인 정합', 'Figma 시각재현', '후니 스킨 입히기', 'DESIGN.md 정합', '스크린샷 diff', 'computed style 대조', '외형 정합', '픽셀 정합' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, mcp__claude-in-chrome__*, mcp__pencil__batch_get, mcp__pencil__get_screenshot, mcp__pencil__open_document, mcp__pencil__get_variables
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-03"
  tags: "huni, widget, design-fidelity, visual, screenshot-diff, design-system, figma, redprinting"
---

# Huni Widget — 시각재현 정합 방법론

기능은 동작하는 위젯에 **후니 비주얼을 입히는** 단계의 표준 절차. 핵심 전제: `04_build`는 이미 React-in-Shadow-DOM으로 빌드되어 있고 토큰도 일부 반영되어 있다. 따라서 백지 재작성이 아니라 **벌어진 외형을 재서 좁히는 정합**이다.

## 불변 규칙 — 권위 분리

이 하네스의 가장 중요한 규칙이다. 정합 중 판단이 막히면 항상 이 표로 돌아온다.

| 영역 | 권위 | 출처 |
|------|------|------|
| 배치 · 옵션 캐스케이드 · 인터랙션 흐름 · 상태 전이 | **Red 구조** (보존, 변경 금지) | `02_analysis/sequence-diagrams.md`, `cascade-rules.md`, `state-machine.md` |
| 색 · 폰트 · 간격 · radius · 컴포넌트 외형 · 선택상태 표현 | **후니 스킨** (입힘) | huni-design-system 스킬, `_workspace/print-quote/04_design/DESIGN.md` |

**왜 분리하는가:** Red 구조는 widget_monitor 라이브 테스트베드로 동작이 검증된 자산이다. 외형을 입히려다 구조를 건드리면 검증된 동작이 깨진다. 외형(스킨)과 구조(골격)를 분리해 두면 한쪽을 바꿔도 다른 쪽이 안 깨진다 — 이것이 정규화 계약·어댑터 전략과 같은 결의 안전장치다.

**회색지대 해소:** 배치가 애매하면 Red, 외형이 애매하면 후니 스펙. 후니 시안 레이아웃이 Red와 다르면 Red 구조를 따르고 후니 외형만 적용한 뒤 충돌을 `conflicts.md`에 출처 병기로 기록한다. 임의 판단·삭제 금지.

## 정합 5단계

### 1. 베이스라인 측정

현 위젯을 실제로 렌더하고 컴포넌트별 현황을 수치로 잡는다. 추정 금지 — 렌더된 실제 DOM의 computed style을 읽는다.

- 렌더 경로: `04_build` 의 dist 또는 widget-loader로 Shadow DOM 마운트(`index.html` 참조). 필요 시 `npm run build`/`vite preview`.
- 컴포넌트별 스크린샷을 `06_fidelity/captures/before/`에 저장.
- Shadow DOM 내부 요소의 computed style(color·font-family·font-size·line-height·padding·margin·gap·border-radius·선택상태 배경/보더)을 덤프. Shadow root를 관통해 읽어야 하므로 `element.shadowRoot` 또는 위젯이 노출한 훅을 사용한다.

### 2. 후니 기준 대조

huni-design-system 스펙에서 해당 componentType의 정밀값을 가져와 위젯 실측과 나란히 표로 만든다.

- 후니 진실 소스: huni-design-system 스킬(`Skill` 로 호출하거나 플러그인 스킬 본문 참조) — 14컴포넌트·26섹션의 픽셀 측정값·색·타이포.
- DESIGN.md: 토큰(색 팔레트·타이포 스케일·spacing)과 8 Critical Rules.
- 대조 표 한 행 = {컴포넌트, 속성, 위젯 실측, 후니 기준, 편차, 판정}. 편차가 토큰/규칙 위반이면 정합 대상.

### 3. 스킨 정합 (외형만)

벌어진 항목만 외형 레벨로 수정한다. **수정 가능 범위를 엄격히 제한한다.**

| 수정 가능 (스킨) | 수정 금지 (구조 = Red 권위) |
|------------------|------------------------------|
| tailwind.config 토큰, CSS 변수 | DOM 트리 구조, flex/grid 골격 |
| className(색·간격·폰트·radius 유틸) | 이벤트 핸들러, 옵션 캐스케이드 로직 |
| 스타일 prop, 선택상태 표현 토큰 | 상태관리(store), API 호출 시퀀스 |
| 컴포넌트 외형 변형(variant) prop | 컴포넌트 배치 순서·계층 |

후니 스펙에 없는 컴포넌트는 임의 디자인 금지 — 갭으로 보고한다.

### 4. 회귀 가드 (구조 무변경 증명)

외형 정합이 검증된 Red 동작을 깨지 않았음을 증명한다.

- `git diff` 로 구조 변경 0줄 확인: 옵션 캐스케이드·상태관리·핸들러·배치 로직에 변경이 없어야 한다(외형 토큰/스타일/className만 변경).
- hw-qa의 경계면 매트릭스(동작 명세↔구현)가 정합 전후 동일한지 교차 확인 요청.
- 빌드/타입체크/테스트가 정합 후에도 통과하는지 확인.

### 5. 시각 검증

- AFTER 스크린샷을 `06_fidelity/captures/after/`에 저장하고 후니 기준 이미지와 나란히 diff.
- computed style을 스펙 수치와 재대조하여 잔존 편차를 `fidelity-report.md`에 정량 기록.
- 경계면(시각): 선택상태·hover·disabled 등 상태별 외형이 후니 스펙과 일치하는지 상태 전이마다 확인.

## 산출물 (`_workspace/huni-widget/06_fidelity/`)

| 파일 | 내용 |
|------|------|
| `fidelity-report.md` | 컴포넌트별 BEFORE/AFTER 실측 + 잔존 편차 + 스크린샷 경로 + 회귀 가드 결과 |
| `skin-mapping.md` | 위젯 componentType ↔ 후니 디자인 컴포넌트 매핑(토큰·외형 정밀값) |
| `conflicts.md` | Red 구조 vs 후니 시안 충돌(출처 병기 + 적용한 해소 규칙) |
| `captures/before/`, `captures/after/` | 스크린샷, computed style 덤프 |

## 검증 도구 메모

- **스크린샷·렌더**: `mcp__claude-in-chrome__*` 로 실제 브라우저에서 위젯을 띄워 Shadow DOM을 관통한 시각·computed style을 얻는다(가장 신뢰도 높음).
- **.pen 참조(옵션)**: 후니 시안 원본을 시각 대조해야 하면 `mcp__pencil__open_document` + `get_screenshot` 으로 .pen 렌더를 얻는다. 단 진실 소스의 1순위는 huni-design-system 추출 스펙(결정적 수치)이고, .pen은 보조 시각 확인용이다.
- **computed style 덤프**: Shadow root 관통이 핵심. `el.shadowRoot.querySelector(...)` 후 `getComputedStyle`. 위젯이 디버그 훅을 노출하면 그것을 우선 사용.

## 주의 (왜 이렇게 하는가)

- **1px 강박 금지**: 목표는 후니 토큰·8 Critical Rules 일치이지 스크린샷 완전 동일이 아니다. 토큰이 맞으면 미세 렌더 차이는 허용한다.
- **구조를 건드리는 순간 스코프 이탈**: "외형 고치다 보니 배치도 손봤다"는 이 하네스에서 가장 위험한 안티패턴이다. 배치 변경이 정말 필요하면 hw-architect/Red 구조 권위로 에스컬레이트한다.
- **후니 스펙이 비면 디자인하지 말고 보고**: 진실 소스에 없는 외형을 창작하면 진실 소스가 둘이 된다.
