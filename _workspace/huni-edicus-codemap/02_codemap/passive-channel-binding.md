# passive 채널 배선 대조 (재실행: passive 정밀 대조)

> 권위: `docs/edicus.man/src/**` 코드 직접 grep/Read. 모든 사실에 `파일:라인`. 추정 금지·불명확은 "모름".
> 목적: 역공학에서 드러난 두 passive 레이어 — **공식 Edicus**(`from-edicus*` 메시지, 14 action) vs **RedEditorSDK KOI-Passive**(`From-KOI-Passive`, 4 type=load/save/error/close) — 중 **후니 edicus.man 코드가 실런타임에서 실제로 어느 채널을 보는가**를 증거로 확정.

---

## 0. 결론 (TL;DR)

**후니 edicus.man 런타임 코드는 전부 공식 Edicus 채널(`from-edicus*`)을 따른다.** 메시지 식별 키는 `data.action ?? data.type`(또는 `type ?? action`)이며, 콜백은 공식 SDK `window.edicusSDK`(`ctx.create_project(params, callback)`)가 호출하는 `EdicusCallbackData{type, action, info}`를 본다. `EdicusCallbackData.type`은 코드 주석에서 명시적으로 **"from-edicus-* 타입 메시지"** 로 정의된다(`src/types/edicus.ts:70-72`).

**RedEditorSDK의 `From-KOI-Passive` 4-type(load/save/error/close) 핸들러는 후니 런타임에서 호출되지 않는다.** 이 핸들러는 오직 역공학 잔재 파일 `src/lib/red-editor/analyzed/*.js`(es6-converted.js:14003, formatted.js:14415)에만 존재하며, 그 디렉터리(`src/lib/red-editor/`=wrapper.ts + analyzed/* + .d.ts)는 **어떤 런타임 라우트/컴포넌트에도 import되지 않는다**(아래 §4). 즉 KOI-Passive 채널은 **참조용 잔재**다.

| 질문 | 답 (증거) |
|---|---|
| 후니가 보는 passive 계약 | **공식 from-edicus** (RedEditorSDK KOI-Passive 아님) |
| passive 식별 키 | `data.action ?? data.type` (target 문자열 비교 아님) |
| `From-KOI-Passive`/`fromKOIPassive` 사용처 | `src/lib/red-editor/analyzed/*.js`에만 — **런타임 미사용** |
| passive 진입 방법 | `run_mode='passive'` URL 파라미터(공식 Edicus iframe) |
| `src/lib/red-editor/` 실사용 여부 | **잔재**(런타임 import 0건; 타입 1건만 — §4) |

---

## 1. 모듈별 passive 채널 대조표

런타임 메시지 핸들러(=실제 `window` message/SDK 콜백을 받는 코드)만 대상.

| 모듈 | 보는 target/식별키 | 처리 이벤트 | run_mode 지정 | 파일:라인 | 결론(공식 14 vs KOI 4) |
|---|---|---|---|---|---|
| `HuniEditorSDK` (createProject 콜백) | `data.type ?? data.action` | ready·ready-to-listen·close·doc-changed·save-complete·error | — (init이 별도 설정) | `lib/edicus/huni-editor-sdk.ts:138-156` | **공식 from-edicus** |
| `HuniEditorSDK._setupMessageListener` | `data.action ?? data.type` + origin 검증 | _mapToHuniEvent: ready·close·doc-changed·ready-to-listen·save-complete·error | — | `lib/edicus/huni-editor-sdk.ts:280-318` | **공식 from-edicus** |
| `HuniEditorSDK` init | (해당없음) | — | `projectParams.run_mode='passive'` | `lib/edicus/huni-editor-sdk.ts:129-131` | **공식 passive 진입** |
| `EdicusEditor` handleSdkEvent | `data.action ?? data.type` | request-user-token·close·goto-cart | (passive 미지정 경로) | `components/editor/EdicusEditor.tsx:89-111` | **공식 from-edicus** |
| `MobileEditor` handleSdkEvent | `data.action ?? data.type` | request-user-token·close·goto-cart·ready-to-listen·doc-changed | `extraParams.run_mode='passive'` (passiveMode 시) | `components/mobile/MobileEditor.tsx:90-120,158-162` | **공식 from-edicus** |
| `VdpEditor` handleSdkEvent | `data.action ?? data.type` | request-user-token·close | — | `components/editor/VdpEditor.tsx:85-95` | **공식 from-edicus** |
| `PCPassiveEditor` | (직접 핸들러 없음; `useHuniEditor` 경유) | undo/redo/save/close → HuniEditorSDK | `passiveMode: true` → HuniEditorSDK | `components/editor/PCPassiveEditor.tsx:50-54` | **공식 from-edicus (passive)** |
| `EdicusClient` (window.edicusSDK) | `ctx.create_project/open_project(params, cb)` | cb로 공식 SDK 이벤트 전달 | params.run_mode 통과 | `lib/edicus/client.ts:158,183-189,234-237` | **공식 from-edicus (SDK 권위)** |
| `RedEditorWrapper` (잔재) | — (런타임 미사용) | sdk.on(close/request-user-token/goto-cart/save) | — | `lib/red-editor/wrapper.ts:320-338` | **N/A — 잔재** |
| RedEditorSDK 역공학 핸들러 q | `e.target === "From-KOI-Passive"` → e.type | load·save·error·close (KOI 4) | hideToolbar→`run_mode:'passive'` | `lib/red-editor/analyzed/es6-converted.js:14003-14016` (formatted.js:14415) | **KOI-Passive 4 — 런타임 미사용(역공학 잔재)** |

### 핵심 증거 (식별키 = target이 아니라 action/type)

후니 런타임 어디에도 `e.target === '...'` / `From-KOI-Passive` 비교가 없다. 전수 grep 결과 `From-KOI-Passive`·`fromKOIPassive`는 `src/lib/red-editor/analyzed/`에서만 매칭(es6-converted.js:14003,14063; formatted.js:14415,14475 등). 런타임 핸들러는 일관되게:

```
const eventType = data.action ?? data.type;   // EdicusEditor:89, MobileEditor:90, VdpEditor:85, huni-editor-sdk.ts:288
const eventType = data.type ?? data.action;   // huni-editor-sdk.ts:138-139 (createProject 콜백)
```

런타임에서 실제 비교되는 문자열 집합(전수): `request-user-token`·`close`·`goto-cart`·`doc-changed`·`ready-to-listen`·`ready`·`save-complete`·`error` — 전부 공식 from-edicus 이벤트(역공학 KOI 4종 load/save/error/close와 의미·명칭 불일치).

---

## 2. 두 채널 계약 정의 (역공학 원본 기준)

| 채널 | 식별 | 이벤트 셋 | 출처 |
|---|---|---|---|
| **공식 Edicus from-edicus** | `e.type` ∈ {from-edicus, from-edicus-root, from-edicus-tnview}; private는 별도 인터셉트 | RedEditorEventType: close·request-user-token·goto-cart·save·init·refreshToken(+ 후니 매핑 ready·ready-to-listen·doc-changed·save-complete·error) | `lib/red-editor/red-editor-sdk.d.ts:243,478-484`; 역공학 핸들러 `analyzed/es6-converted.js:3778-3783` |
| **RedEditorSDK KOI-Passive** | `e.target === "From-KOI-Passive"` then switch `e.type` | load·save·error·close (4종) | `analyzed/es6-converted.js:14003-14016`, `formatted.js:14415-14422` |

후니 런타임은 **위 첫째 채널만** 본다(§1). KOI-Passive(둘째)는 RedEditorSDK가 자기 부모창에 보내는 신호로, 후니 edicus.man은 RedEditorSDK를 런타임에 로드/구독하지 않으므로(§4) 수신 코드가 존재하지 않는다.

---

## 3. passive 모드 진입(공식 채널) — run_mode 흐름

후니의 passive는 KOI 채널이 아니라 **공식 Edicus의 `run_mode=passive` URL 파라미터**로 진입한다:

- `MobileEditor`: `passiveMode` prop → `extraParams.run_mode='passive'` → `createProject` → `EdicusClient.createProject` → `ctx.create_project`(공식 SDK)(`MobileEditor.tsx:160-164` → `useEdicus.ts:130` → `client.ts:185`).
- `PCPassiveEditor`: `passiveMode:true` → `useHuniEditor` → `HuniEditorSDK.init` → `projectParams.run_mode='passive'`(`PCPassiveEditor.tsx:54` → `huni-editor-sdk.ts:129-131`).
- 타입 계약: `EdicusCommonUrlParams.run_mode?: string  // .. / passive`(`src/types/edicus.ts:111`).

역공학 RedEditorSDK는 `hideToolbar ? 'passive' : 'standard'`로 run_mode를 결정(`analyzed/es6-converted.js:14569,15042,15314,15472`)하나, 이는 잔재 코드이며 후니 런타임은 `hideToolbar`를 사용하지 않는다(런타임 grep 0건; `hideToolbar`는 analyzed/*에만 존재).

---

## 4. `src/lib/red-editor/` = 실런타임 배선인가, 잔재인가? (재확인)

**잔재(reference scaffold)**. 근거(import 전수 grep):

- `RedEditorWrapper`·`getOrCreateWrapper`·`window.RedEditorSDK` 런타임 import: **0건**. `red-editor` 경로 매칭은 `src/types/edicus.ts:347` 주석 1건뿐(타입 `EdicusSDKV2`가 `red-editor-sdk.d.ts`에 선언됨을 설명).
- `wrapper.ts`는 `window.RedEditorSDK`(공식 `window.edicusSDK`와 **다른** 전역)를 래핑(`wrapper.ts:208-280`). 어떤 라우트/컴포넌트도 이를 `new`하지 않는다.
- `analyzed/*.js`(es6-converted.js·formatted.js·red-editor-class.js 등) = RedEditorSDK 난독화 해제 결과물. import 0건, 빌드 진입 0건.
- 디렉터리에 `.gitkeep` 동반(`analyzed/.gitkeep`) — 분석 산출물 보관소 성격.

→ 실런타임 Edicus 배선은 **`src/lib/edicus/`**(client.ts=useEdicus 경유, huni-editor-sdk.ts=useHuniEditor 경유)이며, `src/lib/red-editor/`는 역공학 참조/타입 출처일 뿐 실행 경로가 아니다.

### 라우트→훅→채널 매핑

| 라우트 | 컴포넌트 | 훅 | 실런타임 lib | 채널 |
|---|---|---|---|---|
| `app/editor/[templateId]` | EdicusEditor | useEdicus | `lib/edicus/client.ts`(window.edicusSDK) | 공식 from-edicus |
| `app/mobile/[productId]` | MobileEditor | useEdicus | `lib/edicus/client.ts` | 공식 from-edicus(+run_mode passive) |
| `app/vdp/[templateId]` | VdpEditor | useEdicus | `lib/edicus/client.ts` | 공식 from-edicus |
| (PC passive 진입) | PCPassiveEditor | useHuniEditor | `lib/edicus/huni-editor-sdk.ts`→`client.ts` | 공식 from-edicus passive |

---

## 5. 비고·불확실

- `useEdicus` 경로의 message origin 검증은 SDK 내부(`window.edicusSDK`, 외부 스크립트 `/edicus-sdk-v2.js`)에서 수행되어 **코드 미가시**(검증 위치 단정 불가 — 모름). `HuniEditorSDK`만 후니 코드에서 직접 origin 검증(`TRUSTED_ORIGIN='edicusbase.firebaseapp.com'`·`huni-editor-sdk.ts:278`).
- 이벤트 식별키 정규화 비대칭: `useEdicus` 계열 `action ?? type`(EdicusEditor:89) vs HuniEditorSDK createProject 콜백 `type ?? action`(huni-editor-sdk.ts:138-139). 동작 결과는 동일 셋이나 우선순위 다름.
- `from-edicus-private` 인터셉트(대용량 blob 공급)는 역공학 핸들러(analyzed/es6-converted.js:3783)에만 존재 — 후니 런타임 코드에는 대응 처리 없음(공식 SDK가 내부 처리하는 것으로 보이나 코드 미가시 — 모름).
