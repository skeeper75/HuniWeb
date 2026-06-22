# /wp-json/ 분석 (2026-05-27)

## Site Identity (⚠ 사용자 확인 필요)
- **name**: 후니프린팅
- **description**: 후니프린팅
- **url / home**: https://buysangsang.com

> 사이트 이름이 "후니프린팅"으로 노출됨. buysangsang.com이 후니프린팅의 자체 운영 사이트(또는 동일 운영자) 가능성. 본인 사이트라면 분석 권한·방법이 달라짐.

## Stack
| 영역 | 플러그인/구성 |
|------|---------------|
| Core | WordPress + REST API 공개 |
| Commerce | WooCommerce (wc/v1, wc/v2, wc/v3, wc/store, wc-admin, wc-analytics) |
| Page Builder | Elementor + Elementor Pro + Elementor AI |
| Forms | Contact Form 7 |
| Cache | WP Super Cache (응답 캐싱됨 → 우리 요청 부하 최소) |
| Connectivity | Jetpack |
| Docs | BetterDocs |
| Media | FileBird (폴더 관리) |
| Slider | Slider Revolution |
| Tabs/Dynamic | JetTabs (JetEngine 계열) |
| Cart Recovery | WCAR (WooCommerce Abandoned Recovery) |
| UX Survey | NPS Survey, JT Bad UX Popup |
| Code | Code Snippets |
| Shop CPT | `mshop_agreement` (한국형 mshop 플러그인 추정) |
| MCP | "mcp" 네임스페이스 (Claude/MCP 통합?) |

## 공개 REST 접근성
인증 없이 `wc/store/v1/products` 등 호출 가능 → **Phase A로 카탈로그·옵션·가격 전수 확보 가능 (Playwright 거의 불필요)**

## 발견 매트릭스
| 항목 | 값 | 의미 |
|------|----|----|
| WP REST 활성 | YES | Phase A 진행 가능 |
| Store API 공개 | YES | 옵션·가격 인증 없이 추출 |
| Elementor Pro | YES | 견적 폼이 Elementor Pro Form일 가능성 ↑ |
| CF7 | YES | 일반 문의 폼은 CF7 |
| 캐시 플러그인 | YES | 동일 URL 재호출 시 origin 무부하 |
