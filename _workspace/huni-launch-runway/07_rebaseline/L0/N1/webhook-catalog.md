# N1 — 샵바이 웹훅 발신면 카탈로그

> **범위**: 샵바이(Shopby)가 **밖으로 내보내는** 이벤트의 전수 목록, 등록 방법, 재시도 정책, 서명·검증.
> **성격**: 진단 전용. 소비자(consumer) 설계는 이 카드의 범위가 아니다.
> **읽기전용 준수**: 웹훅 등록·변경 API 를 호출하지 않았고, 셀러어드민 폼을 제출하지 않았다. 모든 근거는 저장소 내 문서다.

---

## 0. 요약 — 이 문서가 확정한 것과 못 한 것

| 항목 | 상태 | 근거 |
|---|---|---|
| 이벤트 타입 전수 | **확정 33종**(샵바이 24 · 고도몰 전용 `GD_*` 9) | `docs/shopby/shopby-api/workspace-server-public.yml:624-637`, `:782-796` |
| 이벤트별 payload 스키마 | **미확인** — 스펙에 없음 | 후술 §2 |
| 등록 방법 | **API 없음**. 앱(App) 등록 경로로 추정되나 화면 근거 미확보 → **미확인** | 후술 §3 |
| 재시도 정책 | **미확인** — 스펙 전체에 재시도·백오프·타임아웃 서술 0건 | 후술 §4 |
| 서명·검증 | **미확인** — 서명 헤더 정의 0건 | 후술 §5 |
| 실패 내역 조회 API | **확정 1개** `GET /webhooks/failed` | `workspace-server-public.yml:572-696` |
| 후니 수신측 | **수신·적재만 구현 · eventType 분기 0 · 소비자 0** | M2 `l0-corrections.md:148-163` |

발신면 자체를 다루는 문서는 저장소 전체에서 **`workspace-server` 한 곳뿐**이다. `docs/shopby/` 전수 grep(`webhook|웹훅`) 결과 해당 파일과 그 파생본(`parsed/*`, `shopby_spec_all.txt`)만 걸린다. `docs/shopby/shopby_enterprise_docs/`(셀러어드민 매뉴얼 13개 영역)에는 `webhook`·`웹훅`·`systemKey` 가 **0건**이다.

---

## 1. ★이벤트 전수 카탈로그 (33종)

권위 출처는 두 곳이고 **문자열이 동일**하다 — `GET /webhooks/failed` 의 `eventType` 쿼리 파라미터 설명(`workspace-server-public.yml:624-637`)과 응답 스키마 `webhooks-failed-1319741198.contents[].eventType` 설명(`:782-796`). 즉 이 33종은 **실패 내역 필터로 쓸 수 있는 값의 목록**이며, 스펙은 이것을 "웹훅 이벤트 타입"이라고만 부른다.

한글 설명은 스펙 원문을 그대로 옮겼다.

### 1.1 샵바이(SHOPBY) 계열 — 24종

| # | eventType (verbatim) | 스펙 설명 | 발생 시점(스펙 문언 기준) | payload 주요 필드 | 스코프 |
|---:|---|---|---|---|---|
| 1 | `CHANGE_APP_STATUS` | 앱 설치/삭제 | 앱 설치 또는 삭제 시 | **미확인** | app |
| 2 | `PRODUCT_INQUIRY_ADDED` | 상품문의 등록 | 상품문의 등록 시 | **미확인** | product |
| 3 | `PRODUCT_INQUIRY_DELETED` | 상품문의 삭제 | 상품문의 삭제 시 | **미확인** | product |
| 4 | `PRODUCT_REVIEW_ADDED` | 상품 후기 등록 | 후기 등록 시 | **미확인** | product |
| 5 | `PRODUCT_REVIEW_DELETED` | 상품 후기 삭제 | 후기 삭제 시 | **미확인** | product |
| 6 | `INQUIRY_ADDED` | 1:1문의 등록 | 1:1문의 등록 시 | **미확인** | member/CS |
| 7 | `INQUIRY_MODIFIED` | 1:1문의 변경 | 1:1문의 변경 시 | **미확인** | member/CS |
| 8 | `INQUIRY_DELETED` | 1:1문의 삭제 | 1:1문의 삭제 시 | **미확인** | member/CS |
| 9 | `ACCUMULATION_ADDED` | 적립금 지급 | 적립금 지급 시 | **미확인** | member |
| 10 | `ACCUMULATION_SUBTRACTED` | 적립금 차감 | 적립금 차감 시 | **미확인** | member |
| 11 | `ACCUMULATION_SUBTRACT_ROLLBACK` | 적립금 차감 취소 | 차감 취소 시 | **미확인** | member |
| 12 | `MEMBER_CREATED` | 회원가입 | 가입 시 | **미확인** | member |
| 13 | `MEMBER_INFO_CHANGED` | 회원정보변경 | 정보 변경 시 | **미확인** | member |
| 14 | `MEMBER_GRADE_CHANGED` | 회원등급변경 | 등급 변경 시 | **미확인** | member |
| 15 | `MEMBER_GROUP_CHANGED` | 회원그룹변경 | 그룹 변경 시 | **미확인** | member |
| 16 | `MEMBER_WITHDRAW` | 회원탈퇴 | 탈퇴 시 | **미확인** | member |
| 17 | `MEMBER_DORMANT` | 휴면회원 전환 | 휴면 전환 시 | **미확인** | member |
| 18 | `MEMBER_RELEASED` | 휴면회원 해제 | 휴면 해제 시 | **미확인** | member |
| 19 | `CREATE_ORDER` | 주문생성 | 주문 생성 시 | **미확인** | order |
| 20 | `CHANGE_ORDER_STATUS` | 주문상태변경 | 주문상태 변경 시 | **미확인** | order |
| 21 | `UPDATE_RECEIVER` | 수령자 정보 변경 | 수령자 변경 시 | **미확인** | order |
| 22 | `ADD_TASK_MESSAGE` | 업무메세지 등록 | 업무메세지 등록 시 | **미확인** | order/CS |
| 23 | `UPDATE_TASK_MESSAGE` | 업무메세지 수정 | 업무메세지 수정 시 | **미확인** | order/CS |
| 24 | `PRODUCT_UPDATED` | 상품 등록/수정/삭제 | 상품 등록·수정·삭제 시 | **미확인** | product |

### 1.2 고도몰(GODO) 전용 계열 — 9종

`solutionType` 이 `GODO` 인 상점에만 해당한다(`workspace-server-public.yml:800-802`: `SHOPBY: 샵바이, GODO: 고도`). 후니는 샵바이 몰이므로 **런칭 범위 밖**이지만, 같은 enum 에 섞여 있어 필터링 시 오인을 막기 위해 전수 기록한다.

| # | eventType (verbatim) | 스펙 설명 | 스코프 |
|---:|---|---|---|
| 25 | `GD_MEMBER_LOGGED_IN` | 회원 로그인 | member (고도몰) |
| 26 | `GD_MEMBER_CREATED` | 회원 가입 | member (고도몰) |
| 27 | `GD_MEMBER_GRADE_CHANGED` | 회원 등급 변경 | member (고도몰) |
| 28 | `GD_MEMBER_INFO_CHANGED` | 회원 정보 변경 | member (고도몰) |
| 29 | `GD_MEMBER_WITHDRAW` | 회원 탈퇴 | member (고도몰) |
| 30 | `GD_ORDER_COMPLETED` | 주문 완료 | order (고도몰) |
| 31 | `GD_ORDER_CREATED` | 입금대기 주문 생성 | order (고도몰) |
| 32 | `GD_ORDER_GOODS_STATUS_CHANGED` | 주문 상품 상태 변경 | order (고도몰) |
| 33 | `GD_PRODUCT_UPDATED` | 상품 등록/수정/삭제 | product (고도몰) |

### 1.3 claim(취소·교환·반품) 계열은 목록에 없다

33종 중 클레임 전용 이벤트는 **하나도 없다**. 취소·반품·교환은 `CHANGE_ORDER_STATUS` 안에 접혀 들어가는 것으로 보이나, 스펙이 그렇게 말한 적은 없다 → **미확인**. `claim-server-public.yml` 에는 `webhook`·`웹훅` 이 0건이다.

---

## 2. payload 스키마 — 전 이벤트 미확인

스펙이 payload 에 대해 남긴 유일한 정보는 **실패 내역 레코드의 `data` 필드**다.

```yaml
# workspace-server-public.yml:773-775
data:
  type: string
  description: 웹훅 송신 데이터^|data
```

`data` 는 `type: string` 이고 예시값이 문자열 `"data"` 다(`:690`). 즉 **본문 구조가 스펙에 정의돼 있지 않다** — JSON 인지, 이벤트별로 형태가 다른지, 공통 봉투(envelope)를 쓰는지 전부 알 수 없다.

실패 레코드에서 확정적으로 읽히는 **전송 메타데이터**는 다음과 같다(`:747-817`). 이것은 payload 가 아니라 발송 기록의 필드다.

| 필드 | 타입 | 설명(원문) | 예시 |
|---|---|---|---|
| `httpMethod` | string | HTTP METHOD | `POST` |
| `webhookUrl` | string | 웹훅 수신 URL | `https://webhookUrl.com` |
| `solutionType` | string | 솔루션 타입 - (SHOPBY: 샵바이, GODO: 고도) | `SHOPBY` |
| `mallNo` | number | 샵바이 쇼핑몰 번호 | `1234` |
| `shopNo` | number | 고도몰 상점 번호 | `1234` |
| `eventType` | string | 웹훅 이벤트 타입 (§1의 33종) | `CHANGE_APP_STATUS` |
| `data` | string | 웹훅 송신 데이터 | `data` |
| `exceptionDateTime` | string | 예외 발생 시간 | `2025-10-27 11:37:18` |
| `exceptionType` | string | 예외 타입 | `class java.lang.Exception` |
| `exceptionMessage` | string | 예외 메시지 | `ERROR!` |

여기서 **확정되는 두 가지**:

1. **전송은 `POST`** — 예시값과 `httpMethod` 필드 존재가 그것을 가리킨다. 다만 "항상 POST"라는 문언은 없다 → 고정 여부는 **미확인**.
2. **수신 URL 은 `https://`** 형태로 예시된다 — 강제 여부는 스펙에 없다(§3).

예외 타입이 `class java.lang.Exception` 이라는 Java 클래스명 문자열인 점은, 실패 판정이 **샵바이 발송 측 예외**로 기록된다는 뜻이다. 수신측이 4xx/5xx 를 준 경우 그것이 어떤 `exceptionType` 으로 남는지는 **미확인**.

---

## 3. 등록 방법

### 3.1 등록·수정·삭제 API 는 없다

`workspace-server-public.yml` 이 정의하는 엔드포인트는 8개이고, `Webhook` 태그를 단 것은 **`GET /webhooks/failed` 하나뿐**이다(`:572-584`). 등록(POST)·수정(PUT)·삭제(DELETE)·목록조회 엔드포인트가 **존재하지 않는다**.

| 엔드포인트 | 태그 | 성격 |
|---|---|---|
| `PUT /app-installed/extend` | app-installed | 앱 만료일 연장 |
| `GET /app-installed/status` | app-installed | 앱 사용 상태 조회 |
| `GET /auth/me` | Auth | 어드민/몰 정보 조회 |
| `POST /auth/token` | Auth | 단기 토큰(5분) |
| `POST /auth/token/long-lived` | Auth | 장기 토큰(100년) |
| `POST /auth/token/revoke` | Auth | 장기 토큰 제거 |
| `GET`/`POST`/`DELETE /external-script` | ExternalScript | 외부스크립트 |
| **`GET /webhooks/failed`** | **Webhook** | **실패 내역 조회** |

따라서 **웹훅 URL 등록은 API 가 아닌 화면에서 이루어진다**고 보는 것이 자연스럽다. 다만 그 화면의 실재를 이 저장소로는 확정할 수 없다.

### 3.2 유일한 간접 근거 — systemKey 발급 경로

`systemKey` 헤더 설명이 앱 등록 화면을 지목한다(`workspace-server-public.yml:649-651`):

> 시스템 키 (외부시스템 연동을 위한 server API 호출 키)
> - 발급경로: 워크스페이스 > 셀러어드민 > 신규 앱(App) 등록 시 수정페이지에서 확인가능
> - 앱 기준으로 systemKey 발급됨

**앱 기준으로 키가 발급된다**는 것과 `CHANGE_APP_STATUS`(앱 설치/삭제) 이벤트가 목록의 첫 항목인 것을 보면, 웹훅은 **앱(App) 단위로 매달리는 구조**로 읽힌다. 그러나 "그 수정페이지에 웹훅 URL 입력란이 있다"는 문언은 **어디에도 없다** → **미확인**(셀러어드민 실화면 확인 필요).

`docs/shopby/shopby_enterprise_docs/`(appearance·claim-order·management·member·order·partner·product·promotion·service·statistic 등 13개 영역 매뉴얼) 전수 grep 결과 `webhook`·`웹훅`·`systemKey`·`앱 등록` **모두 0건**이다. 셀러어드민 매뉴얼에 웹훅 등록 화면이 문서화돼 있지 않다.

### 3.3 조회 API 가 요구하는 인증 3종

`GET /webhooks/failed` 는 세 헤더를 **모두 필수**로 요구한다(`:647-671`).

| 헤더 | 필수 | 값 |
|---|:---:|---|
| `systemKey` | ✅ | 앱 단위 발급 키. 예시 `test-system-key` |
| `Authorization` | ✅ | `Bearer {access_token}` — 중간 띄어쓰기 필수 |
| `Version` | ✅ | `1.0` |

`access_token` 은 두 종류다(`workspace.mdx §Auth`):

- **단기(5분)** `POST /auth/token` — 「토큰을 발급한 장비의 IP 에서만 server API 를 호출할 수 있습니다.」
- **장기(100년)** `POST /auth/token/long-lived` — 「**앱에 등록된 IP에서만** server API 를 호출할 수 있습니다.」 refresh_token 없음.

### 3.4 IP 제약의 방향에 주의 — 카드 전제의 정정

M2 카드는 "server-api 가 등록된 IP 를 요구한다"고 전했다. 스펙 문언을 보면 이 제약은 **후니가 샵바이를 호출할 때**(server API 아웃바운드) 걸리는 것이지, **샵바이가 후니를 호출할 때**(웹훅 인바운드) 걸리는 것이 아니다. 두 방향은 별개다.

- **아웃바운드(후니 → 샵바이 server API)**: IP 화이트리스트 **확정**(위 인용).
- **인바운드(샵바이 → 후니 웹훅 수신 URL)**: URL 이 HTTPS 여야 하는가, 샵바이 발신 IP 대역이 고정인가, 포트 제약이 있는가 — **스펙에 서술 0건 → 전부 미확인**. 예시값이 `https://webhookUrl.com` 인 것이 유일한 힌트이고, 이는 강제 조건의 근거가 되지 않는다.

---

## 4. 재시도 정책 — 전면 미확인

`workspace-server-public.yml` · `shopby_spec_all.txt` · `shopby-api-docs-complete/` 전수에서 재시도 횟수·백오프 간격·타임아웃·성공 판정 기준(2xx 여부)·데드레터 동작을 서술한 문장이 **하나도 없다**. 일반적인 웹훅 관례로 값을 추정하지 않는다.

| 항목 | 상태 |
|---|---|
| 재시도 횟수 | **미확인** |
| 백오프 방식·간격 | **미확인** |
| 요청 타임아웃 | **미확인** |
| 성공 판정(HTTP 2xx?) | **미확인** — `exceptionType`/`exceptionMessage` 로 실패를 기록한다는 사실만 확정 |
| 데드레터 / 재발송 트리거 | **재발송 API 없음**. 조회 전용 `GET /webhooks/failed` 만 존재 |
| 순서 보장(ordering) | **미확인** |
| 중복 발송(at-least-once) 여부 | **미확인** |

### 4.1 확정된 것 — 실패 내역의 보관·조회 창

`workspace-server-public.yml:577-583`:

> 웹훅 발송 시 실패했던 내역을 조회합니다.
> **7일 이내의 검색 기간에 한해서만 조회가 가능합니다.**
> 웹훅 실패 내역의 **보관기간은 생성일로부터 6개월** 입니다.

| 성질 | 값 | 근거 |
|---|---|---|
| 검색 창(한 번의 질의) | **7일 이내** | `:581` |
| 실패 레코드 보관 | **6개월** | `:583` |
| 필수 파라미터 | `startDateTime` · `endDateTime` (둘 다 required) | `:598-609` |
| 페이징 | `page`(기본 1) · `pageSize`(기본 10) | `:586-597` |
| 정렬 | `direction` 기본 `DESC` | `:641-646` |
| 몰 필터 | `mallNos`(샵바이) / `shopNos`(고도몰) | `:610-621` |

**운영상 의미**: 재발송 API 가 없으므로, 웹훅이 유실되면 복구는 **후니가 `GET /webhooks/failed` 로 실패분을 긁어 스스로 재처리**하는 방식밖에 없다. 그리고 그 조회는 7일 창으로만 되므로 **폴링 주기가 7일을 넘으면 구멍이 난다**. 이 API 를 부르는 코드가 후니 쪽에 있는지는 §6 의 대상이다.

---

## 5. 서명·검증 — 미확인

수신측이 "이 호출이 정말 샵바이에서 왔는가"를 판정할 수단에 대한 서술이 **스펙 전체에 없다**.

| 수단 | 상태 |
|---|---|
| 서명 헤더(HMAC 등) 이름·알고리즘 | **미확인** — 헤더 정의 0건 |
| 공유 시크릿 | **미확인** — `systemKey` 가 인바운드에도 실려 오는지 알 수 없다 |
| 타임스탬프 / replay 방어 | **미확인** |
| 발신 IP 화이트리스트 | **미확인**(§3.4) |
| mTLS | **미확인** |

`systemKey`·`Authorization` 헤더는 **후니가 샵바이를 부를 때** 싣는 값으로만 정의돼 있다(`in: header` 가 전부 `GET /webhooks/failed` 의 요청 파라미터다). 샵바이가 후니를 부를 때 무엇을 싣는지는 별개 사안이고, 문서에 없다.

**따라서 현 시점에서 후니 수신 엔드포인트는 인증 근거를 문서에서 얻을 수 없다.** 검증 설계는 셀러어드민 실화면 또는 샵바이 기술지원 회신으로만 닫힌다.

---

## 6. 후니 수신 현황 — M2 확정 사실

이하는 M2 가 이미 확정한 사실이며 재도출하지 않는다.

### 6.1 수신함은 있고, 읽는 쪽이 없다

M2 `l0-corrections.md:148-163` (C-9 ★[누락]):

> `shopby_hook.py` 는 133줄 전체가 수신·저장 전용이고 **`eventType` 분기가 하나도 없다** — 무엇이 오든 `t_ord_webhooks` 에 `RECEIVED` 로 넣고 200 을 준다. 그리고 `TOrdWebhooks` 참조는 **모델 정의(`models.py:1123`)와 이 `create`(`shopby_hook.py:124`) 둘뿐**이다.

교정문(`l0-corrections.md:162-163`):

> 「shopby webhook — 수신·적재만 구현(`t_ord_webhooks`), **eventType 분기 0 · 소비자 0**. 결제→생산 전환 미구현. 샵바이 측 등록 여부 미확인.」

즉 §1 의 33종 중 **어느 것도 후니 쪽에서 분기되지 않는다**. 수신은 무조건 200, 적재는 무조건 `RECEIVED`.

### 6.2 자사몰 코드에도 webhook 은 0건

M2 `contract-c2-shopby.md:396`:

> 저장소 전체 grep(`node_modules`·`.next` 제외) 결과 `order/register` · `cart/items` · `X-Huni-Server-Key` · `hsk_` · `webhook` **전부 0건**.

### 6.3 결제 웹훅이 런칭 흐름에서 맡은 자리

SDK 가이드 라이브 캡처(`_evidence/sdk-guide-live-20260902.txt`)가 결제 웹훅의 역할을 세 곳에서 말한다.

`:334` — 전체 흐름 요약:

> 번호는 아래 단계 목록과 같다 — ① 담기(3호출) → ② 장바구니 화면(2호출) → ④ 결제 직전 갱신 → ⑤ 주문 등록. 샵바이는 주문번호만 만들고, **그 번호로 결제 웹훅에서 후니와 다시 만난다.**

`:876` — 자사몰의 의무 경계:

> 결제 완료 자체는 저희가 쇼핑몰 웹훅으로 따로 받습니다 — 알려주지 않으셔도 됩니다.

`:1399-1402` — 웹훅 이후에 무엇이 일어나야 하는가:

> 저희 — 결제 완료를 샵바이 웹훅으로 받아, 원고 파일을 임시 보관함에서 주문 보관함으로 옮기고(승격) 검수·생산 접수·송장 등록까지 진행합니다.
> **웹훅에는 파일 정보가 실려 오지 않습니다** — 주문번호로 저희 기록을 찾아 잇습니다. 그래서 5번 호출이 빠지면 그 주문은 무엇을 만들지 알 수 없습니다.

`:818` — 주문상품옵션번호가 웹훅에 실려 온다는 주장:

> 상태변경 웹훅도 이 값을 실어 보내므로 저희 쪽에서 그대로 이어집니다.

> ⚠ **주의**: `:818` 은 후니 가이드의 서술이지 샵바이 스펙의 문언이 아니다. 샵바이 스펙은 payload 를 `data: string` 으로만 정의하므로(§2), `orderProductOptionNo` 가 실제로 실려 오는지는 **샵바이 문서로는 확인되지 않는다**.

### 6.4 런칭 흐름을 닫으려면 소비자가 필요한 이벤트

아래는 §1 카탈로그와 §6.3 가이드 문언을 맞춘 **진단**이다. 소비자를 설계하지 않고, 어느 이벤트가 비어 있는지만 지목한다.

| 우선순위 | eventType | 왜 필요한가 | 현재 |
|---|---|---|---|
| **1 (필수)** | `CHANGE_ORDER_STATUS` | 결제 완료 → 원고 승격 → 검수 → 생산 접수 → 송장. 가이드가 웹훅으로 받겠다고 못 박은 그 흐름의 트리거(`sdk-guide:1399-1402`). 결제완료 전용 이벤트가 33종에 없으므로 **결제 완료는 이 이벤트의 상태값으로 판별해야 한다**(그 상태값 목록은 **미확인**) | 소비자 0 |
| **2 (필수)** | `CREATE_ORDER` | 주문 생성 시점 포착. 다만 가이드는 자사몰이 `POST /api/w/v1/order/register` 를 부르도록 설계했고 그 호출이 **미구현**(`contract-c2-shopby.md:385-396`)이므로, 이 웹훅이 그 공백의 대체 경로가 될 수 있는지 판단이 필요 | 소비자 0 |
| **3 (사실상 필수)** | `UPDATE_RECEIVER` | 수령자 변경이 생산·송장 이후면 배송 사고. 후니가 송장을 등록하는 주체이므로 반영 경로가 필요 | 소비자 0 |
| 4 (운영) | `ADD_TASK_MESSAGE` / `UPDATE_TASK_MESSAGE` | 업무메세지 = CS 연동. 런칭 필수는 아님 | 소비자 0 |
| 5 (범위 밖) | `MEMBER_*` · `ACCUMULATION_*` · `PRODUCT_*` · `INQUIRY_*` | 회원·적립금 원장은 Shopby 소유(`contract-c2-shopby.md §3`), 상품 사양 원장은 후니 소유. 런칭 흐름에 개입하지 않음 | 소비자 0 |
| — (해당 없음) | `GD_*` 9종 | 고도몰 전용. 후니는 샵바이 몰 | 해당 없음 |

**취소·반품은 카탈로그에 전용 이벤트가 없다**(§1.3). 가이드가 「취소 가능 경계(`상품준비중`부터 즉시취소 불가)」를 말하는데(`l0-corrections.md` lead 메모), 그 경계를 웹훅으로 알 수단이 `CHANGE_ORDER_STATUS` 밖에 없다면 **상태값 매핑이 런칭 블로커**가 된다.

### 6.5 관측 0건의 의미

후니프린팅은 PG 결제 승인 심사 중이며, 결제가 한 건도 일어나지 않았다. 따라서 `t_ord_webhooks` 가 비어 있다면 그것은 **아직 실행되지 않았다**는 뜻이지 **구현되지 않았다**는 뜻이 아니다. 반대로 위 §6.1 의 "소비자 0" 은 코드 관측에서 나온 **구현 부재**이며, 이 둘을 섞지 말 것.

---

## 7. 미확인 목록

발신면(샵바이):

1. **웹훅 URL 등록 화면** — 셀러어드민 어느 메뉴에서 등록하는가. 앱(App) 등록 수정페이지로 추정되나 문서 근거 0. **셀러어드민 실화면 필요**
2. **이벤트 구독 선택 가능 여부** — 33종을 개별 선택하는가, 앱 단위로 전부 오는가
3. **payload 스키마 33종 전부** — `data: string` 외에 구조 정의 없음. 특히 `CHANGE_ORDER_STATUS` 의 상태값 목록
4. **재시도 횟수·백오프·타임아웃** — 서술 0건
5. **성공 판정 기준** — HTTP 2xx 인가, 본문 형식을 보는가
6. **데드레터 이후 동작** — 재발송 트리거가 있는가(재발송 API 는 없음)
7. **서명·검증 수단** — 헤더 이름·알고리즘·시크릿 전부 미정의
8. **인바운드 URL 제약** — HTTPS 강제인가, 샵바이 발신 IP 가 고정인가, 포트 제약
9. **전송 메서드 고정 여부** — `POST` 예시뿐, "항상 POST" 문언 없음
10. **순서 보장 / 중복 발송** — at-least-once 인지, 순서가 보장되는지
11. **클레임(취소·교환·반품) 이벤트의 소재** — 33종에 전용 항목 없음. `CHANGE_ORDER_STATUS` 에 접히는지
12. **`orderProductOptionNo` 가 실제로 웹훅에 실리는가** — 후니 가이드의 주장(`sdk-guide:818`)이며 샵바이 스펙 문언 아님

수신면(후니) — M2 가 이미 미확인으로 남긴 항목의 승계:

13. **샵바이 쪽에 후니 웹훅 URL 이 등록돼 있는가** — M2 `l0-corrections.md:157-158` 및 `:254`(미확인 6번). `docs/shopby/`·`docs/huni/shopby-onboarding/` 전수 검색으로 확정 불가
14. **후니가 `GET /webhooks/failed` 를 폴링하는가** — 재발송 API 가 없으므로 유실 복구의 유일한 경로인데, 이를 호출하는 코드의 유무는 이 카드에서 확인하지 않았다

---

## 8. 출처

| 구분 | 경로 |
|---|---|
| 발신면 1차 | `docs/shopby/shopby-api/workspace-server-public.yml:572-696`(엔드포인트), `:747-817`(스키마) |
| 발신면 파생 | `docs/shopby/shopby-api-docs-complete/04_server-api/workspace.mdx` §Webhook / §Auth |
| 발신면 파생 | `docs/shopby/shopby-api/parsed/workspace-server-public.md:409-435` |
| 전수 확인(누락 방지) | `docs/shopby/shopby-api/shopby_spec_all.txt:161006-161246` — 16개 hit 전부 위 정의의 중복본 |
| 셀러어드민 매뉴얼 | `docs/shopby/shopby_enterprise_docs/` — `webhook`·`웹훅`·`systemKey` **0건** |
| 수신면(후니) | `_workspace/huni-launch-runway/07_rebaseline/L0/M2/l0-corrections.md:148-163`, `:254` |
| 수신면(후니) | `_workspace/huni-launch-runway/07_rebaseline/L0/M2/contract-c2-shopby.md:269`, `:396`, `:402` |
| 런칭 흐름 | `_workspace/huni-launch-runway/07_rebaseline/L0/M2/_evidence/sdk-guide-live-20260902.txt:334`, `:818`, `:876`, `:1399-1402` |
