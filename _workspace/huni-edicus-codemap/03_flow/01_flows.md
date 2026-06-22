# 01 — 플로우 (인증→상품→편집→주문 · 패시브 라이프사이클 · 주문 상태머신)

> 청중: 개발팀. 권위[HARD]=API 계약 팩 + 코드맵 팩. 각 전이에 SDK 메서드/이벤트·`PDF p.N`·`파일:라인` 병기.
> 코드↔계약 불일치는 `%% 불일치: ...` 주석으로 명시.

---

## A. end-to-end 시퀀스 (인증 → 상품선택 → 편집 → 주문)

PC 데스크탑 `EdicusEditor` 경로(`useEdicus`→`EdicusClient`→`window.edicusSDK`)를 기준으로 한다(`data-flow.md:44-53`). 토큰은 [HARD] 고객사 서버에서 발급해 클라로 전달하고 SDK params `token`으로 쓴다(`SDK PDF p.2`).

```mermaid
sequenceDiagram
  actor User
  participant NextApp as "Next 앱 (페이지/컴포넌트)"
  participant Hook as "useEdicus / EdicusClient"
  participant SDK as "Edicus SDK (iframe)"
  participant Server as "Edicus Server/Resource API"
  participant FB as "Firebase Auth"

  rect rgb(227,242,253)
  note over User,FB: 1) 인증
  User->>NextApp: LoginForm.login(email,pw)
  NextApp->>FB: signInWithEmailAndPassword
  FB-->>NextApp: onAuthStateChanged(user)
  NextApp->>NextApp: getIdToken → document.cookie '__session'
  NextApp->>Server: POST /api/edicus/auth {uid}
  Note right of Server: server-api.getToken → POST /api/auth/token<br/>(edicus-api-key, edicus-uid) PDF p.2-3
  Server-->>NextApp: { token } (메모리만 보관)
  end

  rect rgb(232,245,233)
  note over User,Server: 2) 상품 선택
  User->>NextApp: 홈 / 모바일 카탈로그
  NextApp->>Server: GET /api/edicus/products?partner
  Note right of Server: resource-api.getProductList<br/>GET /resapi/product/list PDF p.18
  Server-->>NextApp: { prodCates, products }
  User->>NextApp: 상품 선택 → /editor/[templateId]
  end

  rect rgb(232,226,251)
  note over User,SDK: 3) 편집 (Edicus iframe)
  NextApp->>Hook: useEdicus.init
  Hook->>SDK: window.edicusSDK.init({base_url})
  Note right of SDK: client.ts:158 · base_url=EDICUS_BASE_HOST
  alt projectId 있음
    Hook->>SDK: open_project({token,prjid,...}, cb)
    Note right of SDK: SDK PDF p.8 · client.ts:199
  else 신규
    Hook->>SDK: create_project({token,ps_code,template_uri,...}, cb)
    Note right of SDK: SDK PDF p.5 · client.ts:185
  end
  SDK-->>Hook: cb { action:'project-id-created', info:{project_id} } PDF p.6
  SDK-->>Hook: cb { action:'request-user-token' } PDF p.7
  Hook->>Server: fetchUserToken → POST /api/edicus/auth
  Note right of Hook: %% 불일치: EdicusEditor.fetchUserToken body 미전달<br/>auth/route.ts는 uid 필수 → 400 위험 (codemap §5-1)
  Hook->>SDK: post_to_editor('send-user-token',{token}) PDF p.18
  User->>SDK: 편집 (사진/텍스트)
  end

  rect rgb(255,243,224)
  note over User,Server: 4) 주문
  SDK-->>Hook: cb { action:'goto-cart' } → router.push('/orders') PDF p.6
  User->>NextApp: 잠정주문
  NextApp->>Server: POST /api/edicus/orders {projectId,type:'tentative'}
  Note right of Server: server-api.tentativeOrder<br/>POST /api/projects/:id/order/tentative PDF p.10
  Server-->>NextApp: { order_id, status:'ordering' }
  User->>NextApp: 확정주문
  NextApp->>Server: POST /api/edicus/orders {projectId,type:'definitive'}
  Note right of Server: POST /api/projects/:id/order/definitive PDF p.13
  Server-->>NextApp: { order_id, status:'ordered' }
  end
```

**추적 메모**
- 인증: `useAuth.login`→`signInWithEmail`(`useAuth.ts:105`→`auth.ts:17`); `__session` 쿠키(`useAuth.ts:83-84`); Edicus 토큰 발급 `POST /api/edicus/auth {uid}`(`useAuth.ts:50-53`)→`server-api.getToken`→`EDICUS_API_HOST/api/auth/token`(`Server API PDF p.2-3`). 토큰은 메모리만, localStorage 미저장(`useAuth.ts:37-38`).
- 상품: `ProductGrid`가 `fetch /api/edicus/products?partner`(`ProductGrid.tsx:33`)→`resource-api.getProductList`(`Resource PDF p.18`).
- 편집: `useEdicus.init`→`client.init`→`window.edicusSDK.init({base_url})`(`useEdicus.ts:90`→`client.ts:158`). `projectId` 유무로 `open_project`/`create_project` 분기(`EdicusEditor.tsx:136-139`). 콜백 라우팅: `request-user-token`→토큰 재발급+`postToEditor('send-user-token')`, `close`→`router.back()`, `goto-cart`→`router.push('/orders')`(`EdicusEditor.tsx:81-112`).
- 주문: `useOrder`→`POST /api/edicus/orders`(`useOrder.ts:134-156`)→`server-api.tentativeOrder/definitiveOrder`(`server-api.ts:121`)→`EDICUS_API_HOST/api/projects/:id/order/*`(`Server API PDF p.10-13`). `order_id`는 [HARD] 고객사 DB 기록 대상(`Server API PDF p.11,13`).
- `%% 불일치`(시퀀스에 주석): 4개 편집기 토큰 발급이 **body 없이 POST**라 `uid` 필수 라우트와 충돌(`hooks-and-edicus-wiring.md:102`). 상세는 `02_code-api-wiring.md`.

---

## B. Edicus 패시브 모드 라이프사이클 (stateDiagram)

패시브 모드 = edicus를 canvas만 보이게 띄우고 postMessage로 부모↔iframe 연동(`passive-mode-events.md:7`). 진입=`create_project`/`open_project`의 `run_mode='passive'`(`SDK PDF p.19`). edicus→고객사 콜백 `function(err,data)`의 `data.action`으로 상태 전이를 본다.

```mermaid
stateDiagram-v2
  [*] --> Initializing : run_mode='passive' (SDK PDF p.19)
  Initializing --> ReadyToListen : action ready-to-listen
  note right of ReadyToListen
    request-feature는 보통
    ready-to-listen 직후 전송 (SDK PDF p.15)
    %% 불일치: ready-to-listen info/의미 PDF 미기재
  end note
  ReadyToListen --> ProjectLoaded : load-project-report status=end (PDF p.20)
  ReadyToListen --> LoadFailed : load-project-report status=error / error-report (PDF p.20)
  ProjectLoaded --> DocChanged : doc-changed (ps_code,page_count) (PDF p.20)
  DocChanged --> Editing
  Editing --> Editing : page-changed / var-added / var-changed / var-deleted (PDF p.23-24)
  Editing --> Editing : state-history (can_undo/can_redo/doc_dirty) (PDF p.23)
  Editing --> Saving : post_to_editor command type=save (PDF p.15)
  Saving --> SaveStart : save-doc-report status=start (PDF p.21)
  SaveStart --> SaveEnd : save-doc-report status=end + docInfo (PDF p.21-22)
  SaveStart --> SaveError : save-doc-report status=error (PDF p.21)
  SaveEnd --> Editing
  SaveError --> Editing
  Editing --> TokenExpired : action request-user-token (PDF p.7)
  TokenExpired --> Editing : post_to_editor send-user-token {token} (PDF p.18)
  Editing --> Closing : action close / goto-cart (PDF p.6,20)
  LoadFailed --> [*]
  Closing --> [*] : destroy({parent_element}) (PDF p.4)
```

**추적 메모**
- action enum 권위=`passive-mode-events.md:22-38`(ready-to-listen·load-project-report·doc-changed·page-changed·var-*·state-history·save-doc-report·error-report·close 등). 코드는 정확한 케밥 문자열로 매칭(`passive-mode-events.md:40`).
- 코드 진입점: `MobileEditor` passive 콜백 `ready-to-listen→onReadyToListen`·`doc-changed→onDocChanged`(`data-flow.md:57`; `MobileEditor.tsx:112-120`); 툴바 `undo/redo/save-doc` `postToEditor` 직접 호출(`MobileEditor.tsx:218-222`). `HuniEditorSDK`는 `ready`/`ready-to-listen`/`close`/`doc-changed`/`save-complete`/`error` 매핑(`huni-editor-sdk.ts:135-158`).
- save 전이: `state-history.doc_dirty`로 Save 버튼 enable/disable(`PDF p.23`). save-doc-report `docInfo@end`는 일반상품/사진인화 두 형태(`PDF p.21-23`).
- `%% 불일치`: `ready-to-listen` info/의미는 **PDF 미기재(모름)**(`passive-mode-events.md:177`); `save()`가 `postToEditor('save-doc')`로 보내나 PDF command type은 `save`(`huni-editor-sdk.ts:208-210`; `SDK PDF p.15`) — 이름 차이는 `02_code-api-wiring.md`에 상세.

---

## C. 주문 상태머신 (stateDiagram)

2단계 주문(잠정→확정)이며 취소는 잠정 상태에서만 가능(`data-flow.md:83-93`). 상태 enum: 프로젝트 `editing|ordering|ordered`(`types/edicus.ts:97`), 주문 `tentative|definitive|cancelled|processing|completed`(`types/order.ts:10-15`), Can Order status `editing|ordering|ordered|rendering|rendered`(`Server API PDF p.10`).

```mermaid
stateDiagram-v2
  [*] --> editing : 프로젝트 생성/편집 (status editing)
  editing --> ordering : 잠정주문<br/>POST /orders {type:tentative} → /order/tentative (PDF p.10)
  note right of ordering
    Tentative = 취소 가능·렌더링 안 됨 (PDF p.10)
    order_id는 [HARD] 고객사 DB 기록 (PDF p.11)
  end note
  ordering --> cancelled : 취소<br/>DELETE /orders → /orders/:id/cancel (PDF p.13)
  ordering --> ordered : 확정주문<br/>POST /orders {type:definitive} → /order/definitive (PDF p.13)
  note right of ordered
    Definitive = 취소 불가·렌더링 가능 (PDF p.13)
    반드시 Tentative 이후 호출 (PDF p.13)
  end note
  ordered --> rendering : Request for Render (내부) (PDF p.16)
  rendering --> rendered : Change Rendering Status as rendered (PDF p.17)
  rendering --> ordered : render-fail → reset_as_ordered (PDF p.13-14)
  cancelled --> [*]
  rendered --> [*]
```

**추적 메모**
- 클라: `useOrder.tentativeOrder/definitiveOrder/cancelOrder`→`POST /api/edicus/orders/{tentative|definitive|cancel}`(`useOrder.ts:134,144,155`).
- 서버: `orders/route.ts` POST(type 분기)·DELETE(취소)→`server-api.*`→`EDICUS_API_HOST/api/projects/:id/order/*`·`/api/orders/:id/cancel`(`data-flow.md:90-91`; `server-api.ts:121-145`).
- 표시: `/orders` RSC가 `OrderCard`로 렌더, **잠정 상태만** 확정/취소 액션 노출(`orders/page.tsx:111-118`).
- `processing|completed`(order.ts)와 `rendering|rendered`(Server API/Can Order)는 별도 출처 enum — 위 머신은 Server API 렌더 단계를 권위로 그리고, order.ts의 후속 상태는 클라 도메인 모델로 별도 존재(`types/order.ts:10-15`). 두 enum 합성 화살표는 팩에 근거 없어 창작하지 않음.
- `%% 불일치`: `useOrder`가 `/orders/tentative` 등 **서브경로**로 POST하나 대응 route 파일 부재 — 구현은 `orders/route.ts`(POST type 분기·DELETE)뿐(`hooks-and-edicus-wiring.md:103`). 상세는 `02_code-api-wiring.md`.
