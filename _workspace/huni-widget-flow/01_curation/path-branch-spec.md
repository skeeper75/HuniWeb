# path-branch-spec.md — 파일업로드 경로 vs 에디쿠스 경로 분기 명세

> 큐레이션가: hwf-flow-curator · 권위=역공학 자료 · 미상은 명시(`unknowns-board.md`)
> 핵심 directive: "각 상품군이 파일 업로드와 에디쿠스를 어떻게 연결하는가"

---

## 0. 분기 결정요인 (확인된 사실)

| 결정요인 | 값 | 효과 | 근거 |
|----------|-----|------|------|
| `exterior.uploadType[key]` | `"editor"` \| `"pdf"` | 업로더 탭 = 에디쿠스 경로 vs PDF 경로 | `deob_06_app_widget_sdk.js:781-787` |
| `uploadType` 기본값 | `{default:"editor"}` | 위젯 초기 탭은 **에디터** | `deob_06_app_widget_sdk.js:781-783` |
| 업로더 키 | `"default"`(표지) / `"inner"`(내지) | 책자는 내지·표지 업로더 2개를 독립 분기 | `deob_06_app_widget_sdk.js:1174-1182` |
| `item_gbn` | `book2025_item` / `vDigital_item` / `clothes2025_item` | canOrder 검증 경로 분기 | `deob_06_app_widget_sdk.js:1169-1203` |
| Edicus `editor` 필드 | `"template"` / `"upload"` | Edicus 상품이 템플릿형/업로드형 | `editor_api_analysis.md:66, 102` |

> ※ "uploadType를 editor/pdf로 자동 vs 수동 결정하는 규칙"(어떤 상품은 PDF 탭만, 어떤 상품은 둘 다인지를 서버가 어떻게 지시하는가)의 **단일 코드 라인 근거는 미확인** — `unknowns-board.md` U-2.
> Uploader가 PDF/에디터 둘 다 노출할지는 `uploadConfig {editor, pdf, token}`(buildUploadConfig)에 의존하나 그 설정값 출처 라인은 디옵스 본문에 생략됨(`deob_06_app_widget_sdk.js:580-590, 612-622`).

---

## 1. 파일 업로드(PDF) 경로 — S3 presigned

```
사용자: 업로더 "PDF" 탭 선택 → exterior.setUploadType("pdf", key)
   │ 근거: deob_06_app_widget_sdk.js:785-787
파일 선택(드래그&드롭/파일선택기)
   │
파일 검증: 확장자(기본 application/pdf), 크기 ≤ 1GB
   │ 근거: deob_06_app_widget_sdk.js:542-560 (S3Uploader 주석), 1GB 에러문구 deob_05_app_api.js:1412
   ▼
POST /api/aws/presigned-url   (presigned URL + 새 파일명 획득)
   │ 근거: deob_06_app_widget_sdk.js:552-554
   ▼
PUT <presignedURL>            (S3 직접 업로드)
   │ 근거: deob_06_app_widget_sdk.js:554-555
   ▼
emit upload → order.fileUploadInfo 갱신 (책자: [0]=내지, [1]=표지)
   │ 근거: deob_06_app_widget_sdk.js:558-559, 슬롯 인덱스 1180-1181
   ▼
(선택) POST {locale}/product/s3GetObjectJson  → 업로드 파일 메타 조회
   │ 근거: deob_05_app_api.js:1167-1184 (fetchS3FileInfo)
   ▼
주문 시: fileUploadInfo가 주문 페이로드에 포함 (canOrder가 파일 존재 검증)
   │ 근거: deob_06_app_widget_sdk.js:1178-1193
```

미상:
- presigned URL 발급 정확한 호스트(widget-api.redprinting.co.kr 추정 vs 상대경로) 및 유효기간 → `unknowns-board.md` U-3, U-4.
- 주문 최종 제출 시 s3FileUrl/파일정보를 어떤 엔드포인트에 어떤 필드로 제출하는지 라인 근거 없음 → U-5.

---

## 2. 에디쿠스(Edicus) 경로 — RedEditorSDK iframe

### 2.1 진입 (위젯 → 에디터 오픈)
```
사용자: 업로더 "에디터" 탭(기본 active) → "편집하기" 버튼 클릭
   │ UI 실측 근거: editor_api_analysis.md:160-170
RedEditorSDK 인증·초기화 (makers.redprinting.net)
   │ POST /token {type:"verify"} → refreshToken         editor_api_analysis.md:22-30
   │ POST /editor target=issueUserToken (uid=base64 RP userId) → Firebase JWT(1h)  :33-46
   │ POST /editor target=getProductInfo pdtCode=<RP> → {productCode(Edicus), editor:"template"|"upload", division:"red_widget"(KOI passive)}  :48-69
   │ GET /v1/templates/{edicusCode}                      :71-93
   ▼
RedEditorSDK.createProject(editorConfig{selector,psCode,title,templateUrl,...}, projectOptions)
   │ 근거: editor_sdk_method_catalog.md:78-94 (createProject)
   │ → EditorBridge가 iframe 생성, URL 구성, postMessage 통신 시작
   │   근거: editor_sdk_method_catalog.md:306-308
```

### 2.2 iframe postMessage 라이프사이클 (양방향)
```
init → ready-to-listen → doc-changed → project-id-created
     → save-doc-report:start → save-doc-report:end → goto-cart / close
```
- 라이프사이클 상태머신 정의: `raw/widget_monitor/SIMULATOR_GUIDE.md:35-40`.
- `save-doc-report`(status="end") → 저장 페이로드 `{message, projectId, data{...mode,deviceTarget}}` 구성 후, `close`/`goto-cart` action이면 `isReadyToOrder(projectID)` 호출.
  근거: `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_editor_sdk.js:11385-11398`.
- SDK가 수신 처리하는 22개 이벤트(`on(eventType,cb)`): create, close, load, change, save, select, historyState, historyLabel, promoReport, error, imagePool, previewClose, fontList, changeMode, pageCountChange, pageChange, groupCaption, imposeOpened, printCountChange, customTabSelectionChange, docReport, all.
  근거: `editor_sdk_method_catalog.md:233-242`; 이벤트 분기 코드 `deob_editor_sdk.js:11463-11470`.
- `goto-cart` 페이로드(에디터 완료 시): `{projectID, tnUrlList, totalPageCount}`.
  근거: `SIMULATOR_GUIDE.md:41`. (deob 측 `goto-cart` action 처리: `deob_editor_sdk.js:11393`.)
- 실측 이벤트 발생 확인(GSTGMIC): `doc-changed`, `project-id-created`, `save-doc-report`, `goto-cart`, `from-edicus`/`to-edicus` 메시지 존재. `ready-to-listen` 문자열은 해당 캡처에 미출현(0회) — 라이프사이클 라벨 정의는 SIMULATOR_GUIDE에만.
  근거: `raw/widget_monitor/editor_monitor_GSTGMIC.json` (이벤트 카운트 실측).

### 2.3 복귀 (에디터 → 위젯)
```
에디터 완료 → goto-cart/close 메시지 → 위젯 CommonWidgetInstance.setEditorData(editorResultData)
   │ KOI 타입: processKoiEditorData / RP 타입: processRpEditorData → exterior.setEditorData(key)
   │ 근거: deob_06_app_widget_sdk.js:1138-1147
   ▼
isAfterEdit(key)=true (uploadType==="editor" && editingYn==="Y") → canOrder 통과 조건 충족
   │ 근거: deob_06_app_widget_sdk.js:810, 1177, 1203
   ▼
주문 가능 → (위젯 호스트가 주문/장바구니 제출)
```

미상:
- KOI vs RP 에디터 타입을 무엇이 결정하는지(`division: red_widget`=KOI passive 신호는 있으나 RP 타입 분기 라인 근거 부족) → U-6.
- `createProject` projectOptions(calendarConfig/customTabInfo 등)를 상품군별로 어떻게 채우는지 → U-7.

---

## 3. 상품유형(item_gbn)별 업로드/에디터 연결 (canOrder 기준)

| item_gbn | 업로드 슬롯 | 에디터 | 핵심 분기 | 근거(deob_06_app_widget_sdk.js) |
|----------|------------|--------|----------|------|
| `book2025_item` (책자) | 내지(inner)+표지(default) **각각** PDF 또는 에디터 | 양쪽 가능 | uploadType를 키별 순회, PDF면 파일슬롯/파일명중복 검사 | :1174-1189 |
| `vDigital_item` (굿즈 GS / 아크릴 AC) | default 1슬롯 | 가능 | uploadType.default editor/pdf, editor면 isAfterEdit, `dosuInfo.COD==="SID_X"`(인쇄없음)는 에디터 불요 | :1192, 1203 |
| `clothes2025_item` (의류) | default | 조건부 | 인쇄없음(printType.COD 없음)이면 통과, 실크인쇄(PTP_SLK)면 팬톤 필수 | :1194, 1198-1200 |
| (부자재 ACC: GSSBMTL/GSSBSTP/GSSBACM) | 없음 | 없음 | AccWidgetInstance.canOrder는 subMtrlInfo+가격만 검증 | :1359-1375 |

- price_gbn 매핑(실측): 책자=`book2025_price`, 굿즈 GSTGMIC=`tiered_price`, 아크릴 ACNTHAP=`vTmpl_price`.
  근거: 책자/GSTGMIC `monitor_report.md:166-170` + `cascade_captures/PRBKORD_cascade.json`/`GSTGMIC_cascade.json`; ACNTHAP `cascade_captures/ACNTHAP_cascade.json`.
  > ⚠ 불일치: `monitor_report.md:170`은 AC를 `tiered_price`로 적었으나 실제 ACNTHAP 캡처는 `vTmpl_price`. → 캡처 권위 채택, `unknowns-board.md` U-8.

---

## 4. "book2025_item=양쪽 / vDigital_item=에디터전용" 명제 검증

- 스킬/태스크 가설: book2025_item=업로드+에디터 둘다, vDigital_item=에디터 전용.
- **역공학 코드 근거로 확인되는 것**: 두 item_gbn 모두 `uploadType`에 `"pdf"`와 `"editor"` 분기가 존재(`:1178-1203`) → **vDigital_item도 PDF 업로드 경로가 코드상 존재**(canOrder `uploadType.default==="pdf"` 처리 `:1192`). 따라서 "vDigital_item=에디터 전용"은 코드 레벨에서 단정 불가.
- 상품별로 PDF/에디터 둘 다 보일지(또는 한쪽만)는 `uploadConfig{editor,pdf}` 설정에 달려 있고 그 출처 라인 근거는 없음 → **상품 단위 가용성은 "추정/모름"으로 둠**(`product-path-matrix.csv`·`unknowns-board.md` U-2).
