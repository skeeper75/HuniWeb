# 시퀀스 다이어그램 (구현 등급)

> 파이프라인 ② 산출물. 모든 다이어그램은 라이브 관찰(`02_analysis/captures/`) 또는 Phase 1 캡처에 근거.
> 근거: `[라이브 관찰]` 본 세션 실측 / `[정적+라이브]` Phase 1 재확인 / `[정적 분석]` deob 소스.
> 식별자(함수·엔드포인트·이벤트)는 후니 구현가가 직접 참조 가능하도록 실제 명칭 사용.

---

## 1. 초기화 (상품 선택 → 위젯 마운트 → 첫 가격) [라이브 관찰]

```mermaid
sequenceDiagram
    autonumber
    participant Host as 호스트 페이지
    participant SDK as 브릿지 SDK(productRedWidgetSDK.js)
    participant Widget as Vue3 위젯(Shadow DOM)
    participant PS as ProductStore
    participant OS as OrderStore
    participant RP as www.redprinting.co.kr

    Host->>SDK: sdkInit(pdt_cod) / createWidget
    SDK->>Widget: mount #redWidgetSdk (Shadow DOM open)
    Widget->>RP: GET /ko/product/get_digital_product_info?pdt_cod=
    RP-->>Widget: 200 product_data (16~18 데이터셋)
    Widget->>PS: setBaseInfo(product_data)
    Widget->>OS: 기본 옵션으로 orderData 초기화<br/>(sizeInfo/dosuInfo/meterialInfo/quantityInfo)
    Widget->>Widget: 옵션 UI 렌더(fieldset N개)
    Note over Widget,RP: 마운트 직후 기본옵션 가격 자동 호출 [라이브 관찰]
    Widget->>RP: POST /ko/product_price/get_ajax_price_vTmpl<br/>{dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}
    RP-->>Widget: 200 {result, result_sum, result_log, book_info}
    Widget->>Host: 가격 표시(result_sum 3단 워터폴 + VAT + 배송비)
    Note right of Widget: 총 소요 ~4.6s (initDurationMs) [라이브 관찰]
```

## 2. 옵션 변경 → 가격 재계산 (디바운스) [라이브 관찰]

```mermaid
sequenceDiagram
    autonumber
    participant User as 사용자
    participant Widget as Vue3 위젯
    participant OS as OrderStore
    participant Cascade as 캐스케이드 룰<br/>(pdt_disable_pcs_info)
    participant RP as www.redprinting.co.kr

    User->>Widget: 옵션 변경 (규격/자재/수량/색상/후가공 select·input)
    Widget->>OS: orderData 즉시 갱신
    alt 자재(MTRL_CD) 변경
        Widget->>Cascade: lookup disable_pcs_info[MTRL_CD]
        Cascade-->>Widget: 비활성 PCS_CD 목록
        Widget->>OS: 해당 후가공 disable + 선택돼있었으면 해제
    end
    Note over Widget,RP: 디바운스 ~300ms (관찰 지연 ~360ms) [라이브 관찰]
    Widget->>Widget: debounce(300ms) — 연속변경 시 마지막만
    Widget->>OS: priceCalc.params 조립(ORD_INFO+PCS_INFO)
    Widget->>RP: POST /ko/product_price/get_ajax_price_vTmpl
    RP-->>Widget: 200 result_sum
    Widget->>User: 가격 표시 갱신
    Note right of Widget: 응답 동일 옵션 30s 캐시(TTL) — 정적 근거 [정적 분석]
```

## 3. 에디터 열기 (표지 디자인) [라이브 관찰 — 잔존#1 해소]

```mermaid
sequenceDiagram
    autonumber
    participant User as 사용자
    participant Widget as Vue3 위젯
    participant Ext as ExteriorStore
    participant WAPI as widget-api.redprinting.co.kr
    participant MAPI as makers.redprinting.net
    participant Host as 호스트(onOpenEditor)
    participant EdSDK as RedEditorSDK
    participant Iframe as Edicus iframe<br/>(edicusbase.firebaseapp.com)

    User->>Widget: "에디터" 탭 → "편집하기" 클릭
    Widget->>Ext: payloadForEditorConfig.default 조립
    Widget->>WAPI: POST /api/editor/config/KOI {pdt_cod, sizeInfo, pcsInfo,...}
    WAPI-->>Widget: 200 {config:{psCode,templateUrl,resource_id,token}, option:{pluginCustomData}}
    Widget->>Host: onOpenEditor(KOI config)
    Host->>EdSDK: new RedEditorSDK({accessToken, userId, locale})
    EdSDK->>MAPI: POST /token {type:verify}
    MAPI-->>EdSDK: 200 {refreshToken}
    EdSDK->>MAPI: POST /editor (issueUserToken / getProductInfo)
    MAPI-->>EdSDK: 200 {token(Firebase JWT), product{edicusCode,...}}
    EdSDK->>MAPI: PUT /v1/template/{base64(templateUrl)}/hit
    MAPI-->>EdSDK: 200
    EdSDK->>Iframe: createProject — iframe src=/ed#/editor_landing?cmd=create&token=&ps_code=&...
    Note over Iframe,Host: ↓ from-edicus postMessage (origin=edicusbase) [라이브 관찰]
    Iframe-->>Host: from-edicus: load-project-report {status:"start", ps_code}
    Iframe-->>Host: from-edicus: ready-to-listen
    Iframe-->>Host: from-edicus: doc-changed {ps_code,page_count,template_uri,div,vdp_catalog}
    Iframe-->>Host: from-edicus: request-prod-info {}
    Host->>Iframe: (deferred) to-edicus-root: send-extra-param {prod_info,options} [정적]
    Iframe-->>Host: from-edicus: project-id-created {project_id}
    Iframe-->>Host: from-edicus: load-project-report {status:"end", project_id, edicus_user_id}
    Host->>Ext: editorData.default = {projectID,...}
```

## 4. 에디터 저장 → 장바구니 (편집 완료) [정적 + 테스트베드 핸들러]

```mermaid
sequenceDiagram
    autonumber
    participant User as 사용자
    participant Iframe as Edicus iframe
    participant Host as 호스트 핸들러(index.html)
    participant OS as OrderStore/ExteriorStore
    participant Submit as 주문 submit

    User->>Iframe: 캔버스 편집 → 저장/완료 클릭
    Iframe-->>Host: from-edicus: save-doc-report {phase:"start"}
    Iframe-->>Host: from-edicus: save-doc-report {phase:"end",<br/>docInfo:{projectID,psCode,tnUrlList[],totalPageCount}}
    Host->>Host: window.__lastEditorDocInfo = docInfo
    Iframe-->>Host: from-edicus: goto-cart {projectID, tnUrlList, totalPageCount, case}
    Host->>Host: 완료 페이로드 조립<br/>{projectID, tnUrlList(||docInfo), totalPageCount, case}
    Host->>OS: 주문데이터에 projectID·썸네일·페이지수 반영
    Host->>Host: editorOverlay 닫기 + 스토어 스냅샷 갱신
    Note over Host,Submit: 주문가능 시 fn_order_able→sdkCreatePot→form submit
    Host->>Submit: 주문 진행
    Note right of Host: save-doc-report/goto-cart는 본 세션 미트리거<br/>(편집 미수행) — 정적+핸들러 근거 [부분]
```

## 5. PDF 업로드 (S3 presigned) [정적+라이브, Phase 1]

```mermaid
sequenceDiagram
    autonumber
    participant User as 사용자
    participant Uploader as S3Uploader 컴포넌트
    participant WAPI as widget-api.redprinting.co.kr
    participant S3 as s3.ap-northeast-2 (redprintingweb.tempo)
    participant RP as www.redprinting.co.kr
    participant OS as OrderStore

    User->>Uploader: PDF 파일 선택 (내지=inner / 표지=default)
    Uploader->>Uploader: 검증(application/pdf, ≤1GB) [정적]
    Uploader->>WAPI: POST /api/aws/presigned-url {file_name,pdt_cod,content_type}
    WAPI-->>Uploader: 200 {filename(UUID), presignedURL(X-Amz-Expires=3600)}
    Uploader->>S3: PUT presignedURL (PDF binary, Content-Type:application/pdf)
    S3-->>Uploader: 200 (빈 본문)
    Uploader->>RP: POST /ko/product/s3GetObjectJson {file_name:UUID.pdf}
    RP-->>Uploader: 200 파일메타(크기/페이지)
    Uploader->>OS: fileUploadInfo[] ([0]=inner, [1]=default)
    Note right of OS: 둘 다 필수일 때 누락→주문불가-파일<br/>org_file_nm 중복→주문불가-파일명중복 [정적]
```

## 6. 주문 가능성 판정 (canOrder) [정적 분석]

```mermaid
sequenceDiagram
    autonumber
    participant Widget as 위젯
    participant Validator as fn_order_able / getSummary
    participant OS as OrderStore
    participant Host as 호스트

    Widget->>Validator: 옵션·파일·가격 변경마다 재평가
    Validator->>OS: 필수옵션 선택? 표지/내지 입력(에디터/PDF) 완료?<br/>수량 MIN_PRN 충족? 가격 산정 성공?
    alt 모두 충족
        Validator-->>Widget: canOrder = true → 주문 버튼 활성
    else 미충족
        Validator-->>Widget: canOrder = false + 사유(주문불가-파일/수량/옵션)
    end
    Widget->>Host: 주문 클릭 → sdkCreatePot(주문데이터) → form submit
```

---

## 참고: 호스트 ↔ 에디터 메시지 방향 요약 [정적+라이브]

| 방향 | type | 라이브 관찰 액션 |
|------|------|----------------|
| iframe→호스트 | `from-edicus` | load-project-report, ready-to-listen, doc-changed, request-prod-info, project-id-created [라이브] / save-doc-report, goto-cart, close [정적] |
| iframe→호스트 | `from-edicus-private` | waiting-for-extra-param, waiting-for-ddp-data (SDK 자체처리) [정적] |
| 호스트→iframe | `to-edicus-root` | send-extra-param, send-ddp-data, change-project [정적] |
| 호스트→iframe | `to-edicus` | change-layout, set-item-attribute, add-page ... [정적] |
