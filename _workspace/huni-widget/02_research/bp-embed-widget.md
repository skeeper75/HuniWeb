# 임베드 위젯 베스트프랙티스 (Shadow DOM 격리·로더·버전관리)

> 파이프라인 ② 산출물. 국내외 베스트프랙티스 리서치 → 후니 React-in-Shadow-DOM 위젯 권고.
> 비교 기준선: RedPrinting 위젯(`#redWidgetSdk` Shadow Host + `#red-widget-root`, widget.js CloudFront 배포 — `01_reverse/widget-runtime-spec.md` §2).
> 모든 인용은 WebFetch로 본문 검증한 URL만 사용. 출처는 문서 하단 `Sources:`.

---

## 1. 핵심 원칙 — 위젯은 "남의 사이트에 얹힌 손님"

임베드 위젯의 제1원칙: **호스트 페이지를 절대 깨뜨리지 않는다.** MakerKit 가이드는 이를 "fail silently rather than breaking the host page. Your widget is a guest on someone else's site"로 명문화한다 [MakerKit]. 초기화·렌더·API 호출 전 구간을 try/catch로 감싸 위젯 내부 오류가 호스트로 전파되지 않게 한다.

이는 RedPrinting이 `productRedWidgetSDK.js`(33KB 브릿지)를 호스트-위젯 글루로 두고, 런타임(`widget.js`)을 Shadow DOM 안에 격리한 3계층 구조와 정확히 일치한다(`widget-runtime-spec.md` §1). 후니도 동일하게 **얇은 로더/브릿지 + 격리된 런타임** 2단 분리를 채택한다.

## 2. Shadow DOM 격리 — 양방향 스타일 차단

Shadow DOM은 `DocumentFragment` 안에 HTML·CSS를 캡슐화하여 컴포넌트 경계를 명확히 한다 [Smashing]. CSS 네임스페이싱은 호스트 페이지의 높은 specificity 규칙에 의해 덮어쓰일 수 있지만, **Shadow DOM은 hard boundary를 생성**하여 양방향(호스트→위젯, 위젯→호스트) 스타일 누출을 모두 차단한다 [MakerKit][Viget].

### open vs closed 모드

| 모드 | 특성 | 권고 |
|------|------|------|
| `open` | `element.shadowRoot`로 외부 스크립트가 내부 접근·디버깅 가능 | RedPrinting이 채택(`#shadow-root(open)`) |
| `closed` | 외부 introspection 차단, 민감정보(가격) 컴포넌트에 적합 | Smashing은 "closed-first" 권고 [Smashing] |

Smashing 2025는 "Make a habit of using closed mode unless you are debugging"을 권고하며, 특히 금융·가격 정보를 다루는 컴포넌트는 closed가 안전하다고 본다 [Smashing]. 다만 RedPrinting은 `open`을 채택했고, **개발/디버깅 편의 + Edicus 오버레이·a11y 도구 접근성**을 고려하면 트레이드오프가 있다.

**후니 권고 (Priority High)**: `mode: 'open'` 채택. 근거 — ① Red 검증 패턴과 정합 ② 가격은 클라이언트에서 계산되지 않고 서버 권위(`price-engine-reversed.md` §3)이므로 Shadow DOM 내부 노출이 곧 가격 룰 노출이 아님 → closed의 보안 이점이 후니 위젯에는 약함 ③ 개발/QA 시 `shadowRoot.querySelector` 디버깅 필요. 단, 토큰(JWT)은 DOM이 아닌 메모리 스토어에만 보관(Section 6 참조).

## 3. 로더 패턴 — 단일 script-tag + data-* 설정

검증된 표준 패턴 [MakerKit]:

```html
<script src="https://cdn.huni.example/widget/v1/loader.js"
        data-pdt-cod="PRBKYPR"
        data-locale="ko"></script>
```

- `document.currentScript`로 자신을 로딩한 `<script>` 참조 획득 → `getAttribute()` / `dataset`으로 설정 읽기 [MakerKit]. **로드 시점에 별도 API 호출 없이** 설정 전달 가능.
- Viget 패턴: 호스트가 타깃 div를 두고(`<div id="huni-widget-root">`), 로더가 `init({ rootId })`로 해당 노드에 `attachShadow({ mode: "open" })` [Viget].

**후니 권고**: RedPrinting은 `form#product_form` 내부에 `div#redWidgetSdk`를 두고 그 안에 Shadow Host를 마운트한다(`widget-runtime-spec.md` §2). 후니도 ① **명시적 마운트 노드 + init() API**(호스트가 위치 제어) 우선, ② data-* 자동 마운트는 단순 임베드용 폴백으로 제공. 설정은 `pdt_cod`, `locale`, 호스트 콜백 채널을 data-* 또는 init 인자로 받는다.

## 4. 번들 전략 — 경량 로더 + 동적 청크

검증된 번들 사이즈 목표 [MakerKit]:

| 기준 | 값 |
|------|-----|
| 기본 React + Tailwind 위젯 | ~45KB gzipped |
| 최대 임계 | < 100KB gzipped |
| 의존성 감사 트리거 | > 150KB |

권고 (Priority High):
- **2단 로딩**: 초경량 `loader.js`(설정 파싱·Shadow Host 생성·메인 청크 lazy fetch)만 호스트에 즉시 로드 → 메인 런타임 청크는 동적 import. RedPrinting의 브릿지(33KB)/런타임(438KB) 분리와 동형. 후니는 React 기반이므로 런타임을 100KB 이하로 압축 가능(Red의 Vue 438KB는 비최적화 기준선).
- **Tree-shaking**: shadcn은 컴포넌트 단위 복사(소스 인입) 방식이라 사용 컴포넌트만 번들 → tree-shaking에 유리. 14 componentType(`DESIGN.md` §7) 중 실제 사용분만 포함.
- **에디터(Edicus) 청크 분리**: Edicus SDK·브릿지는 사용자가 디자인 탭에 진입할 때만 동적 로드(`editor-bridge-protocol.md` 참조) → 초기 번들에서 제외.

## 5. 버전 관리·CDN 배포

검증된 패턴 [MakerKit][Embeddable]:
- **버전 고정 URL**: `cdn/widget/v1/...` 형태로 버전별 경로 제공 → 고객(호스트)은 특정 버전에 핀, 신버전은 새 경로로 배포. RedPrinting은 `RedWidgetSDK/prod/` 경로 사용(`widget-runtime-spec.md` §1).
- **CDN 호스팅**: 빠른 로딩·가용성. 환경별 CSS/JS URL 분리(.env.development / .env.production) [MakerKit].

**후니 권고 (Priority High)**:
- `loader.js`는 **버전 무관 안정 URL**(롱텀, 캐시 짧게) — 로더가 핀된 메이저 버전의 런타임 청크 URL을 해석.
- 런타임 청크는 **immutable + content-hash** 파일명(`runtime.{hash}.js`, 캐시 1년) → 무중단 배포.
- 메이저 버전 경로(`/v1/`, `/v2/`)로 breaking change 격리. 어댑터 레이어(Red→후니 컨버전, `data-adapter`)는 위젯 코드 불변 원칙이므로 위젯 버전과 독립.

## 6. 함정 모음

| 함정 | 증상 | 대응 |
|------|------|------|
| 폰트 미적용 | Shadow DOM 내부에서 `@font-face`가 `<head>` 링크에 의존 → 적용 안 됨 [Viget] | 폰트를 Shadow Root 내부 stylesheet에 인라인 또는 `adoptedStyleSheets`로 주입. 호스트 폰트 의존 금지. 한글 웹폰트는 subset + `font-display: swap` |
| rem/line-height 누출 | Shadow DOM이 부모의 `font-size`·`line-height` 상속 [Gourav-TW] | Shadow Host 컨테이너에 `line-height` 명시 + Tailwind 기본 rem을 컨테이너 기준으로 고정 (상세 `bp-react-shadow-dom.md`) |
| 토큰 DOM 노출 | open 모드에서 JWT를 DOM 속성/텍스트에 두면 외부 스크립트가 읽음 | red-editor-token JWT는 메모리 스토어(Zustand)에만 보관, DOM 미노출 |
| 호스트 form 충돌 | Shadow DOM 내부 form은 호스트 form에 자동 연결 안 됨 [Smashing] | RedPrinting은 호스트 `form#product_form`에 br릿지가 `sdkCreatePot`으로 주입(`widget-runtime-spec.md` §6). 후니도 form 데이터는 브릿지가 명시적으로 호스트에 전달(ElementInternals 또는 콜백) |

## 7. 후니 채택 결론

| 결정 | 권고 | Priority |
|------|------|----------|
| 아키텍처 | 얇은 로더/브릿지 + 격리 런타임 2단 (Red 3계층과 동형) | High |
| Shadow 모드 | `open` (Red 정합·디버깅·a11y) + 토큰 메모리 격리 | High |
| 로더 | 단일 script-tag + init()/data-* 설정, fail-silently | High |
| 번들 | <100KB gzip, Edicus 청크 동적 분리, shadcn tree-shake | High |
| 배포 | content-hash immutable + 메이저 버전 경로 + CDN | High |

---

## Sources:

- [MakerKit] Building Embeddable React Widgets: Production-Ready Guide — https://makerkit.dev/blog/tutorials/embeddable-widgets-react (WebFetch 검증: script-tag 로더·document.currentScript·45KB/100KB 번들 목표·CDN 버전관리·fail-silently·Shadow DOM hard boundary)
- [Viget] Embeddable Web Applications with Shadow DOM — https://www.viget.com/articles/embedable-web-applications-with-shadow-dom (WebFetch 검증: init({rootId})·attachShadow open·style 주입·폰트 함정)
- [Smashing] Web Components: Working With Shadow DOM (2025-07) — https://www.smashingmagazine.com/2025/07/web-components-working-with-shadow-dom/ (WebFetch 검증: open vs closed 트레이드오프·closed-first 권고·delegatesFocus·form 미연결 한계)
- [Embeddable] Create Embeddable React Widget — https://embeddable.co/blog/create-embeddable-react-widget (WebSearch 결과 — CDN 버전 핀 패턴, 본문 미정독: 보조 인용)
