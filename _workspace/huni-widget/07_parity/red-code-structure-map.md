# Red 위젯 코드 구조 전수 지도 (S0 종합 인덱스)

**작성:** 2026-06-03 | **목적:** RedPrinting 위젯의 역공학 소스 코드(deobfuscated)를 권위 명세로 삼아 구조를 전수 추출. 신규 구현(04_build)과의 코드 레벨 구조 정합(S1) 토대.
**정합 기준:** 책임·로직·분기 재현 동등 (라인 답습 아님). React vs Vue 구현차는 허용, 책임·분기 커버리지가 같으면 정합.

## 모듈별 지도 (3종)

| 모듈 | 파일 | 담당 | 산출 |
|------|------|------|------|
| API 계층 | `deob_05_app_api.js` (54KB) | 엔드포인트·reqBody·트랜스포트 | [red-code-map-05-api.md](red-code-map-05-api.md) |
| 위젯 SDK | `deob_06_app_widget_sdk.js` (54KB) | 라이프사이클·5스토어·캐스케이드엔진·브리지 | [red-code-map-06-widget-sdk.md](red-code-map-06-widget-sdk.md) |
| 컴포넌트 | `deob_07_app_components.js` (134KB) | 38컴포넌트·디스패치·옵션처리·상품분기 | [red-code-map-07-components.md](red-code-map-07-components.md) |
| 에디터 SDK | `deob_editor_sdk.js` (439KB) | from-edicus 30액션·goto-cart·토큰·origin보안 | [red-code-map-08-editor-sdk.md](red-code-map-08-editor-sdk.md) |

## S0 핵심 발견 — "축의 재정의" (캡처가 놓친 것)

1. **price_gbn은 코드 분기축이 아니다.** 우리가 "4 가격모델 대표"로 게이트한 프레임 자체가 틀린 축이었다. 코드는 단일 가격 엔드포인트(`get_ajax_price_vTmpl`) + price_gbn 불투명 echo. **진짜 분기축 = `itemGroup` 4상품군**(book2025/clothes2025/vDigital/ACC). → 전 상품 커버리지는 itemGroup×컴포넌트조합으로 재정의.

2. **componentType은 Red 코드에 없다.** Red는 **38개 컴포넌트**(메인3/서브10/후가공26/자재1/수량4)를 (a)데이터 존재여부 조건부 렌더 (b)PCS_CD→동적 import 맵(후가공 31케이스)으로 디스패치. **우리 "14 componentType switch"는 어댑터가 38종을 정규화·병합한 결과** — 이 정규화 규칙이 parity의 실제 검증 대상.

3. **스토어 5개** (config/product/exterior/order/acc-order). 기존 분석 "4개"는 config(locale/번역) 누락. config를 order에 합치면 안 됨.

4. **ACC(부자재)는 앱/인스턴스 클래스 자체가 갈림**(`init()` M1.has(pdtCode)). 단순 옵션 분기가 아닌 별도 앱 경로.

## S1 검증 대상 후보 (코드가 드러낸 미재현·오분류 의심)

| # | 의심 갭 | 근거 | 영향 |
|---|---------|------|------|
| P1 | **14↔38 정규화 규칙** 미문서화 | 어댑터가 Red 두 디스패치를 14로 정규화 | parity 핵심 — 정규화가 손실 없는지 |
| P2 | **복합 후가공 손실** (COT_DFT 단/양면+코팅, ROU_DFT 멀티+귀토글+사이즈연동반경) | `mod_07` 컴포넌트 내부 분해·재합성 로직 | 우리 finish-button 단일선택으로 재현 불가 |
| P3 | **color-chip hex 미이관** | END_PAP 10색 hex가 Red 컴포넌트 내부 하드코딩(`mod_07:2511`) | 매트릭스 "산출0" 오판 — Red엔 색칩 baseline 존재 |
| P4 | **VIEW_YN 동적 add/remove** (가격재계산 동반) | `mod_06:1452` | 우리 cascade.ts는 disable만, 동적토글 없음 |
| P5 | **컴포넌트 내부 캐스케이드** 미승격 | ROU_DFT 사이즈→반경, Apparel 인쇄영역→PDT_WRK | 어댑터/스토어로 안 올라옴 |
| P6 | **이중 debounce 200ms** / 자재-스코프 disable | `mod_06:2742`+`mod_05:1937` / VisiblePostPcs | 가격 트리거·disable 동작 정합 |
| P7 | **에디터 30액션·deferred-param·auto-save·inheritToken·origin 무검증** | `deob_editor_sdk.js` (08맵) | 30 from-edicus 액션 커버, goto-cart=close 공유(case switch 불요), origin allowlist 보안보강 |

## 다음 (S1)

도메인별 대응 매트릭스: 각 Red 책임 × {우리 구현 위치 / 정합상태(완전재현·부분·누락·상이) / 코드증거}. 위 P1~P6 우선 검증.
S0 검토 확정 후 S1 설계 착수.
