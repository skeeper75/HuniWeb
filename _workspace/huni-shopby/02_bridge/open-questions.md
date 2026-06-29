# open-questions.md — 가격 주입·정산 정합 미상

> 스펙에서 못 찾은 필드/흐름 = "모름" 명시(날조 0). 권위 순서: Shopby OpenAPI 스펙 → enterprise 문서 → 라이브 갭필.
> 갭필(docs.shopby.co.kr WebFetch)은 부족분만, 향후 수행. 산출자: hsb-product-bridge-analyst. 작성: 2026-06-25.

---

## OQ-1 — "주문 시 가격 결정" 상품 유형/설정의 존재 여부 [enterprise 정독 — 강화]
- **무엇이 미상**: 라인 가격을 등록가가 아닌 "주문 시점에 동적으로 결정"하게 만드는 상품유형·옵션유형·설정.
- **확인한 것(부정 근거)**: ① 22개 `docs/shopby/shopby-api/*.yml` 전수 재검색 결과 `customPrice`·`priceOverride`·
  `overridePrice`·`manualPrice` 류 키 **0건**(2026-06-25 재실측). post-cart/post-order-sheet/calculate·admin
  order-server 어디에도 라인 가격 입력 필드 없음. ② **enterprise `option.mdx` 정독**: 옵션가(addPrice)는 등록 시
  입력하는 **고정 추가/차감값**만 존재(`:60-62`). "주문 시 결정" 옵션유형 **미발견**.
- **남은 가능성**: docs.shopby.co.kr 비공개 상품유형(예 견적상품) 존재 여부만 잔존(가능성 낮음).
- **검증 방법**: docs.shopby.co.kr 상품유형 가이드 갭필(부족분만).
- **영향**: 전략 C(직접주입) 순수형 **불가**로 결론 강화(스펙+enterprise 이중 부정). 실현형은 P-B(동적 옵션)뿐이며 그것도 OQ-3 종속.

## OQ-2 — 카트/주문 라인 단위 customProperty·추가정보 첨부 가능 여부
- **무엇이 미상**: `customProperty`(get-custom-property-by-mallno `:1136`)와 `extraInfo`(get-product-extraInfos `:1211`)는
  **상품 단위 마스터**로 확인됨. 이를 **주문 라인 인스턴스마다** 임의 값으로 첨부하는 경로는 스펙 미확인.
- **확인한 것**: 라인이 받는 자유 데이터 = `optionInputs[].inputValue`(텍스트, `:32046-32063`)뿐. customProperty의
  라인 첨부 필드는 cart/order-sheet 스키마에 없음.
- **검증 방법**: order-server-public.yml(admin 주문) 응답에 라인별 customProperty 노출 여부 확인 + 갭필.
- **영향**: 가능하면 후니 사양 메타를 구조화 전달(F7)에 유리. 현재는 텍스트(F5)로만 무손실 전달.

## OQ-3 — 주문 직전 옵션 동적 생성(경로 P-B)의 운영 정합 [judgement 정독 — 위험 격상]
- **무엇이 미상**: 1주문 직전에 후니가 `addPrice=계산가`인 옵션을 `put-product-options`로 즉석 등록/변경하고
  그 optionNo로 카트에 담는 패턴이 **상품심사를 유발하는지**(자동승인 예외 여부). + 실시간 노출 지연·동시성·잔존 청소.
- **확인한 것(위험 격상)**: enterprise `judgement.mdx:9` 명문 — "신규 등록 또는 **상품의 일부 정보를 수정한 경우**
  상품판매를 위한 상품 심사 필요", 수정 시 **"수정 후 승인대기"**(`:35`)로 전이. **옵션/addPrice 변경이 "일부 정보
  수정"에 포함되면 P-B는 심사 대기 동안 판매 차단 → 사실상 불가**(M-JUDGE-1). 등록 API 자체는 존재.
- **남은 미상**: addPrice/옵션값 변경이 상품심사 자동승인(예외) 대상인지 — 매뉴얼 문구로 단정 불가.
- **검증 방법**: docs.shopby.co.kr 상품심사 정책(어떤 수정이 재심사 트리거인지) + (가능 시) 라이브 admin 읽기 탐색.
- **영향**: P-B가 막히면 전략 C 실현형·전략 D 가격 메커니즘이 무너짐 → 무손실 길은 전략 A(사전 일괄 동기화)만 남음.
  **D 채택의 결정적 관문.**

## OQ-7 — `/products/{productNo}/purchasable` 의미 정정 (구매가능 게이트 아님)
- **확인(정정)**: `get-product-purchase-permission`(`product-shop-public.yml:3730`)은 이름과 달리 **"상품우선구매권한"**
  (`{permissionNo,optionNo,purchaseStartAt,purchaseEndAt,purchaseCnt,purchasedCnt}`, `:3801-3805`) = 기간·수량
  한정구매권 정보다. 후니가 찾는 일반 "이 라인 담을 수 있나" sanity는 **`get-cart-validate`**(`order-shop-public.yml:1138`,
  `{result:bool}`)가 담당(commerce-flow-contract §1.6). → 브리지 SB2 "카트 전달 가능" 판정에 purchasable 오용 금지.
- **영향**: 정정만(미상 아님). 토대 §4 "카트 전달 가능 상태"의 런타임 sanity는 cart-validate에 배선.

## OQ-4 — 정산이 라인 salePrice/addPrice를 권위로 쓰는지 (가격 분리 시 정합)
- **무엇이 미상**: Shopby 정산/세금계산서/거래명세서(NATIVE, `admin-analysis/feature-matrix.md:79-85`)가 산출 기준으로
  쓰는 가격이 **라인 등록가(salePrice+addPrice)** 인지, 아니면 결제 금액·외부소스인지.
- **확인한 것**: 주문서 `paymentInfo.paymentAmt`·라인 `price.buyAmt`는 서버 산출(`order-shop-public.yml:3957-3958, 4020`).
  정산이 이 값을 권위로 쓰는지는 정산 API/문서 미확인.
- **검증 방법**: settlement 관련 yml(있으면) + `shopby_enterprise_docs/statistic`·정산 매뉴얼 갭필.
- **영향**: 전략 B/D처럼 후니가 별도 권위가를 보유(Shopby엔 placeholder)하면, 정산이 placeholder를 쓰면 정산 왜곡.
  정산이 결제 실청구액을 쓰면 P-B로 라인가를 후니가와 일치시켜야 함 → 어느 경우든 "라인가=후니가" 동기화 필요 가능성.

## OQ-5 — 할인 모델 불일치 (후니 구간단가/등급 ↔ Shopby 할인율/쿠폰)
- **무엇이 미상**: 후니 `discounts[]`(수량구간 할인=구간단가, 등급할인=`pricing.py:478-537`)를 Shopby의 상품단위
  즉시/추가할인율·쿠폰으로 무손실 환산하는 길. 후니 구간단가는 "구간별 다른 단가"이지 "정률/정액 할인"이 아님 →
  Shopby 할인 모델과 구조 상이.
- **확인한 것**: Shopby 할인 = salePrice 기준 즉시(`immediateDiscountInfo`)→추가→쿠폰 순차(`product-shop-public.yml:3816-3833`).
  후니 등급할인은 라이브 0행(C9, 현재 비발화), 수량구간 할인은 구간단가로 final_price에 이미 반영됨.
- **enterprise 보강**: Shopby native 수량할인 = **필수옵션 구매수량·금액 기준** 정률/정액(`option.mdx:162`) — 후니
  "구간단가"(구간마다 다른 단가)와 구조 상이 재확인. 후니 final_price는 수량구간 단가까지 이미 반영된 최종가이므로,
  Shopby 측 할인(즉시/추가/수량)을 **전부 0**으로 두고 등록가=후니 final_price로 쓰는 것이 무손실(이중할인 회피).
- **검증 방법**: architect가 "Shopby 할인 0 + 등록가=후니 final_price" 설계의 정산 표시(정상가↔할인가) 정합 검토.
- **영향**: 전략 A에서 Shopby 할인 기능 켜면 이중할인 위험 — **Shopby 할인=0 권장**(잠정 닫힘, 설계 확정만 남음).

## OQ-6 — 후니 prd_cd ↔ Shopby productNo 매핑 마스터의 소유/동기화 주체
- **무엇이 미상**: 매핑 마스터(신규 운영자산)를 어디서(후니 백엔드 vs Shopby managementCode) 권위로 두고
  생성/변경을 어떻게 동기화하는지. (옵션은 optionManagementCd/extraManagementCd로 키 매핑 가능 — `:6502-6505`.)
- **검증 방법**: managementCode 기반 멱등 매핑이 search API로 역조회 가능한지(`get-products-search` 등) 확인.
- **영향**: 모든 전략의 운영 기반. architect 설계 항목.
