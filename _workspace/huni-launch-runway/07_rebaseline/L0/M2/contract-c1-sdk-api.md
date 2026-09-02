# 계약 C1 — 쇼핑몰(huni-skin-shopby) ↔ webadmin(huni-admin) SDK·API 계약

- 카드: M2 / L0 재기준선(rebaseline) · 작성 2026-09-02
- 대상: `huni-skin-shopby`(Next.js, `/Users/innojini/Dev/huni-skin-shopby`) ↔ `huni-admin`(Django, `/Users/innojini/Dev/HuniWeb/raw/webadmin`)
- 조사 방식: 읽기 전용. 라이브 브라우저·네트워크 접근 없음(라이브 확인은 별도 담당).
- 인용 표기: 저장소 루트는 `/Users/innojini/Dev/HuniWeb` 와 `/Users/innojini/Dev/huni-skin-shopby`. 이하 `raw/webadmin/...` 은 전자, `src/...` 는 후자 기준.

---

## 0. 출처 순서와 그 결과 — 무엇이 어디에 적혀 있나

이 문서는 프로젝트 규칙에 따라 **앱 내장 매뉴얼을 먼저** 읽고, 그다음 코드를 대조했다. 읽은 순서와 각 출처가 실제로 답해 준 범위는 다음과 같다.

| 순서 | 출처 | 성격 | 이 계약에 대해 답해 주는 것 |
|---|---|---|---|
| 1 | `raw/webadmin/tools/manual_content.py` (924줄) | **운영자** 매뉴얼 원고 | 용어 정의 수준 — 「허용 사이트 / 사이트 키」(manual_content.py:70), 「주문 인계(핸드오프)」(:71), 「게시 / 버전」(:69) |
| 2 | `raw/webadmin/tools/widget_manual_content.py` (821줄) | **운영자용 위젯빌더** 매뉴얼 원고 | 임베드 3원칙(EMBED_NOTES, :719-732), 게시=버전 스냅샷, 미리보기 담기의 JSON 확인 |
| 3 | `_evidence/sdk-guide-live-20260902.txt` (2,132줄, 2026-09-02 캡처) | **개발자용 공개 SDK 가이드**(`/sdk/guide/`) | 임베드 2줄·이벤트 7종·submit 결과 계약·CSS 변수·자격증명 3종·엔드포인트 레퍼런스 |
| 3b | `raw/webadmin/tools/gen_sdk_guide.py` (125KB, 2026-08-28) | **위 가이드를 생성하는 원고 파일**(같은 저장소 안) | 필드명·오류 문자열·엔드포인트별 주요 오류 코드의 정확한 출처. 렌더된 텍스트보다 나은 증거 |
| 3c | `raw/webadmin/tools/test_widget_sdk.js` (67KB) · `tools/test_huni_editor_sdk.js` (18KB) | SDK 테스트 하네스 | 이벤트 계약·편집기 브리지가 **실제로 어떻게 동작하는지** 못박은 assertion |
| 4 | 코드 (`urls.py`·`widget_api.py`·`cart_items.py`·`shopby_hook.py`·`widget.js` 등) | 실행되는 사실 | 게이트 실제 판정, 응답 필드, 오류 코드, 상태코드 |
| 5 | 라이브 curl 관측(조율자 실행, 2026-09-02, 읽기 전용) | 관측된 사실 | §3.2a |

**중요한 범위 경계 하나.** 운영자 매뉴얼 2종에 SDK·API 계약이 없는 것은 누락이 아니다. 두 매뉴얼은 운영자가 알아야 할 것만 다루겠다고 스스로 선언하고 있고(widget_manual_content.py:719-721 — 「붙이는 작업은 개발 담당자 몫이지만, 운영자가 알아야 할 것은 다음 세 가지입니다」), 개발자 계약은 별도 공개 페이지 `/sdk/guide/` 가 맡는다(`raw/webadmin/webadmin/config/urls.py:241` — 「SDK 개발자 가이드·데모 — 외부 파트너 개발자용 **공개** 페이지(비로그인)」). 즉 문서가 두 독자로 갈라져 있는 **의도된 설계**다. 이 문서의 §1·§2·§3 은 그 SDK 가이드를 1차 근거로 삼고 코드로 대조했다. 그럼에도 남는 진짜 갭은 §6 에 따로 모았다.

---

## 1. SDK 표면 — 임베드 스크립트가 실제로 주는 것

### 1.1 임베드는 두 줄이다

```html
<script src="https://huni-admin.printly.co.kr/static/catalog/widget.js"></script>
<huni-widget widget-id="WGT_000001" site-key="wk_xxxxxxxx"></huni-widget>
```

근거: SDK 가이드 `sdk-guide-live-20260902.txt:29-33` — 「발급받은 site_key 와 위젯 코드만 있으면 됩니다. 페이지에 아래 두 줄을 넣으세요.」
쇼핑몰 쪽 실제 상수도 같은 값이다 — `src/lib/printly/huni.ts:10` (`HUNI_ADMIN_ORIGIN = "https://huni-admin.printly.co.kr"`), `:13` (`WIDGET_SCRIPT_SRC = ${HUNI_ADMIN_ORIGIN}/static/catalog/widget.js`).

### 1.2 마운트 방식 — Web Component + Shadow DOM

`widget.js` 는 `huni-widget` 커스텀 엘리먼트를 정의하고(widget.js:903, `customElements.define("huni-widget", HuniWidget)`), `connectedCallback` → `_init()` 에서 `attachShadow({mode:"open"})` 로 섀도 루트를 만든 뒤 그 안에 렌더러 CSS 를 링크하고 마운트 지점을 심는다(widget.js:104-107).

의존 스크립트는 `widget.js` 가 자기 `src` 경로에서 순차 로드한다 — `vendor/json-logic-js.js` → `constraint_engine.js` → `spine_calc.js` → `widget_renderer.js`(widget.js:47-56). 배포 원자성을 위해 전부 `?v=<SDK_VERSION>` 쿼리로 페어링한다(widget.js:26-27, 현재 `86d2eb7d`).

**문서화된 함정 하나(반드시 전달 대상).** 섀도 DOM 이라 페이지 CSS 와 충돌하지 않지만, `font-family` 처럼 **상속되는** 속성은 섀도 경계를 그대로 넘는다. 페이지 어디에도 `font-family` 선언이 없으면 위젯은 브라우저 기본 세리프(한글 명조 계열)로 떨어진다 — 가이드가 명시적으로 경고한다(`sdk-guide-live-20260902.txt:36`, 재차 `:1512`). 해법은 페이지 `body` 에 서체를 선언하거나 `--hw-font` 로 고정.

### 1.3 두 임베드 형태 — 선언형과 SDK형(등가)

| 형태 | 지정 방법 | 근거 |
|---|---|---|
| 선언형 | `<huni-widget widget-id site-key accent design hide-submit hide-reasons>` | 가이드 :77-85 / 코드 widget.js:99, :110, :233 |
| SDK형 | `new HuniWidgetSDK(); await w.mount(sel, {widgetId, siteKey, apiBase, accent, hideSubmit, hideReasons, hideOnError})` | 가이드 :86-95 / 코드 widget.js:906-940 |

가이드는 「두 방식은 완전히 등가입니다(같은 코드 한 벌)」이라고 못박고 있고(:73), 코드도 그렇다 — `HuniWidgetSDK.mount` 는 엘리먼트를 만들어 같은 속성을 세팅할 뿐이다(widget.js:907-921).

**호스트가 넘기는 것(입력) 전수**

| 속성 / 옵션 | 하는 일 | 근거 | 쇼핑몰 사용 여부 |
|---|---|---|---|
| `widget-id` / `widgetId` | 위젯 코드(WGT_xxxxxx). 필수 | widget.js:99, :104 | 사용 — `src/components/product/huni-widget.tsx:311` 계열, 값은 DB 조회로 해석(§1.6) |
| `site-key` / `siteKey` | 사이트 공개키(wk_…). 필수 | widget.js:99 | 사용 — 서버 env `HUNI_WIDGET_SITE_KEY` 에서만 주입(`src/lib/printly/widget.ts:57`) |
| `api-base` / `apiBase` | 스크립트 출처와 다른 API 서버를 쓸 때만 | widget.js:100 | 미사용 |
| `accent` | 강조색 → `--hw-accent` 로 인라인 설정 | widget.js:109-110 | 사용 — 기본 `#5538b6`(huni-widget.tsx:119, :314) |
| `design` | 디자인 잠금(`/designs` 에서 고른 dsn_cd) | 가이드 :81 / widget.js:135 계열 | **미사용**(§1.7 갭 후보) |
| `hide-submit` / `hideSubmit` | 내장 장바구니 버튼 행을 그리지 않음 | widget.js:228-233 | 사용 — `huni-widget.tsx:315` |
| `hide-reasons` / `hideReasons` | 미충족 사유 안내를 위젯이 그리지 않음(호스트가 그림) | widget.js:917 / 가이드 :141-144 | **미사용** — 쇼핑몰은 `reasons` 를 자체 상태로도 받으면서(huni-widget.tsx:136) 위젯 안내도 그대로 둔다(§1.7) |
| `hide-on-error` / `hideOnError` | 로드 실패 시 위젯 영역 숨김 | widget.js:918 | 미사용 |

### 1.4 위젯이 되돌려 주는 것 — 이벤트 7종

전부 `CustomEvent`, `bubbles + composed`, `<huni-widget>` 엘리먼트에서 발화한다(widget.js:92-94). SDK 형은 접두사 없이 구독(`w.on("priced", …)`, widget.js:975).

| 이벤트 | 언제 | detail | 근거(코드) |
|---|---|---|---|
| `huni:ready` | 로드·첫 렌더 완료 | `{widgetId, product:{prd_cd, prd_nm}, …, reasons}` | widget.js:262-264 |
| `huni:change` | 선택이 바뀜 | `{selections, qty, …}` | widget.js:236 |
| `huni:priced` | 가격 계산 성공 | `{total, ok}` (가이드 표기는 `{total, supply, vat, lines}`) | widget.js:237 / 가이드 :113 |
| `huni:state` | 주문가능 상태 변화 | `{canOrder, reasons[], price\|null}` — 키 정확히 3개 | widget.js:741-747, :760 |
| `huni:submit` | 핸드오프 성공 | `{ok:true, token, payload, handoff_id, summary, expires_in}` | widget.js:894-897 |
| `huni:editor` | 편집기 버튼 클릭. **cancelable** — `preventDefault()` 하면 호스트가 편집기 실행을 인수 | widget.js:343-350 |
| `huni:error` | 가격/검증/핸드오프/편집기 실패 | `{message, code?, cause?, reasons?/violations?/errors?}` | widget.js:304 |

**발화 순서 계약(가이드 :121).** `huni:ready` → `huni:state`(초기 1회 보장) → 이후 **상태가 실제로 바뀔 때만**, 같은 상태 연속 발화는 억제. 조용히 깨지기 쉬운 종류의 약속이라 계약으로 기록한다. 코드상 `huni:state` 는 렌더러의 canOrder 재평가 단일 지점에서만 나온다(widget.js:238-240).

이 계약은 **문서상의 약속이 아니라 테스트로 못박혀 있다** — `raw/webadmin/tools/test_widget_sdk.js:598-618`:

| 테스트 | 못박은 것 |
|---|---|
| `s2m D1` (:603-604) | `ready` 이전 `_emitState()` 는 **무발화** |
| `s2m D2` (:606) | `ready` 이후 첫 발화 **정확히 1회**, detail `{canOrder:true, reasons:[], price:null}` |
| `s2m D3` (:610) | 같은 상태 3회 추가 호출 → 발화 **0회**(서명 기반 중복 억제) |
| `s2m D4` (:613-616) | 상태가 바뀌면 발화, detail 이 바뀐 값 반영 |
| `s2m D8` (:617-618) | state detail 키는 **정확히 `canOrder`·`reasons`·`price` 3개** |
| `s2m C1` (:518-522) | submit 성공 시 `huni:submit` **1회**, 결과 객체와 detail 이 같은 객체 |
| `s2m C6` (:595) | 클라 판정 미충족이면 **fetch 호출 0회**(서버 왕복 없음) |
| `F1(E1)` (:772-782) | `huni:editor` 는 `cancelable:true` 로 발화 |
| `F5(E5)` (:838-850) | resolve 가 422 `no_editor_mapping` 이면 token 을 부르지 않고 `huni:error` 를 낸다(**무음 실패 금지**) |

**편집기 브리지의 실제 통신 방식**(`tools/test_huni_editor_sdk.js:88-92`): 저수준 Edicus SDK 는 URL 에 `wait_private_css=true` 만 싣고, 편집기가 `waiting-for-extra-param` 을 보내오면 **`postMessage` 로 CSS 본문을 넘기는 2단 핸드셰이크**다. 그래서 `createProject`/`openProject` 호출 시점에 테마 본문이 이미 손에 있어야 한다(지연 fetch 를 미리 끝냄, `:96-106`). 테마는 **치장이라 실패해도 편집기는 열려야 한다** — CDN 이 한 번 삐끗한 날 편집 자체가 막히면 안 되기 때문(`:111-118`, 무테마 폴백).

**메서드 표면**

| 호출 | 반환 | 근거 |
|---|---|---|
| `el.submit()` | **절대 throw/reject 하지 않음** — 성공 `{ok:true, token, payload, handoff_id, summary, expires_in}`, 실패 `{ok:false, code, message, reasons\|violations\|errors}` | widget.js:817-828, :888-897 / 가이드 :158-166 |
| `el.getStatus()` | `{canOrder, reasons, price}` | widget.js:765 |
| `el.canOrder()` | 불리언 | widget.js:766 |
| `sdk.canOrder()` | **사유 배열(string[])** — 이름과 다름, 레거시 하위호환 | widget.js:970-972 / 가이드 :167 |
| `sdk.getState()` / `getSummary()` / `setSelection()` / `price()` / `validate()` / `setNotice()` / `on()` / `off()` / `destroy()` | — | widget.js:941-977 |
| `el.setEditorResult(item, result)` | 편집기 결과 주입 | widget.js:308-314 / 쇼핑몰 타입선언 `src/types/huni-widget.d.ts:44` |

**가이드가 명시한 요철 3가지(:167-169)** — ① `sdk.canOrder()` 반환형이 이름과 다름, ② `state.price` 는 마지막 서버 응답값이라 선택 변경 후 ~300ms 디바운스 동안 직전 값, ③ **중복 제출 가드가 위젯에 없다** — 버튼 연타로 handoff 가 여러 번 서명될 수 있어 호스트가 `disabled` 로 막아야 한다. 쇼핑몰은 `busy` 상태로 이를 처리한다(huni-widget.tsx:137 `const [busy, setBusy] = useState(false)`).

### 1.5 CSS 변수 테마 표면 (`--hw-*`)

운영자 매뉴얼도 이 경계를 그대로 말한다 — 「겉모양은 임베드하는 쪽에서 — 색·글꼴·간격은 CSS 변수(`--hw-*`)로 사이트에 맞춰 바꿉니다. 위젯빌더는 **무엇을 보여줄지**를, 사이트는 **어떤 색으로 보여줄지**를 담당합니다.」(widget_manual_content.py:727-729).

위젯 내부 스타일은 전부 `var(--hw-토큰, 기본값)` 패턴이라 페이지 CSS 로 안전하게 덮인다(가이드 :1502). 주요 토큰(가이드 :1506-1513, 전수 표 있음):

| 계열 | 토큰(대표) | 기본값 |
|---|---|---|
| 브랜드 | `--hw-accent` / `--hw-accent-bg` / `--hw-accent-soft` | `#5538B6` / `#f7f5ff` / `#b8a9e8` |
| 서체·형태 | `--hw-font`(기본 inherit) / `--hw-radius` / `--hw-ink` | inherit / 5px / `#1a1a2e` |
| 버튼 | `--hw-btn-h` / `--hw-btn-fs` / `--hw-btn-ink` / `--hw-btn-on-bg` | 50px / 14px / `#767676` / `#fff` |
| 가격 요약 | `--hw-price-total-fs` / `--hw-price-ln-fs` | 22px / 11.5px |
| 가로선 | `--hw-divider-color` / `--hw-divider-h` | `#b8a9e8` / 1px (widget_manual_content.py:496-497 이 운영자 관점에서 같은 토큰을 언급) |
| 편집기 오버레이 | `--hw-editor-z` / `--hw-editor-bg` / `--hw-editor-bar-bg` / `--hw-editor-title-c` | 2147483000 / rgba(17,17,17,.55) / `#fff` / `#111` (widget.js:442-452) |
| 모바일 | `--hw-fs-scale-sm` / `--hw-fs-scale-sm-price` | 1 / 1.35 |

### 1.6 쇼핑몰 쪽 배선 — 실제로 어떻게 붙어 있나

| 단계 | 구현 | 근거 |
|---|---|---|
| 오리진 워밍 | `preconnect(HUNI_ADMIN_ORIGIN, {crossOrigin:"anonymous"})` — huni-admin API 가 호출당 ~700ms 로 느려 체감 지연을 줄이려는 조치 | `src/app/layout.tsx:4`, `:40` / 사유는 `src/lib/printly/huni.ts:1-8` |
| 스크립트 주입 | `<Script src={WIDGET_SCRIPT_SRC} strategy="afterInteractive" />` | `src/components/product/huni-widget.tsx:304` |
| widget-id 해석 | **API 가 아니라 Railway DB 직접 SELECT**(읽기전용 풀) — `site_key → t_wgt_sites.site_cd`, `(site_cd, prd_cd) → t_wgt_widgets` 게시(.02)+활성버전+판매중 | `src/lib/printly/widget.ts:65-99`, 캐시 300초 `:25` |
| site_key 보관 | 서버 env `HUNI_WIDGET_SITE_KEY` — 브라우저 번들 미노출 | `src/lib/printly/widget.ts:56-58` |
| 주문 트리거 | `hide-submit` + `huni:state` 구독 → 자체 버튼 → `el.submit()` | `huni-widget.tsx:8-13`, `:315` |
| 주문 데이터 이송 | handoff 결과를 **샵바이 optionInputs 텍스트**로 실음 — `huni_token`(서명 토큰), `huni_order`(총액·수량·요약·editors·files JSON) | `huni-widget.tsx:47-80` |
| 재견적 | 자체 Next 라우트가 서버에서 `/handoff/requote` 대리 호출(로그인 세션 필수, 오픈 프록시 방지) | `src/app/api/printly/requote/route.ts:16-30` |

**주목할 사실 — 쇼핑몰은 위젯 해석에 `/api/w/v1/catalog` 를 쓰지 않고 DB 를 직접 읽는다.** SDK 가이드는 카탈로그 API 로 상품 페이지를 구성하라고 안내하지만(가이드 :45-46), 실제 배선은 `PRINTLY_DB_URL` 로 Railway 를 직접 SELECT 한다(`src/lib/printly/widget.ts:44-52`). 계약이 이중이며, DB 스키마가 바뀌면 API 계약과 무관하게 쇼핑몰이 깨진다. §6 에 갭으로 기록.

### 1.7 SDK 표면 중 쇼핑몰이 아직 쓰지 않는 것

| 미사용 표면 | 무슨 기능인가 | 안 쓰면 어떻게 되나 |
|---|---|---|
| `design="DSN_xxxxxx"` 속성 | 디자인 목록에서 고른 디자인의 고정 사양(사이즈·페이지수)을 잠근 채 주문 | 디자인 다건 상품(포토북 등) 주문 동선이 성립하지 않음 — `/designs`·`/design-image` 두 엔드포인트도 함께 미사용 |
| `hide-reasons` | 사유 UI 를 호스트가 전부 그리기 | 현재는 위젯 안내와 쇼핑몰 안내가 병존(중복 표시 가능) |
| `api-base`, `hide-on-error` | — | 영향 없음 |
| `/catalog` | 게시 위젯·카테고리 트리 조회 | DB 직접 조회로 대체 중(위 §1.6) |
| `/guides`, `/main-images` | 작업가이드 파일·상품 메인이미지 | 상품 상세 콘텐츠를 쇼핑몰이 별도 관리해야 함 |

---

## 2. `/api/w/v1/*` 전수 계약표

### 2.0 개수 검증 — 27개 주장에 대한 대조 (이것 자체가 발견)

`urls.py` 를 파싱해 실제로 센 결과는 **22개**다. 27 이 아니다.

```
grep -n "api/w/v1" raw/webadmin/webadmin/config/urls.py  →  22 hits (라인 246~288)
```

같은 파일을 파싱하는 드리프트 가드 테스트가 이미 존재한다 — `raw/webadmin/tests/test_sdk_guide.py:49` 가 `path("(api/w/v1/[^"]+)"` 정규식으로 라우트를 모으고, `:39` 에서 `api/w/v1/shopby/` 접두는 공개 가이드 문서화 대상에서 제외한다. 공개 SDK 가이드 원고의 엔드포인트 항목 수는 **21개**(`tools/gen_sdk_guide.py` 의 `ENDPOINTS`, `grep -c '"method":'` = 21) — 22 − 1(샵바이 웹훅) = 21 로 정확히 맞는다.

27 에 도달하는 세는 법이 없지는 않으나, 어느 것도 문서에 근거가 없다:

| 세는 법 | 결과 |
|---|---|
| A. `path()` 선언 수 | **22** ← 실측 |
| B. A + `cart/items/{item_id}` 의 PUT·DELETE 분리 | 23 |
| C. B + `/sdk/guide/`·`/sdk/demo/`·`/sdk/cart-guide/`(urls.py:241,242,245) | 26 |
| D. C + 같은 경로의 POST 별칭 | 27 |
| E. A + multipart 4 액션 전개(+3) + cart PUT/DELETE 분리(+1) + 웹훅 PUT(+1) | 27 |

D·E 두 경로로 27 이 나오지만 **둘 다 추정**이다. 27 이라는 숫자의 출처를 확인하기 전에는 「경로 22개, 메서드 구분 계약 행 24개(아래 표)」로 읽는 것이 사실에 맞다. → **미확인 / 확인 방법**: 27 을 주장한 문서·발화의 원문을 확인해 세는 단위(경로 / 메서드 / 액션 / 문서 페이지 포함 여부)를 특정할 것.

### 2.1 계약표 (24행 — 22경로, cart 항목 경로만 메서드별 분리)

호출 주체 약어: **W**=위젯 런타임(브라우저) · **S**=쇼핑몰 서버 · **B**=빌더 미리보기 · **X**=외부(샵바이)
게이트 약어: **SK**=site_key · **OD**=허용도메인(Origin/Referer) · **SVK**=`X-Huni-Server-Key` · **TKN**=HMAC 서명 토큰 · **SEC**=URL 비밀경로 · **없음**=공개
분당 한도: 표기 없으면 사이트당 240(기본 버킷). 전용 버킷은 각 셀에 명시(전부 600).
오류 코드 열의 출처: 엔드포인트별 목록은 `raw/webadmin/tools/gen_sdk_guide.py` 의 `ENDPOINTS[].errors`(:233-689), HTTP 상태 매핑은 같은 파일 `ERROR_DICT`(:691-813), 실제 발생 지점은 각 행의 코드 인용.

| # | 경로 | 메서드 | 하는 일 | 요청(주요) | 응답(주요) | 인증·게이트 | 멱등성 | 실패 상태·코드 | 호출 주체 | 근거 file:line |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | `/api/w/v1/widgets/<wgt_cd>` | GET | 게시 위젯의 화면 구성(cfg) + 상품 런타임 메타 | `wgt_cd`(path), `site_key`(query) | `{ok, widget:{wgt_cd,wgt_nm,ver_no,theme_opts,cfg}, meta}` | SK+OD+분당240 (`_gate`) | 조회(멱등) | 403 bad_site_key / 403 origin_not_allowed / 404 widget_not_found / 403 site_mismatch / 409 not_published / 409 no_active_version / 409 product_unpublished / 501 cfg_ver_unsupported / 429 rate_limited | W | urls.py:246 · widget_api.py:814-829 |
| 2 | `/api/w/v1/catalog` | GET | 이 site_key 로 임베드 가능한 게시 위젯 전체 + 상품·카테고리·시작가·디자인수 | `site_key` | `{ok, categories[], widgets[{wgt_cd,wgt_nm,prd_cd,prd_nm,cat_cds,start_price,design_cnt}]}` | SK+OD+분당240 (`_gate` 미사용, 직접 조립) | 조회 | 403 bad_site_key / 403 origin_not_allowed / 429 | S | urls.py:247 · widget_api.py:4407-4433 |
| 3 | `/api/w/v1/price` | POST | 서버 권위 가격 재계산(위젯은 표시만) | `site_key, wgt_cd, selections, qty, case_cnt, pages, sel_opts, sel_opt_grps, proc_sels, addons, with_tiers, set?` | `{ok, total, supply, vat, lines[], unitLabel, unitValue, tier_prices[]}` | SK+OD+분당240 | 조회성(부수효과 없음) | 422 bad_qty·bad_dim_precision·bad_proc_detail·case_cnt_not_allowed·bad_pages·pages_required / 422 price_gap / 409 product_unpublished | W | urls.py:248 · widget_api.py:2155-2163 |
| 4 | `/api/w/v1/validate` | POST | 제약 규칙(JSONLogic) 서버 판정 | `site_key, wgt_cd, selections, sel_opts, sel_opt_grps, proc_sels, set?` | `{ok, violations[{msg,typ}]}` | SK+OD+분당240 | 조회성 | 422 bad_dim_precision·bad_proc_detail / 409 product_unpublished | W | urls.py:249 · widget_api.py:2466-2506 |
| 5 | `/api/w/v1/upload/presign` | POST | 원고 S3 직업로드용 presigned PUT URL 발급(최대 20개/회) | `site_key, wgt_cd, files[{item,mbr,inst,name,size,ext}]` | `{ok, uploads[{item,mbr,inst,name,key,url,headers,expires_in}]}` | SK+OD+분당240 | 비멱등(호출마다 새 key) | 400 no_files·too_many_files / 422 bad_files·bad_file_type·bad_file_size·bad_file_count / 503 upload_not_configured / 502 presign_failed | W | urls.py:250 · widget_api.py:3501-3557 |
| 6 | `/api/w/v1/upload/multipart/<action>` | POST | 100MB 초과 원고 조각 업로드 — `create\|sign\|complete\|abort` | `site_key, wgt_cd, key, upload_id, part_numbers[]` | action별 `{ok, upload_id}` / `{ok, urls}` / `{ok, key}` / `{ok, aborted}` | SK+OD+분당240. **`complete`·`abort` 는 상품 판매중지 검사 면제**(조각 정리 목적) | `abort` 는 멱등(늦은 취소 흡수) | 400 bad_action·bad_upload_id·bad_upload_key·too_many_parts·bad_parts / 409 product_unpublished(create·sign만) / 502 complete_failed / 503 upload_not_configured | W | urls.py:252 · widget_api.py:3669-3691, UPLOAD_FINISH_ACTIONS widget_api.py:455 |
| 7 | `/api/w/v1/handoff` | POST | **주문 직전 최종 관문** — 가격·제약·원고 전부 재검증 후 HMAC 서명 토큰 발급 | `site_key, wgt_cd, selections, qty, case_cnt, pages, order_title, spine_color, sel_opts, sel_opt_grps, proc_sels, addons, files[], editors[], guest_id, set?` | `{ok, token, payload{site_cd,wgt_cd,prd_cd,total,supply,vat,selections,files,editors,spine,ts}, expires_in:3600, handoff_id, qty_rule}` | SK+OD+분당240 | **비멱등** — 호출마다 새 서명·새 handoff_id | 422 constraint_violation·price_unavailable·price_gap·tmpl_combo_gap·artwork_required·artwork_not_uploaded·bad_files·bad_editors·bad_qty·bad_pages·spine_unavailable·price_unit_mismatch / 409 product_unpublished | W | urls.py:254 · widget_api.py:3456-3494 |
| 8 | `/api/w/v1/handoff/verify` | POST | 파트너 서버가 브라우저 경유 토큰을 검증 | `site_key, token` (+헤더 SVK 선택) | `{ok, valid, payload}` 또는 `{ok, valid:false, reason}` | SK만(**OD 없음** — 서버-투-서버 허용) + SVK 선택(보내면 검증) | 멱등 | 403 bad_site_key / 403 bad_server_key / `valid:false` reason ∈ expired·bad_signature·site_mismatch·product_unpublished | S | urls.py:255 · widget_api.py:3700-3724 |
| 9 | `/api/w/v1/handoff/requote` | POST | 장바구니 재견적 — 결제 직전 갱신 / 수량(부수) 변경. **사양은 서명 payload 에서 승계, 수량 외 변경 불가** | `site_key, token, qty?` \| `copies?` (+헤더 SVK 선택) | `{ok, token, payload, expires_in, handoff_id, price_changed, prev_total, qty_rule}` | SK만(**OD 없음**) + 전용버킷 `rq:` 분당600 + SVK 선택 | 비멱등(새 토큰) | 422 bad_token·token_too_old·bad_qty·constraint_violation·price_gap·tmpl_combo_gap·set_not_supported·copies_not_allowed / 409 product_unpublished / 429 | S | urls.py:256 · widget_api.py:3885-3934, 3975-3984 |
| 10 | `/api/w/v1/cart/items` | POST | 담기 — 토큰을 후니가 보관하고 불변 `item_id`(UUID) 발급 | 헤더 SVK **필수** + `{site_key, token, shop_cart_no?}` | `{ok, item_id, summary, total, qty, qty_rule, expires_at, repriced}` | SK + **SVK 필수(fail-closed)** + 전용버킷 `ct:` 분당600. **CORS 미개방**(브라우저 preflight 차단) | 비멱등(호출마다 새 item_id) | 403 bad_server_key·bad_site_key·site_mismatch / 422 bad_token·token_too_old / 409 product_unpublished / 429 | S | urls.py:261 · cart_items.py:351-400, 게이트 :98-131 |
| 11 | `/api/w/v1/cart/items/fetch` | POST | 장바구니 화면 N줄 일괄 조회(최대 50) — **요청 순서 그대로 반환** | 헤더 SVK **필수** + `{site_key, item_ids[]}` | `{ok, items[{item_id,status,summary,total,qty,qty_rule,expires_at}]}`, status ∈ ok·expired·product_unpublished·not_found | 동 위 | 멱등 | 400 missing_item_ids / 422 too_many_items / 403 bad_server_key·bad_site_key / 429 | S | urls.py:262 · cart_items.py:455-503 |
| 12 | `/api/w/v1/cart/items/<item_id>` | PUT (POST 별칭) | 갱신 — 수량/부수 변경 또는 결제 직전 재견적. **item_id 불변, 보관 30일 미연장** | 헤더 SVK **필수** + `{site_key, qty?\|copies?}` | `{ok, item_id, summary, total, qty, qty_rule, expires_at, price_changed, prev_total}` | 동 위 | 비멱등(재견적) | 404 not_found / **410 expired** / 422 bad_qty·set_not_supported·copies_not_allowed·price_gap·price_unavailable / 409 product_unpublished | S | urls.py:264 · cart_items.py:508-586, 605-626 |
| 13 | `/api/w/v1/cart/items/<item_id>` | DELETE | 정리 — best-effort. 없는 항목도 204 | 헤더 SVK **필수** + `{site_key}` 또는 `?site_key=`(본문 없는 클라이언트 허용) | `204 No Content` | 동 위 | **멱등** | 403 bad_server_key·bad_site_key / 429 | S | cart_items.py:588-603, 본문없음 허용 :106-109 |
| 14 | `/api/w/v1/order/register` | POST | 쇼핑몰 주문번호에 **검증된 제작 사양·원고 목록을 묶어 보관** + 원고 승격(tmp→order) | `{site_key, order_no, line_no, token \| item_id}` (+헤더 SVK — `item_id` 경로는 **필수**, `token` 경로는 선택) | `{ok, order_id, already, qty, total}` | SK + 전용버킷 `or:` 분당600 + SVK 조건부 필수 | **멱등** — UNIQUE(site_cd, shop_ord_no, shop_line_no)가 유일한 심판, 재전송은 `already:true` | 400 missing_order_no·missing_line_no·order_no_too_long·missing_token / 404 not_found / 422 bad_token·token_too_old / 403 site_mismatch·bad_server_key / 409 order_mismatch·register_failed·product_unpublished | S | urls.py:267 · widget_api.py:4186-4327 |
| 15 | `/api/w/v1/shopby/webhook/<secret>` | POST, PUT | 샵바이 웹훅 수신 — **원문 저장 후 즉시 200**. 해석·검증·처리는 하지 않음 | 경로 마지막 조각이 비밀키. 본문=샵바이 페이로드 원문(최대 256KB) | `{ok, hook_id}` | **SEC(URL 비밀경로)만.** site_key·서명 헤더 없음. **rate limit 없음**(의도적 — 재전송이 없어 한 건도 거절 불가) | 중복제거 **안 함**(이벤트 고유번호 부재) — 멱등성은 처리 단계 책임 | 404(비밀 불일치·미설정, 403 아님) / 405 / 500(저장 실패 — 샵바이 실패목록에 남기려 의도적) | X | urls.py:271 · shopby_hook.py:78-133 |
| 16 | `/api/w/v1/editor/resolve` | POST | 옵션조합(또는 dsn_cd) → Edicus `ps_cd`·`tmpl_uri` 결정 | `site_key, wgt_cd, selections, sel_opts, proc_sels, dsn_cd?` | `{ok, ps_cd, tmpl_uri}` | SK+OD+분당240 | 조회성 | 422 editor_not_enabled·no_editor_mapping·bad_design / 409 product_unpublished | W | urls.py:274 · widget_api.py:4338-4377 |
| 17 | `/api/w/v1/editor/token` | POST | Edicus 사용자 토큰 **대리 발급**(비밀 API 키는 서버에만) | `site_key, wgt_cd, guest_id` | `{ok, token, partner, uid, expires_in:3600}` | SK+OD+분당240 | 비멱등 | 422 bad_guest_id·editor_not_configured·editor_token_failed. **어떤 실패에서도 5xx 를 내지 않음**(CF 가 5xx 본문을 갈아치우므로) | W | urls.py:275 · widget_api.py:4380-4404 |
| 18 | `/api/w/v1/swatch/<kind>/<code>` | GET, HEAD | 공정·자재·책등규격 스와치 이미지 공개 서빙 | `kind` ∈ proc·mat·spine, `code` | 이미지 바이트 | **없음(완전 공개)** — 타 도메인 `<img src>` 직접 로드 요건. `ACAO: *` 고정, `Vary` 미부착, 1년 immutable | 멱등 | 404 not_found(미등록·논리삭제·S3 실패 전부 404 로 흡수) / 405 | W(브라우저) | urls.py:277 · widget_api.py:833-871 |
| 19 | `/api/w/v1/guides` | GET | 상품별 작업가이드 파일 목록 + 다운로드 URL | `site_key, prd_cd` | `{ok, prd_cd, guides[{guide_nm,orig_file_nm,file_ext,file_size,tags,disp_seq,download_url,upd_dt}]}` | SK만(**OD 없음** — 소비자가 쇼핑몰 웹서버) + 전용버킷 `gd:` 분당600 | 멱등. **download_url 은 만료형이라 캐시 금지** | 400 missing_prd_cd / 404 product_not_found / 403 bad_site_key / 429 | S | urls.py:280 · widget_api.py:4509-4566 |
| 20 | `/api/w/v1/main-image/<img_path>` | GET, HEAD | 상품 메인이미지 바이트 공개 서빙 | `img_path` = `{prd_cd}/{파일명}` 정확히 2조각 | 이미지 바이트 | **없음(완전 공개)**. 활성 행 `file_key` **정확 일치**만 서빙(키 추측 스캔 차단) | 멱등 | 404 not_found / 405 | 브라우저 | urls.py:283 · widget_api.py:883-909 |
| 21 | `/api/w/v1/main-images` | GET | 상품별 메인이미지 목록 | `site_key, prd_cd` | `{ok, prd_cd, images[{url,name,seq,rep,list}]}` | SK만(**OD 없음**) + 전용버킷 `mi:` 분당600 | 멱등 | 400 missing_prd_cd / 404 product_not_found / 403 / 429 | S | urls.py:285 · widget_api.py:4569-4607 |
| 22 | `/api/w/v1/designs` | GET | 상품별 디자인 목록(썸네일·고정사양·디자인별 시작가) | `site_key, prd_cd` | `{ok, prd_cd, designs[{dsn_cd,dsn_nm,thumb_url,tags,fixed_specs[],disp_seq,start_price}]}` | SK + **OD 있음** + 전용버킷 `ds:` 분당600 | 멱등 | 400 missing_prd_cd / 404 product_not_found / 403 bad_site_key·origin_not_allowed / 429 | S | urls.py:287 · widget_api.py:4610-4637 |
| 23 | `/api/w/v1/design-image/<img_path>` | GET, HEAD | 디자인 썸네일 바이트 공개 서빙 | `img_path` = `{prd_cd}/{파일명}` | 이미지 바이트 | **없음(완전 공개)**, `thumb_key` 정확 일치만 | 멱등 | 404 / 405 | 브라우저 | urls.py:288 · widget_api.py:4640-4665 |
| 24 | (참고) `OPTIONS` 프리플라이트 | OPTIONS | `api_endpoint` 데코레이터가 붙은 전 경로에 204 응답 + CORS 헤더 | — | `204` | 게이트 없음(전달 계층만) | 멱등 | — | W | widget_api.py:582-607 |

행 24는 별도 경로가 아니라 데코레이터 동작이므로 경로 수 22 에 포함되지 않는다(참고행).

**미확인 셀 — 닫는 방법**
- 6번 multipart 의 액션별 정확한 응답 키: `_multipart_dispatch`(widget_api.py:3560-3667)를 액션별로 완독하면 닫힌다. 이 문서는 SDK 가이드의 요약 표기(`gen_sdk_guide.py:611-613`)를 인용했다.
- 3·7번의 `set`(셋트) 요청 하위 스키마 전체: `_prep_set_body`(widget_api.py:1746-1818) 완독 필요.
- 7번 `payload` 의 전체 키 목록: `_quote`(widget_api.py:2997-3455, 약 460줄) 완독 필요. 이 표는 SDK 가이드가 공개한 키만 적었다.

---

## 3. 인증·게이트 모델

### 3.1 자격증명 3종

운영자 매뉴얼은 이 중 하나(사이트 키)만 다룬다 — 「위젯을 붙일 수 있는 도메인 목록과 그 열쇠입니다. 등록되지 않은 도메인에서는 위젯이 동작하지 않습니다.」(manual_content.py:70). 나머지 둘은 SDK 가이드와 코드에만 있다.

| 자격증명 | 공개 여부 | 형태 | 자리 | 역할 | 근거 |
|---|---|---|---|---|---|
| `site_key` | **공개** — 임베드 태그·페이지 소스에 노출 | `wk_…`, 최대 64자 | GET=쿼리, POST=본문 | 문패 — 어느 사이트의 호출인가. 허용도메인과 짝 | 가이드 :41, :308 · `t_wgt_sites.site_key` models.py:830 |
| `X-Huni-Server-Key` | **비공개** — 서버 환경변수에만 | `hsk_…` 50자 남짓 | **요청 헤더**(URL·액세스로그에 남지 않는 자리를 고른 것) | 열쇠 — 서버-투-서버 인증 | 가이드 :296-310 · widget_api.py:117-134, SERVER_KEY_HEADER :134 |
| 서명 토큰 | 비공개(후니가 보관) | HMAC-SHA256, SECRET_KEY 파생, 컨텍스트 `huni-widget-handoff-v1` | `/handoff` 응답 → 이후 요청 본문 | 주문 1건의 서명된 사양·금액. TTL 3600초 | widget_api.py:53-55, `_sign`/`_verify` :2511-2564 |

**서버키 저장은 평문이 아니라 SHA-256 해시**(`t_wgt_sites.svr_key_hash`, models.py:835). 그래서 「키를 다시 알려 주세요」는 성립하지 않고 재발급뿐이며, 재발급 즉시 옛 키가 무효다(widget_api.py:122-127). 발급 도구는 `raw/webadmin/tools/issue_server_key.py`. 대조는 `hmac.compare_digest`(widget_api.py:186). IP 화이트리스트는 쓰지 않는다 — 「자사몰이 Vercel 이라 나가는 IP 가 고정이 아니다」(widget_api.py:132).

### 3.2 게이트가 실제로 어떻게 걸리나

`_gate`(widget_api.py:548-580) 순서: ① `site_key` → `_site()` 조회(`del_yn='N'`, `use_yn≠'N'`) ② 실패 시 **IP 버킷 리밋**(무효 키 무차별대입 1겹 방어, 분당 600) 후 403 `bad_site_key` ③ `_origin_allowed` ④ 사이트 분당 240 ⑤ `wgt_cd` 필수 ⑥ `_widget()` — 위젯 존재·사이트 일치·게시(.02)·활성버전·상품 판매중.

**허용도메인 판정**(`_origin_allowed`, widget_api.py:498-507): `site.allow_domains`(jsonb 배열)가 **비어 있으면 통과**한다. 값이 있으면 `Origin` 또는 `Referer` 의 host 를 비교하되 `*.` 접두는 제거하고, `host == d` 또는 `host.endswith("." + d)` — 즉 **서브도메인 자동 통과**. Origin·Referer 가 둘 다 없으면(=서버·curl) **거절**된다.

가이드가 이 동작을 운영 관점으로 풀어 준다: Vercel 프로덕션을 등록해도 브랜치 프리뷰 호스트는 다른 호스트라 `origin_not_allowed` 로 막히니 프리뷰 주소도 함께 등록해야 하고(가이드 :57), `localhost`·`127.0.0.1` 은 등록하면 포트 무관 통과한다(:58).

**경로별 게이트 실제 적용** — 여기가 가이드와 코드가 갈리는 지점이다.

| 게이트 조합 | 해당 경로 |
|---|---|
| SK + OD + 분당240 (`_gate` 전체) | widgets, price, validate, handoff, upload/presign, upload/multipart, editor/resolve, editor/token |
| SK + OD + 분당240 (직접 조립) | catalog, designs |
| SK만(OD 없음) + 전용버킷 | handoff/verify(SVK 선택), handoff/requote(`rq:` SVK 선택), guides(`gd:`), main-images(`mi:`), order/register(`or:` SVK 조건부 필수) |
| SK + **SVK 필수** + `ct:` + **CORS 미개방** | cart/items, cart/items/fetch, cart/items/{id} PUT·POST·DELETE |
| 게이트 없음(완전 공개) | swatch, main-image, design-image |
| URL 비밀경로만 | shopby/webhook |

### 3.2a 라이브 관측 — 두 개의 403 은 원인이 다르다 (2026-09-02, 읽기 전용)

조율자가 실행한 관측(추정 아님, 관측된 사실):

| 호출 | 결과 |
|---|---|
| `curl -s https://huni-admin.printly.co.kr/api/w/v1/catalog` (키 없음) | **HTTP 403** · `{"ok": false, "error": "유효하지 않은 site_key 입니다.", "code": "bad_site_key"}` |
| `curl -s ".../api/w/v1/catalog?site_key=wk_invalid"` (키 틀림) | **동일한 HTTP 403 / `bad_site_key`** |

두 가지를 읽을 수 있다.

1. **키 누락과 키 오류가 호출자에게 구분되지 않는다.** 코드가 그렇게 짜여 있다 — `_site(key)` 는 `key` 가 falsy 면 즉시 `None` 을 돌려주고(widget_api.py:108-114), 호출부는 두 경우를 같은 분기로 처리한다(widget_api.py:4427-4431). 무효 키 무차별대입에 정보를 주지 않으려는 설계로 읽히지만, 파트너 디버깅에서는 「키를 안 실었나 / 키가 틀렸나」를 구분할 수 없다.
2. **`bad_site_key` 와 `origin_not_allowed` 는 둘 다 403 이지만 원인이 다르다.** 서버·curl 처럼 브라우저가 아닌 호출자는 `site_key` 게이트를 먼저 만나므로 `origin_not_allowed` 에 **도달조차 하지 않는다**(순서: site_key → Origin → rate limit, widget_api.py:4426-4437). 유효한 키를 실은 뒤 등록되지 않은 도메인의 브라우저에서 부를 때만 `origin_not_allowed` 가 나온다.

| 코드 | HTTP | 원인 | 언제 보이나 |
|---|---|---|---|
| `bad_site_key` | 403 | 키 없음 **또는** 키가 무효(삭제·사용중지 포함) | 모든 호출자 |
| `origin_not_allowed` | 403 | 키는 유효한데 `Origin`/`Referer` 호스트가 `allow_domains` 밖 | 브라우저 호출자만(키 통과 후) |
| `site_mismatch` | 403 | 키는 유효한데 그 위젯·토큰이 이 사이트 소속이 아님 | 위젯 코드를 잘못 짝지은 경우 |
| `bad_server_key` | 403 | `X-Huni-Server-Key` 없음 또는 틀림 | `cart/*`(필수), 나머지 S2S 경로(값이 틀렸을 때) |

근거: `gen_sdk_guide.py:692-693`(오류 사전), widget_api.py:548-580, :4426-4437.

### 3.3 서버키 필수 전환 스위치 (운영상 중요)

`/handoff/verify`·`/handoff/requote`·`/order/register`(token 경로)는 현재 서버키가 **선택**이다 — 헤더를 안 보내면 통과하되 `NOKEY` 이벤트를 남기고, 보냈는데 틀리면 403 `bad_server_key`(widget_api.py:168-196). 필수 전환은 코드 배포 없이 Railway 환경변수 `WAPI_SERVER_KEY_REQUIRED` 하나로 한다(`_sk_required`, widget_api.py:141-152, 기본 False). `cart/*` 는 스위치와 무관하게 처음부터 fail-closed 이고, `order/register` 의 `item_id` 경로도 스위치와 무관하게 필수다(widget_api.py:4212-4216).

**전환 판단 재료**: `t_wgt_abuse_logs` 의 NOKEY 기록이 며칠간 0 인 것을 보고 켠다(widget_api.py:175-180). → **쇼핑몰 팀 액션**: `X-Huni-Server-Key` 를 세 경로에도 미리 싣기 시작해야 스위치를 켤 수 있다. 현재 쇼핑몰의 requote 프록시(`src/app/api/printly/requote/route.ts:57-63`)가 이 헤더를 싣는지는 그 파일의 헤더 블록을 완독해 확인할 것(이 조사에서는 헤더 구성 부분까지 읽지 않았다 — **미확인**).

### 3.4 사이트 등록은 어디서 하나

`t_wgt_sites`(모델 `TWgtSites`, models.py:826-848, 테이블 설명 「허용사이트」). 컬럼: `site_cd`, `site_nm`, `allow_domains`(jsonb), `site_key`, `svr_key_hash`, `use_yn`, `del_yn`.

**전용 관리 화면이 없다.** Django admin 의 제네릭 자동 등록 루프(`raw/webadmin/webadmin/catalog/admin.py:2049-2243`)가 catalog 앱 전 모델을 표준 목록/변경 화면으로 등록하므로, 허용 사이트도 그 표준 changeform 으로만 편집된다. 서버키는 이 화면으로 만들 수 없고 CLI(`tools/issue_server_key.py`)로만 발급된다. 빌더는 사이트 목록을 읽기만 한다(widget_views.py:96-97).

### 3.5 빌더 미리보기는 고객 게이트를 어떻게 우회하나

빌더 미리보기는 **관리자 세션이 권한**이고 대상이 **작성중 작업본**이라 `site_key` 게이트를 타지 않는 별도 경로를 쓴다 — `widget_preview_presign`(`raw/webadmin/webadmin/catalog/widget_views.py:828-843`). 그 docstring 이 근거다: 「런타임(`/api/w/v1/upload/presign`)은 site_key 로 고객을 게이트하지만, 빌더 미리보기는 **관리자 세션**이 권한이고 **작업본(게시 전 항목)**을 대상으로 한다. 그래서 별도 경로다.」

우회가 무제한이 아니다. 두 겹의 격리가 있다(widget_views.py:836-843):
- 업로드 키를 `PREVIEW-{site_cd}` 로 만든다. handoff 의 `key_belongs` 는 `/{site_cd}/` 를 찾으므로 `/PREVIEW-SITE_A/` 에는 `/SITE_A/` 가 없어 **미리보기 키로는 실제 주문이 성립하지 않는다**.
- 파일 검증 규칙은 런타임과 **같은 `_check_files`** 를 쓴다 — 미리보기에서 통과한 설정이 실주문에서 막히면 미리보기의 의미가 없기 때문.

반면 `/sdk/demo/` 는 우회가 **없다** — 「데모=게시 위젯 실임베드(실서비스 경로 그대로 — site_key 게이트 포함, 우회 없음)」(urls.py:243-244).

### 3.5a 정책·제한 하드 넘버 (가이드 §17, :2119-2124)

| 항목 | 값 | 코드 근거 |
|---|---|---|
| 레이트 리밋 — 브라우저 경로 | 사이트당 **240회/분** | `RATE_LIMIT_PER_MIN = 240` widget_api.py:429 |
| 레이트 리밋 — 서버-투-서버(`cart/*` · 재견적 · 주문 등록 · 가이드 · 메인이미지 · 디자인) | 각 **600회/분**(버킷 분리) | widget_api.py:435, :437, :441, :445, :446, cart_items.py:53 |
| 레이트 리밋 — 무효 site_key 요청의 IP 버킷 | **600회/분** | `RATE_LIMIT_IP_PER_MIN = 600` widget_api.py:430 |
| 429 응답 | `rate_limited` + `Retry-After: 60` | widget_api.py:447, `_rate_limited` :537-546 |
| 핸드오프 토큰 TTL | **3600초** | `HANDOFF_TTL_SEC = 3600` widget_api.py:53 |
| 장바구니 항목 보관 | **30일**(담은 날 기준, 갱신해도 미연장) — 원고 파일 수명과 같은 값 | `CART_TTL_SEC = WAPI.REQUOTE_MAX_AGE_SEC` cart_items.py:46 → `REQUOTE_MAX_AGE_SEC = 30*24*3600` widget_api.py:2557 |
| presign 발급 | 1회 최대 **20개 URL** | `PRESIGN_MAX_BATCH = 20` widget_api.py:3498 |
| 일괄 조회 | 1회 최대 **50건** | `FETCH_MAX = 50` cart_items.py:49 |
| 파일 크기 | 기본 **500MB/파일**(위젯 설정), **100MB 초과 자동 멀티파트** | 가이드 :184, :2003 |
| 오류 상태코드 | **비즈니스 거절은 422 로 통일**(5xx 아님) — 본문 `code` 로 분기 | 가이드 :2124 |
| 자산 캐시 | `widget.js` 는 무버전 URL, 내부 자산은 `?v=버전` 자동 페어링 | widget.js:24-27 |
| 오류 응답 형태 | 항상 `{ "error": 사람이 읽을 메시지, "code": 기계용 코드 }` | `_err` widget_api.py:86-91 |
| 오류 코드 사전 | 약 **90개** 코드 × HTTP 상태 × 대처 | `gen_sdk_guide.py:691-813` (`ERROR_DICT`) |

### 3.5b 위젯 없이 API 를 직접 쓸 때의 정규 호출 순서 (가이드 §16, :2110-2117)

```
(선택) GET  /catalog                 → 임베드 가능 위젯·상품·카테고리로 상품 페이지 구성
       GET  /widgets/{wgt_cd}        → meta.prod_dims·opt_groups 로 선택 UI, cfg.items 가 화면 구성
반복    POST /price                   → 선택이 바뀔 때마다. ok:false 면 그 조합은 판매 불가
(원고)  POST /upload/presign → S3 PUT → 반환 key 보관
       POST /handoff                 → 최종 선택값 전체 + files(위 key). 성공 시 token/payload
파트너서버 POST /handoff/verify        → 검증된 payload 의 금액으로 주문 확정
```

이 순서가 §2 표의 **호출 주체 열의 척추**다. 그리고 가이드가 못박은 규칙 하나 — 「직접 호출 시에도 검증 규칙은 동일하게 적용됩니다 — **위젯을 우회한다고 통과 기준이 느슨해지지 않습니다(fail-closed)**. 화면에서 허용한 조합이 handoff 에서 422 로 거절되면, 화면 로직이 서버 규칙과 어긋난 것입니다.」(:2117)

### 3.6 가이드 서술 ↔ 코드 불일치 (발견)

| 가이드 서술 | 코드 사실 | 영향 |
|---|---|---|
| 「모든 엔드포인트는 site_key 게이트(+ **도메인 검사** + 분당 240회 제한)를 지납니다」(가이드 :1517) | 도메인 검사를 **안 하는** 경로가 6개(verify·requote·guides·main-images·order/register·cart/*), 분당 240 이 아닌 전용 버킷 600 을 쓰는 경로가 7개, 게이트가 **아예 없는** 공개 경로가 3개(swatch·main-image·design-image) | 파트너가 「서버에서 부르면 다 막힌다」고 오해하거나 반대로 「공개 이미지 경로도 site_key 로 보호된다」고 오해할 수 있음 |
| 「CORS 는 전 엔드포인트 허용(Origin 에코)입니다」(가이드 :1518) | `cart/*` 는 **CORS 를 의도적으로 내보내지 않는다** — `s2s_endpoint` 가 `api_endpoint` 와 「일부러 다르게」 CORS 헤더도 OPTIONS 도 처리하지 않아 브라우저는 preflight 에서 막힌다(cart_items.py:78-96) | 「브라우저에서 cart API 를 부르면 된다」는 오독 위험. 다만 가이드 본문(:519, :726)은 cart/* 브라우저 호출 불가를 정확히 적고 있어 **부록(§14) 한 줄만 낡았다** |
| 분당 240회로 단일 표기 | 실제는 버킷별로 다름 — 기본 240(`RATE_LIMIT_PER_MIN`, widget_api.py:429), IP 600, requote/order/guide/main-img/design/cart 각 600 (widget_api.py:429-447) | 파트너가 결제 경로 동시성을 과소평가할 수 있음 |

이 세 줄은 SDK 가이드 부록 §14 의 총론 문장이고, 각 엔드포인트 상세 항목은 대체로 정확하다. **개발자 전달 대상**으로 §6 에 기록한다.

---

## 4. 「리소스 공유」가 실제로 공유하는 것 — 원장(system of record) 분계

SDK 가이드가 한 줄로 정리한 분계선을 기준선으로 삼는다(`sdk-guide-live-20260902.txt:262-263`):

> 「무엇이 담겼나 · 몇 개인가 · 지웠나」는 샵바이가, 「무엇을 어떻게 만드나 · 얼마인가」는 저희(후니)가 갖습니다. 둘을 잇는 것이 `item_id` 입니다.

| 자원 | 원장(권위) | 전달 통로 | 상대편이 갖는 것 | 근거 |
|---|---|---|---|---|
| **상품·옵션·공정·자재 카탈로그** | **후니** (`t_prd_*`·`t_cod_*`) | `GET /widgets/{wgt_cd}` 의 `meta`, `GET /catalog` | 표시용 최소 필드만(R2 필터 — `matched_row`·공식명·`use_dims` 등 원가 역산 가능 필드는 절대 미포함) | widget_api.py:1-13, `_runtime_meta` :673-680 |
| **가격** | **후니 서버, 항상 재계산** | `POST /price`(표시용), `POST /handoff`(서명 확정가) | 쇼핑몰은 어떤 금액도 계산하지 않음. 샵바이에는 「판매가 10원 상품 × 수량」 형태로 실림 | widget_api.py:8-10, `SHOPBY_PRICE_UNIT=10` :60-66 |
| **제약 규칙** | **후니** | `/widgets` 응답의 `constraints` 원문(프런트 ceEval 용) + `/validate` 서버 판정 | 클라 판정은 UX용, 최종 관문은 handoff | widget_api.py:676-678 |
| **주문 사양 + 금액(서명)** | **후니**(토큰이 원본) | `/handoff` → token, `/handoff/verify` → 검증된 payload | 쇼핑몰은 토큰을 샵바이 `optionInputs.huni_token` 텍스트로 나르거나(현행) 아예 안 만짐(권장 B안) | huni-widget.tsx:47-80 / 가이드 :169-172 |
| **장바구니 항목의 부가정보(사양·금액·원고키)** | **후니** (`t_wgt_cart_items`) | `cart/*` 4종 | 쇼핑몰은 36자 `item_id` 하나만 샵바이 텍스트 옵션에 실음 — **자체 테이블 불필요** | cart_items.py:1-27 / 가이드 :255-260 |
| **장바구니 자체(무엇이·몇 개·지웠나)** | **샵바이** | 샵바이 Cart API | 후니는 관여 안 함 — 「이중 원장이 되지 않는다」가 A안 기각 사유 | cart_items.py:9-11 |
| **주문서·결제·주문 원장** | **샵바이** | 샵바이 주문 API + 웹훅 | 후니는 `order/register` 로 사양을 주문번호에 묶어 보관만 | 가이드 :1389 / widget_api.py:4198-4210 |
| **원고 파일(업로드)** | **후니 S3** | `/upload/presign`·`/upload/multipart` — 파일은 후니 서버를 지나지 않고 브라우저→S3 직행 | 쇼핑몰은 `payload.files[]` 참조만 | widget_api.py:3502-3506 |
| **원고(편집기 결과)** | **Edicus**(프로젝트) + 후니(uid·prjid 매핑) | `/editor/resolve`(PSCode·템플릿 결정) · `/editor/token`(사용자 토큰 **대리 발급** — 비밀 API 키는 후니 서버에만) | 쇼핑몰은 `payload.editors[].result.prjid` 를 주문에 저장 | widget_api.py:4380-4404 / `src/types/huni-widget.d.ts:12-20` |
| **스와치 이미지(자재·공정·책등규격)** | **후니 마스터**(`swatch_img_key` → S3) | `GET /swatch/{kind}/{code}` 공개 프록시 | 브라우저가 `<img src>` 로 직접 로드. 키 원문은 절대 노출 안 함 | widget_api.py:613-619, :842-871 |
| **상품 메인이미지** | **후니**(`t_prd_main_imgs`) | `/main-images`(목록, S2S) + `/main-image/{path}`(바이트, 공개) | 활성 행 `file_key` 정확 일치만 서빙 | widget_api.py:883-909, :4569-4607 |
| **디자인(고정사양 묶음)·썸네일** | **후니**(`t_prd_designs`) | `/designs` + `/design-image/{path}` | 현재 쇼핑몰 미사용 | widget_api.py:4610-4665 |
| **작업가이드 파일** | **후니**(`t_prd_guide_files` → S3) | `GET /guides` — `download_url` 은 **만료형이라 호출마다 재발급, DB 캐시 금지** | 쇼핑몰 웹서버 전용 | widget_api.py:4509-4566 |
| **시작가(목록 대표가)** | **후니** — 매일 새벽 배치가 위젯 첫 화면 기본 사양으로 미리 계산 | `/catalog` 의 `start_price{amt,qty,src,basis}` | ⚠ **최저가가 아니라 기본 사양 기준가** — 「~부터」 표기는 `basis=design_min` 일 때만 사실 | gen_sdk_guide.py:263-273 / 운영자 용어는 manual_content.py:73 |
| **결제·취소·배송 이벤트** | **샵바이** | `POST\|PUT /shopby/webhook/{secret}` — 후니는 원문 저장 후 즉시 200 | 웹훅 본문은 **판단 근거가 아니라 신호**. 실제 상태·금액은 나중에 주문조회 API 로 다시 읽어 판단(fail-closed) | shopby_hook.py:11-16 |
| **위젯 화면 구성(cfg)** | **후니 위젯빌더 게시 버전 스냅샷** | `/widgets` 의 `cfg` | 저장≠게시 — 게시본만 서빙 | widget_manual_content.py:641-651 |
| **겉모양(색·글꼴·간격)** | **쇼핑몰** | `--hw-*` CSS 변수 | 「위젯빌더는 무엇을 보여줄지를, 사이트는 어떤 색으로 보여줄지를 담당」 | widget_manual_content.py:727-729 |

---

## 5. 깨지면 무엇이 무너지는가 (blast radius)

| 엔드포인트 군 | 깨졌을 때 |
|---|---|
| `/widgets/{wgt_cd}` | 위젯이 아예 안 뜬다. 상품 상세의 옵션 패널 전체가 공백 — 주문 동선 시작 불가. 쇼핑몰은 `resolveHuniWidget` 이 null 이면 기존 Configurator 로 폴백하지만(`src/lib/printly/widget.ts:110-125`), 이 API 자체 실패에는 폴백이 없다 |
| `/catalog` | 파트너가 위젯 목록을 프로그램으로 못 얻음. **현재 쇼핑몰은 DB 직접 조회라 즉시 영향 없음** — 대신 DB 스키마 변경 시 쇼핑몰이 조용히 깨진다 |
| `/price` | 가격이 「계산 중」에서 멈춘다. 선택은 되지만 금액 표시 불가 → 사실상 주문 불가 |
| `/validate` | 제약 위반 조합이 화면에서 통과. 최종 관문(handoff)이 422 로 막으므로 **주문은 안 새지만**, 고객이 담기 직전에야 거절당함 |
| `/handoff` | **주문 전면 중단.** 서명 토큰이 없으면 담기·결제 어느 것도 성립하지 않음 |
| `/handoff/verify` | 파트너가 금액을 검증할 수 없음 → 브라우저가 보낸 금액을 믿는 순간 **금액 위조 노출**. 현행 쇼핑몰은 토큰을 샵바이 텍스트 옵션에 싣는 경로라 검증 누락이 곧 결제 금액 오류 |
| `/handoff/requote` · `cart/items/{id}` PUT | **결제 직전 갱신 불가 → 장바구니 항목 결제 전면 불가**(토큰 1시간). 담긴 물건은 있는데 결제가 안 되는 형태로 나타남 |
| `cart/items`(담기) | 담기 자체 실패. 이 경로가 죽으면 토큰 직접 보관 방식(구 경로)으로 폴백해야 하는데 쇼핑몰이 그 테이블을 안 만들었다면 폴백 없음 |
| `cart/items/fetch` | 장바구니 화면에 금액·요약이 안 뜸(샵바이 줄은 보이되 내용 미상) |
| `cart/items/{id}` DELETE | 무해 — best-effort, 30일 TTL 이 정리(cart_items.py:588-594) |
| `/order/register` | **결제된 주문의 사양 유실.** 이후 웹훅은 주문번호만 들고 오므로 「무엇을 만들지 알 수 없는」 주문이 생김. 동시에 원고 승격(tmp→order)이 안 돌아 원고가 30일 뒤 소멸 |
| `/shopby/webhook/{secret}` | **결제 사건 영구 유실.** 샵바이는 실패한 웹훅을 재전송하지 않는다 — 결제는 됐는데 생산이 시작되지 않는 사고(shopby_hook.py:5-8). 저장 실패 시 500 을 주는 것도 샵바이 실패목록에 남기려는 의도 |
| `/upload/presign` · `/upload/multipart` | 파일 업로드형 상품 주문 불가. `abort` 가 못 돌면 조각이 보이지 않는 채 **S3 과금**(widget_api.py:3673-3676) |
| `/editor/resolve` · `/editor/token` | 편집기(Edicus) 상품 주문 불가. `resolve` 실패는 편집기 버튼이 열리지 않는 형태, `token` 실패는 편집기가 열려도 인증 실패 |
| `/swatch/*` | 색·질감 견본이 이름 첫 글자 플레이스홀더로 폴백(widget_manual_content.py:604-607). 주문은 가능하나 선택 정확도 하락 |
| `/main-image*` · `/designs` · `/design-image` | 상품 이미지·디자인 목록 공백. 디자인 선택형 상품은 주문 진입 자체 불가 |
| `/guides` | 작업가이드 다운로드 불가. 고객이 규격 틀린 원고를 올릴 확률 상승(주문은 성립) |
| `widget.js`(정적 스크립트) | 전 상품 위젯 마운트 실패. `?v=` 페어링이 깨지면 신 `widget.js` + 구 렌더러 조합으로 **계약이 조용히 갈릴 수 있음**(widget.js:24-27) |

---

## 6. 갭 보드 — 개발자·담당자 전달 대상

운영자 매뉴얼에 SDK 계약이 없는 것은 §0 대로 **범위 경계이지 결함이 아니다.** 아래는 그것과 별개로 확인된 진짜 갭이다.

| # | 갭 | 성격 | 닫는 방법 |
|---|---|---|---|
| G-1 | SDK 가이드 부록 §14 총론 3문장이 실제 게이트와 어긋남(§3.6) — 원고는 `raw/webadmin/tools/gen_sdk_guide.py` — 「모든 엔드포인트가 도메인 검사」, 「CORS 전 엔드포인트 허용」, 「분당 240회」 | 문서 결함(개발자 오독 유발) | `tools/gen_sdk_guide.py` 의 §14 머리말을 게이트 조합별 표로 교체 |
| G-2 | **허용 사이트 등록 절차가 운영자 매뉴얼에 없다** — 용어 정의(manual_content.py:70)만 있고 「어디서·어떻게 등록하나」가 없음. 실제로는 전용 화면 없이 Django 표준 changeform 이고, 서버키는 화면으로 만들 수 없으며 CLI 전용 | **운영자 매뉴얼의 진짜 누락** — 운영자가 「새 도메인에 붙이려면 허용 사이트에 도메인을 먼저 등록해야 합니다」(widget_manual_content.py:723-724)를 읽고도 등록할 방법을 알 수 없음 | manual_content.py 의 SCREENS 또는 MODEL_ADMIN_SCREENS 에 「위젯 › 허용 사이트」 항목 추가 + 서버키는 담당 개발자 요청 절차임을 명시 |
| G-3 | 서버키 필수 전환(`WAPI_SERVER_KEY_REQUIRED`)에 쇼핑몰이 준비돼 있는지 **미확인** | 운영 리스크 — 켜는 순간 세 경로가 403 | `src/app/api/printly/requote/route.ts` 의 fetch 헤더 블록(:57 이후)과 order/register 호출부에서 `X-Huni-Server-Key` 전송 여부 확인. 후니 쪽은 `t_wgt_abuse_logs` 의 NOKEY 건수 조회 |
| G-4 | 쇼핑몰이 위젯 해석을 **API 가 아니라 Railway DB 직접 SELECT** 로 함(`src/lib/printly/widget.ts:65-99`) | 숨은 결합 — `t_wgt_sites`/`t_wgt_widgets`/`t_wgt_widget_versions` 스키마 변경이 API 계약과 무관하게 쇼핑몰을 깬다 | `/catalog` 로 이관하거나, 이 DB 의존을 계약 문서에 명시적 항목으로 등재 |
| G-5 | `design` 속성 미배선 → `/designs`·`/design-image` 두 엔드포인트가 통째로 미사용 | 기능 미완 | 디자인 다건 상품(포토북 등) 출시 범위에 포함되는지 확인. 포함이면 디자인 목록 페이지 + `design` 속성 전달 구현 필요 |
| G-6 | 중복 제출 가드가 위젯에 없음(가이드 :169). 쇼핑몰은 `busy` 로 막고 있으나 **경합 조건 검증 미확인** | 잠재 결함 — 연타 시 handoff 다중 서명 | 쇼핑몰 버튼 핸들러의 `setBusy` 순서를 `el.submit()` 호출 **이전**으로 확정했는지 확인(huni-widget.tsx 제출 핸들러 완독) |
| G-7 | 「27개 공개 경로」주장의 근거 불명(§2.0) — 실측 22(`urls.py`), 공개 문서화 21(`gen_sdk_guide.py` `ENDPOINTS`) | 기준선 불일치 | 27 의 출처 문서를 특정해 세는 단위를 합의. 이후 `tests/test_sdk_guide.py` 의 드리프트 가드(:43-50)에 개수 assertion 추가 권장 |
| G-8 | `/handoff` payload 전체 키 목록이 공개 문서에 없음(가이드는 대표 키만) | 문서 갭 | `_quote`(widget_api.py:2997-3455) 완독 후 payload 스키마를 계약 문서에 확정 |
| G-9 | 서명 토큰 TTL 3600초와 보관 30일(`REQUOTE_MAX_AGE_SEC`, widget_api.py:2557)의 관계가 운영자에게 안 보임 | 운영 문의 유발 — 「담아 뒀는데 결제가 안 돼요」 | 운영자 매뉴얼 FAQ 에 「장바구니 30일 / 견적 1시간 / 결제 직전 자동 재견적」 한 줄 추가 |
| G-10 | `bad_site_key` 가 **키 누락과 키 오류를 구분하지 않음**(§3.2a 라이브 관측) | 의도된 보안 설계이나 파트너 디버깅 비용 | 현행 유지가 타당. 대신 SDK 가이드 오류 사전의 `bad_site_key` 설명에 「없음/무효를 구분하지 않는다」를 명시(`gen_sdk_guide.py:692`) |
| G-11 | `allow_domains` 가 **비어 있으면 도메인 검사가 통과**한다(widget_api.py:500-501) | 잠재 노출 — 등록만 하고 도메인을 안 채운 사이트는 어느 도메인에서든 임베드 가능 | `t_wgt_sites` 에서 `allow_domains` 가 null·빈 배열인 활성 사이트를 실측(라이브 담당). 있으면 채우거나, 빈 배열을 「전부 거절」로 뒤집는 정책 변경 검토 |

---

## 7. 이 조사가 하지 않은 것 (잔여 위험)

- **라이브 호출 없음.** 상태코드·오류코드는 전부 코드 및 SDK 가이드 원고에서 읽은 값이고, 실제 응답을 관측하지 않았다. 라이브 검증은 별도 담당.
- **완독하지 않은 코드**: `_quote`(약 460줄), `_multipart_dispatch`, `_prep_set_body`, `widget_renderer.js`(6,965줄), 쇼핑몰의 `huni-widget.tsx` 후반부(제출 핸들러·재개 로직)·`src/lib/api/widget-order.ts`. 이 문서에서 「미확인」으로 표시한 셀은 전부 이 범위에서 나온다.
- **DB 조회 없음.** `t_wgt_sites` 에 실제로 몇 개 사이트가 등록돼 있는지, `allow_domains` 가 비어 있는 사이트가 있는지(=도메인 검사 무력화 상태) 확인하지 않았다. `allow_domains` 가 비면 통과하는 구조(widget_api.py:500-501)라 **운영 실측이 필요한 항목**이다.
- SDK 가이드 캡처본은 2026-09-02 시점 스냅샷이다. 가이드는 `tools/gen_sdk_guide.py` 에서 생성되므로 그 파일이 바뀌면 가이드도 바뀐다.
