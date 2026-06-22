# Phase A Round 2 — buysangsang.com (2026-05-27)

## 1. 상품 카테고리 트리 (65개, `product_cat`)

**숫자 코드 체계** — 한국 인쇄업계 표준 분류 패턴 강력 추정. huni 상품마스터 xlsx와 코드 매핑 필요.

```
accessories (단일)
1000 ─ 1001 1002 1003 1004              (4)
1100 ─ 1101 1102 1103 1104              (4)
1200 ─ 1201 1202 1203                   (3)
1300 ─ 1301 1302 1303 1304              (4)
1400 ─ 1401 1402 1403                   (3)
1500 ─ 1501 1503 ─ 150301               (3, ⭐ 4-level 유일)
1600 ─ 1601 1602 1603                   (3)
1700 ─ 1701 1702 1703 1704              (4)
1800 ─ 1801 1802 1803                   (3)
1900 ─ 1901 1902 1903 1904 1905 1906 1999  (7)
2000 ─ 2001 ~ 2011                      (11 ← 최대)
2100 ─ 2101 ~ 2105                      (5)
```

⚠ 카테고리 slug가 숫자뿐이라 의미가 불명. 이름 매핑 필요 → 다음 라운드 wc/store/v1/products/categories 호출.

## 2. 상품 인벤토리 (225개, `/shop/{id}/{name}/`)

| 영역 | 표본 | 비고 |
|------|------|------|
| 명함·엽서·카드 | 프리미엄엽서, 코팅엽서, 2단/3단 접지카드, 지그재그엽서, 포토카드 | 첫 20건 다수 |
| 스티커 | 반칼 자유형 스티커 (다양 variants) | |
| 책자 | 중철책자, 무선책자 (2026-01-28 신규) | 최신 |
| 굿즈 | 말랑키링, 말랑포카홀더, 말랑네임탁, 말랑여권케이스, 캔버스심플백, 캔버스숄더백 | 굿즈 라인 활성 |
| ⚠ 테스트 | **결제테스트** | 운영 데이터 정리 필요 |

- URL: `/shop/{id}/{korean-name}/` ← 새 사이트도 호환 권장
- lastmod: 2024-05 ~ 2026-01-28 → 활성 운영
- 단일 sitemap 파일에 225건 (50K 이하 분량)

## 3. 사이트 IA (61개 Page, flat)

모두 parent=0 (Page 계층 없음). Elementor 페이지 빌더가 IA를 대신함.

**그룹 분류:**

| 그룹 | 페이지 |
|------|-------|
| Shop/Commerce (5) | Store, Shop, Cart, Checkout, Compare |
| **Design Tools (5⭐)** | **Designer, Product Builder, Design Studio, Upload Design File, Create Your Own** |
| Account (9) | Login, Register, My Account, My Dashboard, My Orders, Lost ID, Password Recovery, Email Authentication, Member Unsubscribe |
| Support (6) | Contact Us, FAQs, Track Order, Shipping, Privacy Policy |
| Wishlist/etc | Wishlist, Compare |
| Legal (6) | Terms, Agreement, Privacy Policy, Personal Information Policy 등 |
| Blog (3) | Blog, Blog-2 |
| 기타 (19) | (확인 필요) |

⭐ **Design Tools가 5개로 분리** — 견적 마법사 단일 화면이 아니라 **도구별 다중 진입점** 구조. 디자이너 자작 vs 파일 업로드 vs 빌더 vs ... 사용자 의도별 분기.
⭐ **Lost ID / Email Authentication / Member Unsubscribe** — 한국형 mshop_agreement 플러그인 흔적, 회원관리 한국 특화.

## 핵심 결정 포인트 (pq-pm decisions.md 후보)

| ID | 항목 | 옵션 |
|----|------|------|
| D1 | 카테고리 코드 체계 유지? | (A) 숫자 코드 + 이름 별도 (B) slug를 영문 의미로 변경 |
| D2 | URL 구조 (`/shop/{id}/{name}/`) | (A) 그대로 유지 (호환성↑) (B) `/products/{slug}` 단순화 |
| D3 | Design Tools 다중 진입? | (A) 5개 유지 (B) 단일 통합 마법사 + 모드 선택 (C) 2~3개 그룹화 |
| D4 | mshop_agreement CPT 이관? | (A) WP 의존 유지 (B) Next.js로 재구현 (C) 헤드리스 WP |
| D5 | "결제테스트" 등 운영 데이터 cleanup | 리뉴얼 전 정리 필요 |

## 트래픽 통계 (현재까지)
- 누적 요청: 6건 (robots + wp-json + sitemap-index + cat sitemap + product sitemap + pages)
- 추정 대역폭: < 80KB
- 한도 사용률: 3% (200req / 20MB 한도)
