---
name: huni-widget-spec
description: >
  후니 인쇄 자동견적 위젯의 구현 명세를 작성하는 표준 스킬. 컴포넌트 트리·상태관리·가격엔진·Shadow DOM 격리·Edicus 연동·API 계약·번들 전략을 구현 가능한 단일 청사진으로 정리한다.
  '위젯 명세 작성', '위젯 아키텍처 설계', '컴포넌트 트리 설계', '가격엔진 명세', 'API 계약 작성', 'Shadow DOM 전략', '구현 청사진' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-02"
  tags: "huni, widget, spec, architecture, react, shadow-dom, design-system"
---

# Huni Widget — Spec Skill

## 목적

`hw-architect`가 위젯 개발의 모든 요소를 `hw-builder`가 추측 없이 구현 가능한 수준으로 명세한다. 입력(역공학·동작분석·리서치·DESIGN.md)을 종합해 단일 소스 청사진을 산출한다.

## 확정 기술 결정

- **React-in-Shadow-DOM 임베드 위젯**: 내부 React 18/19 + shadcn/Tailwind, 격리 Shadow DOM
- RedPrinting이 Vue3를 Shadow DOM에 마운트한 패턴의 React판 (widget_monitor가 동작 검증)
- 상태관리: Zustand (Red 5 Pinia 스토어 대응)
- 에디터: Edicus SDK createProject + KOI passive + from-edicus postMessage

## 명세 작성 원칙

명세는 "왜"를 담아야 빌더가 엣지케이스에서 올바르게 판단한다. 강압적 지시보다 결정 근거를 전달한다.

| 원칙 | 설명 |
|------|------|
| 구현 가능 구체성 | 함수 시그니처·타입(TS)·엔드포인트·이벤트명 수준. "잘 처리한다" 같은 모호함 금지 |
| 단순성 강제 | 요청되지 않은 추상화·플래그·미래 대비 배제. 가장 단순한 동작 설계 우선 |
| 근거 표기 | 각 결정에 출처(역공학/동작분석/리서치/DESIGN.md). 미해결은 OPEN 항목 |
| DESIGN.md 규칙 내재화 | 8 Critical Rules를 컴포넌트 명세에 명시적 제약으로 반영 |

## 산출물 구조 (`_workspace/huni-widget/03_spec/`)

architecture / component-tree / state-management / price-engine / shadow-dom-strategy / editor-integration / api-contract / bundle-strategy / build-plan (각 파일 역할은 hw-architect 정의 참조).

## DESIGN.md 14 componentType ↔ shadcn 매핑 (필수 반영)

| # | componentType | DESIGN.md 규칙 | shadcn 기반 |
|---|--------------|---------------|-------------|
| 1 | OptionButton (RULE-2) | 선택=흰배경+보라테두리 2px, 155×50 | Button + 커스텀 variant |
| 2 | SelectBox (RULE-1) | native select 금지, ▼ 텍스트 캐럿, 348×50 | Popover/Command (custom) |
| 3 | CounterInput (RULE-3) | 직사각형 3-part 223×50, 원형/스피너 금지 | 커스텀 |
| 4 | ColorChip (RULE-4) | 50×50 원형, 선택=흰채움+보라 ring 2px | 커스텀 |
| 5 | PriceSlider (RULE-5) | @radix-ui/react-slider 필수, native range 금지 | Slider(Radix) |
| 6~8 | Image/Mini/LargeColorChip | ring-2 보라, 동적 색상 로드 | 커스텀 |
| 9 | AreaInput | 가로×세로 mm, X 구분자 | Input(custom) |
| 10 | PageCounterInput | ring-2 보라, min/max/step 동적 | 커스텀 |
| 11~12 | Finish Button/Select | RULE-1/2 동일 적용 | 위 재사용 |
| 13 | Summary | 합계 24px/600 보라 | 커스텀 |
| 14 | Upload CTA | 465×50, outline/filled/dark 3종 | Button variant |

> 옵션 라벨·값은 절대 하드코딩 금지(RULE-5) — DB/API 동적 주입 후 `.map()` 렌더. Noto Sans -5% 자간 전역.

## 정규화 계약 + 어댑터 레이어 (필수 — 컨버전 무손실 조건)

후니 DB는 미정이므로 위젯은 **정규화 계약(normalized contract)**에만 의존하고, 데이터 소스 차이는 어댑터가 흡수한다. 이유: Red shape(PCS_COD/MTRL_CD 등 자체 코드 체계)에 위젯을 직접 붙이면 후니 DB 컨버전 시 위젯 내부를 재작성해야 한다. 어댑터를 두면 컨버전이 "교체"가 되어 위젯 코드가 불변이다.

```
[Red 캡처 fixture] ──Red 어댑터──┐
                                  ├──▶ [정규화 위젯 계약] ──▶ [위젯(불변)]
[후니 DB/API(추후)] ─후니 어댑터──┘
```

- `data-contract.md`: 위젯이 소비하는 정규화 모델 — 옵션(componentType·라벨·값·단위)·캐스케이드 제약·가격분해·업로드. Red/후니 무관
- `data-adapter.md`: Red 캡처(body-log.json·option-schema)→정규화, 후니→정규화 매퍼 + 코드 체계 매핑표
- **컨버전 경로**: Red fixture로 구현·검증 → DB 확정 시 후니 어댑터 작성·교체 → 위젯 무변경
- 위젯/훅/컴포넌트는 정규화 타입만 import. Red 원시 필드명(PCS_COD 등) 직접 참조 금지

## 명세 체크리스트

- [ ] 컴포넌트 트리 + 14 componentType 매핑 완료
- [ ] Zustand 스토어 + 옵션 캐스케이드 + 셀렉터 정의
- [ ] 가격엔진(debounce 300ms/캐시 TTL) + API 계약(ORD_INFO+PCS_INFO)
- [ ] Shadow DOM에 Tailwind 주입(adoptedStyleSheets) + 폰트·CSS변수 전파 전략
- [ ] Edicus 브리지 + postMessage origin 검증
- [ ] BFF API 계약 + 후니 백엔드(Shopby/Neon) 매핑
- [ ] build-plan 구현 순서·우선순위(High/Med/Low) + OPEN 항목

## 라이브러리 문서

shadcn/Radix/Zustand/React 18+ 사용법은 Context7 우선(resolve-library-id → get-library-docs), 불가 시 공식문서 WebFetch. 명세에 버전 명시.
