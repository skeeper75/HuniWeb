# 후니프린팅 견적 위젯 기능명세서 (Quote Widget Functional Spec)

- 상태: Draft v1.0 (Open-Core 핵심 컴포넌트 OC-C-04)
- 작성일: 2026-05-31
- 작성자: pq-architect
- 오너 지시: "RedPrinting 위젯 기능은 완벽하게 구현. Edicus 편집기 공통이므로 철저히 분석해 후니 위젯에 필수 반영."
- 산출 경로: `_workspace/print-quote/03_architecture/quote-widget-spec.md`
- 입력:
  - RedPrinting 역공학: `05_code_pattern_transfer_analysis.md`(Adopt 21/Ref 9/Skip 3), `역공학_최종_보고서.md`, `editor_sdk_method_catalog.md`(45메서드), `deob_05_app_api.js`(가격API/debounce), `deob_06_app_widget_sdk.js`(canOrder/이중업로더/콜백/itemGbn)
  - 우리 설계: `pricing-engine.md`(6단계), `form-builder.md`(8축), `block-schema.md`(14위젯), `open-core-scope.md`(OC-C-04/05), `pricing-rules.md`(19시트), `requirements-ears.md`(REQ-PQ-001~129)
- 본 문서 위치: 코드 구현이 아닌 **기능명세(무엇을/왜)**. 프로토타입·SPEC의 입력.

> **[HARD] 설계 게이트:** RedPrinting 기능을 "완벽 반영"하되 **맹목적 답습 금지**. 후니 모델 우위 5가지(서버사이드 CascadeEngine / CSP-Hybrid 3-Layer / Custom Element 멀티인스턴스 / 코드 스플리팅 / HMAC 보안)를 존중하고, transfer_analysis의 Reference 9/Skip 3 판정을 반영한다. deob 소스에서 확인 안 되는 동작은 **"런타임 검증 필요(RTV)"** 로 명시.

---

## §1. 위젯 책임 범위 (Scope)

### 1.1 견적 위젯이 하는 일 (Customer-facing 5단계)

```
[1] 옵션 선택        상품 사양 8축 캐스케이드 입력 (규격→용지→도수→수량→후가공→제본→…)
        ↓               서버사이드 CascadeEngine이 의존성 검증·선택지 필터링
[2] 실시간 가격     옵션 변경 → debounce 300ms → POST /api/products/[code]/pricing
        ↓               pricing-engine 6단계 산출 → breakdown[] 명세 표시 (인쇄비/후가공비 분해)
[3] 파일 준비       이중 모드: ① 파일 업로드(S3) ② Edicus 디자인 에디터(iframe+SSO+postMessage)
        ↓               아트워크 산출 → 주문 첨부
[4] 주문 전 검증    canOrder() 클라이언트 종합검증 (옵션완결성·파일·가격·필수옵션)
        ↓               서버 validate와 병행 (RTT 절감)
[5] 카트/주문 연결  add_to_cart / save_quote / open_editor → quote_lines.spec_snapshot 영속
```

### 1.2 Open-Core 경계 (포함/제외)

| 구분 | 포함 (Open-Core) | 제외 (V1.1) |
|---|---|---|
| 옵션 | 8축 캐스케이드, 비규격 사이즈 모달, 14 UI 타입 | repeater(책자 페이지별 옵션 — O-FB-4 종속), VDP 필드 |
| 가격 | 실시간 6단계 산출, breakdown 분해 표시, 인쇄비/후가공비 분리 | 쿠폰/적립금 UI(Step5 할인은 정가 결제로 우회 가능), B2B 등급별 가격표 |
| 파일 | 파일 업로드 + Edicus 에디터 진입(iframe+SSO+아트워크 첨부, 최소형) | 저장디자인 라이브러리, 디자인의뢰 워크플로우, 풀 DesignProject 결합 |
| 검증 | canOrder() 클라이언트 + BFF Zod 재검증 | PitStop 심화 자동검수(REQ-PQ-065는 검수 도메인, 위젯은 포맷 1차 검증만) |
| 연결 | 장바구니 담기, 견적 저장(재진입 복원) | 옵션보관함(REQ-PQ-039, 재주문 편의 — V1.1) |

> **위젯 책임 vs 엔진 책임 분리 [HARD]:** 위젯은 **UI·상태·트리거**만 소유. 가격 산출(pricing-engine)·옵션 의존성 룰(CascadeEngine)·파일 검수는 모두 서버사이드. 위젯은 호출자(caller). RedPrinting이 38 컴포넌트에 분산 하드코딩한 로직을 후니는 서버로 끌어올린다(우위 #1, #2).

### 1.3 멀티 인스턴스 모델 (Reference 판정 반영)

RedPrinting `window.RedWidgetSDK` 전역 싱글톤 → 후니 `customElements.define('huni-quote-widget')` Custom Element + 독립 Shadow DOM(우위 #3). 한 페이지에 여러 견적 위젯(예: 묶음 상품 비교)이 네임스페이스 충돌 없이 공존. 빌더의 `option_panel` 블록(block-schema §2.7)이 각 인스턴스를 렌더.

---

## §2. 옵션 캐스케이드 명세 (Option Cascade)

### 2.1 RedPrinting 의존성 트리 → 후니 도메인 매핑

RedPrinting 옵션 의존성(역공학 §3.2)을 후니 `Specification / SpecOption / SpecRule`(form-builder 8축)으로 매핑.

| RedPrinting (As-Is) | 후니 도메인 (To-Be) | form-builder 8축 | pricing 영향 |
|---|---|---|---|
| 규격 (sizes) → 작업사이즈 자동(CUT→WRK +10mm 도련) | `Specification(name=size)` + `SpecOption` / `size_custom` | 축1 사이즈 | Step1 (비규격 surcharge) |
| 내지/표지 용지(paper/weight) → 자재코드(INN/CVR_MTRL_CD) | `Specification(name=paper)` 다대다 소재 매핑 | 축2 종이/소재 | Step2 per_unit |
| 인쇄 도수 (dosuInfo) | `Specification(name=print_sides/dosu)` | 축3 도수 + 축4 단/양면 | Step2 percentage |
| 수량 (QTY → PRN_CNT) | `Specification(name=quantity)` number/slider | 축5 수량 | **Step1 단가 1차 결정 (QuantityBreak)** |
| 후가공 (PCS_INFO[]: CUT/PER/COT/BIND) | `Specification(name=finishing)` multi_select + `SpecRule` | 축6 후가공 | Step2 per_unit + setup_fee |
| 제본 (PER_DFT 좌철/상철, BIND_DIRECTION) | `Specification(name=binding)` | 축7 제본 | Step2 fixed + setup_fee |
| 가공옵션(별색·코팅 세부) | `SpecOption` + `SpecRule` enable/disable | 축8 가공옵션 | Step2 fixed |

> **핵심 차이 [우위 #1]:** RedPrinting은 의존성을 38개 Vue 컴포넌트 + 제품코드 하드코딩 상수(`MATERIAL_PCS_CODE_MAP`, `RESET_MATERIAL_AFTER_EDIT_CODES` 등 deob_06 §23)로 분산 관리. 후니는 **서버사이드 CascadeEngine**이 `product_spec_rules`(enable/disable/require)를 동적 평가. 500+ 상품 확장 시 하드코딩은 기술부채(transfer_analysis §3 Reference 판정).

### 2.2 캐스케이드 동작 흐름 (서버사이드)

```
사용자가 옵션 X 선택
    ↓
위젯이 현재 selectionMap을 CascadeEngine에 전달
    POST /api/products/[code]/cascade  { selections: {specName: optionValue} }
    ↓
CascadeEngine (서버):
  1. SpecRule 평가 (CSP-Hybrid 3-Layer, 우위 #2):
     - Layer 1 물리적: 사이즈 > 소재 최대규격 → 비활성
     - Layer 2 공정: 박 후가공 → 박 가능 소재만 enable
     - Layer 3 비즈니스: 등급/프로모션 노출 제어
  2. 다음 단계 선택지 필터링 (가용 옵션 set)
  3. 자동 선택/리셋 (RedPrinting RESET_MATERIAL_AFTER_EDIT 대응 → DB rule)
    ↓
응답: { availableOptions, autoSelected[], disabledOptions[], resetFields[] }
    ↓
위젯 UI 갱신 (disabled 옵션 회색조, 다음 step unlock)
```

> RedPrinting은 캐스케이드를 **클라이언트 reactive watch**로 처리(Pinia). 후니는 **서버 권위(authoritative)** — 클라이언트는 캐시된 가용 옵션만 즉시 표시(낙관적), 서버가 신뢰 경계. RTV: RedPrinting의 정확한 watch 트리거 순서는 런타임 검증 필요(정적 분석 한계, 보고서 §6.1).

### 2.3 14 componentType UI 매핑 (Adopt #1 — Top10 1위)

RedPrinting 38 Vue 컴포넌트 → 14 UI 패턴. 후니 form-builder V1 16종 필드 타입에 1:1 매핑.

| # | RedPrinting componentType | 용도 | 후니 form-builder type | block-schema |
|---|---|---|---|---|
| 1 | ButtonType | 라디오형 버튼 그룹 | `radio` | option_panel display_as=radio |
| 2 | FinishButtonType | 후가공 토글 버튼 | `checkbox` (multi) | option_panel |
| 3 | ColorChipType | 컬러칩 선택 | `swatch` | option_panel display_as=swatch |
| 4 | SelectType | 드롭다운 | `select` | form_field/option_panel |
| 5 | ImageButton (아이콘 체크박스) | 시각 옵션 | `image_grid` | display_as=image_grid |
| 6 | SizeType (규격) | 규격 선택 | `size_select` | option_panel |
| 7 | CustomSizeType (비규격) | W×H 입력 | `size_custom` | OC-C-04.1 모달 |
| 8 | QtyType (TotalQty/SetQty/SimpleQty/DesignQty) | 수량 4변형 | `quantity`/`number`/`slider` | display_as=slider |
| 9 | PaperType (자재필터+선택) | 용지 2단 | `select` + 더보기(50/200종, REQ-PQ-035) | option_panel |
| 10 | DosuColorType | 도수+컬러 | `radio` | option_panel |
| 11 | TextInputType (주문제목) | 텍스트 | `text` | form_field |
| 12 | UploaderType (이중) | 파일/에디터 | `file_upload` + edicus_slot | §5 |
| 13 | OptionRow (fieldset 래퍼) | 행 그루핑 | OptionFieldset 공용 | Adopt #6 |
| 14 | PostPcsType (후가공 25종) | 후가공 분류 | `checkbox` + §4 분류 | option_panel |

> **Adopt #6 OptionRow fieldset 패턴 (deob_06 §3, line 148-179):** RedPrinting의 `<fieldset><legend>` + 우측 extra 버튼 패턴은 a11y + 시각 그루핑을 동시 해결. 후니 `OptionFieldset` 공용 컴포넌트로 채택. `priority` prop으로 CSS `order` 제어(상품유형별 옵션 순서) — 단 후니는 순서를 **DB `Specification.sort_order`** 로 주입(하드코딩 회피).

### 2.4 비규격 사이즈 (OC-C-04.1, REQ-PQ-011/024/025)

RedPrinting `CustomSizeType` + 사이즈 보간 → 후니 `size_custom` 필드 + 모달.
- 가로/세로 mm 직접 입력 → 면적 표시
- pricing-engine: 사이즈 매트릭스(PR02) bilinear 보간(REQ-PQ-024), 범위 초과 시 단가/m² 외삽(REQ-PQ-025)
- 검증: `customSize.widthMm * heightMm > spec.max_value_mm2` → `CustomSizeBelowMin/ExceedsMaxError`(pricing-engine §4-C)

---

## §3. 실시간 가격계산 명세 (Realtime Pricing)

### 3.1 RedPrinting fetchPriceCalculation → 후니 pricing-engine 6단계

| RedPrinting (deob_05 line 1129~1154) | 후니 (pricing-engine.md) |
|---|---|
| `POST /ko/product_price/get_ajax_price_vTmpl` | `POST /api/products/[code]/pricing` |
| 요청 `{dataJson: {ORD_INFO[], PCS_INFO[], price_gbn, mb_cust_cod}}` | `QuoteInput {productId, options, quantity, customSize?, context}` |
| 응답 `[{PCS_CD, PRICE, PRICE_VAT, PRICE_MALL}]` 공정별 배열 | `QuoteResult {grandTotal, breakdown[], warnings, meta}` |
| `price_gbn`(book2025_price 등) 가격체계 선택 | `priceTable.pricing_model`(PriceTable3D/BasePriceTier 디스크리미네이터) |
| `mb_cust_cod` 회원/비회원 차등 | `context.customerGrade`(guest/normal/silver/gold/vip) |

### 3.2 ORD_INFO + PCS_INFO 분리 구조 (Adopt #3 — 필수)

> **이것이 인쇄비/후가공비 분리 표시의 핵심.** RedPrinting이 요청을 두 배열로 분리하는 것을 후니가 채택. 단 후니는 응답 측 `breakdown[]`(pricing-engine §1 6단계)으로 이미 분해 보유 → RedPrinting보다 **세밀**(step별 category 분류).

| RedPrinting 분리 | 후니 대응 |
|---|---|
| `ORD_INFO[{상품코드, 자재, 수량}]` | `QuoteInput.options`(사양) + `quantity` → pricing Step1 base_price |
| `PCS_INFO[{PCS_CD, PCS_DTL_CD}]` | finishing options → pricing Step2 option_surcharge (category='option_surcharge') |
| 응답 공정별 PRICE 배열 | `breakdown[].category` (base_price / option_surcharge / setup_fee / …) |

후니 요청은 단일 `QuoteInput`(flat options)으로 보내고, **서버가 ORD/PCS 분해**를 수행(클라이언트 단순화). RedPrinting은 클라가 분리 — 후니는 서버 책임으로 이동(우위 #1 정합).

### 3.3 인쇄비·후가공비 분해 표시 (REQ-PQ-027/038)

`quote_preview` 위젯(block-schema §2.8)이 `breakdown[]`을 step별 렌더:

```
견적 명세 (breakdown[] 표시)
─────────────────────────────
인쇄비       기본단가 50원 × 100매 (100~499 구간)   5,000원   [step1 base_price]
판비/제판비                                          5,000원   [step1 setup_fee]
후가공       양면 코팅(반광) +15원 × 100매           1,500원   [step2 option_surcharge]
             박 가공비(동판 5,000 + 가공)             8,000원   [step2 fixed, REQ-PQ-028]
인쇄(양면)   +50%                                              [step2 percentage]
─────────────────────────────
소계                                                29,250원   [step3 subtotal]
긴급납기     +30%                                    8,775원   [step4 rule_surcharge]
부가세(10%)                                          3,802원   [step6 vat, REQ-PQ-029/030]
배송비       (10만원 미만)                            3,000원   [step6 shipping]
─────────────────────────────
합계                                                44,827원   [grandTotal]
```

> RedPrinting은 공급가/부가세/청구금액 3단만 표시. 후니는 **6단계 전체 breakdown** 노출 → "왜 이 가격인가" 설명 가능(pricing-engine 원칙 #4). REQ-PQ-027(후가공 분리), REQ-PQ-028(박 동판비 라인), REQ-PQ-038(LineItem 산식) 충족.

### 3.4 debounce 300ms + 캐시 (Adopt #2 — Top10 2위)

| 항목 | RedPrinting | 후니 |
|---|---|---|
| debounce | Lodash debounce(deob_05 line 329-420, 전체 번들 ~1000줄) | `usePricing.ts` debounce 300ms (lodash-es 개별 import 또는 네이티브 — Reference: 번들 절감) |
| 캐시 | (정적분석 한계 — RTV) | 5초 TTL, 키=`(productId, optionsHash, quantity, customerGrade)` (pricing-engine §9) |
| 응답목표 | — | REQ-PQ-021 < 500ms (cache hit ≤50ms, P99 산출 ≤50ms) |
| 무효화 | — | PriceTable/Surcharge 수정 시 `revalidateTag('product:'+id)` |

### 3.5 실시간 갱신 UX (form-builder §13)

```
옵션 변경 → debounce 300ms → optimistic UI(이전 결과 회색조)
    → POST pricing → QuoteResult → breakdown 항목별 highlight 1초
오류: API 실패 → 이전 가격 유지 + 토스트 / 5회 연속 실패 → circuit break
```

REQ-PQ-031(가격요소 변경 시 실시간 갱신), REQ-PQ-021(0.5초), REQ-PQ-033(최소수량 미달 거부) 충족.

---

## §4. 후가공 처리 (Post-Process / Finishing)

### 4.1 visible/hidden/essential 3분류 (Adopt #4)

RedPrinting `classifyPostProcessOptions`(deob_06 §16, 원본 mod_06 line 2618~2661) — 서버 `pdt_pcs_info`를 `ESN_YN`(필수여부)/`VIEW_YN`(노출여부) 2 플래그로 분류. 핵심 로직은 mod_06 line 1198~1254(`h()`, `f()`, `_()`, `p()` 함수)에서 PCS_CD/VIEW_YN/ESN_YN/PCS_DTL_CD 구조 확인.

| RedPrinting 분류 | 조건 | 후니 대응 (SpecOption + CascadeEngine) |
|---|---|---|
| **hidden** (자동적용) | `ESN_YN='Y' && VIEW_YN='N'` | `SpecOption.auto_apply=true, visible=false` — 필수이나 UI 미표시, 가격엔 반영 |
| **visible** (선택) | `ESN_YN='Y'&&VIEW_YN='Y'` 또는 `ESN_YN='N'` | `SpecOption.visible=true` — 사용자 선택 UI 노출 |
| **essential/sub** (자재연결) | `SUB_MTR`/`DIR_MTR`/`WRK_MTR` 계열 | `SpecRule(rule_type=require)` — 자재 선택이 후가공 자동 연결(deob_06 `MATERIAL_PCS_CODE_MAP`) |
| **disabled** | `disabledOpts[mtrlCd]` | CascadeEngine `disabledOptions[]` 반환 |

> **후니 매핑 [우위 #1]:** RedPrinting은 분류를 클라이언트 유틸 함수 + 제품코드별 하드코딩 맵(`MATERIAL_PCS_CODE_MAP` 9개 제품)으로 처리. 후니는 `SpecOption.visible/auto_apply` 컬럼 + `SpecRule`로 **DB 동적 관리**. 신규 후가공 추가 시 코드 배포 불필요.

### 4.2 후가공 항목별 가격 분해

각 후가공 PCS는 `spec_option_surcharges`로 가격 연결(pricing-engine §5 축5):
- per_unit (코팅: 매당 +15원) — Step2
- fixed (박: 동판비 5,000 + 가공비 — REQ-PQ-028) — Step2
- setup_fee 누적 (판비) — Step1
- breakdown에 후가공별 개별 라인(REQ-PQ-027 분리 표시)

### 4.3 hidden 후가공의 신뢰 경계

hidden(자동적용) 후가공도 **반드시 서버에서 가격 반영** — 클라이언트가 누락/조작해도 BFF가 `SpecOption.auto_apply=true`를 강제 합산(pricing-engine validate Step0). RedPrinting은 클라가 PCS_INFO 구성 → 신뢰 경계 약함. 후니는 서버 권위.

---

## §5. 파일 준비 — 이중 모드 (File Preparation)

### 5.1 이중 모드 토글 (Adopt #5)

RedPrinting `uploadType: "editor" | "pdf"`(deob_06 `useExteriorStore`, line 780-814) — 키별(`default`/`inner`/`cover`) 관리. 후니 매핑:

| 모드 | RedPrinting | 후니 | block-schema |
|---|---|---|---|
| 파일 업로드 | `uploadType='pdf'` → S3 업로드 | `file_upload` 위젯 → S3(REQ-PQ-078, CloudFront 배포) | OC-C-05 |
| 디자인 에디터 | `uploadType='editor'` → Edicus iframe | `edicus_slot` 위젯 → Edicus iframe+SSO | OC-C-05.1, §2.13 |

> **둘 다 Open-Core 필수(D-PM-37).** 키별 관리(책자 내지/표지 분리)는 후니도 채택 — `uploadType[key]` → 후니 멀티 슬롯(book2025 내지/표지 각각 모드 선택, deob_06 canOrder line 1174-1189 참조).

### 5.2 Edicus 연동 핵심 인터페이스 (editor_sdk_method_catalog 45메서드 기반)

RedPrinting EditorBridge 패턴(iframe + postMessage 양방향, base URL `edicusbase.firebaseapp.com`)을 후니 `EdicusEditor` 컴포넌트로 차용. **Open-Core 최소 연동 범위**에 필요한 SDK 메서드:

| 후니 인터페이스 | Edicus SDK 메서드 | 용도 | 트리거 |
|---|---|---|---|
| `initEditor(config)` | `new RedEditorSDK({accessToken, userId, sandboxMode})` | SDK 초기화 | edicus_slot 마운트 |
| **SSO 토큰** | `setToken()` / `setUserId()` | partner="hunip" SSO(D-PM-37) | 로그인/게스트 토큰 발급 |
| `createProject(...)` | `createProject(editorConfig, projectOptions)` | 신규 디자인 시작 | "디자인 시작" CTA |
| `openProject(id)` | `openProject(editorConfig)` | 기존 프로젝트 편집 | 재진입 |
| **가격 동기화** | `setPrice(priceValue)` | 에디터에 견적가($PRCE) 주입 | pricing 결과 → 에디터 |
| **주문가능 검증** | `checkOrderable(projectId)` → `{can_order, doc_rev, message}` | 에디터 산출물 주문 가능 확인 | §6 canOrder 통합 |
| **저장/닫기** | `save()` / `saveThenClose()` / `close()` | 아트워크 확정 | "완료" |
| **이벤트 구독** | `on(eventType, cb)` (22 이벤트: create/close/save/change/load/error/pageCountChange 등) | 에디터 상태 동기화 | 라이프사이클 |
| **정리** | `destroy(resetCallbacks)` | iframe 제거·콜백 초기화 | 위젯 언마운트(멀티인스턴스 누수 방지) |
| 아트워크 첨부 | (save 후 projectId/doc_rev → 주문 첨부) | Edicus Prepress 렌더 → 접수파일(REQ-PQ-076) | 주문 생성 |

> **Open-Core 미포함 메서드:** reformProject/cloneProject/VDP(openVdpViewer/setVariableData)/remoteEditorBulk/getResourceList/템플릿 갤러리(getTemplateList) 등은 V1.1(저장디자인·디자인의뢰·VDP). edicus_slot의 `editor_mode='vdp'`는 V2(form-builder vdp_field_definitions).

### 5.3 postMessage 프로토콜 + 장애 격리

- iframe ↔ 호스트 양방향(EditorBridge 패턴)
- **가격 무종속(pricing-engine §10 O-002):** Edicus는 디자인 자산(template_uri/content_uri)만 보유. **가격 계산 입력에 미포함** → Edicus 장애가 견적가에 영향 없음.
- RTV: Edicus iframe origin 검증·postMessage 메시지 스키마는 SDK 외부 의존(`edicusbase.firebaseapp.com`)이므로 통합 시 런타임 검증 필요.

### 5.4 에디터 편집 후 자재 리셋 (deob_06 RESET_MATERIAL_AFTER_EDIT_CODES)

RedPrinting은 26개 제품코드 하드코딩 Set으로 "에디터 편집 후 자재 초기화"를 처리. 후니는 **SpecRule(rule_type='reset')** 로 DB 표현(transfer_analysis §5 P1-003 권고). 위젯은 CascadeEngine `resetFields[]` 응답을 수신해 처리.

### 5.5 파일 포맷 검증 (REQ-PQ-063/064/070)

위젯 1차 검증(클라이언트): 인쇄타입별 강제 포맷(디지털=PDF, 실사=JPG/PDF, 박/도장=AI). 자유형 스티커는 출력파일(PDF)+칼선파일(AI CS9) 분리(REQ-PQ-070). 잘못된 포맷 즉시 거부+가이드(REQ-PQ-064). **심화 검수(PitStop, REQ-PQ-065)는 검수 도메인** — 위젯 책임 밖.

---

## §6. 주문 전 검증 — canOrder (Pre-Order Validation)

### 6.1 RedPrinting canOrder 분석 (deob_06 line 1155~1215)

RedPrinting `canOrder()`는 클라이언트 종합 검증 — 검증 항목:
1. 제품 주문가능 상태 (`order_yn !== 'N'`)
2. 사이즈 유효성 (`orderData.validation.length === 0`)
3. 가격 계산 결과 (`priceCalc.result.retCode === 200 && result_sum.PRICE`)
4. itemGbn별 파일/에디터 검증:
   - 책자(book2025): 내지/표지 각각 editor(`isAfterEdit`) 또는 pdf(파일존재) + 파일명 중복 검사
   - PDF 모드: 파일 존재 확인
   - 의류(clothes2025): 인쇄없음 통과 / 실크인쇄 팬톤 미선택 거부
   - 에디터 모드: 편집완료(`isAfterEdit`) 확인 (인쇄없음 SID_X 제외)

### 6.2 후니 useOrderValidation 매핑 (Adopt #7)

| RedPrinting 검증 | 후니 대응 |
|---|---|
| `order_yn !== 'N'` | `product.is_orderable` |
| 사이즈 validation | CascadeEngine `validation[]` (서버) |
| priceCalc retCode 200 | `QuoteResult` 정상 산출 + `grandTotal > 0`(또는 promo 0원 허용) |
| 파일/에디터 존재 | `fileUploadInfo` or `editorData.editingYn === 'Y'` (Edicus `checkOrderable`) |
| 필수 옵션 완결 | SpecRule `require` 전부 충족 |
| 책자 내지/표지 파일명 중복 | 멀티슬롯 파일명 유일성 검사 |

> **이중 검증 [우위 정합]:** 후니 `useOrderValidation.ts`(클라이언트 사전검증, RTT 절감) + **BFF Zod 재검증(신뢰 경계, form-builder §12)**. RedPrinting은 클라이언트 검증만 — 후니는 서버 재검증 추가. 검증 결과 `{success, errorMessage}` 동일 시그니처 채택.

### 6.3 검증 시점 (form-builder §12 5단계)

```
[1] onChange/onBlur 즉시 피드백 → [2] onSubmit 종합(canOrder) → [3] BFF Zod parse(신뢰경계)
→ [4] pricing-engine validate(SpecRule+qty) → [5] DB Constraint
```

---

## §7. 상품유형별 분기 (Product Type Branching)

### 7.1 RedPrinting itemGbn 분기 (Adopt #9)

RedPrinting 3 메인 컴포넌트(Digital/Acrylic/Clothes) + itemGbn(book2025/clothes2025 등) + ACC(부자재). deob_06 §23 제품코드 상수 맵(QUANTITY_UI_TYPE_MAP, CALENDAR_PRODUCT_CODES, ACC_PRODUCT_CODES 등)으로 분기.

| RedPrinting itemGbn | 위젯 구성 특징 | 후니 chunk |
|---|---|---|
| Digital(디지털인쇄) | 방향→자재필터→컬러→모양→자재→도수→두께→규격→수량→후가공→파일 | `huni-chunk-digital` |
| Book(book2025) | 내지/표지 group-title 디바이더, 내지/표지 분리 업로드 | `huni-chunk-book` |
| Apparel(clothes2025) | 인쇄유형→컬러→사이즈→인쇄영역→팬톤(deob_07 916-1151) | `huni-chunk-apparel` |
| Acrylic | 제작방식(Method)→인쇄데이터(PrintData) | `huni-chunk-acrylic` |
| ACC(부자재) | `useAccOrderStore`, 단순 옵션 | (digital 청크 포함) |

11 itemGbn → 4 동적 import 청크(transfer_analysis #9). 코드 스플리팅 3KB 로더+청크(우위 #4) vs RedPrinting 450KB 단일 번들.

### 7.2 후니 상품군 비종속 설계와 조화 [HARD]

> **충돌 해소:** open-core-scope §상단 "상품군 비종속 설계 원칙"(상품 마스터 구동) vs RedPrinting itemGbn 하드코딩 분기.
>
> **후니 방침:** itemGbn 분기는 **하드코딩하지 않고 `product.productType` + `Specification` 구성으로 데이터 구동**. 위젯은 `productType`을 보고 **렌더 청크만 선택**(번들 최적화), 옵션 구성·순서·의존성은 전부 DB(`Specification.sort_order`, `SpecRule`, `option_panel.step_overrides`). 우선 상품군 미확정(실무진 협의 대기)이어도 동일 위젯이 데이터 주입만으로 동작.
>
> 즉 RedPrinting의 "분기 패턴"(청크 분리)은 채택하되, "분기 기준"은 itemGbn 상수 → DB `productType` + spec 구성으로 이동. **componentType 14종(§2.3)이 상품군 비종속 빌딩블록** — 어떤 상품군이 와도 14 UI 타입 조합으로 표현.

### 7.3 수량 UI 4변형 (deob_06 QUANTITY_UI_TYPE_MAP)

RedPrinting TotalQty/SetQty/SimpleQty/DesignQty → 후니 `quantity` 필드의 `display_as`(number/slider) + `Specification.metadata.qty_ui_variant`. 포토카드 세트가격(20장=6,000원, 21장+ 대량 — REQ-PQ-034) 같은 변형은 BasePriceTier + SpecRule로 표현.

---

## §8. 필수 구현 체크리스트 (MUST / SHOULD / SKIP)

RedPrinting Adopt 21패턴을 **후니 모델 기준**으로 재정리. (MUST=Open-Core 필수, SHOULD=V1 권장, SKIP=후니 우위로 대체 또는 V1.1)

### 8.1 MUST (Open-Core 필수 — 14건)

| # | 기능 | RedPrinting 출처 | 후니 구현 | REQ-PQ |
|---|---|---|---|---|
| M1 | 14 componentType UI 매핑 | Adopt #1 | form-builder 14 type + display_as | PQ-009 |
| M2 | 옵션 캐스케이드 의존성 | §3.2 트리 | **서버 CascadeEngine**(우위 #1) + SpecRule | PQ-010 |
| M3 | debounce 300ms 가격재계산 | Adopt #2 | usePricing debounce + 5초 캐시 | PQ-021/031 |
| M4 | ORD/PCS 분리 가격 → breakdown 분해 | Adopt #3 | pricing 6단계 breakdown[] | PQ-027/038 |
| M5 | 후가공 visible/hidden/essential 분류 | Adopt #4 | **SpecOption.visible/auto_apply**(우위 #1) | PQ-010 |
| M6 | 후가공 항목별 가격 분해(박 동판비) | §3.3 | spec_option_surcharges 라인 | PQ-027/028 |
| M7 | 이중 모드 업로더(파일/에디터) | Adopt #5 | file_upload + edicus_slot | PQ-063/076 |
| M8 | Edicus iframe+SSO+아트워크 첨부 | EditorBridge | EdicusEditor(SDK 최소 10메서드 §5.2) | PQ-076/077 |
| M9 | canOrder 클라이언트 종합검증 | Adopt #7 | useOrderValidation + BFF Zod 재검증 | PQ-033 |
| M10 | 비규격 사이즈 입력+보간 | CustomSizeType | size_custom + bilinear 보간 | PQ-011/024/025 |
| M11 | 실시간 가격 UX(optimistic+highlight) | §3.5 | form-builder §13 | PQ-031 |
| M12 | itemGbn 분기 → productType 데이터 구동 | Adopt #9 | productType 청크(비종속, §7.2) | PQ-003 |
| M13 | 최소수량 미달 거부+가이드 | canOrder | pricing validate Step0 | PQ-033 |
| M14 | 파일 포맷 1차 검증 | §5.5 | 인쇄타입별 강제 포맷 | PQ-063/064/070 |

### 8.2 SHOULD (V1 권장 — 5건)

| # | 기능 | 출처 | 비고 |
|---|---|---|---|
| S1 | OptionRow fieldset 래퍼(a11y) | Adopt #6 | OptionFieldset 공용, sort_order DB 주입 |
| S2 | 호스트 콜백 자동 디스패치(9 CustomEvent) | Adopt #8 | on-option-change/on-price-change 등(deob `setOrderData`→onOptionChange) |
| S3 | 책자/의류 복합 컴포넌트 순서 | Adopt #10 | huni-chunk-book/apparel — 단 V1 핵심 SKU 확정 시(O-FB-4) |
| S4 | 자재연결 후가공(SUB/DIR_MTR) | deob §23 | SpecRule require, V1 일부 상품 |
| S5 | 에디터 편집 후 자재 리셋 | RESET_MATERIAL | SpecRule reset(P1-003) |

### 8.3 SKIP (후니 우위 대체 또는 V1.1 — 맹목 답습 금지)

| # | RedPrinting 방식 | SKIP 사유 | 후니 대체 |
|---|---|---|---|
| K1 | `window.RedWidgetSDK` 전역 싱글톤 | 멀티인스턴스/네임스페이스 충돌 | Custom Element + Shadow DOM(우위 #3) |
| K2 | 제품코드 하드코딩 상수(26+ Set/Map) | 500+ 상품 확장 기술부채 | DB SpecRule/SpecOption 동적(우위 #1, Ref) |
| K3 | 클라이언트 의존성 watch(38 컴포넌트 분산) | 신뢰 경계 약함 | 서버 CascadeEngine 권위(우위 #1/#2) |
| K4 | Lodash 전체 번들(~1000줄) | 번들 사이즈 | lodash-es 개별/네이티브(Ref) |
| K5 | 280개 번역 하드코딩 | 다국어 확장 | JSON 분리(V1 한국어, i18n V2 — Ref) |
| K6 | 단순 클라이언트 가격검증만 | 무결성 위반 위험 | BFF Zod 재검증 추가 |
| K7 | VDP/clone/reform/템플릿 갤러리 | Open-Core 범위 밖 | V1.1/V2(저장디자인·VDP) |

---

## §9. REQ-PQ 추적 (Traceability)

| 기능 영역 | 섹션 | 충족 REQ-PQ |
|---|---|---|
| 옵션 캐스케이드 (8축, 의존성, 14 UI, 비규격) | §2 | PQ-003, PQ-008, PQ-009, PQ-010, PQ-011, PQ-035 |
| 실시간 가격 (6단계, 분해, debounce, 보간) | §3 | PQ-020, PQ-021, PQ-022, PQ-023, PQ-024, PQ-025, PQ-026, PQ-027, PQ-028, PQ-029, PQ-030, PQ-031, PQ-032, PQ-033, PQ-034, PQ-037, PQ-038 |
| 후가공 처리 (분류, 가격분해, 박 동판비) | §4 | PQ-010, PQ-027, PQ-028 |
| 파일 준비 (이중모드, Edicus, 포맷검증) | §5 | PQ-063, PQ-064, PQ-070, PQ-076, PQ-077, PQ-078 |
| 주문 전 검증 (canOrder) | §6 | PQ-033 (+ PQ-040 주문연결 전제) |
| 상품유형 분기 (productType 데이터구동) | §7 | PQ-001, PQ-003, PQ-004, PQ-034 |
| 견적 연결 (장바구니, 견적저장) | §1.1 | PQ-039 (보관 V1.1), PQ-040~ (주문) |

> 가격엔진 상세 REQ(PQ-020~039)는 pricing-engine.md가 1차 충족, 본 위젯은 그 **UI·트리거·표시** 측면을 충족. 파일검수 심화(PQ-065 PitStop, PQ-067~075 파일명/권한)는 검수·생산 도메인(위젯 책임 밖, OC-A-07).

---

## §10. 미해결 / 후속 확인 항목

| ID | 항목 | 유형 | 담당 |
|---|---|---|---|
| QW-O-1 | 우선 상품군 선정 → 카탈로그 시드 (화면은 비종속이라 비차단) | owner/실무진 | open-core §4 순위3 |
| QW-O-2 | 무료배송 기준 (lineSubtotal vs afterDiscount) — breakdown step6 정확도 | architect | O-PE-1 |
| QW-O-3 | 책자 페이지별 옵션(repeater) V1 포함 여부 (S3 종속) | owner | O-FB-4 |
| QW-O-4 | Edicus postMessage 메시지 스키마·origin 검증 | RTV(런타임) | SDK 외부의존 통합 시 |
| QW-O-5 | RedPrinting 캐스케이드 watch 트리거 순서 / 가격 캐시 정책 | RTV(런타임) | 보고서 §6.1 정적분석 한계 |
| QW-O-6 | hidden 후가공 가격 합산의 서버 강제 — auto_apply 컬럼 스키마 추가 | architect→analyst | schema.sql SpecOption 확장 |
| QW-O-7 | 9 CustomEvent 호스트 콜백 — 빌더 인터랙션 모델 정합 | architect | interaction-model.md |

---

REQ coverage: REQ-PQ-001~039(가격·옵션), 063~078(파일) 부분 / REQ-BUILDER 연계(option_panel, edicus_slot)
References: 05_code_pattern_transfer_analysis.md(Adopt21/Ref9/Skip3), deob_05_app_api.js(L329-420 debounce, L1129-1154 가격API), deob_06_app_widget_sdk.js(L148-179 OptionRow, L580-940 store/상수, L1155-1215 canOrder), editor_sdk_method_catalog.md(45메서드), pricing-engine.md(6단계), form-builder.md(8축/14type), block-schema.md(§2.7 option_panel/§2.8 quote_preview/§2.13 edicus_slot), open-core-scope.md(OC-C-04/05/05.1, D-PM-37), requirements-ears.md
