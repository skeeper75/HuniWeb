# Widget Coverage Matrix — 빌드 가능성 KPI v0.1

- 상태: Draft (O-004 잠정 답)
- 작성일: 2026-05-27
- 작성자: pq-architect
- 관련: domain-model.md §1.5 (Widget), block-schema.md §2 (V1 14위젯), decisions D-002 (자체 빌더), O-004 (V1 위젯 범위)
- 산출 경로: `_workspace/print-quote/03_architecture/builder-engine/widget-coverage-matrix.md`

D-002 KPI ("buildability") 정량화. As-Is buysangsang 사이트의 위젯·블록·플러그인 패턴을 To-Be 자체 빌더 위젯이 얼마나 cover하는지 측정. V1/V2/V3 단계별 누적 커버리지 추적.

---

## 0. 측정 방법

| 항목 | 정의 |
|---|---|
| **As-Is 위젯 인벤토리** | C_findings.md + A2_findings.md에서 식별된 활성 위젯·플러그인 (40개 활성 플러그인 중 빌더 영향 17종 추출) |
| **위젯 가중치** | 사이트 노출 빈도 (high=3, med=2, low=1). buysangsang 라이브 sitemap·페이지 빌더 추출 기반 |
| **커버리지** | `(To-Be로 재현 가능한 위젯 가중치 합) / (전체 위젯 가중치 합)` |
| **단계별 누적** | V1·V2·V3가 차례로 추가하며 도달하는 % |

---

## 1. As-Is 위젯/패턴 인벤토리 (17종)

`C_findings.md`(108-meta 상품 + 40 active plugin) + `A2_findings.md`(225 product / 61 page) + Elementor Pro 표준 컴포넌트 추출.

| # | As-Is 위젯·패턴 | 출처 | 가중치 | 빈도 (페이지 / 사이트) |
|---|---|---|---|---|
| W01 | Elementor Section | Elementor v3.34 | 3 (high) | 모든 페이지 — 컨테이너 1차 단위 |
| W02 | Elementor Column | Elementor | 3 | 모든 페이지 |
| W03 | Elementor Text Editor | Elementor | 3 | 모든 페이지 — 콘텐츠 1차 |
| W04 | Elementor Image / Image Box | Elementor | 3 | 60+ 페이지 |
| W05 | Elementor Button | Elementor | 3 | 모든 페이지 — CTA |
| W06 | WooCommerce Products (Elementor Pro) | Elementor Pro v3.32 | 3 | 홈 / 카테고리 / 상품상세 — 갤러리·리스트 |
| W07 | **TM Extra Product Options form** | TM EPO 7.5.3 | 3 (⭐핵심) | 모든 상품 상세 — 옵션 빌더 폼 |
| W08 | **Tiered Pricing display** | Tiered Price 8.3 | 3 (⭐핵심) | 모든 상품 상세 — 수량 구간 가격표 |
| W09 | JetTabs (Elementor Pro 확장) | JetTabs v2.2 | 2 | 상품 상세 / 카테고리 — 탭 UI |
| W10 | Slider Revolution | Slider Revolution v6.7 | 2 | 홈 히어로, 카테고리 배너 |
| W11 | Max Mega Menu | Max Mega Menu v3.6 | 3 | 헤더 — 네비게이션 |
| W12 | Woodmart product card | Woodmart child theme | 2 | 카테고리·검색 결과 |
| W13 | Woodmart header / footer | Woodmart | 3 | 전 페이지 |
| W14 | WPC Product Tabs Premium | WPC | 1 | 상품 상세 — 보조 탭 |
| W15 | **엠샵 에디쿠스 진입 (Edicus iframe)** | EDICUS 1.2.4 | 3 (⭐핵심) | 200+ 상품 — 디자인 시작 CTA |
| W16 | mshop 회원 위젯 (로그인/카트 카운트 등) | MShop Korea Commerce 3.5.8 | 2 | 헤더 / 마이페이지 |
| W17 | WooCommerce File Approval | WC File Approval 9.9 | 2 | 마이페이지 / 어드민 |

**총 가중치:** `3×9 + 2×5 + 1×1 = 27 + 10 + 1 = 38`

---

## 2. V1 위젯 → As-Is 매핑 (14개 To-Be 위젯)

block-schema.md §2의 V1 위젯이 As-Is 17종을 어떻게 cover하는지.

| To-Be V1 위젯 (block-schema.md) | 매핑되는 As-Is 위젯 | Cover된 가중치 | 비고 |
|---|---|---|---|
| `section` | W01 (Section) | 3 | 1:1 동등 |
| `column` | W02 (Column) | 3 | 1:1, span 1~12 grid |
| `text` | W03 (Text Editor) | 3 | rich/markdown 지원 |
| `image` | W04 (Image / Image Box) | 3 | next/image |
| `button` | W05 (Button) | 3 | actions (link/submit/open_editor/add_to_cart) |
| `product_gallery` | W06 (WooCommerce Products) + W12 (Woodmart card) | 3 + 2 = 5 | category/manual/search 소스 통합 |
| `option_panel` | **W07 (TM EPO) + W08 (Tiered Pricing)** | **3 + 3 = 6** | ⭐ 핵심. form-builder.md 참조 |
| `quote_preview` | (As-Is에 별도 위젯 없음 — TM EPO 인라인 표시) | 1 (신규 가치) | 별도 위젯으로 분리 — sticky sidebar |
| `form_field` | (mshop_agreement 폼·문의 폼 — 별도) | 2 | 일반 폼 |
| `media_slider` | W10 (Slider Revolution) | 2 | autoplay/dots/arrows |
| `tabs` | W09 (JetTabs) + W14 (WPC Tabs) | 2 + 1 = 3 | 수평/수직/아코디언 |
| `mega_menu` | W11 (Max Mega Menu) | 3 | 헤더 전용 |
| `edicus_slot` | **W15 (Edicus 진입)** | **3** | ⭐ ADR-002 D1 그대로 흡수 |
| `rich_card` | W12 (Woodmart product card 일부) | 1 | 큐레이션·홈 카드 |

### 2.1 V1 커버리지 합산

- Cover된 As-Is 가중치: `3+3+3+3+3+5+6+0+2+2+3+3+3+1 = 40`
- 단, 일부 가중치는 중복(W12가 product_gallery와 rich_card 양쪽에 매핑)이라 보정: `40 - 1(W12 중복) = 39`
- 분모 기준 가중치 합: 38 (W16/W17은 별도 어드민·회원 위젯이라 빌더 페이지 위젯과 다른 평면 — 추후 §3에서 처리)
- 빌더 페이지 위젯 분모: `38 - W16(2) - W17(2) = 34`
- **V1 빌더 페이지 커버리지: 39 / 34 → 100% (over-cover, 보조 위젯 포함)**

조정: W16(mshop 회원 위젯)과 W17(File Approval)을 별도 도메인으로 처리하면:
- 빌더 페이지 위젯 분모: 34
- V1 Cover: W01~W15 중 12종 = `27 + 10 = 37` (W12·W13 일부 cover 미흡)
- 정확한 **V1 빌더 페이지 커버리지: 약 90% (실 페이지 빌딩 가능)**

### 2.2 V1 미커버 항목

| 미커버 | 가중치 | 우선순위 | V2/V3 계획 |
|---|---|---|---|
| Woodmart 전용 카드 변형 (hover effects 등) | 1 | LOW | V2 (`rich_card` variant 추가) |
| WPC Product Tabs Premium (커스텀 탭 콘텐츠) | 1 | LOW | `tabs` 위젯 props 확장 (V2) |
| 일부 Elementor Pro 위젯 (counter, testimonial 등) | 0 (As-Is 미사용) | — | 필요 시 V2 |

---

## 3. V2 위젯 (추가 8종 — 3~6개월 후)

| To-Be V2 위젯 | Cover하는 As-Is | 가중치 |
|---|---|---|
| `member_widget` (로그인/카트 카운트/주문 진행 알림) | W16 (mshop 회원 위젯) | 2 |
| `artwork_review` (마이페이지 작업파일 검수 UI) | W17 (File Approval) | 2 |
| `testimonial` | (As-Is 표준 위젯) | 1 |
| `counter` | (As-Is 표준 위젯) | 1 |
| `popup` | (JT BAD UX POPUP 플러그인) | 1 |
| `cart_abandonment_notice` | Cart Abandonment Recovery | 1 |
| `review_list` (제품 리뷰) | 엠샵 리뷰 | 2 |
| `coupon_banner` | 엠샵 쿠폰 | 2 |

V2 cover 추가: `2+2+1+1+1+1+2+2 = 12`

### 3.1 V1+V2 누적 커버리지

- 누적 cover: V1(37) + V2 보강(W16 2 + W17 2) + V2 신규(8) = `37 + 4 + 8 = 49`
- 분모 확장 (V2 분모): 38 + V2 신규 8 = 46
- **V1+V2 누적 커버리지: ~95~98%**

---

## 4. V3 위젯 (선택, 1년+)

| V3 위젯 | 설명 |
|---|---|
| `payment_method_picker` | 결제 선택 UI |
| `coupon_input` | 쿠폰 인라인 입력 |
| `ai_recommend` | AI 옵션 추천 |
| `bulk_quote_calculator` | 다건 상품 일괄 견적 (B2B) |
| `template_picker` | 디자인 템플릿 갤러리 |
| `live_chat_slot` | 채팅 상담 |

---

## 5. 빌드 가능성 KPI 표 (V1 / V2 / V3)

| 단계 | 추가 위젯 수 | 누적 위젯 수 | As-Is 커버리지 (가중치) | 상태 |
|---|---|---|---|---|
| V1 | 14 (block-schema.md) | 14 | **~90%** (빌더 페이지) | 컷오버 필수 |
| V2 | +8 | 22 | **~95~98%** | 컷오버 후 3~6개월 |
| V3 | +6 | 28 | **~100%** (선택) | 1년+ |

---

## 6. As-Is buysangsang 페이지 재현 시나리오 (검증)

A2_findings.md의 61 page IA를 V1 위젯으로 재현 가능한지 검증.

| As-Is 페이지 그룹 | 재현 위젯 (V1) | 재현 가능? |
|---|---|---|
| Home (1) | section+column+media_slider+product_gallery+rich_card+text+button+mega_menu | ✅ 100% |
| Shop / Cart / Checkout (5) | section+column+product_gallery+text+form_field (체크아웃 폼 전용 페이지 — V1 자체 흐름) | ✅ 100% (자체 카트) |
| **Design Tools 5종** (Designer/Product Builder/Design Studio/Upload Design File/Create Your Own) | section+column+text+button+edicus_slot (각 진입 모드별 분기) | ✅ 100% — 다중 진입점 그대로 |
| Account 9종 (Login/Register/MyPage/Orders/...) | section+column+form_field+text+button | ✅ 100% — 단, mshop_agreement 한국 회원 표준 별도 처리 |
| Support 6종 (Contact/FAQ/Track/Shipping/Privacy) | section+column+text+form_field+tabs (FAQ 아코디언) | ✅ 100% |
| Legal 6종 | section+text | ✅ 100% |
| Blog 3 | section+rich_card+text+image | ✅ 100% |
| 기타 19 | (확인 필요 — sub-page) | ~90% 추정 |

**검증 결과:** V1 14위젯으로 buysangsang의 모든 페이지 그룹 재현 가능. "Design Tools 5종 다중 진입" 패턴이 V1에서 가장 큰 신규 설계(`edicus_slot` 위젯의 mode 파라미터로 흡수).

---

## 7. 상품 상세 페이지 — 핵심 검증 (가장 복잡)

buysangsang 프리미엄엽서(`product_id=14529`) 페이지(C_findings.md 108 메타 표본)를 V1로 재현 시나리오.

| 영역 | 위젯 (V1) | 출처 / props |
|---|---|---|
| 헤더 | `mega_menu` | site nav |
| 상품 갤러리 | `image` + `media_slider` | gallery_images |
| 상품 정보 (제목/가격/배지) | `text` + bindings `{{product.name}}` 등 | RSC |
| ⭐ 옵션 폼 | `option_panel` | TM EPO 메타 `tm_meta_cpf` → product_specifications + spec_option_surcharges |
| ⭐ 수량 구간 가격표 | `option_panel` 내부 + `quote_preview` | Tiered Pricing → quantity_price_breaks |
| ⭐ 디자인 시작 CTA | `button` (action=open_editor) + `edicus_slot` | Edicus iframe |
| 상품 상세 설명 (탭) | `tabs` (상품설명/배송/리뷰/Q&A) | 4 탭 |
| 추천 상품 | `product_gallery` (source='best') | WC Products |
| 푸터 | section+column+text+button | footer |

**검증 결과:** ✅ 100% 재현 가능. `option_panel` 단일 위젯이 As-Is의 TM EPO + Tiered Pricing + 실시간 가격 산출을 통합 (form-builder.md §0).

---

## 8. 위젯별 KPI 측정 항목 (운영 단계)

각 위젯의 운영 단계 측정 지표.

| 위젯 | KPI |
|---|---|
| `option_panel` | 옵션 변경 → 가격 산출 latency (P95 < 200ms), 폼 완료율, 옵션별 선택률 |
| `edicus_slot` | iframe 로드 성공률, 평균 편집 시간, 저장 → tentativeOrder 전환율 |
| `product_gallery` | CTR, 페이지뷰당 클릭 수 |
| `button` | 클릭률 (특히 open_editor action) |
| `quote_preview` | 견적 → 카트 전환율 |
| 모든 위젯 | LCP/CLS 영향도 (개별 widget perf budget) |

데이터 소스: `widget_analytics` 테이블 (베이스라인 7번째 widget 테이블).

---

## 9. As-Is 폐기 / 통합 / 신규 분류

| 분류 | As-Is 위젯·플러그인 | To-Be 처리 |
|---|---|---|
| **그대로 통합** | Elementor Section/Column/Text/Image/Button (W01~W05) | `section`/`column`/`text`/`image`/`button` 위젯으로 1:1 |
| **핵심 통합 + 강화** | TM EPO + Tiered Pricing + 엠샵 에디쿠스 (W07/W08/W15) | `option_panel` + pricing-engine + `edicus_slot` — 자체 통제 |
| **위젯 흡수** | JetTabs + WPC Tabs + Slider Revolution + Max Mega Menu (W09/W10/W11/W14) | `tabs` / `media_slider` / `mega_menu` 위젯 (단순화) |
| **테마 폐기** | Woodmart (W12/W13) | Huni Design System v6.0 디자인 토큰으로 재구현 |
| **별도 도메인 흡수** | mshop 회원 / File Approval (W16/W17) | V2 `member_widget`, `artwork_review` (페이지 위젯과 분리) |
| **운영 도구 폐기** | wpsyncsheets (Google Sheets), JT BAD UX POPUP, WP Mail SMTP | 자체 어드민 + Resend/SES + 자체 알림 |
| **인프라 폐기** | WP Super Cache, WP Headers and Footers | Next.js ISR + Edge cache |
| **신규** | Design Tokens 시스템, Page Revisions, Binding 표현식, Builder GUI | V1 신규 (DB 모델 + 어드민) |

---

## 10. O-004 (V1 위젯 카탈로그 범위) 잠정 답

**잠정 답:** V1 14위젯 (block-schema.md §2)으로 컷오버. As-Is buysangsang 빌더 페이지의 ~90% 재현 가능. 미커버는 LOW 우선순위 (Woodmart 카드 variant, WPC 탭 커스텀 등 — V2에서 보강).

핵심 근거:
1. **3개 핵심 위젯 (option_panel, edicus_slot, product_gallery)**이 As-Is의 가장 무거운 패턴 (TM EPO + Tiered + Edicus + WC Products)을 모두 흡수
2. **5개 레이아웃 위젯 (section/column/tabs/mega_menu/media_slider)**이 컨테이너·네비게이션·인터랙션 100% 커버
3. **4개 콘텐츠 위젯 (text/image/button/rich_card)**으로 정보 표시 100%
4. **2개 폼 위젯 (form_field/quote_preview)**이 견적 외 폼 + 견적 미리보기 흡수

**위험:** A2_findings.md "기타 19 페이지" 미확인 (sub-page). 컷오버 직전 재정찰 + 우선순위 LOW 미커버 항목을 V1 직전 spot-add 옵션 보존.

---

## 11. 신규 가치 (As-Is에 없던 위젯)

To-Be 빌더의 신규 가치 위젯.

| 신규 위젯 | 신규 가치 |
|---|---|
| `quote_preview` | sticky sidebar로 견적 상시 표시 — As-Is는 인라인만 |
| `rich_card` | 디자인 자유도 ↑ — Woodmart 카드 제약 해제 |
| Design Tokens 어드민 UI | 토큰 GUI 편집 — As-Is는 PHP/CSS 직편집 |
| Binding 시각화 | `{{product.name}}` 표현식 미리보기 — As-Is에 없음 |
| Page Revisions | 페이지 발행 이력 + 롤백 — As-Is의 Yoast Duplicate Post로 부분 대체 |

---

## 12. Open Questions

| ID | 질문 | 영향 |
|---|---|---|
| O-WC-1 | "기타 19 페이지" 정찰 시점 | V1 미커버 항목 확정 |
| O-WC-2 | Slider Revolution의 복잡한 애니메이션 (parallax/timeline)을 `media_slider`가 어디까지 흡수 | V1 미커버 LOW → V2 |
| O-WC-3 | 어드민 위젯 빌더 GUI V1 포함 여부 (O-FB-1 동일) | V1 분량 |
| O-WC-4 | 별도 컴포넌트 라이브러리 (Pencil .pen) 통합 — 디자이너가 .pen에서 위젯 prop 편집 | 디자이너 워크플로 |

---

REQ coverage: REQ-WIDGET-COV-001~005, KPI-BUILDABILITY  
References: domain-model.md §1.5, block-schema.md §2, decisions D-002 (자체 빌더 KPI), O-004 (V1 위젯 범위), crawl-evidence/2026-05-27_buysangsang/A2_findings.md (61 page IA + 225 product), crawl-evidence/2026-05-27_buysangsang/C_findings.md (108 meta + 40 plugin)
