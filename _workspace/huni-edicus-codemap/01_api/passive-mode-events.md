# Edicus 패시브 모드 이벤트 카탈로그

권위[HARD]: `docs/edicus.man/docs/Edicus JS SDK.pdf` (38p). 모든 계약에 `PDF p.N` 근거.

## 0. 개요 (`PDF p.19`)

- 패시브 모드 = edicus를 작업영역(canvas)만 보이게 띄우고, edicus 외부(고객사 페이지)와 edicus 내부가 postMessage로 연동하는 모드. edicus UI 최소화·부모 페이지에 embed. (multi line 미지원 — 취소선 표기)
- 진입: `create_project` / `open_project`의 `run_mode='passive'` (`PDF p.19`).
- 수신(edicus→고객사): `create_project`/`open_project`에 등록한 **callback** 함수로 메시지가 계속 들어옴.
- 송신(고객사→edicus): `post_to_editor` API (sdk-method-catalog.md §10 참조).

## 1. callback data 공통 구조 (`PDF p.19-20`)

callback `function(err, data)` — `data`:

| Data | Type | 설명 |
|------|------|------|
| `action` | string | edicus에서 전송된 메시지 종류 (아래 표) |
| `info` | object | action에 따른 메시지 세부 내용 |

### action 종류 (`PDF p.19-20`)

| action | 설명 |
|--------|------|
| `ready-to-listen` | (수신 준비 완료 신호; 설명 PDF 미기재) |
| `load-project-report` | 프로젝트 최초 로드 상태 보고 |
| `change-project-report` | 프로젝트 변경 상태 보고 |
| `change-template-report` | 템플릿 변경 상태 보고 |
| `project-id-created` | 새로운 project-id가 생성됨 |
| `save-doc-report` | edicus doc이 저장을 시작하거나 끝낼 때 |
| `doc-changed` | edicus doc이 로드되거나 변경됨 |
| `page-changed` | page가 변경됨 |
| `var-added` | 외부 연동 아이템이 추가됨 |
| `var-deleted` | 외부 연동 아이템이 삭제됨 |
| `var-changed` | 외부 연동 아이템의 내용이 변경됨 |
| `state-history` | 히스토리 상태를 보고함 |
| `error-report` | 중요 오류 사항을 전달 |
| `close` | edicus를 닫아줄 것을 요청 |

> grep 식별자 표기: 코드에서는 `action === "load-project-report"` 처럼 정확한 케밥 문자열로 매칭.

---

## 2. info 페이로드 (action별)

### 2.1 info@`load-project-report` & `change-project-report` (`PDF p.20`)

| Key | Type | 설명 |
|-----|------|------|
| `status` | string | start / end / denied / error |
| `error` | any | status가 error일 때 존재 |
| `project_id` | string | 프로젝트 id |

### 2.2 info@`change-template-report` (`PDF p.20`)

| Key | Type | 설명 |
|-----|------|------|
| `status` | string | start / end / denied / error |
| `error` | any | status가 error일 때 존재 |
| `psCode` | string | 템플릿 psCode |
| `template_uri` | string | 템플릿 리소스 uri |

### 2.3 info@`project-id-created` (`PDF p.20`)

| Key | Type | 설명 |
|-----|------|------|
| `project_id` | string | 생성된 프로젝트 id |

### 2.4 info@`error-report` (`PDF p.20`)

| Key | Type | 설명 |
|-----|------|------|
| `error` | string | error 코드. `load-prodinfo-failed`(pscode로 prodinfo 못 얻음) / `load-template-failed`(template_uri로 템플릿 못 얻음) |

### 2.5 info@`doc-changed` (`PDF p.20`)

| Key | Type | 설명 |
|-----|------|------|
| `ps_code` | string | 상품의 ps_code (product_size_code) |
| `page_count` | number | 로드된 edicus doc의 page 갯수 |
| `vdp_catalog` | (미기재) | variable data 정보 |

### 2.6 info@`save-doc-report` (`PDF p.21`)

| Key | Type | 설명 |
|-----|------|------|
| `status` | string | start / end / error |
| `docInfo` | any | 프로젝트 및 문서 정보 (일반상품/사진인화 상세는 아래) |
| `error` | any | status가 error일 때 존재 |

#### docInfo@`start` & `error`@save-doc-report (`PDF p.21`)

| Key | Type | 설명 |
|-----|------|------|
| `projectID` | string | project id |

#### docInfo@`end`@save-doc-report — 일반상품 (`PDF p.21-22`)

| Key | Type | 설명 |
|-----|------|------|
| `projectID` | string | project id |
| `docRevision` | number | document version 정보 |
| `totalPageCount` | number | 전체 page 갯수 |
| `contentPageCount` | number | cover 제외 content page 갯수 |
| `totalCellCount` | number | 전체 사진틀 갯수 |
| `emptyCellCount` | number | 빈 사진틀 갯수 |
| `lowResCellCount` | number | 저해상도 사진 포함한 사진틀 갯수 |
| `vdpList` | varInfo | vdp 리스트 |
| `layerDetect` | any | (설명 미기재) |
| `tnUrlList` | Array | preview thumbnail url 리스트 |
| `usedFontsList` | Array | 사용된 폰트 리스트 ([{ familyName, typeStyleName, fullName, issue, url }]) |
| `unresolvedFontsList` | Array | 저장 시 미등록 폰트 사용분 ([{ page_index, fonts_unresolved:[...], text_raw }]); 없으면 key 자체 없음 |
| `caleandarInfo` | Object | year/month만 유효, 나머지 변경 가능 ({ year, month, index_range, options, categories }) |

#### docInfo@`end`@save-doc-report — 사진인화 (`PDF p.22-23`)

| Key | Type | 설명 |
|-----|------|------|
| `projectID` | string | project id |
| `docRevision` | number | document version 정보 |
| `totalPrintCount` | number | 사진의 갯수 |
| `totalOrderCount` | number | 각 사진 개별 수량 합산 |
| `totalLoadingCount` | number | (설명 미기재) |
| `paperType` | string | "matte" 또는 "gloss" |
| `lowResPrintCount` | number | 저해상도 이미지 갯수 |
| `tnUrlList` | Array | preview thumbnail url 리스트 |
| `prints` | Array | 사진 정보 (예: [{ orderCount:1 }, { orderCount:3 }, ...]) |

### 2.7 info@`page-changed` (`PDF p.23`)

| Key | Type | 설명 |
|-----|------|------|
| `page_index` | number | 선택된 page 인덱스 번호 |
| `page_type` | string | 선택된 page 종류, 기본 'content' |

### 2.8 info@`state-history` (`PDF p.23`)

| Key | Type | 설명 |
|-----|------|------|
| `can_undo` | boolean | Undo 가능여부 (Undo 버튼 enable/disable 대응 필요) |
| `can_redo` | boolean | Redo 가능여부 (Redo 버튼 enable/disable 대응 필요) |
| `doc_dirty` | boolean | Save 가능여부 (Save 버튼 enable/disable 대응 필요) |

### 2.9 info@`var-added` & `var-deleted` & `var-changed` (`PDF p.23-24`)

| Key | Type | 설명 |
|-----|------|------|
| `item_type` | string | item type |
| `path` | itemPath | editor 내에서 item address (`{ item_id, page_id, page_index }`) |
| `variable` | varInfo | variable 정보 (`{ type, id, title, group_id, extra }`) |
| `data` | object | `{ text: string }` |
| `state` | object | `{ enable: boolean }` |

**외부 연동 텍스트 처리 규칙** (`PDF p.24`):
- `var-added` 수신 → text-field 생성. var-added info 내용을 그대로 보관.
- `var-deleted` 수신 → 해당 item_id와 연결된 text-field 삭제.
- `var-changed` 수신 → 해당 item_id와 연결된 text-field 찾음:
  - `info.data` 존재 시 `info.data.text`로 value 갱신.
  - `info.state` 존재 시 `info.state.enable`에 대응해 text-field 활성화/비활성화.

---

## 3. Preview 모드 콜백 (별도) (`PDF p.28-29`)

- `open_preview` callback에서 back button 클릭 시: `data = { type:"from-edicus-preview", action:"close" }` (패시브 콜백과 별개 type). → `editor.destroy()`로 제거.

---

## 4. 토큰 만료 시 흐름 (콜백 연계, `PDF p.6-9`)

create_project/open_project callback이 `{ type:"from-edicus", action:"request-user-token" }`를 보내면 → 고객사 서버에서 새 토큰 발급 → `editor.post_to_editor("send-user-token", { token })` 전송. (Server API: `POST /api/auth/token`)

---

## 미상 / 정직 표기

- `ready-to-listen` action의 info/의미: **모름(PDF 미기재)** (post_to_editor request-feature를 ready-to-listen 직후 보낸다는 언급만, `PDF p.15`).
- `change-project-report` info 표는 load-project-report와 공유(`PDF p.20`).
- `doc-changed`의 `vdp_catalog`, save-doc-report의 `layerDetect`/`totalLoadingCount` 세부 구조: **모름(PDF 미기재)**.
- callback의 `err` 인자 사용 규약(패시브 콜백에서): PDF는 `function(err, data)` 시그니처와 "성공 시 err null"만 명시 (`PDF p.9`).
