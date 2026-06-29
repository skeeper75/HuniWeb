# RedPrinting Widget Monitoring Report

> 작성일: 2026-03-31
> 대상: www.redprinting.co.kr 위젯 동작 분석

---

## Executive Summary

레드프린팅은 두 가지 별개의 주문 시스템을 운영한다:

| 시스템 | 대상 상품 | 스크립트 | Shadow DOM |
|--------|-----------|----------|------------|
| **새 위젯** (Vue 3 + Pinia) | 책자(PRBKY*, PRBKO*), 굿즈(GS), 아크릴(AC) | `productRedWidgetSDK.js` + `widget.js` | ✓ (open mode) |
| **레거시** | 명함, 전단지, 스티커, 리플렛, 배너 등 400+개 | `product.js`, `product_sticker.js` | ✗ |

새 위젯 확인 상품: **약 25개** (18개 책자 + GS 카테고리 + AC 카테고리)

---

## 새 위젯 적용 상품군

### 책자 (PRBKY* — 윤전, PRBKO* — 토너)
```
PRBKYPR, PRBKYCO, PRBKYRN, PRBKYST, PRBKYSL, PRBKYPB, PRBKYCB, PRBKYRB  (윤전 8종)
PRBKORD, PRBKOCD, PRBKOPR, PRBKOCO, PRBKORN, PRBKOST, PRBKOSL, PRBKOPB, PRBKOCB, PRBKORB  (토너 10종)
```

### 부자재/굿즈
- GS 카테고리 (예: GSTGMIC — 마이크 네임택)
- AC 카테고리 (예: ACNTHAP — 아크릴 명찰)

---

## Widget SDK 초기화 패턴 (역공학 확인)

```javascript
// 1. SDK 인스턴스 생성 (clientKey 필수)
const sdk = new RedWidgetSDK("red-pc");  // "red-pc" | "red-mobile"

// 2. 위젯 마운트
sdk.init({
  target: "#redWidgetSdk",     // 마운트 DOM 선택자
  pdtCode: "PRBKORD",          // 제품 코드
  pttCode: "",                 // 패턴 코드 (선택)
  locale: "ko",                // "ko" | "en"
  member: { mb_id: "", mb_cust_cod: "", base64ID: "" },
  deviceType: "pc"             // "pc" | "mobile"
}, {
  onOptionChange: (data) => {},
  onPriceChange: (data) => {},
  onOpenEditor: (data) => {}
});
```

**Shadow DOM 구조**:
```
div#redWidgetSdk
  └── #shadow-root (mode: open)
        └── div#red-widget-root  ← Vue 3 createApp 마운트
```

---

## API 구조 (실측 확인)

### GET /ko/product/get_digital_product_info
```
쿼리 파라미터: pdt_cod=PRBKORD
응답: {
  retCode: 200,
  result: {
    product_option: {
      option: {
        pdt_cod, pdt_nme, item_gbn, price_gbn,
        skinInfo: {
          paperSelect: { view_yn, title },
          sizeSelect: { view_yn, title },
          dosuSelect: { view_yn, title },
          subjectGroup: { view_yn, title },
          quantityGroup: { view_yn, title: { orderCnt, printCnt } }
        }
      }
    },
    product_data: { ... },
    member_info: { ... }
  }
}
```

### POST /ko/product_price/get_ajax_price_vTmpl

**책자 request body**:
```json
{
  "dataJson": {
    "ORD_INFO": [{
      "PDT_CD": "PRBKORD",
      "CUT_WDT": 210, "CUT_HGH": 297,
      "WRK_WDT": 220, "WRK_HGH": 307,
      "PRN_CNT": 1, "PAGE_CNT": 2,
      "CVR_CLR_CNT": 8, "INN_CLR_CNT": 8,
      "CVR_MTRL_CD": "RXART250",
      "INN_MTRL_CD": "RXOMO080"
    }],
    "PCS_INFO": [
      { "PCS_COD": "CUT_DFT", "PCS_DTL_COD": "DFXXX", "ATTB": "" },
      { "PCS_COD": "CVR_UNT", "PCS_DTL_COD": "DFXXX", "ATTB": "" },
      { "PCS_COD": "RIN_DFT", "PCS_DTL_COD": "BPLFT", "ATTB": "RIN_BLK" },
      { "PCS_COD": "ADC_PVC", "PCS_DTL_COD": "DFXXX" },
      { "PCS_COD": "BIND_DIRECTION", "PCS_DTL_COD": "BPLFT" }
    ],
    "price_gbn": "book2025_price"
  }
}
```

**굿즈/부자재 request body** (GSTGMIC):
```json
{
  "dataJson": {
    "ORD_INFO": [{
      "PDT_CD": "GSTGMIC",
      "MTRL_CD": "RXBVW300",
      "CUT_WDT": 351, "CUT_HGH": 241,
      "WRK_WDT": 355, "WRK_HGH": 245,
      "PRN_CNT": 1, "ORD_CNT": 1,
      "DOSU_COD": "SID_S", "PRN_CLR_CNT": 4
    }],
    "PCS_INFO": [
      { "PCS_COD": "WRK_MTR", "PCS_DTL_COD": "TG001", "ATTB": 1 },
      { "PCS_COD": "COT_DFT", "PCS_DTL_COD": "TCGLS", "ATTB": "" },
      { "PCS_COD": "PDT_WRK", "PCS_DTL_COD": "PKT01", "ATTB": "" },
      { "PCS_COD": "PAK_POL", "PCS_DTL_COD": "DFXXX", "ATTB": "" },
      { "PCS_COD": "THO_CUT", "PCS_DTL_COD": "TG001", "ATTB": "" }
    ],
    "price_gbn": "tiered_price"
  }
}
```

**공통 응답 구조**:
```json
{
  "retCode": 200,
  "result": [
    {
      "PCS_CD": "string",     "PCS_DTL_CD": "string",
      "PCS_COD": "string",    "PCS_DTL_COD": "string",
      "PRICE": 1900,          "PRICE_VAT": 190,
      "PRICE_MALL": 1900,     "PRICE_MALL_VAT": 190,
      "ORG_PRICE": 1900,      "ORG_PRICE_VAT": 190,
      "PRICE_LOG": "string",  "PRICE_MALL_LOG": "string"
    }
  ],
  "result_sum": { ... },
  "book_info": { ... },   // 책자만 존재
  "seneca_info": { ... }  // 책자만 존재
}
```

---

## 상품 타입별 item_gbn / price_gbn

| 상품 타입 | item_gbn | price_gbn |
|-----------|----------|-----------|
| 책자 (윤전/토너) | `book2025_item` | `book2025_price` |
| 굿즈 네임택 (GS) | `vDigital_item` | `tiered_price` |
| 아크릴 명찰 (AC) | `vDigital_item` | `tiered_price` |

---

## Pinia 스토어 구조

4개 스토어가 모든 상품 타입에 공통 사용:

| 스토어 | 초기 상태 키 | 역할 |
|--------|-------------|------|
| `config` | `locale` | 언어 설정 |
| `product` | `baseInfo` (→ product_option, product_data) | 상품 정보 |
| `order` | `orderData` | 현재 주문 옵션 상태 |
| `exterior` | `uploadType`, `editorData` | 파일 업로드 / 에디터 연동 |

**Shadow DOM 내 Pinia 접근법**:
```javascript
// window.__pinia 는 null — Shadow DOM 안쪽에 격리
// 올바른 접근법:
const tryGetPinia = (root) => {
  for (const el of root.querySelectorAll('*')) {
    const vueApp = el.__vue_app__;
    if (vueApp) {
      const pinia = vueApp._context?.provides?.pinia;
      if (pinia?.state?.value) return pinia.state.value;
    }
    if (el.shadowRoot) {
      const r = tryGetPinia(el.shadowRoot);
      if (r) return r;
    }
  }
};
```

---

## ORD_INFO 필드 차이 정리

| 필드 | 책자 | 굿즈/부자재 |
|------|------|-------------|
| `PDT_CD` | ✓ | ✓ |
| `CUT_WDT`, `CUT_HGH` | ✓ (재단 크기) | ✓ |
| `WRK_WDT`, `WRK_HGH` | ✓ (작업 크기) | ✓ |
| `PRN_CNT` | ✓ (인쇄부수) | ✓ |
| `PAGE_CNT` | ✓ (내지장수) | ✗ |
| `CVR_MTRL_CD` | ✓ (표지재질) | ✗ |
| `INN_MTRL_CD` | ✓ (내지재질) | ✗ |
| `CVR_CLR_CNT` | ✓ (표지도수) | ✗ |
| `INN_CLR_CNT` | ✓ (내지도수) | ✗ |
| `MTRL_CD` | ✗ | ✓ (단일재질) |
| `ORD_CNT` | ✗ | ✓ (주문건수) |
| `DOSU_COD` | ✗ | ✓ (도수코드) |
| `PRN_CLR_CNT` | ✗ | ✓ (인쇄도수) |

---

## 로컬 시뮬레이터

```
_workspace/widget_monitor/local/
├── server.js       Express 프록시 (포트 3001)
├── index.html      위젯 테스트 페이지
├── widget.js       심볼릭 링크 → 00_raw/widget.js
└── widget.css      심볼릭 링크 → 00_raw/widget.css
```

실행: `cd _workspace/widget_monitor/local && node server.js`
접속: `http://localhost:3001?pdt=PRBKORD`
콘솔: `getStoreSnapshot()`

**API 패치 메커니즘**: `fetch` + `XMLHttpRequest` 인터셉트로 `redprinting.co.kr` → `/rp-api` 리다이렉트.

---

## 후니프린팅 Aurora Widget Engine 적용 시사점

1. **`productCode` vs `productId`**: RedPrinting API는 `pdt_cod` (문자열 코드) 사용. Huni API가 `productId` (숫자) 를 사용한다면 별도 매핑 레이어 필요.
2. **`item_gbn` / `price_gbn`**: 상품 타입 분기의 핵심. Huni 상품마스터에 이 필드에 대응하는 값을 저장해야 함.
3. **PCS_INFO 구조**: 후가공 옵션 선택 결과를 `PCS_COD` + `PCS_DTL_COD` 쌍으로 전달. 레거시 req_*/rst_* 방식과 다른 새 패턴.
4. **Shadow DOM 격리**: `window.__pinia` 접근 불가 → Vue 앱 인스턴스 통해 접근해야 함.
