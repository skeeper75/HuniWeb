# gate-verdict.md — Huni-Widget-Flow 독립 검증 (F1~F6)

> 검증가: hwf-validator (독립 게이트, 생성≠검증) · 직접 재실측: deob_* 소스 + widget_monitor 캡처
> 권위=역공학 원본(읽기전용). 생성자 "근거 있음" 주장 비신뢰 — 모든 표본 인용을 원본에서 직접 sed/grep/python 대조.

## 종합 판정: **GO** (CONDITIONAL — 사소한 출처 표기 정정 1건, curator 라우팅)

핵심 게이트 F3(경로 분기)·F4(26 커버리지) 모두 PASS. 표본 인용 전건 원본 일치, 미상 정직 표기 정확.
유일한 결함은 U-1 보조 출처 표기 오류 1건으로, **어떤 mermaid/이미지에도 영향 없음**(sdkCreatePot은 전 산출에서 올바르게 미상·점선 처리). 따라서 GO를 막지 않는 CONDITIONAL.

---

## F1 근거 실재성 — **PASS**

표본 인용을 deob_* 원본에서 직접 라인 대조. 전건 일치.

| 인용 | 주장 | 원본 실측 | 판정 |
|------|------|-----------|------|
| deob_06:30-42,936 | RedWidgetSDK(clientKey) throw, ALLOWED=["red-mobile","red-pc"] | 정확 일치 (constructor + ALLOWED_CLIENT_KEYS) | ✓ |
| deob_06:79-94,939 | isCommonProduct=!ACC.has, ACC={GSSBMTL,GSSBSTP,GSSBACM}, editorData reactive provide | 정확 일치 | ✓ |
| deob_06:780-814 | uploadType={default:"editor"}, setUploadType, isAfterEdit 공식 | 정확 일치 (라인까지) | ✓ |
| deob_06:1155-1215 | canOrder 전 분기 로직 | 정확 일치 (아래 F3 참조) | ✓ |
| deob_05:1085-1110 | fetchProductInfo GET .../product/get_digital_product_info?pdt_cod= | 정확 일치 | ✓ |
| deob_05:1129-1154 | fetchPriceCalculation POST get_ajax_price_vTmpl, body {dataJson} | 정확 일치 | ✓ |
| deob_06:542-561 | S3Uploader 5단계 + /api/aws/presigned-url | 정확 일치 (구현부 elided 명시도 사실) | ✓ |
| editor_sdk_method_catalog:304-313 | EditorBridge/ApiClient/iframe base url | 정확 일치 | ✓ |
| editor_sdk_method_catalog:233-242 | 22 이벤트 목록 | 정확 일치 (22개 전수) | ✓ |
| deob_editor_sdk:11385-11398 | save-doc-report end → isReadyToOrder(close/goto-cart) | 정확 일치 | ✓ |
| deob_editor_sdk:2784 | definitiveOrder/tentativeOrder/isReadyToOrder/cancelOrder | 일치 | ✓ |
| 5 Pinia store (deob_06:717/754/780/822/850) | config/product/exterior/order/acc-order | defineStore 5건 정확 일치 | ✓ |

**날조/과장 인용 0.** 라인 번호가 실제 위치와 정확히 맞음(통상 ±수 라인 오차도 거의 없음).

---

## F2 구조 정확성 — **PASS**

`02_mermaid/00_architecture.md` (a)아키텍처·(b)시퀀스·(c)라이프사이클·(d)presigned 4 도해 검증.

- **3계층**: 브릿지/로더(productRedWidgetSDK.js) → widget.js(Vue3+Pinia, Shadow DOM open) → RedEditorSDK iframe. 원본 monitor_report:10-18 + deob 구조와 일치.
- **Shadow DOM 경계**: attachShadow(open)·#red-widget-root·widget.css cloudfront 주입 — deob_06:71-98 일치.
- **Pinia 5 스토어** 노드: config/product/order/exterior/acc-order — defineStore 5건과 정확 일치.
- **API 엔드포인트**: get_digital_product_info(GET) / get_ajax_price_vTmpl(POST dataJson) / presigned-url+S3 PUT — 전건 원본 일치.
- **postMessage 양방향**(L3↔iframe), createProject 화살표, definitiveOrder target — 일치.
- **라이프사이클 stateDiagram**: init→ready-to-listen→doc-changed→project-id-created→save-doc-report→goto-cart/close→isReadyToOrder. SIMULATOR_GUIDE:35-41 + deob_editor_sdk:11385-11398 일치. ready-to-listen note(캡처 미출현)도 점선 처리 정확.

잘못된 화살표·없는 노드 0건. 출처 classDef(CDN/자체서버/Edicus) 구분 정확.

---

## F3 경로 분기 정합 [핵심] — **PASS**

canOrder() 전 분기를 deob_06:1155-1215 원문과 1:1 대조. **분기 결정요인·시퀀스 전건 정확, 역전 0.**

- **결정요인 = item_gbn + exterior.uploadType[key]** — 코드 그대로(`itemGroup`, `uploadTypeState`).
- **기본 탭=editor**: `uploadType=reactive({default:"editor"})` 코드 확인.
- **책자(book2025_item)**: uploadType 키별(inner/default) 순회, editor→isAfterEdit(key), pdf→파일슬롯+파일명중복. **슬롯 매핑 [0]=inner, [1]=default(표지)**도 코드(`uploadKey==="inner" && !fileUploadInfo[0]` / `"default" && !fileUploadInfo[1]`)와 정확 일치.
- **uploadType.default==="pdf"**: fileUploadInfo[0] 필수, clothes+PTP_SLK→pantone 필수 — 코드 일치.
- **clothes2025_item & !printType.COD → 통과** — 코드 일치.
- **uploadType.default==="editor" & !isAfterEdit() & dosuInfo.COD!=="SID_X" → 에디터 필요** — 코드 일치.
- **vDigital_item PDF 경로 코드상 존재** → "에디터 전용 단정 불가"(U-10)는 코드로 입증되는 정직한 판단. 명제 검증(§4)이 가설을 코드로 반증한 점 우수.
- **price_gbn 실측**: PRBKORD=book2025_price, GSTGMIC=tiered_price, ACNTHAP=vTmpl_price — cascade 캡처 직접 추출로 전건 일치.

mermaid product-flows §2(패턴A)·§3(패턴B)의 분기 흐름이 canOrder 코드와 일치. PDF 경로 점선(패턴B)·종단 미상 점선 처리 정확.

---

## F4 26 카테고리 커버리지 — **PASS**

`redprinting_catalog.json` python 직접 추출: **distinct category = 26** (총 479상품).
matrix·mermaid product-flows §1.1 모두 26 전수 커버 — 누락 0, 초과 0 (set diff 공집합).

- 패턴 A=PR(책자분), B=GS·AC, C=23+PR비책자. 합계 26 정합.
- 레거시 확인분(BC/BN/LF/ST) shadowHostCount=0 — 6개 캡처(BCSPDFT/BCSPHIG/BNSTDFT/LFXXXXX/STDRCAD/PRLFXXX) 직접 확인, 전건 widgetInfo.shadowHostCount=0·mountPoints=[].
- 신위젯 확인분(GSTGMIC) shadowHostCount=1 확인.
- 카테고리별 catalog count 정합(GS=136, AC=20, PR=56 등). 상세=`coverage-check.csv`.

---

## F5 이미지↔사실 정합 — **PASS**

codex 4장 PNG 육안 직접 확인(Read 임베드).

| 이미지 | 사실 정합 | 한글 깨짐 | 가독성 | 판정 |
|--------|-----------|-----------|--------|------|
| journey-overall | 5단계 + Step3 업로드/에디터 fork→merge → 가격 → 주문. 분기가 가격 전 합류 정확 | 없음(영어만) | 우수 | ✓ |
| product-groups | A=Booklets(both), B=Goods/Acrylic(Editor-focused), C=Legacy Upload-centric(Cards/Flyers/Stickers/Banners). 3패턴 정확 | 없음 | 우수 | ✓ |
| path-compare | Upload 4단계 vs Editor 5단계, 둘 다 Ready to order 수렴. spec와 단계수 일치 | 없음 | 우수 | ✓ |
| representative-journeys | Booklet Cover+Inner 각 Upload/Editor "Both OK"; Goods/Acrylic Editor "Primary"+Upload dimmed "Editor-focused" | 없음 | 우수 | ✓ |

환각 단계·오분류·텍스트 깨짐 0. 비전문가 가독성 양호. 영어 라벨 전략으로 한글 렌더 문제 회피 성공.

---

## F6 미상 정직성 — **PASS** (보조 출처 표기 정정 1건 → CONDITIONAL 사유)

unknowns-board 14건이 mermaid/이미지에서 확정 사실로 위장되지 않았는지 점검.

- **U-1 sdkCreatePot**: 핵심 주장("deob 소스에 라인 근거 없음")을 grep으로 직접 검증 — deob_* 전건 0건 확인. ✓ 정직.
  mermaid (b)에서 호스트 주문 제출을 점선+`%% 역공학 미확인 U-1/U-5/U-9`로, 이미지에서도 sdkCreatePot 미등장. **확정 위장 0.**
  - ⚠ **정정 1건(curator 라우팅)**: unknowns-board.md U-1·widget-architecture.md:138은 sdkCreatePot가 "SIMULATOR_GUIDE.md·editor_monitor_GSTGMIC.json에서만 등장"이라 했으나, 정확 리터럴 grep 결과 그 두 파일엔 **0회**, 실제로는 `docs/reversing/RedPrinting_SDK_Deep_Analysis_Report.html`·`RedPrinting_Widget_Analysis_Report.html`에 등장. → 보조 출처 표기 오류(핵심 "deob 근거 없음" 결론은 옳음). 영향: 다운스트림 도해/이미지에 전혀 반영 안 됨(전부 미상 처리). **GO 비차단.**
- **U-2 uploadType 자동/수동 결정 규칙**: buildUploadConfig 구현부가 deob에서 elided(deob_06:561 "구현은 원본 mod_06 line 2031~2165와 동일 구조"로 확인). mermaid가 점선+미확인 표기. ✓
- **U-8 AC price_gbn**: monitor_report:170=tiered_price vs ACNTHAP 캡처=vTmpl_price 불일치 — 캡처 권위 채택, mermaid 패턴B에 vTmpl_price 반영. 직접 재실측으로 캡처가 옳음 확인. ✓
- **U-10/U-14 신위젯 범위·vDigital PDF 가용성**: 이미지 4가 "Editor-focused"(전용 아님)로, 이미지 2 manifest가 "그룹 경향·전상품 단정 아님" 명시. ✓
- **ready-to-listen 0회**(GSTGMIC editor_monitor): python count 직접 확인 0회 — spec 주장 정확, stateDiagram note로 정직 표기. ✓

미상의 결론 위장 0(보조 출처 표기 1건 제외). **F6 본질=PASS.**

---

## 수정 라우팅

| 결함 | 심각도 | 라우팅 | 조치 |
|------|--------|--------|------|
| U-1 sdkCreatePot 보조 출처 표기 오류(SIMULATOR_GUIDE/editor_monitor → 실제는 HTML 리포트 2종) | Low(비차단) | **curator** (unknowns-board.md U-1, widget-architecture.md:138) | "SIMULATOR_GUIDE·editor_monitor" → "RedPrinting_SDK_Deep_Analysis_Report.html·RedPrinting_Widget_Analysis_Report.html"로 정정. 결론(deob 근거 없음)은 유지. |

> 그 외 mermaid-author·visualizer 라우팅 결함 없음(F2/F3/F5 전건 PASS).

## 결론
**GO (CONDITIONAL)** — 산출 전반이 역공학 사실에 충실하고, 핵심 분기(F3)·커버리지(F4)·이미지 정합(F5)·미상 정직(F6)이 모두 통과. curator의 Low 정정 1건은 신뢰 차단 사유 아님이며, 적용 시 차기 검증에서 clean GO.
