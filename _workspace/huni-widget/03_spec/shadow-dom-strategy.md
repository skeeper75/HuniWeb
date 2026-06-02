# shadow-dom-strategy.md — React-in-Shadow-DOM + 스타일 격리

> 파이프라인 ③. React createRoot in shadowRoot + Tailwind/shadcn 주입 + 폰트·CSS변수 전파 + Edicus iframe 오버레이.
> 근거: [역공학 §2] Red Vue3-in-Shadow-DOM 마운트 구조 / [DESIGN] Noto Sans·토큰 / [리서치 후합류 검토] adoptedStyleSheets는 established practice로 잠정 확정.

---

## 1. 마운트 (loader 책임)

[역공학 §2] Red: `#redWidgetSdk` Shadow Host → `#shadow-root(open)` → `#red-widget-root` Vue mount. 후니 React판:

```ts
// widget-loader
function mountWidget(hostEl: HTMLElement, opts: WidgetInitOptions, callbacks: HostCallbacks) {
  const shadow = hostEl.attachShadow({ mode: 'open' });   // open — Red과 동일, 디버깅 가능
  injectStyles(shadow);                                    // §2
  const mountPoint = document.createElement('div');
  mountPoint.id = 'huni-widget-root';
  shadow.appendChild(mountPoint);
  import('@huni/widget').then(({ createWidgetRoot }) => {
    createWidgetRoot(mountPoint, opts, callbacks);         // React 18 createRoot(mountPoint)
  });
}
```

> [결정] `mode: 'open'` — Red과 동일. 격리는 스타일·DOM 경계로 충분하고 closed는 디버깅·테스트(QA)를 막는다(과방어 금지).

---

## 2. Tailwind/shadcn 스타일 주입 (adoptedStyleSheets)

[리서치 후합류 검토] Shadow DOM에 Tailwind를 넣는 정석은 **Constructable Stylesheet + `adoptedStyleSheets`**. `<style>` 인젝션 대비 (a) 파싱 1회·인스턴스 공유, (b) 호스트로 누수 0, (c) 멀티 인스턴스 메모리 절약.

```ts
let sheet: CSSStyleSheet | null = null;     // 모듈 싱글톤 — 멀티 인스턴스 공유
function injectStyles(shadow: ShadowRoot) {
  if (!sheet) {
    sheet = new CSSStyleSheet();
    sheet.replaceSync(COMPILED_TAILWIND_CSS); // 빌드시 인라인된 컴파일 CSS 문자열
  }
  shadow.adoptedStyleSheets = [sheet];
}
```

- 빌드: Tailwind를 위젯 컴포넌트 대상으로 컴파일 → CSS 문자열을 런타임 청크에 인라인(`?inline`). 별도 widget.css 네트워크 요청 불필요(Red은 link[widget.css] 별도 로드; 후니는 인라인으로 단순화).
- shadcn 컴포넌트 CSS도 동일 시트에 포함(Tailwind 유틸 기반이므로 자동).
- 폴백: `adoptedStyleSheets` 미지원 구형 브라우저 → `<style>` 주입 폴백 1줄. [결정] 폴백은 1단계만(과방어 금지).

---

## 3. 폰트 (Noto Sans) — Shadow 경계 처리

[DESIGN 3] Noto Sans ONLY, 자간 -5%. `@font-face`는 **document 레벨**에서만 동작(Shadow 내부 `@font-face`는 무시될 수 있음).

```ts
// loader가 document.head에 1회 주입 (폰트는 격리 대상 아님 — 전역 등록 필요)
function ensureFont() {
  if (document.getElementById('huni-noto-sans')) return;
  const link = document.createElement('link');
  link.id = 'huni-noto-sans'; link.rel = 'stylesheet';
  link.href = 'https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600&display=swap';
  document.head.appendChild(link);
}
```

- Shadow 내부 컴포넌트는 `font-family: 'Noto Sans KR', sans-serif` 적용(adoptedStyleSheet의 :host 규칙). 폰트 데이터는 document에서 로드됨.
- [결정] 폰트만 전역(document.head), 스타일·토큰은 격리. 폰트는 본질적으로 전역 리소스라 격리 불가 — 호스트와 공유돼도 무해(이름만 등록).

---

## 4. CSS 변수(디자인 토큰) 전파

[DESIGN 2] 토큰을 `:host` CSS 변수로 정의 → Shadow 내부 전체 상속:

```css
:host {
  --primary: #553886; --primary-dark: #3B2573; --border-default: #CACACA;
  --text-label: #424242; --text-muted: #979797; --bg-section: #F5F5F5; /* ... DESIGN §2 전체 */
  font-family: 'Noto Sans KR', sans-serif;
  letter-spacing: -0.05em;        /* DESIGN 자간 -5% 전역 */
}
```

> [결정] 토큰은 `:host` 변수 + Tailwind config의 `theme.extend.colors`에 동일 매핑 → `bg-[#553886]` 대신 `bg-primary` 사용 가능하나, DESIGN.md가 hex 직기재를 명시하므로 hex 클래스 허용(둘 다 동작). 단일 출처는 `:host` 변수.

---

## 5. Edicus iframe 오버레이 처리

[동작분석 §4] Edicus는 `edicusbase.firebaseapp.com` iframe. Shadow DOM 내부에 iframe을 둘 때 주의:

- iframe은 Shadow root 내부 `<EditorOverlay>`에 마운트(포털로 shadow root 최상단 z-50). 호스트 페이지 위 풀스크린 오버레이.
- [결정] iframe은 격리 스타일 영향 안 받음(별 browsing context) — 오버레이 컨테이너만 위젯 스타일로. iframe `src`는 editor-integration.md.
- postMessage: `window.addEventListener('message')`는 **document 레벨**(iframe→window). 따라서 리스너는 loader/editor-bridge가 document에 등록하고, origin 검증 후 store로 전달. Shadow 경계와 무관(message는 window 이벤트). [동작분석 event-contract §4].
- 멀티 인스턴스 시 message 라우팅: editor-bridge가 어느 위젯이 에디터를 열었는지 추적(`editorSide`+인스턴스 id)하여 해당 store로만 dispatch. editor-integration.md §5.

---

## 6. 격리 검증 (QA 기준)

- 호스트 페이지 CSS(`* { box-sizing }`, reset 등)가 위젯에 영향 없음(Shadow 경계).
- 위젯 Tailwind가 호스트로 누수 없음(adoptedStyleSheets는 shadow scope).
- 호스트의 전역 `font-family`가 위젯 오염 없음(:host에서 재선언).

---

## 7. OPEN

- `adoptedStyleSheets` 폴백 필요 브라우저 매트릭스 확정 [리서치 후합류 검토].
- 멀티 인스턴스 시 시트 공유 vs 인스턴스별 — 현재 공유(§2). 인스턴스별 토큰 오버라이드 요구 생기면 재검토(현재 불요).
