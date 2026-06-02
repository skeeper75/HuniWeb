# 위젯 런타임 동작 구조 (라이브 관찰 기반)

> 파이프라인 ② hw-runtime-analyst 산출물. `localhost:3001` 라이브 테스트베드 실구동으로 관찰.
> 근거 표기: `[라이브 관찰]` = 본 세션 Playwright 헤드리스 실구동 캡처 / `[정적+라이브]` = Phase 1 캡처 재확인 / `[정적 분석]` = deob 소스 / `[추정]` = 미관찰 추론.
> 라이브 캡처 원본: `02_analysis/captures/runtime_capture_{GSTGMIC,PRBKYPR}.json` (토큰·서명 REDACTED).
> 라이브 세션: 2026-06-02, 토큰 VALID, 세션쿠키 14개.

---

## 0. 본 세션 라이브 관찰 요약 [라이브 관찰]

| 흐름 | 관찰 결과 | 캡처 |
|------|----------|------|
| 초기화 | 상품선택 → `get_digital_product_info` 200 → 위젯 마운트 → 초기 가격 1회 | runtime_capture_*.json network |
| 옵션변경→가격재계산 | 옵션 변경 후 ~360ms 뒤 `get_ajax_price_vTmpl` POST 200 (디바운스) | timing.optionSettleMs |
| **에디터 라이프사이클(잔존#1)** | **6 from-edicus 이벤트 실시간 캡처** — load-project-report→ready-to-listen→doc-changed→request-prod-info→project-id-created | editor.eventTimeline |
| 스토어 구조 | 책자=config/product/order/exterior 4스토어, order.orderData에 표지/내지 분리 + exterior.uploadType | storeAfterOption |

**테스트베드 복구 조치 [라이브 관찰]**: `widget.js`/`RedEditorSDK.min.js`/`widget.css` 심볼릭링크가 깨져(404, target=`raw/red_reverse_engineer/00_raw` 부재) 위젯 미마운트 상태였음. 실제 자산은 `docs/reversing/red_reverse_engineer/00_raw/`로 이동. 심링크 재지정 후 SDK 정상 로드(RedWidgetSDK/RedEditorSDK = function, 콘솔 에러 0)·위젯 마운트·에디터 구동 확인. 이 조치로 테스트베드가 다시 동작 검증됨.

---

## 1. 초기화 흐름 [라이브 관찰]

상품 클릭 시점 기준 관찰된 시퀀스 (GSTGMIC 기준, +상대시각):

```
+0ms     상품 선택 (host: data-code 클릭 → sdkInit/createWidget)
+~280ms  GET /rp-api/ko/product/get_digital_product_info?pdt_cod=GSTGMIC   [REQ]
+~830ms  └─ 200 (product_data 16~18 데이터셋)                              [RES, ~550ms 소요]
         → ProductStore.baseInfo 적재 + Shadow DOM 위젯 마운트(#redWidgetSdk)
+~1300ms POST /rp-api/ko/product_price/get_ajax_price_vTmpl  (초기 기본옵션 가격)  [REQ]
+~1700ms └─ 200 (result_sum 표시)                                          [RES]
```

- 초기화 총 소요(상품선택→가격표시 첫 사이클): **~4.6초** (`timing.initDurationMs` GSTGMIC 4621ms / PRBKYPR 4582ms). 대부분 위젯 렌더·Edicus SDK 비동기 로드 포함.
- 위젯은 마운트 직후 **기본 선택 옵션으로 가격 1회 자동 호출** — 사용자 입력 없이도 가격 표시. [라이브 관찰: product_info 직후 price POST]
- 스토어 초기 키: 책자/굿즈 모두 `config, product, order, exterior` 4개로 관찰됨(부자재 `acc-order`는 별 인스턴스 — 본 세션 미구동). [라이브 관찰]

## 2. 옵션 선택 → 가격 재계산 흐름 [라이브 관찰]

옵션(select) 1개 변경을 주입하고 관찰:

```
+0ms     사용자 옵션 변경 (select change 이벤트 → 위젯 핸들러)
         → OrderStore.orderData 즉시 갱신 (sizeInfo/dosuInfo/meterialInfo/pcsInfo/quantityInfo)
+~360ms  POST get_ajax_price_vTmpl (디바운스 후 1회)                        [REQ]
+~560ms  └─ 200 → result_sum 갱신 → 가격 표시 업데이트                     [RES]
```

- **옵션변경 → 가격REQ 지연 ~360ms** (GSTGMIC: optionChangeAt 6334ms, priceREQ 6697ms = 363ms / PRBKYPR: 6621→6982 = 361ms). Phase 1의 정적 디바운스 300ms + 처리 오버헤드와 일치. [라이브 관찰 — 디바운스 입증]
- 연속 변경 시 마지막 1회만 발사되는 디바운스 패턴은 정적 소스(`fetchPriceCalculation`)에서 확정, 본 세션은 단일 변경이라 1 REQ만 관찰. [정적+라이브]
- 가격 요청 본문은 스토어 `order.orderData.priceCalc.params`에 그대로 보관됨 → 위젯이 스토어에서 ORD_INFO/PCS_INFO를 조립해 호출. [라이브 관찰]

### 라이브 관찰된 가격 요청 페이로드 (PRBKYPR, priceCalc.params) [라이브 관찰]
```json
{ "ORD_INFO": [{ "PDT_CD":"PRBKYPR", "CUT_WDT":182,"CUT_HGH":257, "WRK_WDT":192,"WRK_HGH":267,
   "PRN_CNT":30, "PAGE_CNT":10, "CVR_CLR_CNT":4, "INN_CLR_CNT":8,
   "CVR_MTRL_CD":"RXART300", "INN_MTRL_CD":"RXYWM080" }],
  "PCS_INFO": [ {"PCS_COD":"CUT_DFT","PCS_DTL_COD":"DFXXX"}, {"PCS_COD":"PER_DFT","PCS_DTL_COD":"BPLFT"},
                {"PCS_COD":"CVR_SFT","PCS_DTL_COD":"DFXXX"}, {"PCS_COD":"COT_DFT","PCS_DTL_COD":"TCMAS"},
                {"PCS_COD":"BIND_DIRECTION", ...} ] }
```
> Phase 1 가격계약(`price-engine-reversed.md`)을 라이브 재확인. 표지(CVR_*)/내지(INN_*) 분리, PCS_INFO 배열 확정. 응답 본문(result_sum 3단 워터폴)은 Phase 1 `captures/price_*.json` 8조합에 풀 캡처되어 있어 재사용. [정적+라이브]

## 3. 스토어 상태 구조 (책자 PRBKYPR, 라이브) [라이브 관찰]

`order.orderData` 키 (라이브 스냅샷):
```
sizeInfo, dosuInfo, meterialInfo,           ← 표지(default) 규격·도수·자재
inner_dosuInfo, inner_meterialInfo,         ← 내지(inner) 도수·자재 (책자 전용)
pcsInfo[],                                  ← 선택 후가공 배열
quantityInfo {ordCnt, prnCnt},              ← 수량(권수)·내지페이지수
priceCalc {params, ...}                     ← 최종 가격 요청 페이로드 + 결과
```
- **표지/내지 이원화 확정**: `meterialInfo`(RXART300 아트지300g) + `inner_meterialInfo`(RXYWM080 윤전백색모조80g) 동시 존재. 굿즈(GSTGMIC) order에는 `inner_*` 없음 → 단일 면. Phase 1 가설을 라이브 입증. [라이브 관찰]
- `quantityInfo = {ordCnt:30, prnCnt:10}` — ordCnt=주문수량(권), prnCnt=내지페이지수. (Phase 1의 PRN_CNT=수량/PAGE_CNT=페이지 매핑과 일치; 스토어 필드명은 ordCnt/prnCnt) [라이브 관찰]

### exterior 스토어 — 업로드 방식 분기 [라이브 관찰, 신규 발견]
```json
"exterior": {
  "uploadType": { "default": "editor", "inner": "pdf" },   // 표지=에디터, 내지=PDF
  "editorData": { "default": null },                        // 에디터 결과(projectID 등) 보관
  "payloadForEditorConfig": { "default": { lang_cod, pdt_cod, PDT_NM, sizeInfo, pcsInfo, ... } }
}
```
- **핵심 동작 발견**: 책자는 면(side)별로 업로드 수단이 다르다 — **표지(default)=Edicus 에디터, 내지(inner)=PDF 업로드**. `exterior.uploadType`이 면별 입력 UI를 분기. [라이브 관찰]
- `payloadForEditorConfig.default`는 표지 에디터를 열 때 `editor/config/KOI`로 보낼 페이로드를 미리 조립해 둔 것. [라이브 관찰]

## 4. 에디터 라이프사이클 — 실시간 메시지 타임라인 [라이브 관찰 — 잔존 #1 해소]

GSTGMIC "편집하기" 클릭 → Edicus iframe 생성 → 실제 `from-edicus` postMessage **6건 실시간 캡처** (편집하기 클릭 +기준):

```
[A] editor/config/KOI POST 200 (widget-api)         (편집하기 +1.5s)
    ├─ KOI config 응답: { mode:"NEW", type:"KOI",
    │     config:{locale,title,psCode:"Triangle_L@GSTGMIC",
    │             templateUrl:"gcs://.../3106075.json", resource_id:3106075, token:[JWT]},
    │     option:{ pluginCustomData:{ mtrlCode:"RXBVW300" } } }
[B] makers /token POST 200  (refreshToken)
[C] makers /editor POST 200 (Firebase JWT / getProductInfo)
[D] makers PUT /v1/template/{base64(templateUrl)}/hit 200
[E] iframe src = edicusbase.firebaseapp.com/ed#/editor_landing?cmd=create&token=[JWT]
[F] makers GET /v2/template/resource/{resource_id} → 500 (토큰 컨텍스트 의존, 직접경로 실패; iframe 내부는 정상)

──── 이후 from-edicus 메시지 (iframe → 호스트, origin=https://edicusbase.firebaseapp.com) ────
+0ms      from-edicus: load-project-report   info{ status:"start", edicus_user_id:null, project_id:null, ps_code:"Triangle_L@GSTGMIC" }
+93ms     from-edicus: ready-to-listen       info: null
+1409ms   from-edicus: doc-changed           info{ ps_code, page_count:1, template_uri:"gcs://...3106075.json", div:"red_widget", vdp_catalog:[] }
+1411ms   from-edicus: request-prod-info     info: {}        ← 에디터가 호스트에 상품정보 요청(deferred-param 핸드셰이크의 공개 신호)
+2092ms   from-edicus: load-project-report   info{ status:"end", edicus_user_id:"redp-redprinting", project_id:"-Ou6PlD74V7Treg6c86o", ps_code }
+2092ms   from-edicus: project-id-created    info{ project_id:"-Ou6PlD74V7Treg6c86o" }
```

### Phase 1 추정 vs 라이브 관찰 차이 (은폐 금지) [라이브 관찰]

| Phase 1 추정 단계 | 라이브 실제 관찰 | 비고 |
|------------------|-----------------|------|
| init | (관찰 안 됨 — 대신 `load-project-report:start`) | "init" 액션명은 미관찰. 실제 첫 신호는 `load-project-report` |
| ready-to-listen | ✅ `ready-to-listen` (info null) | 확정 |
| doc-changed | ✅ `doc-changed` (ps_code·page_count·template_uri·div·vdp_catalog) | 확정 + info 스키마 캡처 |
| (없음) | 🆕 `request-prod-info` (info {}) | **신규** — 에디터가 prod_info를 호스트에 요청. deferred-param 핸드셰이크의 공개 액션 |
| project-id-created | ✅ `project-id-created` (project_id) | 확정 + projectID 실값 캡처 |
| (없음) | 🆕 `load-project-report` (start/end 2회, project_id·edicus_user_id) | **신규** — 프로젝트 로드 보고. end에서 projectID·edicus_user_id 확정 |
| save-doc-report:start/end | (본 세션 미관찰 — 실제 편집·저장 미수행) | 저장 트리거 안 함. Phase 1 정적+핸들러 근거 유지 |
| goto-cart | (본 세션 미관찰 — 장바구니 미진행) | 동일 |
| close | (본 세션 미관찰) | 동일 |

> **결론**: 잔존 #1(에디터 iframe 실시간 메시지 타임라인)을 **라이브 해소**. create→ready→doc-changed→project-id-created 까지 실측. `save-doc-report`/`goto-cart`/`close`는 실제 저장·주문 액션을 트리거해야 발생하므로 본 세션(편집 미수행)에선 미발생 — Phase 1 정적+테스트베드 핸들러 근거를 유지하며 명시적으로 [부분]으로 표기.

### 에디터 진입 핵심 식별자 [라이브 관찰]
- `psCode = "Triangle_L@GSTGMIC"` — `{Edicus템플릿식별}@{RP상품코드}` 형식. 후니는 `{edicusPsCode}@{huniPdtCode}` 매핑 필요.
- `templateUrl = "gcs://template/partners/redp/res/template/3106075.json"` (GCS 경로), `resource_id = 3106075`.
- `pluginCustomData = { mtrlCode:"RXBVW300" }` — 선택 자재를 에디터에 전달(편집 캔버스 자재 반영).
- `div = "red_widget"` = KOI passive mode 식별자 (`editor_api_analysis.md` 확인).
- `project_id = "-Ou6PlD74V7Treg6c86o"` — Firebase pushID 형식(Edicus 프로젝트 키).

## 5. 업로드 흐름 [정적+라이브, Phase 1]

S3 presigned 업로드는 Phase 1에서 end-to-end 라이브 검증(`s3-upload-flow.md`). 본 세션 재구동 시 PDF 탭 미진입(에디터 흐름 집중)으로 추가 캡처 없음. exterior.uploadType의 `inner:"pdf"`가 내지 PDF 업로드 경로를 활성화함을 라이브 스토어로 재확인. [정적+라이브]

흐름 요약:
```
파일선택 → POST /widget-api/api/aws/presigned-url {file_name,pdt_cod,content_type}
        → {filename(UUID), presignedURL(60분만료)} → PUT S3 직접 → fileUploadInfo[]에 반영
        (fileUploadInfo[0]=내지, [1]=표지)
```

## 6. 주문 확정 흐름 [정적 분석]

`fn_order_able`(검증) → `sdkCreatePot`(주문데이터 조립) → 호스트 form submit. 본 세션 미구동(주문 진행 안 함). 에디터 결과는 `goto-cart` 수신 시 `{projectID, tnUrlList, totalPageCount, case}`로 주문데이터에 반영(index.html 호스트 핸들러 검증). [정적 + 테스트베드 핸들러]

## 7. 잔존 미검증 (은폐 금지)

- `save-doc-report` / `goto-cart` / `close` from-edicus 실시간 캡처 — 실제 캔버스 편집·저장·장바구니 액션 트리거 필요(자동화 헤드리스에서 Edicus UI 조작 복잡). Phase 1 정적+핸들러 근거 유지. [부분]
- 가격 응답 본문 본 세션 재캡처 — 프록시 로깅 미들웨어 경로 차이로 responseBody 빈 객체. Phase 1 `captures/price_*.json` 8조합 풀 응답 재사용(이미 검증). [폴백]
- 부자재(ACC, acc-order 스토어) 라이브 구동 — 본 세션 책자/굿즈만. [미관찰]
- PRBKYPR 에디터 실구동(본 세션 옵션변경 타이밍 영향으로 미열림) — GSTGMIC 에디터 흐름으로 프로토콜 확정, 책자도 동일 to/from-edicus 사용(정적). [부분]
