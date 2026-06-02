# 베스트프랙티스 리서치 요약 (후니 위젯 권고 통합)

> 파이프라인 ② 산출물 통합. 4개 베스트프랙티스 문서의 핵심 권고를 후니 위젯 아키텍처 결정으로 매핑.
> 대상 스택: **React-in-Shadow-DOM** (내부 React + shadcn/Tailwind, 격리 Shadow DOM) + **Edicus** 에디터 + **Neon PG** 결제. (Shopby 범위 제외)
> 기준선: RedPrinting 위젯 역공학(`01_reverse/`). 정합성·개선점을 근거로 제시.
> 본 문서 및 4개 세부 문서 모두 `Sources:` WebFetch 검증 완료.

---

## 1. 토픽별 권장 접근 (Recommended Approach)

### ① 임베드 위젯 → `bp-embed-widget.md`
**권장**: 얇은 로더/브릿지 + 격리 런타임 **2단 분리**(RedPrinting 3계층과 동형), Shadow DOM `mode: 'open'`, 단일 script-tag + init()/data-* 설정, fail-silently 오류 처리. 번들 <100KB gzip(기본 ~45KB 목표), Edicus 청크 동적 분리. content-hash immutable + 메이저 버전 경로 CDN 배포.
**근거**: Red 패턴 검증 + MakerKit/Viget/Smashing 베스트프랙티스 정합.

### ② React-in-Shadow-DOM → `bp-react-shadow-dom.md`
**권장**: `createRoot(shadowRoot 내부 div)` 직접 마운트 + Tailwind를 `?inline` CSS → `CSSStyleSheet.replaceSync` → **인스턴스 공유 `adoptedStyleSheets`**. shadcn 포털(Dialog/Select/Popover)은 **Radix `Portal container`를 Shadow Root 내부로 지정**(최대 함정). `:host`에 rem/line-height/폰트/CSS변수 고정. Zustand 인스턴스 스코프 + 토큰 메모리 격리.
**근거**: react.dev createRoot 패턴 + MDN adoptedStyleSheets(Baseline 2023+) + Gourav rem 함정 + Smashing form/focus 한계.

### ③ 실시간 가격 UX → `bp-pricing-ux.md`
**권장**: **서버 권위 가격**(클라이언트 재계산 금지 — Red 라이브 반증). 옵션 변경 ~250~350ms 디바운스 + 요청 ID로 stale 폐기. 최초=스켈레톤, 재계산=지연 등장 국소 펄스(전역 스피너 금지), 가격값에 낙관 업데이트 금지(이전값 dimmed 유지). 공정별 분해 + 3단 워터폴 + VAT/배송 별산(투명성). 구성기는 캐스케이드 + 제약 disable+사유, 정규화 스키마에 제약 포함.
**근거**: Red 가격 엔진 계약 + Tamara/OneThing 로딩 임계(300ms·낙관 결제 금지).

### ④ 에디터 통합 → `bp-editor-integration.md`
**권장**: postMessage 송수신 모두 **Edicus origin 명시 검증**(Red의 와일드카드 `*` 개선). action 화이트리스트 + info 스키마 검증. iframe sandbox 최소권한 + CSP frame-src/frame-ancestors. 라이프사이클 createProject→deferred-param→save-doc-report→goto-cart를 정규화 계약으로 어댑터 매핑. 토큰은 백엔드 발급·메모리 보관·~55분 선제 갱신.
**근거**: MDN postMessage 보안 3원칙 + Didit iframe 보안 + Red 브릿지 프로토콜 실측.

---

## 2. 채택 / 참조 / 회피 분류

### 채택 (Adopt) — Red 검증 + 베스트프랙티스 합치
- 얇은 로더/브릿지 + 격리 런타임 2단 분리 (Red 3계층 동형)
- Shadow DOM 격리 마운트 (`createRoot(shadowRoot)`)
- 서버 권위 가격 모델 (옵션→디바운스→API→result_sum 표시)
- 가격 공정별 분해 + 3단 워터폴 투명성
- Edicus 라이프사이클(save-doc-report→goto-cart)을 정규화 계약으로 매핑
- 옵션 캐스케이드 제약(`pdt_disable_pcs_info` → 정규화 제약 스키마)

### 참조 (Reference) — 도입하되 후니식 변형
- `adoptedStyleSheets` 단일 시트 인스턴스 공유 (Vue→React 전환)
- Pinia 4~5 스토어 분기 → Zustand 인스턴스 스코프 + 어댑터 흡수
- react-shadow-scope (직접 제어 우선, 멀티인스턴스 번거로우면 폴백)
- 스켈레톤/지연 스피너 임계(300ms) UX

### 회피 (Avoid) — Red 답습 금지 / 베스트프랙티스 위배
- **postMessage 와일드카드 `targetOrigin: "*"`** (Red 현황) → origin 명시로 개선 [HARD 보안]
- 수신 메시지 origin/스키마 미검증 (Red 느슨) → 화이트리스트 검증
- 가격에 낙관적 업데이트(잘못된 추정값 표시) → 이전값 dimmed
- 전역 차단 스피너 (INP 악화) → 국소 점진 피드백
- shadcn 포털을 기본 `document.body`에 (스타일 붕괴) → Shadow 내부 컨테이너
- 토큰을 DOM/로컬스토리지 노출 → 메모리 스토어 전용
- 클라이언트 가격 재계산 (라이브 반증) → 서버 전용

---

## 3. Top 권고 (아키텍처 결정 입력 — hw-architect 통지)

| # | 권고 | 영향 영역 | Priority |
|---|------|----------|----------|
| 1 | Tailwind/shadcn를 `adoptedStyleSheets` 단일 공유 시트로 주입, shadcn 포털을 Shadow 내부 컨테이너로 강제 | Shadow DOM 렌더 코어 | High |
| 2 | 서버 권위 가격 + 디바운스 + 요청ID stale 폐기 + 낙관 가격 금지 | 가격 UX·API 계약 | High |
| 3 | postMessage origin 명시 검증 (Red 와일드카드 개선) + action 화이트리스트 + sandbox/CSP | 에디터 통합 보안 | High |
| 4 | 얇은 로더 + 격리 런타임 + Edicus 청크 분리, <100KB, content-hash 버전관리 | 번들·배포 | High |
| 5 | Zustand 인스턴스 스코프 + 토큰 메모리 격리, 정규화 계약 + 어댑터로 Red/후니 차이 흡수 | 상태·컨버전 | High |
| 6 | 가격 공정별 분해 + 3단 워터폴 투명성, 옵션 제약 정규화 스키마 | 차별점·구성기 | Medium-High |

→ 이 권고가 `hw-architect`의 아키텍처 결정(특히 ①③⑤)의 근거임.

---

## 4. 증거 신뢰도·thin 영역

### 강한 증거 (WebFetch 본문 검증 + Red 라이브 정합)
- React createRoot-in-Shadow + adoptedStyleSheets (MDN Baseline 2023+, Gourav, react.dev)
- postMessage 보안 (MDN 공식 + Didit + Bindbee)
- 로딩 UX 임계 (Tamara + OneThing 구체 수치)
- Red 가격/브릿지 계약 (`01_reverse/` 라이브 검증)

### Thin / 추가 검증 권장 영역
- **shadcn/Radix 포털을 Shadow 내부 container로 지정하는 정확한 prop 동작**: 일반 React-in-Shadow 원리로 도출(WebFetch 검증된 react-shadow-scope FormControl/slot 등 간접 근거). Radix `Portal container` prop 동작은 **빌드 단계에서 실제 구현·검증 필요**(hw-builder 실측). [추가 검증]
- **Edicus iframe sandbox 최소 권한 집합**: Edicus 동작에 필요한 정확한 allow-* 조합은 문서 근거 없음 → **라이브 실측 확정 필요**(`editor-bridge-protocol.md` §9 미검증 영역과 연계). [추가 검증]
- **Tailwind v4 전용 Shadow 주입 세부**: 검증된 Gourav 사례는 Twind/Tailwind 일반. Tailwind v4(`@theme`/CSS-first) + shadcn 변수의 `:host` 주입은 빌드 검증 필요. Context7 `get-library-docs` 미가용으로 v4 공식 세부 미인용 — 빌드 시 Tailwind v4 공식 문서 재확인 권장. [추가 검증]
- **비책자(굿즈/아크릴) 가격·구성기 페이로드**: `price-engine-reversed.md` §4가 책자만 라이브 검증 → 구성기 제약 UI는 책자 기준. [Red측 미검증]

---

## Sources:

본 요약은 4개 세부 문서의 검증 출처를 통합 참조한다. 각 문서 `Sources:` 섹션의 WebFetch 검증 URL 일괄:

- React createRoot in Shadow DOM — https://gourav.io/blog/render-react
- ShadowRoot.adoptedStyleSheets (MDN) — https://developer.mozilla.org/en-US/docs/Web/API/ShadowRoot/adoptedStyleSheets
- Tailwind in Shadow DOM — https://gourav.io/blog/tailwind-in-shadow-dom
- react-shadow-scope — https://github.com/jonathandewitt-dev/react-shadow-scope
- Web Components: Shadow DOM (Smashing 2025) — https://www.smashingmagazine.com/2025/07/web-components-working-with-shadow-dom/
- Embeddable React Widgets (MakerKit) — https://makerkit.dev/blog/tutorials/embeddable-widgets-react
- Embeddable Web Apps with Shadow DOM (Viget) — https://www.viget.com/articles/embedable-web-applications-with-shadow-dom
- Loading States (Tamara) — https://www.tamaramilakovic.com/thinking/loading-states-are-not-one-component
- Skeleton vs Spinners (OneThing) — https://www.onething.design/post/skeleton-screens-vs-loading-spinners
- Window.postMessage (MDN) — https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
- iFrame Security Best Practices (Didit) — https://didit.me/blog/embedded-iframe-security-best-practices/
- Secure Cross-Window Communication (Bindbee) — https://bindbee.dev/blog/secure-cross-window-communication

(모든 URL은 본 세션에서 WebFetch로 본문 검증됨. WebSearch-only 보조 인용은 각 세부 문서에 명시.)
