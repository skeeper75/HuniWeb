# Shopby Shop API 인증·세션 모델 (회원/게스트)

> 권위: OpenAPI 스펙(`order-shop-public.yml`·`member-shop-public.yml`) 1차 →
> docs-complete `auth.mdx`(인증 서비스 = `auth-shop`) 보강.
> ★ 인증(토큰 발급) 엔드포인트는 본 레포의 `*.yml` 파일에 **없다** — 별도 인증 서비스(`auth-shop`)이며
> 현재 권위 근거는 docs-complete의 `shopby-api-docs-complete/01_shop-api/auth.mdx`(operationId 기재). 미상 raw shape은 open-questions로.

---

## 1. 두 가지 토큰 헤더 규약 (공존)

모든 Cart/OrderSheet/Purchase op는 회원 식별에 다음 두 헤더 중 하나를 받는다(둘 다 optional, 상호배타 사용).

| 헤더 | 형식 | 설명 | 근거 |
|------|------|------|------|
| `accessToken` | 토큰 문자열(raw) | 회원 액세스 토큰(레거시) | 스펙: order-shop-public.yml:485-491 (get-cart 외 전 op 반복) |
| `Shop-By-Authorization` | `Bearer <token>` | 액세스 토큰(OAuth2 스펙) | 스펙: order-shop-public.yml:492-498 |

- docs-complete member.mdx 주: "[Oauth2 API](post-oauth2-token)로 토큰을 발급받은 경우, 기존 accessToken 대신 Shop-By-Authorization으로 액세스 토큰을 전달" — 근거: shopby-api-docs-complete/01_shop-api/member.mdx:169-171 (동일 패턴 6회 반복).
- 즉 **신규(권장) = OAuth2 `Shop-By-Authorization` 헤더**, 레거시 = `accessToken` 헤더. 후니 신규 구현은 OAuth2 경로 채택 권장.

---

## 2. 공통 클라이언트 헤더 (인증 무관 필수)

| 헤더 | 필수 | 설명 | 근거 |
|------|:---:|------|------|
| `Version` | ✅ | API 버전(`1.0`) | 스펙: order-shop-public.yml:457-463 |
| `clientId` | ✅ | 쇼핑몰 클라이언트 아이디(몰 식별, ★비밀값) | 스펙: order-shop-public.yml:464-470 |
| `platform` | ✅ | PC / MOBILE_WEB / AOS / IOS | 스펙: order-shop-public.yml:471-477 |
| `language` | - | 기본 ko | 스펙: order-shop-public.yml:478-484 |

- `clientId`는 몰 식별 비밀값 — 산출물/로그/프롬프트에 실제 값 비노출(본 문서엔 키 이름만).

---

## 3. 회원 인증 흐름

### 3.1 OAuth2 (권장)

| 단계 | 엔드포인트 | operationId | 근거 |
|------|-----------|-------------|------|
| 토큰 발급(로그인) | `POST /oauth2` | `post-oauth2-token` | auth.mdx:629-633 |
| 토큰 갱신 | `PUT /oauth2` (`Shop-By-Authorization`+`Refresh-Token` 헤더) | `put-oauth2-token` | auth.mdx:610-627 |
| 토큰 만료(로그아웃) | `DELETE /oauth2` (`Shop-By-Authorization`) | `delete-oauth2-token` | auth.mdx:646-660 |
| 오픈아이디 재인증 | `PUT /oauth2/openid` | `put-oauth2-openid-reauthenticate` | auth.mdx:662-680 |

- 발급 후 `Shop-By-Authorization: Bearer <accessToken>`, 갱신 시 `Refresh-Token` 헤더 사용.
- ★ `post-oauth2-token`의 requestBody(아이디/비밀번호 필드)는 mdx 표에 헤더만 기재되고 body schema 미기재 → open-questions Q-AUTH-1.

### 3.2 레거시 OAuth (accessToken 발급)

| 단계 | 엔드포인트 | operationId | 근거 |
|------|-----------|-------------|------|
| 토큰 발급 | `POST /oauth/token` | `post-oauth-token-dormant` | auth.mdx:276-289 |
| 토큰 반환(로그아웃) | `DELETE /oauth/token` (`accessToken` 헤더) | `RevokeToken` | auth.mdx:294-308 |

### 3.3 소셜/간편 로그인 (OpenId)

| 단계 | 엔드포인트 | operationId | 근거 |
|------|-----------|-------------|------|
| 로그인 URL 조회 | `GET /oauth/login-url` (`provider`,`redirectUri`,`state`) | `get-oauth-login-url` | auth.mdx:146-164 |
| OpenId 토큰 발급(POST) | `POST /oauth/openid` (`keepLogin`→90일 토큰) | `post-oauth-openid` | auth.mdx:167-256 |
| 로그인 페이지 열기 | `GET /oauth/begin` | `get-oauth-begin` | auth.mdx:535-561 |
| 콜백(토큰 발급) | `GET /oauth/callback` → `nextUrl?accessToken=..&expireIn=..` | `get-oauth-callback` | auth.mdx:566-600 |
| SNS 연동 해제 | `DELETE /oauth/openid` | `delete-oauth-openid` | auth.mdx:258-275 |

- 지원 provider: ncp_naver, ncp_kakao, ncp_kakao-sync, ncp_line, ncp_facebook, ncp_payco, ncp_apple, ncp_google, app-card, (엔터프라이즈 자체연동) ncpstore — 근거: auth.mdx:200-230.
- 흐름: `/oauth/begin` → 간편 로그인 페이지 → `/oauth/callback` → `nextUrl`(쿼리에 accessToken 포함) — 근거: auth.mdx:553-555, 586-592.

### 3.4 본인인증(인증번호)

| 단계 | 엔드포인트 | operationId | 근거 |
|------|-----------|-------------|------|
| 인증번호 발송 | `POST /authentications` | `SendAuthenticationNumber` | auth.mdx:60-71 |
| 인증번호 확인 | `GET /authentications` | `get-authentications` | auth.mdx:31-56 |
| 이메일 인증코드 확인 | `GET /authentications/email` | `get-authentications-email` | auth.mdx:104-130 |
| KCP 본인인증 | KCPCertification 리소스 | (mdx) | auth.mdx:리소스 목록 22-29 |

---

## 4. 게스트(비회원) 세션 모델

게스트는 영속 토큰이 없다. 흐름은 임시 비밀번호 기반.

| 단계 | 메커니즘 | 근거 |
|------|---------|------|
| 장바구니 | 토큰 없이 `POST /guest/cart`로 매 호출 라인 전달(서버 영속 안 함) | 스펙: order-shop-public.yml:1272, 파라미터에 토큰 헤더 미포함 1280-1307 |
| 주문서 | `POST /order-sheets`를 accessToken=null로 호출 | 스펙: order-shop-public.yml:3787 ("비회원 주문인 경우 accessToken을 null로 보냄") |
| 결제 예약 | `POST /payments/reserve` `member:false` + `tempPassword`(비회원 필수) | 스펙: order-shop-public.yml:33222-33224, 33241-33244 |
| 주문 조회 토큰 | `GET .../guest-token`(orderNo로 guestToken 발급) | 스펙: order-shop-public.yml:5309 `get-previous-order-guest-token` |
| 주문 상세 조회 | `GET /guest/orders/{orderNo}` (`guestToken` 헤더 필수) | 스펙: order-shop-public.yml:1421 `get-guest-orders-order-no`, guestToken required:true |
| 비밀번호 찾기 | `GET /guest/orders/{orderNo}/forgot-password` | 스펙: order-shop-public.yml:2579 |

- ★ 회원 vs 게스트 핵심 차이:
  1. 카트 영속성: 회원=서버(`cartNo` PK, get/put/delete/calculate), 게스트=stateless(매번 body 계산).
  2. 식별: 회원=`accessToken`/`Shop-By-Authorization` 토큰, 게스트=`tempPassword`(설정)→`guestToken`(orderNo로 발급, 조회용).
  3. 주문서/예약 엔드포인트는 **동일**(회원 토큰 유무 + `member` 플래그 + `tempPassword`로 분기).

---

## 5. 후니 브리지 함의

- 후니 프론트(위젯)는 회원 = OAuth2 `Shop-By-Authorization` 보유, 게스트 = 토큰 없이 stateless cart + reserve 시 tempPassword 생성.
- `clientId`/토큰은 .env.local 또는 서버 세션에 보관, 클라이언트 노출 최소화(특히 `clientId`는 몰 식별 비밀값).
- 인증 서비스 base URL은 auth.mdx 기준 `https://shop-api.shopby.co.kr`(auth.mdx:18), 주문 서비스는 `https://shop-api.e-ncp.com`(order-shop-public.yml:7). 두 도메인이 다른 점 확인 필요 → open-questions Q-ENV-1.
