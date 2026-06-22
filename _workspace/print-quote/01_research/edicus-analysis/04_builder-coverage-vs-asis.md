# 04. Coverage Map — `edicus.man` vs buysangsang As-Is

생성일: 2026-05-27
As-Is 출처: `_workspace/print-quote/01_research/crawl-evidence/2026-05-27_buysangsang/C_findings.md`

범례: ✅ 완전 커버 / 🟡 부분 커버 (가공 필요) / ❌ 미커버 (별도 구현 필요)

---

## A. 핵심 가격·옵션 엔진

| As-Is 패턴 (buysangsang plugin) | edicus.man 상태 | 비고 |
|--------------------------------|------------------|------|
| **TM Extra Product Options & Add-Ons** 7.5.3 — `tm_meta_cpf` (mode=builder) 옵션 폼 빌더 | ❌ | 옵션 폼 빌더/렌더러 자체가 없음. `VdpField` (text/number/date)만 존재하나 이는 VDP 가변 데이터용. As-Is의 "select/radio/checkbox/이미지 셀렉터/구간 슬라이더/페이지 카운터/색상칩" 같은 옵션 위젯 카탈로그는 미구현 |
| **Tiered Price Table for WooCommerce** 8.3.0 — `_fixed_price_rules`, `_percentage_price_rules`, `_tiered_price_rules_type` 수량 구간 할인 | ❌ | 가격 계산 로직이 전혀 없음. 가격 모델(`decimal price` README 언급) 외 룰 엔진/구간 테이블/할인 적용기 부재 |
| **MShop Display Pricing** — `variable_type=global`, `display_type=select` 멤버십·표시가 | ❌ | 멤버십/표시가 분리 모델 없음 |
| **MShop Korea Commerce** 3.5.8 — `_mnks_*`, `_msdp_*`, `_mshop_*` 메타 묶음 | ❌ | 한국 커머스 메타 모델 없음 |

→ **가격·옵션 엔진 = 0% 커버**. As-Is의 두 메가 플러그인(TM EPO + Tiered Pricing)이 담당하는 영역은 To-Be에서 완전 신규 구현이 필요하다.

## B. 디자인 빌더 (페이지·캔버스)

| As-Is 패턴 | edicus.man 상태 | 비고 |
|-----------|------------------|------|
| **엠샵 에디쿠스 (EDICUS) 1.2.4** WP 플러그인 — Edicus SDK iframe 통합 | ✅ | **이것이 직접 대응되는 영역**. `EdicusClient` + `useEdicus` + `EdicusEditor` + `HuniEditorSDK` 전체 통합 스택이 Next.js 15/React 19에 완성된 상태 |
| Edicus 프로젝트 라이프사이클 (editing → ordering → ordered) | ✅ | `ProjectStatus` 타입 + `OrderPanel` 상태 머신 UI |
| 잠정주문/확정주문/취소 워크플로우 | ✅ | `useOrder` 훅 + API route + `OrderStatus` |
| VDP (가변 데이터 인쇄) | 🟡 | `VdpEditor` 컴포넌트는 있으나 `VdpField`는 text/number/date 3종만. As-Is의 명함 대량 개인화 수준까지는 단순. `docs/red-editor-sdk-analysis.md`가 SDK 측 VDP API(`getEntities`, `getNoStocksInfo`, `uniform-select`/`individual-select` 엔티티)를 문서화하고 있어 보강 가능 |
| 모바일/PC/Passive 편집 모드 | ✅ | `MobileEditor`, `PCPassiveEditor`, `EdicusEditor` 3종 + `passiveMode` 플래그 + 키보드 단축키 |
| 파트너별 브랜딩 (CSS, 색상, 로고) | ✅ | `CSS_PRESETS` (hunip/dark/red), `private_css` iframe 주입, `getCssForPartner()` |

→ **빌더 자체(에디터 캔버스/페이지/블록)는 외부 위임 모델이라 코드로 노출되지 않으나, 통합 셸은 ✅ 완비.**

## C. Elementor / Woodmart 위젯 시스템

| As-Is 패턴 | edicus.man 상태 | 비고 |
|-----------|------------------|------|
| Woodmart Child + Woodmart 부모 테마 (상용 v1.1.3) | ❌ | 테마/위젯 인프라 자체가 무관함. Tailwind + 자체 컴포넌트(`HuniButton`/`HuniInput`/`HuniSelect`/`HuniRadio`/`HuniCheckbox`/`HuniBadge`/`HuniCard`/`HuniTab`)로 처음부터 구성 |
| Elementor v3.34 + Elementor Pro v3.32 페이지 빌더 | ❌ | 페이지 빌더 위젯 시스템 없음 |
| JetTabs / Slider Revolution / Max Mega Menu | ❌ | 모두 부재 |
| WPC Product Tabs Premium (상품 상세 탭) | ❌ | 별도 |

→ **마케팅 사이트(랜딩/홈)의 페이지 빌더 부분은 0% 커버**. As-Is가 위젯 카탈로그 + Elementor로 페이지를 짠 부분은 To-Be에서 자체 디자인 시스템(Tailwind + Huni UI)으로 다시 짜야 함.

## D. 한국 결제 / 인쇄 워크플로

| As-Is 패턴 | edicus.man 상태 | 비고 |
|-----------|------------------|------|
| mshop-npay, pgall-for-woocommerce (네이버페이/심플페이) | ❌ | PG 통합 없음 |
| **WooCommerce File Approval** 9.9 — 인쇄 파일 검수 | ❌ | 파일 승인 워크플로 없음 (Edicus 백엔드가 자체 처리한다고 가정한 듯) |
| WP File Download / WP File Manager (디자인 파일 관리) | ❌ | 별도 |
| `wpsyncsheets_file_design/printing` Google Sheets 동기화 | ❌ | 별도 |
| `_naverpay_unavailable` 등 결제수단 메타 | ❌ | |

## E. 유저/계정/회원

| As-Is 패턴 | edicus.man 상태 | 비고 |
|-----------|------------------|------|
| 엠샵 내계정 / 멤버십 / 역할별 노출 (`_alg_wc_pvbur_*`) | 🟡 | Firebase Auth + admin 체크는 있으나 등급제/역할별 가격 노출은 미구현 |
| 엠샵 리뷰 / 엠샵 SMS / 엠샵 쿠폰 | 🟡 | admin 메뉴 셸(`/admin/sms`, `/admin/billing`)은 존재. 실 구현은 미확인 (셸/플레이스홀더 가능성 높음) |

## F. 운영/마케팅 보조

| As-Is | edicus.man |
|-------|------------|
| WP Super Cache | ❌ Next.js ISR로 대체 가능 |
| WP Mail SMTP | ❌ |
| Cart Abandonment Recovery | ❌ |
| User Switching / Admin Menu Editor Pro | ❌ |
| BetterDocs / Yoast Duplicate Post / Loco Translate | ❌ |
| Code Snippets / WP Headers And Footers | ❌ Next.js layout으로 대체 |

---

## 종합 커버리지 매트릭스

| 빌더 도메인 영역 | 커버 | 추정치 |
|------------------|------|--------|
| Edicus SDK 통합 / 프로젝트 라이프사이클 / 주문 워크플로 | ✅ | **95%** |
| 파트너 브랜딩 / CSS 토큰 / 모바일·PC·Passive 모드 | ✅ | **90%** |
| Huni Design System UI (8개 컴포넌트) | ✅ | **80%** (확장 필요) |
| 관리자 셸 (14페이지 라우트) | 🟡 | **40%** (라우트만, 실 비즈니스 로직 부족 가능성) |
| VDP 가변 데이터 | 🟡 | **30%** (text/number/date만) |
| Firebase Auth | ✅ | **70%** |
| **옵션 폼 빌더 (TM EPO 대체)** | ❌ | **0%** |
| **가격 엔진 / 구간 할인 (Tiered Pricing 대체)** | ❌ | **0%** |
| **멤버십 가격 표시 (MShop Display Pricing 대체)** | ❌ | **0%** |
| **페이지 빌더 / 위젯 카탈로그 (Elementor 대체)** | ❌ | **0%** |
| **인쇄 파일 검수 / 승인 (File Approval 대체)** | ❌ | **0%** |
| **한국 PG 결제 통합** | ❌ | **0%** |
| **쿠폰 / 리뷰 / SMS 발송 / 적립금** | ❌ | **5%** (관리 셸만) |

**총평**: `edicus.man`은 As-Is의 "디자인 편집기 + 주문 워크플로" 슬라이스에서는 90%+ 커버하지만, 그 외 **커머스 본체(가격·옵션·결제·검수·멤버십)는 0%**. 즉 "빌더 절반"이 아니라 "**Edicus 통합 슬라이스 한 칸**"만 풀려 있는 상태이며, 가장 비싸고 어려운 영역(옵션폼/가격엔진)은 여전히 신규 설계가 필요.
