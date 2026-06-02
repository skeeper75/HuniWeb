# Edicus 에디터 브릿지 프로토콜 (postMessage 라이프사이클)

> 파이프라인 ① 미검증 영역 #3 보강. Edicus iframe ↔ 호스트 postMessage 양방향 프로토콜.
> 근거: `deob_editor_sdk.js:2550-2745`(브릿지 KOI/Qe 객체) + `raw/widget_monitor/local/index.html:324-392`(호스트 수신 핸들러, 라이브 동작 검증된 테스트베드).
> 근거 표기: `[정적 분석]` 비난독화 소스 / `[라이브 검증]` 테스트베드 동작·캡처 / `[추정]`

---

## 1. 에디터 아키텍처 [정적 분석]

- 운영 base_url: `https://edicusbase.firebaseapp.com`
- 개발 base_url: `https://edicus-stage.firebaseapp.com`
- 진입 경로: `landing_path=/ed#/editor_landing`, `tnview_path=/ed#/tnview/landing`, `preview_path=/ed#/preview/landing`, `lite_path=/ed#/lite/landing`
- 통신: 호스트가 `<iframe>` 생성 → `iframe.contentWindow.postMessage(JSON.stringify(msg), "*")` 송신, `window.addEventListener("message")` 수신.
- 이벤트 리스너 1회만 등록(`window.__KOI_EVENT_LISNTER_INITIALIZE` 플래그).

## 2. 메시지 type 분류 [정적 분석]

| 방향 | type | 용도 |
|------|------|------|
| 호스트→에디터 | `to-edicus-root` | 프로젝트/문서 레벨 제어 (change-project, send-extra-param, send-ddp-data) |
| 호스트→에디터 | `to-edicus` | 편집 동작 (change-layout, set-item-attribute, add-page 등 다수) |
| 호스트→에디터 | `to-edicus-tnview` / `to-edicus-preview` | 썸네일뷰·미리보기 제어 |
| 에디터→호스트 | `from-edicus` / `from-edicus-root` / `from-edicus-tnview` | 일반 콜백 → `target_callback(null, e)` 전달 |
| 에디터→호스트 | `from-edicus-private` | 내부 핸드셰이크(deferred param 요청) — SDK가 직접 처리, 호스트 콜백 안 감 |

## 3. 프로젝트 진입 (iframe URL 명령) [정적 분석]

`Qe.create_project / open_project / edit_template / reform_project / recycle_project` — iframe src URL 쿼리로 명령 전달:

```
{base_url}/ed#/editor_landing?cmd=create&token={JWT}&ps_code={psCode}&title={enc}
   [&template_uri=...][&content_uri=...]  + 공통 파라미터
```
- `cmd`: `create` | `open`(+prjid) | `edit-template` | `reform`(+prjid+ps_code) | `recycle`(+prjid+title) | `create-design-project` | `open-design-project`
- 공통 URL 파라미터(`_add_common_url_param`, 40+개): `partner, mobile, div, lang, ui_locale, editor_type, parent_type, run_mode, master_mode, edit_mode, ui_style, num_page, max_page, min_page, unit_page, max_order, min_order, force_plugin, plugin_param, edit_lock, no_update, clear_src, ...`
- **Deferred 파라미터**: 큰 데이터(ddp_block, private_css, prod_info, options, option_string, data_row, data_feed, zoom, size_option, rsc_option, template_list)는 URL에 `&wait_{name}=true` 플래그만 붙이고, 에디터가 준비되면 `from-edicus-private:waiting-for-extra-param` 으로 요청 → 호스트가 `to-edicus-root:send-extra-param` 으로 응답. [정적 분석]

## 4. Deferred-Param 핸드셰이크 [정적 분석]

```
에디터 → 호스트:  {type:"from-edicus-private", action:"waiting-for-extra-param",
                   info:{param_names:["prod_info","options",...]}}
호스트 → 에디터:  {type:"to-edicus-root", action:"send-extra-param",
                   info:{params:[{name:"prod_info", prod_info:{...}}, ...]}}

에디터 → 호스트:  {type:"from-edicus-private", action:"waiting-for-ddp-data"}
호스트 → 에디터:  {type:"to-edicus-root", action:"send-ddp-data", info:{ddp_block:{...}}}
```
이 핸드셰이크는 SDK가 자체 처리하며 위젯 코드로 노출되지 않음.

## 5. 라이프사이클 (from-edicus, 호스트 수신) [라이브 검증된 핸들러 + 정적]

`index.html:326` 정의된 라이프사이클 단계 (테스트베드 실동작 기반):
```
init → ready-to-listen → doc-changed → project-id-created
     → save-doc-report:start → save-doc-report:end → goto-cart → close
```

### 주요 inbound 이벤트 페이로드 [정적+라이브]

**save-doc-report** (저장 보고 — projectID·문서정보 획득):
```json
{ "type":"from-edicus", "action":"save-doc-report",
  "info": { "phase":"start"|"end",
            "docInfo": { "projectID":"...", "psCode":"...",
                         "tnUrlList":["<썸네일 URL>", ...],
                         "totalPageCount": <n> } } }
```
호스트(`index.html:358`)는 `info.docInfo`를 `window.__lastEditorDocInfo`로 보관.

**goto-cart** (장바구니 이동 — 편집 완료, 주문 데이터 확정):
```json
{ "type":"from-edicus", "action":"goto-cart",
  "info": { "projectID":"...", "tnUrlList":[...], "totalPageCount":<n>, "case":"..." } }
```
호스트(`index.html:364`)가 만드는 완료 페이로드:
```json
{ "projectID": info.projectID,
  "tnUrlList": info.tnUrlList || docInfo.tnUrlList || [],
  "totalPageCount": info.totalPageCount || docInfo.totalPageCount || 0,
  "case": info.case }
```
→ 에디터 오버레이 닫고, 스토어 스냅샷 갱신, 주문 데이터에 projectID·썸네일·페이지수 반영.

## 6. Outbound 편집 액션 (to-edicus) [정적 분석]

`deob_editor_sdk.js` 9768~10381 영역의 액션 벌브:
`set-item-attribute, delete-page, set-page-attribute, clone-page, flip-sticker, change-layout, copy-page-content, new-document, add-page, set-text-style, set-item-layer-filter, resize-page, impose-pages, add-page-group, clone-page-group, change-page-group-info, change-project, change-template, execute-ddp-block` 등.

프로젝트 레벨: `change_project(project_id)`, `change_template(ps_code, template_uri)`, `change_layout(layout_uri, page_index, change_bg)`.

## 7. KOI 에디터 설정 API [정적 + 부분 라이브]

**`POST /api/editor/config/{KOI|RP}`** (widget-api) — `deob_06:576`
- `KOI` = 코이(자체) 에디터, `RP` = 레드프린팅 에디터
- 응답 shape [라이브 캡처 — body-log.json, 과거 위젯 구동 시 200]:
```json
{ "config": { "locale":"ko", "title":"...", "psCode":"...", "templateUrl":"...",
              "resource_id": <n>, "token":"<JWT>" },
  "option": { "pluginCustomData": {...} },
  "error": null }
```
> 본 라이브 세션에서 직접 curl POST 시 프록시 body 전달 이슈로 500 (서버가 payload undefined로 인식). 실제 위젯 구동 경로에서는 200 확인됨(api-log.json 다회 기록). [라이브 검증: 위젯 경로 / 미검증: 직접 호출 페이로드 형태]

### makers-api 흐름 (KOI 에디터 토큰·리소스) [라이브 검증, api-log]
위젯이 에디터를 열 때 순차 호출:
```
POST /widget-api/api/editor/config/KOI   → 200 (config+token)
POST /makers-api/token                   → 200 (69 bytes, 토큰)
POST /makers-api/editor                  → 200 (~642 bytes)
PUT  /makers-api/v1/template/{base64}/hit→ 200 (히트 카운트)
GET  /makers-api/v2/template/resource/{id} → 500 (리소스 — 토큰 컨텍스트 의존, 직접 호출시 실패)
```

## 8. 후니 시사점

1. 후니 Edicus 브리지는 동일 `to-edicus*`/`from-edicus*` 프로토콜 사용. 위젯은 **createProject(token, ps_code, title)** → deferred-param 응답(prod_info/options) → **save-doc-report** 수신(projectID 보관) → **goto-cart** 수신(주문확정) 시퀀스만 구현하면 핵심 충족.
2. React-in-Shadow-DOM 위젯에서 호스트 통합은 `from-edicus:goto-cart` → 위젯 정규화 계약(projectID·tnUrlList·totalPageCount)로 매핑하는 어댑터로 처리.
3. 토큰은 KOI config의 `token`(JWT, red-editor-token 헤더) — 후니 백엔드 어댑터가 발급.

## 9. 잔존 미검증

- 본 라이브 세션에서 에디터 iframe 실구동 → 실제 `from-edicus` 메시지 타임라인 직접 캡처는 미수행(헤드리스 브라우저 풀 에디터 플로우 미실행). 라이프사이클 단계·페이로드는 테스트베드 핸들러(index.html, 검증된 동작) + 정적 소스 근거. [라이브 검증: 핸들러 / 미검증: 본 세션 실시간 메시지 덤프]
- `save-doc-report`의 `phase` 외 추가 info 필드, `goto-cart`의 `case` 값 종류 — 미캡처. [미검증]
