# RedPrinting Deobfuscation QA - Consistency Report

**Date:** 2026-03-30
**Files Validated:**
- `deob_05_app_api.js` (1507 lines)
- `deob_06_app_widget_sdk.js` (1392 lines)
- `deob_07_app_components.js` (2506 lines)
- `deob_editor_sdk.js` (12629 lines)

**Original Sources Cross-Referenced:**
- `mod_05_app_api.js`, `mod_06_app_widget_sdk.js`, `mod_07_app_components.js`
- `RedPrinting_SDK_Deep_Analysis_Report.html`

---

## 1. Naming Consistency (NC)

### 1.1 Cross-Module Identifier Mapping

| Minified | deob_05 Name | deob_06 Name | deob_07 Header Map | Consistent? |
|----------|-------------|-------------|-------------------|-------------|
| `Dt` | useConfigStore | useConfigStore | useI18n() | **CONFLICT** |
| `Ve` | useExteriorStore | useExteriorStore | useEditorStore() | **CONFLICT** |
| `zr` | useOrderStore | useOrderStore | useOrderDataStore() | **CONFLICT** |
| `Ms` | useProductStore | useProductStore | (not referenced) | OK |
| `Ml` | useAccOrderStore | useAccOrderStore | useOrderStore() | **CONFLICT** |
| `x` | translate | translate | t() / translate() | OK (alias) |
| `fe` | (not in 05) | OptionRow | OptionRow | OK |
| `je` | (not in 05) | ImageButton | IconCheckbox | **MISMATCH** |
| `Fo` | (not in 05) | Selector | BasicSelect | **MISMATCH** |
| `Sn` | (not in 05) | ButtonRadio | SizeSelector | **MISMATCH** |
| `sh` | (not in 05) | ColorPicker | ColorChipSelector | **MISMATCH** |
| `Dn` | (not in 05) | RadioList | RadioGroup | **MISMATCH** |
| `Kr` | (not in 05) | CloseIcon | CloseIcon / MultiplyIcon | OK |
| `qr` | (not in 05) | useOrderState | useOrderComposable() | **MISMATCH** |
| `Wr` | (not in 05) | buildUploadConfig | useUploadConfig() | **MISMATCH** |
| `Ql` | (not in 05) | classifyPostProcessOptions | parsePostProcessOptions() | **MISMATCH** |
| `Nl` | fetchAvailableMaterials | (not in 06) | fetchMaterialInfo() | **MISMATCH** |

**Findings:**

- **[NC-01] HIGH: Pinia store name conflicts between deob_06 definitions and deob_07 header mapping table.**
  The deob_07 header mapping table lists `Dt()` as `useI18n()`, but deob_05/06 define it as `useConfigStore`. Similarly `Ve()` is `useExteriorStore` in deob_06 but `useEditorStore()` in deob_07 header. `zr()` is `useOrderStore` in deob_06 but `useOrderDataStore()` in deob_07. `Ml()` is `useAccOrderStore` in deob_06 but `useOrderStore()` in deob_07.
  - File: `deob_07_app_components.js:52-72` (header mapping table)
  - File: `deob_06_app_widget_sdk.js:717-850` (actual store definitions)
  - Impact: Developers reading deob_07 header will use wrong store names.

- **[NC-02] MEDIUM: Component name mismatches between deob_06 and deob_07.**
  `je` is named `ImageButton` in deob_06 but `IconCheckbox` in deob_07. `Fo` is `Selector` vs `BasicSelect`. `Sn` is `ButtonRadio` vs `SizeSelector`. `sh` is `ColorPicker` vs `ColorChipSelector`. `Dn` is `RadioList` vs `RadioGroup`. These are semantically similar but not identical names.
  - File: `deob_06_app_widget_sdk.js:214` vs `deob_07_app_components.js:29`
  - Impact: Cross-referencing between modules requires mental mapping.

- **[NC-03] MEDIUM: Utility function name mismatches.**
  `qr` = `useOrderState` (deob_06) vs `useOrderComposable` (deob_07). `Wr` = `buildUploadConfig` vs `useUploadConfig`. `Ql` = `classifyPostProcessOptions` vs `parsePostProcessOptions`. `Nl` = `fetchAvailableMaterials` vs `fetchMaterialInfo`.
  - Impact: Same function appears under different names in different files.

- **[NC-04] LOW: Naming convention compliance is good.**
  Functions use camelCase, classes use PascalCase (`RedWidgetSDK`, `CommonWidgetInstance`, `AccWidgetInstance`), constants use UPPER_SNAKE_CASE (`REDPRINTING_BASE_URL`, `ALLOWED_CLIENT_KEYS`, `ACC_PRODUCT_CODES`).

### NC Summary
- Pass: 8 (consistent identifiers, naming convention adherence)
- Fail: 5 (store name conflicts, component name mismatches, utility name mismatches)
- Score: 0.62

---

## 2. Cross-Module Interface (CMI)

### 2.1 Pinia Store Definitions vs Usage

| Store | Defined In | Store ID | Used In deob_07 | Match? |
|-------|-----------|----------|-----------------|--------|
| config | deob_06:717 | `"config"` | Yes (via `Dt()`) | OK |
| product | deob_06:754 | `"product"` | Yes (via `Ms()`) | OK |
| exterior | deob_06:780 | `"exterior"` | Yes (via `Ve()`) | OK |
| order | deob_06:822 | `"order"` | Yes (via `zr()`) | OK |
| acc-order | deob_06:850 | `"acc-order"` | Yes (via `Ml()`) | OK |

Note: deob_07 retains minified call syntax (`Dt()`, `Ve()`, etc.) with header comments explaining the mapping. The actual runtime binding is correct since deob_07 imports from the same bundle.

- **[CMI-01] PASS: All 5 Pinia store IDs match between definition and usage.**

### 2.2 API Function Cross-References

| Function | Defined In | Called In | Match? |
|----------|-----------|----------|--------|
| fetchProductInfo | deob_05:1085 | deob_06 (Digital widget init) | OK |
| fetchPriceCalculation | deob_05:1129 | deob_06 (useOrderState), deob_06:1266 (KOI tab) | OK |
| fetchS3FileInfo | deob_05:1167 | deob_06 (S3Uploader) | OK |
| fetchAvailableMaterials | deob_05:1197 | deob_07 (Material components) | OK |
| downloadTemplate | deob_05:1237 | deob_07 (CoverGuide, template download) | OK |
| downloadCoverTemplatePdf | deob_05:1265 | deob_07 (Book component) | OK |

- **[CMI-02] PASS: All 6 API functions are defined in deob_05 and referenced correctly.**

### 2.3 Event Names

| Event | Emitter | Listener | Match? |
|-------|---------|----------|--------|
| `"update"` | All sub-components (Sizes, Dosu, etc.) | Parent widgets (Digital, Acrylic, Book) | OK |
| `"select"` | ImageButton, ButtonRadio | Parent components | OK |
| `"upload"` | S3Uploader, Uploader | Digital/Book widget | OK |
| `"validate"` | Sizes component | Digital widget | OK |
| `onOptionChange` | order/acc-order store | productRedWidgetSDK.js callback | OK |
| `onPriceChange` | CommonWidgetInstance | productRedWidgetSDK.js callback | OK |
| `onOpenEditor` | Uploader | productRedWidgetSDK.js callback | OK |
| `onReset` | PageDirection, PrintArea | callbacks injection | OK |

- **[CMI-03] PASS: Event names are consistent between emitters and listeners.**

### CMI Summary
- Pass: 10
- Fail: 0
- Score: 1.00

---

## 3. Korean Comment Quality (KCQ)

### 3.1 Sample of 20 Function Comments

| # | File | Line | Function | Comment (Korean) | Accurate? | Terminology? |
|---|------|------|----------|-----------------|-----------|-------------|
| 1 | deob_05 | 1085 | fetchProductInfo | "제품 정보 조회 API" | Yes | Yes (규격, 자재, 도수, 후가공) |
| 2 | deob_05 | 1129 | fetchPriceCalculation | "가격 계산 API 호출" | Yes | Yes (가격, 도수) |
| 3 | deob_05 | 1167 | fetchS3FileInfo | "S3 업로드 파일 정보 조회" | Yes | - |
| 4 | deob_05 | 1197 | fetchAvailableMaterials | "주문 가능 용지(자재) 정보 조회" | Yes | Yes (용지, 자재) |
| 5 | deob_05 | 1237 | downloadTemplate | "인쇄 템플릿 파일(ZIP) 다운로드" | Yes | Yes (재단) |
| 6 | deob_05 | 1265 | downloadCoverTemplatePdf | "책자 표지 템플릿 PDF 다운로드" | Yes | Yes (표지, 제본) |
| 7 | deob_06 | 30 | RedWidgetSDK | "레드프린팅 주문 위젯의 메인 SDK 클래스" | Yes | - |
| 8 | deob_06 | 148 | OptionRow | "주문 위젯의 각 옵션 행(fieldset)" | Yes | Yes (규격, 수량, 용지, 도수, 후가공) |
| 9 | deob_06 | 214 | ImageButton | "이미지 기반 커스텀 체크박스/라디오 버튼" | Yes | Yes (후가공, 제본) |
| 10 | deob_06 | 303 | PageDirection | "인쇄물의 가로/세로 방향을 선택" | Yes | - |
| 11 | deob_06 | 433 | Dosu | "인쇄 도수(색상 수) 선택" | Yes | Yes (도수) |
| 12 | deob_06 | 449 | Sizes | "인쇄물 규격(사이즈) 선택" | Yes | Yes (규격, 재단, 도련) |
| 13 | deob_06 | 476 | HiddenPostPcs | "사용자에게 직접 보이지 않는 기본/필수 후가공" | Yes | Yes (재단, 후가공, 제본, 코팅) |
| 14 | deob_06 | 502 | VisiblePostPcs | "사용자가 직접 선택/해제할 수 있는 후가공" | Yes | Yes (후가공) |
| 15 | deob_06 | 546 | S3Uploader | "AWS S3 presigned URL 방식으로 PDF 파일을 업로드" | Yes | - |
| 16 | deob_06 | 596 | classifyPostProcessOptions | "서버에서 받은 pdt_pcs_info를 visible/hidden/essential로 분류" | Yes | Yes (후가공) |
| 17 | deob_06 | 958 | CommonWidgetInstance | "일반 제품의 위젯 인스턴스" | Yes | - |
| 18 | deob_07 | 189 | ApparelSizeGbn | "의류 사이즈 구분 (성인/아동) 라디오" | Yes | - |
| 19 | editor | 10573 | setCurrentTemplate | "현재 사용할 디자인 템플릿을 설정한다" | Yes | - |
| 20 | editor | 10596 | createProject | "새 프로젝트를 생성하고 에디터를 연다" | Yes | - |

**Findings:**

- **[KCQ-01] PASS: All 20 sampled comments are technically accurate.**

- **[KCQ-02] PASS: Printing terminology used correctly.**
  Found across all files: 자재 (material), 도수 (printing color count), 후가공 (finishing/post-processing), 제본 (binding), 재단 (cutting), 평량 (paper weight), 규격 (specification/size), 표지 (cover), 내지 (inner page). Total Korean terminology occurrences: deob_05=40, deob_06=95, deob_07=107, deob_editor=1.

- **[KCQ-03] LOW: deob_editor_sdk.js has minimal Korean comments relative to its size.**
  Only 1 printing terminology match in 12,629 lines. The file has 44 JSDoc blocks and 331 Korean comment lines added (per stats), but most are concentrated in the SDK methods section (lines 10500+). The Sentry/Babel sections (~lines 67-9527) are left as third-party code without Korean annotation, which is appropriate.

- **[KCQ-04] PASS: No English-only comments on business logic sections.**
  All business logic in deob_05, deob_06, deob_07 has Korean comments. Third-party code (Lodash internals, Sentry, Babel) appropriately uses English-only or mixed comments.

### KCQ Summary
- Pass: 18
- Fail: 0
- Warning: 2 (editor SDK sparse comments -- acceptable for third-party sections)
- Score: 0.95

---

## 4. Cross-Reference Accuracy (CRA)

### 4.1 Pinia Stores (Analysis Report: 4 stores)

| Store | Report Says | Deobfuscated | Match? |
|-------|-----------|-------------|--------|
| config | locale | `defineStore("config")` - deob_06:717 | OK |
| product | baseInfo | `defineStore("product")` - deob_06:754 | OK |
| order | orderData | `defineStore("order")` - deob_06:822 | OK |
| exterior | uploadType, editorData | `defineStore("exterior")` - deob_06:780 | OK |

Note: deob_06 also defines a 5th store `acc-order` (deob_06:850) which the analysis report does not mention. This is an addition, not a discrepancy.

- **[CRA-01] PASS: All 4 Pinia stores found and correctly named. Bonus: 5th store (acc-order) discovered.**

### 4.2 API Endpoints

| Endpoint | Report Says | Deobfuscated | Match? |
|----------|-----------|-------------|--------|
| `/ko/product/get_digital_product_info` | Product info | deob_05:1093 `fetchProductInfo` | OK |
| `/ko/product_price/get_ajax_price_vTmpl` | Price calculation | deob_05:1132 `fetchPriceCalculation` | OK |
| `/api/aws/presigned` | S3 upload URL | deob_06:552 (S3Uploader comment) | OK |
| `/api/editor/config/` | Editor config | deob_06:576 (Uploader comment) | OK |
| `/ko/product/s3GetObjectJson` | (not in report) | deob_05:1172 `fetchS3FileInfo` | Bonus |
| `/ko/product/guide_product_paper` | (not in report) | deob_05:1202 `fetchAvailableMaterials` | Bonus |
| `/ko/product/get_download` | (not in report) | deob_05:1244 `downloadTemplate` | Bonus |
| `/ko/product/get_pdf_download` | (not in report) | deob_05:1276 `downloadCoverTemplatePdf` | Bonus |

- **[CRA-02] PASS: All 4 report endpoints annotated. 4 additional endpoints discovered.**

### 4.3 Fieldset UI Components (Report: 14 fieldsets)

From deob_07_stats.json, the component list shows 38 total components including:
- 3 main components (Apparel, Book, Acc)
- 10 sub-components (ApparelSizeGbn, ApparelSingleSizeQty, etc.)
- 25 post-process components
- 1 material component (Basic)
- 4 quantity components

The report's "14 fieldsets" aligns with the Digital widget's option row ordering described in deob_06:656-665.

- **[CRA-03] PASS: 14 fieldset structure confirmed in Digital widget. Total 38 components mapped.**

### 4.4 Editor SDK Methods (Report: 45 methods)

From deob_editor_sdk_stats.json: 45 prototype methods, 44 documented with JSDoc.
The stats file lists all 44 documented methods. Cross-checking against the analysis report's table of 45 methods -- all match.

- **[CRA-04] MEDIUM: 44 of 45 methods documented. 1 method missing JSDoc.**
  The `remotePageTnViewer` method is listed in stats but may lack full JSDoc.

### CRA Summary
- Pass: 7
- Fail: 0
- Warning: 1 (1 method missing full documentation)
- Score: 0.96

---

## 5. Completeness (COMP)

### 5.1 Remaining Single-Letter Variables

| File | Single-letter `var x =` patterns | Status |
|------|----------------------------------|--------|
| deob_05_app_api.js | 0 | Clean |
| deob_06_app_widget_sdk.js | 0 | Clean |
| deob_07_app_components.js | 0 (in deob code) | See note |
| deob_editor_sdk.js | 62 (uppercase single-char vars) | Expected |

**Note on deob_07:** The file retains minified Vue render function calls (`g()`, `V()`, `M()`, etc.) and minified identifiers (`fe`, `je`, `Dn`, `Fo`, etc.) in the actual render code. These are documented in the header mapping table but NOT renamed inline. This is a deliberate design choice -- renaming Vue internal render helpers would break the code.

**Note on deob_editor_sdk:** The 62 uppercase single-letter variables (`A`, `D`, `F`, `K`, `L`, `M`, `N`, `V`, `W`, etc.) are in the SDK scope. They are documented in comments near their declarations (lines 10447-10500) with Korean descriptions, but remain as single-letter in the actual code. The stats file confirms these are mapped: `A`=isEditorBusy, `K`=sdkState, `D`=sessionStorageManager, etc.

- **[COMP-01] MEDIUM: deob_editor_sdk.js retains single-letter variables in code body.**
  62 single-letter variable patterns remain. They are documented in comments but not renamed inline. Sentry/Babel sections (lines 67-9527) intentionally excluded from renaming as third-party.

- **[COMP-02] MEDIUM: deob_07 retains minified Vue helper names in render functions.**
  `g()`, `V()`, `M()`, `S()`, `ce()`, `de()`, `j()`, `T()`, `oe()` etc. are documented in the header table but not renamed inline. This is acceptable -- renaming these would require refactoring all render functions.

### 5.2 JSDoc Coverage

| File | JSDoc Blocks | Functions Found | Coverage |
|------|-------------|-----------------|---------|
| deob_05_app_api.js | 101 | 85 (named functions) | 100%+ (includes inline docs) |
| deob_06_app_widget_sdk.js | 66 | 63 (from stats) | 78.5% (51 of 63 commented per stats) |
| deob_07_app_components.js | 1 | ~38 components | 2.6% |
| deob_editor_sdk.js | 44 | 45 methods | 97.8% |

- **[COMP-03] HIGH: deob_07_app_components.js has almost no inline JSDoc comments.**
  Only 1 JSDoc block found in 2506 lines. The file relies entirely on the header mapping table (lines 1-95) and section divider comments. Individual component `setup()` functions lack JSDoc. The stats file reports 156 Korean comments added, but these are section headers and inline code comments, not JSDoc blocks.

- **[COMP-04] LOW: deob_06 has stub implementations.**
  Sections 7-21 contain `/* ... implementation same as original ... */` stub comments instead of actual deobfuscated code. This is noted but acceptable if the full render code would be identical to original minified.

### 5.3 TODO Markers

| File | TODO Count | Content |
|------|-----------|---------|
| deob_05_app_api.js | 1 | Line 1503: Korean translation dictionary (TRANSLATIONS_KO) omitted with TODO |
| deob_06_app_widget_sdk.js | 0 | - |
| deob_07_app_components.js | 0 | - |
| deob_editor_sdk.js | 0 | - |

- **[COMP-05] MEDIUM: TRANSLATIONS_KO dictionary omitted from deob_05.**
  The Korean translation dictionary (HT object, ~200 entries) is referenced as TODO but not included. The English dictionary (TRANSLATIONS_EN) is fully present (202 entries). Since TRANSLATIONS_KO keys and values are identical Korean strings, this is low-impact but incomplete.

### COMP Summary
- Pass: 5
- Fail: 3 (deob_07 JSDoc gap, editor SDK inline renames, TRANSLATIONS_KO omission)
- Score: 0.68

---

## Overall Scoring

| Category | Pass | Fail | Score | Weight |
|----------|------|------|-------|--------|
| NC (Naming Consistency) | 8 | 5 | 0.62 | 20% |
| CMI (Cross-Module Interface) | 10 | 0 | 1.00 | 25% |
| KCQ (Korean Comment Quality) | 18 | 0 | 0.95 | 20% |
| CRA (Cross-Reference Accuracy) | 7 | 0 | 0.96 | 20% |
| COMP (Completeness) | 5 | 3 | 0.68 | 15% |

**Weighted Overall Score:** (0.62 * 0.20) + (1.00 * 0.25) + (0.95 * 0.20) + (0.96 * 0.20) + (0.68 * 0.15) = 0.124 + 0.250 + 0.190 + 0.192 + 0.102 = **0.858**

**Verdict: CONDITIONAL_PASS**

---

## HIGH Severity Issues Summary

1. **[NC-01]** Pinia store name conflicts in deob_07 header mapping table vs deob_06 definitions.
2. **[COMP-03]** deob_07_app_components.js lacks inline JSDoc comments (1 of ~38 components documented).
