# Shopby Enterprise 1차 정찰 결과 (2026-05-27)

## 🔥 핵심 발견

**후니프린팅은 buysangsang(WP) 외에도 Shopby Enterprise mall을 이미 운영 중**

| 항목 | 값 |
|------|----|
| Mall No | 81683 |
| Mall Name | huniprinting48 |
| PC URL | https://huniprinting48.shopby.co.kr |
| Mobile URL | https://m-huniprinting48.shopby.co.kr |
| Aurora 라이브 노출 | YES (sitemap 24 URL이 표준 Aurora 라우팅) |
| robots.txt | `User-agent: * Allow: /` |
| 캐시 | NCE Cache HIT, max-age=3600 (CDN 적극 활용) |

→ **두 사이트 병행 운영 중** (buysangsang.com WP + huniprinting48.shopby.co.kr Aurora Skin). 리뉴얼 = 둘 다 종결 → 단일 To-Be로 통합.

## Shopby Shop API 정확한 엔드포인트 (Phase A 정찰)

### 상품 도메인 (`product-shop-public`, GET 42건)
- `/products/{productNo}` — 상품 상세
- `/products/search` — 검색
- `/products/options` — **옵션 목록 (옵션이 별도 API 엔티티)**
- `/products/extraInfo` — 부가정보
- `/products/custom-properties` — **상품 커스텀 속성**
- `/products/configuration/naver-shopping` — 네이버 쇼핑 설정
- `/products/regular-delivery` — 정기 결제
- `/products/best-seller/search`, `/products/best-review/search`
- `/free-gift-condition/*` — 사은품 조건
- `/additional-discounts/by-product-no` — **추가할인 (수량 구간 할인?)**

### 진열 도메인 (`display-shop-public`, GET 53건)
- `/categories` — 전체 카테고리
- `/categories/{categoryNo}` — 단일
- `/categories/simple-1depth`, `/categories/new-product-categories`
- `/category/product-reviews`
- `/display/sections`, `/display/sections/{sectionNo}` — **진열 섹션 (Aurora 메인 페이지 빌딩 블록)**
- `/display/banners/*`, `/display/popups/*`, `/display/events/*` — 배너·팝업·기획전
- `/display/brands/*` — 브랜드 트리·검색

### 라이브 sitemap.xml 24 URL (Aurora 표준 라우트)
```
/                          /products           /customer-center
/sign-in /sign-up          /no-access          /notice
/find-id /find-password    /member-only        /faq
/my-page                   /adult-certification
/my-page/coupon            /my-page/like
/my-page/accumulation      /my-page/product-review
/my-page/product-inquiry   /my-page/personal-inquiry
/my-page/shipping-address  /orders /claims
/member-modification       /member-withdrawal
```

→ **사용자 직관 검증 1차**: 이 URL 구조는 명백히 **표준 B2C 쇼핑몰 모델**. 견적 마법사·디자인 에디터·옵션 폼·실시간 가격 등 인쇄 견적 도메인 진입점이 0개.

## 인증·운영 메모

- **Server API**: IP 화이트리스트 필수 (현재 IP 211.221.205.141 미등록). 200req 던져 모두 400 → 등록 후 재시도 필요
- **Shop API**: clientId 헤더(camelCase). 정상 200. IP 제한 없음.
- **mall 응답**: 55KB. 정책·등급·은행계좌·회원가입 설정·적립금 정책 등 통합 포함 — 분석가치 매우 높음

## 잠정 가설 (백그라운드 에이전트 결과로 확정)

1. Shopby Aurora Skin은 **회원·체크아웃·주문내역·CS** 영역에서는 검증된 표준 — 직접 활용 가치 있음
2. 그러나 **상품 상세의 옵션 폼·실시간 가격·디자인 에디터**는 Aurora 표준에 없음 — 자체 구축 필수
3. → **사용자 제안한 Hybrid (옵션 B) 또는 자체 빌더 100% (옵션 C)**가 현실적
4. **단, Shopby Server API는 IP 화이트리스트 필요 → 운영 환경 IP 사전 조율 필수**

## Trafic 통계 (이번 라운드)
- 누적 Shopby 요청: 6건, ~63KB
- 누적 전체: 약 30 req / ~620KB / 한도 30%
