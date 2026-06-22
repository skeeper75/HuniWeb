# RedEditorSDK v6.6.48 — 역공학 메서드 카탈로그 (KOI-Passive 래퍼)

권위[HARD·역공학 1급]: `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_editor_sdk.js` (v6.6.48, 438KB deobfuscated) · `docs/reversing/red_reverse_engineer/03_deobfuscated/editor_sdk_method_catalog.md` (45메서드 카탈로그) · `docs/edicus.man/ref/RedEditorSDK.js` (614KB min) · `docs/edicus.man/src/lib/red-editor/red-editor-sdk.d.ts`·`wrapper.ts`.

> **이것은 무엇인가** — RedEditorSDK는 RedPrinting이 Edicus 편집기(`editor.create_project`/`open_project`/`post_to_editor` 등 PDF v2 API → `sdk-method-catalog.md`) **위에 씌운 자사 래퍼**다. Edicus는 iframe 안에서 돌고, RedEditorSDK는 그 iframe을 만들고·토큰을 관리하고·iframe과 postMessage로 통신하는 클라이언트 SDK다. 후니가 Edicus를 직접 통합하더라도, **RedPrinting의 검증된 통합 레퍼런스**로서 전수 가치가 있다(특히 KOI-Passive 래핑·옵션 매핑).
>
> 메서드 수 = **45개 프로토타입 메서드**(분류 `deob_editor_sdk.js:10506-10507` 주석): 템플릿 5 · 프로젝트 7 · 에디터UI 5 · VDP 3 · 라이프사이클 5 · 인증 5 · 이벤트 2 · 조회 9 · 주문 1 · 데이터 2 · 기타 1 = 44 unique(+getTemplateList가 SDK/ApiClient 양쪽 = 45).

---

## 0. 생성자 — `new RedEditorSDK(initConfig)` (`deob_editor_sdk.js:10509-10569`)

생성자 본체에서 토큰 발급·Sentry 초기화·전역 message 리스너 등록을 수행한다.

| Key | Type | 필수 | 설명 | 근거 |
|-----|------|------|------|------|
| `accessToken` | string | Yes | API 액세스 토큰. `U(["accessToken"], t)` 필수 검사 | `:10515` |
| `sandboxMode` | boolean\|"local" | No | `"local"`=local / truthy=dev / falsy=product 환경 분기 | `:10519` |
| `inheritToken` | boolean | No | true면 `verifyToken()`/`autoRefreshToken()` 건너뜀 | `:10520` |
| `userId` | string | No | 지정 시 `issueUserToken` 호출, 미지정 시 sessionStorage `userId` 참조 | `:10531,10542` |
| `initialStageUrl` | string | No | 에디터 서버 커스텀 URL (`Qe.init(isDev, initialStageUrl)`) | `:10531` |
| `email` | string | No | sessionStorage `email` 저장 | `:10556` |
| `staffCode` | string | No | sessionStorage `staffCode` 저장 | `:10556` |
| **`fromKOIPassive`** | boolean | No | **KOI-Passive 모드 플래그.** `K.fromKOIPassive = t.fromKOIPassive` 로 SDK 상태에 보존 → 이후 KOI-Passive 트리거 체인의 시작점 | `:10513` |

**내부 상태(K = sdkState)** (`:10513`): `K.mode = "standard"`(초기) → passive 전환 가능 · `K.deviceTarget = "pc"` · `K.fromKOIPassive` · `K.openType`("CREATE"/"OPEN"/...) · `K.clone` · `K.originProjectId`.
**전역 리스너 등록** (`:10531`): `We.addEventListener("message", s, !1)` — iframe→부모 메시지 라우터(`s`). KOI-Passive 메시지 리스너 `q`(`:10455`)는 별도(아래 §KOI-Passive).
**토큰 자동갱신** (`:10520-10530`): `en.autoRefreshToken(...)` 콜백이 갱신 토큰을 KOI iframe(`L`)에 `{target:"KOI-SDK", action:"refreshToken", info:{token}}`로 postMessage.
**Sentry** (`:10557-10567`): BrowserClient(`logging.betterwaysystems.com`) · release `v6.6.48`.

---

## 1. 템플릿 메서드 (5)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| `setCurrentTemplate` | `(templateConfig)` | 현재 템플릿을 sessionStorage `currentTemplate`에 저장 | void | `:10577-10580` |
| `getCurrentTemplate` | `()` | sessionStorage에서 현재 템플릿 읽기 | `Object`(미설정 `{}`) | `:10587-10590` |
| `getTemplateList` | `(productCode, filterOptions?, legacyCallback?)` | 상품 템플릿 목록 API 조회(`GET /v1/templates/{code}`). features 필터→`$in` 쿼리 | `Promise<{list:[...]}>` | catalog §Template; ApiClient |
| `changeTemplate` | `(productCode, templateUri)` | 에디터 현재 템플릿 변경. `editorBridge.change_template()`로 iframe 전달 | void | catalog §Template |
| `editTemplate` | `(templateEditConfig)` | 스태프 전용 템플릿 편집 모드. `issueStaffToken`(토큰 50분 캐시) | void(async) | catalog §Template |

> Edicus 대응: `changeTemplate`↔`editor.change_template`(PDF p.14) · `editTemplate`↔`editor.edit_template`(PDF p.11).

## 2. 프로젝트 메서드 (7)

| 메서드 | 시그니처 | 목적 | 근거 |
|--------|----------|------|------|
| **`createProject`** | `(editorConfig, projectOptions?, retryCount?)` | 새 프로젝트 생성+에디터 iframe 열기. selector/psCode/title 필수, 최대 4회 재시도 | `:10602-...`(본체 `:10604-`), 필수검사 `:10627` |
| **`openProject`** | `(editorConfig, projectOptions?, retryCount?)` | 기존 프로젝트 열기(projectId 필수). `editorConfig.clone=true`면 복제 후 열기 | catalog §Project; 본체 `:10800-` 부근 |
| `reformProject` | `(editorConfig, projectOptions?, retryCount?)` | 디자인 유지·상품규격(psCode)만 변경(리폼). selector/projectId/psCode 필수 | catalog §Project; 본체 `:11020-` 부근 |
| `changeProject` | `(newProjectId)` | 열린 에디터의 프로젝트를 다른 것으로 변경 | catalog §Project |
| `cloneProject` | `(sourceProjectId, cloneOptions?)` | 프로젝트 복제, 새 ID 반환. `{projectOwnerId}` | `Promise<string>` |
| `getProjectId` | `()` | 현재 프로젝트 ID(sessionStorage) | `string\|null` |
| `getProjectOwnerId` | `(projectId, legacyCallback?)` | 소유자 ID 조회(`GET /v1/project/{id}/ownerId`) | `Promise<Object>\|void` |

### createProject/openProject **projectOptions** 매핑 (`:10632-10666` createProject, `:10860-` openProject)
opt(projectOptions)→editorConfig(iframe URL 파라미터)로 평면화. 핵심 옵션:

| projectOptions 키 | editorConfig/효과 | 근거 |
|-------------------|-------------------|------|
| `calendarConfig` `{initialYear,initialMonth,range,prefixMonths,afterMonths}` | `calendarDate = "Y-M-range-prefix-after"` (→ Edicus `cal_date`) | `:10638` |
| `emptyDocument`/`customDocument`/`addPages`/`deletePages`/`executeList` | `ddpBlock`(DDP 커맨드)로 변환, `templateUrl=null` | `:10638-10658` |
| `initPageCount`/`maxPage`/`minPage`/`maxOrder` | editorConfig 동명 키(→ Edicus `num_page`/`max_page`/`min_page`/`max_order`) | `:10638` |
| `autoSave`(number, 분) | 전역 `W = autoSave` | `:10666` |
| `isMobile` | `editorConfig.isMobile=true`, **`K.deviceTarget="mobile"`** | `:10666` |
| **`hideToolbar`** | `editorConfig.hideToolbar=true`, **`K.mode="passive"`** ← KOI-Passive 핵심 트리거 | `:10666` (open `:10860`, reform `:11044`) |
| `showSetting`/`useVideoFrame`/`extra`/`locale` | editorConfig 동명 키 | `:10666` |
| `limitColor`/`paletteCode` | `extra.palette` 팔레트 설정 | `:10666` 이하 |
| `customTabInfo` | 커스텀 탭(옵션 선택 UI) 데이터 — CustomTabManager 가공 | catalog §Project |
| `promotionInfo`/`privateCSS` | 프로모션 배너 / 커스텀 CSS URL | catalog §Project |
| `clone`(openProject) | `editorConfig.clone` — 복제 후 열기 | `:10860` |

### 특이 분기
- psCode 분할 `psCode.split("@")[1]`가 `["PHBKPRM"]`이면 `deletePages=[{target:"cover"}]` 자동 (`:10632`).
- 미인증(`isReady=false`) 시 4회까지 500ms 재시도 후 alert(`:10619-10625`).

## 3. 에디터 UI 메서드 (5)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| `openFullyFunctionalUI` | `(uiConfig{selector,productCode}, uiOptions{targetUrl,...})` | KOI 풀기능 게이트웨이 UI를 iframe으로 열기 | `Function\|false`(메시지 전송 함수/사용중이면 false) | catalog §EditorUI |
| `remoteEditor` | `(commandType, commandPayload)` | 에디터 원격 명령("command"/"execute-ddp-block"…). changeLayout 타입 deprecated | `Promise<void>` | catalog §EditorUI |
| `remoteEditorBulk` | `(commandList[], historyLabel?, resetHistory?, onCompleteCallback?)` | 다수 DDP 명령 일괄 전송 | void | catalog §EditorUI |
| `changeLayout` | `(templateUri, templateIndex, layoutOptions?, onCompleteCallback?)` | 활성 페이지 레이아웃 변경. `{changeBackground,changeOverlay,transferCellContent,transferTextContent}` | `this`(체이닝) | catalog §EditorUI |
| `copyPageContent` | `(sourcePageIndex, targetPosition)` | 페이지 콘텐츠 복사 | `this`(체이닝) | catalog §EditorUI |

> KOI = Knowledge Of Interface(RedPrinting 내부 시스템). `openFullyFunctionalUI`는 passive(toolbar 숨김) 편집을 풀기능 편집으로 승격하는 게이트웨이.

## 4. VDP 메서드 (3)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| `openVdpViewer` | `(vdpConfig{selector,projectId,npage,flow,dataRow,psCode})` | VDP(가변데이터인쇄) 뷰어 iframe 열기 | void | catalog §VDP |
| `setVariableData` | `(variableDataRow)` | VDP 데이터 행을 에디터에 설정 | void | catalog §VDP |
| `getCurrentTemplateVdpList` | `()` | 현재 템플릿 VDP 카탈로그 | `{totalPage,variableDataList}\|null` | catalog §VDP |

> Edicus 대응: `openVdpViewer`↔TnView/VDP(PDF p.25-27) · `setVariableData`↔`editor.set_variable_data_row`(PDF p.26).

## 5. 라이프사이클 메서드 (5)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| `save` | `(saveOptions?{removeOutterItems})` | 현재 프로젝트 저장 | void | catalog §Lifecycle |
| `saveThenClose` | `(saveOptions?)` | 저장 후 에디터 닫기 | void | catalog §Lifecycle |
| `close` | `()` | 저장 없이 에디터 닫기 | void | catalog §Lifecycle |
| `destroy` | `(resetCallbacks?)` | SDK 인스턴스 파괴·리소스 정리. 콜백 null화·iframe 제거 | void | catalog §Lifecycle |
| `checkOrderable` | `(projectId, legacyCallback?)` | 주문 가능 여부 확인 | `Promise<{can_order,doc_rev,message}>` | catalog §Lifecycle |

> Edicus 대응: `save`↔`post_to_editor('command',{type:'save'})` · `close`↔`editor.close`(PDF p.10) · `destroy`↔`editor.destroy`(PDF p.4).

## 6. 인증 메서드 (5)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| `setToken` | `(newToken)` | API 액세스 토큰 변경 | void | catalog §Auth |
| `setUserId` | `(userId)` | userId 설정+토큰 발급(비동기 isReady=true) | null | catalog §Auth |
| `setPrice` | `(priceValue)` | 에디터 `$PRCE` 변수에 가격 설정 | void | catalog §Auth |
| `setEdicusStageUrl` | `(stageUrl)` | 에디터 서버 URL 커스텀 변경 | void | catalog §Auth |
| `getCustomCss` | `(cssUrl)` | 외부 CSS 다운로드→문자열 | `Promise<string>` | catalog §Auth |

## 7. 이벤트 메서드 (2)

| 메서드 | 시그니처 | 목적 | 반환 | 근거 |
|--------|----------|------|------|------|
| **`on`** | `(eventType, eventCallback)` | 에디터 이벤트 콜백 등록 (22 이벤트, 아래) | `this`(체이닝) | catalog §Event |
| `editorEventHandler` | `(editorError, eventData)` | iframe 수신 이벤트 내부 처리(45 액션 분기·Sentry 로깅) | — (내부용) | catalog §Event |

**`on()` 지원 이벤트 22종**: `create` · `close` · `load` · `change` · `save` · `select` · `historyState` · `historyLabel` · `promoReport` · `error` · `imagePool` · `previewClose` · `fontList` · `changeMode` · `pageCountChange` · `pageChange` · `groupCaption` · `imposeOpened` · `printCountChange` · `customTabSelectionChange` · `docReport` · `all`.

> 이 `on()` 이벤트(22종)가 **부모 페이지가 구독하는 고수준 콜백**이다. iframe(Edicus)에서 온 raw 메시지/KOI-Passive 메시지를 SDK가 받아 이 이벤트들로 emit한다. KOI-Passive 4 type→on 이벤트 매핑은 `passive-mode-events.md` §3 참조.

## 8. 조회 메서드 (9)

| 메서드 | 시그니처 | 목적 | 근거 |
|--------|----------|------|------|
| `getProductInfo` | `(productCode, legacyCallback?)` | 상품 정보(userData·paletteInfo) | catalog §Query |
| `getProductList` | `(legacyCallback?)` | 전체 상품 목록(`GET /v1/templates`) | catalog §Query |
| `getResourceList` | `(productCode, resourceQuery{resourceType}, filterOptions?, legacyCallback?)` | 디자인 리소스 목록 | catalog §Query |
| `getSceneInfo` | `(sceneCallback)` | 전체 씬 정보 | catalog §Query |
| `getActiveSceneInfo` | `(sceneCallback)` | 활성 페이지 씬 정보 | catalog §Query |
| `getImposeCount` | `(imposeParams{methods,sourceSize,imposeSize,rotatable,border}, legacyCallback?)` | 임포징 수량 계산 | catalog §Query |
| `getCustomTabSelectInfo` | `(selectionData)` | 커스텀 탭 선택 조합(`$CODE` 파싱·NO_STOCK 판별) | catalog §Query |
| `getResourceWithId` | `(resourceId, legacyCallback?)` | ID 단일 리소스(`GET /v2/template/resource/{id}`) | catalog §Query |
| `remotePageTnViewer` | `(pageNavPayload)` | 썸네일 뷰어 페이지 이동 | catalog §Query |

## 9. 주문 메서드 (1)

| 메서드 | 시그니처 | 목적 | 비고 | 근거 |
|--------|----------|------|------|------|
| `prepareOrder` | `(projectId, orderParams{order_count,total_price}, legacyCallback?)` | 임시 주문 생성 | **DEPRECATED**(서버 직접 호출 권장) | catalog §Order |

## 10. 데이터 메서드 (2)

| 메서드 | 시그니처 | 목적 | 근거 |
|--------|----------|------|------|
| `getProjectList` | `(legacyCallback?)` | 현재 사용자 프로젝트 목록 | catalog §ProjectData |
| `getProjectThumbnails` | `(projectId?, legacyCallback?)` | 프로젝트 썸네일 목록 | catalog §ProjectData |

## 11. 기타 (1)
- 분류 주석상 "기타 1" — 카탈로그 본문에서 단일 매핑이 명확히 분리되지 않음. **모름(deobfuscated 카탈로그 미명시)** — 후보: getTemplateList의 ApiClient 중복분(45번째 카운트).

---

## 내부 헬퍼 클래스 (참고)

| 클래스 | 역할 | 근거 |
|--------|------|------|
| `EditorBridge`(editorBridge) | iframe 생성·URL 구성·postMessage 양방향. base `edicusbase.firebaseapp.com`(운영)/`edicus-stage.firebaseapp.com`(개발) | catalog §Helper |
| `ApiClient`(apiClient) | makers.redprinting.net HTTP 래퍼. `red-editor-token` 헤더·토큰 50분 자동갱신 | catalog §Helper |
| `CustomTabManager` | 커스텀 탭 UI 데이터 가공·소재목록 동적 추출·템플릿 매칭 | catalog §Helper |

## ApiClient 엔드포인트 (RedPrinting makers API — 후니 무관, 레퍼런스용)

| Endpoint | Method | 메서드 |
|----------|--------|--------|
| `POST /editor` | call() | 범용(target 구분) |
| `GET /v1/templates` | getProductList |
| `GET /v1/templates/{code}` | getTemplateList |
| `GET /v1/resources/resource/query` | getResourceList |
| `GET /v2/template/resource/{id}` | getResourceWithId |
| `PUT /v1/template/{uri}/{type}` | updateTemplateCount |
| `POST /token` | verifyToken/refreshAccessToken |
| `GET /v1/project/{id}/ownerId` | getProjectOwnerId |

> 이 엔드포인트는 RedPrinting `makers.redprinting.net` 자사 API다. 후니가 통합할 **Edicus Server API**는 별개(`server-api-catalog.md`). RedEditorSDK가 자사 백엔드를 어떻게 묶는지의 레퍼런스로만 본다.

---

## 미상 / 정직 표기
- "기타(1)" 분류 메서드의 정확한 명칭/역할: **모름**(§11).
- 일부 메서드 본체 라인은 deobfuscated 파일에서 minified 바인딩(`o`,`i`,`e`)으로 표기돼 시그니처는 `editor_sdk_method_catalog.md`(역공학 정리본)를 1급 인용, 본체 위치는 근사 라인으로 표기.
- `on()` 22 이벤트 각각의 payload 스키마: 일부는 Edicus passive info(=`passive-mode-events.md`)와 동형이나 RedEditorSDK 측 정규화 후 shape는 **부분 모름**(d.ts/wrapper.ts 대조는 code-cartographer 영역).
