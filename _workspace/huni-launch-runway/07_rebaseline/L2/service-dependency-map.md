# L2 — 연계 서비스 전수 지도

> 작성 2026-09-02 · run-huniweb 세션 · 카드 t29(L2)
> 근거는 **코드**다. 문서·커밋 메시지는 근거로 쓰지 않았다.
> 대상: `/Users/innojini/Dev/huni-skin-shopby` (Next.js 스토어프론트) + `raw/webadmin` (Django 운영자/가격엔진)
> 읽기전용 조사 — 두 코드베이스 수정 0 · DB write 0.

## 0. 한눈에

외부 의존 **18종**. 오픈(10/6) 관점 위험도 3등급:

| 등급 | 뜻 | 건수 | 해당 |
|---|---|---|---|
| 🔴 critical — 오픈 차단 | 없으면 주문이 성립하지 않음 | 7 | D-01·02·03·04·05·06·11 |
| 🟡 high — 기능 결손 | 없으면 핵심 기능 일부가 빠짐 | 3 | D-07·08·15 |
| 🟡 medium — 보완 필요 | 대체 수단이 있거나 미구현 | 5 | D-09·10·16·17·18 |
| ⬜ low — 운영 편의 | 없어도 고객 경로 무영향 | 3 | D-12·13·14 |

## 1. 서비스 목록

### D-01 · Shopby shop API (스토어프론트) 🔴
- 호스트: `https://shop-api.e-ncp.com` — `huni-skin-shopby/src/lib/api/config.ts:67`
- 호출 지점: `src/app/api/shop/[...path]/route.ts:43-48` (catch-all 프록시, 서버에서만 헤더 주입)
- 인증: `clientId` + `platform` + `Version` 헤더 (`src/lib/api/config.ts` `buildShopHeaders`) + 회원 `Authorization: Bearer` — 세션 JWT에서 읽어 주입 (`route.ts:27-40`)
- 쓰는 곳: 카탈로그·장바구니·주문서·회원·리뷰·쿠폰·포인트 전부
- 계약 필요: **예** — NHN Commerce Shopby 몰 계약 + clientId 발급
- 실패 시 영향: 쇼핑몰 전 기능 정지. 대체 경로 없음.

### D-02 · Shopby server API (파트너/운영) 🔴
- 호스트: `https://server-api.e-ncp.com` — `huni-skin-shopby/src/lib/api/config.ts:31`, `raw/webadmin/webadmin/config/settings.py:465`
- 호출 지점: `huni-skin-shopby/src/app/api/shopby/[...path]/route.ts:21-45` · `raw/webadmin/webadmin/catalog/shopby_client.py:1-50`
- 인증: `authorization: Bearer <파트너 JWT>` + `systemkey` + `version` (`shopby_client.py:_creds`)
- 계약 필요: **예** — 파트너 토큰·시스템키 발급
- 실패 시 영향: 관리자 조회 + 메인이미지 동기화 정지. 고객 주문 경로는 D-01로 유지.
- 제약: 초당 100회 상한(429 `EXHAUSTED`) — `shopby_client.py:5-6` 실측 계약 주석

### D-03 · NCPPay 결제 SDK (PG) 🔴
- 스크립트: `<shopApiBase>/payments/ncp_pay.js` — `huni-skin-shopby/src/lib/payments/ncp-pay.ts:60`
- 설정 공급: `src/app/api/pay-config/route.ts:8` (clientId·platform 공개값)
- 예약 호출: `NCPPay.reservation(...)` — `src/lib/payments/ncp-pay.ts:31-38`, `src/components/checkout/checkout-form.tsx:395`
- 인증: 회원은 `shopbyAuthorization: Bearer <accessToken>`, 게스트는 무인증
- 계약 필요: **예** — PG사 계약 + Shopby 결제수단 설정
- ⚠ **현행 결제수단은 무통장입금(ACCOUNT)뿐**이다. `checkout-form.tsx:8-9`가 "PG 연동은 후속 — 현재는 무통장만 동작"이라고 코드 주석으로 명시한다. 카드 결제는 오픈 차단 항목.

### D-04 · Printly 후니어드민 위젯 SDK + 견적 API 🔴
- 오리진: `https://huni-admin.printly.co.kr` — `huni-skin-shopby/src/lib/printly/huni.ts:10`
- 위젯 스크립트: `WIDGET_SCRIPT_SRC` preload — `src/app/(main)/product/[slug]/page.tsx:60`
- 커스텀 엘리먼트 마운트: `src/components/product/huni-widget.tsx:312-313` (`widget-id`, `site-key`)
- 재견적 API: `POST /api/w/v1/handoff/requote` — `src/app/api/printly/requote/route.ts:16`
- 인증: `site_key`(도메인 제한 공개키, 서버 env `HUNI_WIDGET_SITE_KEY`만) + 로그인 세션 게이트(`requote/route.ts:22-30`)
- 서버측 구현: `raw/webadmin/webadmin/config/urls.py:246-256` (widgets·catalog·price·validate·handoff)
- 계약 필요: 아니오(자사) — 단 **도메인 화이트리스트 등록** 필요
- 실패 시 영향: 실시간 견적·인쇄 옵션 선택 전면 불가 → 인쇄 주문 자체가 불가

### D-05 · Printly 커머스 DB (Railway PostgreSQL, 위젯 해석) 🔴
- 접속: `PRINTLY_DB_URL` — `huni-skin-shopby/src/lib/printly/widget.ts:44-53` (pg Pool, `default_transaction_read_only=on`)
- 쿼리: `t_wgt_sites` → `t_wgt_widgets` 2단계 — `src/lib/printly/widget.ts:68-90`
- 캐시: `unstable_cache` 300초, 태그 `printly-widgets` — `widget.ts:26-28`
- 계약 필요: 아니오(자사)
- 실패 시 영향: 위젯 미해석 → 하드코딩 가격의 폴백 Configurator로 떨어짐(`configurator.tsx:45-52`). **잘못된 가격이 노출되는 경로**라 사실상 오픈 차단.

### D-06 · Edicus 온라인 편집기 🔴
- 호스트: `EDICUS_API_HOST` — `raw/webadmin/webadmin/config/settings.py:545`
- 토큰 발급: `POST {host}/api/auth/token`, 헤더 `edicus-api-key` — `raw/webadmin/webadmin/catalog/edicus_lookup.py:214-241`
- 리소스 호스트: `EDICUS_RESOURCE_HOST` (미설정 시 SDK 기본 `https://edicusbase.firebaseapp.com`) — `settings.py:547-548`
- 위젯 API 노출: `api/w/v1/editor/resolve`, `api/w/v1/editor/token` — `config/urls.py:274-275`
- 인증: `EDICUS_API_KEY` + `EDICUS_PARTNER_CODE` (`edicus_lookup.py:253-257`)
- 계약 필요: **예** — Edicus 파트너 계약
- 실패 시 영향: 에디터 주문 상품 전부 주문 불가. 게이트: `edicus_lookup.py:253`이 키 미설정이면 조기 반환(fail-closed).
- ⚠ 스토어프론트의 "에디터로 디자인하기" 버튼은 **onClick이 없다**(`configurator-actions.tsx:170-176`). 에디터 진입은 위젯 내부 경로(`huni:editor` 이벤트, `huni-widget.tsx:176`)만 살아 있다.

### D-07 · AWS S3 (5개 버킷 용도) 🟡
- 클라이언트: `boto3.client("s3", ...)` — `s3_guide.py:266`, `s3_artwork.py:208`, `s3_main_img.py:187`, `s3_swatch.py:143`
- presigned URL: `s3_artwork.py:239,280` (원고 PUT·멀티파트), `s3_guide.py:288,350`, `s3_main_img.py:197`
- 버킷: `S3_ARTWORK_TMP_BUCKET`·`S3_ARTWORK_ORDER_BUCKET`(`settings.py:439-440`), `S3_GUIDE_BUCKET`(`:501`), `S3_MAIN_IMG_BUCKET`(`:508`), `S3_SWATCH_BUCKET`(`:450`)
- 리전: `ap-northeast-2` 기본 — `settings.py:441`
- 인증: boto3 기본 자격증명 체인(환경변수/IAM 역할) — 코드가 키를 직접 읽지 않음
- 계약 필요: **예** — AWS 계정·버킷·IAM
- 실패 시 영향: 원고 업로드 불가(=주문 원고 미첨부), 가이드·메인이미지 서빙 불가
- 함정 기록: 신규 버킷 307 리다이렉트 회피용 `endpoint_url` 명시 — `s3_guide.py:238,265`

### D-08 · Shopby 웹훅 수신 🟡
- 엔드포인트: `api/w/v1/shopby/webhook/<str:secret>` — `raw/webadmin/webadmin/config/urls.py:271`
- 구현: `catalog/shopby_hook.py:1-27`
- 인증: **서명 없음**. 추측 불가능한 비밀 경로(`SHOPBY_WEBHOOK_SECRET`, `settings.py:462`)만이 방어선
- 상태: **partial** — 원문 적재 후 즉시 200까지만. 해석·주문 처리는 미구현(`shopby_hook.py:8-11`이 명시)
- 실패 시 영향: Shopby는 **실패한 웹훅을 재전송하지 않는다**(`shopby_hook.py:5`). 결제됐는데 생산이 시작되지 않는 사고 경로.

### D-09 · Pie Canvas 발행본 DB (상세페이지 탭) 🟡
- 접속: `PRINTLY_DB_URL` 재사용, `vc_v_product_detail_tabs` VIEW만 읽음 — `huni-skin-shopby/.env.example:44-49`
- 조회: `fetchPublishedDetailTabs(...)` — `src/app/(main)/product/[slug]/page.tsx:51-56`, `src/lib/printly/publications.ts`
- 범위 고정: `PRINTLY_WORKSPACE_ID` — `src/lib/printly/product-code-map.ts:23-38`
- 실패 시 영향: 상세탭이 정적 섹션으로 폴백(치명 아님)

### D-10 · Daum(카카오) 우편번호 서비스 🟡
- 스크립트: `https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js` — `huni-skin-shopby/src/lib/daum-postcode.ts:10`
- 인증: 없음(무료 공개)
- 계약 필요: 아니오
- 실패 시 영향: 주소 검색 팝업 불가 → 배송지 수기 입력만 가능

### D-11 · Railway PostgreSQL (webadmin 주 DB) 🔴
- 접속: `DATABASE_URL` — `raw/webadmin/webadmin/config/settings.py` (dj-database-url)
- 드라이버: `psycopg[binary]>=3.1` — `requirements.txt`
- 모델 58개 — `raw/webadmin/webadmin/catalog/models.py:13-1468`
- 실패 시 영향: 가격엔진·위젯 API·운영자 화면 전면 정지

### D-12 · Anthropic API (관리자 비서) ⬜
- 클라이언트: `anthropic.Anthropic(api_key=...)` — `raw/webadmin/webadmin/catalog/assistant.py:238-240` (lazy import)
- 키: `ANTHROPIC_API_KEY` — `settings.py:517`
- 엔드포인트 노출: `api/assistant/` — `config/urls.py:291-300`
- 계약 필요: **예**(유료 API) — 단 키 미설정 시 경로 비활성
- 실패 시 영향: 관리자 비서만 중단. 고객 경로 무영향.

### D-13 · GitHub API (비서 이슈 등록) ⬜
- 호출: `https://api.github.com/repos/{repo}/issues` — `raw/webadmin/webadmin/catalog/assistant_issue.py:174`
- 인증: `Authorization: Bearer <ASSISTANT_GITHUB_TOKEN>` — `assistant_issue.py:177-183`
- 대상 레포: `shopbiz-site/HuniProductPrice2` 기본값 — `settings.py:537`
- 실패 시 영향: 리포트 자동 등록만 중단

### D-14 · Telegram Bot API (남용 알림) ⬜
- 호출: `https://api.telegram.org/bot{token}/sendMessage` — `raw/webadmin/webadmin/catalog/rate_alerts.py:61`
- 인증: `TELEGRAM_BOT_TOKEN` + `TELEGRAM_ALERT_CHAT_ID` — `settings.py:416`
- 미설정 시 네트워크 시도 자체를 안 함 — `rate_alerts.py:56-58`
- 실패 시 영향: 알림만 누락(모든 예외 흡수, `rate_alerts.py:73-76`)

### D-15 · Redis (위젯 rate-limit 공유 캐시) 🟡
- 설정: `REDIS_URL` — `raw/webadmin/webadmin/config/settings.py:343,362-368`
- 미설정 시 LocMem 폴백 — `settings.py:339-341`
- ⚠ **현행 Railway는 REDIS_URL 미설정**(`settings.py:340` 주석). 워커별 카운트라 실질 상한 = 설정값 × 워커수(`settings.py:531`)
- 실패 시 영향: 위젯 남용 방어가 약화(오픈 시 트래픽에 따라 위험)

### D-16 · NextAuth OAuth (Google / Naver / Kakao) 🟡
- env 자리: `AUTH_GOOGLE_ID/SECRET`, `AUTH_NAVER_*`, `AUTH_KAKAO_*` — `huni-skin-shopby/.env.example:17-32`
- 상태: **미배선**. `authConfig.providers`는 빈 배열(`src/lib/auth/auth.config.ts:16`), SNS 버튼은 토스트 안내만(`src/components/auth/sns-buttons.tsx:74-80`)
- 계약 필요: **예** — 3개 콘솔 앱 등록 + Redirect URI
- 실패 시 영향: 소셜 로그인 미제공(이메일 로그인은 정상)

### D-17 · 본인인증(휴대폰/아이핀) ⬜→🟡
- **호출 지점 없음**. `huni-skin-shopby/src` 전역 `https://` 검색 결과에 인증사 호스트가 없다.
- 회원가입은 이메일+비밀번호만 — `src/app/api/auth/signup/route.ts:26-31`
- 실패 시 영향: 오픈 정책상 본인인증이 필요하면 **신규 개발** 항목

### D-18 · 세금계산서/현금영수증 발행 ⬜→🟡
- **호출 지점 없음**. 증빙서류 화면은 정적 표 UI만 — `huni-skin-shopby/src/components/mypage/document-section.tsx:1-6`
- B2B 후불·세금계산서는 webadmin에도 전용 화면 없음(`config/urls.py`에 부재; `TCusCustomers` 모델만 존재 `catalog/models.py:87`)
- 실패 시 영향: B2B 정산 경로 미구현 → 신규 개발 항목

## 2. 오픈(10/6) 관점 블로커 요약

코드가 말하는 것만 적는다.

1. **카드 결제 미연동** — 무통장입금만 동작(`checkout-form.tsx:8-9`). PG 결제는 코드에 없다.
2. **Shopby 웹훅 후처리 미구현** — 수신만 하고 주문 처리로 이어지지 않는다(`shopby_hook.py:8-11`). 재전송이 없으므로 유실 = 사고.
3. **위젯 상품 매핑이 수동 7건** — `product-code-map.ts:41-49`. 나머지 상품은 하드코딩 가격 폴백(`configurator.tsx:45-52`)으로 떨어진다.
4. **원고 업로드 경로가 스토어프론트에 없다** — 서버측 presign은 있으나(`s3_artwork.py:239`), FE의 "PDF파일 직접 올리기"는 장바구니 담기일 뿐이다(`configurator-actions.tsx:74-86`).
5. **에디터 진입 버튼이 데드** — `configurator-actions.tsx:170-176`에 onClick 없음.
6. **Redis 미설정** — 위젯 rate limit이 워커별로 쪼개져 있다(`settings.py:340`).
7. **본인인증·세금계산서 미구현** — 호출 지점 자체가 없다(D-17, D-18).

## 3. 판정 규약

- `done` — 실제 외부 호출/DB 접근이 코드에 있고 화면까지 배선됨
- `partial` — 일부만 실동작(예: 조회는 되나 쓰기는 mock, 수신만 하고 처리 없음)
- `stub` — UI는 있으나 실동작 없음(no-op·토스트·하드코딩)
- `absent` — 코드 자체가 없음
