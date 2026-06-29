# 크로스 플랫폼 위젯 시스템 비교 보고서

> 생성일: 2026-03-31
> 분석 대상: RedPrinting vs WowPress
> 목적: Huni 플랫폼 위젯 시스템 설계를 위한 기술 격차 분석

---

## 요약

RedPrinting은 Vue 3 + Pinia + Shadow DOM 기반의 정교한 SPA 위젯 시스템을 운영하며, 실시간 가격 계산 API, 옵션 캐스케이드 엔진, Edicus 에디터 연동까지 갖추고 있다. 반면 WowPress는 jQuery 3.4.1 기반의 전통적 서버 렌더링 방식으로, 전용 위젯 API나 에디터 연동이 존재하지 않는다.

---

## D1: 옵션 캐스케이드 (Option Cascade)

| 항목 | RedPrinting | WowPress |
|------|-------------|----------|
| **아키텍처** | 클라이언트 SPA (Vue 3 reactive) | 서버 렌더링 (form POST) |
| **옵션 로딩** | `fetchProductInfo` API로 16개 데이터셋 일괄 로드 | 서버에서 HTML로 사전 렌더링 |
| **캐스케이드 흐름** | 용지 → 규격 → 도수 → 수량 → 후가공 (PCS) | 없음 — 정적 폼 필드 |
| **상태 관리** | Pinia 5개 스토어 (config/product/order/exterior/acc-order) | 없음 (jQuery DOM 직접 조작) |
| **비활성화 규칙** | `pdt_disable_pcs_info` 배열 — 자재별 후가공 제외 규칙 (PRBKORD: 30+ 규칙) | 없음 |
| **제품 유형별 분기** | `item_gbn` 기반 3종: vDigital_item, book2025_item | 단일 폼 구조 |
| **자재 코드 체계** | 자재코드(BV300g 등) → 작업사이즈 자동 산출 (CUT→WRK +10mm 도련) | 텍스트 기반 옵션 |

### 근거 데이터

**RedPrinting GSTGMIC (마이크 네임택):**
- 1개 자재(BV300g), 4개 규격, 11개 PCS 항목
- 옵션 변경 시 `useOrderStore` reactive 갱신 → 가격 자동 재계산

**RedPrinting PRBKORD (트윈링 책자):**
- 표지 2개 + 내지 4개 자재, cover/inner 분리 가격 구조
- `pdt_disable_pcs_info`에 30개 이상의 자재-후가공 비활성화 규칙

**WowPress:**
- `/product` 경로에 form POST 방식, 서버에서 완성된 HTML 반환
- 옵션 간 의존 관계를 처리하는 클라이언트 로직 미발견

---

## D2: 가격 계산 API (Pricing API)

| 항목 | RedPrinting | WowPress |
|------|-------------|----------|
| **실시간 가격 API** | POST `/ko/product_price/get_ajax_price_vTmpl` | 없음 |
| **가격 엔진 종류** | 3종: `tiered_price`, `vTmpl_price`, `book2025_price` | 확인 불가 (서버 내부) |
| **요청 구조** | `{dataJson: {ORD_INFO, PCS_INFO, price_gbn, mb_cust_cod}}` | N/A |
| **응답 구조** | 공정별 가격 배열 `[{PCS_CD, PRICE, PRICE_VAT, PRICE_MALL}]` | N/A |
| **가격 분해** | 공급가/부가세/청구금액 3단 분리 + 공정별 원가 | 총액만 표시 (추정) |
| **고객 등급 가격** | `mb_cust_cod`로 회원/비회원 차등 | 확인 불가 |
| **배송비** | `result_sum.book_info.DLVR_AMT` (3,500원) 포함 | 별도 페이지 |

### 근거 데이터

**RedPrinting 가격 분해 예시 (PRBKORD):**
- `PCS_ETC_PRICE` / `PCS_PRI_PRICE` 분리 — 후가공 vs 본인쇄 원가 투명 공개
- 표지/내지 각각 별도 가격 계산 후 합산

**RedPrinting 가격 분해 예시 (GSTGMIC):**
- 기본가 6,000원, `tiered_price` 엔진으로 수량 구간별 단가 계산

**RedPrinting 가격 분해 예시 (ACNTHAP):**
- `vTmpl_price` 엔진, 기본가 3,300원, `option_info`로 뒷면 자재 선택 가능

**WowPress:**
- `priceTexts=[]` — 제품 목록 페이지에서 가격 텍스트 미노출
- 가격 관련 API 호출 미발견 (analytics/tracking 호출만 존재)

---

## D3: 에디터 연동 (Editor Integration)

| 항목 | RedPrinting | WowPress |
|------|-------------|----------|
| **에디터** | Edicus (makers.redprinting.net) | 없음 |
| **연동 방식** | KOI passive mode (`division: "red_widget"`) | N/A |
| **인증 흐름** | 4단계: POST /token → Firebase JWT → getProductInfo → /v1/templates | N/A |
| **코드 매핑** | RP 제품코드 → Edicus 코드 (예: GSTGMIC → PA05-PHSTSQP) | N/A |
| **UI 진입점** | Shadow DOM 내 "에디터" 탭 → "편집하기" 버튼 | N/A |
| **SDK** | RedEditorSDK (250KB) — 45개 메서드, 23개 DDP 명령 | N/A |
| **iframe 통신** | EditorBridge (postMessage 기반, 198줄) | N/A |
| **디자인 파일** | 파일 업로드 또는 에디터 내 직접 디자인 | 파일 업로드만 (추정) |

### 근거 데이터

**RedPrinting Editor 흐름:**
1. `POST /token` — 세션 쿠키 기반 인증
2. `POST /editor target=issueUserToken` — Firebase JWT 발급
3. `POST /editor target=getProductInfo` — RP→Edicus 코드 매핑
4. `GET /v1/templates/{edicusCode}` — 에디터 템플릿 로드

**RedPrinting KOI 설정:**
- `useFullyFunctionalUI: false` — 호스트 위젯이 UI 제어권 유지
- `division: "red_widget"` — passive mode 식별자

**WowPress:**
- 6개 페이지 프로브 전체에서 `hasEditor: false`
- 에디터 관련 스크립트/iframe 미발견

---

## D4: UX 흐름 (UX Flow)

| 항목 | RedPrinting | WowPress |
|------|-------------|----------|
| **위젯 격리** | Shadow DOM (`#redWidgetSdk`) | 없음 — 호스트 DOM 직접 |
| **페이지 전환** | SPA — 옵션 변경 시 페이지 리로드 없음 | 전통적 MPA — form POST로 페이지 이동 |
| **옵션 변경 반응** | 즉각적 reactive 업데이트 (Vue 3 reactivity) | 서버 왕복 필요 (추정) |
| **가격 업데이트** | 옵션 변경 즉시 비동기 가격 재계산 | 주문 확정 시점에만 (추정) |
| **제품 유형별 UI** | 3개 메인 컴포넌트: Apparel/Book/Acc + 25개 후가공 | 단일 폼 구조 |
| **다국어** | ko/en 280개 번역 사전 내장 | 한국어 단일 |
| **에러 추적** | TanStack Query 기반 재시도 + Sentry | Sentry (vue/10.22.0 번들, jQuery 사이트에서) |
| **CS 채팅** | 미확인 | Firebase/Firestore 기반 CS 채팅 |

### 근거 데이터

**RedPrinting 컴포넌트 구조:**
- 38개 Vue 컴포넌트 (3 메인 + 10 서브 + 25 후가공)
- Shadow DOM으로 호스트 페이지 CSS/JS 충돌 완전 차단

**WowPress 스크립트 스택:**
- jQuery 3.4.1, bxslider, lightslider, moment, jquery.form, jquery.dataTree
- `common.js`, `wowcommon.js` — 범용 유틸리티
- Firebase SDK — CS 티켓 전용 (제품/주문 로직 아님)

---

## D5: 기술 스택 (Technical Stack)

| 항목 | RedPrinting | WowPress |
|------|-------------|----------|
| **프레임워크** | Vue 3.5.21 Runtime | jQuery 3.4.1 |
| **상태 관리** | Pinia 2.x (5 stores) | 없음 |
| **데이터 페칭** | TanStack Query | jQuery.ajax / form POST |
| **보안** | DOMPurify (XSS 방지) | 미확인 |
| **에러 추적** | Sentry (EditorSDK 내) | Sentry (vue/10.22.0) |
| **번들 크기** | widget.js 450KB + EditorSDK 250KB | 개별 스크립트 다수 |
| **빌드 도구** | Webpack/Vite (minified 단일 번들) | 미확인 (비번들 개별 로드) |
| **API 통신** | REST (6 Widget + 8 Editor 엔드포인트) | form POST + analytics only |
| **실시간 기능** | 없음 (폴링 기반 가격) | Firebase Realtime (CS 전용) |
| **CDN/호스팅** | S3 파일 관리 (`fetchS3FileInfo`) | Cafe24 서브도메인 (기본 호스팅 페이지) |

### 근거 데이터

**RedPrinting widget.js 구조 (역공학 결과):**
- Vendor: Vue 3 (4,700줄) + DOM Runtime (3,000줄) + Pinia (1,400줄) + TanStack/DOMPurify (2,604줄)
- Application: API Layer (1,507줄) + SDK Class (1,392줄) + Components (2,506줄)

**WowPress 기술 스택:**
- cafe24 서브도메인에서 기본 호스팅 페이지 확인 — 자체 인프라 미구축
- YouTube/GA 등 분석 스크립트가 API 호출의 대부분

---

## Huni 전략 권고사항

### 즉시 도입 (Phase 1)
1. **옵션 캐스케이드 API** — RedPrinting 수준의 reactive 옵션 체계 구축
2. **실시간 가격 계산 API** — 공정별 원가 투명 분해 지원

### 중기 구축 (Phase 2)
3. **Shadow DOM 위젯 격리** — 호스트 사이트 독립적 위젯 배포
4. **에디터 연동** — Edicus 또는 대안 에디터 KOI 패턴 적용

### 장기 차별화 (Phase 3)
5. **가격 엔진 통합** — tiered/vTmpl/book 3종 엔진을 통합 인터페이스로
6. **다국어/다테마** — WowPress에 없는 다국어 + 테마 시스템으로 차별화

---

*본 보고서는 RedPrinting 3개 제품(GSTGMIC, PRBKORD, ACNTHAP) 캡처 데이터, WowPress 6개 페이지 프로브, 역공학 최종 보고서, Edicus 에디터 API 분석을 기반으로 작성되었습니다.*
