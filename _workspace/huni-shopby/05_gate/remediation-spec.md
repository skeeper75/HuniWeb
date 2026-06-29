# remediation-spec.md — 확정 결함 교정 명세 (단계·수정 대상·라우팅·인간 승인 큐) · 재게이트 R2

> 산출자: hsb-integration-gate. 작성: 2026-06-25 (재게이트 2회차, 보정 루프 후).
> 범위[HARD]: 게이트가 스펙·라이브로 **직접 재확인한** 사항만. 미상(I-AUTH-2·I-PAY-1 등)은 교정이 아니라
> 갭필/인간 승인 큐로 분리(추정 0). 실 구현/연동은 **인간 승인 후 §6 huni-widget 트랙 위임** — 본 명세는
> 검증·교정명세까지(DB 미적재·라이브 읽기전용·server API 쓰기 0). 비밀값(systemKey·clientId·토큰) 키 이름만.

---

## 0. 상태 요약 — 직전 NO-GO(R1) 교정 8건 전부 CLOSED

직전 게이트 R1은 SB1·SB2 FAIL(돈크리 X03·X05·주문실패 X08·X09 외)로 **NO-GO**였고, R-1~R-9 보정을 architect로
되돌렸다. 재게이트 R2에서 게이트가 **각 보정을 스펙 라인으로 직접 재확인**한 결과 8건 전부 설계 본문에 반영됨 →
**CLOSED**. 신규 확정 결함 적발 0. 따라서 **신규 교정(remediation) 항목 0**이며, 본 명세는 ① CLOSED 교정 검증
②실 구현 착수 전 닫혀야 할 BLOCKED 관문·갭필·잔여 검증 포인트의 **인간 승인/갭필 큐**로 종합한다.

| R | 직전 결함 | 교정 위치 | 게이트 재확인(스펙 라인) | 상태 |
|---|----------|----------|------------------------|:---:|
| R-1/X03 | salePrice=0 불변식 미명문(돈크리) | integration-arch §4.2.1·widget-cart §4.0 | product-shop:799-800(즉시할인 비대칭)·product-server 8곳(첫옵션0) | ✅ CLOSED |
| R-2/X05 | server API 인증 미분리 | integration-arch §1.1·widget-cart §4.1 | product-server:1756-1815(systemKey required·server-api base) | ✅ CLOSED |
| R-3/X08 | calculate addressRequest 누락 | e2e §0/§1/§2 #7 | order-shop:28580·28588(required·4하위필수) | ✅ CLOSED |
| R-4/X09 | reserve 필수9 축약 | e2e #8·widget-cart §6.1 | order-shop:33000(9필수)·33398(검증액 nullable) | ✅ CLOSED |
| R-5/X04 | put-product-options full shape 부재 | widget-cart §4.2 | product-server schema products-options-915318368 example | ✅ CLOSED |
| R-6/X07 | recurringPaymentDelivery 누락 | e2e #5 | order-shop:21436(products[] required) | ✅ CLOSED |
| R-7/X10 | guest-token method/body 오기 | e2e §0 #10g·§2 | order-shop:5304 post:·5352 {password} | ✅ CLOSED |
| R-8 | "dead link 0" 과장(필드갭 은폐) | e2e §0·§5 정직성 분리 | operationId 연결/필드갭 구분 반영 | ✅ CLOSED |
| R-9/X01 | bridge-spec member channelType 잔존 | bridge-spec §1.2 정정 | cart-1115878954 channelType 부재 | ✅ CLOSED |

---

## A. 실 구현 착수 전 닫혀야 할 BLOCKED 관문 (인간 승인·갭필 선결 — CONDITIONAL 사유)

> 게이트가 GO를 냈으나 **CONDITIONAL** — 아래 3관문은 전략 D/P-B 가격 메커니즘의 결정적 선결이며, 설계가
> 추정으로 메우지 않고 정직 분리(open-issues §A). 닫히기 전 실 구현(특히 P-B 동적 옵션 등록) 착수 금지.

| ID | 무엇이 막혔나 | 닫는 법 | 닫히지 않으면 | 승인 주체 |
|----|--------------|---------|--------------|----------|
| **I-PRICE-1** | P-B(주문 직전 옵션 동적 생성)가 상품심사 "수정 후 승인대기" 유발 여부 (judgement.mdx:9,35) | docs.shopby.co.kr 상품심사 정책 갭필 + 라이브 admin 읽기 탐색(쓰기 금지) | 전략 D 붕괴 → **전략 A(P-A 사전 동기화)로 마이그레이션**(설계 §2.3, 고정가·소조합부터). 위젯/BFF 정규화 계약 무변경 | 인간 + 갭필 |
| **I-PRICE-2** | 정산이 라인 salePrice/addPrice를 권위로 쓰는지 (정산=NATIVE) | settlement yml(있으면)+enterprise 정산 매뉴얼 갭필 | 정산 왜곡 위험. P-B로 라인가=후니가 일치시키면 정합되나 소스 미확인 | 인간 + 갭필 |
| **I-PRICE-3** | P-B 동적 옵션의 동시성·잔존 청소·**클레임 추적(X11)**·server API 격리·노출 지연 | 라이브 admin 동작 확인(읽기) + 운영 설계. **immutable 옵션 정책 권고**(주문 묶인 옵션 삭제 금지·useYn=N만·addPrice 변경/삭제 금지) | 청소(GC)↔클레임/정산 추적성 충돌(과거 주문 옵션 참조 끊김) | 인간 |

---

## B. 갭필 큐 (docs.shopby.co.kr WebFetch 읽기전용·부족분만 — 추정 아님)

| ID | 미상 | 갭필 대상 | 영향 |
|----|------|----------|------|
| **I-AUTH-2** | post-oauth2-token/openid requestBody raw shape | auth OpenAPI(본 레포 yml에 oauth2 path/operationId 0건·게이트 grep 확인) | 회원 로그인 구현 상세(외부회원 일부 shape는 member-shop:2409·2447에 실재) |
| **I-PAY-1** | 결제 확정(주문 생성) 전용 POST·PG↔Shopby 콜백 | NCPPay 결제편의모듈·app-payment-module 가이드 | reserve 후 결제 확정 흐름(현재 confirmUrl만 확인) |
| **I-PAY-2** | subPayAmt/externalPayInfos ↔ paymentAmtForVerification 산식 | 외부결제/복합결제 가이드 | 복합결제 검증액 정합 |
| **I-OS-1** | recurringPaymentDelivery 일반(비정기) 주문 빈/null shape | 주문서 일반주문 예시 | 일반 주문서 작성(필수키 채움법) |
| **I-CART-1** | 게스트 cartNo 출처/채번 | 비회원 장바구니 가이드 | 게스트 카트 라인 조립 |
| **I-META-1/I-FILE-1** | 라인 단위 customProperty·구조화 파일메타 첨부 경로 | order-server 라인 스키마·주문 가이드 | 원고 구조화 첨부(현재 텍스트 식별자 무손실로만) |

---

## C. 잔여 검증 포인트 (라이브/위젯 실호출 — §6 위임·인간 승인 후)

> 게이트는 스펙+라이브 읽기전용까지. 아래는 실호출/쓰기가 필요해 게이트 범위 밖(파괴적 쓰기·실견적 실호출).

| ID | 미검증 | 검증 방법 | 검증 주체 |
|----|--------|----------|----------|
| **VP-X03** | 별행(order≥2) addPrice>0 옵션이 put-product-options로 실제 등록·심사 통과·즉시 노출 | 인간 승인 후 라이브 server API 쓰기(테스트 상품) + 심사 상태 추적 | §6 / 인간 승인 |
| **I-VERIFY-1** | 가격소스 104상품의 strict 실호출 final_price>0 실비율 | evaluate_price strict 실호출(상품별) | §6 huni-widget |
| **I-VERIFY-2** | 옵션→차원 ref_dim 풀이가 위젯/BFF 어댑터에서 무손실 재현 | 위젯 CONTEXT vs 라이브 시뮬 대조 | §6 |
| **I-VERIFY-3** | 셋트 7부모 evaluate_set_price PRICE≠0·이중합산 0 | evaluate_set_price 실재계산 | §23 set-gate / §6 |

---

## D. 인간 승인 결정 큐 (선결 — 구현 방향 결정)

| ID | 결정 필요 | 기본 권고 |
|----|----------|----------|
| **I-AUTH-1** | 몰 운영방식(스킨몰 vs headless) | headless(CPQ 위젯·커스텀 주문 자유도) — Aurora index.mdx 근거 |
| **I-AUTH-3** | 외부회원 연동(ncpstore) 채택 + 고객사 회원정보 조회 API 1:1 등록 | 후니 회원 권위 위치에 따라 결정 |
| **I-STRAT-1** | CPQ 유한·열거(전략 A) vs 연속·매트릭스(전략 D/P-B) 분리 확정 | 고정가/축≤5부터 A 파일럿, 면적/구간형은 D(하이브리드) |
| **I-RED-1** | RED 카테고리(하드커버책자·포토북·아크릴·캘린더·조합형, 가격소스 0) 브리지 범위 | 브리지 제외 또는 인간 승인 후 dbmap 선적재 |
| **I-NAVER-1** | NaverPay 별도 mini-OrderSheet 1차 범위 포함 여부 | PM/architect 결정 |
| **I-MAP-1** | prd_cd↔productNo 매핑 마스터 소유/동기화 주체 | 후니 백엔드 권위(멱등 managementCode 역조회) |

---

## E. 라우팅 요약

- **architect 보정 루프**: 불필요(R-1~R-9 CLOSED·신규 결함 0).
- **§6 huni-widget(구현)**: 인간 승인 후 — BFF 어댑터(두 API 클라이언트·P-B 가격 동기화·optionInputs 평면화·에러
  정규화)·VP-X03/I-VERIFY-* 실호출 검증.
- **갭필(WebFetch 읽기전용)**: B표(I-AUTH-2·I-PAY-1/2·I-OS-1·I-CART-1·I-META-1/I-FILE-1).
- **dbmap 적재 트랙(인간 승인 후)**: I-RED-1(RED 가격소스 0 상품 선적재 시).
- **§23 set-gate**: I-VERIFY-3(셋트 가격 재계산).

> ★ 결론: 직전 NO-GO 8 교정 전부 CLOSED·신규 결함 0 → 설계 검증 GO(CONDITIONAL). 실 구현 착수의 게이트는
> A표 BLOCKED 3관문(특히 I-PRICE-1 상품심사)이며, NO면 전략 A 마이그레이션으로 흡수(위젯/BFF 계약 무변경).
