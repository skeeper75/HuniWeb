# widget-architecture.md — RedPrinting 위젯 3계층 구조 + 전체 플로우

> 큐레이션가: hwf-flow-curator · 권위=역공학 자료(읽기전용)
> 모든 사실에 `파일:라인` 근거. 미상은 `unknowns-board.md` 참조.
> 핵심 축: "각 상품군이 파일 업로드와 에디쿠스(Edicus)를 어떻게 연결하는가"

---

## 0. 한눈에 — 3계층

```
[계층 1] 브릿지/로더 (productRedWidgetSDK.js)
   └ 상품 페이지에서 widget.js + RedEditorSDK.min.js 를 로드, SDK 초기화 호출
        │
        ▼
[계층 2] 주문 위젯 (widget.js) — Vue 3 + Pinia, Shadow DOM(open)
   └ RedWidgetSDK 클래스 → Shadow DOM 생성 → Vue 앱 마운트
   └ Pinia 스토어 5개: config / product / order / exterior / acc-order
   └ 옵션 UI 렌더 → 가격 계산 → 업로드/에디터 분기 → 주문 가능 검증
        │   (exterior.uploadType === "editor" 일 때)
        ▼
[계층 3] 에디쿠스 에디터 (RedEditorSDK.min.js v6.6.48) — iframe
   └ EditorBridge: iframe postMessage 양방향 통신
   └ ApiClient: makers.redprinting.net (Edicus Firebase 백엔드)
   └ createProject → 라이프사이클 이벤트 → save-doc-report → goto-cart
```

근거:
- 3계층 구분: `raw/widget_monitor/monitor_report.md:10-18` (새 위젯=Vue3+Pinia, `productRedWidgetSDK.js`+`widget.js`, Shadow DOM open mode), `docs/reversing/red_reverse_engineer/final/역공학_최종_보고서.md:36-59` (widget.js / RedEditorSDK.min.js 모듈 구조도).
- 계층 1 명칭 `productRedWidgetSDK.js`: `raw/widget_monitor/monitor_report.md:14`. (※ 역공학 산출물은 `widget.js`만 디옵스했고 `productRedWidgetSDK.js` 자체 소스 라인 근거는 없음 → `unknowns-board.md` U-12 참조.)

---

## 1. 계층 2 — RedWidgetSDK 진입점 (widget.js)

### 1.1 SDK 인스턴스 생성·초기화
- `new RedWidgetSDK(clientKey)` — clientKey ∈ {`"red-pc"`,`"red-mobile"`}, 그 외는 throw.
  근거: `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_06_app_widget_sdk.js:30-42`, 허용값 `:936` (`ALLOWED_CLIENT_KEYS`).
- `sdk.init(initConfig, callbacks)` — `initConfig = {target, pdtCode, pttCode, locale="ko", member, deviceType="pc"}`.
  근거: `deob_06_app_widget_sdk.js:59-67`.
- 마운트 절차: `target` 요소에 `attachShadow({mode:"open"})` → `<div id="red-widget-root">` 생성 → Vue 앱 mount.
  근거: `deob_06_app_widget_sdk.js:71-76, 98`. Shadow DOM 구조 실측: `raw/widget_monitor/monitor_report.md:56-62`.
- Shadow DOM에 위젯 CSS 링크 주입: `https://d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/prod/widget.css`.
  근거: `deob_06_app_widget_sdk.js:98, 1389-1391`.
- 전역 노출: `window.RedWidgetSDK = RedWidgetSDK`.
  근거: `deob_06_app_widget_sdk.js:103`.

### 1.2 일반 제품 vs 부자재(ACC) 분기 (인스턴스 종류 결정)
- `isCommonProduct = !ACC_PRODUCT_CODES.has(productCode)`.
  - true → `CommonWidgetComponent` 마운트 + `CommonWidgetInstance` 반환.
  - false → `AccWidgetComponent` 마운트 + `AccWidgetInstance` 반환.
  근거: `deob_06_app_widget_sdk.js:79-80, 98`.
- `ACC_PRODUCT_CODES = {GSSBMTL, GSSBSTP, GSSBACM}`.
  근거: `deob_06_app_widget_sdk.js:939`.
- 일반 제품만 `editorData = reactive({editingYn:"N"})` 를 provide (부자재는 에디터 미사용 신호).
  근거: `deob_06_app_widget_sdk.js:89-94`.

### 1.3 Pinia 스토어 5개
| 스토어 | id | 핵심 상태 | 근거 (deob_06_app_widget_sdk.js) |
|--------|-----|----------|------|
| config | `config` | `locale` | :717-727 |
| product | `product` | `baseInfo` (product_option, product_data) | :754-769 |
| order | `order` | `orderData` (+ setOrderData가 `callbacks.onOptionChange({type:"COMMON"})` 호출) | :822-842 |
| exterior | `exterior` | `uploadType`(키별), `editorData`(키별), `payloadForEditorConfig` | :780-814 |
| acc-order | `acc-order` | `orderData` (+ setOrderData가 `onOptionChange({type:"ACC"})`) | :850-869 |

- `exterior.uploadType` 기본값 = `{default:"editor"}` (즉 기본 탭은 에디터).
  근거: `deob_06_app_widget_sdk.js:781-783`.
- `isAfterEdit(key)` = `uploadType[key]==="editor" && editorData[key].editingYn==="Y"`.
  근거: `deob_06_app_widget_sdk.js:810`.
- (역공학 보고서는 5스토어, monitor_report 실측은 4스토어로 기재 — acc-order는 부자재 전용이라 일반 상품 캡처에 미노출. 근거: `역공학_최종_보고서.md:118-127` vs `monitor_report.md:174-184`.)

---

## 2. 초기화 → 옵션 → 가격 전체 데이터 흐름

```
[서버] GET /ko/product/get_digital_product_info?pdt_cod=<code>
        → useProductStore.baseInfo (product_option.option{ item_gbn, price_gbn, skinInfo... }, product_data)
                │
        [사용자 옵션 변경] → useOrderStore.setOrderData(orderData, summary)
                │            (sizeInfo / dosuInfo / meterialInfo / quantityInfo / pcsInfo / fileUploadInfo)
                │            → callbacks.onOptionChange 자동 호출
                ▼
        POST /ko/product_price/get_ajax_price_vTmpl
             body: { dataJson: { ORD_INFO:[...], PCS_INFO:[...], price_gbn, mb_cust_cod } }
                │
                ▼
        priceCalc.result.result_sum (PRICE/PRICE_VAT/PRICE_MALL/ORG_PRICE...) → UI (공급가/부가세/청구금액)
```

근거:
- 제품정보 API: `deob_05_app_api.js:1085-1110` (`fetchProductInfo`, `GET .../product/get_digital_product_info?pdt_cod=`), 응답 스키마 실측 `monitor_report.md:67-89`.
- 가격 API: `deob_05_app_api.js:1129-1154` (`fetchPriceCalculation`, `POST .../product_price/get_ajax_price_vTmpl`, body `{dataJson:...}`). 요청 분리구조 `ORD_INFO`/`PCS_INFO`: `05_code_pattern_transfer_analysis.md:38-42`. 책자/굿즈 request/response 실측: `monitor_report.md:91-160`.
- 데이터 흐름 도식: `역공학_최종_보고서.md:70-88`.
- 옵션 변경→가격 디바운스(설계 권고): `05_code_pattern_transfer_analysis.md:32-37` (Red는 `deob_05_app_api.js:329-420` Lodash debounce 사용).

### 2.1 가격 응답 구조 (공통 + 책자 전용)
- 공통: `result[]`(공정별), `result_sum`(합계). 책자만 `book_info`, `seneca_info` 추가.
  근거: `monitor_report.md:142-160`.
- 가격 합계 표시 로직(할인/몰가 우선순위): `deob_06_app_widget_sdk.js:1273-1285` (CommonWidgetInstance), `:1336-1339` (Acc).

---

## 3. 업로드/에디터 분기 (계층 2 ↔ 계층 3 경계)

> 상세 시퀀스는 `path-branch-spec.md`. 여기서는 구조적 위치만.

- **통합 업로더 컴포넌트(Uploader)**: PDF 탭 / 에디터 탭 토글. PDF 탭=S3Uploader, 에디터 탭=RedEditorSDK 연동 + 무료 템플릿 갤러리.
  근거: `deob_06_app_widget_sdk.js:564-590` (Uploader 컴포넌트 주석), 에디터 설정 조회 `POST /api/editor/config/{KOI|RP}` `:575-578`.
- **PDF 경로(S3Uploader)**: 파일선택 → 검증(확장자/1GB) → `POST /api/aws/presigned-url`(presigned URL+새파일명) → `PUT presignedURL`(S3 직접 업로드) → emit.
  근거: `deob_06_app_widget_sdk.js:542-561` (S3Uploader 주석, 5단계 업로드 플로우).
  (※ 스킬 기재 `/api/aws/presigned`와 디옵스 주석 `/api/aws/presigned-url` 표기 차이 — `unknowns-board.md` U-3.)
- **에디터 경로(RedEditorSDK)**: 계층 3에서 iframe 생성·postMessage 통신.
  근거: `editor_sdk_method_catalog.md:306-313` (EditorBridge: iframe·postMessage; ApiClient: makers.redprinting.net).
- **편집 결과 반영**: `CommonWidgetInstance.setEditorData(editorResultData)` → KOI/RP 타입별 처리 → `exterior.setEditorData`.
  근거: `deob_06_app_widget_sdk.js:1138-1147`.
- **UI 실측(GSTGMIC)**: Shadow Root 안 버튼 `upload-btn "PDF"` / `upload-btn.active "에디터"`(탭) / `upload-btn.edit "편집하기"`(실제 에디터 실행).
  근거: `raw/widget_monitor/editor_api_analysis.md:158-170`.

---

## 4. 계층 3 — Edicus 에디터 (RedEditorSDK)

- 버전 `6.6.48`. SDK 클래스 45 메서드, EditorBridge(iframe·postMessage), ApiClient(makers.redprinting.net, `red-editor-token` 헤더, 50분 자동 갱신).
  근거: `editor_sdk_method_catalog.md:1-5, 304-313`.
- iframe Base URL: 운영 `https://edicusbase.firebaseapp.com`, 개발 `https://edicus-stage.firebaseapp.com`.
  근거: `editor_sdk_method_catalog.md:306-308`.
- Edicus 백엔드 도메인 `makers.redprinting.net`, SDK CDN `d2vgy67dgpwzce.cloudfront.net`.
  근거: `editor_api_analysis.md:10-16`.
- 에디터 초기화 API 시퀀스(실측): `POST /token`(refreshToken) → `POST /editor target=issueUserToken`(Firebase JWT, 유효 1h) → `target=getProductInfo`(RP코드→Edicus코드 변환, `editor: template|upload`, `division: red_widget`=KOI passive) → `GET /v1/templates/{edicusCode}`.
  근거: `editor_api_analysis.md:19-94`.
- 주문 제출 타깃: ApiClient `call()`의 target 중 `tentativeOrder`/`definitiveOrder`/`isReadyToOrder`/`cancelOrder`.
  근거: `deob_editor_sdk.js:2784`.
- 라이프사이클: `save-doc-report`(end) → `goto-cart`/`close` 시 `isReadyToOrder` 호출.
  근거: `deob_editor_sdk.js:11385-11398`.

> [HARD·미상] 위젯이 장바구니/주문을 서버에 최종 제출하는 함수 `sdkCreatePot`은 **디옵스 원본 소스(deob_*)에 라인 근거 없음** — HTML 분석 리포트(`RedPrinting_SDK_Deep_Analysis_Report.html` 2회·`RedPrinting_Widget_Analysis_Report.html` 1회)에만 등장(=2차 해설, 원본 소스 아님). `unknowns-board.md` U-1 참조. Edicus 측 최종 주문은 `definitiveOrder` target(`deob_editor_sdk.js:2784`)으로 확인됨.

---

## 5. 주문 가능 검증 (canOrder) — 분기 종합 지점

`CommonWidgetInstance.canOrder()`가 item_gbn·uploadType별로 파일/에디터 충족을 검증한다(분기 결정요인을 코드로 직접 확인 가능).
근거: `deob_06_app_widget_sdk.js:1155-1215`.
- 공통 선검사: `order_yn==="N"`→주문불가, 사이즈 validation, `priceCalc.result.retCode!==200 || !result_sum.PRICE`→주문불가-가격. (:1161-1167)
- `item_gbn==="book2025_item"`(책자): `uploadType`을 키별(inner/default=표지) 순회 — `editor`면 `isAfterEdit(key)`, `pdf`면 해당 파일 슬롯 존재 검사 + 내지/표지 파일명 중복 검사. (:1174-1189)
- `uploadType.default==="pdf"`: `fileUploadInfo[0]` 필수. clothes+실크인쇄(PTP_SLK)면 팬톤 필수. (:1192-1195)
- `item_gbn==="clothes2025_item"` & 인쇄없음(printType.COD 없음): 통과. (:1198-1200)
- `uploadType.default==="editor"` & `!isAfterEdit()` & `dosuInfo.COD!=="SID_X"`(인쇄없음 제외): 에디터 편집 필요. (:1203)

→ **분기 결정요인 = `item_gbn`(상품유형) + `exterior.uploadType`(키별 editor/pdf)**. `path-branch-spec.md`에 시퀀스로 전개.
