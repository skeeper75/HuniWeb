# 위젯 런타임 명세 (SDK 로딩·Shadow DOM·스토어·API)

> 파이프라인 ① 산출물. seed-redprinting-sdk-analysis.md(정적) 기준선 위에 라이브 캡처로 검증·보강.
> 근거: `[라이브 검증]` localhost:3001 실응답 / `[정적 분석]` deob 소스·리포트 / `[추정]`

---

## 1. 3계층 아키텍처 [정적 분석 + 라이브 검증]

| 계층 | 파일 | 특성 | 역할 |
|------|------|------|------|
| 브릿지 | `productRedWidgetSDK.js` (자체 호스팅) | 33KB·비난독화·jQuery | 호스트 ↔ 위젯 글루, 20 명명 함수 |
| 런타임 | `widget.js` (CloudFront) | 438KB·Vue3+Pinia | Shadow DOM 렌더·스토어·API·가격표시 |
| 에디터 | `RedEditorSDK.min.js` (CloudFront) | 45 메서드 | Edicus 표지 디자인 에디터 |

CDN: `d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/prod/{widget.js,widget.css}`
API 호스트 [라이브 검증]: 본서버 `www.redprinting.co.kr`, 위젯API `widget-api.redprinting.co.kr`, 메이커스 `makers.redprinting.net`, 에디터 `edicusbase.firebaseapp.com`, 에셋 `d3qehkb69dy9zc.cloudfront.net`.

## 2. Shadow DOM 마운트 [정적 분석]

```
form#product_form > ... > div#redWidgetSdk (Shadow Host)
  > #shadow-root(open) > link[widget.css] > div#red-widget-root (Vue3 App + $pinia)
      > div.widget-container > div.widget-body > N fieldset.option-row
```

## 3. Pinia 스토어 (상품군별 차이 확정) [라이브 검증]

seed의 4 vs 5 불일치를 라이브 product_info 구조로 **확정**:

| 스토어 | 사용 인스턴스 | 근거 |
|--------|--------------|------|
| `useConfigStore` | 공통 | 위젯 설정 |
| `useProductStore` | 공통 (책자·부자재 공유) | `getProductBaseInfo()` — deob_06:1313 |
| `useOrderStore` | 책자/일반(`CommonWidgetInstance`) | orderData(sizeInfo/dosuInfo/...) |
| `useAccOrderStore` | **부자재(`AccWidgetInstance`)** — deob_06:1309 | subMtrlInfo 기반 |
| `useExteriorStore` | 책자(표지/내지 외형) | exterior |

→ **확정**: 4개(config/product/order/exterior)는 책자류, 부자재(ACC) 인스턴스는 order 대신 **acc-order** 사용 = 상품군별로 useOrderStore↔useAccOrderStore 가 갈린다. seed 가설(상품군별 차이) 라이브 데이터로 입증.
- 라이브 증거: 책자(PRBKYPR) product_data에 `inner_pdt_*` 4개 데이터셋 존재 → 내지/표지 분리(exterior+order). 굿즈(GSTGMIC)·아크릴(ACNTHAP)에는 `inner_*` 없음 → 단순 order/acc-order. [라이브 검증]

## 4. product_data 데이터셋 (상품군별) [라이브 검증]

| 데이터셋 | 책자 PRBKYPR | 굿즈 GSTGMIC | 아크릴 ACNTHAP |
|----------|:---:|:---:|:---:|
| pdt_base_info | ✓ | ✓ | ✓ |
| pdt_mtrl_info (자재) | ✓ | ✓ | ✓ |
| pdt_size_info (규격) | ✓ | ✓ | ✓ |
| pdt_dosu_info (도수) | ✓ | ✓ | ✓ |
| pdt_bnc_info / pdt_dosu_bnc_info | ✓ | - | - |
| pdt_prn_cnt_info(+_add, exp) | ✓ | ✓ | ✓ |
| pdt_pcs_info (후가공) | ✓ (20) | ✓ (11) | ✓ (4) |
| pdt_add_pcs_info | ✓ | ✓ | ✓ |
| pdt_disable_pcs_info (캐스케이드 제약) | ✓ (24) | ✓ (0) | ✓ (0) |
| inner_pdt_mtrl/dosu/bnc/dosu_bnc_info | ✓ (4) | - | - |
| pdt_add_info | ✓ | ✓ | ✓ |
| option_info (제작방식/형태/인쇄데이터) | - | - | ✓ |

`product_option.option` 공통 필드 [라이브 검증]:
`pdt_cod, pdt_nme, item_gbn, price_gbn, skinInfo, order_yn, cut_guide_yn, able_paper_yn, price_table_yn, useTemplateDownload, useKoiEditor, useRPEditor, usePDF, usePDFordCnt, useEditorOrdCnt, koiAccessToken, rpAccessToken, koi_template_resource_id, koiOption`

## 5. 핵심 6 API [라이브 검증]

| # | 엔드포인트 | 메서드 | 인증 | 라이브 |
|---|-----------|--------|------|--------|
| 1 | `/ko/product/get_digital_product_info?pdt_cod=` | GET | 쿠키 | ✓ 200 (3상품 캡처) |
| 2 | `/ko/product_price/get_ajax_price_vTmpl` | POST | 쿠키 | ✓ 200 (8조합) |
| 3 | `/api/aws/presigned-url` (widget-api) | POST | 쿠키+토큰 | ✓ 200 (PUT까지 검증) |
| 4 | `/api/editor/config/{KOI\|RP}` (widget-api) | POST | 쿠키+토큰 | ✓ 위젯경로 200 (직접호출 프록시이슈) |
| 5 | `/ko/product/s3GetObjectJson` | POST | 쿠키 | [정적] 파일메타 조회 |
| 6 | `/ko/product/guide_product_paper` | POST | 쿠키 | [정적] 자재가이드 |
| (보조) | makers-api `/token`,`/editor`,`/template/*` | POST/PUT/GET | 쿠키+토큰 | ✓ 일부 200 |

인증 모델 [정적+라이브]: **세션 쿠키 only** (본서버) + **red-editor-token JWT 헤더**(widget-api/makers-api). Authorization/Bearer/CSRF/API키 없음. JWT 만료 ~55분(자동 갱신). `base64ID="redprinting_nomember"`는 단순 인코딩(보안 아님).

## 6. 브릿지 글로벌 함수 (호스트 통합 API 기준) [정적 분석]

`sdkInit`/`fnInitSdk`(초기화), `sdkOptionChange`(옵션변경→가격재계산), `sdkInformMaterials`(자재전달), `sdkOpenEditor`/`fnKoiEditor*`/`fnRpEditor*`(에디터), `sdkEditorCheck`, `sdkPrintAreaGuide`/`sdkGuide`(가이드), `sdkCreatePot`(주문데이터→submit), `fnPreOrder`/`fn_order_able`(주문검증), `fnCalcPriceTable`(가격표), `fnEstimate`(견적서).

→ 후니 위젯의 호스트 통합 이벤트/콜백 API를 이 함수군에 매핑(CustomEvent 또는 콜백 prop).

## 7. 데이터 흐름 [정적+라이브]

```
호스트 sdkInit(pdt_cod)
  → GET get_digital_product_info → ProductStore.baseInfo 적재(16~18 데이터셋)
  → 위젯 옵션 UI 렌더(fieldset N개)
사용자 옵션 변경
  → OrderStore 갱신 → debounce → POST get_ajax_price_vTmpl(ORD_INFO+PCS_INFO)
  → result_sum 표시(3단 워터폴: MALL/할인/정가 + VAT + 배송비)
표지 디자인
  → PDF 탭: 파일선택 → POST presigned-url → PUT S3 → fileUploadInfo
  → 에디터 탭: editor/config/KOI → Edicus iframe → from-edicus(save-doc-report→goto-cart) → projectID
주문
  → fn_order_able 검증 → sdkCreatePot(주문데이터 생성) → 호스트 form submit
```

## 8. 잔존 미검증

- 에디터 iframe 실구동 메시지 타임라인(editor-bridge-protocol.md §9 참조). [미검증]
- editor/config 직접 호출 페이로드 형태(프록시 이슈로 본 세션 직접 검증 불가, 위젯 경로는 검증). [부분]
- 비책자(굿즈/아크릴) 가격 페이로드. [미검증]
