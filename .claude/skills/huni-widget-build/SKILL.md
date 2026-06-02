---
name: huni-widget-build
description: >
  후니 인쇄 자동견적 위젯을 React-in-Shadow-DOM 임베드 위젯으로 구현하는 패턴 스킬. Custom Element + React createRoot(shadowRoot) 마운트, Tailwind adoptedStyleSheets 주입, 14 componentType↔shadcn 매핑, Zustand 옵션 캐스케이드, Edicus postMessage 브리지, 가격엔진을 동작 코드로 만든다.
  '위젯 구현', '위젯 빌드', 'Shadow DOM 위젯 구현', 'React 위젯 마운트', 'Tailwind 격리', '옵션 컴포넌트 구현', '가격엔진 구현', 'Edicus 브리지 구현' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-02"
  tags: "huni, widget, react, shadow-dom, tailwind, shadcn, zustand, edicus, build"
---

# Huni Widget — Build Skill

## 목적

`hw-builder`가 03_spec 명세를 동작하는 후니 위젯으로 구현한다. widget_monitor가 동작 검증한 패턴(Shadow DOM 마운트 + Edicus createProject + from-edicus postMessage)을 후니 React 스택으로 재현한다.

## 핵심 구현 패턴

### 1. Custom Element + React in Shadow DOM

위젯은 호스트 사이트 어디든 삽입 가능한 Custom Element. shadowRoot에 React를 마운트하여 스타일/스크립트를 호스트와 격리한다(Red가 Vue3로 한 것의 React판). 이유: 호스트 페이지 CSS 충돌 방지 + 멀티 인스턴스 안전.

```
class HuniWidget extends HTMLElement {
  connectedCallback() {
    const shadow = this.attachShadow({ mode: 'open' });
    // Tailwind 스타일시트를 adoptedStyleSheets로 주입 (아래 2번)
    const mount = document.createElement('div');
    shadow.appendChild(mount);
    createRoot(mount).render(<App pdtCode={this.getAttribute('pdt')} />);
  }
}
customElements.define('huni-widget', HuniWidget);
```

### 2. Tailwind를 Shadow DOM에 주입 (핵심 난제)

Shadow DOM은 전역 CSS가 침투하지 않으므로 Tailwind 빌드 결과를 `CSSStyleSheet` + `adoptedStyleSheets`로 주입한다. CSS 변수(디자인 토큰)는 `:host`에 선언. 폰트(Noto Sans)는 document head에도 로드(@font-face는 shadow 경계 통과).

이유: `<link>` 삽입보다 adoptedStyleSheets가 FOUC 없고 인스턴스 간 공유 가능.

### 3. 14 componentType ↔ shadcn 매핑

DESIGN.md 8 Critical Rules를 코드 제약으로 적용:
- 선택 상태 = `bg-white border-2 border-[#553886] text-[#553886]` (컬러 채움 금지)
- SelectBox = custom dropdown (native `<select>` 금지), `▼` 텍스트 캐럿
- CounterInput = 직사각형 3-part (원형/스피너 금지)
- ColorChip = 50×50 원형, 선택 시 흰채움+보라 ring 2px
- PriceSlider = `@radix-ui/react-slider` (native range 금지)
- 옵션 라벨/값 = DB/API 동적 주입 후 `.map()` (하드코딩 금지)
- 폰트 = Noto Sans, 자간 -5%

### 4. Zustand 상태 + 옵션 캐스케이드

Red 5 Pinia 스토어 대응 Zustand 스토어. 옵션 변경 시 캐스케이드 제약(material→pcs disable) 적용 후 가격 재계산 트리거. 호스트와 격리(전역 store 싱글톤 금지, 인스턴스별).

### 5. 가격엔진

옵션 변경 → debounce(300ms) → 캐시(TTL) 확인 → 미스 시 가격 API(ORD_INFO+PCS_INFO) 호출 → 가격 분해 표시. 매 변경 즉시 호출 금지(Red 대비 후니 성능 개선점).

### 6. Edicus 브리지

Edicus SDK `createProject(psCode, templateUrl)` + KOI passive config. `window.addEventListener('message', ...)`로 `from-edicus` 수신하되 **반드시 origin 검증**. 라이프사이클: save-doc-report → goto-cart. 토큰 갱신 처리.

## 작업 규칙

- build-plan.md의 파일 트리·우선순위(High→Med→Low) 순서로 구현
- 명세에 있는 것만 구현 — 요청되지 않은 추상화·미래 대비 금지 (단순성)
- 명세에 없는 인접 코드 수정 금지 (스코프 규율)
- `.env.local` 키만 참조, 비밀값 하드코딩·커밋 금지
- 구현 후 빌드/타입체크 실행하여 통과 증거 확보

## 라이브러리 문서

React 18/19·shadcn·Radix·Zustand·Tailwind는 Context7 우선 조회(resolve-library-id → get-library-docs), 불가 시 공식문서 WebFetch. Shadow DOM + adoptedStyleSheets + Tailwind 통합은 검증된 레시피 우선.

## 어댑터 레이어 + fixture 구현 (컨버전 무손실)

후니 DB 미정 상태이므로 위젯은 **정규화 계약**(`data-contract.md`)에만 의존하고, 데이터는 **어댑터**(`data-adapter.md`)를 거쳐 주입한다.

- 위젯 컴포넌트·훅·스토어는 정규화 타입만 import. Red 원시 필드(PCS_COD/MTRL_CD 등) 직접 참조 금지
- Red 어댑터: `raw/widget_monitor/local/body-log.json` 등 캡처 응답 → 정규화 계약으로 변환하여 fixture 제공
- 구현·검증은 이 fixture로 수행 (위젯이 실데이터로 동작함을 입증)
- 컨버전: DB 확정 시 후니 어댑터만 작성·교체 → 위젯 코드 불변. 데이터 소스 토글(fixture↔실 BFF)은 환경설정/주입으로 분리
- 이 구조가 깨지면("위젯이 Red shape에 직접 의존") 컨버전이 재작성이 되므로 빌드 시 최우선 준수

## 동작 비교 기준

구현 동작은 `raw/widget_monitor/local` 레퍼런스(localhost:3001)와 비교하여 옵션·가격·에디터 흐름이 동등 이상인지 확인한다.
