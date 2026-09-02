# API 읽기 2건 — A-13(비회원 구매 설정) · A-5(viewShopSpecification)

> 작성일 **2026-09-02** · 카드 `L0/CARDS-Q.md` §Q2 할 일 3 · lane `plan-huniweb`
> 실행 스크립트 `api_check_a13_a5.py` · 요청 로그 `_get-log.txt` · 원자료 `a13-nonmember-purchase.csv` · `a5-order-configs.json`
> **전건 GET · 쓰기 0 · 자격증명 값은 어떤 파일에도 기록하지 않았다.**

## 0. 한 장 요약

| 항목 | 물어본 것 | 실측 답 | 뒤집힌 것 |
|---|---|---|---|
| **A-13** | 상품 226개의 「비회원 구매 **불가**」 설정값 | **297건 전건 `nonmemberPurchaseYn = Y`(구매 가능)** · 판매중 226건도 전건 Y | ★ **뒤집혔다** — 「불가」로 설정된 상품이 **0건**이다 |
| **A-5** | `viewShopSpecification` 현재 설정값 | **`false`** — 거래명세서가 고객에게 노출되지 않는다 | 뒤집힘 없음(값이 확정됐다) |

두 건 모두 **닫혔다.** 셀러어드민 접속 없이 API 읽기만으로 끝났다.

## 1. 인증 — Q0 와 같은 경로인가

| 대상 | 쓴 API | 인증 | Q0 와 같은가 |
|---|---|---|---|
| A-13 | **서버 API** `GET /products/search` · `GET /products/{mallProductNo}` | `systemKey` + `Authorization: Bearer <서버 액세스 토큰>` | **같다** |
| A-5 | **샵바이 API** `GET /order-configs` | `clientId` + `platform` 헤더 | **다르다 — 아래 사유** |

> **A-5 만 인증이 다른 이유**: `/order-configs`(주문 설정 값 가져오기)는 **shop-public 스펙에만 존재**한다
> (`docs/shopby/shopby-api/order-shop-public.yml:3721`). 서버 API(`order-server-public.yml`)에 같은 경로가 없어
> grep 0건이다. 그래서 서버키 대신 몰 `clientId` 로 읽었다. **둘 다 GET 이고 둘 다 읽기 전용**이다.

## 2. A-13 — 비회원 구매 설정값 전수

### 무엇을 읽었나

`GET /products/search` 로 상품 전건(297)을 열거하고, 상품마다 `GET /products/{mallProductNo}` 를 읽어
응답의 `mallProduct.nonmemberPurchaseYn` 을 가져왔다. 필드 뜻은 스펙 그대로 —
「비회원구매 가능여부 · Y(가능), N(불가능)」(`product-server-public.yml:6784`).

### 결과

| 구분 | 건수 | `nonmemberPurchaseYn` |
|---|---:|---|
| 판매중(`ONSALE`) | **226** | **전건 `Y`** |
| 판매정지(`STOP`) | **71** | **전건 `Y`** |
| **합계** | **297** | **`N` 0건 · 빈값 0건** |

같이 읽힌 값: `minorPurchaseYn` 도 **297건 전건 `Y`**(미성년자 구매 가능).
회원등급·회원그룹 노출 제한(`memberGradeDisplayInfo` · `memberGroupDisplayInfo`)은 **297건 전건 없음**.

### Q0 결과와 교차 대조 — 상품 집합이 정확히 겹친다

| Q0 분류(텍스트 옵션) | 판매상태 | 건수 |
|---|---|---:|
| `huni_item` 있음 | `ONSALE` | **226** |
| 둘 다 없음 | `STOP` | **71** |

즉 **「판매중 226 = 후니 옵션이 붙은 상품」 · 「정지 71 = 옵션이 없는 상품」** 이 한 치도 어긋나지 않는다
(`L5/Q0/label-check.csv` ↔ `a13-nonmember-purchase.csv`, 297건 키 완전 일치).

### 이게 무슨 뜻인가 — 쉬운 말로

물음은 「비회원이 못 사게 막아 둔 상품이 몇 개인가」였다. **한 개도 없다.**
판매중인 226건 전부 비회원이 그냥 살 수 있다.

그래서 두 가지가 따라온다.

1. **무통장 관통을 비회원(게스트)으로 돌릴 수 있다.** 절차서 단계 6 이 시크릿 창을 쓰는 근거다.
   덕분에 E-5(비회원 자동 알림)·E-6(게스트 경로)을 같은 주문 하나로 같이 본다.
2. **게스트 `item_id` 소유권 검증 문제(D-6)가 이론이 아니라 현실이다.** 게스트는 서버 장바구니가 없어
   검증원이 없는데(`contract-c2-shopby.md:463`), 상품 226건이 전부 게스트 구매 가능이므로
   **그 경로가 실제로 열려 있다.** 설계 미정 상태 그대로 오픈하면 남의 주문 요약·금액이 읽힐 수 있다.

### 남는 미확인

- **설정 화면에서 이 값이 어떻게 보이는가**는 못 봤다(셀러어드민 미접속). API 값만 확정됐다.
- **몰 단위 비회원 구매 차단 설정**이 따로 있는지는 이 조회로 알 수 없다. 상품 단위 값만 읽었다.

## 3. A-5 — `viewShopSpecification`

### 결과 (`GET /order-configs` 응답 원문에서 발췌)

| 키 | 값 | 뜻 |
|---|---|---|
| **`viewShopSpecification`** | **`false`** | **거래명세서를 고객에게 보여주지 않는다** |
| `shopSpecificationFields` | `["IMMEDIATE_DISCOUNT_PRICE", "PRODUCT_NO"]` | 명세서에 실릴 항목 설정(노출은 꺼져 있음) |
| `specificationAdditionalInfo` | `""` | 추가 안내문 없음 |
| `visibleReceiptBtn` | `{specification:false, pgReceipt:false, specificationBrief:false}` | **영수증·명세서 버튼 3종 전부 숨김** |
| `useSimpleReceipt` · `usePaymentReceipt` | `false` · `false` | 간이영수증·결제영수증 미사용 |
| `cashReceipt` · `cashReceiptRequired` | `false` · `false` | **현금영수증 기능이 꺼져 있다** |
| `pgType` | **`null`** | **PG 가 연동돼 있지 않다** |
| `escrow.escrowInfoKey` | `null` | 에스크로 미설정 |

### 이게 무슨 뜻인가

**A-5 의 원래 걱정은 「거래명세서가 고객에게 도달하면 10원 × 1,500개가 그대로 나간다」였다.
그 경로는 지금 닫혀 있다.** 명세서도 영수증 버튼도 전부 꺼져 있어 고객 화면에 뜨지 않는다.

다만 **운영자 화면에서는 여전히 출력할 수 있다.** 그래서 A-4(거래명세서 수량 표기)는
「고객 노출 위험」이 아니라 「담당자가 보는 화면」 문제로 성격이 바뀐다 —
절차서 단계 13 이 이 구분을 반영한다.

### 덤으로 확정된 것 두 가지

1. **`pgType = null`** — 몰에 PG 가 연동돼 있지 않다는 **직접 증거**다.
   원장 `X-PG-CONTRACT-01` 의 「계약 미체결·라이브몰 결제수단 ACCOUNT/NONE만」과 같은 방향이고,
   C-1(후니가 PG 파이프라인 어느 단계인가)의 **몰 쪽 절반**을 API 로 뒷받침한다.
   이니시스 가맹점 쪽 단계는 여전히 미확인이다(캡처 1장 필요).
2. **`cashReceipt = false`** — 현금영수증 발행이 꺼져 있다.
   그래서 **E-1(현금영수증 수량 표기 형식)은 무통장 관통으로도 닫히지 않는다.**
   설정을 켜는 것은 이 카드 범위 밖이자 별도 승인 사안이다.

## 4. 완료조건 대조

| 조건 | 결과 | 증거 |
|---|---|---|
| ④-1 API 2건 **GET 전건** | **충족** — 요청 304건(order-configs 1 + 상품목록 6 + 상품상세 297), 메서드 집합 `{'GET'}`, 비200 응답 **0** | `_get-log.txt` · 스크립트 출력 |
| ④-2 **키 노출 0** | **충족** — 자격증명은 환경변수에서만 읽고, 산출 4파일 어디에도 값이 없다 | `_verify-q2.txt` 기계 grep |
| 쓰기 0 | **충족** — POST/PUT/PATCH/DELETE **0건** | `_get-log.txt` 전건 `GET` |
| 셀러어드민 접속 | **0회** | 이 카드는 API 만 읽었다 |

## 5. 역방향 — 물음 대비 뒤집힌 것

| # | 원래 물음(`open-questions.md` §A) | 실측 | 성격 |
|---|---|---|---|
| 1 | A-13 「상품 226개의 **비회원 구매 불가** 설정값」 | **불가로 설정된 상품 0건.** 297건 전건 구매 가능 | **물음의 전제가 뒤집혔다.** 「몇 개가 막혀 있나」가 아니라 「하나도 안 막혀 있다」 |
| 2 | A-13 은 「상품 목록 또는 조회 API」로 닫는다고만 적혀 있었다 | 목록(`/products/search`)에는 이 필드가 **없다.** 상품 상세(`/products/{no}`)를 상품마다 읽어야 나온다 | 조회 비용이 1회가 아니라 297회다 |
| 3 | A-5 는 「켜져 있으면 거래명세서가 고객에게 도달」 | **꺼져 있다.** 도달 경로가 닫혀 있어 위험도가 내려간다 | 위험 판정이 낮아지는 방향 |
| 4 | (물어보지 않았는데 나온 것) | `pgType = null` · `cashReceipt = false` | C-1 보강 · E-1 봉쇄 |

**삭제·축소한 것 0건.** 이 문서는 A-13·A-5 두 항목에 값을 채웠을 뿐, 기존 판정을 지우지 않았다.
