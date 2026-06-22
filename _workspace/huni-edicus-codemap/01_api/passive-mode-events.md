# 패시브 모드 이벤트 — 양면 카탈로그 (Edicus 공식 ↔ RedEditorSDK KOI-Passive)

권위[HARD·양면 둘 다 1급]:
- **Edicus 공식**: `docs/edicus.man/docs/Edicus JS SDK.pdf` (38p). 근거 `PDF p.N`.
- **RedEditorSDK 역공학**: `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_editor_sdk.js` (v6.6.48). 근거 `deob_editor_sdk.js:라인`.

> **두 패시브 레이어가 존재한다**(재실행 핵심 발견). ① **Edicus 공식 passive** — `target="from-edicus"`, 14 action을 콜백 `function(err,data)`로 부모에 흘림(세밀). ② **RedEditorSDK KOI-Passive** — RedPrinting이 Edicus를 iframe으로 감싸고, 그 iframe이 보내는 메시지를 `target="From-KOI-Passive"`, **4 type(load/save/error/close)** 으로 단순화·재포장한 래퍼 채널. 후니가 Edicus를 직접 통합하면 ①을 보지만, RedPrinting 레퍼런스(RedEditorSDK 사용 시)는 ②를 본다. 이전 실행은 ②를 누락했다.

---

# PART A — Edicus 공식 패시브 (`from-edicus`, 14 action)

## A.0 개요 (`PDF p.19`)
- 패시브 모드 = edicus를 작업영역(canvas)만 보이게 띄우고, 부모(고객사 페이지)↔edicus 내부가 postMessage 연동. (multi line 미지원)
- 진입: `create_project`/`open_project`의 `run_mode='passive'` (`PDF p.19`).
- 수신(edicus→고객사): create_project/open_project에 등록한 **callback**으로 메시지 유입.
- 송신(고객사→edicus): `post_to_editor` API (`sdk-method-catalog.md` §10).

## A.1 callback data 공통 구조 (`PDF p.19-20`)
callback `function(err, data)` — `data` = `{ action:string, info:object }`.

### A.1 action 14종 (`PDF p.19-20`) — grep 식별자=케밥 문자열
| action | 설명 |
|--------|------|
| `ready-to-listen` | 수신 준비 완료 신호(설명 PDF 미기재) |
| `load-project-report` | 프로젝트 최초 로드 상태 보고 |
| `change-project-report` | 프로젝트 변경 상태 보고 |
| `change-template-report` | 템플릿 변경 상태 보고 |
| `project-id-created` | 새 project-id 생성됨 |
| `save-doc-report` | edicus doc 저장 시작/종료 |
| `doc-changed` | edicus doc 로드/변경 |
| `page-changed` | page 변경 |
| `var-added` | 외부 연동 아이템 추가 |
| `var-deleted` | 외부 연동 아이템 삭제 |
| `var-changed` | 외부 연동 아이템 내용 변경 |
| `state-history` | 히스토리 상태 보고 |
| `error-report` | 중요 오류 전달 |
| `close` | edicus 닫기 요청 |

## A.2 info 페이로드 (action별)

### A.2.1 `load-project-report` & `change-project-report` (`PDF p.20`)
`{ status: start/end/denied/error, error?(status=error), project_id }`

### A.2.2 `change-template-report` (`PDF p.20`)
`{ status: start/end/denied/error, error?, psCode, template_uri }`

### A.2.3 `project-id-created` (`PDF p.20`)
`{ project_id }`

### A.2.4 `error-report` (`PDF p.20`)
`{ error: "load-prodinfo-failed"(pscode로 prodinfo 못 얻음) / "load-template-failed"(template_uri로 템플릿 못 얻음) }`

### A.2.5 `doc-changed` (`PDF p.20`)
`{ ps_code(product_size_code), page_count(number), vdp_catalog(variable data 정보; 세부 모름) }`

### A.2.6 `save-doc-report` (`PDF p.21`)
`{ status: start/end/error, docInfo:any, error?(status=error) }`
- **docInfo@start & error**: `{ projectID }`
- **docInfo@end — 일반상품** (`PDF p.21-22`): `{ projectID, docRevision, totalPageCount, contentPageCount, totalCellCount, emptyCellCount, lowResCellCount, vdpList(varInfo), layerDetect(미기재), tnUrlList[], usedFontsList[{familyName,typeStyleName,fullName,issue,url}], unresolvedFontsList?[{page_index,fonts_unresolved[],text_raw}], caleandarInfo{year,month,index_range,options,categories} }`
- **docInfo@end — 사진인화** (`PDF p.22-23`): `{ projectID, docRevision, totalPrintCount, totalOrderCount, totalLoadingCount(미기재), paperType:"matte"/"gloss", lowResPrintCount, tnUrlList[], prints[{orderCount}] }`

### A.2.7 `page-changed` (`PDF p.23`)
`{ page_index(number), page_type(string, 기본 'content') }`

### A.2.8 `state-history` (`PDF p.23`)
`{ can_undo, can_redo, doc_dirty }` — Undo/Redo/Save 버튼 enable 대응.

### A.2.9 `var-added` & `var-deleted` & `var-changed` (`PDF p.23-24`)
`{ item_type, path(itemPath{item_id,page_id,page_index}), variable(varInfo{type,id,title,group_id,extra}), data{text}, state{enable} }`
- 처리규칙(`PDF p.24`): var-added→text-field 생성/보관 · var-deleted→item_id 연결 text-field 삭제 · var-changed→info.data.text로 value 갱신/info.state.enable로 활성화 토글.

## A.3 Preview 모드 콜백 (별개 채널, `PDF p.28-29`)
- `open_preview` callback에서 back 클릭: `data={ type:"from-edicus-preview", action:"close" }` → `editor.destroy()`. (passive 콜백과 별도 type)

## A.4 토큰 만료 흐름 (콜백 연계, `PDF p.6-9`)
- callback이 `{ type:"from-edicus", action:"request-user-token" }` → 고객사 서버 새 토큰 발급 → `post_to_editor("send-user-token",{token})`. (Server API `POST /api/auth/token`)

---

# PART B — RedEditorSDK KOI-Passive (`From-KOI-Passive`, 4 type)

## B.0 채널 정의 — 메시지 리스너 `q` (`deob_editor_sdk.js:10455-10472`)
RedEditorSDK는 KOI iframe이 보내는 메시지를 전용 리스너 `q`로 받는다. JSON 문자열을 파싱해 `target === "From-KOI-Passive"`일 때만 `type` 4종을 분기한다(`:10456-10470`):

```js
q = function(t) {
  if (t.data && "string"==typeof t.data && t.data.match(/^{.*}$/g)) {
    var e = JSON.parse(t.data);
    if (e && "From-KOI-Passive" === e.target) switch (e.type) {   // :10458
      case "load":  A=!1, D("projectId", e.info.info.project_id), f(e.info); break;  // :10459-10461
      case "save":  h(e.info); break;                                                 // :10462-10463
      case "error": H(e.info); break;                                                 // :10465-10466
      case "close": d(e.info);                                                        // :10468-10469
    }
  }
}
```

## B.1 KOI-Passive 4 type (`deob_editor_sdk.js:10458-10470`)
| type | 핸들러(내부) | 동작 | 근거 |
|------|--------------|------|------|
| **`load`** | `f(e.info)` | 로딩 락 해제(`A=false`) + sessionStorage `projectId` = `e.info.info.project_id` 저장 + load 콜백 호출 | `:10459-10461` |
| **`save`** | `h(e.info)` | save 콜백 호출 | `:10462-10463` |
| **`error`** | `H(e.info)` | error 콜백 호출(생성자 토큰 발급 실패 등에도 같은 `H` 사용) | `:10465-10466` |
| **`close`** | `d(e.info)` | close 콜백 호출 | `:10468-10469` |

- 메시지 shape: `{ target:"From-KOI-Passive", type:"load"|"save"|"error"|"close", info:{...} }`.
- `load`의 info는 **이중 중첩**: `info.info.project_id` (`:10460`) — KOI 게이트웨이가 Edicus 원본 info를 한 겹 더 감쌈.
- 역방향(SDK→KOI iframe)은 별 target: 토큰 갱신 시 `{ target:"KOI-SDK", action:"refreshToken", info:{token} }` postMessage (`:10522-10529`).

## B.2 KOI-Passive 트리거 체인 [HARD]
KOI-Passive 4 type 채널이 켜지는 경로:

1. **생성자 플래그**: `new RedEditorSDK({ fromKOIPassive:true, ... })` → `K.fromKOIPassive = t.fromKOIPassive` (`:10513`). 이후 로깅·동작이 KOI-Passive 분기(`:11356,11387,11404,11433`에서 `(KOI-Passive)` 라벨).
2. **hideToolbar→passive 모드 전환**: createProject/openProject의 `projectOptions.hideToolbar`가 truthy면 `editorConfig.hideToolbar=true` **그리고 `K.mode="passive"`** (`:10666` createProject / `:10860` openProject / `:11044` reformProject).
3. **iframe URL run_mode**: iframe URL 빌드 시 `run_mode: editorConfig.hideToolbar ? "passive" : "standard"` (`:10762` create / `:10955` open / `:11059` reform / `:11129`). URL 빌더가 `&run_mode=passive`로 부착(`:2642`의 `run_mode` 쿼리 조립).
4. → Edicus iframe이 passive로 뜨고, KOI 게이트웨이가 Edicus의 `from-edicus` 메시지를 받아 `From-KOI-Passive`(4 type)로 재포장해 부모 SDK 리스너 `q`(`:10455`)로 전달.

**요약 체인**: `fromKOIPassive`(생성자) / `hideToolbar`(옵션) → `K.mode="passive"`(`:10666`) → iframe `run_mode=passive`(`:10762`) → Edicus passive 가동 → `From-KOI-Passive` 4 type → 리스너 `q`(`:10458`) → load/save/error/close 콜백 → `on()` 이벤트 emit.

> 주의: `K.mode="passive"`(toolbar 숨김 편집 = Edicus 공식 패시브와 같은 `run_mode=passive`)와 `fromKOIPassive`(KOI 게이트웨이 경유 플래그)는 별개 신호다. hideToolbar만으로도 Edicus는 passive로 뜨지만, `From-KOI-Passive` 4 type 메시지는 KOI 게이트웨이를 통해 들어올 때 수신된다.

---

# PART C — 양면 매핑 (Edicus 14 action ↔ KOI-Passive 4 type)

RedEditorSDK는 Edicus 공식 14 action을 **라이프사이클 4 type으로 단순화**한다. 1:1이 아니라 **N:1 묶음**이다(여러 Edicus action이 한 KOI type으로 수렴).

| KOI-Passive type (`From-KOI-Passive`) | 수렴하는 Edicus action (`from-edicus`) | 근거 |
|---------------------------------------|----------------------------------------|------|
| **`load`** | `load-project-report`(end) · `project-id-created` · `doc-changed` (프로젝트/문서 로드 완료 묶음) | `:10459-10461`(project_id 추출) ↔ `PDF p.20` |
| **`save`** | `save-doc-report`(start/end·일반상품/사진인화 docInfo) · 사실상 `state-history`의 doc_dirty 후속 | `:10462` ↔ `PDF p.21-23` |
| **`error`** | `error-report`(load-prodinfo-failed/load-template-failed) · `change-*-report`의 status=error/denied | `:10465` ↔ `PDF p.20` |
| **`close`** | `close` (edicus 닫기 요청) | `:10468` ↔ `PDF p.20`,`p.6` |
| (KOI 4 type에 직접 노출 안 됨 = on() 이벤트로만) | `change-project-report` · `change-template-report` · `page-changed` · `var-added/deleted/changed` · `ready-to-listen` | 아래 ※ |

※ Edicus의 세밀 action(page-changed·var-*·change-template-report 등)은 KOI-Passive 4 type **밖**이며, RedEditorSDK 측에서는 별도 `on()` 이벤트(`pageChange`·`change`·`docReport` 등, `rededitor-sdk-catalog.md` §7의 22 이벤트)로 라우팅된다(=KOI-Passive는 "큰 라이프사이클 4단계"만, 세밀 변경은 standard 이벤트 경로). 4 type↔on 이벤트의 정확 라우팅 코드 대조는 **code-cartographer 영역**.

### 단순화 의미
- **Edicus 공식(14)** = 세밀·상태머신형(편집 중 모든 변화 추적; 외부 var 연동·페이지 이동까지).
- **KOI-Passive(4)** = 게이트웨이형·라이프사이클만(열림/저장/오류/닫힘). RedPrinting은 KOI 게이트웨이 안에서 세밀 이벤트를 소비·흡수하고, 부모(상품 페이지)에는 4단계만 노출해 통합을 단순화.

---

## 미상 / 정직 표기
- `ready-to-listen` info/의미: **모름(PDF 미기재)** (post_to_editor `request-feature`를 직후 보낸다는 언급만, `PDF p.15`).
- `doc-changed.vdp_catalog`, `save-doc-report.layerDetect`/`totalLoadingCount` 세부: **모름(PDF 미기재)**.
- KOI-Passive `load/save/error/close`의 `info` 내부 스키마: 코드상 `e.info`/`e.info.info`만 확인(`:10460`). 그 하위 필드 전체 = Edicus 원본 info와 동형으로 추정되나 **KOI 게이트웨이 변형분은 부분 모름**(deob 미노출).
- 내부 핸들러 `f`/`h`/`H`/`d`의 정확한 emit 대상 `on()` 이벤트명: deobfuscated 파일에서 minified 바인딩이라 직접 라인 확정 불가 → **code-cartographer가 d.ts/wrapper.ts로 대조**(생성자 토큰 발급 실패 시에도 `H` 재사용 = error 콜백 공유는 `:10517,10539,10551`에서 확인).
- 14→4 매핑의 일부 묶음(load에 doc-changed 포함 여부 등)은 `:10460`의 project_id 추출·라벨 로깅(`:11356-11433`)에서 추정 — 정확 라우팅은 KOI 게이트웨이(별 코드, 미보유)에 있어 **부분 추정**으로 표기.
