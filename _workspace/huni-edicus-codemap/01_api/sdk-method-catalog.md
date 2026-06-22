# Edicus JS SDK — 메서드 계약 카탈로그

권위[HARD]: `docs/edicus.man/docs/Edicus JS SDK.pdf` (38p, Copyright 2018 모션원). 모든 계약에 `PDF p.N` 근거.
보조 대조: `docs/edicus.man/docs/red-editor-sdk-analysis.md`(역공학 RedEditorSDK v6.6.48 / EdicusSDK v2). 역공학은 PDF를 덮어쓰지 않으며 버전 차이만 주석으로 표기.

> 본 SDK = **EdicusSDK v2** (스크립트 `edicus-sdk-v2.js`). `init()`이 반환한 `editor` 객체로 나머지 메서드를 호출한다.
> 역공학 자료의 `RedEditorSDK`(v6.6.48: createProject/openProject/on/save/close...)는 RedPrinting이 v2 위에 올린 별도 래퍼이며, 본 카탈로그의 권위는 PDF(v2)다.

---

## 0. 준비 / 토큰 흐름

- 스크립트 추가: `<script src="edicus-sdk-v2.js"></script>` (`PDF p.2`).
- 에디터는 고객사 지정 `div` 아래 `iframe`으로 삽입됨 (`PDF p.2`).
- **토큰 흐름**(`PDF p.2`): 편집기를 띄우거나 액세스하려면 access token 필요 → 토큰은 **고객사 서버에서 edicus server로 접속해 발급**(Server API `POST /api/auth/token`) → 발급분을 **client로 전달** → SDK params의 `token`으로 사용. 세션 중 토큰 만료 시 edicus가 `request-user-token` action을 보내며, 고객사는 새 토큰을 서버에서 받아 `post_to_editor("send-user-token", { token })`로 전달 (`PDF p.7-9`).
- back/forward 등으로 편집기 iframe이 재표시될 때는 편집기가 보이지 않도록 설계됨 (`PDF p.2`).

---

## 1. `window.edicusSDK.init(config)` — SDK 준비 (`PDF p.3`)

- 시그니처: `let editor = window.edicusSDK.init(config);`
- 반환: `editor` (이후 모든 함수는 이 반환 객체로 호출).
- config:

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `base_url` | string | (지정 안 하면 default) | 에디쿠스 편집기 base url |

- 호출 시점: 최초 1회, 다른 모든 메서드 호출 전.

---

## 2. `editor.destroy(params)` — SDK 사용 종료 (`PDF p.4`)

- 시그니처: `editor.destroy({ parent_element });`
- 현재 편집기를 닫고 SDK가 확보한 모든 리소스 해제.
- params:

| Key | Type | 설명 |
|-----|------|------|
| `parent_element` | HTMLDomElement | 편집기 생성/열기 시 사용한 dom element |

- 반환/콜백: PDF 미기재. (preview 종료 시 destroy 사용 예: `PDF p.29`)

---

## 3. `editor.create_project(params, callback)` — 새 상품 만들기 (`PDF p.5-7`)

- 시그니처: `editor.create_project(params, callback);`
- 새 상품을 편집기에 열려면 `ps_code`, `template_uri`, `token` 필요 (`PDF p.5`).
- params:

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | 편집기 iframe이 추가될 dom node |
| `partner` | string | | 부여받은 partner-id |
| `token` | string | | 서버를 통해 받은 access key |
| `mobile` | boolean | false | 모바일 UI로 띄우기 |
| `div` | string | host | division code |
| `lang` | string | ko | language code ("ko"·"ja"·"en") |
| `ui_locale` | string | same with lang | ui locale code ("ko"·"ja"·"en") |
| `ps_code` | string | | 사이즈코드 + 상품 코드 |
| `template_uri` | string | | 리소스 템플릿 uri |
| `title` | string | | 제목 |
| `run_mode` | string | 'standard' | 패시브 모드로 열 때 'passive' |
| `edit_mode` | string | 'standard' | 디자이너 모드로 열 때 'design' |
| `num_page` | number | | 포토북 내지 스프레드 장수 (없으면 template 그대로 생성) |
| `max_page` | number | | 내지 스프레드 최대 장수 (기본=paging rule) |
| `min_page` | number | | 내지 스프레드 최소 장수 (기본=paging rule) |
| `cal_date` | string | | 달력 날짜 생성 커맨드. 'year-month' 또는 'year-month-this-prev-next'. 예 '2019-1'→2019년 1~12월 / '2019-1-12-1-1'→2018년 12월~2020년 1월(총 14개월) |
| `private_css` | string | | css 오버라이드 값 |
| `clear_src` | string | | item default src 삭제 (현재 "cell"만 가능) |
| `no_update` | boolean | false | true면 편집 종료 버튼이 '나가기'로 바뀌고, 저장 없이 바로 goto-cart |
| `options` | object | | (확장) 에디터 추가 설정. 하위 `sizing`={type:'page', width_mm, height_mm}로 대지 크기 변경 (`PDF p.31-32`) |

- callback: `function(err, data)` — 성공 시 `err === null` (`PDF p.6`).
- callback data.action 케이스 (`PDF p.6`):
  - 생성 성공: `{ type:"from-edicus", action:"project-id-created", info:{ project_id } }`
  - 편집기 종료: `{ type:"from-edicus", action:"close" }` (또는 `'goto-cart'`)
  - 토큰 필요: `{ type:"from-edicus", action:"request-user-token" }` → `post_to_editor("send-user-token", { token })`로 대응
  - 모바일 사진선택 탭 도움말: `{ type:"from-edicus", action:"request-help-message", info:{ case:'photo-import' } }`

---

## 4. `editor.open_project(params, callback)` — 편집 상품 열기 (`PDF p.8-9`)

- 시그니처: `editor.open_project(params, callback);`
- 저장된 프로젝트를 편집기로 연다.
- params (create_project와 공통 키 + 차이):

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | 편집기 iframe이 추가될 dom node |
| `partner` | string | | 부여받은 partner-id |
| `token` | string | | 서버를 통해 받은 access key |
| `mobile` | boolean | false | 모바일 UI로 띄우기 |
| `div` | string | host | division code |
| `lang` | string | ko | language code ("ko"·"ja"·"en") |
| `ui_locale` | string | same with lang | ui locale code |
| `prjid` | string | | **프로젝트 id** (open 전용) |
| `run_mode` | string | 'standard' | 'passive'=패시브 / 'preview'=사진인화 상품일 경우에만 적용 |
| `edit_mode` | string | 'standard' | 디자이너 모드 'design' |
| `no_update` | boolean | false | true면 "저장" 버튼이 "나가기"로 표시 |
| `num_page` / `max_page` / `min_page` | number | | 포토북 스프레드 장수 (create_project와 동일 의미) |

- callback: `function(err, data)` — 성공 시 `err === null`.
- callback data.action 케이스 (`PDF p.9`): `goto-cart`(또는 `close`), `request-user-token`, `request-help-message`(`info.case:'photo-import'`).

---

## 5. `editor.close(params)` — 편집기 닫기 (`PDF p.10`)

- 시그니처: `editor.close({ parent_element });`
- 현재 열려있는 편집기를 닫음.
- params:

| Key | Type | 설명 |
|-----|------|------|
| `parent_element` | HTMLDomElement | 편집기 생성/열기 시 사용한 dom element |

- 반환/콜백: PDF 미기재.

---

## 6. `editor.edit_template(params, callback)` — 템플릿 수정하기 (`PDF p.11`)

- 시그니처: `editor.edit_template(params, callback);`
- 템플릿 수정모드로 편집기를 연다.
- params:

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | 편집기 iframe이 추가될 dom node |
| `token` | string | | 서버를 통해 받은 access key |
| `div` | string | host | division code |
| `lang` | string | ko | language code |
| `ui_locale` | string | same with lang | ui locale code |
| `ps_code` | string | | 사이즈코드 + 상품 코드 |
| `template_uri` | string | | 리소스 템플릿 uri |

- callback: `function(err, data)` — 성공 시 `err === null`.
- callback data 케이스: 편집기 종료 `{ type:"from-edicus", action:"goto-cart" }`(또는 `close`).

---

## 7. `editor.change_project(project_id)` — 프로젝트 변경하기 (`PDF p.13`)

- 시그니처: `editor.change_project({ project_id });`
- 편집기가 떠 있는 상태에서 프로젝트를 변경.
- params:

| Key | Type | 설명 |
|-----|------|------|
| `project_id` | string | 프로젝트 id |

- 샘플: `editor.change_project({ project_id: "abcdefghijklmn" })`.

---

## 8. `editor.change_template(ps_code, template_uri)` — 템플릿 변경하기 (`PDF p.14`)

- 시그니처: `editor.change_template({ ps_code, template_uri });`
- 편집기가 떠 있는 상태에서 템플릿을 변경.
- params:

| Key | Type | 설명 |
|-----|------|------|
| `ps_code` | string | 템플릿의 ps code |
| `template_uri` | string | 템플릿의 resource uri |

- 샘플: `editor.change_template({ ps_code:"90x50@NC", template_uri:"gcs://template/partners/motion1/res/template/4201.json" })`.

---

## 9. 상품 삭제 (`PDF p.14`)

- 별도 SDK 메서드 없음 — **Server API "Delete Project"**(`DELETE /api/projects/:prjid`)를 고객사 서버에서 호출하는 방식으로 상품 삭제. (server-api-catalog.md 참조)

---

## 10. `editor.post_to_editor(action, info)` — 메시지 보내기 (`PDF p.15-18`)

- 시그니처: `editor.post_to_editor(action, info);`
- 동작 중인 edicus로 메시지 전송. 주로 패시브 모드에서 사용.
- arguments:

| Argument | Type | 설명 |
|----------|------|------|
| `action` | string | edicus에 전송할 메시지 종류 (아래) |
| `info` | object | action에 따른 메시지 세부 내용 |

- **action 종류** (`PDF p.15`):

| action | 설명 |
|--------|------|
| `command` | 간단한 명령 전달 (UNDO/REDO 등) |
| `var-changed` | 부모쪽 variable 변화를 edicus에 알려줌 |
| `add-image` | image 삽입을 명령 |
| `add-text` | text 삽입을 명령 |
| `request-feature` | 편집기 부가 기능 요청 (거부될 수 있음; 보통 ready-to-listen 직후 전송) |
| `send-user-token` | 새로운 token을 편집기에 보냄 |

- **info (action=`command`)** (`PDF p.15-16`):

| Key | Type | 설명 |
|-----|------|------|
| `type` | string | 명령 종류: `undo`·`redo`·`save` |
| `force_save` | boolean | |
| `show_progress` | boolean | |

- **info (action=`add-image`)** (`PDF p.16`):

| Key | Type | 값/설명 |
|-----|------|---------|
| `src_type` | string | `file-input`(파일 불러오기 창으로 로컬 파일 추가) |
| `method` | string | `add`(마지막 아이템으로 추가) |
| `item_type` | string | `cell`(사진틀로 추가)·`sticker`(스티커로 추가) |

- **info (action=`add-text`)** (`PDF p.16`):

| Key | Type | 설명 |
|-----|------|------|
| `variable` | varInfo | variable 정보 (varInfo 구조: §11) |
| `data` | object | `{ text, font_size(pt), align('left'/'center'/'right') }` |

- **info (action=`request-feature`)** (`PDF p.17`): `feature`(string, 요청 feature; `promo-window` 등) + `option`(object). `option@promo-window`: `{ preferredWidth, preferredHeight, url(iframe url), opened }`.
- **info (action=`var-changed`)** (`PDF p.17`): `{ item_type, path(itemPath), variable(varInfo), data:{ text } }`.
- **info (action=`send-user-token`)** (`PDF p.18`): `{ token: string }` — 새로 얻은 user-token 문자열.

- 샘플 (`PDF p.18`):
  - `editor.post_to_editor('command', { type:'undo' })`
  - `editor.post_to_editor('add-image', { src_type:'file-input', method:'add', item_type:'sticker' })`
  - `editor.post_to_editor('add-text', { name:'_text_001_', feature:'var:text', data:{ text:'내용을 입력하세요', font_size:10, align:'left' } })`
  - `editor.post_to_editor('var-changed', { name:'_text_001_', feature:'var:text', data:{ text:'...' }, item_id:234, page_id:5, page_index:0 })`

> 패시브 모드 콜백(edicus→고객사) 이벤트는 별도 파일 `passive-mode-events.md` 참조.

---

## 11. 공용 타입 — itemPath / varInfo (`PDF p.16, p.23, p.24`)

**itemPath** (`PDF p.16, p.23`):

| Key | Type | 설명 |
|-----|------|------|
| `item_id` | number | item 고유 번호 |
| `page_id` | number | item이 속한 page 고유 번호 |
| `page_index` | number | item이 속한 page index |

**varInfo / VariableInfo** (`PDF p.17, p.23, p.24`):

| Key | Type | 설명 |
|-----|------|------|
| `type` | string | 외부연동 action 타입 (input / select) |
| `id` | string | 외부연동에 사용할 아이템 id |
| `title` | string | 외부 연동 아이템의 title |
| `group_id` | string | select를 위한 group id |
| `extra` | any | 외부연동에 부가 데이터 |

**Variable 관련 Data Type (TypeScript 표기, `PDF p.24`)**:
```ts
interface VariableDataSet { rows: Array<VariableDataRow>; }      // 모든 Variable Data Table
interface VariableDataRow { cols: Array<VariableData>; }          // Print 1개에 대응
interface VariableData { id: string; value: { text: string }; }  // 1개 Variable Data
interface VariableInfo { type: string; id: string; title: string; group_id: string; extra: any; }
```

---

## 12. TnView (썸네일 뷰어) & VDP (`PDF p.25-27`)

개요(`PDF p.25`): TnView = EDICUS Editor에서 저장한 Project 썸네일을 보여주는 최소 모드. VDP(Variable Data Printing) = EDICUS DOC에 가변 데이터를 주입해 동적으로 최종 출력 제어. TnView에는 VDP의 한 row(variable_data_row)를 주입한다.

### 12.1 `editor.open_tnview(params, callback)` — TnView 시작 (`PDF p.25-26`)

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | iframe이 추가될 dom node |
| `token` | string | | 서버를 통해 받은 access key |
| `prjid` | string | | 프로젝트 id |
| `npage` | number | 1 | 한 화면에 보여줄 페이지 수 |
| `flow` | string | horizontal | 페이지 배치 방향 |

- callback: `function(err, data)` — 성공 시 `err === null`.

### 12.2 Page 이동 (`PDF p.26`)

- `editor.post_to_tnview("move-page", { direction:"next" });` (params: `direction` string, default "next", "prev"/"next")
- 단축 샘플: `editor.move_page_tnview("next");`

### 12.3 `editor.set_variable_data_row(varDataRow)` — TnView에 Variable Data 주입 (`PDF p.26-27`)

- 시그니처: `editor.set_variable_data_row(varDataRow);`
- TnView에 Variable Data 주입 → 썸네일 갱신.

| Key | Type | 설명 |
|-----|------|------|
| `varDataRow` | VairableDataRow | 한 개의 print에 해당하는 variable data 집합 |

- 주의(`PDF p.27` Harry 노트): `shrink:true` 적용 텍스트박스의 장평값은 단일 값이어야 함(인디자인 템플릿).

---

## 13. Preview (`PDF p.28-29`)

### 13.1 `editor.open_preview(params, callback)` — Preview 시작 (`PDF p.28`)

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | iframe이 추가될 dom node |
| `partner` | string | | 파트너 코드 |
| `uid` | string | | user id |
| `prjid` | string | | 프로젝트 id |
| `npage` | number | 1 | 한 화면에 보여줄 페이지 수 (숫자 또는 auto; auto면 pageGroup 있는 상품은 pageUnit으로 자동 설정) |
| `flow` | string | horizontal | 페이지 배치 방향 (horizontal / vertical / grid:{size}, 예 grid:312) |

- callback: `function(err, data)` — 성공 시 `err === null`.
- back button 클릭 시: `data = { type:"from-edicus-preview", action:"close" }` → 보통 `editor.destroy({ parent_element })`로 preview 제거 (`PDF p.28-29`).

### 13.2 `editor.post_to_preview(action, info)` — Preview Navigation (`PDF p.29`)

- 시그니처: `editor.post_to_preview(action, info);`
- 샘플: `editor.post_to_preview('move-page', { direction:'prev' })` / `('move-page', { direction:'next' })`.

---

## 14. `editor.recycle_project(params, callback)` — 프로젝트 재활용하기 (`PDF p.30-31`)

- 시그니처: `editor.recycle_project(params, callback);`
- 기존 프로젝트를 이용해 새 프로젝트 생성. **사용자 사진은 제거**됨.
- params (open_project와 유사):

| Key | Type | Default | 설명 |
|-----|------|---------|------|
| `parent_element` | dom element | | iframe이 추가될 dom node |
| `partner` | string | | 부여받은 partner-id |
| `token` | string | | 서버를 통해 받은 access key |
| `mobile` | boolean | false | 모바일 UI |
| `div` | string | host | division code |
| `lang` | string | ko | language code |
| `ui_locale` | string | same with lang | ui locale code |
| `prjid` | string | | 프로젝트 id |
| `title` | string | | 제목 |
| `num_page`/`max_page`/`min_page` | number | | 포토북 스프레드 장수 |
| `private_css` | string | | css 오버라이드 값 |
| `no_update` | boolean | false | true면 종료 버튼 '나가기', 저장 없이 goto-cart |

- callback: `function(err, data)` — 성공 시 `err === null`. 케이스는 create_project와 동일(project-id-created / close|goto-cart / request-user-token / request-help-message) (`PDF p.31`).

---

## 미상 / 정직 표기

- `init`/`destroy`/`close`/`change_project`/`change_template`의 명시적 반환값·콜백: **모름(PDF 미기재)** (콜백 없는 동기 호출로 기재됨).
- `post_to_editor`/`post_to_tnview`/`post_to_preview`의 반환값: **모름(PDF 미기재)**.
- `request-feature`의 전체 feature enum: PDF에 `promo-window`만 표로 노출, 나머지 항목은 **모름(PDF 미기재)**.
