# RedPrinting 역공학 코드 패턴 전이 분석

> 분석일: 2026-04-10
> 분석자: MoAI Opus Architect
> 대상: deobfuscated JS 5,400줄+ (API Layer + Widget SDK + Vue Components)
> 목적: 후니프린팅 위젯에 적용 가능한 코드 패턴 식별

---

## 1. 판정 요약

| 축 | Adopt (채택) | Reference (참조) | Skip (불필요) |
|----|-------------|-----------------|-------------|
| API 통신 | 2 | 2 | 2 |
| 상태 관리 (Pinia) | 3 | 1 | 1 |
| 옵션 캐스케이드 UI | 7 | 0 | 0 |
| 가격 계산 + 트리거 | 3 | 2 | 0 |
| 에디터 통합 | 3 | 2 | 0 |
| Shadow DOM + 초기화 | 3 | 2 | 0 |
| **합계** | **21** | **9** | **3** |

---

## 2. 즉시 채택 가능한 패턴 (Top 10)

### 1. 옵션 UI 타입 다양화 (componentType 매핑)
- **Red**: 38개 Vue 컴포넌트 → 14가지 UI 패턴
- **후니 현재**: `OptionCascade.tsx:70-105` — 모든 옵션을 `Select` 드롭다운 하나로만 렌더링
- **적용**: 14개 componentType(ButtonType, FinishButtonType, ColorChipType 등)에 맞는 shadcn 컴포넌트 매핑
- **위치**: `packages/printly/packages/components/src/order/steps/OptionCascade.tsx`

### 2. debounce 300ms 가격 재계산 + 캐시
- **Red**: `deob_05_app_api.js:329-420` Lodash debounce
- **후니 현재**: `usePricing.ts`에 debounce 미구현 → 옵션 변경 시마다 즉시 API 호출
- **적용**: 300ms debounce + 30초 TTL 캐시 (아키텍처 문서에 설계됨, 코드 미반영)
- **위치**: `packages/printly/packages/components/src/order/hooks/usePricing.ts`

### 3. ORD_INFO + PCS_INFO 분리 가격 요청 구조
- **Red**: `deob_05_app_api.js:1129-1154` — `{ORD_INFO: [{상품코드, 자재, 수량}], PCS_INFO: [{PCS_CD, PCS_DTL_CD}]}`
- **후니 현재**: flat `SelectionMap`만 전달 → 후가공 항목별 가격 분해 불가
- **적용**: 인쇄비/후가공비 분리 표시를 위해 필수
- **위치**: `widget.service.ts` calculatePrice, `@shared/types` PriceRequest

### 4. 후가공 visible/hidden 분류 로직
- **Red**: `deob_06_app_widget_sdk.js:596-609` — ESN_YN/VIEW_YN 기반 3분류
- **적용**: 클라이언트에서 "보이는 후가공"과 "자동 적용 후가공" 구분 UI 로직
- **위치**: 신규 `FinishingSection.tsx`

### 5. 에디터/PDF 이중 모드 업로더
- **Red**: `deob_06_app_widget_sdk.js:780-814` — `uploadType: "editor" | "pdf"` 토글
- **적용**: `FileUpload.tsx`를 이중 모드 Uploader로 확장
- **위치**: `packages/printly/packages/components/src/order/FileUpload.tsx`

### 6. OptionRow fieldset 래퍼 패턴
- **Red**: `deob_06_app_widget_sdk.js:148-179` — `<fieldset>` + `<legend>` + 우측 extra 버튼
- **적용**: 접근성(a11y)과 시각적 그루핑 동시 해결
- **위치**: 신규 `OptionFieldset.tsx` 공용 컴포넌트

### 7. canOrder() 클라이언트 종합 검증
- **Red**: `deob_06_app_widget_sdk.js:1155-1215` — 파일/에디터/가격/옵션 종합 검증
- **적용**: 서버 validate와 병행하는 클라이언트 사전 검증 (RTT 절감)
- **위치**: 신규 `useOrderValidation.ts`

### 8. 호스트 콜백 자동 호출 패턴
- **Red**: `deob_06_app_widget_sdk.js:830-835` — `setOrderData` 시 `callbacks.onOptionChange` 자동 호출
- **적용**: 9개 CustomEvent (on-option-change, on-price-change 등) 디스패치
- **위치**: `useOptionCascade.ts` 내 `updateSelection`에 `dispatchEvent` 추가

### 9. itemGbn별 위젯 분기 (동적 import)
- **Red**: 3 메인 컴포넌트 (Digital/Acrylic/Clothes)
- **적용**: 11개 itemGbn → 4개 청크(digital/book/apparel/acrylic) 동적 import
- **위치**: `OrderWidget.tsx` 내 itemGbn 기반 분기

### 10. 의류/책자 전용 복합 컴포넌트 구조
- **Red**: Apparel(`deob_07:916-1151`) 인쇄유형→컬러→사이즈→인쇄영역→팬톤 순서
- **Red**: Book(`deob_07:1744-1957`) 내지/표지 group-title 디바이더
- **적용**: 상품유형별 필드셋 순서와 의존 관계 청사진
- **위치**: 신규 `huni-chunk-book.ts`, `huni-chunk-apparel.ts`

---

## 3. 참조만 할 패턴

| Red 방식 | 후니 방식 | 후니가 다르게 가져가야 할 이유 |
|----------|----------|---------------------------|
| Vue 3 + Pinia reactive/watch | React 19 + Zustand subscribe/selector | 프레임워크 차이, Zustand selector가 더 명시적 |
| 제품코드 하드코딩 상수 다수 | DB ConstraintRule 동적 관리 | 500+ 상품 확장 시 하드코딩은 기술 부채 |
| `window.RedWidgetSDK` 전역 싱글톤 | `customElements.define` Custom Element | 다중 인스턴스 + 네임스페이스 충돌 방지 |
| Lodash 전체 번들 (~1,000줄) | lodash-es 개별 import 또는 네이티브 | 번들 사이즈 절감 |
| 280개 번역 하드코딩 | JSON 분리 + 동적 로딩 | 다국어 확장 대비 |

---

## 4. 후니가 Red보다 잘한 점 (5가지)

1. **서버 사이드 CascadeEngine** — Red 38개 컴포넌트에 분산 하드코딩 vs 후니 DB 동적 관리
2. **CSP-Hybrid 3-Layer** — Red 단순 if/else vs 후니 물리적/공정/비즈니스 3단계
3. **Custom Element 멀티 인스턴스** — Red 전역 싱글톤 vs 후니 독립 Shadow DOM
4. **코드 스플리팅** — Red 450KB 단일 번들 vs 후니 3KB 로더 + 청크
5. **HMAC 보안** — Red 단순 문자열("red-mobile") vs 후니 HMAC-SHA256 서명

---

## 5. SPEC 배치 권고

### P1-003 (CascadeEngine)에 추가
- `classifyPostProcessOptions` 후가공 분류 로직
- 에디터 편집 후 자재 자동 리셋 규칙 (`RESET_MATERIAL_AFTER_EDIT_CODES`)
- 책자 페이지수 제약 검증 확장

### P1-004 (Widget API)에 추가
- ORD_INFO + PCS_INFO 분리 가격 요청
- `getSummary()` 상품유형별 주문 요약
- `canOrder()` 클라이언트 검증 스키마

### P4-001~003 (Widget franchise)에 추가
- 14가지 componentType UI 컴포넌트 구현
- 호스트 통신 프로토콜 (9개 CustomEvent)
- 프리셋 테마 시스템
- Facade 로더 + 코어 분리 번들 전략

### 신규 SPEC 필요
- **SPEC-EDITOR-INTEGRATION**: Edicus iframe 통합, postMessage 프로토콜, 에디터 상태 관리
- **SPEC-PRODUCT-TYPE-UI**: itemGbn별 UI 분기, 의류/책자/부자재 전용 컴포넌트

---

## References

- `_workspace/red_reverse_engineer/03_deobfuscated/deob_05_app_api.js` — Red API 레이어
- `_workspace/red_reverse_engineer/03_deobfuscated/deob_06_app_widget_sdk.js` — Red Widget SDK
- `_workspace/red_reverse_engineer/03_deobfuscated/deob_07_app_components.js` — Red Vue 컴포넌트
- `_workspace/huni_widget_franchise/03_widget_architecture.md` — 후니 위젯 아키텍처
- `_workspace/huni_widget_franchise/04_component_taxonomy.md` — 후니 14 componentType
- `packages/api/src/modules/widget/widget.service.ts` — 후니 Widget Service
- `packages/api/src/modules/widget/cascade-engine.ts` — 후니 CascadeEngine
