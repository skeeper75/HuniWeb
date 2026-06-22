# RedEditorSDK Method Catalog

> Version: 6.6.48  
> Source: RedEditorSDK.min.js (deobfuscated)  
> Total Methods: 45 (44 unique, getTemplateList appears in both SDK and ApiClient)

---

## Constructor

```javascript
new RedEditorSDK(initConfig)
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `initConfig.accessToken` | `string` | Yes | API 액세스 토큰 |
| `initConfig.userId` | `string` | No | 사용자 ID (미지정 시 sessionStorage 참조) |
| `initConfig.sandboxMode` | `boolean\|"local"` | No | 개발 모드 (`true`=dev, `"local"`=로컬, `false`=운영) |
| `initConfig.inheritToken` | `boolean` | No | `true`이면 토큰 검증/자동갱신 건너뜀 |
| `initConfig.initialStageUrl` | `string` | No | 에디터 서버 커스텀 URL |
| `initConfig.email` | `string` | No | 사용자 이메일 |
| `initConfig.staffCode` | `string` | No | 스태프 코드 |
| `initConfig.fromKOIPassive` | `boolean` | No | KOI 패시브 모드 여부 |

**Internal State:**
- `this.version` = `"6.6.48"`
- `this.isDev` = sandboxMode
- `this.isReady` = userId 인증 완료 여부
- `sdkState.mode` = `"standard"` | `"passive"`
- `sdkState.deviceTarget` = `"pc"` | `"mobile"`
- `apiClientInstance` = ApiClient 인스턴스 (makers API 통신)
- `editorBridge` = EditorBridge 인스턴스 (iframe 통신)
- `sentryHubInstance` = Sentry Hub (에러 로깅)

---

## Template Methods (5)

### setCurrentTemplate(templateConfig)
- **Purpose:** 현재 사용할 디자인 템플릿을 sessionStorage에 저장
- **Parameters:** `templateConfig` (Object) - 템플릿 설정 객체
- **Returns:** void

### getCurrentTemplate()
- **Purpose:** sessionStorage에서 현재 템플릿 설정을 읽어 반환
- **Parameters:** None
- **Returns:** `Object` - 현재 템플릿 설정 (미설정 시 `{}`)

### getTemplateList(productCode, filterOptions?, legacyCallback?)
- **Purpose:** 특정 상품의 템플릿 목록을 API로 조회
- **Parameters:**
  - `productCode` (string) - 상품 코드
  - `filterOptions` (Object|Function) - 필터: `{ size, features, sort }`
  - `legacyCallback` (Function) - `(error, data)` 콜백
- **Returns:** `Promise<Object>` - `{ list: [...] }`
- **Notes:** features 필터는 상품의 userData와 대조하여 $in 쿼리로 변환됨

### changeTemplate(productCode, templateUri)
- **Purpose:** 에디터의 현재 템플릿을 변경
- **Parameters:**
  - `productCode` (string) - 상품 코드
  - `templateUri` (string) - 새 템플릿 URI
- **Returns:** void
- **Notes:** editorBridge.change_template()으로 iframe에 전달

### editTemplate(templateEditConfig)
- **Purpose:** 스태프 전용 템플릿 편집 모드로 에디터를 열기
- **Parameters:** `templateEditConfig` (Object) - selector, psCode, templateUrl, division, lang 등
- **Returns:** void (async)
- **Notes:** issueStaffToken API 사용, 토큰 50분 캐시

---

## Project Methods (7)

### createProject(editorConfig, projectOptions?, retryCount?)
- **Purpose:** 새 프로젝트를 생성하고 에디터 iframe을 열기
- **Parameters:**
  - `editorConfig` (Object) - `{ selector, psCode, title, templateUrl, ... }` (selector, psCode, title 필수)
  - `projectOptions` (Object) - 다양한 옵션 (아래 참조)
  - `retryCount` (number) - 내부 재시도 카운터 (최대 4회)
- **Returns:** void (async)
- **Key Options:**
  - `calendarConfig` - 캘린더 상품용 날짜 설정
  - `customTabInfo` - 커스텀 탭 (옵션 선택 UI) 설정
  - `paletteCode` - 팔레트 색상 코드
  - `emptyDocument` / `customDocument` / `addPages` / `deletePages` - 페이지 조작
  - `hideToolbar` / `isMobile` / `showSetting` - UI 모드
  - `autoSave` - 자동 저장 간격 (분)
  - `privateCSS` - 커스텀 CSS URL
  - `promotionInfo` - 프로모션 배너 설정

### openProject(editorConfig, projectOptions?, retryCount?)
- **Purpose:** 기존 프로젝트를 열어 에디터를 실행
- **Parameters:** createProject와 동일 구조 (projectId 필수, title 불필요)
- **Returns:** void (async)
- **Notes:** `editorConfig.clone = true`이면 프로젝트를 복제 후 열기

### reformProject(editorConfig, projectOptions?, retryCount?)
- **Purpose:** 기존 프로젝트를 새 상품 코드로 리폼(재구성)
- **Parameters:** selector, projectId, psCode 필수
- **Returns:** void (async)
- **Notes:** 디자인 유지, 상품 규격만 변경

### changeProject(newProjectId)
- **Purpose:** 에디터에서 열린 프로젝트를 다른 프로젝트로 변경
- **Parameters:** `newProjectId` (string) - 변경할 프로젝트 ID
- **Returns:** void

### cloneProject(sourceProjectId, cloneOptions?)
- **Purpose:** 프로젝트를 복제하고 새 프로젝트 ID를 반환
- **Parameters:**
  - `sourceProjectId` (string) - 원본 프로젝트 ID
  - `cloneOptions` (Object) - `{ projectOwnerId }`
- **Returns:** `Promise<string>` - 복제된 프로젝트 ID

### getProjectId()
- **Purpose:** 현재 프로젝트 ID를 반환
- **Returns:** `string|null` - sessionStorage의 projectId

### getProjectOwnerId(projectId, legacyCallback?)
- **Purpose:** 프로젝트 소유자 ID를 조회
- **Returns:** `Promise<Object>|void`

---

## Editor UI Methods (5)

### openFullyFunctionalUI(uiConfig, uiOptions?)
- **Purpose:** KOI 풀 기능 게이트웨이 UI를 iframe으로 열기
- **Parameters:**
  - `uiConfig` - `{ selector, productCode }`
  - `uiOptions` - `{ targetUrl, ... }` 게이트웨이 옵션
- **Returns:** `Function|false` - iframe에 메시지를 보내는 함수, 또는 사용 중이면 false
- **Notes:** KOI = Knowledge Of Interface (레드프린팅 내부 시스템)

### remoteEditor(commandType, commandPayload)
- **Purpose:** 에디터에 원격 명령을 전송
- **Parameters:**
  - `commandType` (string) - "command", "execute-ddp-block" 등
  - `commandPayload` (Object) - 명령 데이터
- **Returns:** `Promise<void>` - command+close-preview인 경우 결과 Promise
- **Notes:** changeLayout 타입은 deprecated

### remoteEditorBulk(commandList, historyLabel?, resetHistory?, onCompleteCallback?)
- **Purpose:** 여러 DDP 명령을 일괄 전송
- **Parameters:**
  - `commandList` (Object[]) - 고수준 명령 배열
  - `historyLabel` (Object|Function) - 히스토리 라벨 또는 완료 콜백
  - `resetHistory` (boolean|Function) - 히스토리 리셋 또는 완료 콜백
  - `onCompleteCallback` (Function) - DDP 실행 완료 콜백
- **Returns:** void

### changeLayout(templateUri, templateIndex, layoutOptions?, onCompleteCallback?)
- **Purpose:** 현재 활성 페이지의 레이아웃을 변경
- **Parameters:**
  - `templateUri` (string) - 새 레이아웃 템플릿 URI
  - `templateIndex` (number) - 템플릿 내 인덱스
  - `layoutOptions` (Object) - `{ changeBackground, changeOverlay, transferCellContent, transferTextContent }`
  - `onCompleteCallback` (Function) - 완료 콜백
- **Returns:** `this` (메서드 체이닝)

### copyPageContent(sourcePageIndex, targetPosition)
- **Purpose:** 페이지 콘텐츠를 다른 위치로 복사
- **Returns:** `this` (메서드 체이닝)

---

## VDP Methods (3)

### openVdpViewer(vdpConfig)
- **Purpose:** VDP(가변 데이터 인쇄) 뷰어를 iframe으로 열기
- **Parameters:** `{ selector, projectId, npage, flow, dataRow, psCode }`

### setVariableData(variableDataRow)
- **Purpose:** VDP 데이터 행을 에디터에 설정
- **Parameters:** `variableDataRow` (Object) - VDP 데이터

### getCurrentTemplateVdpList()
- **Purpose:** 현재 템플릿의 VDP 카탈로그를 반환
- **Returns:** `Object|null` - `{ totalPage, variableDataList }` 또는 null

---

## Lifecycle Methods (5)

### save(saveOptions?)
- **Purpose:** 현재 프로젝트를 저장
- **Parameters:** `saveOptions` - `{ removeOutterItems: boolean }`

### saveThenClose(saveOptions?)
- **Purpose:** 저장 후 에디터를 닫기

### close()
- **Purpose:** 에디터를 닫기 (저장 없이)

### destroy(resetCallbacks?)
- **Purpose:** SDK 인스턴스를 파괴하고 리소스를 정리
- **Parameters:** `resetCallbacks` (boolean) - 이벤트 콜백 초기화 여부
- **Notes:** 모든 이벤트 콜백을 null 함수로 리셋, iframe 제거

### checkOrderable(projectId, legacyCallback?)
- **Purpose:** 프로젝트의 주문 가능 여부를 확인
- **Returns:** `Promise<Object>` - `{ can_order: boolean, doc_rev, message }`

---

## Auth Methods (5)

### setToken(newToken)
- **Purpose:** API 액세스 토큰을 변경

### setUserId(userId)
- **Purpose:** 사용자 ID를 설정하고 토큰을 발급
- **Returns:** null (비동기로 isReady=true 설정)

### setPrice(priceValue)
- **Purpose:** 에디터에 가격 정보를 설정 ($PRCE 변수)

### setEdicusStageUrl(stageUrl)
- **Purpose:** 에디터 서버 URL을 커스텀 URL로 변경

### getCustomCss(cssUrl)
- **Purpose:** 외부 CSS 파일을 다운로드하여 문자열로 반환
- **Returns:** `Promise<string>` - CSS 텍스트

---

## Event Methods (2)

### on(eventType, eventCallback)
- **Purpose:** 에디터 이벤트 콜백을 등록
- **Supported Events (22):**
  - `create`, `close`, `load`, `change`, `save`, `select`
  - `historyState`, `historyLabel`, `promoReport`, `error`
  - `imagePool`, `previewClose`, `fontList`, `changeMode`
  - `pageCountChange`, `pageChange`, `groupCaption`
  - `imposeOpened`, `printCountChange`, `customTabSelectionChange`
  - `docReport`, `all`
- **Returns:** `this` (메서드 체이닝)

### editorEventHandler(editorError, eventData)
- **Purpose:** 에디터 iframe에서 수신된 이벤트를 내부 처리
- **Notes:** SDK 내부용. 45개 이벤트 액션을 분기 처리. Sentry 로깅 포함.

---

## Query Methods (9)

### getProductInfo(productCode, legacyCallback?)
- **Purpose:** 상품 정보를 조회 (userData, paletteInfo 포함)
- **Returns:** `Promise<Object>` - 상품 데이터

### getProductList(legacyCallback?)
- **Purpose:** 전체 상품 목록 조회 (GET /v1/templates)

### getResourceList(productCode, resourceQuery, filterOptions?, legacyCallback?)
- **Purpose:** 디자인 리소스 목록을 조회
- **Parameters:** resourceQuery에 `resourceType` 필수

### getSceneInfo(sceneCallback)
- **Purpose:** 에디터의 전체 씬 정보를 조회

### getActiveSceneInfo(sceneCallback)
- **Purpose:** 현재 활성 페이지의 씬 정보를 조회

### getImposeCount(imposeParams, legacyCallback?)
- **Purpose:** 임포징 수량을 계산
- **Parameters:** `{ methods, sourceSize, imposeSize, rotatable, border }`

### getCustomTabSelectInfo(selectionData)
- **Purpose:** 커스텀 탭 선택 정보를 조합하여 반환
- **Notes:** $CODE 파싱, combination/rawData/findData 타입 처리, NO_STOCK 판별

### getResourceWithId(resourceId, legacyCallback?)
- **Purpose:** ID로 단일 리소스를 조회

### remotePageTnViewer(pageNavPayload)
- **Purpose:** 썸네일 뷰어의 페이지를 이동

---

## Order Method (1)

### prepareOrder(projectId, orderParams, legacyCallback?) [DEPRECATED]
- **Purpose:** 임시 주문을 생성
- **Parameters:** `orderParams` - `{ order_count, total_price }`
- **Notes:** 서버에서 직접 호출하는 것을 권장

---

## Project Data Methods (2)

### getProjectList(legacyCallback?)
- **Purpose:** 현재 사용자의 프로젝트 목록을 조회

### getProjectThumbnails(projectId?, legacyCallback?)
- **Purpose:** 프로젝트 썸네일 목록을 조회

---

## Internal Helper Classes

### EditorBridge (editorBridge)
- iframe 생성, URL 구성, postMessage 기반 양방향 통신
- Base URL: `https://edicusbase.firebaseapp.com` (운영) / `https://edicus-stage.firebaseapp.com` (개발)

### ApiClient (apiClient)
- HTTP API 래퍼 (makers.redprinting.net)
- 인증: `red-editor-token` 헤더
- 토큰 자동 갱신: 50분 간격

### CustomTabManager
- 커스텀 탭 UI 데이터 가공
- 소재 목록에서 동적 아이템 추출
- 템플릿 매칭 및 초기 변수 설정

---

## API Endpoints (via ApiClient)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `POST /editor` | `call()` | 범용 API (target 파라미터로 구분) |
| `GET /v1/templates` | `getProductList()` | 전체 상품 목록 |
| `GET /v1/templates/{code}` | `getTemplateList()` | 상품별 템플릿 목록 |
| `GET /v1/resources/resource/query` | `getResourceList()` | 리소스 목록 |
| `GET /v2/template/resource/{id}` | `getResourceWithId()` | 단일 리소스 조회 |
| `PUT /v1/template/{uri}/{type}` | `updateTemplateCount()` | 템플릿 사용 횟수 갱신 |
| `POST /token` | `verifyToken() / refreshAccessToken()` | 토큰 검증/갱신 |
| `GET /v1/project/{id}/ownerId` | `getProjectOwnerId()` | 프로젝트 소유자 조회 |
