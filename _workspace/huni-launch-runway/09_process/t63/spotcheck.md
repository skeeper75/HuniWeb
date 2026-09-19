# t63 표본 재검 — 조사 레인 주장을 리드가 직접 열어 확인한 기록

생성(조사 레인)과 검증(이 카드 리드)을 분리한다는 공통 프로토콜 ④에 따라,
레인이 적어 낸 `path:line` 중 판정에 무게가 실리는 것을 직접 열어 확인했다.
기계 전수 검산(`verify.py` G6)과 별개의, 내용까지 읽은 표본이다.

## 확인한 것

| row_id | 레인 주장 | 직접 확인 | 판정 |
|---|---|---|---|
| STD-CAT-043 | `raw/webadmin/webadmin/config/urls.py:248` 에 `api/w/v1/catalog` | `path("api/w/v1/catalog", wapi.api_catalog, name="wapi_catalog")` 실재 | 일치 |
| STD-CAT-036 | `urls.py:288` 에 `api/w/v1/designs` | `path("api/w/v1/designs", wapi.api_designs, ...)` 실재 | 일치 |
| STD-CAT-043 | `widget_api.py:5844` 가 `api_catalog` 정의 | `def api_catalog(request):` 실재 | 일치 |
| STD-CAT-039 | `widget_api.py:5955-5958` 가 시작가 산출 | 같은 함수 안에서 `from catalog import start_price as SP` · `SP.start_price_map(...)` 확인 | 일치 |
| STD-CAT-040 | `huni-skin-shopby/src/lib/api/server/catalog.ts:86` 이 샵바이 salePrice 를 그대로 읽음 | `price: p.discountedPrice ?? p.salePrice ?? 0` 실재 | 일치 |

## 한 가지 바로잡은 읽기

`api_catalog` 의 docstring 에 **「R2: 표시 필드만 노출 — 가격·화면 구성(cfg)은 없다」**(`widget_api.py:5850` 부근)가
남아 있어, 문서만 보면 이 엔드포인트가 가격을 안 준다고 읽힌다.
그러나 같은 함수 본문이 `t_prd_start_prices` 를 읽어 시작가를 실어 보낸다(260823-vbx · 설계 A-4 주석).
**docstring 이 낡았고 코드가 최신이다.** 이 카드는 코드를 따른다.

## 이 표본이 받치는 판정

시작가가 「API 로 내려가는데 쇼핑몰에 안 보인다」(STD-CAT-040)의 원인은 다음으로 좁혀진다 —
webadmin 은 **자기 catalog API 로** 시작가를 내보내고 있고, 샵바이 상품 필드로 **밀어넣지는 않는다**.
그런데 huni-mall 은 그 API 가 아니라 **샵바이 원본 salePrice** 를 읽는다.
즉 두 쪽이 서로 다른 그릇을 보고 있다. 이관(STD-CAT-043)은 이 어긋남을 없애는 작업이다.

단, 「샵바이로 미는 코드가 없다」는 부재 주장은 레인의 grep 결과이고
이 카드에서 `shopby_sync.py` 전문을 직접 읽어 재확인하지는 않았다 — **찾지 못했다**로 남긴다.

---

# 2차 표본 — 결제·배송 (PAY/SHP 레인)

| row_id | 레인 주장 | 직접 확인 | 판정 |
|---|---|---|---|
| STD-PAY-001 | 카드 탭은 있으나 제출이 막혀 있다 | `checkout-form.tsx:365-371` 에 `if (values.paymentMethod !== "bank_transfer")` → 토스트 「현재 무통장입금만 지원합니다」 후 `return` | 일치 |
| STD-PAY-031 | 10원×수량 모델이 코드에 있다 | `src/lib/api/widget-order.ts:26` `SHOPBY_AMOUNT_UNIT = 10` · `:33` `amountToOrderCnt()` 실재 | 일치 |
| STD-PAY-031 | README 가 표시↔청구 불일치를 알려진 이슈로 적어 놨다 | `README.md:70-71` 에 「⚠ 알려진 이슈 … 표시↔청구 불일치, 별도 과제」 실재 | 일치 |

## 여기서 눈에 걸린 것 — 문서와 코드가 서로 다른 말을 한다

`README.md:70-71` 은 **「표시 금액은 위젯 총액을 따르지만 실제 PG 청구액은 shopby 가
서버에서 옵션가 기준으로 확정한다」**고 적어 불일치를 경고한다.
그런데 `widget-order.ts:20-35` 의 10원 단위 모델은 **판매가 10원 × 수량(=총액÷10)** 으로
청구액이 위젯 총액과 같아지게 만드는 배선이다. 둘은 같은 것을 다르게 말한다.

셋 중 하나다 — (1) README 경고가 10원 모델보다 먼저 쓰였고 낡았다,
(2) 10원 모델이 일부 경로에만 걸려 있고 나머지 경로는 여전히 옵션가로 청구된다,
(3) 옵션가 절삭 때문에 특정 금액대에서만 어긋난다.
**이 카드에서 어느 쪽인지 가리지 않았다.** 결제단위 10원은 t61 리드 보강 판정을 그대로 따르고,
실제 청구액 대조는 라이브 결제를 태워야 확정되므로 `gaps.csv` 의 `STD-PAY-031` 로 남긴다.
(공통 프로토콜 ③ — 라이브는 읽기 탐색만, 주문·결제 금지.)

---

# 3차 표본 — 비회원 경로 (ORD 레인)

비회원 주문·조회는 이 카드가 명시적으로 떠안은 관심사라 직접 열어 봤다.

| row_id | 원장이 말하는 것 | 코드가 하는 것 | 판정 |
|---|---|---|---|
| STD-ORD-022 | 「비회원 주문 조회(**주문번호+휴대전화**)」 | `guest-order-lookup.tsx:28` 스키마가 `password` 를 요구하고, `:136` 기본값도 `{orderNo, password}`, `:150` 요청 본문도 `{password}` 뿐. 폼에 **휴대전화 입력칸이 없다**(`:188` 「비밀번호」 필드) | **불일치** |
| STD-ORD-007 | 비회원 장바구니(비영속) | `guest-cart.ts:3-8` — 샵바이 `/cart` 가 회원 전용이라 **localStorage** 에 담는다고 코드 주석이 명시 | 일치 |
| STD-ORD-030 | 주문등록 S2S | `widget_api.py:5286-5303` 에 수신측 `POST /api/w/v1/order/register` 실재. 호출측(huni-mall)은 못 찾았다 | 일치(수신만 있음) |

## STD-ORD-022 — 원장과 코드가 다른 본인확인 수단

파일 주석(`:6-7`)은 **「주문번호 + 주문 시 입력한 비밀번호」**라 적고,
API 스펙은 `POST /guest/orders/{orderNo}` 에 `{password, mobileNo?}` 를 받는다 —
**`mobileNo` 는 선택 파라미터이고 UI 가 쓰지 않는다.**

즉 기능은 돌지만 **원장 행이 적어 둔 수단과 실제 수단이 다르다.**
어느 쪽이 맞는지는 이 카드가 정할 일이 아니다(본인확인 수단은 정책이다).
`gaps.csv` 에 「다 코드는 있는데 연결 안 됨」으로 올리고, 판단은 정책 주체에 남긴다.
원장 제목을 이 카드에서 고치지 않는다 — 735행에 손대지 않는다는 경계를 지킨다.
