# unknowns-board.md — 근거 부재 항목 전수

> 큐레이션가: hwf-flow-curator · 권위=역공학 자료
> [HARD] 미상은 결론으로 위장하지 않는다. 확인되면 갱신, 아니면 "모름(근거 없음)" 유지.
> 다운스트림(mermaid 집필가·시각화가)은 이 보드의 항목을 추측으로 메우지 말 것.

---

## A. 주문/장바구니 제출 경로

- **U-1 `sdkCreatePot` 정의·시그니처**: 태스크/스킬이 "주문=sdkCreatePot"로 기술하나, 디옵스 원본 소스(`deob_05/06/editor_sdk.js`, `editor_sdk_method_catalog.md`)에 **이 식별자의 라인 근거 없음**. HTML 분석 리포트(`RedPrinting_SDK_Deep_Analysis_Report.html` 2회·`RedPrinting_Widget_Analysis_Report.html` 1회)에만 등장(=2차 해설, 원본 소스 아님). → 실제 위젯의 장바구니 제출 함수명·페이로드 미상.
  - 확인된 인접 사실: Edicus 측 최종 주문 target = `definitiveOrder`(임시=`tentativeOrder`, 가능검사=`isReadyToOrder`) — `deob_editor_sdk.js:2784`.
- **U-5 PDF 주문 최종 제출 필드**: S3 업로드 후 주문 시 s3FileUrl/파일정보를 어떤 엔드포인트·필드로 제출하는지 라인 근거 없음. (S3Uploader는 emit까지만 확인 — `deob_06_app_widget_sdk.js:558-559`.)
- **U-9 호스트(상품페이지)↔위젯 주문 핸드오프**: `callbacks`(onOptionChange/onPriceChange/onOpenEditor 등)는 확인되나(`monitor_report.md:48-54`), 호스트가 canOrder 통과 후 실제 주문을 어디로 보내는지 미상.

## B. 업로드/에디터 분기 결정 규칙

- **U-2 uploadType 자동/수동 결정 규칙**: 어떤 상품이 PDF 탭만 / 에디터 탭만 / 둘 다 노출하는지를 서버가 어떻게 지시하는지 단일 라인 근거 없음. `uploadConfig{editor,pdf,token}`(buildUploadConfig)에 의존하나 디옵스 본문이 해당 구현을 생략(`deob_06_app_widget_sdk.js:580-590, 612-622`). 기본 탭이 "editor"인 것만 확인(`:781-783`).
- **U-3 presigned 엔드포인트 표기 차이**: 스킬 문서=`/api/aws/presigned`, 디옵스 주석=`/api/aws/presigned-url`(`deob_06_app_widget_sdk.js:552`). 정확한 절대 호스트(상대경로 vs `widget-api.redprinting.co.kr`) 미확인.
- **U-4 presigned URL 유효기간**: 미상(근거 없음).
- **U-6 KOI vs RP 에디터 타입 결정요인**: `setEditorData`가 `type==="KOI"`/그외(RP)로 분기(`deob_06_app_widget_sdk.js:1145`)하고 `division:"red_widget"`=KOI passive 신호(`editor_api_analysis.md:111-118`)는 있으나, 상품이 KOI/RP 중 무엇으로 열리는지 결정하는 라인 근거 부족.
- **U-7 createProject projectOptions 상품군별 채움 규칙**: `calendarConfig/customTabInfo/paletteCode/emptyDocument...`(`editor_sdk_method_catalog.md:85-94`)을 달력/굿즈 등 상품군별로 어떻게 구성하는지 미상.
- **U-10 vDigital_item PDF 가용성 단정 불가**: 코드상 vDigital_item도 `uploadType.default==="pdf"` 경로 존재(`deob_06_app_widget_sdk.js:1192`) → "vDigital_item=에디터 전용"은 코드 레벨에서 확정 불가. 상품 단위 가용성은 추정/모름.

## C. 데이터 불일치 (캡처 vs 문서)

- **U-8 아크릴(AC) price_gbn 불일치**: `monitor_report.md:170`=`tiered_price`, 실제 ACNTHAP 캡처(`cascade_captures/ACNTHAP_cascade.json`)=`vTmpl_price`. → 캡처를 권위로 채택(`vTmpl_price`). monitor_report 요약이 일반화 과정에서 부정확했을 가능성.

## D. 상품 코드 정의·매핑

- **U-11 캡처 상품코드 중 레거시 placeholder**: `LFXXXXX`(일반전단)·`PRLFXXX`(리플렛)의 `XXXXX`는 실제 상품코드가 아니라 캡처용 자리표시자로 보임(catalog에는 `LFXXXXX`/`PRLFXXX`로 등재). 이들 캡처는 `shadowHostCount=0`(레거시 시스템)이라 신위젯 대상 아님. 진짜 개별 상품코드 정의 미상.
- **U-13 BNSTDFT / STDRCAD 정의·시스템 귀속**: 캡처 존재하나 `shadowHostCount=0`(레거시). BNSTDFT=BN 배너(스탠드), STDRCAD=ST 카드스티커로 catalog 매칭은 되나, 신위젯 전환 여부·item_gbn 미상(레거시로 추정).
- **U-14 26 카테고리 중 신위젯 적용 범위**: `monitor_report.md:17`="새 위젯 확인 상품 약 25개(18 책자 + GS + AC)". GS(136)·AC(20) 카테고리 **전 상품**이 신위젯인지, 일부만인지 상품 단위 근거 없음 → `product-path-matrix.csv`에서 카테고리 행은 "추정". 나머지 22개 카테고리(BC/AH/AI/BN/BT/CL/EN/ET/FB/FS/HL/LF/ME/NC/OT/PD/PH/PM/PO/PV/SK/ST 및 PR 비책자)는 레거시 추정이나, 신위젯 전환분 존재 가능성 미상 → "모름(근거 없음)".

## E. 계층 1 (브릿지/로더)

- **U-12 `productRedWidgetSDK.js` 소스 근거**: 3계층 중 계층 1(브릿지·로더)는 `monitor_report.md:14`에서 이름만 확인. 역공학 산출물은 `widget.js`/`RedEditorSDK.min.js`만 디옵스 — `productRedWidgetSDK.js` 자체의 라인 단위 근거 없음(브릿지 역할=문서 서술 기반).

---

## 갱신 가이드
- 라이브 재캡처(widget_monitor 5탭·cascade) 또는 `deob_*` 추가 디옵스로 근거 확보 시 해당 U-항목을 `확인`으로 승격하고 `widget-architecture.md`/`path-branch-spec.md`/`product-path-matrix.csv` 대응 행을 동시 갱신.
- 특히 U-1(sdkCreatePot)·U-2(uploadType 규칙)·U-14(신위젯 범위)는 다운스트림 도해의 핵심 분기라 우선 해소 권장.
