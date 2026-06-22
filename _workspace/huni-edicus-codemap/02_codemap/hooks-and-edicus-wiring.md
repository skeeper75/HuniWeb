# hooks ↔ Edicus 배선

> 권위: 코드 직접 분석. 모든 배선에 `파일:라인` 근거. 외부 연동(Edicus SDK·Edicus 서버·Firebase)은 경계 노드.
> 4개 훅: `useEdicus`·`useHuniEditor`·`useAuth`·`useOrder`.

---

## 1. useEdicus (`src/hooks/useEdicus.ts`)

| 항목 | 내용 (근거) |
|---|---|
| 책임 | `EdicusClient` 생명주기를 React에 통합(`:5-7,65`). 마운트 시 init, 언마운트 시 destroy(`:82-114`). |
| 입력 | `containerRef`(마운트 DOM), `config{baseUrl,partner}`, `onEvent`(SDK 콜백)(`:65-69`) |
| 상태 | `isReady`·`error`(`useState`); `clientRef`·`configRef`·`onEventRef`(`useRef`)(`:70-80`) |
| 반환 | `{ isReady, error, client, createProject, openProject, closeEditor, postToEditor }`(`:175-183`) |

Edicus 배선 (EdicusClient 경유 → window.edicusSDK):

| 호출 | SDK 메서드/이벤트 | 근거 |
|---|---|---|
| `client.init()` | `window.edicusSDK.init({base_url})` | `useEdicus.ts:90` → `client.ts:158` |
| `createProject(token,psCode,title,extra)` | `ctx.create_project(params, cb)` | `useEdicus.ts:130` → `client.ts:185` |
| `openProject(token,prjid,extra)` | `ctx.open_project(params, cb)` | `useEdicus.ts:152` → `client.ts:199` |
| `closeEditor()` | `ctx.close({parent_element})` | `useEdicus.ts:167` → `client.ts:212` |
| `postToEditor(action,info)` | `ctx.post_to_editor(action,info)` | `useEdicus.ts:172` → `client.ts:236` |
| destroy(언마운트) | `ctx.destroy({parent_element})` | `useEdicus.ts:105` → `client.ts:222` |
| 콜백(`onEvent`) 처리 이벤트 | `request-user-token`·`close`·`goto-cart` | 콜백 라우팅은 호출 컴포넌트가 처리(EdicusEditor 참조) |

사용처: `EdicusEditor`(`components/editor/EdicusEditor.tsx:116`), `VdpEditor`(`VdpEditor.tsx:100`), `MobileEditor`(`MobileEditor.tsx:125`).

## 2. useHuniEditor (`src/hooks/useHuniEditor.ts`)

| 항목 | 내용 (근거) |
|---|---|
| 책임 | `HuniEditorSDK`(EdicusClient 합성 래퍼) 생명주기 통합·PC passive 편집기용(`:5-7,60`) |
| 입력 | `{containerId, productId, partnerId, passiveMode?, privateCss?}`(`:19-30`) |
| 상태 | `sdkRef`(useRef); `isReady`·`isLoading`·`error`(useState)(`:61-64`) |
| 반환 | `{ sdk, isReady, isLoading, error, undo, redo, save, close }`(`:128-137`) |
| 이벤트 구독 | `sdk.on('ready', …)` → isReady=true(`:80-85`) |

Edicus 배선 (HuniEditorSDK 경유):

| 호출 | SDK 동작 | 근거 |
|---|---|---|
| `sdk.init({...})` | `HuniEditorSDK.init` → `EdicusClient.init()` + `createProject` | `useHuniEditor.ts:89` → `huni-editor-sdk.ts:89,99,135` |
| `undo()` | `client.postToEditor('undo', {})` | `huni-editor-sdk.ts:192` |
| `redo()` | `client.postToEditor('redo', {})` | `huni-editor-sdk.ts:199` |
| `save()` | `client.postToEditor('save-doc', {})` (주의: 'save' 아님) | `huni-editor-sdk.ts:208-210` |
| `close()` | emit 'close' 후 destroy | `huni-editor-sdk.ts:217-220` |

HuniEditorSDK 내부 추가 배선:
- 토큰 발급: `fetch('/api/edicus/auth', {POST})`(`huni-editor-sdk.ts:263`) — **본문 없이 POST**(서버 라우트는 `uid` 요구 → §5 위험).
- postMessage 수신: `window.addEventListener('message', …)` + origin 검증(`TRUSTED_ORIGIN='edicusbase.firebaseapp.com'`)(`huni-editor-sdk.ts:17,278,301`).
- 프로젝트 생성: `createProject` 콜백으로 `ready`/`ready-to-listen`/`close`/`doc-changed`/`save-complete`/`error` 매핑(`huni-editor-sdk.ts:135-158`).
- passive 모드: `run_mode='passive'` 파라미터 추가(`huni-editor-sdk.ts:129-131`).

사용처: `PCPassiveEditor`(`components/editor/PCPassiveEditor.tsx:50`).

## 3. useAuth (`src/hooks/useAuth.ts`)

| 항목 | 내용 (근거) |
|---|---|
| 책임 | Firebase 인증 상태 + Edicus 토큰 + 관리자 권한 통합(`:3-5,39`) |
| 상태 | `user`·`loading`·`error`·`edicusToken`·`isAdmin`(useState)(`:40-44`) |
| 반환 | `{ user, loading, error, edicusToken, isAdmin, login, register, logout }`(`:137-146`) |

Firebase/Edicus 배선:

| 호출 | 대상 | 근거 |
|---|---|---|
| `onAuthChange(cb)` | `firebase/auth onAuthStateChanged` | `useAuth.ts:73` → `lib/firebase/auth.ts:36` |
| `login` | `signInWithEmail` → `signInWithEmailAndPassword(auth,…)` | `useAuth.ts:105` → `auth.ts:17` |
| `register` | `signUpWithEmail` → `createUserWithEmailAndPassword` | `useAuth.ts:116` → `auth.ts:24` |
| `logout` | `signOutUser` → `signOut(auth)` | `useAuth.ts:129` → `auth.ts:30` |
| 관리자 판정 | `firebaseUser.getIdTokenResult().claims['admin']` | `useAuth.ts:78-79` |
| 세션 쿠키 | `document.cookie='__session=<idToken>…'` (미들웨어용) | `useAuth.ts:83-84` |
| Edicus 토큰 발급 | `fetch('/api/edicus/auth', {POST, body:{uid:edicusUid}})` | `useAuth.ts:50-53` |
| edicusUid 정규화 | `generateEdicusUid(firebaseUid)`(영숫자+하이픈, 64자) | `useAuth.ts:49` → `auth.ts:56-63` |

보안 노트: Edicus 토큰은 메모리만 보관, localStorage 미저장(XSS 방지·`useAuth.ts:37-38`). Firebase config는 `NEXT_PUBLIC_FIREBASE_*` 환경변수(`lib/firebase/config.ts:10-17`). 경계 노드=Firebase Auth.

## 4. useOrder (`src/hooks/useOrder.ts`)

| 항목 | 내용 (근거) |
|---|---|
| 책임 | 주문 프로세스(잠정→확정→취소) 관리, 내부 API 호출(`:3-7,68`) |
| 상태 | `order`·`loading{tentative,definitive,cancel}`·`error`(`:69-75`) |
| 반환 | `{ order, loading, error, tentativeOrder, definitiveOrder, cancelOrder, clearError }`(`:166-174`) |

배선 (전부 내부 API 라우트, Edicus SDK 직접 호출 없음):

| 호출 | 엔드포인트 | 근거 |
|---|---|---|
| `tentativeOrder(projectId)` | `POST /api/edicus/orders/tentative` | `useOrder.ts:134-135` |
| `definitiveOrder(projectId)` | `POST /api/edicus/orders/definitive` | `useOrder.ts:144-145` |
| `cancelOrder(orderId)` | `POST /api/edicus/orders/cancel` | `useOrder.ts:155-156` |

주의(§5): `useOrder`는 `/orders/tentative` 등 **서브경로**로 POST하나, 실제 구현 라우트는 `app/api/edicus/orders/route.ts`(POST body `{projectId,type}`, DELETE 취소)뿐 — 서브경로 핸들러 파일 부재(불일치).

## 5. 위험·불일치(코드 근거)

1. **토큰 발급 본문 불일치**: `auth/route.ts`는 `uid` 필수(`auth/route.ts:11-13,21`)인데, `HuniEditorSDK._fetchToken`·`EdicusEditor.fetchUserToken`·`MobileEditor.fetchEditorToken`·`VdpEditor.fetchUserToken`는 **body 없이 POST**(`huni-editor-sdk.ts:263`, `EdicusEditor.tsx:35-37`, `MobileEditor.tsx:35`, `VdpEditor.tsx:41`). → 400 위험. `useAuth.fetchEdicusToken`만 `{uid}` 전달(`useAuth.ts:50-53`).
2. **useOrder 엔드포인트 불일치**: 호출 경로(`/orders/tentative|definitive|cancel`)에 대응하는 route 파일이 없음. 구현은 `orders/route.ts`(POST type 분기·DELETE 취소).
3. **origin 검증 범위**: `HuniEditorSDK`만 message origin 검증(`huni-editor-sdk.ts:278`). `useEdicus` 경로의 콜백은 SDK 내부(window.edicusSDK)에 의존 — 검증 위치 SDK 내부(코드 미가시, 외부 SDK).
4. **이벤트 이름 표기 차이**: `useEdicus` 콜백 data는 `action ?? type`(`EdicusEditor.tsx:89`), HuniEditorSDK는 `type ?? action`(`huni-editor-sdk.ts:138-139`) — 정규화 비대칭.
