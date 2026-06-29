# widget-cart-contract.md — 위젯 → BFF → Shopby 카트/주문 계약 (§6 huni-widget 입력용)

> 산출자: hsb-integration-architect. 작성: 2026-06-25.
> 목적: 위젯 `data-contract.md §6`의 **UNDECIDED `/cart-handoff` 경계**를 Shopby 커머스 계약에 바인딩한다.
> [HARD] 위젯은 Shopby를 모른다(`api-contract §6` — "Shopby 등 특정 플랫폼 가정 금지"). 이 문서가 정의하는
> Shopby 매핑은 **전부 BFF(브리지) 내부** 책임이며, 위젯이 보내는 것은 `NormalizedCartHandoff` 하나다.
> 권위 순서: Shopby OpenAPI 스펙(`docs/shopby/shopby-api/*.yml`) 1차 → enterprise/Aurora → 라이브 갭필.
> 모든 Shopby shape 주장에 `스펙: <파일>:<operationId>` 또는 `파일:라인` 근거. 입력 팩 밖 필드 창작 0·미상 "모름".
> 입력 근거: `huni-widget/03_spec/data-contract.md`·`api-contract.md`,
> `01_research/commerce-flow-contract.md`, `02_bridge/product-price-bridge-spec.md`·`shopby-product-model.md`.

---

## 0. 계약 위치 (경계 한눈에)

```
위젯 ── NormalizedCartHandoff ──▶ BFF POST /cart-handoff ──▶ [BFF 어댑터(이 문서)] ──▶ Shopby
       (data-contract §6, 위젯 권위)   (api-contract #6)        ① 가격 동기화 P-B        post-cart / post-guest-cart
                                                                ② prd_cd→productNo 매핑     post-order-sheet / reserve
                                                                ③ 사양·원고 → optionInputs
```

- **위젯이 보내는 단 하나의 payload = `NormalizedCartHandoff`** (id+label 스냅샷·가격 스냅샷·원고 artifacts).
- **위젯이 받는 응답 = `{ok, redirectUrl?}`** (`api-contract #6`). redirectUrl 있으면 위젯이 호스트에
  `huni:order` 콜백으로 전달(호스트가 장바구니/주문서 화면으로 이동).
- **위젯은 Shopby `productNo`/`optionNo`/`orderSheetNo`/토큰을 모른다.** 전부 BFF 내부 상태.

---

## 1. 위젯 → BFF: `POST /cart-handoff` (위젯이 호출, 변경 없음)

`api-contract #6` / `data-contract §6` 그대로 — 위젯 측은 **무변경**(컨버전 키스톤 보존):

```ts
// 위젯이 보내는 것 (data-contract §6 — Shopby 무지)
interface NormalizedCartHandoff {
  productCode: string;                 // 불투명 후니 상품코드 (prd_cd)
  selectedOptions: SelectedOption[];   // [{groupId, valueId}] id+label 스냅샷
  quantity: number;
  pageCount?: number;
  priceSnapshot: { finalPrice: number; vat: number; shipping: number };
  artifacts: NormalizedArtifact[];     // 면별 editor projectId 또는 pdf storedFileName
}
interface SelectedOption { groupId: string; valueId: string; }
interface NormalizedArtifact {
  side: 'default'|'inner'; kind: 'editor'|'pdf';
  projectId?: string; thumbnailUrls?: string[]; totalPageCount?: number;  // editor
  storedFileName?: string; originalFileName?: string;                     // pdf
}
```

> ★ 위젯은 `selectedOptions`를 **id로만** 보낸다(불투명). label 스냅샷이 필요하면 BFF가 `/product` 응답
> (`NormalizedProduct.optionGroups[].values[].label`)에서 재조립한다. 위젯은 Shopby 옵션 라벨 문자열 포맷을 모른다.

---

## 2. BFF → Shopby: 라인 조립 매핑 (이 문서의 핵심)

BFF가 `NormalizedCartHandoff`를 받아 Shopby `post-cart`(회원) / `post-guest-cart`(게스트) requestBody로 변환.

### 2.1 회원 — `post-cart` requestBody (배열의 1원소 = 라인 1건)

`스펙: order-shop-public.yml:post-cart`(`:679`), requestBody schema `cart-1115878954`(`:32025-32070`):

| Shopby 필드 | 타입 | 필수 | BFF가 채우는 값(출처) | 근거 |
|------------|------|:---:|----------------------|------|
| `productNo` | number | ✅ | prd_cd↔productNo 매핑 마스터에서 `handoff.productCode` 역조회 | `:32067` / bridge F1 |
| `optionNo` | number | ✅ | **P-B로 동적 생성/갱신한 옵션의 번호**(addPrice=finalPrice) | `:32064` / bridge §3.2 P-B |
| `orderCnt` | number | ✅ | `handoff.quantity` | `:32043` / bridge F4 |
| `optionInputs[]` | array | - | 사양 라벨 + 원고 식별자 텍스트(§3) | `:32046-32063` / bridge F5 |
| `baseProductNo` | number(null) | - | (추가상품 라인만) 본상품 productNo | `:32035-32038` / bridge F6 |
| `groupId` | string(null) | - | (선택) 장바구니 그룹 | `:32039-32042` |

```jsonc
// BFF가 Shopby로 보내는 post-cart body (배열)
[
  {
    "productNo": 100234,            // ← 매핑 마스터(handoff.productCode → productNo)
    "optionNo": 5567,              // ← P-B 동적 옵션 (addPrice = handoff.priceSnapshot.finalPrice)
    "orderCnt": 200,              // ← handoff.quantity
    "optionInputs": [             // ← 사양·원고 식별자 (텍스트, 가격 무관)
      {"inputNo": 1, "inputLabel": "사양", "inputValue": "아트지 300g / 90x50mm / 4도양면 / 무광코팅"},
      {"inputNo": 2, "inputLabel": "원고", "inputValue": "editor:proj_AbCd123 | pdf:9f8e-uuid.pdf"}
    ]
  }
]
```

> ★ `inputNo`/`inputLabel`은 **상품에 사전 등록된 텍스트 옵션(inputs)** 을 참조한다
> (`shopby-product-model §3` — 등록측 `inputs[].inputMatchingType`). BFF가 해당 상품의 입력옵션 정의를
> `get-product-options` 응답 `inputs[]`(`product-shop-public.yml:3725-3727`)에서 읽어 `inputNo`를 채운다.
> **임의 `inputNo`는 불가** — 사전 등록된 입력옵션이 없으면 사양/원고 텍스트 전달 채널이 막힌다(§5 에러 E-INPUT).

### 2.2 게스트 — `post-guest-cart` requestBody

`스펙: order-shop-public.yml:post-guest-cart`(`:1272`), schema `guest-cart337708942`(`:32078-32127`):

| Shopby 필드 | 회원과 차이 | 근거 |
|------------|------------|------|
| `cartNo` | **필수**(회원엔 없음) — 클라이언트 임시값. 출처 미상 = open-issues I-CART-1 | `:32082-32086` |
| `productNo`/`optionNo`/`orderCnt`/`optionInputs[]`/`baseProductNo` | 회원과 동형 | `:32118-32126` |
| `channelType` | guest 스키마에만 존재(회원 post-cart 스키마엔 없음) | `:32093-32096` |
| 토큰 헤더 | **없음**(accessToken/Shop-By-Authorization 미포함) | `:1280-1307` |

> ★ 게스트 카트는 **서버 영속 안 함** — `post-guest-cart`는 라인을 매번 body로 보내 **금액 계산만** 한다
> (회원은 GET /cart/calculate, 게스트는 POST /guest/cart로 계산). BFF/프론트가 라인을 클라이언트 보관.

---

## 3. 사양·원고(artifacts) → 라인 적재 (무손실 텍스트 채널)

`shopby-product-model §3` M-INPUT-1: `optionInputs[].inputValue`는 **자유 텍스트, 가격 효과 0**. 인쇄 사양과
Edicus/PDF 원고 식별자를 **표시·전달하는 무손실 채널**로 적합(가격 채널 아님).

| 후니 handoff 요소 | → Shopby 라인 적재 | 무손실? | 근거 |
|-------------------|--------------------|---------|------|
| `selectedOptions[]` (사양 id) → BFF가 label 환원 | `optionInputs[].inputValue`(사양 요약 텍스트) | ✅ 표시 / ❌ 가격 | bridge F5 |
| `artifacts[].projectId` (Edicus) | `optionInputs[].inputValue` 텍스트(`editor:<projectId>`) | ✅ 식별자 | data-contract §6 / bridge F7 |
| `artifacts[].storedFileName` (PDF S3 UUID) | `optionInputs[].inputValue` 텍스트(`pdf:<storedFileName>`) | ✅ 식별자 | data-contract §4 |
| `artifacts[].thumbnailUrls`/`totalPageCount` | (라인 구조화 첨부 표준 경로 미확인) | ❓ 모름 = I-FILE-1 | OQ-2 연장 |

- **원고 권위 보관처 = 후니 BFF/생산 시스템**(S3 + projectId/storedFileName). Shopby 라인엔 **식별자만** 실어
  추적성 확보(`integration-architecture §6.3` — Shopby=주문/정산, 후니=원고/생산 역할 분리).
- 보조 채널: 주문 메모 `payments/reserve.orderMemo`(`order-shop-public.yml:33060-33063`)에 주문 단위 원고 요약 가능.
- ★ **라인 단위 구조화 파일 메타 객체**(thumbnail·pageCount를 텍스트가 아닌 객체로)의 표준 Shopby 경로는
  스펙 미확인 → I-FILE-1("모름"). 현재는 텍스트 식별자(무손실)로만.

---

## 4. 가격 동기화 계약 (BFF 내부 — 위젯 무관, P-B)

위젯 `priceSnapshot.finalPrice`가 Shopby 라인가로 살아남는 유일 경로(`product-price-bridge-spec §3.2`).

### 4.0 가격 불변식 [HARD · R-1/X03 — 돈크리티컬]

`addPrice = final_price`는 아래 불변식이 동시에 성립해야만 과금 정합한다(`integration-architecture §4.2.1`):

| 불변식 | 값 | 근거 |
|--------|----|------|
| `salePrice` (대표상품/컨테이너) | **0 고정** | 구매가 = salePrice×(1−즉시할인율)+addPrice이므로 salePrice≠0이면 과금 오류 |
| 즉시할인·추가할인·수량할인 | **0** | 이중할인 회피 + 즉시할인 비대칭 제거(OQ-5) |
| 가격 = `addPrice` 한 곳 | `addPrice = final_price'` | 라인 가격 입력 필드 부재(X02) |
| **대표(첫) 옵션 addPrice** | **0 강제** | "첫 옵션가는 반드시 추가금이 0"(`product-server-public.yml:9504,11646,13273,14567,16495`) → 가격은 **별 옵션행**으로 |

### 4.1 server API 인증 분리 [HARD · R-2/X05]

`put-product-options`는 고객 Shop API가 아니라 **server API**다:
- base = `server-api.e-ncp.com`(`product-server-public.yml:7`), 인증 = **`systemKey`(header, required:true)** +
  `version`(header, required:true)(`product-server-public.yml:put-product-options` :1758·:1789). 고객 `Authorization`은 required:false(:1773).
- → BFF는 **server API 클라이언트(systemKey)** 로만 호출(고객 토큰 사용 금지). `systemKey`는 `.env.local`/BFF 서버
  세션에만(키 이름만 노출). 고객 critical path와 **실패 격리·레이트·동시성 가드**(`integration-architecture §1.1·§4.4`).

### 4.2 BFF 의사코드 (X04 full payload shape · R-5)

```ts
// BFF 의사코드 (위젯은 이 단계를 모름) — 두 API 클라이언트 분리
async function cartHandoff(h: NormalizedCartHandoff) {
  const productNo = mapping.toProductNo(h.productCode);          // F1
  const verified  = await evaluate_price(h.productCode, ...);    // 만료 가드 재계산
  if (!verified.ok || verified.final_price <= 0) throw E_PRICE;  // PRICE≠0 (메모리)
  if (verified.final_price !== h.priceSnapshot.finalPrice) throw E_STALE; // 만료 불일치

  // ★ server API 클라이언트(systemKey)로만 — full payload shape (X04)
  //   스펙: product-server-public.yml:put-product-options(:1756) / schema products-options-915318368(:16796)
  const res = await serverApi.putProductOptions({               // systemKey 헤더 (Shop API 클라이언트 아님)
    mallProductNo: productNo,
    options: [
      // 대표(첫) 옵션 — addPrice=0 강제 (첫 옵션 0 제약)
      { item: true, optionType: "STANDARD", optionName: "구성", optionValue: "기본",
        order: 1, addPrice: 0, useYn: "Y", optionManagementCd: "",
        stockCnt: 0, mallOptionNo: 0 /* 0=신규, 기존값=수정 */, optionSelectType: "MULTI" },
      // 가격 옵션행 — addPrice = 후니 권위가 (별행, order≥2)
      { item: true, optionType: "STANDARD", optionName: "견적가", optionValue: `q_${verified.quote_id}`,
        order: 2, addPrice: verified.final_price, useYn: "Y", optionManagementCd: "",
        stockCnt: 0, mallOptionNo: 0, optionSelectType: "MULTI" },
    ],
    inputs: [ // 사양·원고 텍스트 채널(§3) — 가격 무관
      { mallProductInputNo: 0, inputText: "사양/원고", inputMatchingType: "OPTION", useYn: "Y", required: false },
    ],
  });
  // 응답: {mallProductNo, mallProductOptionNos[], mallProductInputNos[]} (:1817 / schema products-options-1969028125)
  const optionNo = pickPriceOptionNo(res.mallProductOptionNos);  // 가격 옵션행(order=2)의 번호
  await shopApi.postCart([{ productNo, optionNo, orderCnt: h.quantity, optionInputs }]); // Shop API 클라이언트
}
```

- **put-product-options 완전 payload shape (X04, 스펙 `:16796` schema `products-options-915318368`)**:
  `{mallProductNo, options:[{item, optionType, optionName, optionValue, order, addPrice, useYn, optionManagementCd,
  stockCnt, optionImages?, extraManagementCd?, mallOptionNo, forcedSoldOut?, optionSelectType}], inputs:[{mallProductInputNo,
  inputText, inputMatchingType, useYn, required}]}`. 응답 = `{mallProductNo, mallProductOptionNos[], mallProductInputNos[]}`(:1817).
- **`mallOptionNo` 분기**: `0`(또는 미지정)=신규 생성 / 기존 옵션번호=수정(`:16828` "옵션번호(수정)"). P-B는 주문건별
  신규 생성(공유 금지) — 동시성 회피(§6/OQ-3).
- **`addPrice = final_price`(가격 옵션행)** → Shopby가 `salePrice(=0) + addPrice` 재산출해도 동일값(이중계산 0,
  `product-price-bridge-spec §3.3` / `shopby-product-model §6` M-PRICE-1).
- **Shopby 라인 할인 전부 0** — 후니 final_price는 이미 수량구간·등급 반영 최종가(OQ-5, `bridge open-questions OQ-5`).
- ★ P-B(주문 직전 동적 옵션 생성)의 상품심사·동시성·잔존 청소·server API 격리는 **미검증 BLOCKED 관문** =
  open-issues I-PRICE-1(`bridge open-questions OQ-3`, M-JUDGE-1). 고정가·소조합 상품군은 **P-A(사전 동기화)** 로 우회(I-STRAT-1).

---

## 5. 에러 계약 (위젯 status='error' 매핑)

`api-contract §0` 공통 에러 `{ok:false, code, message}`. BFF가 Shopby 실패를 정규화 코드로 환원:

| code | 발생 지점 | 위젯 표시(reasons) | 근거 |
|------|----------|-------------------|------|
| `E_PRICE` | finalPrice ≤ 0 / ok=false | "가격을 산출할 수 없습니다(재선택)" | PRICE≠0 (메모리 huni-widget-red-price-never-zero) |
| `E_STALE` | 핸드오프가≠재계산가(만료) | "가격이 변경되었습니다(재견적)" | bridge §3.3 / arch §4.4 |
| `E_INPUT` | 상품에 사전 등록 텍스트 옵션 없음 | "사양/원고 전달 채널 미설정(상품 등록 필요)" | shopby-product-model §3, §2.1 주 |
| `E_VALIDATE` | `get-cart-validate` result=false | "구매 불가 상품(재고/판매상태)" | order-shop:1138, commerce-flow §1.6 |
| `E_RESERVE` | reserve 검증 거절(paymentAmtForVerification 불일치) | "결제 금액 검증 실패(재시도)" | order-shop:33398-33401 |
| `E_MAP` | prd_cd↔productNo 매핑 부재 | "미연동 상품(브리지 매핑 필요)" | bridge F1 / OQ-6 |

> ★ `redirectUrl`(성공): BFF가 장바구니/주문서 진입 URL 반환 → 위젯이 `huni:order` 콜백으로 호스트에 전달
> (`api-contract #6`). 위젯은 직접 네비게이션하지 않는다.

---

## 6. 주문서·결제 단계는 위젯 범위 밖 (스킨/프론트 책임)

`post-cart` 이후(주문서·결제)는 **위젯이 아니라 Aurora 스킨몰/후니 프론트**가 수행한다. 위젯 계약은 `/cart-handoff`
에서 끝난다(`data-contract §6` HARD 스코프). 후속 단계의 operationId 바인딩은 `e2e-sequences.md §0` 표 참조:

`post-order-sheet`(`:3789`) → `get-order-sheet`(`:3870`) → `order-sheets/{no}/calculate`(`:4063`) →
`payments/reserve`(`:4703`). 라인 shape는 cart와 동형(`order-sheets-427257668` products[] `:21432`).

### 6.1 reserve 필수세트 [HARD · R-4/X09 — 주문실패 가드]

`payments/reserve` requestBody(`payments-reserve-2101669004`, `order-shop-public.yml:33000` 직접 확인)는
**required 9필드**가 있다 — 스킨/프론트가 전부 채워야 한다(누락 시 400/주문실패):

| reserve 필수 필드 | 의미 | 출처/주 |
|-------------------|------|---------|
| `clientReturnUrl` | PG 결제 완료 후 복귀 URL | 프론트가 지정(result=SUCCESS&orderNo 수신) |
| `member` | 회원여부 boolean | 회원=true / 게스트=false(+`tempPassword`, :33241-33244) |
| `orderSheetNo` | 주문서 번호 | #5 post-order-sheet 출력 |
| `orderer` | 주문자 정보 객체 | 회원 프로필/게스트 입력 |
| `payType` | 결제수단 타입 | get-order-sheet `availablePayTypes` 중 선택 |
| `pgType` | PG사 타입 | 결제수단별 |
| `saveAddressBook` | 배송지 주소록 저장 boolean | 프론트 토글 |
| `subPayAmt` | 보조결제(적립금 등) 금액 | I-PAY-2(외부결제 검증액 산식 갭필) |
| `updateMember` | 회원정보 갱신 boolean | 프론트 토글 |

- `paymentAmtForVerification`은 **required 아님 — `nullable:true`**(`order-shop-public.yml:33398-33400` 직접 확인).
  **단 anti-tamper 운영규칙상 항상 전송**한다(order-sheet/calculate의 `paymentInfo.paymentAmt`를 되돌려 검증).
  "스펙 필수"와 "운영 필수"를 구분 — 스펙상 nullable이나 보안상 생략 금지.
- 게스트는 `member:false` + `tempPassword`(비회원 필수), 회원은 `member:true` + Shop-By-Authorization.
  `tempPassword`는 비회원 주문 조회(§e2e §0 #10g `POST /previous-orders/guest/{orderNo}`의 `password`)와 동일 자격.

---

## 7. 자기 점검

- [x] 위젯이 보내는 단일 payload(`NormalizedCartHandoff`) → Shopby `post-cart`/`post-guest-cart` 필드 매핑.
- [x] 모든 Shopby 필드에 `스펙:파일:operationId` 근거 — dead link 0.
- [x] 사양·원고 무손실 텍스트 채널(optionInputs) + 가격 동기화(P-B, addPrice=finalPrice) 분리.
- [x] 에러 계약 정규화(위젯 status='error') — 위젯은 Shopby 코드 무지.
- [x] 입력 팩 밖 필드 창작 0 — 라인 구조화 첨부(I-FILE-1)·게스트 cartNo(I-CART-1)는 "모름" 분리.
