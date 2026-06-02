# architecture.md — 후니 위젯 전체 아키텍처

> 파이프라인 ③ hw-architect 산출물. 구현 단일 청사진의 최상위 문서.
> 근거 표기: `[역공학]` = 01_reverse / `[동작분석]` = 02_analysis / `[DESIGN]` = DESIGN.md / `[결정]` = 본 명세 엔지니어링 결정 / `[리서치 후합류 검토]` = 02_research 미입수로 잠정 확정.

---

## 0. 확정 사항 (변경 불가 전제)

| 항목 | 결정 | 근거 |
|------|------|------|
| 위젯 형태 | **React-in-Shadow-DOM 임베드 위젯** (내부 React 18, shadcn/Tailwind, 격리 Shadow DOM) | 하네스 키스톤 |
| 패턴 출처 | RedPrinting Vue3-in-Shadow-DOM 의 React판 | [역공학] widget-runtime-spec §2 |
| 에디터 | Edicus SDK (`createProject` + KOI passive + `from-edicus` postMessage) | [동작분석] runtime-behavior §4 |
| DB | Neon(`DATABASE_URL`) 또는 미정 — 위젯은 DB에 직접 의존하지 않음 | 키스톤 |
| 상태관리 | Zustand (Red 4~5 Pinia 스토어 대응) | [DESIGN] RULE-5 / [역공학] §3 |
| 데이터 의존 | **정규화 계약 only** — Red/후니/커머스 백엔드 raw shape 직접 참조 금지 | 키스톤 |
| 커머스 백엔드 | **UNDECIDED** — 장바구니/주문 경로는 정규화 계약 경계에 두고 어댑터가 흡수. 특정 커머스 플랫폼 바인딩 금지 | 스코프 제약 |

> [HARD] Shopby 가정 0건. `.env.local`에 Shopby 키가 존재하나 본 위젯 스펙은 이를 참조하지 않는다. 장바구니 핸드오프(`from-edicus:goto-cart`)는 정규화 페이로드를 BFF에 전달하는 데서 끝나며, 그 뒤 커머스 바인딩은 어댑터/BFF의 책임(미정)이다.

---

## 1. 3계층 매핑 (Red 3계층 → 후니 스택)

[역공학] Red는 브릿지(productRedWidgetSDK.js) / 런타임(widget.js Vue3) / 에디터(RedEditorSDK) 3계층. 후니 React판 매핑:

| Red 계층 | 후니 계층 | 기술 | 책임 |
|----------|-----------|------|------|
| 브릿지(33KB jQuery glue) | **Loader (`@huni/widget-loader`)** | 경량 ES module (~5KB target) | 호스트 페이지에 `<script>` 1줄. Shadow Host 생성, 런타임 청크 동적 import, 콜백/CustomEvent 양방향 브리지 |
| 런타임(438KB Vue3+Pinia) | **Runtime (`@huni/widget`)** | React 18 + Zustand + shadcn/Tailwind | Shadow DOM 내부 렌더, 옵션 UI, 캐스케이드 룰엔진, 가격 표시, 업로드, 에디터 오버레이 제어 |
| 에디터(RedEditorSDK 45 메서드) | **Editor Bridge (`@huni/editor-bridge`)** | Edicus SDK wrapper + postMessage | Edicus iframe 생성, `createProject`, deferred-param 핸드셰이크, `from-edicus` 수신 → 정규화 |

> [결정] 3계층 분리 유지 이유: 로더는 호스트에 영원히 박히므로 최소·안정 계약이어야 하고(번들 교체 시 호스트 무수정), 런타임은 빈번히 갱신되며, 에디터 브리지는 Edicus 버전 의존이라 격리 필요. Red가 검증한 분리를 그대로 따른다.

---

## 2. 레이어 다이어그램

```
┌─────────────────────────── 호스트 페이지 (후니 상품 상세) ───────────────────────────┐
│  <div id="huni-widget" data-pdt-code="..." data-locale="ko"></div>                  │
│  <script src="cdn/.../huni-widget-loader.js"></script>                              │
│                                                                                      │
│   Loader (경량)                                                                       │
│     · Shadow Host 생성 (attachShadow open)                                            │
│     · adoptedStyleSheets 주입 (Tailwind compiled)                                     │
│     · 동적 import('huni-widget-runtime') → createRoot(shadowRoot)                     │
│     · 호스트 콜백 prop ↔ CustomEvent 양방향 브리지                                       │
│  ┌──────────────────── Shadow Root (격리) ──────────────────────────┐                │
│  │  React App                                                        │                │
│  │   <WidgetProvider>  (Zustand store + 정규화 계약 주입)             │                │
│  │     <OptionPanel>   (Zone1~4, 14 componentType)                    │                │
│  │     <PriceSummary>  (서버 권위 가격 표시 — 계산 안 함)             │                │
│  │     <OrderCTA>      (PDF업로드 / 디자인에디터 / 장바구니)          │                │
│  │     <EditorOverlay> (Edicus iframe 호스팅)                         │                │
│  └────────────────────────────────────────────────────────────────┘                │
└──────────────────────────────────────────────────────────────────────────────────┘
        │ 정규화 계약(data-contract)만 통과              ▲ from-edicus (origin 검증)
        ▼                                                │
┌─────────────────── 어댑터 레이어 (data-adapter) ──────────────────────────────────┐
│  Red 어댑터 (fixture, 오늘)  │  후니 어댑터 (DB 확정 후, 교체)                       │
└────────────────────────────────────────────────────────────────────────────────┘
        │                                                │
        ▼                                                ▼
┌─────────── BFF (api-contract) ───────────┐   ┌────── Edicus (edicusbase.firebaseapp.com) ──────┐
│ /product /price /presigned /editor-config│   │ Firebase / makers / 에디터 iframe                │
│ /cart-handoff(커머스 바인딩 UNDECIDED)    │   └─────────────────────────────────────────────────┘
└───────────────────────────────────────────┘
        │ (어댑터가 데이터소스로 변환)
        ▼
   [Neon DATABASE_URL 또는 미정]   [커머스 백엔드 UNDECIDED]
```

---

## 3. 데이터 흐름 (정규화 계약 경계 강조)

[동작분석] sequence-diagrams 의 6 시퀀스를 정규화 경계로 재서술:

```
① 초기화:  Loader mount → BFF GET /product/{code} → 어댑터 → NormalizedProduct
           → Zustand setProduct → OptionPanel 렌더 → 초기 가격 1회 자동
② 옵션변경: UI change → store.applyCascade(6종 룰) → debounce(300ms)
           → BFF POST /price (NormalizedPriceRequest) → 어댑터 → NormalizedPriceBreakdown
           → PriceSummary 표시 (위젯은 계산 안 함 [역공학 §3])
③ 표지 에디터: OrderCTA → BFF POST /editor-config → NormalizedEditorConfig
           → Edicus createProject → from-edicus 수신 → 어댑터 → NormalizedEditorResult
④ 내지 PDF: 파일선택 → BFF POST /presigned → NormalizedPresigned → PUT S3 직접
           → NormalizedUploadResult
⑤ 주문가능: store.selectCanOrder() (클라이언트 룰, 서버 왕복 없음)
⑥ 장바구니: from-edicus:goto-cart → NormalizedCartHandoff → BFF POST /cart-handoff
           → [커머스 바인딩 UNDECIDED — 어댑터 책임]
```

[결정] 모든 외부 데이터는 어댑터를 거쳐 정규화 타입으로만 store/컴포넌트에 진입한다. `PCS_COD`·`MTRL_CD`·`price_gbn` 등 Red 원시 필드는 어댑터 내부에만 존재하고 위젯 코드에 등장하지 않는다.

---

## 4. 기술 스택 결정 근거

| 결정 | 선택 | 근거 / 대안 기각 |
|------|------|-----------------|
| React 버전 | React 18 (createRoot) | Shadow DOM 마운트는 `createRoot(shadowRoot)`로 직접. React 19도 호환되나 18로 고정(생태계 안정). [결정] |
| 스타일 격리 | Tailwind compiled → `adoptedStyleSheets` (Constructable Stylesheet) | Shadow DOM 격리 + 호스트 CSS 누수 차단. `<style>` 인젝션 대비 중복 파싱 없음. [리서치 후합류 검토] (established practice) |
| UI 컴포넌트 | shadcn (Radix 기반) + 후니 커스텀 variant | DESIGN.md가 shadcn 매핑 명시. Radix Slider는 RULE-5-EXT 필수 |
| 상태 | Zustand | DESIGN RULE-5 데이터 우선순위(store) + Red 5 Pinia 대응. Redux 과설계 기각 |
| 빌드 | Vite (library mode) | 로더+런타임 청크 분리, ESM 출력 |
| 데이터 검증 | 정규화 타입 = TS interface only (런타임 검증은 어댑터 경계 1곳만 zod) | [결정] 과검증 금지 — 신뢰 경계는 어댑터 입구 1곳 |

---

## 5. 모듈 경계 (패키지 책임)

```
packages/
  widget-loader/     # 호스트 임베드. Shadow Host·스타일주입·런타임 import·브리지. NO 비즈로직
  widget/            # React 런타임. components/ stores/ hooks/ types(정규화계약). NO 외부 raw shape
  editor-bridge/     # Edicus postMessage. createProject·핸드셰이크·origin검증·정규화변환
  adapters/          # red/ (fixture) + huni/ (추후). 정규화 ↔ 데이터소스 매퍼. 교체 단위
  contract/          # 정규화 타입 정의 (data-contract.md의 TS화). 모든 패키지가 import
```

[결정] `contract/`는 의존성 그래프의 최하단(아무것도 import 안 함). `widget/`은 `contract/`만 import하고 `adapters/`를 절대 import하지 않는다(어댑터는 BFF 응답 변환용으로 BFF 레이어에 위치). 이 단방향 의존이 "위젯 무변경 컨버전"을 코드 레벨로 강제한다.

---

## 6. OPEN 항목 (build-plan.md로 이관)

- 호스트 멀티 인스턴스(한 페이지 N위젯) — bundle-strategy §5에서 다룸
- 모바일 반응형 브레이크포인트 [DESIGN 부록B TBD]
- 회원 등급 할인 표시(PRICE_MALL≠PRICE) 실데이터 [역공학 미검증]
