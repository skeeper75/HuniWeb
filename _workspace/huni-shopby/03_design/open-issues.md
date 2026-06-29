# open-issues.md — Shopby 통합 설계 미해결·갭필·인간 승인 결정

> 산출자: hsb-integration-architect. 작성: 2026-06-25.
> 원칙: 추정 0. 스펙/입력 팩에서 못 찾은 것은 날조하지 말고 "모름"으로 분리. 설계는 미상을 추정으로 메우지 않고
> BLOCKED/UNDECIDED로 표기했다. 권위 순서: Shopby OpenAPI 스펙 → enterprise/Aurora → 라이브 갭필(부족분만).
> 입력 팩 open-questions 승계: `01_research/open-questions.md`(Q-*)·`02_bridge/open-questions.md`(OQ-*)·
> `00_foundation/open-questions.md`(OQ-1~12). 본 문서는 그것들을 **설계 결정 관점**으로 재분류·격상한다.

---

## A. BLOCKED 관문 — 전략 D/P-B 채택의 결정적 선결 (HIGH, 인간 승인·갭필 전 진행 불가)

| ID | 이슈 | 무엇이 막혔나 | 닫는 법 | 승계 |
|----|------|--------------|---------|------|
| **I-PRICE-1** | P-B(주문 직전 옵션 동적 생성)가 **상품심사 "수정 후 승인대기"** 유발 여부 | enterprise `judgement.mdx:9,35`: 상품 일부 정보 수정 시 재심사·판매 차단. addPrice 변경이 "일부 수정"에 포함되고 자동승인 예외가 없으면 **P-B 사실상 불가** → D 가격 메커니즘 붕괴 | docs.shopby.co.kr 상품심사 정책(어떤 수정이 재심사 트리거인지) 갭필 + 라이브 admin 읽기 탐색 | OQ-3 / M-JUDGE-1 |
| **I-PRICE-2** | 정산이 라인 `salePrice/addPrice`를 권위로 쓰는지 | 정산/세금계산서=NATIVE(`feature-matrix:79-85`). 후니 권위가 분리 시 정산 왜곡 위험. P-B로 라인가=후니가 일치시키면 정합되나 정산 소스 미확인 | settlement yml(있으면) + enterprise 정산 매뉴얼 갭필 | OQ-4 |
| **I-PRICE-3** | P-B 동적 옵션의 **동시성·잔존 청소·노출 지연·청소↔클레임 추적 충돌(X11)·server API 격리(R-2)** | 주문건별 고유 optionNo 생성(P-C 덮어쓰기 회피) 설계는 했으나 ① 등록 즉시 storefront 노출/구매가능 지연·잔존 옵션 GC 정책 ② **청소(GC)와 클레임/주문이력 추적성 충돌**(주문 후 옵션 삭제 시 과거 주문의 옵션 참조 끊김) ③ **put-product-options(server API·systemKey) 호출 실패 격리·레이트**(R-2/§1.1·§4.4) 미검증 | 라이브 admin 동작 확인(읽기 탐색) + 운영 설계(인간). **immutable 옵션 정책 권고**: 주문에 묶인 동적 옵션은 **삭제 금지·`useYn=N`만(addPrice 변경/삭제 금지)** 로 추적성 보존(인간 승인) | OQ-3 / X11 / R-2 |

> ★ I-PRICE-1이 NO면 **마이그레이션 경로 = 전략 A(사전 일괄 동기화)로 회귀**(고정가·소조합부터). 위젯·BFF
> 정규화 계약은 무변경(어댑터 내부 선택) — `integration-architecture §2.3·§2.4` 하이브리드 분리로 흡수.

---

## B. 가격 주입 — 부정 확정 vs 잔존 가능성

| ID | 이슈 | 상태 | 근거 |
|----|------|------|------|
| **I-PRICE-4** | "후니 계산가 정수를 카트 라인에 그대로 주입" | **부정 확정(불가)** — 미상 아님 | post-cart/post-order-sheet/calculate 3개 라인 가격 필드 0건. 6개 yml `customPrice`/`orderPrice`/`priceOverride` 0건(`product-price-bridge-spec §3.1`) |
| **I-PRICE-5** | "주문 시 가격 결정" 상품유형(견적상품 등) 존재 여부 | **잠정 부정(강화)·라이브 잔존** | 스펙+enterprise option.mdx 이중 미발견. docs.shopby.co.kr 비공개 상품유형만 잔존(가능성 낮음) = OQ-1 |
| **I-DISCOUNT-1** | 후니 구간단가/등급 ↔ Shopby 할인율/쿠폰 무손실 환산 | **잠정 닫힘(설계 확정만)** | 후니 final_price=이미 최종가 → Shopby 할인 전부 0 권장(이중할인 회피). 설계 영역 = OQ-5 |

---

## C. 결제·주문 흐름 갭 (스펙 미노출 — 갭필 필요)

| ID | 이슈 | 무엇이 미상 | 닫는 법 | 승계 |
|----|------|------------|---------|------|
| **I-PAY-1** | 결제 확정(주문 생성) 전용 POST 부재 | order-shop 전체에서 cart→ordersheet→reserve 경로에 "결제 확정/주문 생성" POST 없음(재확증). reserve 후 PG `returnUrl`/`confirmUrl`→`clientReturnUrl?result=SUCCESS&orderNo`. 결제 확정이 PG↔Shopby 서버 콜백(confirmUrl)으로만 처리되는지 | docs.shopby.co.kr 결제편의모듈(NCPPay)·app-payment-module 가이드 갭필 | Q-PAY-1 |
| **I-OS-1** | `recurringPaymentDelivery` 일반(비정기) 주문 필수 처리 | `post-order-sheet.products[].recurringPaymentDelivery` required(`:21440`)인데 일반주문에서 빈/null 키 채움법 미상(예시는 cycleType="MONTH") | 일반 주문 예시 갭필(주문서 가이드) | Q-OS-1 |
| **I-PAY-2** | `subPayAmt`/`externalPayInfos`와 `paymentAmtForVerification` 산식 관계 | reserve `subPayAmt` required(`:33009`)+외부결제 조합 시 검증액 산식 미상 | 외부결제/복합결제 가이드 갭필 | Q-PRICE-2 |
| **I-MISC-1** | reserve 필수 `agreementTermsAgrees` termsType 세트 | 어떤 termsType이 결제 성공 필수인지(몰 설정 종속 추정) | 약관 동의 가이드 갭필 | Q-MISC-1 |

---

## D. 인증·세션 (auth 서비스 raw shape — 갭필)

| ID | 이슈 | 무엇이 미상 | 갭필 | 승계 |
|----|------|------------|------|------|
| **I-AUTH-1** | 몰 운영방식(스킨몰 vs **headless**) 확정 | 후니 인쇄 CPQ 위젯·커스텀 주문엔 headless가 적합 후보(`aurora index.mdx:21,33`)이나 최종 결정=인간 승인 | 인간 승인(운영방식) | — |
| **I-AUTH-2** | `post-oauth2-token`/`post-oauth2-openid-token` requestBody shape | 본 레포 yml에 auth 서비스 스펙 없음. auth.mdx는 헤더만 표기. (단 openid 엔드포인트 base URL은 `shop-api.e-ncp.com`으로 확인 — 외부회원 가이드:72) | docs.shopby.co.kr auth OpenAPI 갭필 | Q-AUTH-1/2 |
| **I-AUTH-3** | 외부회원 연동(ncpstore) 채택 여부 | 후니 자체 회원 권위를 둘지 + 고객사 회원정보 조회 API 1:1 사전 등록(외부회원 가이드:31) | 인간 승인 + Shopby 1:1 문의 | auth-session §3.3 |
| **I-ENV-1** | 서비스별 base URL 차이 | order=`shop-api.e-ncp.com`(:7), auth/member docs=`shop-api.shopby.co.kr`(auth.mdx:18). oauth2/openid는 e-ncp.com(외부회원 가이드:72). 동일 게이트웨이 별칭/환경 분리 여부 미상 | 서버정보/환경 가이드 갭필 | Q-ENV-1 |

---

## E. 카트/주문 라인 세부 (갭필)

| ID | 이슈 | 무엇이 미상 | 갭필 | 승계 |
|----|------|------------|------|------|
| **I-CART-1** | 게스트 `cartNo` 출처/채번 | post-guest-cart `cartNo` required인데 게스트는 서버 영속 카트 없음(클라 임시값 추정·스펙 미명시) | 비회원 장바구니 가이드 갭필 | Q-CART-1 |
| **I-META-1** | 카트/주문 라인 단위 `customProperty` 첨부 가능 여부 | customProperty/extraInfo는 상품 단위 마스터 확인. 라인 인스턴스 임의 첨부 경로 스펙 미확인. 라인 자유 데이터=optionInputs(텍스트)뿐 | order-server 응답 라인별 customProperty 노출 확인 + 갭필 | OQ-2 |
| **I-FILE-1** | 원고 **구조화 파일 메타**(thumbnailUrls·pageCount 객체)의 라인 적재 표준 경로 | 현재는 식별자 텍스트(optionInputs)로만 무손실 전달. 객체 첨부 표준 경로 미확인 | OQ-2 연장 + admin 주문 라인 스키마 확인 | widget-cart-contract §3 |
| **I-OS-2** | cartNos 경유 vs products 직접 — 금액 일치 보장 | 두 경로 calculate 동일 산식인지·중복 제공 시 우선순위 미상 | 주문서 가이드 갭필 | Q-OS-2 |
| **I-CART-2** | post-cart `channelType` 예시 vs 스키마 불일치 | post-cart 예시(:729)에 channelType:null, 스키마(:32035-32069)엔 미정의. guest-cart 스키마에만 존재. 회원 post-cart에 channelType 송신 가능/무시 여부 | 라이브 응답 동작 + 쇼핑채널링 가이드 갭필 | Q-CART-2 |

---

## F. 운영자산·매핑 (설계 항목 — 인간/구현 결정)

| ID | 이슈 | 결정 필요 | 승계 |
|----|------|----------|------|
| **I-MAP-1** | prd_cd ↔ productNo 매핑 마스터의 소유/동기화 주체 | 후니 백엔드 권위 vs Shopby managementCode. 멱등 매핑이 search API 역조회 가능한지(`optionManagementCd`/`extraManagementCd` :6502-6505) | OQ-6 |
| **I-STRAT-1** | CPQ 유한·열거 상품군(전략 A) vs 연속·매트릭스(전략 D/P-B) 전략 분리 확정 | 토대 §2 GREEN ≈ 60상품 중 고정가형/축≤5(option.mdx:44 최대 5축 제약)부터 A 파일럿. 면적매트릭스/구간형은 D | bridge §5-1 |
| **I-NAVER-1** | NaverPay 경로(별도 mini-OrderSheet) 1차 통합 범위 포함 여부 | post-payments-naver-ordersheet(:4815)는 표준 경로와 분기. PM/architect 결정 | Q-MISC-2 |
| **I-RED-1** | RED 카테고리(하드커버책자·포토북·아크릴·캘린더류·조합형) 브리지 범위 처리 | 가격소스 0(§21 NO-GO). 브리지 제외 vs 인간 승인 후 dbmap 선적재 | foundation OQ-11 |

---

## G. 토대 검증 잔여 (게이트 SB2/SB3로 — 본 설계가 가정한 전제)

| ID | 이슈 | 본 설계가 가정한 것 | 검증 주체 |
|----|------|---------------------|----------|
| **I-VERIFY-1** | 위젯 strict 실호출 `final_price>0` 상품 실제 비율 | 가격소스 보유 104/275(라이브 재실측 확인). 실호출 0원 여부(R-1·R-3·R-5)는 상품별 미검증 | 게이트 SB2 / huni-widget |
| **I-VERIFY-2** | 옵션→차원 `ref_dim` 풀이(R-2) 위젯/BFF 어댑터 무손실 재현 | 라이브 시뮬은 ref_dim 풀이, 위젯 CONTEXT는 "옵션코드만" 의도 — 불일치 가능 | 게이트 SB2 |
| **I-VERIFY-3** | 셋트 7부모 `evaluate_set_price` PRICE≠0·이중합산 0 | 셋트 28행/7부모 적재만 확인(라이브 재실측). 실재계산 미검증 | 게이트 SB3 / §23 set-gate |
| **I-VERIFY-4** | §21 verdict(2026-06-23 NO-GO)와 §2 재실측(가격 가능 다수) 시점차 | 스티커16/16·포스터9/9 가격 가능하나 §21 배치3 NO-GO. 브리지 착수 전 상품 단위 GREEN 재확인 | 게이트 SB2 |

---

## H. 자격증명·접근 제약

| ID | 제약 | 상태 |
|----|------|------|
| **I-CRED-1** | `HUNI_ADMIN_PW` stale — product-viewer 화면축 3원 대조 BLOCKED(§21 K6 5연속) | 자격증명 갱신 후 라이브 화면축 재실행. 본 설계는 DB 읽기전용 SELECT(2026-06-25 재실측 확인)로 대체 |
| **I-CRED-2** | clientId·토큰·refreshToken 비밀값 | `.env.local`/BFF 서버 세션 보관·클라이언트 노출 최소(특히 clientId=몰 식별 비밀값). 산출물/로그/프롬프트 키 이름만 |

---

## 정직성 노트

- 본 설계가 **확정한 것**: 라인 가격 직접 주입 불가(부정 확정)·계산가 생존 유일 경로=등록가 동기화·전략 D/P-B
  권고(트레이드오프 인용)·종단 operationId 바인딩(dead link 0)·위젯→BFF→Shopby 카트 계약·라이브 토대 행수 재실측.
- 본 설계가 **확정 못한 것(추정 0으로 분리)**: P-B 심사/정산 관문(I-PRICE-1/2/3 BLOCKED)·결제 확정 흐름(I-PAY-1)·
  auth raw shape(I-AUTH-2)·라인 구조화 첨부(I-META-1/I-FILE-1)·상품별 실견적 성공(I-VERIFY-*).
- **갭필 후보(docs.shopby.co.kr, WebFetch 읽기전용·부족분만)**: I-PRICE-1(심사 정책)·I-PRICE-2(정산)·
  I-PAY-1(결제편의모듈)·I-AUTH-2(auth OpenAPI)·I-OS-1(주문서 일반주문)·I-CART-1(게스트 카트).
- **인간 승인 선결**: I-AUTH-1(운영방식)·I-AUTH-3(외부회원)·I-STRAT-1(전략 분리)·I-RED-1(RED 범위)·I-NAVER-1.

## 보정 루프 반영 (게이트 NO-GO → architect 보정, 2026-06-25)

게이트 SB1·SB2 FAIL → `05_gate/remediation-spec.md` R-1~R-9 적용 완료(설계 본문 반영):

- **R-1/X03(돈크리)** — 가격 불변식 명문화: `integration-architecture §4.2.1`·`widget-cart-contract §4.0`
  (salePrice=0·즉시/추가할인=0·addPrice=final_price·첫 옵션 addPrice=0→가격 별 옵션행).
- **R-2/X05(보안)** — server API 인증 분리: `integration-architecture §1.1`(경계도+두 클라이언트)·`widget-cart-contract §4.1`
  (systemKey만·.env.local/BFF·실패 격리/레이트/동시성 → I-PRICE-3 보강).
- **R-3/X08** — order-sheet calculate `addressRequest`(4필수)+`shippingAddresses[].payProductParams[]`: `e2e §0/§1/§2 #7`.
- **R-4/X09** — reserve 필수9 전체 명시 + `paymentAmtForVerification`(nullable·운영필수 주석): `e2e #8`·`widget-cart-contract §6.1`.
- **R-5/X04** — put-product-options 완전 payload shape(options[]/inputs[])+`mallOptionNo=0(신규)/기존(수정)` 분기: `widget-cart-contract §4.2`.
- **R-6/X07** — post-order-sheet `products[].recurringPaymentDelivery` 명시 + 일반주문 빈/null shape=**I-OS-1 갭필**: `e2e #5`.
- **R-7/X10** — guest-token = `POST /previous-orders/guest/{orderNo}` + {password}: `e2e §0 #10g·§2`(tempPassword와 동일 자격).
- **R-8(정직성)** — "dead link 0"→"operationId 연결 0 끊김 / 필수 필드 갭은 X07·X08·X09·I-OS-1로 분리": `e2e §0·§5`.
- **R-9/X01** — bridge-spec §1.2 member post-cart `channelType?` 제거+`I-CART-2` 주석(구현=schema 기준): `02_bridge/product-price-bridge-spec.md §1.2`.

> 미상은 여전히 교정 아님 — 갭필(I-OS-1·I-PAY-2 등)·인간 승인(I-PRICE-1/2/3·X11 immutable 옵션 정책 등)으로 분리(추정 0).
