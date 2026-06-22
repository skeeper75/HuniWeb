# Phase C — 인증 API 결과 (2026-05-27)

자격증명: lojesus75@gmail.com (administrator, id 222, "신우진")

## 🎯 가격·옵션 엔진의 정체 (찾던 핵심)

| 역할 | 플러그인 | 버전 | meta_data 흔적 |
|------|---------|------|----------|
| **옵션 폼 엔진** | **TM Extra Product Options & Add-Ons** | 7.5.3 | `tm_meta_cpf` = `{mode: builder, price_display_mode: ...}` |
| **수량 구간 할인** | **Tiered Price Table for WooCommerce** | 8.3.0 | `_fixed_price_rules`, `_percentage_price_rules`, `_tiered_price_rules_type` |
| **한국 커머스 마더** | **MShop Korea Commerce (s2)** | 3.5.8 | `_mnks_*`, `_msdp_*`, `_mshop_*` |
| **디자인 에디터** | **엠샵 에디쿠스 (EDICUS)** | 1.2.4 | ⭐ `docs/edicus.man/`의 그 코드와 직결 |
| **결제** | mshop-npay, pgall-for-woocommerce (심플페이) | - | `_naverpay_unavailable` |
| **인쇄 파일 검수** | WooCommerce File Approval | 9.9 | wpsyncsheets_file_design/printing |

→ **우리 빌더가 재현해야 할 옵션·가격 모델 = TM Extra Product Options (builder mode) + Tiered Pricing 룰 엔진**

## 🎨 디자인·빌더 스택

| 역할 | 구성 |
|------|------|
| Theme | **Woodmart Child** (parent: Woodmart, XTemos 상용 v1.1.3) |
| Page Builder | Elementor v3.34.0 + **Elementor Pro v3.32.1** |
| Widget 확장 | JetTabs For Elementor v2.2.11, Slider Revolution v6.7.38, Max Mega Menu v3.6.2 |

→ **우리 빌더의 디자인 시스템 소스 = Woodmart + Elementor Pro 위젯셋**. As-Is widget catalog 추출 시 elementor-pro / jet-tabs / revslider / mega-menu 위젯 우선 식별.

## 🔌 활성 플러그인 전수 (40개)

엠샵 모듈 6종: MShop Korea Commerce / 엠샵 내계정 / 엠샵 리뷰 / 엠샵 SMS / 엠샵 에디쿠스 / 엠샵 쿠폰
한국 결제: 네이버페이 + 심플페이
인쇄 워크플로: WooCommerce File Approval + WP File Download (+Cloud Addon) + WP File Manager
콘텐츠: BetterDocs, Yoast Duplicate Post, Classic Editor, Loco Translate, Safe SVG
운영: WP Super Cache, WP Mail SMTP, JT BAD UX POPUP, Cart Abandonment Recovery, User Switching, Admin Menu Editor Pro, 사용자 역할 편집자, Code Snippets, WP Headers And Footers, WPC Product Tabs Premium, FileBird Pro
빌더: Elementor + Pro + Woodmart Core + JetTabs + Slider Revolution

전체 목록: `C1_plugins.json`

## 💰 통화·세금
- KRW, KR, 소수점 0자리 (₩ 정수 표시)
- calc_taxes=YES (세금 계산 활성)
- 매장 주소: 중구 필동로 80

## 📦 단일 상품 메타 (프리미엄엽서, 108개 메타)

- type=simple, attributes=0, variations=0 ← 표준 WC variations 사용 안 함
- 가격 ₩15,000 (base, 옵션 가산 전)
- 주요 메타 그룹:
  - `_mnks_*` (8개): MShop 재고/카테고리 통합
  - `_msdp_*` (10개+): **MShop Display Pricing** — variable_type=global, display_type=select 등
  - `_mshop_*`, `_msrp_*`: 멤버십·표시가
  - `_tiered_*` + `_fixed_price_rules` + `_percentage_price_rules`: **이 상품은 빈 배열** (구간 할인 미적용) — 다른 상품 표본에서 확인 필요
  - `tm_meta_cpf` = TM 옵션 폼 정의 (mode=builder, price_display_mode=...) ⭐ **다음 라운드 파싱 1순위**
  - `woodmart_*` (10개+): 테마별 표시 옵션
  - `_alg_wc_pvbur_*`: Algoritmika 역할별 노출 제어
  - `_nbo_*`, `_nbpt_*`, `_nbls_*`, `_nbes_*`: 미식별 prefix (추정: 옵션 그룹/배지)
  - `wpsyncsheets_file_design`, `wpsyncsheets_file_printing`: **Google Sheets 동기화**되는 파일 메타

전체 메타: `C3_product_14529.json`

## ⭐ 가장 중요한 연결: 에디쿠스 = 우리 도메인

`docs/edicus.man/`에 있는 Next.js 코드가 **엠샵 에디쿠스 플러그인의 신규 버전(또는 마이그레이션 타깃)**일 가능성. 이 코드베이스를 분석하면 빌더 도메인 모델의 절반 이상이 풀립니다 — pq-architect/pq-researcher의 다음 작업 우선순위.
