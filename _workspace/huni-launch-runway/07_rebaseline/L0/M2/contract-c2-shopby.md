# 계약 C2 — 쇼핑몰(huni-skin-shopby) ↔ Shopby(NHN 헤드리스 커머스)

> 카드 M2 · L0 재기준선 · 조사일 2026-09-02 · **정적 코드 판독 + 문서 대조만**(라이브 호출 없음)
>
> 조사 대상
> - 코드: `/Users/innojini/Dev/huni-skin-shopby` (HEAD `30cb88a` — 「feat(checkout): 비회원(게스트) 구매」)
> - Shopby 공식 스펙: `/Users/innojini/Dev/HuniWeb/docs/shopby/shopby-api/*.yml`, `docs/shopby/shopby-api-docs-complete/`, `docs/shopby/shopby_enterprise_docs/`
> - 후니 SDK 가이드 라이브 캡처: `_workspace/huni-launch-runway/07_rebaseline/L0/M2/_evidence/sdk-guide-live-20260902.txt` (2,132줄, 2026-09-02 캡처). 생성기 원본은 `raw/webadmin/tools/gen_sdk_guide.py`.
>
> 이 문서에서 「가이드:NNN」은 위 캡처 파일의 줄번호다.

---

## 0. 한 장 요약 — 이 계약이 지금 어떤 상태인가

| # | 판정 | 무엇 |
|---|---|---|
| F-1 | **결함(치명)** | 결제 후 후니에 알리는 **주문 등록 호출(`POST /api/w/v1/order/register`)이 코드에 없다.** 저장소 전체 grep 0건. 가이드는 「이 호출이 빠지면 그 주문은 무엇을 만들지 알 수 없습니다」(가이드:1402)라고 명시 |
| F-2 | **계약 드리프트(치명)** | 몰은 `optionInputs` 에 **`huni_token`(서명 토큰)을 싣는다.** 현행 계약은 토큰을 샵바이에 넣는 것을 **금지**하고 `huni_item`(item_id)를 쓰라고 한다(가이드:1315-1321) |
| F-3 | **계약 드리프트(치명)** | 후니 **항목 보관소 API(`/api/w/v1/cart/items` 4종)와 서버키 `X-Huni-Server-Key` 가 코드에 전혀 없다.** 몰은 폐기 예정인 `POST /handoff/requote` 경로만 쓴다 |
| F-4 | **결함** | **결제 직전 갱신(재견적)이 결제 화면에 없다.** 회원·게스트 공통. 장바구니 화면에만 있다 |
| F-5 | **결함** | 재견적 프록시가 **로그인 세션 필수**라 게스트는 401 → 게스트 수량변경·정규화 불가 |
| F-6 | **드리프트** | `huni_order` JSON 안에 `editors`(편집기 프로젝트)·`files`(원고 파일 참조)를 넣는다. 계약은 이를 **금지**(주문조회 응답으로 평문 노출, 가이드:1180-1187) |
| F-7 | **드리프트** | `optionInputs` 에 **`inputNo` 를 보내지 않는다**(라벨만). 가이드는 `inputNo` 동봉을 예시로 쓰고, 라벨만으로 매칭되는지는 「확인되지 않았습니다」(가이드:1044) — **미확인** |
| F-8 | **문서 정정** | 「server API 로 연동」은 부정확하다. **실사용 경로는 전부 shop-api** 이고, server-api 훅은 1개(`/admins`)뿐이며 **소비처 0건(사문)** |
| F-9 | **주장 불일치** | L0 ARCHITECTURE.md 의 「Shopby API **31** 고유 경로」가 재실측과 어긋난다. 재실측 = **38** |
| F-10 | 정상 | 금액 단위는 **10원** 이 맞다(`SHOPBY_AMOUNT_UNIT = 10`). 가이드가 경고한 「100원 기준으로 만들었으면 10배 틀어짐」에는 해당하지 않는다 |

---

## 1. 연동 구조

### 1.1 Shopby 는 표면이 셋이고, 몰이 실제로 쓰는 것은 하나다

| 표면 | 호스트 | 인증 | 몰이 쓰는가 |
|---|---|---|---|
| **shop API**(스토어프론트) | `https://shop-api.e-ncp.com` — `src/lib/api/config.ts:66-68` | `clientId` + `platform` + `version` 헤더. 회원 API 만 `Shop-By-Authorization: Bearer <accessToken>` 추가 — `config.ts:96-103`, `src/app/api/shop/[...path]/route.ts:55-62` | **예 — 실사용 전부(37 경로)** |
| **server API**(관리자/파트너) | `https://server-api.e-ncp.com` — `config.ts:30-32` | `authorization: Bearer <파트너 JWT>` + `systemkey` + `version` — `config.ts:44-51` | **사실상 아니오 — 훅 1개(`/admins`), 소비처 0건** |
| **admin(셀러어드민 화면)** | — | — | 아니오(코드 연동 없음. 운영자가 브라우저로 본다) |

**F-8 — 「server API 연동」이라는 표현 정정.**
`apiFetch`(= server API 프록시 호출)를 쓰는 곳은 `src/lib/api/hooks/use-admins.ts:23` 하나뿐이고, `useAdmins` 를 import 하는 컴포넌트는 **0건**이다(`src/lib/api/index.ts:12` 의 배럴 re-export 만 존재). 즉 상품·장바구니·주문서·결제·마이페이지 **전 경로가 shop-api** 다.
가이드가 미확정 항목으로 남긴 것도 이 지점이다 — 「자사몰이 샵바이 서버 API를 쓰는지 — 상품·주문 상태 변경 같은 관리자용 API(server-api)는 **등록된 IP에서만** 호출됩니다. 쓰실 계획이면 고정 IP를 미리 알려 주세요. … shop-api는 IP 제한이 없으니 신경 쓰지 않으셔도 됩니다」(가이드:1443-1448).
→ **판단**: 현행 코드대로면 고정 IP 등록은 **불필요**. 다만 `/admins` 훅과 `/api/shopby` 프록시를 남겨 두면 「언젠가 쓸 것」으로 오해되어 런칭 직전에 IP 이슈가 튀어나온다. **결정 필요** — (a) server-api 를 안 쓰기로 확정하고 프록시·훅을 제거하거나, (b) 쓸 계획이면 고정 IP 를 지금 NHN 에 등록. **미확인**: 배포 환경(Railway 등)이 고정 IP 를 제공하는지.

### 1.2 프록시가 앉은 자리 — 비밀은 브라우저에 내려가지 않는다

```
브라우저                     Next.js 서버                         Shopby
  │                              │                                  │
  │ fetch("/api/shop/cart")      │                                  │
  ├─────────────────────────────►│ buildShopHeaders() 로            │
  │  (same-origin, 비밀 없음)    │ clientId·platform·version 주입   │
  │                              │ + 세션 쿠키에서 accessToken 읽어 │
  │                              │   Shop-By-Authorization 주입     │
  │                              ├─────────────────────────────────►│
```

| 항목 | 위치 | 내용 |
|---|---|---|
| shop 프록시 | `src/app/api/shop/[...path]/route.ts:45` | catch-all. path·query·body·method 를 그대로 중계. GET/POST/PUT/PATCH/DELETE 5종 export |
| server 프록시 | `src/app/api/shopby/[...path]/route.ts:23` | 동일 구조. 비밀 헤더만 다름 |
| 회원 토큰 주입 | `route.ts:55-62` | `x-shopby-public: 1` 헤더가 없으면 세션 JWT 에서 accessToken 을 꺼내 `Shop-By-Authorization: Bearer` 로 붙인다. 게스트는 토큰이 없어 **헤더 자체가 안 붙는다**(= clientId 만으로 호출) |
| 멀티파트 예외 | `route.ts:71` | `/storage/*` 업로드는 `Accept: application/json` 이면 404 → `*/*` 로 교체(실측 주석) |
| 204 처리 | `route.ts:113-120` | `PUT /cart` 등 204 는 body null 로 |
| 인증 가드 | `src/proxy.ts:33` | `PROTECTED_PREFIXES = ["/mypage", "/order"]`. **`/cart`·`/checkout` 은 게스트 진입 허용**(30cb88a 에서 해제) |

### 1.3 토큰 발급·갱신·폐기

| 동작 | 호출 | 위치 | 비고 |
|---|---|---|---|
| 로그인 | `POST /oauth2` `{memberId, password, keepLogin}` | `src/lib/auth/shopby-auth.ts:74` | 응답 `accessToken`+`refreshToken`+`expiresIn` |
| 갱신 | `PUT /oauth2` (헤더 `Shop-By-Authorization: Bearer <만료 access>` + `Refresh-Token: <refresh>`) | `shopby-auth.ts:101` | **비회전** — 응답에 refreshToken 이 없어 기존 것을 유지(`shopby-auth.ts:36-46`, 2026-08-29 실측 주석) |
| 폐기 | `DELETE /oauth2` | `shopby-auth.ts:176` | 로그아웃 시 `POST /api/auth/shopby-logout` 이 대행 |
| 갱신 위치 | `/api/auth/session` 한 곳 | `src/app/api/shop/[...path]/route.ts:20-25` 주석 | **프록시는 refresh 하지 않는다** — 라우트 핸들러 응답이 쿠키를 갱신하지 못해 회전된 토큰이 유실되는 사고(M0013/A0001)를 겪은 뒤의 설계 |
| 401 자가복구 | 회원 shop 호출이 401 이면 `getSession()` 1회 후 재시도 | `src/lib/api/client.ts:126-136` | 무한루프 방지 위해 1회만 |

### 1.4 서버측 vs 브라우저측

| 서버에서만 도는 것 | 위치 |
|---|---|
| 카테고리 트리 · 상품목록 · 상품검색 · 상품상세 | `src/lib/api/server/catalog.ts:101 / 128 / 187 / 370` (`next: {revalidate}` 캐시) |
| 공지 목록·상세 | `src/lib/api/server/board.ts:74 / 99` |
| 로그인·갱신·로그아웃·프로필·회원가입 | `src/lib/auth/shopby-auth.ts` 전체 |
| 후니 재견적 대리 호출 | `src/app/api/printly/requote/route.ts:57` (`site_key` 는 서버 env `HUNI_WIDGET_SITE_KEY` 로만 — `:30`) |
| 위젯 해석·상세탭 조회 | `src/lib/printly/widget.ts`, `publications.ts` (Shopby 아님 — Railway PG 직접 SELECT) |

| 브라우저에서 도는 것 | 위치 |
|---|---|
| 장바구니·주문서·쿠폰·적립금·마이페이지·리뷰 전부 | `src/lib/api/hooks/*` (React Query + `shopFetch`) |
| NCPPay 결제 SDK | `src/lib/payments/ncp-pay.ts:60` — `<shopApiBase>/payments/ncp_pay.js` 를 직접 로드 |

### 1.5 환경변수 — 실제 키 이름(카드에 적힌 이름과 다르다)

| 카드가 적은 이름 | 코드의 실제 이름 | 어느 표면을 인증하나 | 위치 |
|---|---|---|---|
| `SHOPBY_SERVER_API_URL` | **`SHOPBY_API_BASE_URL`** | server API 베이스 | `config.ts:31` |
| `SHOPBY_SERVER_ACCESS_TOKEN` | **`SHOPBY_ACCESS_TOKEN`** | server API `authorization: Bearer` | `config.ts:46` |
| `SHOPBY_SYSTEM_KEY` | `SHOPBY_SYSTEM_KEY` ✓ | server API `systemkey` | `config.ts:47` |
| `SHOPBY_VERSION` | **`SHOPBY_API_VERSION`** | 양 표면 공통 `version` 기본값(호출별 오버라이드) | `config.ts:48`, `:101` |
| `SHOPBY_SHOP_API_URL` | `SHOPBY_SHOP_API_URL` ✓ | shop API 베이스 | `config.ts:67` |
| `SHOPBY_CLIENT_ID` | `SHOPBY_CLIENT_ID` ✓ | shop API `clientId` (공개 식별자 — `/api/pay-config` 로 브라우저에 내려감) | `config.ts:80`, `:99` |
| `SHOPBY_PLATFORM` | `SHOPBY_PLATFORM` ✓ | shop API `platform`(기본 `PC`) | `config.ts:81`, `:100` |
| `SHOPBY_EXTERNAL_KEY` · `SHOPBY_SECRET_KEY` · `SHOPBY_API_PROFILE` · `SHOPBY_ADMIN_URL` | **저장소에 없음**(`.env.example`·`src` grep 0건) | — | — |

`mallkey` 헤더는 **의도적으로 보내지 않는다** — Shopby 가 폐기 예정이고 Authorization 사용 시 null 권장이라(`config.ts:38-40`).

**미확인**: `X-Huni-Server-Key`(가이드가 요구하는 후니 서버키, `hsk_` 접두 50자 남짓 — 가이드:300-301)는 `.env.example`·코드 어디에도 없다. 발급 여부부터 확인 필요.

---

## 2. Shopby 경로 전수표 — 「31 고유 경로」 주장 검증

### 2.1 재실측 결과: **38 고유 경로** (server API 1 + shop API 37)

메서드가 여러 개인 경로는 1건으로 센다(예: `/cart` 의 GET/POST/PUT/DELETE = 1경로).

#### A. 인증 (1)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 1 | `/oauth2` | POST · PUT · DELETE | 로그인 · 토큰갱신 · 토큰폐기 | shop / clientId(+Bearer·Refresh-Token 헤더) | `src/lib/auth/shopby-auth.ts:74` · `:101` · `:176` |

#### B. 회원 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 2 | `/profile` | GET · PUT · DELETE · POST | 프로필 조회 · 수정 · **탈퇴** · 회원가입 | shop / 회원(가입만 비회원) | `use-profile.ts:46` · `:74` · `:115` · `shopby-auth.ts:203`(GET) · `:239`(POST 가입) |
| 3 | `/profile/password` | PUT | 비밀번호 변경 | shop / 회원 | `use-profile.ts:135` |

#### C. 상품·카탈로그 (5)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 4 | `/categories` | GET | 카테고리 트리(`categoryViewType=MULTI_LEVEL`) | shop / 공개(서버) | `src/lib/api/server/catalog.ts:101` |
| 5 | `/products/search` | GET | 전체 상품 페이지네이션 + 키워드 검색 | shop / 공개(서버) | `catalog.ts:128` · `:187` |
| 6 | `/products/{productNo}` | GET | 상품 상세(이름·가격·이미지·`productManagementCd`) | shop / 공개(서버) | `catalog.ts:370` |
| 7 | `/products/{productNo}/options` | GET | 대표 optionNo 해석(장바구니·주문서에 필요) | shop / 공개 | `use-product-options.ts:42` |
| 8 | `/products/favoriteKeywords` | GET | 인기 검색어 | shop / 공개 | `use-search.ts:17` |

#### D. 리뷰 (4)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 9 | `/products/{productNo}/product-reviews` | GET · POST | 상품평 목록 · 작성 | shop / 공개(GET) · 회원(POST) | `use-product-reviews.ts:49` · `use-review-write.ts:98` |
| 10 | `/products/{productNo}/product-reviews/{reviewNo}` | PUT · DELETE | 내 리뷰 수정 · 삭제 | shop / 회원 | `use-my-reviews.ts:92` · `:114` |
| 11 | `/profile/product-reviews` | GET | 내가 쓴 리뷰 목록 | shop / 회원 | `use-my-reviews.ts:55` |
| 12 | `/profile/order-options/product-reviewable` | GET | 작성 가능(구매확정) 목록 | shop / 회원 | `use-review-write.ts:42` |

#### E. 장바구니 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 13 | `/cart` | GET · POST · PUT · DELETE | 조회 · 담기 · 수량/optionInputs 갱신 · 삭제 | shop / **회원 전용** | `use-cart.ts:136` · `:210` · `:223` · `:237` |
| 14 | `/cart/count` | GET | 헤더 배지 개수 | shop / 회원 | `use-cart.ts:175` |

#### F. 주문서 (6)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 15 | `/order-sheets` | POST | 주문서 생성(`products[]` 필수, `cartNos[]` 는 사후 정리용) | shop / 회원+**게스트 가능** | `use-order-sheet.ts:49` |
| 16 | `/order-sheets/{orderSheetNo}` | GET | 주문서 조회(품목·`availablePayTypes`·`tradeBankAccountInfos`) | shop / 회원+게스트 | `use-order-sheet.ts:183` |
| 17 | `/order-sheets/{orderSheetNo}/calculate` | POST | 쿠폰·적립금·주소 반영 권위 금액 재계산 | shop / **회원 전용** | `use-order-sheet.ts:267` |
| 18 | `/order-sheets/{orderSheetNo}/coupons` | GET | 적용 가능 장바구니 쿠폰 | shop / 회원 | `use-order-coupons.ts:40` |
| 19 | `/order-sheets/{orderSheetNo}/coupons/apply` | POST | 쿠폰 커밋(null=해제) | shop / 회원 | `use-order-coupons.ts:74` |
| 20 | `/order-sheets/{orderSheetNo}/coupons/maximum` | POST | 최대 할인 쿠폰 자동 선택 | shop / 회원 | `use-order-coupons.ts:105` |

#### G. 결제 (2 — 둘 다 몰이 직접 POST 하지 않는다)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 21 | `/payments/ncp_pay.js` | GET | NCPPay SDK 스크립트 로드 | shop / 공개(브라우저 직접) | `src/lib/payments/ncp-pay.ts:60` |
| 22 | `/payments/reserve` | POST | 결제 예약 → 결제창 → confirm | shop / 회원(`shopbyAuthorization`) · 게스트(무인증) | **SDK 내부 호출**. 몰은 요청 바디만 만든다 — `use-order-sheet.ts:346`(`buildReserveBody`), 호출은 `ncp-pay.ts:88-104` |

#### H. 마이페이지 주문 (3)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 23 | `/profile/orders` | GET | 주문 목록 | shop / 회원 | `use-my-orders.ts:89` |
| 24 | `/profile/orders/summary/status` | GET | 상태별 카운트 | shop / 회원 | `use-my-orders.ts:331` |
| 25 | `/profile/orders/{orderNo}` | GET | 주문 상세 | shop / 회원 | `use-my-orders.ts:360` |

#### I. 배송지 (3)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 26 | `/profile/shipping-addresses` | GET · POST | 주소록 조회 · 추가 | shop / 회원 | `use-shipping-address.ts:69` · `:91` |
| 27 | `/profile/shipping-addresses/{addressNo}` | PUT · DELETE | 수정 · 삭제 | shop / 회원 | `use-shipping-address.ts:104` · `:113` |
| 28 | `/profile/shipping-addresses/{addressNo}/default` | PUT | 기본 배송지 지정 | shop / 회원 | `use-shipping-address.ts:121` |

#### J. 적립금 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 29 | `/profile/accumulations/summary` | GET | 보유 적립금 | shop / 회원 | `use-points.ts:26` |
| 30 | `/profile/accumulations` | GET | 적립금 내역 | shop / 회원 | `use-points.ts:66` |

#### K. 쿠폰 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 31 | `/coupons` | GET | 내 쿠폰 목록 | shop / 회원 | `use-coupons.ts:75` |
| 32 | `/coupons/register-code/{promotionCode}` | POST | 프로모션 코드로 쿠폰 발급 | shop / 회원 | `use-coupons.ts:100` |

#### L. 게시판 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 33 | `/boards/{boardNo}/articles` | GET | 공지 목록 | shop / 공개(서버) | `src/lib/api/server/board.ts:74` |
| 34 | `/boards/{boardNo}/articles/{articleNo}` | GET | 공지 상세 | shop / 공개(서버) | `board.ts:99` |

#### M. 기타 (2)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 35 | `/addresses/search` | GET | 주소 검색 | shop / 공개 | `use-address-search.ts:33` |
| 36 | `/storage/temporary-images` | POST(multipart) | 리뷰 사진 업로드 | shop / 회원 | `use-review-write.ts:65` |

#### N. 비회원 (1)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 37 | `/guest/orders/{orderNo}` | POST `{password}` | 비회원 주문조회 | shop / **비회원**(`member:false` → 토큰 미주입) | `src/components/order/guest-order-lookup.tsx:144` |

#### O. server API (1)

| # | 경로 | 메서드 | 용도 | 인증 표면 | 호출 위치 |
|---|---|---|---|---|---|
| 38 | `/admins` | GET | 운영자 목록 | **server** / Bearer+systemkey | `use-admins.ts:23` — **소비처 0건(사문)** |

### 2.2 「31」과의 대조 — 재현되지 않는다

주장 원문: `_workspace/huni-launch-runway/07_rebaseline/L0/ARCHITECTURE.md:133`
> `| Shopby API (S1→S2) | **31** 고유 경로 | 상품5·장바구니2·주문서6·마이11·전시3·게시판1·결제1 등 |`

| 항목 | 주장 | 재실측 | 판정 |
|---|---:|---:|---|
| 상품 | 5 | 5 | 일치(#4-8) |
| 장바구니 | 2 | 2 | 일치(#13-14) |
| 주문서 | 6 | 6 | 일치(#15-20) |
| 마이 | 11 | 11 | 일치(#2,3,11,12,23,24,25,26,27,28,29,30 중 11 — 조합에 따라 ±1) |
| 전시 | 3 | (리뷰 4 · 카테고리 1 로 5) | **불일치** |
| 게시판 | 1 | 2(목록+상세) | **불일치** |
| 결제 | 1 | 2(`reserve`+`ncp_pay.js`) | **불일치** |
| 명시 소계 | **29** | — | 「등」 2건이 무엇인지 문서에 없음 |
| **총계** | **31** | **38** | **7건 차이** |

**주장이 세지 않았거나 다르게 묶은 것으로 보이는 경로**(적어도 이 7건은 표에 근거가 없다):
`/oauth2` · `/profile` · `/profile/password` · `/addresses/search` · `/storage/temporary-images` · `/guest/orders/{orderNo}` · `/coupons` · `/coupons/register-code/{promotionCode}` · `/admins` · `/boards/.../{articleNo}` · `/payments/ncp_pay.js`.

**판정 — 결함(F-9).** ARCHITECTURE.md 의 31 은 **경로별 근거가 없어 재현·검증이 불가능**하다. 소계 29 + 「등」이라는 표기 자체가 전수가 아님을 인정한 셈이다. L0 정정 시 **38**(server 1 + shop 37)로 갱신하고, 위 §2.1 표를 근거로 첨부할 것을 권한다.

**정직 고지**: 이 38 은 **정적 grep 기반**이다. `shopFetch` / `apiFetch` / 서버측 `fetch(${getShop*BaseUrl()}...)` 를 전수 추적했으나, ① NCPPay SDK 가 내부에서 부르는 경로(`/payments/reserve` 외에 무엇을 더 부르는지)는 번들을 읽지 않아 **미확인**, ② 런타임에서만 조립되는 경로가 있다면 잡히지 않는다. 확정하려면 라이브 HAR 캡처가 필요하다.

---

## 3. 원장 분계 — 무엇을 Shopby 가 갖고 무엇을 후니가 갖는가

가이드가 한 줄로 못 박은 기준선(가이드:262-263):
> 「**무엇이 담겼나 · 몇 개인가 · 지웠나**」는 샵바이가, 「**무엇을 어떻게 만드나 · 얼마인가**」는 저희(후니)가 갖습니다. 둘을 잇는 것이 `item_id` 입니다.

| 원장 항목 | 주인 | 근거 |
|---|---|---|
| 회원(가입·로그인·프로필·탈퇴·비밀번호) | **Shopby** | `POST/PUT/DELETE /profile`, `POST/PUT/DELETE /oauth2` — `shopby-auth.ts:74,101,176,203,239`. 몰의 Prisma `User` 모델(`prisma/schema.prisma:165`)은 **사문**(`src` import 0건) |
| 주소록 | **Shopby** | `/profile/shipping-addresses*` — `use-shipping-address.ts:69,91,104,113,121` |
| 장바구니(회원) | **Shopby** | `/cart` — `use-cart.ts:136,210,223,237` |
| 장바구니(게스트) | **브라우저 localStorage** ⚠ | `src/lib/guest-cart.ts:29`(key `huni_guest_cart`) — 서버 원장 없음 |
| 주문·주문번호·주문상태 | **Shopby** | `/order-sheets`, `/payments/reserve`, `/profile/orders*`. 가이드:753 「주문 생성 = 쇼핑몰」, :758 「주문상태 변경·송장번호 등록 = 후니」 |
| 결제·PG·입금확인 | **Shopby**(NCPPay→PG) | `ncp-pay.ts:88-104`. 가이드:876 「결제 완료 자체는 저희가 쇼핑몰 웹훅으로 따로 받습니다」 |
| 정산 | **Shopby** | 코드 연동 없음. 셀러어드민 영역 |
| 쿠폰·적립금 | **Shopby** | `/coupons*`, `/profile/accumulations*`, `/order-sheets/{no}/coupons*`. 가이드:1116-1128 「쿠폰은 전부 금액 기준 — 안전」 |
| 배송비 | **Shopby**(단, 금액 기준 유형만) | 가이드:1110-1114. 현재 FREE(기본 배송 템플릿) |
| 재고 | **Shopby**가 보유, **후니**가 보충 | 가이드:1085-1100. 재고 × 10원 = 그 상품 누적 결제 한도. 현재 라이브 9,999(1건만 9,979), 최대 2,147,483,647. **자사몰은 재고를 건드리지 말 것** |
| 알림(문자·알림톡·메일) | **Shopby**(주문·결제·배송) / **후니**(파일 관련) | 가이드:1412, :1423 |
| **상품 사양(용지·사이즈·후가공)** | **후니** | 가이드:1130-1133 「주문 사양의 원본은 저희 DB 한 곳뿐」. 몰은 사양 JSON 을 복사하지 않는 것이 계약 — **현재 위반**(§4 F-6) |
| **가격 계산** | **후니** | 위젯 → `payload.total`. Shopby 는 금액을 외부에서 못 받는다(§4.1) |
| **원고 파일(S3)** | **후니** | 가이드:1382-1384 「브라우저에서 저희 S3로 바로 — 자사몰 서버를 거치지 않습니다」 |
| **Edicus 편집기 프로젝트** | **후니**(+Edicus) | `raw/webadmin/webadmin/catalog/edicus_lookup.py:201-208` |
| **주문 토큰(서명 사양서)** | **후니 항목 보관소** | 가이드:250-259. 「쇼핑몰은 DB를 만들지 않으셔도 됩니다」 — **현재 위반**(§4 F-2) |
| 상품 상세 탭 HTML | **Pie Canvas(Railway PG)** | `src/lib/printly/publications.ts` — Shopby 도 후니 주 DB 도 아닌 세 번째 저장소 |
| 위젯↔상품 매핑 | **Printly 커머스 DB** | `src/lib/printly/widget.ts:43` |

### 3.1 헤드리스인데도 Shopby 가 직접 고객에게 내보내는 것 (수량 1,500 이 새는 통로)

가이드:1406-1425.

| 무엇 | 만드는 곳 | 수량이 보이나 | 대응 |
|---|---|---|---|
| 상품·장바구니·주문서·주문조회 화면 | 자사몰 | 아니오 | 통제 가능 |
| 거래명세표 | 자사몰 | 아니오 | 통제 가능 |
| 주문·결제·배송 알림(문자·알림톡·메일) | **Shopby** | **예** | 템플릿에서 `count`·`productNames`(「상품명(수량)」) 치환 제거. **★미확정 — 수정 여부·시점 미정**(가이드:1433) |
| 결제창(PG) | Shopby→PG | 금액 정상, 상품명만 노출 | 무해 |
| **현금영수증·세금계산서** | **Shopby** | **예 — 품목·수량 표기** | **대응책이 가이드에 없다. 미해결 항목** |
| 셀러어드민 주문 화면·판매 통계 | Shopby | **예 — 담당자가 매일 본다** | `huni_order` 요약 한 줄이 이걸 위한 것(가이드:1427-1430) |

**세금계산서 수량 표기**는 이 계약에서 **해법이 제시된 적 없는 유일한 항목**이다. 「10원 × 1,500」이 세금계산서 품목·수량란에 그대로 찍히면 회계·세무 문제가 된다. **PM 결정 필요 · 미확인**.

---

## 4. ★ optionInputs 우회의 전모

### 4.1 왜 이 우회가 존재하나 — 1차 출처

가이드:1037-1039 (§11, 2026-08-26/27 확정):
> 「샵바이 주문서 API는 **금액을 직접 받지 않습니다.** 상품번호·옵션번호·수량만 받고 금액은 샵바이 서버가 상품 정보에서 계산합니다. 그래서 금액을 표현할 수 있는 자리가 **수량밖에** 없습니다.」

가이드:978-981:
> 「주문 금액을 외부에서 지정하는 방법을 샵바이에 문의했고, "**불가능하다**"는 회신을 받았습니다(2026-08-26 미팅).」

그래서 **판매가 10원 상품 × 수량(= 금액 ÷ 10)**. 2026-08-26 에 판매중 226개 상품 판매가를 일괄 10원으로 변경 완료(가이드:1052-1054). 이전 안내는 100원이었고, 「100원 기준으로 만드셨다면 금액이 10배 틀어집니다」(가이드:997).

**몰 코드 확인 — 10원이 맞다.**
```
src/lib/api/widget-order.ts:26   export const SHOPBY_AMOUNT_UNIT = 10;
src/lib/api/widget-order.ts:32-35 amountToOrderCnt(total) = max(1, round(total / 10))
src/components/product/huni-widget.tsx:265   orderCnt: amountToOrderCnt(total)
src/lib/api/requote.ts:76-78     orderCntFromRequote() → 재견적 총액 ÷ 10
```
→ F-10 정상. 10배 오차 위험 없음.

왜 1원이 아니라 10원인가 — 후니 가격엔진이 최종 청구액의 1원 단위를 절삭하므로 청구액은 항상 10원 배수이고, 수량·재고 소모가 1/10 로 준다(가이드:1056-1059). 안전장치로 후니 서버가 토큰 발급 시 「청구액이 10원 배수인가」를 검사해 아니면 `price_unit_mismatch 422` 로 거절한다(가이드:1063-1066) — **반올림 재시도 금지**.

왜 하필 텍스트 옵션인가 — `POST /cart` 의 항목 하나가 가질 수 있는 필드는 `productNo`(상품 고정)·`optionNo`(상품 고정)·`orderCnt`(금액이 씀)·`baseProductNo`·`groupId`·`optionInputs` 뿐이고, **주문마다 다른 값을 넣을 수 있는 자리는 `optionInputs` 하나**다(가이드:1211-1218). `orderMemo`·`extraData` 는 주문 단위라 품목 구분이 안 되고, 상품관리코드는 상품 고정, 조합형 옵션명은 조합 수가 사실상 무한이라 불가능(가이드:1220-1224).

### 4.2 슬롯은 몇 개이고 무엇이 들어가나

**계약(현행 · 가이드:1298-1310)** — 2026-08-27 에 판매중 226개 상품 전부에 등록 완료. 매칭타입 전부 `PRODUCT`, 필수 아님.

| 슬롯 | inputLabel | 넣는 값 | 길이 |
|---|---|---|---|
| 1 | `huni_order` | 후니가 만들어 준 **사람이 읽는 요약 한 줄**(예: `명함 / 스노우250g / 200장`) | 100자 내외 권장 |
| 2 | `huni_item` | `POST /api/w/v1/cart/items` 가 준 **36자 UUID `item_id`**(불변) | 36자 |

**몰 코드(현재)** — `src/components/product/huni-widget.tsx:55-81`

| 슬롯 | inputLabel | 넣는 값 |
|---|---|---|
| 1 | **`huni_token`** | 위젯 `submit()` 이 준 **서명 토큰 원문**(수 KB) — `huni-widget.tsx:70` |
| 2 | `huni_order` | `JSON.stringify({total, qty, summary, qtyRule, editors, files})` — `huni-widget.tsx:60-68, 73-76` |

읽는 쪽: `src/lib/api/widget-order.ts:103-133` (`parseWidget`) — `huni_order` 를 JSON.parse 해 `{total, qty, summary, token, qtyRule}` 로 되돌리고, `huni_token` 에서 토큰을 꺼낸다.
쓰는 쪽(갱신): `src/lib/api/requote.ts:58-73` (`optionInputsFromRequote`) — 재견적 응답으로 두 슬롯을 통째로 새로 만든다.
소비처: 장바구니(`use-cart.ts:96-124`) · 주문서/결제(`use-order-sheet.ts:140-170`) · 게스트 장바구니(`guest-cart.ts:96-113`) — 셋 다 같은 파서를 쓴다(드리프트 방지 설계).

### 4.3 값은 토큰인가 인라인 JSON인가 — **둘 다다(그게 문제다)**

- `huni_token` = 토큰 **원문**(서명된 문자열, 수 KB).
- `huni_order` = **인라인 JSON**, 그 안에 `editors`(Edicus 프로젝트 참조)·`files`(원고 파일 참조)까지 포함.

계약이 금지하는 것을 정확히 두 가지 다 하고 있다:

**F-2 — 토큰을 샵바이에 넣지 말 것** (가이드:1315-1321)
> 「`huni_token` 은 **일부러 만들지 않았습니다.** … 텍스트 옵션은 주문조회 응답으로 그대로 읽히고, **값 길이 상한이 아직 확인되지 않아 조용히 잘리면 서명 검증이 전부 실패합니다.** 토큰은 저희 보관소(§9)에 넘기고, 샵바이에는 넣지 마세요. 그 자리는 짧은 `item_id`(`huni_item`)가 대신합니다.」
> 가이드:1196-1200 — 「토큰은 금액과 사양이 서명된 **자격증명**이라, 읽히는 자리에 두면 안 됩니다.」

즉 몰이 `huni_token` 에 쓰고 있는 라벨은 **상품에 등록조차 되어 있지 않을 가능성이 높다**(등록된 라벨은 `huni_order`·`huni_item` 2개). 등록되지 않은 라벨로 `optionInputs` 를 보내면 어떻게 되는지는 **미확인** — 무시될 수도, 400 일 수도 있다. 라이브 검증 필요.

**F-6 — 요약에 원고·편집기 정보를 넣지 말 것** (가이드:1180-1187, 1247)
> 「사양 JSON을 통째로 넣지 말아 주세요 — ① 길이 제한이 문서에 없습니다 … ② **주문조회 응답으로 그대로 나옵니다.** 샵바이 문서도 "개인정보나 보안이 필요한 정보는 입력하면 안 됩니다"라고 명시합니다. **원고 파일 키·금액 내역이 평문으로 남게 됩니다.** ③ 사양은 변합니다 — 복사본을 두면 두 벌이 어긋납니다.」

몰은 `editors`·`files` 를 `huni_order` 에 넣고(`huni-widget.tsx:66-67`), 재견적 때도 승계·보존한다(`requote.ts:66-68`). **원고 파일 키가 Shopby 주문조회 응답으로 노출된다.**

**F-7 — `inputNo` 미전송.** 가이드 예시는 `{inputNo, inputLabel, inputValue}` 3필드를 보낸다(가이드:1250-1257, 1265-1271). 몰의 `OptionInput` 타입은 `inputNo?: number | null` 을 갖지만(`use-cart.ts:195`) **어디서도 채우지 않는다.** 가이드 스스로 「`inputNo` 를 함께 싣고 계신지. **라벨만으로 매칭되는지는 확인되지 않았습니다**」(가이드:1044)라고 미확인으로 남겼다. → **미확인. 라이브 담기 1건으로 즉시 판정 가능.**

### 4.4 길이 상한 — **문서에 없다(미확인)**

| 출처 | 내용 |
|---|---|
| Shopby OpenAPI | `optionInputs[].inputValue` = `type: string`, `nullable: true`. **`maxLength` 제약 없음** — `docs/shopby/shopby-api/order-shop-public.yml:18296-18311`, `:13176-13193`, `:16673-16685` |
| Shopby 운영 매뉴얼 | 텍스트 옵션은 상품당 **최대 5개**까지 등록 가능, 매칭타입 OPTION/PRODUCT/AMOUNT — `docs/shopby/shopby_enterprise_docs/product/add-list/add/sale-info/option.mdx:45, 166-189`. **글자수 상한 언급 없음** |
| 후니 가이드 | 「**길이는 150자 안쪽으로 잡아 주세요 ★미확정.** 실제 상한이 샵바이 문서에 없어 아직 측정하지 못했습니다. handoff_id(36자) + 요약 100자 정도면 어떤 제한에도 걸리지 않습니다. 샵바이 장바구니를 붙이실 때 **긴 값으로 한 번 시험해 보시고 결과를 알려 주시면** 이 문서에 확정해 넣겠습니다.」(가이드:1354-1359) |
| 몰 코드 주석 | 「shopby 스키마에 없는 위젯 값(token/payload)은 optionInputs(구매자 작성형)에 텍스트로 저장한다(별도 테이블 없이 라인에 동반, **~5000자+ 확인됨**)」 — `src/components/product/huni-widget.tsx:14-16` |

**충돌한다.** 몰 주석은 5,000자+ 를 「확인됨」이라 하고, 후니 가이드는 「미측정 · 150자 안쪽 권장」이라 한다. **몰 주석의 확인 근거(어떤 상품·어떤 값·어떤 응답)가 코드·커밋 어디에도 없다.** 근거 없는 「확인됨」은 검증되지 않은 주장으로 취급해야 한다.

**초과하면 무슨 일이 나나 — 미확인.** 가이드가 경고하는 실패 모드는 **조용한 절단(silent truncation)** 이다(가이드:1319). 절단되면:
- `huni_token` 이 잘림 → 서명 검증 실패 → 재견적 `bad_token 422`, 주문 등록 `bad_token 422`(가이드:843, 「저장 컬럼 길이를 확인하세요 — 잘리면 이 오류가 납니다」)
- `huni_order` JSON 이 잘림 → `JSON.parse` 실패 → `parseWidget` 이 `undefined` 반환(`widget-order.ts:130-132`) → **장바구니·주문서에 위젯 총액이 아니라 shopby 계산가(10원 × N)가 표시된다.** 화면과 결제액이 갈린다.

가이드가 든 선례 — 「상품 이미지 장수는 문서엔 11장인데 서버는 12·13장도 받아주다가 **16장에서 거절**했습니다」(가이드:1183). 명시되지 않은 제한은 어느 날 조용히 자르거나 갑자기 거절한다.

**닫는 방법**: 판매중지 상품 1건으로 `POST /cart` 에 길이별(200 / 1,000 / 2,000 / 5,000 / 8,000자) `inputValue` 를 담고 `GET /cart` 로 되읽어 절단 지점을 이분탐색. 30분이면 끝난다. 결과는 후니에도 회신(가이드가 요청).

### 4.5 후니가 이미 만들어 둔 대체 경로 — 몰이 하나도 안 쓴다 (F-3)

가이드 §9(가이드:394-560) 는 몰이 토큰을 다루지 않도록 **항목 보관소 API 4종**을 신설했다.

| 후니 API | 용도 | 서버키 | 몰 구현 |
|---|---|---|---|
| `POST /api/w/v1/cart/items` | 토큰 → `item_id`+요약+금액 | 필수 | **없음** |
| `POST /api/w/v1/cart/items/fetch` | 일괄 조회(≤50) | 필수 | **없음** |
| `PUT /api/w/v1/cart/items/{item_id}` | 수량 변경 · 결제 직전 갱신 | 필수 | **없음** |
| `DELETE /api/w/v1/cart/items/{item_id}` | 정리 | 필수 | **없음** |
| `POST /api/w/v1/order/register` | **주문 등록** | item_id 사용 시 필수 | **없음** |

저장소 전체 grep(`node_modules`·`.next` 제외) 결과 `order/register` · `cart/items` · `X-Huni-Server-Key` · `hsk_` · `webhook` **전부 0건**. 몰이 부르는 후니 API 는 `POST /api/w/v1/handoff/requote` **한 개**뿐이다(`src/app/api/printly/requote/route.ts:16`).

가이드는 구방식(토큰 직접 보관 + `/handoff/requote`)도 「계속 지원합니다」(가이드:256-257)라고 했으므로 즉시 고장은 아니다. 그러나 구방식을 유지하려면 **토큰을 자사몰 DB 에 보관**해야 하고(가이드:1338-1342), 몰은 그것을 하지 않고 **샵바이 텍스트 옵션에 넣었다** — 이건 구방식도 신방식도 아닌 **금지된 제3의 방식**이다.

**F-1 — 주문 등록 부재가 가장 치명적이다.**
가이드:1401-1402:
> 「웹훅에는 파일 정보가 실려 오지 않습니다 — 주문번호로 저희 기록을 찾아 잇습니다. 그래서 **5번 호출이 빠지면 그 주문은 무엇을 만들지 알 수 없습니다.**」
가이드:886-888:
> 「빠뜨리면 — 결제는 됐는데 무엇을 만들어야 하는지 모르는 주문이 됩니다. 저희 쪽에서 생산 접수를 진행하지 않고 담당자에게 알립니다(조용히 넘어가지 않습니다).」

호출해야 할 자리는 `src/components/checkout/checkout-form.tsx:419-427` / `guest-checkout-form.tsx:146-154` 의 결제 성공 직후, 또는 `/order-complete` 랜딩(`src/app/(main)/order-complete/page.tsx:31`)에서 `orderNo` 를 받은 직후다. `line_no` 는 Shopby `orderProductOptionNo` 를 그대로(가이드:838-840). **입금대기 상태여도 즉시 호출**(가이드:882-885) — 안 그러면 원고가 30일 보관 기한을 넘겨 사라진다.

`extraData` 의 `handoff_ids`(주문 단위 보조 추적키, 가이드:1204-1208, 1343-1350)도 `buildReserveBody`(`use-order-sheet.ts:346-370`)에 **없다.** 필수는 아니다.

### 4.6 절대 켜면 안 되는 Shopby 설정 (수량 = 금액이므로)

가이드:1101-1109. 현재 전부 꺼져 있음이 확인됐고, 앞으로도 켜면 안 된다.

| 금지 | 켜면 |
|---|---|
| 배송비 — 수량 비례 `QUANTITY_PROPOSITIONAL_FEE` | 15,000원 주문의 배송비가 **1,500배** |
| 배송비 — 수량별 차등 `QUANTITY_FEE` | 항상 최상단 구간 |
| 배송비 — 중량별 차등 `WEIGHT_FEE` + **상품 중량 입력** | 총중량 = 중량 × 수량. 중량은 입력만 해 둬도 나중에 사고 |
| 1회 최대구매수량 제한 | 그 값 × 10원 = 결제 금액 상한. 100 이면 1,000원 넘는 주문 차단 |
| 즉시할인 | `(판매가 − 할인) × 수량` 으로 계산돼 청구액 어긋남. 할인은 쿠폰으로 |

허용 배송비: `FREE`(현재) / `CONDITIONAL` / `FIXED_FEE` / `PRICE_FEE` — 전부 금액 기준(가이드:1110-1114).

---

## 5. 비회원(게스트) 구매가 이 브리지 위에서 성립하는가

HEAD `30cb88a` (2026-08-30, Anthony Kim) — 「비회원(게스트) 구매 — 장바구니·바로구매·주문조회」, 16파일 +1,129/−46.
커밋 메시지 자체가 실측 근거와 한계를 함께 적었다: 「shopby 실측: order-sheets 는 토큰없이 200, guest/cart 계산 200(우리 10원×수량 모델과 일치)」 / 「⚠ **NCPPay 게스트 결제·로컬 장바구니는 브라우저 라이브 테스트 필요(헤드리스 불가)**」.

### 5.1 게스트 흐름 실측

| 단계 | 어떻게 도나 | 위치 | 판정 |
|---|---|---|---|
| 진입 가드 해제 | `PROTECTED_PREFIXES` 에서 `/cart`·`/checkout` 제거, `/mypage`·`/order` 만 유지 | `src/proxy.ts:33` | ✅ |
| 담기 | 위젯 `submit()` → **localStorage** 저장(shopby 호출 없음) | `huni-widget.tsx:271-283` → `guest-cart.ts:57-61` | ✅ |
| 장바구니 화면 | `useCart(!isGuest)` 로 shopby 호출 차단(401 방지), `useGuestCart()` 로 로컬 표시. 파싱은 회원과 **동일**(`parseWidget`) | `cart-page.tsx:59-66`, `guest-cart.ts:96-113` | ✅ |
| 주문서 생성 | `POST /order-sheets` 에 `products[]`(+ 로컬 `optionInputs`) 직접 실음, `cartNos: []` | `cart-page.tsx:203-217`, `use-order-sheet.ts:49` | ✅ (토큰 미주입 — `route.ts:55-62`) |
| 결제 화면 분기 | 서버 `auth()` 로 세션 판정 → `GuestCheckoutForm` | `src/app/(main)/checkout/[orderSheetNo]/page.tsx:20-24` | ✅ |
| 결제 예약 | `buildReserveBody({member:false, guestPassword})` → NCPPay **무인증**(`shopbyAuthorization` 없음), `confirmUrl=/order-complete?guest=1` | `use-order-sheet.ts:346-370`, `guest-checkout-form.tsx:124-155` | ⚠ 라이브 미검증 |
| 쿠폰·적립금 | 게스트는 `coupons.cartCouponIssueNo = null`, `subPayAmt = 0` 강제 | `use-order-sheet.ts:363-367` | ✅ 의도적 |
| 주문완료 | `orderNo` 있으면 `/order-complete/{orderNo}`, 없으면 게스트 안내 화면 | `order-complete/page.tsx:29-36`, `order-complete-view.tsx:246` | ✅ |
| 주문조회 | `POST /guest/orders/{orderNo}` `{password}`, `member:false` | `guest-order-lookup.tsx:144-152` | ✅ |
| **재견적(수량변경)** | `POST /api/printly/requote` → **`auth()` 세션 없으면 401** | `requote/route.ts:20-27`, 호출부 `cart-page.tsx:126` | ❌ **깨진다** |
| **재견적(로드 시 정규화)** | 같은 라우트. 실패를 `.catch(() => {})` 로 삼킴 | `cart-page.tsx:177-186` | ❌ **조용히 실패** |
| **결제 직전 갱신** | **아무 데도 없다** — `checkout-form.tsx`·`guest-checkout-form.tsx` 에 requote grep 0건 | — | ❌ **회원도 동일** |
| **주문 등록** | **없다** | — | ❌ **회원도 동일** |
| 주문 후 로컬 장바구니 비우기 | `clearGuestCart()` 가 **정의만 되고 호출처 0건** | `guest-cart.ts:88-90` | ❌ 결제해도 로컬 장바구니가 남는다 |

### 5.2 게스트의 장바구니 항목은 무엇으로 식별되나

**서버측 식별자가 존재하지 않는다.**

| 값 | 무엇 | 위치 |
|---|---|---|
| `cartNo` | **클라이언트가 만든 로컬 일련번호** — `max(기존 cartNo) + 1`. Shopby `cartNo` 와 무관 | `guest-cart.ts:57-61` |
| 저장소 | `localStorage["huni_guest_cart"]` — 브라우저 1개·오리진 1개에 종속 | `guest-cart.ts:29` |
| Shopby 로 가는 식별 | 주문서 생성 시 `productNo`·`optionNo`·`orderCnt`·`optionInputs` 만 넘어간다. 게스트를 잇는 키 없음 | `cart-page.tsx:206-215` |
| 주문 후 식별 | `orderNo` + 고객이 입력한 `password`(Shopby 가 보관) | `guest-checkout-form.tsx:127`, `guest-order-lookup.tsx:146-151` |

즉 **결제 전까지 게스트의 장바구니는 그 브라우저 안에만 존재**한다. 브라우저를 바꾸거나 시크릿 창을 닫거나 localStorage 를 비우면 **복구 수단이 없다**(서버에 흔적이 없으므로). 회원은 `/cart` 가 원장이라 기기 간 이어진다.

계약 관점 참고: 현행 계약대로 `huni_item`(item_id)을 썼다면 게스트도 후니 항목 보관소에 30일 보관되어 서버측 원장을 갖게 된다. 가이드는 「`item_id` 는 고객이 자기 장바구니에서 볼 수 있는 값」이고 「보관소에는 **회원 정보가 없고**, 저희가 확인하는 것은 "이 사이트의 항목인가"까지」(가이드:449-455)라고 명시 — 그래서 **몰 서버가 브라우저가 보낸 `item_ids` 를 검사 없이 중계하면 고객 A 가 남의 주문 요약·금액을 읽을 수 있다**(제작물 제목에 실명이 흔하다). 회원은 인증 세션으로 `GET /cart` 를 호출해 얻은 목록에서만 뽑으면 되지만, **게스트는 서버 장바구니가 없어 그 검증원이 없다** — 게스트에 `item_id` 방식을 도입할 때 반드시 풀어야 할 설계 문제다. **미확인(설계 미정)**.

### 5.3 게스트가 깨뜨리는 것

| 기능 | 상태 | 원인 |
|---|---|---|
| 수량 변경 | **미성립** | 재견적 401. `cart-page.tsx:127-135` 가 「수량을 변경할 수 없습니다」 토스트를 띄우고 draft 를 되돌린다 |
| `qty_rule` 정규화(스테퍼 min/max/incr 확보) | **미성립·무음** | `cart-page.tsx:184` `.catch(() => {})`. 게스트는 스테퍼 규칙 없이 장바구니를 쓴다 |
| 결제 직전 가격 갱신 | **미성립** | 코드 부재(회원도 동일). 계약상 **필수**(가이드:496-499). 토큰 1시간 만료라 **담고 1시간 지나 결제하면 주문 등록 단계에서 거절**될 수 있다 |
| 주문 등록(후니 인계) | **미성립** | 코드 부재(회원도 동일) → 결제돼도 후니가 무엇을 만들지 모른다 |
| 주문조회 | **성립(코드상)** | `POST /guest/orders/{orderNo}` — 라이브 미검증 |
| 원고 재업로드 | **후니 몫** | 가이드:892 「재업로드 요청 알림·재업로드 화면 전부 저희 몫」. 몰이 만들 것 없음 |
| 편집기(Edicus) 재진입 | **위험 — 별건** | §5.4 |
| 쿠폰·적립금 | **의도적 미제공** | Shopby 회원 전용 |

### 5.4 (별건) Edicus `guest_id` 는 Shopby 게스트와 다른 개념이다

**혼동 금지.** `raw/webadmin` 의 `guest_id` 는 **Edicus 편집기의 게스트 신원**이지 Shopby 비회원 결제와 무관하다.

| 항목 | 내용 |
|---|---|
| 정의 | `guest_uid(partner, site_cd, guest_id) = "mo-" + base64url(sha256(f"{partner}:{site_cd}:{guest_id}"))[:50]` — `raw/webadmin/webadmin/catalog/edicus_lookup.py:201-208` |
| 검증 | 편집기 토큰 발급 전 정규식 검사. 형식 `[A-Za-z0-9-]` 8~64자, 위반 시 `bad_guest_id 422` — `raw/webadmin/webadmin/catalog/widget_api.py:4392-4396` |
| 보관 | 위젯이 브라우저 localStorage 에 보관(가이드:1952) |
| **위험** | 쇼핑몰 **서버는 `guest_id` 를 모른다** → 편집기 uid 를 재구성할 수 없다 — `widget_api.py:2968-2987`. 그리고 「주문 레코드에 `guest_id`·`site_cd` 가 남아 있지 않으면 재현할 수 없다」 — `edicus_lookup.py:446-447` |

즉 **비로그인 고객이 편집기로 만든 원고는, 브라우저 localStorage 를 잃으면 서버측에서 되찾을 방법이 없다.** 이건 Shopby 게스트 결제 판정과는 **독립된 별개 리스크**이며, 위 §5.1~5.3 판정에 섞지 않는다. 몰 코드는 편집기를 아예 호출하지 않으므로(위젯 내장 버튼에 위임 — `huni-widget.tsx:166-168` 는 로그만 찍는다) 현재는 잠재 리스크다.

### 5.5 판정

> ## **부분 성립**

| 구간 | 판정 | 근거 |
|---|---|---|
| 담기 → 주문서 생성 → 결제 예약 → 주문번호 수령 → 주문조회 | **코드상 성립, 라이브 미검증** | §5.1 표. `POST /order-sheets` 토큰없이 200 은 커밋 메시지의 실측 주장이나 **증거(HAR·응답 로그) 없음**. NCPPay 게스트 결제는 커밋 작성자 본인이 「브라우저 라이브 테스트 필요」로 명시 |
| 수량 변경 · 결제 직전 갱신 | **미성립** | `requote/route.ts:20-27` 세션 401(게스트) + 결제 화면 requote 부재(회원·게스트 공통) |
| 주문 등록(후니 인계) | **미성립** | 코드 부재 — 게스트 고유 문제가 아니라 **몰 전체의 결함** |
| 장바구니 내구성 | **취약** | 서버 원장 없음. 브라우저 종속(`guest-cart.ts:29`) |

**즉 「10원×N 브리지 위에서 게스트 결제까지는 성립하나, 그 주문이 실제로 인쇄되지는 않는다」** — 주문 등록이 없기 때문이다. 그리고 이 마지막 문장은 게스트뿐 아니라 **회원에게도 똑같이 적용된다.**

**미확인으로 남기는 것**
- 게스트 `POST /order-sheets` 가 토큰 없이 실제 200 인가 → 라이브 1회 호출로 확정
- 게스트 NCPPay `reserve` → 결제창 → `confirmUrl` 왕복이 도는가 → 브라우저 실측 필요
- `POST /guest/orders/{orderNo}` 응답 스키마가 `guest-order-lookup.tsx:60-122` 의 `parse()` 기대와 맞는가 → 실주문 1건 필요
- 등록되지 않은 라벨(`huni_token`)로 `optionInputs` 를 보냈을 때 Shopby 동작 → 라이브 담기 1회

---

## 6. 깨지면 무엇이 무너지는가 (그룹별)

| 그룹 | 깨지면 | 영향 | 감지 |
|---|---|---|---|
| **인증(`/oauth2`)** | 로그인·갱신·폐기 전부. 회원 장바구니·주문서·마이페이지가 401 | 회원 구매 전면 정지. **게스트 구매는 살아 있다**(설계상 분리) | `client.ts:126-136` 1회 재시도 후 `AuthErrorWatcher` 로그아웃 |
| **shop 프록시(`/api/shop`)** | 브라우저 → Shopby 전 경로 | **쇼핑몰 전면 정지** (상품 SSR 은 서버 fetch 라 살아남음) | 502 `upstream_unreachable`(`route.ts:84-89`) |
| **상품·카탈로그** | 카테고리·목록·검색·상세 | 목록/메가메뉴가 빈다. `getProductDetail` 은 null 폴백 | 서버 로그(`catalog.ts:181`) |
| **`/products/{no}/options`** | `defaultOptionNo` 미해석 | **장바구니·바로구매 버튼이 막힌다**(「옵션 정보를 불러오는 중입니다」 — `huni-widget.tsx:239-244`) | 토스트 |
| **장바구니(`/cart`)** | 회원 장바구니 조회·담기·수량·삭제 | 회원 담기 불가. 게스트는 localStorage 라 무영향 | shopby 오류 메시지 그대로 노출(`client.ts:60-69`) |
| **optionInputs 규약** | `huni_order` JSON 파싱 실패 → `parseWidget` undefined | **화면에 10원×N(= 정상 총액이지만 단가·수량·요약이 사라진 형태)이 뜬다.** 셀러어드민에는 「10원 × 1,500개」만 보여 취소·환불·문의 응대 불가(가이드:1427-1430) | 없음 — **조용히 틀린다** |
| **10원 단위 규약** | 후니가 절삭 단위를 바꾸면 10원 배수가 아닌 금액 발생 | 화면 15,003원 / 결제 15,000원. 후니 서버가 `price_unit_mismatch 422` 로 선차단(가이드:1063-1066) | 422. **반올림 재시도 금지** |
| **재견적(`/handoff/requote`)** | 수량 변경·가격 갱신 | 담긴 지 1시간 지난 토큰으로 결제 → 주문 등록에서 거절. 게스트는 애초에 401 | 토스트(수량변경) / 무음(정규화) |
| **주문서(`/order-sheets*`)** | 결제 진입 불가 | 구매 전면 정지 | 「주문서 작성에 실패했습니다」(`cart-page.tsx:222`) |
| **결제(NCPPay)** | `ncp_pay.js` 로드 실패 또는 `reserve` 실패 | 결제 불가 | `ncp-pay.ts:70-73` reject / `onError` 콜백 |
| **주문 등록(부재)** | — | **이미 깨져 있다.** 결제된 주문이 「무엇을 만들지 모르는 주문」이 된다. 후니가 조용히 넘기지 않고 담당자에게 알린다(가이드:886-888) — 즉 **매 주문마다 사람 손이 들어간다** | 후니측 알림. 몰측 감지 수단 없음 |
| **재고(Shopby)** | 재고 0 → 품절 → 구매 불가 | 재고 × 10원 = 그 상품 누적 결제 한도. 현재 9,999 → **약 10만원 결제되면 품절**. 후니가 자동 보충하지만 **보충 작업이 멈추면 전 상품 결제가 멈춘다**(가이드:1096-1099) | Shopby 품절 표시 |
| **금지 설정 오조작** | 수량비례 배송비·중량·최대구매수량·즉시할인 중 하나라도 켜짐 | 배송비 1,500배 / 1,000원 넘는 주문 차단 / 청구액 어긋남 | 없음 — 운영자 실수 한 번으로 발생. **운영 매뉴얼에 명시 필요** |
| **알림 템플릿** | 수량 치환 미제거 | 고객 문자에 「… (1500)」 | ★미확정(가이드:1433) |
| **세금계산서·현금영수증** | 품목·수량에 1,500 | 회계·세무 이슈 | **대응책 없음 — 미해결** |
| **가상계좌 입금기한** | 30일보다 길면 | 입금 전에 원고(30일 보관)가 사라진다. 권장 3~7일(가이드:937-940) | **현재 설정값 미확인** |
| **게스트 localStorage** | 브라우저 변경·시크릿·정리 | 게스트 장바구니 전손, 복구 불가 | 없음 |
| **server API(`/admins`)** | — | **무영향**(소비처 0). 다만 쓰기 시작하면 고정 IP 등록 필요 | — |

---

## 7. 미확인 목록 (추정으로 메우지 않음 · 닫는 방법 명시)

| # | 미확인 | 닫는 방법 |
|---|---|---|
| U-1 | `optionInputs.inputValue` 실제 길이 상한 (몰 주석 「5000자+ 확인됨」 vs 가이드 「미측정·150자 권장」) | 판매중지 상품 1건으로 길이별 `POST /cart` → `GET /cart` 되읽기 이분탐색. 결과를 후니에 회신 |
| U-2 | `inputNo` 없이 라벨만으로 매칭되는가 | 라이브 담기 1회 후 `GET /cart` 응답의 `optionInputs` 확인 |
| U-3 | 등록되지 않은 라벨(`huni_token`)을 보내면 Shopby 가 무시하는가 거절하는가 | 위와 동일 호출로 동시 확인 |
| U-4 | 게스트 `POST /order-sheets` 가 토큰 없이 200 인가 (커밋 주장, 증거 없음) | 라이브 1회 |
| U-5 | 게스트 NCPPay reserve→결제창→confirm 왕복 | 브라우저 실측(헤드리스 불가 — 커밋 명시) |
| U-6 | `X-Huni-Server-Key`(`hsk_…`) 발급 여부 | 후니 담당자 확인 |
| U-7 | 가상계좌 입금기한 현재 설정값 | 셀러어드민 확인 |
| U-8 | 알림 템플릿 수량 치환 제거 시점 | PM ↔ NHN |
| U-9 | 세금계산서 품목·수량 표기 대응 | **대응책 자체가 없음.** PM 결정 필요 |
| U-10 | server-api 사용 여부 확정 + 배포 환경 고정 IP 제공 여부 | 결정 → 필요 시 NHN 에 IP 등록 |
| U-11 | Shopby 프로모션(쿠폰·적립금·배송비)이 10원×N 과 실제로 충돌하지 않는가 | 가이드는 「금액 기준이라 안전」이라 하고 Shopby 쿠폰 문서 원문을 인용(가이드:1118-1126). **실측 1건으로 확인 권장**(돈이 걸린 항목) |
| U-12 | NCPPay SDK 가 내부에서 호출하는 Shopby 경로 전수 | 라이브 HAR 캡처 |

---

## 8. 권고 (우선순위)

1. **주문 등록(`POST /api/w/v1/order/register`) 구현** — 이것 없이는 결제된 주문이 인쇄되지 않는다. 결제 성공 직후, `line_no = orderProductOptionNo`, 입금대기 포함, 실패 시 재시도(멱등 보장).
2. **optionInputs 규약을 현행 계약으로 이관** — `huni_token` 제거, `huni_item`(item_id) 도입, `huni_order` 는 후니가 준 요약 문자열 그대로. `editors`·`files` 제거. 항목 보관소 API 4종 + 서버키 도입.
3. **결제 직전 갱신 추가** — 회원·게스트 결제 화면 양쪽.
4. **U-1 / U-2 / U-3 을 한 번의 라이브 담기로 동시에 닫기** — 30분 작업, 세 개의 미확인이 한꺼번에 사라진다.
5. **게스트 재견적 경로 설계** — 세션 대신 다른 인가 수단(예: 서버가 로컬 라인의 item_id 유효성을 사이트 범위로만 확인) 필요. §5.2 의 **타인 item_id 조회 위험**을 함께 해결해야 한다.
6. **운영 금지사항을 셀러어드민 운영 매뉴얼에 명문화** — 수량비례/중량 배송비·최대구매수량·즉시할인·수동 주문상태 변경·재고 직접 조작.
7. **L0 정정** — ARCHITECTURE.md 의 「31 고유 경로」→ **38**, 「server API 연동」→ 「shop API 연동(server API 는 사문 훅 1개)」.

---

*작성: M2 카드 계약 C2 조사 · 2026-09-02 · 라이브 호출 없음(정적 판독 + 문서 대조)*
