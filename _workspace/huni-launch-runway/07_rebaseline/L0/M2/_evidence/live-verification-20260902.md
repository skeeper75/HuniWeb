# M2 라이브 확인 기록 — 2026-09-02

> 카드 M2 [HARD] 순서 ①매뉴얼 → ②라이브 → ③코드 중 **②라이브** 단계의 관측 기록.
> 전부 읽기전용. 주문·결제·폼제출·DB write 없음. `submit()`·「장바구니 담기」는 누르지 않았다.

## L-1 ★ SDK 개발자 가이드가 라이브에 게시돼 있다 (최대 수확)

`https://huni-admin.printly.co.kr/sdk/guide/` — HTTP 200. 「후니 주문위젯 — 임베드 SDK 개발자 가이드」.
전문 2,132줄을 `_evidence/sdk-guide-live-20260902.txt` 에 보존했다.

**이것이 C1·C2·C3 의 1차 계약 문서다.** 앱 내장 매뉴얼 2종(`manual_content.py`·`widget_manual_content.py`)은
**운영자용**이라 SDK·API 계약을 담지 않는다 — 그 자리를 이 별도 문서가 맡는다. 따라서 「매뉴얼에 SDK 절이 없다」는
매뉴얼 결함이 아니라 **문서 분리**다. (앱 내장 매뉴얼에서 `sdk`·`api/w/v1` grep 0건인 것이 이 때문이다.)

로컬 생성원: `raw/webadmin/tools/gen_sdk_guide.py` (124,951 B · 2026-08-28). 라이브 페이지의 원고이므로
정확한 필드명·에러 문자열은 이 파일을 file:line 으로 인용하는 편이 낫다.

문서 하단 서명: 「재생성: tools/gen_sdk_guide.py · 문의: 후니 개발팀」.

### 이 문서가 닫아 준 M2 「반드시 답할 것」

| 질문 | 답 | 근거 |
|---|---|---|
| Shopby 쿠폰·적립금이 「10원 × N」과 충돌하는가 | **충돌하지 않는다.** 샵바이 쿠폰은 전부 금액 기준. 정액 쿠폰도 「상품별 총 상품금액 기준, 수량별로 할인되지 않음」(샵바이 문서 원문 인용 + 예시). 적립금은 현재 미사용이고 적립률(%)도 금액 기준 | §11 · `sdk-guide-live-20260902.txt:1115-1127` |
| Shopby 배송비는 충돌하는가 | **유형에 따라 충돌한다.** 수량 비례(`QUANTITY_PROPOSITIONAL_FEE`)·수량별 차등(`QUANTITY_FEE`)·중량별 차등(`WEIGHT_FEE`)은 **영구 금지**. 허용은 `FREE`·`CONDITIONAL`(금액)·`FIXED_FEE`·`PRICE_FEE`(금액) 넷뿐 | 같은 파일 `:1096-1114` |
| 그 밖에 금지되는 것 | 1회 최대구매수량 제한(= 결제 금액 상한이 됨) · 즉시할인(= (판매가−할인)×수량 이라 청구액 어긋남) · 상품 중량 입력 | `:1099-1107` |
| shopby webhook 이 무엇을 받는가 | 가이드는 **결제 완료**를 웹훅으로 받는다고 진술(「결제 완료 자체는 저희가 쇼핑몰 웹훅으로 따로 받습니다」). 실제 수신 이벤트 전수는 `shopby_hook.py` 대조 필요 → `interface-6.md` I-5 | `:334`, `:1395-1400` |
| 비회원(게스트) 구매 | 이 문서는 답하지 않는다 → `contract-c2-shopby.md` 에서 판정 | — |

### 주의 — 이 문서의 라이브 관측 주장은 후니팀의 주장이다
「지금은 전부 꺼져 있는 것을 확인했고」(금지 설정) · 「현재 라이브 재고 9,999」 · 「현재 품절 상품 0건」 ·
「판매가 10원 226개 일괄 변경 완료」는 **후니팀이 관측했다고 적은 것**이지 내가 관측한 것이 아니다.
재확인하려면 샵바이 셀러어드민 실화면이 필요하다. `promotion-conflict.md` 는 이 구분을 유지해야 한다.

## L-2 site_key 게이트 실동작 (내가 직접 관측)

```
$ curl -s -o - -w "HTTP %{http_code}" https://huni-admin.printly.co.kr/api/w/v1/catalog
HTTP 403  {"ok": false, "error": "유효하지 않은 site_key 입니다.", "code": "bad_site_key"}

$ curl -s -o - -w "HTTP %{http_code}" ".../api/w/v1/catalog?site_key=wk_invalid"
HTTP 403  {"ok": false, "error": "유효하지 않은 site_key 입니다.", "code": "bad_site_key"}
```

- 키 **없음**과 키 **틀림**이 호출자에게 구별되지 않는다(같은 403·같은 code).
- 브라우저가 아닌 호출이라 Origin 이 없는데도 `origin_not_allowed` 가 아니라 `bad_site_key` 가 먼저 났다 —
  **site_key 검사가 origin 검사보다 앞선다**는 뜻.
- 관측 일시 2026-09-02. 라이브는 움직이므로 인용 시 이 일시를 함께 적는다.

## L-3 라이브 데모가 공개돼 있다

`https://huni-admin.printly.co.kr/sdk/demo/?wgt=WGT_000288` (내장 버튼) ·
`…&mode=host` (자체 버튼 `hide-submit` 모드). 가이드가 「코드 없이 임베드 동작·이벤트·submit 결과를 확인」하는
용도로 안내한다.

**여기서 멈췄다.** 데모의 `submit()` 은 실제 핸드오프 토큰을 발급한다 — 주문은 아니지만 서버 상태를 만드는
제출 행위라, 카드의 「주문·결제·폼제출 금지」에 걸린다고 보아 누르지 않았다. 위젯 실동작 관찰은 **M1 의 축**이므로
그쪽에서 다루는 편이 맞다.

## L-4 API 스펙(Swagger) 은 공개 URL 로는 못 찾았다

가이드 목차에 「API (Swagger)」 항목이 있으나, 아래는 전부 404 (2026-09-02):
`/sdk/openapi.json` · `/api/w/v1/openapi.json` · `/sdk/swagger/` · `/api/w/v1/schema`.

**미확인** — Swagger 가 가이드 페이지 내부 렌더인지 별도 경로인지 확정하지 못했다.
닫으려면: 가이드 페이지의 해당 목차 앵커를 눌러 실제 이동 경로를 보거나, `gen_sdk_guide.py` 에서
Swagger 섹션 생성부를 읽으면 된다.

## L-5 환경변수로 확인한 접속면 (값은 비밀 — 키 이름만)

| 키 | 값 | 뜻 |
|---|---|---|
| `SHOPBY_SHOP_API_URL` | `https://shop-api.e-ncp.com` | 쇼핑몰 API — IP 제한 없음 |
| `SHOPBY_SERVER_API_URL` | `https://server-api.e-ncp.com` | 관리자용 server API — **등록 IP 에서만** |
| `SHOPBY_ADMIN_URL` | `https://service.shopby.co.kr` | 셀러어드민 |
| `SHOPBY_API_PROFILE` | `real` | **운영 프로필** — 테스트 환경이 아니다 |
| `HUNI_ADMIN_URL` | `https://huni-admin.printly.co.kr/admin/product-viewer/` | webadmin |
| `HUNI_BFF_URL` | `http://localhost:3000` | 자사몰 BFF 가 **로컬** — 배포 오리진 미확인 |

`SHOPBY_API_PROFILE=real` 이라 이 자격증명으로 하는 모든 호출이 운영에 닿는다. 조사 중 쓰기 호출을 하지 않은
이유가 이것이다.

## 남긴 미확인 (라이브로만 닫히는 것)

1. 샵바이 셀러어드민에서 금지 설정 4종이 실제로 꺼져 있는가 (가이드의 주장 재확인)
2. 샵바이 배송 템플릿이 실제로 `FREE` 인가
3. 알림 템플릿의 수량 치환(`count`·`productNames`) 제거 여부 — 가이드가 ★미확정으로 남김
4. 세금계산서·현금영수증의 품목·수량 표기 — 완화책이 진술돼 있지 않다
5. shopby webhook 이 샵바이 쪽에 실제로 등록돼 있는가
6. 자사몰 배포 오리진과 허용 도메인 등록 현황
