# edicus.man — 데이터 흐름 (인증 → 상품선택 → 편집 → 주문)

> 권위: 코드 직접 분석. 외부 연동(Firebase·Edicus 서버·Edicus iframe SDK)은 경계 노드. 모든 흐름에 `파일:라인` 근거.

---

## 1. 인증 흐름

```
사용자 → LoginForm.login(email,pw)
   → useAuth.login → signInWithEmail → Firebase Auth(signInWithEmailAndPassword)  ◀ 경계: Firebase
   → onAuthStateChanged(useAuth.ts:73) 콜백 발화
       ├─ getIdTokenResult().claims.admin → isAdmin (useAuth.ts:78-79)
       ├─ getIdToken() → document.cookie '__session=<idToken>' (useAuth.ts:83-84)  ── 미들웨어 인증용
       └─ fetchEdicusToken: POST /api/edicus/auth {uid:generateEdicusUid(uid)} (useAuth.ts:50-53)
              → server-api.getToken(uid) → EDICUS_API_HOST/api/auth/token  ◀ 경계: Edicus 서버
              → edicusToken(메모리만, localStorage 미저장; useAuth.ts:37-38)
```

라우트 가드: `middleware.ts`가 `__session` 쿠키 존재만으로 `/admin/*`·`/editor/*` 보호(`middleware.ts:9-35`). Edge Runtime이라 토큰 유효성 검증은 안 함(존재 여부만·`:23-28`).

## 2. 상품 선택 흐름

두 경로(데스크탑 RSC vs 모바일 client):

```
홈 RSC (/) page.tsx:26 — searchParams.category로 필터 (page.tsx:27-28)
   → (ProductGrid 등) → fetch /api/edicus/products?partner=… (ProductGrid.tsx:33)
       → resource-api.getProductList(partner) → RESOURCE_HOST/resapi/product/list  ◀ 경계: Edicus Resource 서버
   → 선택 시 /editor/[templateId] 또는 /vdp/[templateId]로 이동

모바일 (/mobile) page.tsx:23 (client)
   → useEffect: fetch /api/edicus/products?partner (mobile/page.tsx:36) → useState products (:25)
   → /mobile/[productId] → fetch products로 상세(:44) → "만들기" → showEditor=true → <MobileEditor> (:77)
```

템플릿 쿼리는 `/api/edicus/templates`(GET) → `resource-api.queryTemplates`(`templates/route.ts:37`) 또는 프록시 `/api/edicus/resource/query`(POST).

## 3. 편집 흐름 (Edicus iframe 통합)

세 편집기 변형, 전부 `useEdicus`→`EdicusClient`→`window.edicusSDK`(또는 useHuniEditor 경유):

```
[PC] /editor/[templateId] → <EdicusEditor> (editor/[templateId]/page.tsx:27)
   1) 마운트: fetchUserToken → POST /api/edicus/auth (EdicusEditor.tsx:34-37)  ※body 미전달(불일치)
   2) useEdicus.init → window.edicusSDK.init({base_url}) (client.ts:158)  ◀ 경계: Edicus SDK 스크립트(/edicus-sdk-v2.js)
   3) isReady+initToken 확보 시:
        projectId 있으면 openProject(open_project) / 없으면 createProject(create_project) (EdicusEditor.tsx:136-139)
   4) iframe 콜백 라우팅 (EdicusEditor.tsx:81-112):
        request-user-token → fetchUserToken → postToEditor('send-user-token',{token})
        close            → router.back()
        goto-cart        → router.push('/orders')

[모바일] <MobileEditor> (MobileEditor.tsx) — useEdicus + getMobileConfig(partner) (mobile-config.ts:28)
   - body scroll lock(마운트 hidden, 언마운트 복구·:68-75)
   - extraParams: mobile/lang/ui_locale/private_css/template_uri (:143-156), passive 시 run_mode=passive(:160-162)
   - passive 콜백: ready-to-listen→onReadyToListen, doc-changed→onDocChanged (:112-120)
   - 툴바: PassiveToolbarBottom undo/redo/save-doc 직접 postToEditor (:218-222)

[PC passive] <PCPassiveEditor> (PCPassiveEditor.tsx:50) — useHuniEditor 경유(HuniEditorSDK)
   - 키보드 단축키 Ctrl/Cmd+Z/Y/S/Esc → undo/redo/save/close (:59-106)
   - HuniEditorSDK가 토큰발급(POST /api/edicus/auth)+message origin 검증 수행(huni-editor-sdk.ts:263,278)

[VDP] /vdp/[templateId] → <VdpEditor> (VdpEditor.tsx:63)
   - 가변데이터 필드 입력 → fieldValues(useState) → postToEditor('set-variable-data',{variableData}) (:120-127)
```

편집기 브랜딩: `getCssForPartner`가 후니 디자인 토큰 CSS(#5538B6)를 `private_css`로 iframe에 주입(`custom-css.ts:21-87,131`).

## 4. 상태 관리 (실측)

| 영역 | 실제 메커니즘 | 근거 |
|---|---|---|
| 인증 상태 | 훅 로컬 `useState` + Firebase `onAuthStateChanged` 구독 + `__session` 쿠키 | `useAuth.ts:40-44,73,84` |
| 편집기 인스턴스 | `useRef`(clientRef/sdkRef) + `useState`(isReady/error) | `useEdicus.ts:70-72`, `useHuniEditor.ts:61-64` |
| 주문 상태 | 훅 로컬 `useState` | `useOrder.ts:69-75` |
| 목록 데이터(서버) | RSC `async` + `fetch(... next:{revalidate:0})` | `projects/page.tsx:14`, `orders/page.tsx:14` |
| 목록 데이터(모바일) | client `useEffect` + `fetch` + `useState` | `mobile/page.tsx:36`, `mobile/[productId]/page.tsx:44` |
| 전역 store | **없음** | — |

⚠ **zustand / react-query 미사용**: 둘 다 `package.json` 의존성에 있으나(`zustand`·`@tanstack/react-query`) src 어디에도 `create()` store·`useQuery`/`useMutation`·`QueryClientProvider` 호출 없음(grep 0건). README 기술스택표(`README.md:138-139`)는 "Zustand 5 / TanStack React Query 5"라 명시하나 코드와 불일치 → **현 상태는 로컬 useState + RSC/fetch 패턴**. 루트 레이아웃에도 Provider 없음(`layout.tsx:29-97`). Firebase는 클라이언트 SDK 직접 사용(`lib/firebase/config.ts`).

## 5. 주문 흐름 (2단계 상태머신)

```
프로젝트(editing) ── 잠정주문 ─► (ordering/tentative) ── 확정주문 ─► (ordered/definitive→processing→completed)
                                      └── 취소 ─► (cancelled)   ※잠정 상태에서만
```

- 클라이언트: `useOrder.tentativeOrder/definitiveOrder/cancelOrder` → `POST /api/edicus/orders/{tentative|definitive|cancel}`(`useOrder.ts:134,144,155`).
- 서버 구현: `orders/route.ts` POST(type 분기 tentative/definitive·`:41-42`), DELETE(cancel·`:66`) → `server-api.tentativeOrder/definitiveOrder/cancelOrder` → `EDICUS_API_HOST/api/projects/:id/order/*`·`/api/orders/:id/cancel`(`server-api.ts:121-145`). ◀ 경계: Edicus 서버.
- 상태 타입: 프로젝트 `editing|ordering|ordered`(`types/edicus.ts:97`); 주문 `tentative|definitive|cancelled|processing|completed`(`types/order.ts:10-15`).
- 표시: `/orders` RSC가 `OrderCard`로 렌더, 잠정 상태만 확정/취소 액션 노출(`orders/page.tsx:77,111-118`). goto-cart 이벤트는 편집기→`/orders` 이동(`EdicusEditor.tsx:107-110`).

## 6. 외부 연동 경계 노드 요약

| 경계 | 호스트/대상 | 진입점 |
|---|---|---|
| Edicus iframe SDK | `window.edicusSDK`(`/edicus-sdk-v2.js`), iframe origin `edicusbase.firebaseapp.com` | `client.ts:153-158`, `huni-editor-sdk.ts:17` |
| Edicus 서버 API | `EDICUS_API_HOST`(토큰·프로젝트·주문) | `server-api.ts:37,67-149` |
| Edicus Resource API | `EDICUS_RESOURCE_HOST`(상품·템플릿) | `resource-api.ts:29,47-71` |
| Firebase Auth | `NEXT_PUBLIC_FIREBASE_*` | `lib/firebase/config.ts:10-25` |
| 이미지 | resource-dot-edicusbase / edicusbase.firebaseapp.com remotePatterns | `next.config.ts:5-18` |

(S3/HUNI_BFF: 코드에서 직접 참조 없음. 업로드/presigned는 Edicus iframe SDK 내부 책임으로 추정되며 본 코드 경계 밖.)
