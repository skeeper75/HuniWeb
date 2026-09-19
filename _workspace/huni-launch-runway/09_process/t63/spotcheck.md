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
