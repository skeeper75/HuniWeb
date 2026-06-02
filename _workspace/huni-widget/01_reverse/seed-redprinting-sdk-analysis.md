# RedPrinting SDK 분석 시드 (역공학 보강 출발점)

> 출처: `docs/reversing/RedPrinting_Widget_Analysis_Report.html` + `RedPrinting_SDK_Deep_Analysis_Report.html` (2026-03-18 분석) 정독 추출.
> 분석 대상: 트윈링 책자(PRBKORD) / 무선 책자(PRBKYPR) 상세 주문 페이지.
> 본 문서는 hw-reverse-engineer 의 라이브 보강 출발점. 모든 항목은 `[정적 분석]` 근거이며, 라이브 검증 시 `[라이브 검증]`으로 승격.

## 1. 3계층 아키텍처 (확정)

| 계층 | 파일 | 크기/특성 | 역할 |
|------|------|----------|------|
| 브릿지 | `productRedWidgetSDK.js` (자체 호스팅) | 33KB·834줄·비난독화·jQuery·fetch 0회 | 호스트 페이지 ↔ 위젯 글루. 20개 명명 함수 |
| 런타임 | `widget.js` (CloudFront) | 438KB·Vue3+Pinia·fetch 21회 | Shadow DOM 렌더·상태관리·API·가격계산 |
| 에디터 | `RedEditorSDK.min.js` (CloudFront) | 미니파이·45 메서드 | 표지 디자인 에디터 |

CDN: `d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/prod/{widget.js,widget.css}`, `/RedEditorSDK/js/RedEditorSDK.min.js`

→ **후니 시사점:** 후니도 동일하게 (얇은 임베드 로더) ↔ (React-in-Shadow-DOM 런타임) ↔ (Edicus 에디터) 3계층. 브릿지 함수가 호스트 통합 API 계약의 기준.

## 2. Shadow DOM 마운트 구조

```
form#product_form > aside.aside-rightWrap > section
  > div#redWidgetSdk  (Shadow Host)
      > #shadow-root(open)
          > link[widget.css]
          > div#red-widget-root  (Vue3 App mount + $pinia)
              > div.widget-container > div.widget-body
                  > 14 fieldset.option-row + 2 div.group-title(내지/표지)
```
통계: DOM 335요소, Vue 컴포넌트 488, fieldset 14, select 9, button 11, file input 1, img 14, 고유 CSS 클래스 42.

## 3. 위젯 옵션 14행 (책자 기준)

규격 → 수량 → [내지] 인쇄옵션·용지(이중 드롭다운 paper+weight)·내지장수(2~130)·내지업로드(PDF) → [표지] 인쇄옵션·용지·표지가이드·후가공선택·후가공상세·표지업로드(PDF/에디터).

- **9 select**: sizes, QTY, dosu(내지), paper(내지)+weight(내지), INNER_QTY, dosu(표지), paper(표지)+weight(표지)
- **Icon Checkbox/Radio**: 후가공(링제본/PVC커버/제본방향 토글) · 링색상(검정/흰/금/은 RIN_BLK·WHT·GLD·SLV) · 제본방향(좌철 BPLFT/상철 BPTOP)
- **업로드 2개소**: 내지(PDF 단일) · 표지(PDF/에디터 2탭) → S3 uploader + presigned

## 4. 핵심 API (4개)

| 엔드포인트 | 메서드 | 용도 |
|-----------|--------|------|
| `/ko/product/get_digital_product_info` | POST | 제품 옵션 전체(16~17 데이터셋) 초기 1회 |
| `/ko/product_price/get_ajax_price_vTmpl` | POST | 실시간 가격(옵션 변경 시마다) |
| `/api/aws/presigned` | POST | S3 업로드 presigned URL 발급 |
| `/api/editor/config/` (KOI) | - | 에디터 설정 조회 |

인증: **세션 쿠키만** (Authorization/Bearer/CSRF/API키 없음, 평문 JSON, HTTPS). base64ID="redprinting_nomember"는 단순 인코딩.

## 5. 가격 API 실측 계약 (★최고가치)

**요청** `POST /ko/product_price/get_ajax_price_vTmpl`:
```json
{ "dataJson": {
  "ORD_INFO": [{ "PDT_CD":"PRBKYPR", "CUT_WDT":182,"CUT_HGH":257, "WRK_WDT":192,"WRK_HGH":267,
    "PRN_CNT":50, "PAGE_CNT":10, "CVR_CLR_CNT":4, "INN_CLR_CNT":8,
    "CVR_MTRL_CD":"RXART300", "INN_MTRL_CD":"RXYWM080" }],
  "PCS_INFO": [ {"PCS_COD":"CUT_DFT","PCS_DTL_COD":"DFXXX"}, {"PCS_COD":"PER_DFT","PCS_DTL_COD":"BPLFT"},
    {"PCS_COD":"CVR_SFT","PCS_DTL_COD":"DFXXX"}, {"PCS_COD":"COT_DFT","PCS_DTL_COD":"TCMAS"},
    {"PCS_COD":"BIND_DIRECTION","PCS_DTL_COD":"BPLFT"} ],
  "price_gbn":"book2025_price", "mb_cust_cod":"10000000" } }
```
**응답**: `{ "retCode":200, "result":[ {"PCS_CD":"COT_DFT","PRICE":16800,"PRICE_VAT":1680,"PRICE_MALL":16800}, ... ] }` (공정별 가격 분해)

필드 사전: PDT_CD(제품), CUT_*(재단mm), WRK_*(작업mm, 도련포함), PRN_CNT(수량), CVR/INN_MTRL_CD(표지/내지 자재), PCS_COD/PCS_DTL_COD(공정/상세), PRICE/PRICE_VAT/PRICE_MALL, price_gbn(가격체계), mb_cust_cod(고객등급).

→ **후니 시사점:** 가격엔진 API 계약을 이 구조로 설계. 공정별 분해 표시(투명성)는 후니 차별점.

## 6. Pinia 스토어 (불일치 — 확정 필요)

SDK 리포트=**4개**(config/product/order/exterior), widget_monitor 분석=**5개**(+acc-order). 가설: 책자류 4개 / 부자재(ACC)류 5개 → **상품군별 차이**. hw-reverse-engineer 가 GSTGMIC(부자재) vs PRBKORD(책자) 라이브 비교로 확정.

- `product.baseInfo`: pdt_base_info/pdt_size_info/pdt_mtrl_info/pdt_dosu_info/pdt_pcs_info/**pdt_disable_pcs_info(캐스케이드 제약)**/inner_pdt_*(내지)/member_info 등 17 데이터셋
- `order.orderData`: sizeInfo/inner_dosuInfo/inner_meterialInfo/dosuInfo/meterialInfo/pcsInfo/quantityInfo/priceCalc

## 7. 브릿지 글로벌 함수 (호스트↔위젯 통합 API 기준)

`sdkInit`·`fnInitSdk`(초기화) / `sdkOptionChange`(옵션변경→가격재계산) / `sdkInformMaterials`(자재전달) / `sdkOpenEditor`·`fnKoiEditorInit/fnKoiEditor`·`fnRpEditorInit/fnRpEditor`(에디터) / `sdkEditorCheck`(에디터상태) / `sdkPrintAreaGuide`·`sdkGuide`(가이드) / `sdkCreatePot`(주문데이터 생성→submit) / `fnPreOrder`·`fn_order_able`(주문검증) / `fnCalcPriceTable`(가격표) / `fnEstimate`(견적서).

→ **후니 시사점:** React-in-Shadow-DOM 위젯의 호스트 통합 이벤트/콜백 API를 이 함수군에 대응시켜 설계(CustomEvent 또는 콜백 prop).

## 8. RedEditorSDK 45 메서드 (Edicus 연동 기준)

- 템플릿: setCurrentTemplate/getTemplateList/changeTemplate/editTemplate
- 프로젝트: **createProject**/openProject/reformProject/cloneProject/getProjectId
- 에디터UI: openFullyFunctionalUI/remoteEditor/changeLayout
- VDP: openVdpViewer/setVariableData/getCurrentTemplateVdpList
- 생명주기: **save/saveThenClose/close**/destroy/**checkOrderable**/**prepareOrder**
- 인증/설정: **setToken**/setUserId/**setPrice**/setEdicusStageUrl/getCustomCss
- 이벤트: **on**/editorEventHandler
- 조회: getProductInfo/getResourceList/getSceneInfo 등

→ **후니 시사점:** 후니 Edicus 브리지가 사용할 메서드 우선순위 = createProject/setToken/setPrice/on/save/checkOrderable/prepareOrder.

## 9. 보강 우선순위 (hw-reverse-engineer 인계)

| # | 항목 | 상태 | 라이브 보강 |
|---|------|------|------------|
| 1 | Pinia 스토어 4 vs 5 | 불일치 | GSTGMIC vs PRBKORD 라이브 비교로 확정 |
| 2 | 가격 rule 역산 | 요청/응답 계약 확정, 규칙 미상 | 옵션 조합별 응답 수집 → 규칙 역산 |
| 3 | S3 presigned 발급 | 엔드포인트 식별(`/api/aws/presigned`) | 발급→PUT 플로우 상세 라이브 캡처 |
| 4 | Edicus postMessage | from-edicus 부분 캡처 | 전체 라이프사이클 페이로드 정밀화 |
| 5 | 부자재(ACC) 흐름 | acc-order 스토어 미검증 | ACC 상품 라이브 구동 |
| 6 | TRANSLATIONS_KO | 280+ 미포함 | 한글 라벨 사전 추출 |
