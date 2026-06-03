# Red 코드 구조 지도 — 모듈 05 (App API Layer)

> STAGE S0: 구조 매핑 전용. 파리티 판정 없음.
> 권위 소스: `docs/reversing/red_reverse_engineer/03_deobfuscated/deob_05_app_api.js` (난독화 해제, primary)
> 교차참조: `01_source/mod_05_app_api.js`(원본 beautified) + `01_source/mod_06_app_widget_sdk.js`(reqBody 빌더가 사는 모듈)
> 파리티 기준 = **책임/로직/분기 재현 동치** (라인 카피 아님 — React vs Vue 구현 차이 허용, 행위+분기 커버리지가 일치하면 통과)
>
> 모듈 경계 주의: deob_05 는 **순수 트랜스포트 계층**이다. 모든 fetch 래퍼가 여기 살지만, 가격 reqBody(ORD_INFO/PCS_INFO) 빌드 로직은 **deob_06(widget_sdk) 소관**이며 deob_05 에는 빌더가 없다. 본 문서는 트랜스포트 계약과 "빌더가 어디 사는지"를 명시하고, S0 자매 에이전트(deob_06 매핑)에 빌더 상세를 인계한다.

---

## 0. 핵심 발견 — 캡처(단편)가 놓친 구조적 진실

| 항목 | 캡처(런타임 샘플) 시각 | **코드(권위 소스) 진실** |
|------|----------------------|-------------------------|
| 가격 엔드포인트 수 | 상품군별로 다른 줄 알았음 | **단 1개**: `POST /{locale}/product_price/get_ajax_price_vTmpl` (deob_05:1132). 모든 상품(책자/굿즈/아크릴/의류/달력/부자재)이 동일 URL 사용 |
| `price_gbn` 분기 | 4종(book2025_price / real_price / vTmpl_price / tiered_price)이 코드 분기인 줄 알았음 | **코드에 price_gbn 분기문이 0개**. price_gbn 은 reqBody 안의 **불투명 passthrough 필드**일 뿐. 값은 서버에서 받은 `product_option.option.price_gbn`을 그대로 echo. fetchPriceCalculation(deob_05:1129)은 price_gbn 을 읽지도 분기하지도 않음 — `{dataJson: payload.body}`로 통째 감싸 전송만 함 |
| 가격 분기 주체 | 클라이언트가 분기하는 줄 | **서버가 단독 분기**. 클라이언트는 ORD_INFO/PCS_INFO + (서버가 준)price_gbn 을 조립해 보내고 result_sum 을 받기만 함 |
| reqBody 빌더 위치 | deob_05 가격 함수 안인 줄 | deob_05 에 빌더 없음. 빌더는 **deob_06 의 useOrderState/getKOIEditorTabData + buildOrderSummary**에 분산. deob_05 의 가격 함수는 이미 만들어진 body 를 받음 |

→ **파리티 함의**: "모든 상품 = 코드가 분기하는 모든 상품 경로"라는 기준에서, **deob_05 API 계층은 상품 분기가 거의 없다**(트랜스포트는 상품 불변). 상품 분기는 reqBody 빌드 계층(deob_06/07)에 응집. 우리 React 구현의 API 클라이언트도 동일하게 **상품-불가지(product-agnostic) 트랜스포트**여야 하며, price_gbn 등 가격체계 키를 해석/분기하면 안 된다(echo만).

---

## 1. 책임 인벤토리 (Responsibility Inventory)

| # | Red 책임 | file:line | 로직 요약 | 상품/분기 조건 |
|---|----------|-----------|----------|----------------|
| R1 | 환경/Lodash 유틸 번들 | deob_05:34–1048 | globalThis 감지 + Lodash 내부(isObject/debounce/isEmpty/getNative/getTag...) | 없음(벤더 유틸). 단 `debounce`(initDebounce 329)는 가격호출 디바운스에 쓰임 — deob_06 소비 |
| R2 | API 베이스 URL 상수 3종 | deob_05:1058,1064,1070 | REDPRINTING_BASE_URL=`www.redprinting.co.kr`, ASSETS_IMAGE_CDN_URL=`d3qehkb69dy9zc.cloudfront.net/assets/images`, WIDGET_API_BASE_URL=`widget-api.redprinting.co.kr` | 없음. 단 메인 도메인 vs 위젯 도메인 2-tier 분리(아래 §2 참고) |
| R3 | `fetchProductInfo` | deob_05:1085 | GET 제품 전체 옵션 조회. retCode!==200 → throw. return `{result, errorMessage}` | patternCode 유무로 쿼리 분기(ptt_cod 포함/생략) |
| R4 | `fetchPriceCalculation` | deob_05:1129 | POST 가격계산. body=`{dataJson: payload.body}`로 1중 래핑. retCode!==200 → throw | **상품 분기 없음**. payload.body(=ORD_INFO/PCS_INFO/price_gbn/mb_cust_cod)는 호출자가 완성해 전달 |
| R5 | `fetchS3FileInfo` | deob_05:1167 | POST S3 객체 메타 조회(ContentLength 등). body=`{file_name}`. falsy → throw | 없음. 업로드 완료 후 파일 크기 확인용 |
| R6 | `fetchAvailableMaterials` | deob_05:1197 | POST 주문가능 용지 목록. body=`{pdt_cod}`. PDT_COD/PTT_COD 키로 중복제거 + 가이드 이미지 URL 2종 주입(default/over) | 없음(pdt_cod 만 변동). 결과에 CDN 이미지 경로 합성 |
| R7 | `downloadTemplate` | deob_05:1237 | POST → blob. type!=="application/zip" → throw. createObjectURL→a.click→revoke. file_nm 의 `.`→`_` 치환 | 없음(트랜스포트). 다운로드 파라미터 빌드는 deob_07(buildTemplateDownloadParams) 소관 |
| R8 | `downloadCoverTemplatePdf` | deob_05:1265 | POST → json. success/url 없으면 throw. responseData.url 로 a.click | 책자(무선/트윈링) 표지 전용 — 호출 측 분기(deob_07) |
| R9 | 번역 사전 TRANSLATIONS_EN/KO | deob_05:1295~ | 280+ 라벨 사전 | 없음. translate()가 소비 |

> **deob_05 에는 없지만 API 엔드포인트인 것** (deob_06 소관이나 트랜스포트 인벤토리 완전성 위해 등재):
> | R10 | S3 presigned 발급 | mod_06:2083 | `POST {WIDGET_API_BASE_URL}/api/aws/presigned-url` body=`{filename}` → `{filename(new), presignedURL}`. 이어서 `PUT presignedURL` (Content-Type=file.type, body=file). status!==200 → throw | 없음 |
> | R11 | 에디터 config 발급 | mod_06:2488 | `POST {WIDGET_API_BASE_URL}/api/editor/config/{KOI|RP}` body=`{token, payload}` → `{config, option, ...}`. A.error 시 콘솔만 | `{KOI|RP}` 에디터 종류로 path 분기(m.value) |

---

## 2. 엔드포인트 전수 (8종)

| # | path | method | base | when | reqBody | resp |
|---|------|--------|------|------|---------|------|
| E1 | `/{locale}/product/get_digital_product_info?pdt_cod=&ptt_cod=` | GET | REDPRINTING | 위젯 init 시 1회 | (쿼리) pdt_cod, [ptt_cod] | `{retCode, result, msg}` |
| E2 | `/{locale}/product_price/get_ajax_price_vTmpl` | POST | REDPRINTING | 옵션변경 debounce 후 | `{dataJson:{ORD_INFO[],PCS_INFO[],price_gbn,mb_cust_cod}}` | `{retCode, result_sum, result[], msg}` |
| E3 | `/{locale}/product/s3GetObjectJson` | POST | REDPRINTING | 파일 업로드 직후 | `{file_name}` | S3 obj(ContentLength) or null |
| E4 | `/{locale}/product/guide_product_paper` | POST | REDPRINTING | 자재필터 표시 시 | `{pdt_cod}` | `[{PDT_COD,PTT_COD,...}]` |
| E5 | `/{locale}/product/get_download` | POST(FormData) | REDPRINTING | 템플릿(zip) 다운로드 클릭 | FormData(file_nm 등 가변) | blob(application/zip) |
| E6 | `/{locale}/product/get_pdf_download` | POST(FormData) | REDPRINTING | 책자 표지 PDF 다운로드 | FormData(가변) | `{success,url,msg}` |
| E7 | `/api/aws/presigned-url` | POST | WIDGET_API | PDF 파일 선택 시 | `{filename}` | `{filename,presignedURL}` → 이후 PUT |
| E8 | `/api/editor/config/{KOI|RP}` | POST | WIDGET_API | 편집하기/에디터 진입 | `{token,payload}` | `{config,option,error}` |

**2-tier 도메인**: E1–E6 은 메인몰(REDPRINTING_BASE_URL), E7–E8 은 위젯 전용 API(WIDGET_API_BASE_URL). locale 은 E1–E6 path 에 들어가고 E7–E8 에는 없음.

---

## 3. 가격 호출 심층 (Price-Call Deep Section)

### 3.1 엔드포인트는 단일, price_gbn 분기는 코드에 없음

```
deob_05:1129  async function fetchPriceCalculation(priceRequestPayload, locale = "ko")
deob_05:1132  apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product_price/get_ajax_price_vTmpl`
deob_05:1138  body: JSON.stringify({ dataJson: priceRequestPayload.body })   // ← body 를 dataJson 으로 1중 래핑
deob_05:1141  if (responseData.retCode !== 200) throw new Error(responseData.msg)
```

- **price_gbn 을 코드가 분기하지 않는다**: deob_05 전체에서 price_gbn 토큰은 주석(1123)에만 등장. 코드 경로에서 price_gbn 으로 if/switch 하는 곳 0개(grep 전수 확인). book2025_price / real_price / vTmpl_price / tiered_price 는 **서버가 반환한 옵션값을 reqBody 에 echo 하는 데이터**이지, 클라이언트 분기 키가 아니다.
- `dataJson` 래퍼: 호출자가 만든 `payload.body` 객체를 `{dataJson: ...}` 안에 한 번 더 감싸 전송. (priors `price-engine-reversed.md:13,18` 과 일치)
- `payload` 형태 = `{type:"COMMON", body:{...}}`. `type`("COMMON"/"ACC")은 **클라이언트 내부 라우팅 라벨이고 서버로 안 감**(전송되는 건 body 뿐).

### 3.2 reqBody(ORD_INFO/PCS_INFO) 빌더는 deob_06 소관 — 단일 관찰된 빌드 분기

deob_05 엔 빌더가 없다. deob_06 에서 확인된 유일한 인라인 빌드 경로(의류 KOI 탭 재계산, getKOIEditorTabData):

```
deob_06:1256  updatedOrderInfo = [{ ...previousPriceParams.ORD_INFO[0], MTRL_CD: tabData.MTRL_COD }]
deob_06:1260  updatedPcsInfo = [ ...PCS_INFO.filter(i=>i.PCS_COD!=="DIR_MTR" && i.PCS_COD!=="PDT_WRK"),
                                 ...printAreaPcsList, materialPcsEntry ]
deob_06:1261  priceRequestPayload = { ...previousPriceParams, ORD_INFO: updatedOrderInfo, PCS_INFO: updatedPcsInfo }
deob_06:1266  fetchPriceCalculation({ type:"COMMON", body: priceRequestPayload })
```

핵심 구조 단서(빌더 인계용):
- ORD_INFO 는 단일 원소 배열 `[{...}]`, MTRL_CD 가 자재 키.
- PCS_INFO 는 후가공/자재 항목 배열. `PCS_COD`(예: `DIR_MTR`,`PDT_WRK`,`COT_DFT`) + `PCS_DTL_COD` + 선택적 `ATTB`(수량).
- 재계산 시 기존 params(`getOrderData().priceCalc.params`)를 베이스로 **부분 갱신** 패턴(전체 재조립 아님).
- 책자는 `itemGroup==="book2025_item"`에서 표지/내지 분리 요약(deob_06:1046,1174) — 빌드 분기는 itemGroup 으로 일어남(price_gbn 아님).

### 3.3 응답 → 가격 추출 (3단 워터폴)

deob_06:1273–1284 (getKOIEditorTabData) 와 1336~(getSummary) 에서 result_sum 추출:

```
ORG_PRICE/ORG_PRICE_VAT  = 정가
PRICE/PRICE_VAT          = 할인가
PRICE_MALL/PRICE_MALL_VAT= 몰(추가할인)가
```
워터폴(deob_06:1284):
```
PRICE_MALL !== PRICE  →  몰가:   PRICE_MALL + PRICE_MALL_VAT
ORG_PRICE  !== PRICE  →  할인가: PRICE      + PRICE_VAT
그 외                 →  정가:   ORG_PRICE  + ORG_PRICE_VAT
```
(priors `price-engine-reversed.md:83–85` 와 동일. 다만 priors 워터폴은 PRICE_MALL 우선 명시; 코드도 동일 순서)

### 3.4 mb_cust_cod / 회원 컨텍스트

- price reqBody 의 `mb_cust_cod` 는 init 시 주입된 member 정보(deob_06:65 provide "member")에서 옴.
- 기본 fallback: `mb_cust_cod || "10000000"`, `mb_id || "redprinting"` (mod_06:2521–2522, onCreatePot 경로에서 확인). 비로그인/게스트 시 표준 게스트 코드 `10000000` 사용.

### 3.5 PRN_CNT / ORD_CNT

- deob_05 가격 함수엔 PRN_CNT/ORD_CNT 직접 참조 없음(빌더 소관).
- deob_06:1250 에서 수량은 `ATTB: orderData?.quantityInfo.prnCnt` 형태로 PCS_INFO 항목의 ATTB 에 들어감.
- deob_07:375,382 에 `PRN_CNT` UI 입력 id/name 존재(컴포넌트 소관). MIN_PRN_CNT/MIN_INN_PAGE(deob_07:1219)로 최소 수량 분기 — default vs 책자 구분.

---

## 4. 상품-분기 경로 전수 (API 계층)

API 트랜스포트 계층(deob_05)의 상품 조건 분기는 **사실상 없음**. 확인된 분기는 호출 측(deob_06/07)에 있고, deob_05 내부는 다음만:

| 분기 | file:line | 조건 | 효과 |
|------|-----------|------|------|
| B1 | deob_05:1087 | `patternCode` 존재 여부 | E1 쿼리에 ptt_cod 포함/생략 |
| B2 | deob_05:1212 | PDT_COD/PTT_COD 조합 Set 미존재 | E4 응답 중복제거(상품 무관, 데이터 위생) |

호출 측 상품 분기(인계용, deob_06/07 소관이나 API 사용 형태를 좌우):
- itemGroup `book2025_item`(책자) → 표지/내지 2-업로더 + 표지 PDF(E6) + canOrder 책자 분기(deob_06:1174)
- apparel_info 존재(의류) → getKOIEditorTabData 인쇄영역 PCS 빌드(deob_06:1237)
- itemGroup `clothes2025_item` → canOrder 의류 분기(SLK/팬톤, deob_06:1194,1198)
- 부자재(ACC, ACC_PRODUCT_CODES) → AccWidgetInstance(별도 인스턴스, 가격 동일 E2 사용)

---

## 5. 에러/가드 로직 목록

| 가드 | file:line | 조건 → 동작 |
|------|-----------|------------|
| G1 retCode 게이트 | deob_05:1095,1141 | `retCode!==200` → throw(msg). E1/E2 공통 |
| G2 silent-null 폴백 | deob_05:1103,1178,1208,1221 | catch 시 console.error 후 `{result:null,...}` 또는 null 반환 — **throw 안 함**(UI 무중단). E2 는 errorMessage 동반, E3/E4 는 null |
| G3 zip 타입 검증 | deob_05:1249 | blob.type!=="application/zip" → throw "템플릿 없음" |
| G4 PDF success/url | deob_05:1277 | `!success \|\| !url` → throw(msg) |
| G5 S3 존재 | deob_05:1178 | falsy resp → throw "s3에 존재하지 않음" |
| **G6 PRICE=0 침묵실패** | deob_06:1167 | `priceCalc.result.retCode!==200 \|\| !result_sum.PRICE` → "주문불가-가격". 가격 0/누락이 주문 차단(침묵 PRICE=0 벡터) |
| G7 주문가능상태 | deob_06:1161 | `order_yn==="N"` → "주문불가상태" |
| G8 사이즈 유효성 | deob_06:1164 | `validation.length>0` → "주문불가-사이즈" |
| G9 파일/에디터 완료 | deob_06:1177–1203 | 업로드타입(pdf/editor)별 파일존재·편집완료·파일명중복 검증 |
| G10 presigned 결측 | mod_06:2096 | `!presignedURL \|\| !filename` → throw. PUT status!==200 → throw |
| G11 editor config error | mod_06:2495 | `A.error` → console.error만(조용히 skip) |

- **디바운스/캐싱**: 가격 호출은 debounce(deob_05 initDebounce:329)로 감쌈. priors event-contract `300ms` 명시. deob_05 자체엔 재시도/응답 캐시 없음(매 변경마다 신선 호출).
- **재시도(retry)**: 코드에 자동 재시도 없음. 실패는 G2 폴백으로 흡수.

---

## 6. Auth / Session / Token

- **clientKey 게이트**(deob_06:40): `ALLOWED_CLIENT_KEYS=["red-mobile","red-pc"]`(deob_06:936) 외 값이면 생성자에서 throw "존재하지 않는 사용자". SDK 인스턴스화 레벨 화이트리스트.
- **member 주입**(deob_06:65,89): init config 의 `{mb_id, mb_cust_cod, base64ID}` 를 Vue provide("member") 로 전역 주입. 가격 reqBody 의 mb_cust_cod 및 onCreatePot 의 memberInfo 가 여기서 옴.
- **editor token**(mod_06:2485): E8(editor/config) body 의 `token` = `uploadConfig.token`(KOI 는 별도 토큰 a, RP 는 i.token, mod_06:2676). 이 토큰이 에디터 세션 권한.
- **API 인증 헤더 없음**: E1–E7 fetch 에 Authorization/Bearer 헤더 **없음**(grep 0건). 가격/제품 API 는 헤더 인증 대신 **쿠키 세션 + body 의 mb_cust_cod** 로 회원 식별 추정. (라이브 테스트베드 server.js 가 sessionCookie 를 주입하던 것과 정합 — CLAUDE.md 변경이력 F6 참조)
- **토큰 수명 2축**(인계): 에디터 토큰(E8, JWT exp) vs 가격권위 세션쿠키(E2) 는 별개 수명. 둘 분리 관리 필요.

---

## 7. 우리 구현과 대응시킬 축 (S1 파리티 매트릭스 훅)

각 책임에 대해 우리 React 코드가 **재현해야 하는 책임 레벨**(라인카피 아님):

| 축 | Red 책임 | 우리 React가 반드시 재현할 행위 | 분기 커버리지 |
|----|----------|-------------------------------|--------------|
| A1 | 트랜스포트 product-agnostic | API 클라이언트는 상품을 모름. price_gbn 등 가격체계 키를 **해석/분기 금지, echo만**. 어댑터가 후니 키로 치환 | price_gbn 분기 0개 = 우리도 0개 |
| A2 | 단일 가격 엔드포인트 + dataJson 래핑 | 1개 가격 호출 함수. body 를 정규화 계약 형태(어댑터 경유)로 1중 래핑. retCode!==200 throw | 상품 무분기 |
| A3 | reqBody 빌드 = 옵션상태 → ORD_INFO/PCS_INFO | 빌더는 별 계층(컴포넌트/스토어). ORD_INFO 단일원소, PCS_INFO 배열(PCS_COD+PCS_DTL_COD+ATTB), 부분갱신 패턴 | itemGroup별(book/clothes/acrylic/acc) 빌드 분기 재현 |
| A4 | 3단 가격 워터폴 | result_sum 에서 PRICE_MALL→PRICE→ORG_PRICE 순 워터폴로 표시가 산출. **클라 계산 금지**(서버값 선택만) | 3분기 전부 |
| A5 | retCode + silent-null 폴백 | 200게이트 throw + catch 시 UI 무중단 폴백(null/errorMessage). 다운로드는 throw, 조회는 폴백 | G1~G5 분기 |
| A6 | PRICE=0 주문차단 가드 | retCode!==200 또는 PRICE falsy → 주문불가. (침묵 PRICE=0 회귀 가드) | G6 |
| A7 | canOrder 다축 검증 | order_yn / 사이즈 validation / 가격 / 업로드타입별 파일·에디터·중복 | G6~G9 + itemGroup 분기 |
| A8 | S3 presigned 2-step | presigned 발급(POST)→S3 PUT(file)→ContentLength 조회(E3). 결측 throw | G10 |
| A9 | editor config {KOI\|RP} | 에디터 종류 path 분기 + token/payload body. error 시 조용히 skip | KOI/RP 2분기 |
| A10 | clientKey 화이트리스트 | SDK 마운트 시 허용 키 검증. (후니는 후니 키셋으로) | 화이트리스트 게이트 |
| A11 | member provide → mb_cust_cod | 회원 컨텍스트 전역 주입 + 게스트 fallback(`10000000`) | guest/member 2분기 |

**파리티 비-목표(명시)**: price_gbn 값 4종, ORD_INFO/PCS_INFO 의 Red 키명, `10000000` 게스트코드 — 이들은 Red 고유 데이터/키이며 후니 어댑터가 치환할 대상. 우리 위젯 코어는 **구조(단일 엔드포인트·워터폴·폴백·가드·2-step 업로드)**를 재현하되 Red 키/값을 하드코딩하지 않는다.
