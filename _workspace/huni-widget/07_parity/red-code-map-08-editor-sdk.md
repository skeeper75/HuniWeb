# Red 코드맵 — RedEditorSDK 모듈 (postMessage 브릿지 / 에디터 라이프사이클)

> STAGE S0 (확장) — 구조 매핑 전용. parity 판정 없음.
> 권위 축: RedPrinting 실소스. 우리 `editor-bridge.ts` / `EditorOverlay.tsx`가 이 책임/분기/메시지 구조에 1:1 대응되어야 한다.
> 근거 파일:
> - `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_editor_sdk.js` (디옵스 425KB — primary)
> - `editor_sdk_method_catalog.md`(45메서드) + `deob_editor_sdk_stats.json`(섹션맵·리네임표)
> - cross-ref `01_source/beautified_editor_sdk.js`
> - seam: `07_parity/red-code-map-06-widget-sdk.md`(위젯↔에디터 호스트콜백 경계) + `01_reverse/editor-bridge-protocol.md`(prior)
> 표기: `edsdk:LINE` = deob_editor_sdk.js. SDK 버전 **6.6.48**.

---

## 0. 핵심 구조 결론 (요약)

| 질문 | 코드 확정 답 |
|------|------|
| from-edicus action 총개수 (~25 해소) | **30종** action 처리(아래 §3 전수 표). + KOI-Passive 4종 별도 경로(`edsdk:10458`). + from-edicus-private 2종(deferred 핸드셰이크). |
| goto-cart의 case 값 (런타임 캡처 누락분) | goto-cart는 **별도 case 분기 없음** — `close`와 **동일 핸들러 공유**(`edsdk:11393`). 핵심: `info.projectID`로 `isReadyToOrder` 호출 → `can_order` 판정 → `n.isCanOrder` 세팅 → `onClose` 콜백(`d`). prior가 본 `info.case`는 **에디터→호스트 페이로드 패스스루 필드**일 뿐 SDK가 switch하지 않음. |
| to-edicus 메시지 | iframe URL cmd(create/open/reform/edit-template/recycle/+design/lite/tnview/preview) + postMessage action(change-project/change-template/change-layout/execute-ddp-block/command/send-user-token/send-extra-param/send-ddp-data 등). §4. |
| origin 보안 | **수신·송신 양방향 origin 미검증**. 송신 `postMessage(..., "*")`(`edsdk:2623,2672,2730…`), 수신 핸들러는 `e.type` 문자열만 검사, `event.origin` 비교 **없음**(`edsdk:2575-2635`, `10531`). §6. |
| 토큰(JWT) 수명 | `editorToken`={token, expiredAt} Base64 sessionStorage. `verifyToken`→`autoRefreshToken` **50분 간격**(`3e6`ms, `edsdk:2922`). staff토큰 50분 캐시(`edsdk:11156`). `request-user-token`/`refreshToken` 시 iframe에 `send-user-token`/KOI-SDK refreshToken 재전송. |
| 캡처가 놓친 서프라이즈 | §7 — (a) goto-cart=close 공유, (b) deferred-param 핸드셰이크가 큰 페이로드 전달 메커니즘, (c) auto-save가 load 시 setInterval(분단위 command:save), (d) KOI-Passive 별도 메시지 채널, (e) inheritToken 분기로 토큰 검증 우회. |

---

## 1. 책임 인벤토리 (Responsibility Inventory)

| Red 책임 | edsdk:line | 로직 요약 | 분기 조건 |
|----------|-----------|-----------|-----------|
| SDK 생성자 + 토큰 부트 | `10509-10567` | `version=6.6.48`, sandbox 결정(local/dev/product), `new ApiClient(accessToken, env)`; `!inheritToken`이면 `verifyToken()`+`autoRefreshToken(cb)`; `Qe.init()`(브릿지); `addEventListener("message", s)`(KOI-Passive); userId 있으면 `issueUserToken`→editorToken 저장→`isReady=true` | `inheritToken` true면 토큰 검증/갱신 skip; userId 없으면 sessionStorage userId Base64 검사 |
| EditorBridge 초기화 | `2573-2635`(`Qe.init`) | base_url 결정(운영/개발/커스텀), `window.__KOI_EVENT_LISNTER_INITIALIZE` 1회 가드, `messageListener`(from-edicus 라우터) 등록 | `_isDev`로 base_url 분기, `e`(initialStageUrl) override |
| iframe 빌드 + URL 명령 | `2643-2723` | cmd별 landing URL 조립(`?cmd=...&token=&ps_code=/prjid=&title=`) + `_add_common_url_param`(40+) + `_set_deferred_params` + `_build_iframe` | cmd 11종(create/open/edit-template/create-design/open-design/recycle/reform/+ tnview/preview/lite/gallery) |
| createProject | `10470-10870` | 옵션 빌드(calendarConfig/customTabInfo/palette/page조작/UI모드/autoSave/privateCSS/promotionInfo) → token 있으면 `Qe.create_project` 즉시, 없으면 `issueUserToken` 후 진행 → `updateTemplateCount(hit)` | `isEditorBusy(A)` 가드(재시도 max 4); customDocument/emptyDocument/addPages/deletePages 분기 |
| openProject | `10940-11050` | createProject와 동형, `prjid` 필수·title 불필요. `editorConfig.clone`이면 복제 후 open | clone 분기(`K.clone`, originProjectId 추적) |
| reformProject | `11050-11130` | 기존 prj를 새 ps_code로 재구성 → `Qe.reform_project` | — |
| editTemplate(staff) | `11130-11210` | staff 전용. `issueStaffToken`(50분 캐시) → `Qe.edit_template` | staffEditorToken 만료 검사 |
| **editorEventHandler (from-edicus 디스패처)** | `11336-11447` | `e`(error) 있으면 alert; 없으면 `n.action` 30종 순차 분기(§3). regeneratorRuntime async | action 문자열 + `n.info.status==="end"` 게이트 다수 |
| `on(event, cb)` 등록 | `11461-11530` | 22 이벤트→내부 콜백변수(l/f/p/d/h/v/g/_/y/m/H/x/k/w/S/E/I/T/P/O/j/C/R) 매핑 | error는 Sentry 로깅 래핑 |
| save / saveThenClose / close / destroy | `11540-11700` 부근 | `Qe.post_to_editor("command",{type:"save",...})`; close=command close; destroy=리스너 제거+iframe 제거+콜백 null화 | removeOutterItems 옵션 |
| checkOrderable | `11940-11973` | `isReadyToOrder(projectId)` 호출 → `doc_rev===null`이면 `can_order=false` → `{can_order, doc_rev, message}` | 콜백 or Promise 반환 |
| setToken/setUserId/setPrice/setEdicusStageUrl | `11520-11630` 부근 | setUserId→`issueUserToken`→editorToken; setPrice→`$PRCE` 변수 에디터 전달 | — |
| ApiClient.call(target) | `2780-2795` | FormData(target/uid/email/staffCode/collectionId/qry) → `POST {baseUrl}editor`, 헤더 `red-editor-token` | target별 collectionId 부착(projectId/orderId 분기) |
| verifyToken/refreshAccessToken/autoRefreshToken | `2879-2925` | `POST /token`(red-editor-token 헤더); autoRefresh `setInterval(refreshAccessToken, 3e6)` | — |
| CustomTabManager | `11803-12244` | 커스텀탭 데이터 가공($CODE 파싱, combination/rawData/findData, NO_STOCK 판별) | materialType/productCode 분기(`12402`) |
| DDP Block Builder | `9654-10443` | 고수준 명령(23타입)→DDP 블록. set-item-attribute/set-page-attribute/set-post-layer 등 | 명령 타입별 분기 |

---

## 2. 메시지 채널 분류

| 방향 | type | 처리 | edsdk:line |
|------|------|------|-----------|
| 호스트→에디터 | iframe URL `?cmd=...` | 프로젝트 진입(create/open/reform/edit-template/recycle) | `2643-2663` |
| 호스트→에디터 | `to-edicus-root` | change-project/change-template/send-extra-param/send-ddp-data | `2664,2673,2616,2625` |
| 호스트→에디터 | `to-edicus` | 편집 액션(change-layout/command/execute-ddp-block/send-user-token/set-item-attribute 등) | `2685,2724` |
| 호스트→에디터 | `to-edicus-tnview`/`to-edicus-preview` | 썸네일·미리보기 제어 | `2732+` |
| 호스트→에디터(KOI iframe) | `{target:"KOI-SDK", action:"refreshToken"}` | 토큰 갱신 푸시 | `10522-10529` |
| 에디터→호스트 | `from-edicus`/`from-edicus-root`/`from-edicus-tnview` | `target_callback(null, e)` → editorEventHandler | `2579` |
| 에디터→호스트 | `from-edicus-private` | deferred 핸드셰이크(SDK 자체처리, 호스트 콜백 안감) | `2580-2633` |
| 에디터(KOI Passive)→호스트 | `{target:"From-KOI-Passive", type:"load/save/error/close"}` | 별도 리스너 `q`/`s` | `10455-10471` |

---

## 3. from-edicus 액션 디스패처 전수 카탈로그 (30종)

`editorEventHandler(e, n)` (`edsdk:11336`). `e`(에러)면 `alert(e)` 후 종료. 아니면 `n.action`으로 분기:

| # | action | 게이트 | 핸들러 동작 | 콜백 | line |
|---|--------|--------|-------------|------|------|
| 1 | `project-id-created` | — | `D("projectId", info.project_id)` 저장 + `l(n)` | onCreate(`l`) | 11349 |
| 2 | `load-project-report` | status="end" | `isEditorBusy=false`, autoSave setInterval 시작(분단위 command:save), Sentry "Editor Loaded" | onLoad(`f`) | 11349 |
| 3 | `edit-template-report` | status="end" | load-project-report와 동일 경로 | onLoad(`f`) | 11349 |
| 4 | `show-tn-report` | status="end" | `f(n)` | onLoad(`f`) | 11363 |
| 5 | `doc-changed` | info 존재 | template_uri 있으면 `getResourceWithId`→`updateTemplateCount(hit)`; vdp_catalog 있으면 `vdpCatalogData` 갱신 | onChange(`p`) | 11363-11380 |
| 6 | `var-added` | — | onChange(`p`) 호출 경로 | onChange(`p`) | 11363 |
| 7 | `var-deleted` | — | onChange(`p`) | onChange(`p`) | 11363 |
| 8 | `var-changed` | — | onChange(`p`) | onChange(`p`) | 11363 |
| 9 | `page-changed` | — | `P(n)` | onPageChange(`P`) | 11382 |
| 10 | `promo-external-report` | — | `y(n)` | onPromoReport(`y`) | 11382 |
| 11 | `command-completed` | — | `commandPromiseHandlers.resolve(n)` (remoteEditor Promise) | — | 11382 |
| 12 | `command-rejected` | — | `commandPromiseHandlers.reject(n)` | — | 11384 |
| 13 | `save-doc-report` | status="end" | Sentry "Editor Saved" + `h(n)` | onSave(`h`) | 11386 |
| 14 | **`close`** | — | (15와 공유) isReadyToOrder→isCanOrder→Sentry "Editor Close"→`d(n)` | onClose(`d`) | 11393 |
| 15 | **`goto-cart`** | — | **close와 동일 핸들러**: `info.projectID` 있으면 `isReadyToOrder(projectID)`→`can_order?isCanOrder=true:{error,false}`; finally `d(n)`; autoSave interval clear | onClose(`d`) | 11393-11417 |
| 16 | `selection-changed` | — | `v(n)` | onSelect(`v`) | 11419 |
| 17 | `state-history` | — | `g(n)` | onHistoryState(`g`) | 11419 |
| 18 | `label-history` | — | `_(n.info)` | onHistoryLabel(`_`) | 11419 |
| 19 | `dpp-execute-report` | status="end" | `onDdpExecuteComplete()` 1회 호출 후 null | `k` | 11419 |
| 20 | `scene-info-report` | — | activePage 병합 후 `sceneInfoCallback(sceneInfo)` 1회 후 null | `N` | 11419 |
| 21 | `imgpool-notify` | — | `w(n.info)` | onImagePool(`w`) | 11419 |
| 22 | `preview-closed` | — | `S()` | onPreviewClose(`S`) | 11419 |
| 23 | `font-list` | — | `E(n.info)` | onFontList(`E`) | 11419 |
| 24 | `enter-overlay-mode` | — | `I(n)` | onChangeMode(`I`) | 11419 |
| 25 | `exit-overlay-mode` | — | `I(n)` | onChangeMode(`I`) | 11419 |
| 26 | `page-count-changed` | — | `T(n)` | onPageCountChange(`T`) | 11419 |
| 27 | `request-page-size-change` | — | `m(n)` | onGroupCaption(`m`) | 11419 |
| 28 | `request-user-token` | — | `issueUserToken`→division/lang/companyCode 저장→editorToken 갱신→`post_to_editor("send-user-token",{token})` | — | 11419-11431 |
| 29 | `impose-opened` | — | `O(n)` | onImposeOpened(`O`) | 11432 |
| 30 | `page-group-print-count-changed` | — | `j(n)` | onPrintCountChange(`j`) | 11432 |
| 31 | `prod-var-changed` | — | `C(n)` | onCustomTabSelectionChange(`C`) | 11432 |
| 32 | `doc-report` | — | Sentry "Doc Report" + `R(n)` | onDocReport(`R`) | 11432 |
| — | (전역) `x(n)` | 모든 action | onAllEvents(`x`) 항상 호출 | onAll(`x`) | 11439 |

> KOI-Passive 경로(`edsdk:10455-10471`, target="From-KOI-Passive"): `load`→`f`, `save`→`h`, `error`→`H`, `close`→`d`. (passive 모드 별도 채널.)
> from-edicus-private(`edsdk:2580`): `waiting-for-extra-param`(§5), `waiting-for-ddp-data`.

---

## 4. to-edicus 메시지 (호스트/위젯 → 에디터)

### 4.1 iframe URL 명령 (`Qe.*_project`)
- `create_project`: `?cmd=create&token=&ps_code=&title=[&template_uri][&content_uri]`
- `open_project`: `?cmd=open&token=&prjid=`
- `edit_template`: `?cmd=edit-template&token=&ps_code=[&prjid][&template_uri]`
- `reform_project`: `?cmd=reform&token=&prjid=&ps_code=`
- `recycle_project`: `?cmd=recycle&token=&prjid=&title=`
- `create_design_project`/`open_design_project`: `cmd=create-design-project`/`open-design-project`
- preview/tnview/lite/gallery: 별도 path
- 공통 URL 파라미터 40+(`_add_common_url_param`, `edsdk:2641`): partner/mobile/div/lang/ui_locale/editor_type/parent_type/env_mode/run_mode/master_mode/edit_mode/ui_style/num_page/max_page/min_page/unit_page/max_order/min_order/force_plugin/plugin_param/edit_lock/no_update/clear_src/cal_date/video_frames + deferred flags(`wait_ddp/wait_private_css/wait_prod_info/wait_options/wait_option_string`)

### 4.2 postMessage 명령 (iframe 생성 후)
| 메서드 | type | action | info |
|--------|------|--------|------|
| change_project | to-edicus-root | change-project | {project_id} |
| change_template | to-edicus-root | change-template | {ps_code, template_uri} |
| change_layout | to-edicus | change-layout | {layout_uri, page_index, change_background_if_available} |
| execute_ddp_block | to-edicus | execute-ddp-block | {ddp_block, history_label} |
| post_to_editor(action,info) | to-edicus | (임의) command/save/send-user-token… | info |
| send-extra-param(응답) | to-edicus-root | send-extra-param | {params:[...]} |
| send-ddp-data(응답) | to-edicus-root | send-ddp-data | {ddp_block} |
| autoSave | to-edicus | command | {type:"save", show_progress:false, force_save:false} (50분 아닌 분단위 `W`) |
| token refresh(KOI) | (KOI iframe) | refreshToken | {token} (target:"KOI-SDK") |

### 4.3 위젯 인스턴스 6메서드 ↔ 에디터 SDK 매핑 (seam, 06맵 §4.2)
위젯은 에디터 SDK를 직접 호출하지 않음. **호스트 셸이 중계**:
- 위젯 `onOpenEditor(editorConfig{mode,type,config,option})` → 호스트가 `createProject`(NEW) / `openProject`(EDIT, config.projectId) 호출
- 에디터 결과 `onSave`/`onClose`(goto-cart) → 호스트가 위젯 `instance.setEditorData(data)` 역주입
- 위젯 `canOrder()`는 **위젯 자체 로직**(가격·업로드 검증), 에디터 `checkOrderable`(=isReadyToOrder)와 **별개**
- 위젯 `getKOIEditorTabData()`는 위젯이 자체 fetchPriceCalculation — 에디터 SDK 무관

---

## 5. goto-cart / close 심층 (런타임 캡처 누락분 코드 복원)

`edsdk:11386-11417` — `save-doc-report`(end) 처리 직후, `close` 또는 `goto-cart`이면 **공통 블록 진입**:
```
if (action !== "close" && action !== "goto-cart") → skip (case 45로)
// 진입 시:
try {
  if (n.info && n.info.projectID)
     s = await apiClient.call("isReadyToOrder", n.info.projectID || sessionStorage.projectId)
     // → s.can_order ? n.isCanOrder=true : (n.error=s, n.isCanOrder=false)
} catch (e) { onError(code="003"); n.error = e }
finally {
  Sentry.log("[openType]Editor Close")
  onClose(d)(n)        // 호스트 onClose 콜백 — n에 isCanOrder/error/info 실림
  clearInterval(autoSave)
}
```
**복원된 사실**:
- goto-cart에 **SDK-level `case`/switch 없음**. prior가 본 `info.case`는 **에디터가 보낸 페이로드 필드**로 SDK는 그대로 `n`에 담아 `onClose(d)`로 패스스루.
- 주문가능 판정 = `isReadyToOrder` API(`POST /editor` target=isReadyToOrder, collectionId=projectId) → `{can_order, doc_rev, message}`. `doc_rev===null`이면 강제 false(`checkOrderable` `edsdk:11950`).
- 호스트 onClose 콜백 페이로드(`n`): `{action:"goto-cart", info:{projectID, tnUrlList, totalPageCount, case, ...}, isCanOrder, error?}`.
- 즉 **장바구니 핸드오프는 onClose(goto-cart) 콜백 한 지점**. 호스트가 isCanOrder 검사 후 위젯 `setEditorData` + 주문/카트 라우팅.

---

## 6. origin 보안 finding

### 6.1 송신 (호스트→에디터) — `edsdk:2623, 2672, 2682, 2693, 2730 등`
```
iframe_el.contentWindow.postMessage(JSON.stringify(msg), "*")   // targetOrigin = "*"
```
모든 송신이 `"*"` 와일드카드. 에디터 iframe origin(edicusbase.firebaseapp.com)으로 한정하지 않음 → 메시지가 임의 origin iframe에 노출 가능.

### 6.2 수신 (에디터→호스트) — `edsdk:2575-2635`
```
messageListener = function(t) {
  if (t.data && typeof t.data === "string" && t.data.match(/^{.*}$/)) {
    var e = JSON.parse(t.data)
    if (e) if (e.type === "from-edicus" || ...) target_callback(null, e)
    // ← event.origin 검사 전혀 없음. e.type 문자열만 신뢰.
```
KOI-Passive 리스너(`edsdk:10455`)도 `e.target === "From-KOI-Passive"`만 검사, origin 무검증.

### 6.3 올바른 검사 (우리 구현 기준)
- 송신: `postMessage(msg, EDICUS_ORIGIN)` — `https://edicusbase.firebaseapp.com`(운영)/`edicus-stage.firebaseapp.com`(개발)을 targetOrigin으로 명시.
- 수신: `if (event.origin !== EDICUS_ORIGIN) return;` 를 핸들러 최상단에 추가 후 `e.type` 검사.
- (후니 자체 에디터/도메인 사용 시 해당 origin allowlist로 교체.)

---

## 7. 제품-분기 / 라이프사이클 분기 열거

| 분기축 | 위치 | 조건 |
|--------|------|------|
| sandbox 환경 | `edsdk:10519` | sandboxMode: "local"→local / truthy→dev / false→product (base_url·apiHost 분기) |
| inheritToken | `edsdk:10520` | true면 verifyToken/autoRefresh skip(부모 토큰 상속) |
| openType(mode) | `edsdk:K.openType` | create/open/reform/edit-template — Sentry 로그·라이프사이클 메시지 분기 |
| KOI vs RP 에디터 | 위젯 seam(06맵), 본 SDK는 KOI | 위젯이 `useKoiEditor==="Y"`→KOI / `useRPEditor`→RP config(`/api/editor/config/{KOI\|RP}`). 본 SDK는 KOI(makers) 전용 |
| KOI Passive 모드 | `edsdk:10458, K.fromKOIPassive` | fromKOIPassive면 별도 메시지 채널 + Sentry "(KOI-Passive)" 태그 |
| deviceTarget | `edsdk:K.deviceTarget` | "pc"/"mobile" — URL mobile 파라미터 |
| 페이지 제약(책자 등) | URL `num_page/max_page/min_page/unit_page` | createProject options(addPages/deletePages/emptyDocument/customDocument) |
| 캘린더 | createProject `calendarConfig`→URL `cal_date` | 캘린더 상품 |
| VDP | `openVdpViewer`, doc-changed의 vdp_catalog | 가변데이터 상품 |
| customTab | createProject `customTabInfo` + CustomTabManager | 옵션선택 UI 상품(자재선택 등) |
| staff 편집 | editTemplate `issueStaffToken`(50분 캐시) | 스태프 전용 |
| autoSave | load-report에서 `W`(분) setInterval | autoSave 옵션 설정 시 |

---

## 8. deferred-param 핸드셰이크 (큰 페이로드 전달 메커니즘)

`edsdk:2580-2633` — URL에 큰 데이터를 넣지 않고 `wait_{name}=true` 플래그만:
```
에디터 → 호스트: {type:"from-edicus-private", action:"waiting-for-extra-param",
                  info:{param_names:["prod_info","options","ddp_block",...]}}
호스트(SDK)   : 요청된 각 name을 Qe 내부 보관값(prod_info/options/ddp_block/private_css/
                option_string/data_row/data_feed/zoom/size_option/rsc_option/template_list)에서 꺼내
                {type:"to-edicus-root", action:"send-extra-param", info:{params:[{name, [name]:val}]}}
에디터 → 호스트: {type:"from-edicus-private", action:"waiting-for-ddp-data"}
호스트(SDK)   : {type:"to-edicus-root", action:"send-ddp-data", info:{ddp_block}}
```
이 핸드셰이크는 SDK가 자체 처리(호스트 콜백 비노출). createProject 시 `_set_deferred_params(opts)`로 Qe에 보관값 세팅.

---

## 9. "우리 구현과 대응시킬 축" (S1 훅 — editor-bridge.ts / EditorOverlay.tsx)

| Red 책임 | 우리 구현이 재현해야 할 것 |
|----------|-------------------------------|
| EditorBridge.init 1회 가드 | `editor-bridge.ts`: `window.addEventListener("message")` 1회 등록 + 가드 플래그. **origin allowlist 추가**(§6.3) — Red 와일드카드 보강. |
| iframe URL 명령 | `EditorOverlay.tsx`: cmd별 landing URL 조립(create/open/reform). 공통 URL 파라미터 빌더 + deferred flag(`wait_*`). targetOrigin 명시. |
| from-edicus 디스패처 30종 | `editor-bridge.ts` 디스패처: 30 action → 콜백 라우팅(§3 표 그대로). 특히 project-id-created/load-project-report(end)/doc-changed/save-doc-report(end)/goto-cart=close. `onAll` 항상 호출 유지. |
| **goto-cart=close 공유 + isReadyToOrder** | close/goto-cart 단일 핸들러. `info.projectID`로 주문가능 조회(후니는 자체 백엔드 어댑터의 `isReadyToOrder` 대응) → `isCanOrder` 판정 → onClose 콜백으로 `{projectID, tnUrlList, totalPageCount, isCanOrder}` 정규화 계약 전달. **case 값 switch 구현 불필요**(패스스루). |
| 토큰 수명 | `editorToken={token, expiredAt}` 보관, 50분 자동갱신(verifyToken/refreshAccessToken 대응), `request-user-token` 수신 시 send-user-token 응답. `inheritToken` 분기(부모 토큰 상속) 지원. JWT는 후니 백엔드 어댑터 발급(red-editor-token 헤더 대응). |
| deferred-param 핸드셰이크 | 큰 페이로드(prod_info/options/ddp_block 등)는 URL 미포함, `from-edicus-private:waiting-for-extra-param` 수신 시 `send-extra-param` 응답. SDK 내부 처리(호스트 콜백 비노출). |
| save / close / destroy | save=command(type:save); destroy=리스너 제거+iframe 제거+콜백 null화. autoSave setInterval(load 시작, close 시 clear). |
| KOI vs RP / Passive 분기 | NEW config는 `/api/editor/config/{KOI\|RP}` 응답으로 분기(위젯 seam). 후니는 자체 에디터 어댑터로 추상화 — bridge는 config.type에 따라 동작. |
| 위젯 seam 유지 | editor-bridge는 위젯과 **콜백 계약**으로만 연결(06맵 §4): `onOpenEditor` 수신→오버레이/iframe 구동, 결과→위젯 `setEditorData`. 위젯 스토어를 직접 만지지 않음. |

---

## 10. 잔존 미검증 / S1 주의
- 실제 `from-edicus` 메시지 타임라인 실시간 덤프는 prior 세션에서 미수행(헤드리스 풀 에디터 미실행). 본 맵은 **코드 권위** — action 30종·페이로드 구조는 소스 확정, 일부 info 세부필드는 런타임 확인 권장.
- 후니 에디터가 Edicus(edicusbase) 유지 시 origin/토큰 계약 동일; 후니 자체 에디터 채택 시 origin allowlist·토큰 발급 경로만 어댑터 교체.
