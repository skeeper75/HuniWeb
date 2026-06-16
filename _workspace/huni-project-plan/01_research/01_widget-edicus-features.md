# 인쇄 자동견적 위젯 + 에디쿠스(Edicus) 연동 기능목록

> 후니프린팅 리뉴얼 — 일정관리 IA 문서용 기능 정리.
> **근거**: RedPrinting 위젯 역공학(`docs/reversing/*.html`·`red_reverse_engineer/final`) + huni-widget 하네스 산출물(`01_reverse`·`03_spec`·`07_parity`·`04_build`).
> **검증 표기**: `[라이브]`=localhost:3001 테스트베드 실응답 / `[정적]`=비난독화 소스·리포트 / `[추정]`=미검증 가설.
> **입력 IA 매핑 주의**: 일정관리 IA의 기능번호(B1 규격선택, B5 인쇄도수, B9 제본, C1 실시간가격, D1 파일업로드, D3 온라인에디터 등)는 별도 IA 문서가 권위. 본 문서는 과업이 명시한 앵커에 매핑하고, 그 외 B/C/D/E 번호는 IA 문서 확정 전이라 `(추정매핑)` 표기. IA 문서 확정 시 재대조 필요.

---

# A부. 쉬운 말 기능목록 (실무진·PM용)

위젯이 하는 일을 비개발자가 이해하도록 정리한 표. "외부서비스 의존"은 그 기능이 외부 시스템 없이는 못 돌아가는 항목.

| # | 기능명(쉬운말) | 무엇을 하는지 | 적용 상품군 | 입력 IA 매핑 | 난이도 | 외부서비스 의존 |
|---|---------------|--------------|------------|-------------|:------:|----------------|
| 1 | 위젯 띄우기 | 상품 상세페이지 안에 견적/주문 박스를 끼워 넣어 화면에 보여줌(다른 디자인과 안 섞이게 칸막이 처리) | 전 상품군 | (기반·번호없음) | L | 없음(자체) |
| 2 | 규격(사이즈) 선택 | 명함/엽서/책자 등 인쇄물 크기를 고르게 함 | 전 상품군 | **B1 규격선택** | S | 없음 |
| 3 | 수량 선택 | 몇 부/몇 권 만들지 고르게 함(직접입력+증감버튼) | 전 상품군 | B2 수량(추정매핑) | S | 없음 |
| 4 | 용지 선택 | 종이 종류와 평량(두께)을 2단 드롭다운으로 고르게 함 | 책자·명함·엽서 등 종이류 | B3 용지(추정매핑) | M | 없음 |
| 5 | 인쇄 도수(색상) 선택 | 컬러(4도)/단색(1도)을 표지·내지 따로 고르게 함 | 종이 인쇄류 | **B5 인쇄도수** | S | 없음 |
| 6 | 자재(재질) 선택 | 아크릴·굿즈 등에서 본체 재질을 고르게 함 | 아크릴·굿즈·파우치 | B4 자재(추정매핑) | M | 없음 |
| 7 | 내지 장수 입력 | 책자에서 속지 페이지 수(2~130)를 입력하게 함 | 책자 | B6 내지장수(추정매핑) | S | 없음 |
| 8 | 후가공 선택 | 코팅·박·형압 등 마무리 가공을 고르게 함 | 전 상품군(상품별 종류 다름) | B7 후가공(추정매핑) | M | 없음 |
| 9 | 제본/링 옵션 선택 | 링제본·제본방향(좌철/상철)·링 색상(검정/흰/금/은)을 고르게 함 | 책자 | **B9 제본** | M | 없음 |
| 10 | 옵션 자동 잠금(캐스케이드) | 어떤 용지/자재를 고르면 그것과 안 맞는 후가공을 자동으로 회색 처리해 못 고르게 막음 | 책자(잠금규칙 많음)·기타 | B10 제약(추정매핑) | L | 없음(서버 규칙) |
| 11 | 실시간 가격 표시 | 옵션을 바꿀 때마다 가격을 다시 계산해 즉시 보여줌(정가/할인가/부가세/배송비 분리 표시) | 전 상품군 | **C1 실시간가격** | M | **가격 API** |
| 12 | 공정별 가격 분해 보기 | 인쇄비·코팅비·자재비 등을 항목별로 쪼개 보여줌(가격 투명성) | 전 상품군 | C2 가격상세(추정매핑) | M | **가격 API** |
| 13 | 견적서/가격표 보기 | 수량 구간별 가격표·견적서를 뽑아줌 | 전 상품군 | C3 견적서(추정매핑) | M | 가격 API |
| 14 | 인쇄 가이드 보기 | 작업 사이즈·도련 등 파일 만들 때 지켜야 할 안내선을 보여줌 | 전 상품군 | D2 가이드(추정매핑) | M | 없음 |
| 15 | 파일 업로드(PDF) | 완성된 인쇄용 PDF를 끌어다 올리면 클라우드(S3)에 바로 저장 | 전 상품군(업로드형) | **D1 파일업로드** | L | **S3 업로드** |
| 16 | 업로드 파일 검증 | 올린 파일의 형식·크기·페이지 수가 맞는지 확인하고, 표지/내지 중복·누락을 막음 | 전 상품군 | D1 파일검증(추정매핑) | M | S3 메타조회 API |
| 17 | 온라인 에디터로 디자인 | 파일이 없어도 화면에서 직접 표지·굿즈를 디자인(템플릿 편집·이미지 배치) | 책자·굿즈·아크릴 등 에디터 지원 상품 | **D3 온라인에디터** | XL | **에디쿠스(Edicus)** |
| 18 | 에디터 저장·미리보기 | 에디터에서 만든 디자인을 저장하고 썸네일/미리보기를 받아 주문에 붙임 | 에디터 지원 상품 | D4 미리보기(추정매핑) | L | **에디쿠스** |
| 19 | 주문 데이터 생성 | 고른 옵션+가격+업로드/디자인 결과를 하나로 묶어 주문 폼에 넘김 | 전 상품군 | E1 주문전달(추정매핑) | M | 없음(자체) |
| 20 | 주문 가능 여부 검증 | 필수 옵션·파일이 다 채워졌는지 확인해 빠진 게 있으면 주문을 막음 | 전 상품군 | E2 주문검증(추정매핑) | M | 없음 |
| 21 | 부자재(ACC) 주문 흐름 | 봉투·스티커 등 부자재류는 책자와 다른 단순 주문 흐름으로 처리 | 부자재(ACC) | E3 부자재(추정매핑) | M | 가격 API |
| 22 | 한글 라벨 표시 | 옵션명을 한글로 보기 좋게 표시(서버 코드값 → 한글 라벨 사전) | 전 상품군 | (UI·번호없음) | S | 없음 |

**A부 기능 개수: 22개** (확정 IA 매핑 6개 / 추정매핑 14개 / 번호없는 기반·UI 2개)

> 외부서비스 의존 요약: **에디쿠스 2개**(17·18) · **S3 업로드 2개**(15·16) · **가격 API 4개**(11·12·13·21). 나머지 14개는 위젯 자체 동작.

---

# B부. 개발자용 상세 (별도 시트로 갈 내용)

## B-1. 레드 SDK 3계층 아키텍처 [정적]

| 계층 | 파일 | 특성 | 역할 | 후니 대응 |
|------|------|------|------|----------|
| 브릿지 | `productRedWidgetSDK.js`(자체호스팅) | 33KB·비난독화·jQuery·17 호스트통합 함수 | 호스트 페이지 ↔ 위젯 글루 | 얇은 임베드 로더 |
| 런타임 | `widget.js`(CloudFront) | 438KB·Vue3+Pinia·5 스토어 | Shadow DOM 렌더·상태·API·가격표시 | React-in-Shadow-DOM 런타임 |
| 에디터 | `RedEditorSDK.min.js`(CloudFront) | 미니파이·45 메서드 | 표지/디자인 에디터 | Edicus 브리지 |

API 호스트 [라이브]: 본서버 `redprinting.co.kr` · 위젯API `widget-api.redprinting.co.kr` · 메이커스 `makers.redprinting.net` · 에디터 `edicusbase.firebaseapp.com`.

## B-2. 핵심 브릿지 함수 17 (호스트 통합 API 계약 기준) [정적]

위젯이 호스트와 주고받는 통합 진입점. 후니는 이를 CustomEvent/콜백 prop으로 대응.

- 초기화: `sdkInit` / `fnInitSdk`
- 옵션변경→가격재계산: `sdkOptionChange`
- 자재전달: `sdkInformMaterials`
- 에디터: `sdkOpenEditor` / `fnKoiEditorInit`·`fnKoiEditor`(코이/자체) / `fnRpEditorInit`·`fnRpEditor`(레드)
- 에디터상태: `sdkEditorCheck`
- 가이드: `sdkPrintAreaGuide` / `sdkGuide`
- 주문데이터 생성→submit: `sdkCreatePot`
- 주문검증: `fnPreOrder` / `fn_order_able`
- 가격표/견적: `fnCalcPriceTable` / `fnEstimate`

## B-3. 45 에디터 메서드 중 위젯이 호출하는 핵심 [정적]

후니 Edicus 브리지 우선순위: `createProject` → `setToken` → `setPrice` → `on`(이벤트) → `save`/`saveThenClose` → `checkOrderable` → `prepareOrder`. (전체 45: 템플릿 4·프로젝트 5·에디터UI 3·VDP 3·생명주기 7·인증설정 6·이벤트 2·조회 다수)

## B-4. 가격 API 실측 계약 [라이브]

**`POST /ko/product_price/get_ajax_price_vTmpl`** · 인증=세션 쿠키만 · 평문 JSON.

요청 shape(책자 기준):
```json
{ "dataJson": {
  "ORD_INFO": [{ "PDT_CD","CUT_WDT","CUT_HGH","WRK_WDT","WRK_HGH","PRN_CNT",
                 "PAGE_CNT","CVR_CLR_CNT","INN_CLR_CNT","CVR_MTRL_CD","INN_MTRL_CD" }],
  "PCS_INFO": [{ "PCS_COD","PCS_DTL_COD" }, ...],
  "price_gbn":"book2025_price", "mb_cust_cod":"10000000" } }
```
응답 shape: `result[]`(공정별 PRICE 분해) + `result_sum`(PRICE/PRICE_MALL/ORG_PRICE + VAT 3쌍) + `result_log`(단가명세·배송) + `book_info`(무게·배송비).

상품군별 `price_gbn` 분기 [라이브]: 책자=`book2025_price` · 굿즈=`tiered_price` · 아크릴=`vTmpl_price`. (Red 고유 키 — 후니는 후니 자체 가격체계로 분기, 위젯은 불투명 echo).

역산된 규칙 [라이브, 8조합 측정]: 수량=구간단가 룩업(선형 아님) · 페이지=선형 가산(~1,115원/page) · 색상=인쇄단가 분기(표지 -12,100/내지 -3,600). **클라이언트 재계산 금지·전적으로 서버 권위**(순진 곱셈은 실측과 2배 이상 차이로 반증).

## B-5. 에디쿠스(Edicus) 연동 단계 [정적 + 라이브 핸들러 검증]

```
1. 에디터 띄우기   store.openEditor(side) → BFF가 토큰체인(makers /token,/editor,template/hit) →
                  editor-bridge.createProject(config) → Edicus iframe 생성
                  iframe src = {EDICUS_EDITOR_HOST}/ed#/editor_landing?cmd=create&token={JWT}&ps_code=...
2. 핸드셰이크     from-edicus(request-prod-info) → 호스트 send-extra-param(prod_info/options 전달)
                  ※ 큰 데이터는 deferred-param 방식: URL에 wait_{name}=true만, 준비되면 요청-응답
3. 편집           from-edicus(doc-changed) — 템플릿/레이아웃 편집 진행
4. 저장           from-edicus(save-doc-report: phase start→end) — docInfo(projectID·tnUrlList·페이지수) 보관
5. 썸네일/미리보기 docInfo.tnUrlList = 저장 시 받는 썸네일 URL 배열
6. 주문 파일 확정  from-edicus(goto-cart: projectID·tnUrlList·totalPageCount·case) → 편집완료, 주문데이터에 반영 → close
```
postMessage 라이프사이클(라이브 실측 6 + 정적 3): `CreatingProject → load-project-report(start) → ready-to-listen → doc-changed → request-prod-info → project-id-created → load-project-report(end)` ─편집─ `save-doc-report(start/end) → goto-cart → close`.

방향: 호스트→에디터 `to-edicus-root`/`to-edicus`(편집 명령) · 에디터→호스트 `from-edicus`(콜백)/`from-edicus-private`(SDK 자체처리 핸드셰이크). **origin 검증을 페이로드 파싱 전 최우선**(라이브 origin = `edicusbase.firebaseapp.com`).

## B-6. `.env.local` EDICUS_* 키와 연동 엔드포인트 (키 이름만, 값 비노출)

| 키 이름 | 어떤 연동에 필요 |
|---------|-----------------|
| `EDICUS_PARTNER_CODE` | 파트너 식별(passive mode `div` 값, 위젯 하드코딩 금지·BFF 주입) |
| `EDICUS_API_KEY` | Edicus API 인증 키 |
| `EDICUS_API_HOST` | Edicus API 엔드포인트 |
| `EDICUS_EDITOR_HOST` | 에디터 iframe src 베이스(`/ed#/editor_landing`) |
| `EDICUS_BASE_HOST` | postMessage origin 허용목록(운영) |
| `EDICUS_RESOURCE_HOST` / `EDICUS_ASSET_HOST` | 템플릿/에셋 리소스 호스트 |
| `EDICUS_RENDER_DPI` | 렌더/미리보기 해상도 |
| `EDICUS_FIREBASE_*` (API_KEY·AUTH_DOMAIN·DATABASE_URL·PROJECT_ID·STORAGE_BUCKET·MESSAGING_SENDER_ID) | Edicus가 Firebase 기반 — 에디터/저장/리소스 백엔드 |
| `EDICUS_MANAGER_URL` / `EDICUS_MANAGER_ID` / `EDICUS_MANAGER_PW` | Edicus 관리자(템플릿/리소스 관리) 접속 |

> 토큰(JWT, ~55분 만료·자동갱신)은 위젯이 보관하지 않고 SDK에 즉시 전달. 토큰 발급/갱신은 BFF/어댑터 책임.

## B-7. S3 presigned 업로드 플로우 [라이브, end-to-end 검증]

```
1. POST /api/aws/presigned-url  {file_name, pdt_cod, content_type} → {filename(서버 UUID), presignedURL(60분 만료)}
2. PUT  <presignedURL>  Body=PDF binary  (S3 직접, 서버 경유 없음) → 200
3. POST /ko/product/s3GetObjectJson  {file_name} → 파일 메타(페이지수/크기 검증)
4. fileUploadInfo[0]=내지·[1]=표지 → 주문데이터 반영 (둘 다 필수 시 누락/파일명중복 검증)
```
버킷=`*.tempo`(임시) → 주문확정 시 영구 이동(추정). 검증=확장자 PDF·1GB 제한(클라이언트 검증 확인).

## B-8. 미검증/리스크 영역 (라이브 보강 필요·은폐 금지)

| 영역 | 현재 검증 상태 | 리스크 |
|------|---------------|--------|
| S3 presigned 업로드 | **✅ 해소** — 발급+PUT end-to-end 200 | 운영 SDK의 정확한 `X-Amz-SignedHeaders`/checksum 헤더 셋 미캡처 [미검증] |
| 가격 rule | **✅ 규칙 측정** — 8조합 역산 | 회원등급 할인(PRICE_MALL≠PRICE)·비책자(굿즈/아크릴) ORD_INFO·고급후가공(박/형압/스코딕스) 가격기여 미캡처 [미검증] |
| postMessage 라이프사이클 | **🟡 부분** — 프로토콜·핸들러 확정 | 에디터 iframe 실구동 실시간 메시지 덤프·`goto-cart` `case` 값 종류 미캡처 [미검증]. 위젯은 case pass-through로 흡수 |
| 부자재(ACC) 흐름 | **🟡 구조 확정** — `useAccOrderStore`(AccWidgetInstance) | ACC 가격 페이로드 미캡처 [미검증] |
| 전 상품 스키마 | **부분** — 3상품(책자·굿즈·아크릴) 라이브 | Vue3 위젯 25상품 전수 스키마 미수집(대표 3군 커버) [부분] |

> 잔존 미검증은 모두 **구현 비차단**(어댑터/후속 캡처로 흡수 가능). 일정관리에서는 "라이브 보강 캡처" 후속 태스크로 분리 권장.

## B-9. Pinia 스토어 5종 (상품군별 분기) [라이브 확정]

`useConfigStore`(공통) · `useProductStore`(공통) · `useOrderStore`(책자/일반) · `useAccOrderStore`(부자재 ACC) · `useExteriorStore`(책자 표지/내지). 책자=order+exterior(`inner_*` 데이터셋 존재), 굿즈·아크릴=단순 order(`inner_*` 없음), 부자재=acc-order로 분기.

## B-10. 후니 전환 메모 (huni-widget 하네스 핵심 결정)

- **위젯은 DB가 아닌 정규화 계약(normalized contract)에 의존**. Red 가격(`ORD_INFO`+`PCS_INFO`)·presigned·`from-edicus:goto-cart`를 **어댑터 경계**에서 정규화 형태(`NormalizedEditorConfig`/`NormalizedEditorResult`/`NormalizedArtifact`)로 변환.
- **무손실 컨버전**: Red 역공학 데이터로 위젯을 구현·검증한 뒤, **후니 어댑터로 교체하면 위젯 코어 코드는 불변**. 후니 DB가 아직 미정이어도 위젯 개발 진행 가능(어댑터 레이어가 흡수).
- **가격 불변식**: 위젯은 가격을 절대 계산하지 않음(서버 권위). Red→후니 가격값 비교/이식은 하지 않으며, 후니 자체 가격 API 응답의 `finalPrice`/`vat`/`shipping`만 표시.
- **Red는 사용자 본인 설계 시스템** — 역공학은 답습이 아니라 완전성 검증·후니 어댑터 설계 입력 목적.
- 동등성 검증: huni-widget 하네스가 Red 라이브와 4차원(동작·가격·시각구조·인터랙션)×대표모델 동등 입증 완료(`07_parity/`), vitest 150 통과 — 후니 맞춤 작업 선행 관문 통과.

**B부 핵심 항목 수: 10개 섹션** (3계층 아키텍처 / 17 브릿지 함수 / 45 에디터 메서드 핵심 / 가격 API 계약 / 에디쿠스 6단계 연동 / EDICUS_* 키 매핑 / S3 업로드 플로우 / 미검증·리스크 5영역 / Pinia 5 스토어 / 후니 전환 메모).
