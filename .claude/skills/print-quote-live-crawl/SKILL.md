---
name: print-quote-live-crawl
description: >
  buysangsang.com(WordPress + WooCommerce + Elementor 기반) 및 유사 인쇄견적 사이트를 저트래픽·읽기전용 모드로 안전하게 분석한다.
  sitemap·wp-json·wc REST 등 표준 진입점 우선 활용으로 페이지 렌더링 트래픽을 최소화하고, 화면 캡처가 꼭 필요한 핵심 화면만 Playwright로 보조 수집.
  '경쟁사 크롤', 'buysangsang 분석', '라이브 사이트 캡처', 'wordpress 분석', 'woocommerce 분석', 'elementor 분석', 'print quote crawl' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Bash, WebFetch, mcp__claude-in-chrome__*
metadata:
  version: "1.1.0"
  category: "domain"
  status: "active"
  updated: "2026-05-27"
  tags: "print, quote, wordpress, woocommerce, elementor, playwright, low-traffic, read-only"
---

# Print Quote — Live Crawl Skill (WP+Woo+Elementor 특화)

## 목적

경쟁 인쇄견적 사이트(buysangsang 등 **WordPress + WooCommerce + Elementor 스택**)의 IA·상품·견적 마법사·가격 산출 패턴을 **상대 서비스에 영향을 주지 않는 범위**에서 수집한다. 주문·결제·계정 변경은 절대 수행하지 않는다.

## 안전 규칙 (HARD)

| # | 규칙 | 위반 시 결과 |
|---|------|----------|
| S1 | **읽기·관찰만**. 폼 제출(견적 신청·주문·문의·회원가입·로그인 외) 금지 | 즉시 중단, 사용자 보고 |
| S2 | **계정 자격증명은 사용자 제공 환경변수만**. `BS_USER`/`BS_PASS`, 코드·로그에 평문 금지 | 작업 거부 |
| S3 | **동시 요청 1**, 페이지 간 **3~5초 sleep**, 시간당 총 요청 ≤ 200 | 토큰 절감 + 상대 부하 0 |
| S4 | **robots.txt 준수** — `Disallow` 경로 절대 접근 금지 | 정책 위반 |
| S5 | **이미지·폰트·광고·third-party 스크립트 차단** (Playwright route block). 이미지는 화면 캡처용 1회만 로드 | 트래픽 90%+ 절감 |
| S6 | **모든 GET 응답을 로컬 캐시** — 같은 URL 24h 내 재요청 금지. `If-Modified-Since`로 조건부 GET | 재실행 시 0 트래픽 |
| S7 | **로그인은 세션당 1회**. 쿠키 저장 후 후속은 쿠키 재사용 | 로그인 시도 최소화 |
| S8 | **결제 위젯·PG 게이트웨이 페이지 진입 금지** (`/wc-api/`, `/checkout/order-pay/`, PG 도메인) | 시스템 부하 + 법적 위험 |
| S9 | **추적 픽셀·analytics 호출 차단** (GA, GTM, FB pixel, Meta CAPI 등) — 상대측 비용 발생 가능 | block list 강제 |
| S10 | **민감정보 sanitize 후 저장** — 캡처 전 개인정보(이름·전화·주소·결제수단) 마스킹 | 캡처 보류 |

## 도구 선택 (우선순위)

1. **`WebFetch`** — `robots.txt`, `sitemap.xml`, `wp-json` REST 등 **JSON/XML/HTML 텍스트 응답** 우선. 가장 가볍고 안전.
2. **`mcp__claude-in-chrome__*`** — 동적 렌더링이 필수인 화면(견적 마법사 단계 전환 등)에 한해 사용. 가용 시 사용자 세션 활용 가능.
3. **`Playwright via Bash`** — chrome MCP 미가용 시. 아래 "Playwright 안전 프로필" 필수 적용.
4. **사용자 제공 스크린샷** — 위 3개로 접근 차단된 화면(로그인 후 마이페이지 등)은 사용자에게 캡처 요청.

## 표준 진입점 인벤토리 (WP+Woo+Elementor)

순서대로 시도하며, **각 단계 산출물을 저장하여 다음 단계의 입력으로 재사용**:

### Phase A — 무비용 정찰 (WebFetch만, 트래픽 < 50KB)

| 순서 | 경로 | 목적 | 도구 |
|------|------|------|------|
| 1 | `/robots.txt` | 크롤 허용 영역·sitemap 위치 확인 | WebFetch |
| 2 | `/sitemap.xml` 또는 `/sitemap_index.xml` (Yoast/RankMath/All in One SEO) | **전체 URL 인벤토리 확보** — 페이지 전수 크롤 회피 | WebFetch |
| 3 | `/wp-json/` | WP REST API 활성 여부, 네임스페이스 목록 | WebFetch |
| 4 | `/wp-json/wp/v2/pages?per_page=100&_fields=id,slug,link,title,parent,menu_order` | 사이트 IA 추출 (DB 한 번 조회로 끝) | WebFetch |
| 5 | `/wp-json/wp/v2/categories?per_page=100&_fields=id,slug,name,parent,count` | 카테고리 트리 | WebFetch |
| 6 | `/wp-json/wp/v2/menus` 또는 `/wp-json/menus/v1/menus` (플러그인 따라) | 네비게이션 메뉴 | WebFetch |
| 7 | `/wp-json/wc/store/v1/products?per_page=100&_fields=id,name,slug,permalink,categories,prices,attributes` | **WooCommerce Store API (공개, 인증 불필요)** — 상품 목록·가격·옵션 한 번에 | WebFetch |
| 8 | `/wp-json/wc/store/v1/products/categories` | 상품 카테고리 트리 | WebFetch |
| 9 | `/wp-json/wc/store/v1/products/attributes` | **옵션 속성(용지·사이즈·후가공 등) 표준 정의** | WebFetch |
| 10 | `/wp-json/wc/store/v1/products/{id}` (샘플 5~10건만) | 상품 상세 속성·variations·meta | WebFetch |

> Phase A만으로 **상품 카탈로그·옵션 모델·IA의 80%+** 가 확보됩니다. Playwright는 그 후에 갭만 메우면 됩니다.

### Phase B — Elementor 페이지 구조 (필요 시만)

Elementor는 `_elementor_data` 메타에 모든 위젯 구성을 JSON으로 저장합니다.

| 경로 | 비고 |
|------|------|
| `/wp-json/wp/v2/pages/{id}?_fields=meta._elementor_data` | 인증 필요할 수 있음. 안 되면 HTML 1회 가져와 `data-elementor-type`/`data-widget_type` 파싱 |
| Page HTML (1회만) | `body[class*="elementor-page"]`, `.elementor-widget-form`(Pro 폼) 식별 |

### Phase C — 견적 마법사 동적 캡처 (chrome MCP / Playwright)

이 단계만 실제 렌더링 트래픽이 발생. **3~5개 핵심 상품만** 대상.

캡처 체크리스트 (상품당):
- [ ] 상품 상세 진입 화면 (`?wc-ajax=add_to_cart` 호출 X — 옵션 변경만)
- [ ] 옵션 선택 단계별 가격 갱신 — Network 탭에서 `?wc-ajax=`, `admin-ajax.php?action=` 호출만 캡처
- [ ] **장바구니 진입 X** (실제 cart에 담기 회피). 옵션·가격 변동 패턴이 충분히 파악되면 종료
- [ ] Elementor Pro Form, CF7, WPForms 중 무엇으로 견적 입력 받는지 식별

### Phase D — 로그인 후 영역 (선택, 1회만)

로그인 1회 → 쿠키 저장 → 마이페이지 IA 캡처 → 로그아웃. 주문 내역·결제 정보는 캡처에서 마스킹.

## Playwright 안전 프로필

`_workspace/print-quote/_tools/crawl.ts` 자동 생성 시 다음 옵션 강제:

```ts
// 강제 적용 옵션 (스킬이 생성하는 모든 Playwright 스크립트에 포함)
const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({
  userAgent: 'HuniWeb-Research/1.0 (read-only competitive analysis; contact: <user-email>)',
  serviceWorkers: 'block',
  // 캐시 강제 사용
  bypassCSP: false,
});
const page = await context.newPage();

// 리소스 차단 — 이미지/폰트/미디어/광고/analytics 즉시 abort
await page.route('**/*', (route) => {
  const req = route.request();
  const type = req.resourceType();
  const url = req.url();
  if (['image', 'font', 'media', 'stylesheet'].includes(type)) return route.abort();
  if (/google-analytics|googletagmanager|facebook\.net|doubleclick|hotjar|naver\.com\/wcs|kakao\.com\/track/.test(url)) return route.abort();
  return route.continue();
});

// 동시성 1, 페이지 간 3~5초
await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
await page.waitForTimeout(3000 + Math.random() * 2000);

// 캡처는 한 페이지에 1회만, 이미지는 따로 page.screenshot() 호출 시점에만 로딩 허용
```

**1회 이미지 캡처가 필요할 때**: 별도 context로 image-allowed 모드 진입 → 캡처 → 즉시 종료.

## 캐시 시스템

`_workspace/print-quote/_cache/{domain}/`에 모든 응답을 SHA1(url)로 저장:

```
_cache/buysangsang.com/
├── _index.json               URL → {sha1, timestamp, etag, last-modified, status}
├── ab12cd34.json             응답 본문 (JSON/HTML)
└── ab12cd34.headers.json     응답 헤더
```

재실행 시:
1. URL의 sha1 키 조회
2. `If-Modified-Since` / `If-None-Match` 헤더로 조건부 GET
3. 304 응답이면 캐시 본문 사용 (대역폭 0)
4. 200 응답이면 캐시 갱신
5. 24h 이내 동일 URL은 헤더 체크 없이 캐시 직접 사용

## 산출물 구조

```
_workspace/print-quote/01_research/crawl-evidence/
└── 2026-05-27_buysangsang/
    ├── manifest.json               캡처 인벤토리 + 트래픽 통계
    ├── traffic-budget.md           이 세션의 총 요청·바이트 + 절감율
    ├── A_robots.txt
    ├── A_sitemap-urls.json         전체 URL 인벤토리
    ├── A_wp-routes.json            /wp-json/ 네임스페이스
    ├── A_pages-tree.json           페이지 IA 트리
    ├── A_categories-tree.json
    ├── A_wc-products.json          Store API 상품 전수 (slim)
    ├── A_wc-attributes.json        옵션 속성 정의
    ├── A_wc-product-detail-{slug}.json (5~10건)
    ├── B_elementor-{page-slug}.json
    ├── C_quote_{product-slug}_step{n}.png  필수 화면만
    ├── C_quote_{product-slug}_network.har  옵션 변경 시 호출만 필터
    └── D_mypage-ia.png             (선택)
```

`manifest.json` 필수 필드: 각 캡처의 `purpose`(목적), `traffic_bytes`, `cache_status`(hit/miss/304).

## 워크플로우 (오케스트레이터 호출 시)

1. 사용자 자격증명 환경변수 확인 — 없으면 Phase A·B·C(비로그인) 만 수행
2. **Phase A 전체 실행** (WebFetch only, 무비용)
3. Phase A 결과를 `_workspace/print-quote/01_research/crawl-evidence/{date}/`에 저장
4. pq-researcher에게 "Phase A 산출물로 충분히 분석 가능한가" 확인 요청
5. 필요 시에만 Phase B/C 진행. C는 **3~5개 핵심 상품 한정**
6. D는 사용자 명시 요청 시만
7. `traffic-budget.md` 작성: 총 요청 수, 다운로드 바이트, 캐시 hit율, 절감 추정

## 트래픽 가드 (HARD)

세션 시작 시 한도 설정:

```
MAX_REQUESTS_TOTAL=200
MAX_BYTES_TOTAL=20MB
MAX_REQUESTS_PER_MINUTE=20
```

한도 초과 시 즉시 중단 + 사용자 보고 ("Phase A로 X% 완료, 추가 진행 승인 필요").

## 트러블슈팅

| 증상 | 조치 |
|------|------|
| `/wp-json/` 비활성 (Disable REST API 플러그인) | sitemap.xml만으로 IA 추정 + Phase C 비중 증가 |
| `/wp-json/wc/store/v1/` 403 | 비로그인 차단. `/wp-json/wc/v3/`은 인증 필요 → Phase C로 우회 |
| robots.txt가 모두 Disallow | 사용자에게 보고하고 분석 중단. 문서·리버싱 자료만 활용 |
| Cloudflare 봇 차단 | UA 변경 금지(정직성 우선). 사용자에게 보고 후 수동 캡처 요청 |
| 로그인 실패 | 자격증명 재확인 1회, 캡차면 즉시 중단 → 비로그인 영역만 진행 |
| 가격 갱신 호출 누락 | DOM mutation observer로 가격 표시 영역 추적 (네트워크 의존 ↓) |

## 산출 후 작업

pq-researcher에 반환:
- 캡처 디렉토리 경로
- `traffic-budget.md` 요약 (총 요청·바이트·절감율)
- 누락·실패 항목 목록
- 즉시 분석 가치가 있는 발견 3건 (예: "옵션 속성 ID와 attribute label 매핑", "가격 갱신 호출의 ajax action name", "견적 폼 플러그인 식별")
- Phase B/C 추가 필요 여부 권고
