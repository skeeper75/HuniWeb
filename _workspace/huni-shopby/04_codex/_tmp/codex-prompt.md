# 독립 교차검증 과업 — 후니프린팅 × Shopby 커머스 통합 설계

너는 독립 시니어 커머스 통합 아키텍트다. 아래 후니프린팅(인쇄 자동견적) → Shopby(SaaS 커머스 플랫폼) 통합
설계 산출물을 **Shopby OpenAPI 스펙을 근거로 냉철하게 독립 재판정**하라. 다른 누가 이미 판정한 결론은 모른다고
가정하고, 너 스스로 스펙을 읽어 결함·환각·실현 불가능한 가정을 적발하라. 정당한 설계를 결함으로 오판하지도 마라.

## 배경 (사실)
- 후니는 자체 가격엔진(`evaluate_price`)이 인쇄상품의 견적가(`final_price`)를 산출하는 단일 권위다.
  CPQ 위젯이 옵션(사이즈/도수/자재/후가공/수량 등)을 자유 선택하면 면적매트릭스·수량구간형 연속 가격이 나온다.
- 목표: 위젯이 산출한 후니 견적가를 Shopby 카트/주문/결제 흐름에 무손실로 실어 주문·정산까지 가는 통합.
- 후니는 Shopby를 신규 도입 검토 중. Shopby 카트/주문 라인에는 임의 단가 입력 필드가 없다는 것이 설계의 핵심 전제.

## 읽어야 할 설계 산출물 (검토 대상)
- `_workspace/huni-shopby/03_design/integration-architecture.md` — 종단 통합 아키텍처·전략 권고·가격 권위 주입.
- `_workspace/huni-shopby/03_design/widget-cart-contract.md` — 위젯→BFF→Shopby 카트 라인 필드 매핑 계약.
- `_workspace/huni-shopby/03_design/e2e-sequences.md` — 회원/게스트 종단 시퀀스(operationId 바인딩).
- `_workspace/huni-shopby/03_design/open-issues.md` — 설계가 스스로 분리한 미해결/BLOCKED.
- `_workspace/huni-shopby/02_bridge/bridge-strategy-options.md` — 브리지 전략 A~D × 5축 트레이드오프.
- `_workspace/huni-shopby/02_bridge/product-price-bridge-spec.md` — 라인 필드 매핑 + 동적 가격 주입 경로.
- `_workspace/huni-shopby/02_bridge/shopby-product-model.md` — Shopby 상품/옵션 모델.
- `_workspace/huni-shopby/02_bridge/open-questions.md` — 브리지 미해결.

## 권위 스펙 (네가 직접 대조해 검증할 1차 근거)
- `docs/shopby/shopby-api/order-shop-public.yml` — 카트/주문서/결제(post-cart, post-guest-cart,
  get-cart-calculate, post-order-sheet, order-sheets calculate, post-payments-reserve 등).
- `docs/shopby/shopby-api/product-server-public.yml` — 상품/옵션 등록·수정(put-product-options, addPrice,
  상품심사 inspection/judgement).
- `docs/shopby/shopby-api/product-shop-public.yml` — 상품/옵션 조회(get-product-options 등).
- 그 외 `docs/shopby/shopby-api/*.yml`. (대용량 — grep/타깃 읽기로 효율 탐색)

## 검토 초점 (이 4가지를 스펙으로 검증)
(a) **카트/주문 계약 shape 정합**: widget-cart-contract.md가 주장하는 post-cart / post-guest-cart requestBody
    필드(productNo, optionNo, orderCnt, optionInputs[].inputNo/inputLabel/inputValue, baseProductNo, channelType,
    게스트 cartNo)가 실제 operationId 스키마와 일치하나? 필수/옵션·타입·존재 여부를 스펙 라인으로 확인.
(b) **동적 계산가 주입 실현성**: 설계는 "주문 직전 put-product-options로 addPrice=후니 계산가 옵션을 동적 생성(P-B)"
    하면 cart/calculate·order-sheet/calculate가 salePrice+addPrice 재산출해도 동일값이라 주장한다. 이게 실제로
    통과 가능한가? 막는 요소(상품심사 재승인, 옵션 변경 제약, 동시성, 잔존 옵션, 노출 지연, 옵션 5개 한도 등)를 스펙/
    가능하면 enterprise 문서로 적발. 라인에 임의 단가 필드가 정말 없는지도 독립 재확인.
(c) **브리지 전략 트레이드오프 누락 리스크**: 정산/세금/환불·클레임 관점에서 설계가 빠뜨린 위험. 특히 동적 옵션(P-B)으로
    주문 후 그 옵션을 청소/변경하면 과거 주문·클레임·정산의 가격 추적성이 깨지는가? claim-shop/claim-server 스펙에
    환불액이 무엇을 권위로 쓰는지 단서가 있나?
(d) **종단 시퀀스 끊긴 단계·인증 오류**: e2e-sequences.md의 회원/게스트 시퀀스에 스펙상 빠진 필수 단계·필수 필드,
    잘못된 단계 순서, 인증 헤더 오류(Shop-By-Authorization vs accessToken, 게스트 토큰 흐름)가 있나? 특히
    reserve의 필수 필드(paymentAmtForVerification, agreementTermsAgrees, subPayAmt 등)와 결제 확정 흐름.

## 출력 형식 (반드시 준수)
각 발견을 다음으로 적어라:
- **[발견 ID]** 한 줄 요약
- 분류: 결함(설계가 틀림) / 누락(빠짐) / 리스크(미검증 위험) / false-positive 후보(설계가 맞는데 의심됨)
- 근거: 스펙 파일:라인 또는 operationId (없으면 "스펙 미확인 — 가설"이라고 명시. **절대 날조 금지**)
- 심각도: HIGH(돈/주문 깨짐) / MEDIUM / LOW
- 권고: 무엇을 고치거나 확인해야 하나

마지막에 **종합 판정**(설계가 스펙 정합한가 / 치명 결함 있나)과 **네가 스펙에서 확인 못 해 모르는 것**을 분리해 적어라.
추정으로 메우지 말고 "모름"이라고 해라. 한국어로 답하되 코드/필드명/operationId는 영어 유지.
