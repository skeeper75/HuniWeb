# React-in-Shadow-DOM 베스트프랙티스 (마운트·Tailwind/shadcn 주입·함정)

> 파이프라인 ② 산출물. React 18/19 + Tailwind + shadcn를 Shadow DOM에 격리 마운트하는 검증된 패턴 + 함정 + 코드 스케치.
> 기준선: RedPrinting은 Vue3+Pinia를 Shadow DOM에 마운트(`widget-runtime-spec.md` §2~3). 후니는 React+Zustand로 동일 구조 재현(`DESIGN.md`: Zustand store 의무).
> 모든 인용은 WebFetch 검증 URL만. 출처는 하단 `Sources:`.

---

## 1. React를 Shadow Root에 마운트 (React 18 createRoot)

검증된 핵심 패턴 [Gourav-React]:

```js
// 1) 컨테이너 + Shadow Root
const container = document.createElement("div");
const shadowRoot = container.attachShadow({ mode: "open" });

// 2) createRoot에 "shadowRoot 자체"를 컨테이너로 전달
import { createRoot } from "react-dom/client";
const root = createRoot(shadowRoot);   // 일반 DOM 노드가 아닌 shadowRoot
root.render(<HuniWidget />);
```

핵심: `createRoot()`에 일반 DOM 노드 대신 **shadowRoot를 직접 전달**하면 React 트리가 Shadow 경계 안에 캡슐화된다. "If you render React element(s) inside a shadow DOM, the React element(s) won't inherit any styles from the page CSS" [Gourav-React]. 이는 RedPrinting의 `#shadow-root(open) > #red-widget-root(Vue App)` 구조의 React 등가물이다.

언마운트: `root.unmount()` 호출 후 Shadow Host 제거 → 멀티 인스턴스/리로드 시 메모리 누수 방지.

### 라이브러리 옵션: react-shadow-scope

보일러플레이트를 줄이려면 `react-shadow-scope` 사용 가능 [react-shadow-scope]. 제공:
- `<Scope>`: 일반 엘리먼트에 Shadow Root 부착, stylesheet 문자열/CSSStyleSheet 수용, 상속 스타일 차단
- `<Template>`: declarative shadow DOM + `adoptedStyleSheets` prop
- `css` 태그드 템플릿: 재사용 CSSStyleSheet 캐싱(런타임 오버헤드 감소)
- `<Tailwind>` 컴포넌트: 기본 `/tailwind.css` fetch + 전역 캐시 (빌트인 Tailwind 지원)
- SSR: 서버에서 `css`는 문자열(`<style>`), 하이드레이션 후 CSSStyleSheet로 변환
- `FormControl`: Shadow DOM form ↔ 부모 form 브리지 (Section 5 form 함정 대응)

**후니 권고 (Priority Medium)**: 후니 위젯은 임베드(CSR)가 기본이고 SSR 불필요하므로, 직접 `createRoot(shadowRoot)` + 수동 `adoptedStyleSheets` 제어가 의존성 최소화 측면에서 우선. `react-shadow-scope`는 멀티 인스턴스·선언적 Tailwind 주입이 번거로워지면 채택 검토(폴백). 두 경로 모두 동일한 `adoptedStyleSheets` 기반.

## 2. Tailwind를 Shadow DOM에 주입 — adoptedStyleSheets

호스트 `<head>`의 Tailwind stylesheet는 Shadow DOM 내부에서 접근 불가 [Gourav-TW]. 따라서 컴파일된 Tailwind CSS를 **Constructable Stylesheet로 만들어 shadowRoot.adoptedStyleSheets에 주입**한다.

검증된 API [MDN-adopted]:
```js
// 빌드 시 생성된 Tailwind CSS 문자열을 인라인 import (Vite ?inline 등)
import tailwindCss from "./widget.css?inline";

const sheet = new CSSStyleSheet();
sheet.replaceSync(tailwindCss);
shadowRoot.adoptedStyleSheets = [sheet];
```

검증된 특성 [MDN-adopted]:
- `adoptedStyleSheets`는 `CSSStyleSheet()` 생성자로 만든 배열을 받음. 스타일시트는 shadow root의 부모 `Document` 컨텍스트에서 생성돼야 함.
- **동일 constructed stylesheet를 여러 ShadowRoot가 공유 가능** → 멀티 위젯 인스턴스에서 단일 시트 재사용(메모리 효율). 시트 변경은 모든 채택 객체에 반영.
- 카스케이드: adopted sheet는 `ShadowRoot.styleSheets`(일반 `<style>`/`<link>`) **뒤에** 적용된 것으로 취급.
- 브라우저 지원: **Baseline Widely available (2023-03 이후)** — 모던 브라우저 전반 안정.

대안: `react-shadow-scope`는 내부적으로 `cssom(new CSSStyleSheet())` + `adoptedStyleSheets` 사용 [Gourav-TW][react-shadow-scope]. 폴리필(`construct-style-sheets-polyfill`)은 구형 Safari/Firefox용이나 Baseline 2023+ 환경에서는 대개 불필요.

**후니 권고 (Priority High)**:
- 빌드 시 Tailwind를 **하나의 CSS 문자열로 컴파일** → Vite library mode `?inline` import → `replaceSync` → 단일 constructed sheet를 **모든 위젯 인스턴스 shadowRoot가 공유**.
- shadcn 컴포넌트는 Tailwind 클래스 기반이므로 동일 시트로 커버. shadcn의 CSS 변수(`--background`, `--primary` 등)는 `:host`에 정의(Section 4).

## 3. CSS 변수 전파·preflight·폰트

- **preflight/normalize**: Tailwind preflight는 `*` 셀렉터 기반이라 Shadow DOM 내부에 그대로 주입되며 외부로 누출되지 않음(경계 격리). `react-shadow-scope`는 normalize를 `@layer`로 낮은 우선순위 주입 [react-shadow-scope].
- **rem/line-height 상속 함정**: Shadow DOM은 부모의 `font-size`·`line-height`를 **상속**한다 [Gourav-TW]. 호스트가 `font-size: 12px`면 위젯의 rem 단위가 전부 틀어진다. 대응 — `:host { font-size: 16px; line-height: 1.5; all: initial; }` 류로 컨테이너 기준값을 명시 고정.
- **CSS 변수**: shadcn 테마 토큰(`--primary` 등)은 `:host` 또는 Shadow Root 최상위 셀렉터에 정의 → Shadow 내부 전체 전파. 호스트→위젯 테마 주입이 필요하면 호스트가 CSS 변수를 Shadow Host 엘리먼트에 설정(상속 가능 변수만 경계 통과).
- **폰트**: `@font-face`를 adopted sheet에 포함하거나 Shadow Root 내부 `<style>`로 인라인. 한글 웹폰트는 subset + `font-display: swap`. 호스트 `<head>` 폰트에 의존 금지(`bp-embed-widget.md` §6).

## 4. shadcn-in-Shadow 스케치

```js
// widget-entry.tsx
import tailwindCss from "./index.css?inline";   // @tailwind + shadcn 변수 포함
import { createRoot } from "react-dom/client";

export function mountHuniWidget(host: HTMLElement, opts: WidgetOptions) {
  const shadowRoot = host.attachShadow({ mode: "open" });

  const sheet = new CSSStyleSheet();
  sheet.replaceSync(tailwindCss);                 // preflight + shadcn :host 변수 + utilities
  shadowRoot.adoptedStyleSheets = [sheet];

  const mountPoint = document.createElement("div");
  mountPoint.id = "huni-widget-root";
  shadowRoot.appendChild(mountPoint);

  const root = createRoot(mountPoint);            // shadowRoot 직접도 가능, 포털 타깃 명확화 위해 내부 div 권장
  root.render(<HuniWidget {...opts} />);
  return () => { root.unmount(); host.shadowRoot && host.remove(); };
}
```

`index.css`에 `:host { --primary: ...; font-size:16px; line-height:1.5; }` + `@tailwind base/components/utilities`.

## 5. 함정 — 이벤트 리타게팅·포털·오버레이·a11y

| 함정 | 원인 | 대응 |
|------|------|------|
| **포털 오버레이가 Shadow 밖으로 탈출** | shadcn Dialog/Popover/Select는 React Portal로 `document.body`에 렌더 → Shadow 밖이라 **adopted Tailwind 스타일 미적용**(스타일 깨짐) | 포털 컨테이너를 **Shadow Root 내부 노드로 지정**. Radix(shadcn 기반)는 `Portal container` prop 제공 → `container={shadowRoot.querySelector('#huni-widget-root')}` 주입. 이것이 후니 위젯 최대 함정. |
| **이벤트 리타게팅** | Shadow 경계를 넘는 이벤트는 `event.target`이 Shadow Host로 리타게팅됨. 호스트 페이지의 전역 리스너는 위젯 내부 실제 타깃을 못 봄 | 위젯 내부 이벤트는 Shadow 내부에서 처리(React 트리 안). 호스트 통합은 명시적 CustomEvent/콜백으로(`composed: true` 필요 시 명시). RedPrinting 브릿지 함수군(`sdkOptionChange` 등, `widget-runtime-spec.md` §6)이 이 경계 처리 담당. |
| **React 합성 이벤트** | React 18은 root 컨테이너에 이벤트 위임 → shadowRoot에 마운트 시 위임 루트도 Shadow 내부 → 정상 동작 | `createRoot(shadowRoot)` 또는 내부 div에 마운트하면 React 이벤트 위임이 Shadow 안에서 닫혀 정상. (React 16 시절 document 위임 버그는 18에서 해소) |
| **focus 관리** | Shadow 경계 넘는 focus·`delegatesFocus` | 모달/에디터 오버레이는 Shadow 내부 포털 컨테이너 + focus trap을 Shadow 내부에 둠 [Smashing: delegatesFocus]. |
| **a11y (ARIA 참조)** | `aria-labelledby`/`aria-controls`는 **ID 참조가 Shadow 경계를 넘지 못함** | label과 control을 같은 Shadow 트리 안에 배치. 위젯 내부 완결 구조 유지. |

**후니 권고 (Priority High)**: shadcn의 Dialog/Select/Popover/Tooltip은 **반드시 Radix `Portal container`를 Shadow Root 내부로 지정**. 가격 표시·옵션 캐스케이드 UI는 Select/Popover를 많이 쓰므로(14 componentType) 이 설정 누락 시 전 UI 스타일 붕괴. Edicus 에디터 오버레이도 Shadow 내부 컨테이너에 마운트(`bp-editor-integration.md` 연계).

## 6. 상태관리 — Zustand 임베드·호스트 격리

`DESIGN.md`는 데이터 우선순위 `Option Schema API → Zustand store → props`를 의무화. RedPrinting은 Pinia 스토어 4~5개(config/product/order|acc-order/exterior, `widget-runtime-spec.md` §3)를 Shadow 내부에 둔다. 후니 Zustand 매핑:

- 스토어를 **위젯 인스턴스 스코프**로 생성(전역 싱글톤 금지) → 멀티 인스턴스/호스트 전역과 격리. `createStore` 인스턴스를 React Context로 위젯 트리에 주입.
- 토큰(JWT)·세션은 스토어 메모리에만 보관, DOM 미노출(`bp-embed-widget.md` §6).
- Red의 상품군별 스토어 분기(책자=order, 부자재=acc-order)는 후니에서 정규화 계약 + 어댑터로 흡수(컨버전 전략).

## 7. 후니 채택 결론

| 결정 | 권고 | Priority |
|------|------|----------|
| 마운트 | `createRoot(내부 div in shadowRoot)`, 수동 제어 | High |
| Tailwind 주입 | `?inline` CSS → `CSSStyleSheet.replaceSync` → 인스턴스 공유 `adoptedStyleSheets` | High |
| shadcn 포털 | Radix `Portal container`를 Shadow 내부로 지정 (최대 함정) | High |
| rem/폰트 | `:host` 기준값 고정 + 폰트 인라인 주입 | High |
| 상태 | Zustand 인스턴스 스코프, 토큰 메모리 격리 | High |
| 라이브러리 | 직접 제어 우선, react-shadow-scope는 폴백 | Medium |

---

## Sources:

- [Gourav-React] Render React element inside shadow DOM in React v18 — https://gourav.io/blog/render-react (WebFetch 검증: createRoot(shadowRoot) 패턴·page CSS 미상속)
- [Gourav-TW] Add Tailwind styles to shadow DOM — https://gourav.io/blog/tailwind-in-shadow-dom (WebFetch 검증: adoptedStyleSheets+CSSStyleSheet·rem/line-height 상속 함정·preflight·폴리필)
- [MDN-adopted] ShadowRoot.adoptedStyleSheets — https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/adoptedStyleSheets (WebFetch 검증: API·replaceSync·멀티 ShadowRoot 공유·카스케이드 순서·Baseline 2023-03)
- [react-shadow-scope] jonathandewitt-dev/react-shadow-scope — https://github.com/jonathandewitt-dev/react-shadow-scope (WebFetch 검증: Scope/Template/css/Tailwind 컴포넌트·SSR·FormControl·normalize @layer)
- [Smashing] Web Components: Working With Shadow DOM (2025-07) — https://www.smashingmagazine.com/2025/07/web-components-working-with-shadow-dom/ (WebFetch 검증: delegatesFocus·form 미연결/ElementInternals)
