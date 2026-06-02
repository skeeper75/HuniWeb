# huni-db-mapping.md — 후니 DB ↔ 정규화 위젯 계약 적합성 분석

> 파이프라인 ③ 분석 산출물. 진행 중인 후니 DB(`docs/huni/table-spec_260602.html`)와
> 정규화 위젯 계약(`04_build/src/contract/*` 구현 + `03_spec/data-contract.md`)의 적합성 검증 + 후니 어댑터 방향 설계.
> [HARD] 본 패스는 분석만. 코드·스펙 무수정. 계약 변경은 권고로만 제시 — 채택 결정은 오케스트레이터.
> [HARD] 서버 권위 가격 유지 — 위젯은 가격을 불투명 결과로만 취급. Red 워터폴도 `t_prc_` 공식 스키마도 위젯에 포팅하지 않는다.
> 근거 표기: (후니 테이블명) / (계약 파일) / (pricing-rules.md §) / [역공학] / [동작분석].
>
> **⚠ 2026-06-02 개정 — 후니 측 작성 현황 정정.** 이전 분석은 `table-spec_260602.html`의 모든 테이블(가격 `t_prc_*`/`t_dsc_*` 포함)을
> "작성됨"으로 간주했으나 사실이 아니다. 실제 현황은 §0.1 배너 참조. 가격/제약 매핑 행은 모두 **"후니 DB 미작성 — 엑셀 원천"**으로 재표기했다.

---

## 0.1 후니 측 작성 현황 (STATE-OF-AUTHORING — 먼저 읽을 것)

`table-spec_260602.html`은 **스키마 명세 문서**다 — 테이블 정의(컬럼/FK)가 적혀 있다고 해서 그 테이블에 데이터가 채워져
"운영 중"인 것이 아니다. 후니 측의 실제 작성 상태를 구분한다:

| 구분 | 대상 | 상태 | 위젯 계약에 대한 의미 |
|------|------|------|----------------------|
| ✅ **AUTHORED — 상품 마스터** | `t_prd_products`, `t_prd_product_categories`, `t_prd_product_sizes`, `t_prd_product_materials`, `t_prd_product_print_options`, `t_prd_product_processes`, `t_prd_product_process_excl_groups`, `t_prd_product_plate_sizes`, `t_prd_product_page_rules`, `t_prd_product_bundle_qtys`, `t_prd_product_sets`, `t_prd_product_addons`, `t_mat_materials`, `t_siz_sizes`, `t_clr_color_counts`, `t_proc_processes`, `t_cat_categories`, `t_cod_base_codes`, `t_cus_customers` | DB 테이블로 작성됨 (상품·옵션·분류·코드·고객) | **위젯이 NOW 사용 가능** — NormalizedProduct·옵션 차원·componentType·캐스케이드 UI 셸을 이 마스터로 채울 수 있음 |
| 🚧 **NOT-YET-AUTHORED — 가격** | `t_prc_price_formulas`, `t_prc_formula_components`, `t_prc_price_components`, `t_prc_component_prices`, `t_prd_product_prices`, `t_prd_product_price_formulas`, `t_dsc_discount_tables`, `t_dsc_discount_details`, `t_dsc_grade_discount_rates`, `t_prd_product_discount_tables` | **스키마 placeholder만 존재 — 데이터 미작성, 작성 진행 중**. 실제 가격 원천은 **엑셀 가격표** (`pricing-rules.md`, 19시트, 4 가격모델) | **위젯에 영향 없음** — 서버 권위. 위젯은 BFF가 계산한 불투명 `finalPrice`만 수신. 어댑터의 가격 arm이 후니 작성 완료 후 연결 |
| 🚧 **NOT-YET-AUTHORED — 제약** | `constraint_json`(상품 텍스트 컬럼), `excl_groups` 데이터, 자재→공정 disable 규칙 | **미작성** | **위젯에 영향 없음** — 캐스케이드 엔진은 정규화 제약으로 구동. 오늘은 Red fixture가 구동. 어댑터의 제약 population만 대기 |
| 🚧 **NOT-YET-AUTHORED — 위젯 전용** | 위젯 세션/장바구니/주문 등 위젯 특화 테이블 | **미작성** | 커머스 미확정(UNDECIDED)과 동일. 위젯 진행 무관 |

**핵심 함의:** 가격·제약이 후니 DB에 아직 없다는 사실은 **위젯 진행을 막지 않는다.** 이유는 두 가지 —
(1) **서버 권위 가격** — 위젯은 단가/공식을 모르고 BFF가 준 불투명 결과만 표시하므로, 후니가 엑셀→DB 가격을 언제 작성하든 위젯 코드는 불변.
(2) **정규화 계약 + Red fixture** — 위젯은 정규화 계약에만 의존하고 Red fixture가 그 계약을 이미 만족하므로, 후니 상품 마스터가 작성된 지금
상품·옵션·캐스케이드 UI는 곧바로 구현·검증 가능하고, 가격/제약 실데이터는 어댑터 교체 시점에 들어온다.

---

## 0. 결론 요약 (먼저)

| 항목 | 결론 |
|------|------|
| **전체 적합도** | **높음**. 후니 **상품 마스터**(AUTHORED)는 정규화 계약을 충분히 수용. 가격/제약은 미작성이나 서버 권위·정규화 계약 덕에 위젯 진행 무관. 위젯 코드 0 변경으로 Red→후니 어댑터 교체 가능 |
| **가격 적합** | **적합**. 후니 실제 가격은 **엑셀 4 모델**(PriceTable3D / SizeMatrix2D / FixedUnit / TieredDiscount, `pricing-rules.md §16`). 네 모델 + 후가공·제본·수량할인·VAT·배송의 출력(`QuoteResult`)은 모두 `NormalizedPriceBreakdown`(finalPrice + vat + shipping + lines[])으로 평면화 가능. 서버 권위 — BFF가 4모델 중 무엇으로 계산하든 위젯은 불투명 `finalPrice`만 수신 (§2 재검증) |
| **캐스케이드 적합** | **엔진 적합**. 캐스케이드 **엔진**(정규화 제약 구동)은 변경 없음. 후니 제약 데이터가 미작성이므로 어댑터의 제약 population만 대기 — 오늘은 Red fixture로 구동 (§3) |
| **ZERO 위젯 변경** | **달성 가능**. 위젯 가시 계약 변경 **0건 필수**. 어댑터 내부 작업 다수 |
| **NOW 진행 가능 범위** | 후니 상품 마스터로 **NormalizedProduct·옵션 차원·14 componentType 렌더·캐스케이드 UI 셸**을 즉시 구현. 가격 실수치·제약 규칙·위젯 테이블만 후니 작성 대기 (§3.5) |
| **진짜 최상위 블로커** | **후니 측 가격·제약 작성**(엑셀 4모델→BFF, constraint 규칙) — **위젯 설계가 아니라 후니 데이터 작성**이 임계경로. 위젯은 그동안 Red fixture + 상품마스터 정규화 데이터로 무차단 진행 |

---

## 1. 매핑 매트릭스 (계약 필드 → 후니 테이블·컬럼)

### 1.1 NomalizedProduct (`contract/product.ts`)

| 계약 필드 | 후니 출처 | 변환/비고 |
|-----------|----------|----------|
| `code` | `t_prd_products.prd_cd` ✅AUTHORED | 그대로 (불투명) |
| `name` | `t_prd_products.prd_nm` ✅AUTHORED | 그대로 |
| `unit` | (DB에 상품 단위 컬럼 없음) → `t_prd_product_bundle_qtys.bdl_unit_nm` 또는 `t_cod_base_codes`(prd_typ_cd 파생) ✅AUTHORED | **갭 G6** — Red `PDT_UNIT` 대응 직접 컬럼 없음. 어댑터가 묶음단위명/코드테이블에서 파생 |
| `priceSchemeKey` | `t_prd_product_price_formulas.frm_cd` 🚧**미작성 — 엑셀 원천** | 불투명 echo. 가격공식 미작성이므로 임시로 상품군→4모델 분류 키(category prefix `001~012`)를 echo. 위젯은 의미 모름 |
| `sides` | `t_prd_products.prd_typ_cd`/`semi_role_cd` + `t_prd_product_sets`(표지/내지 분해) | 책자=세트구조면 `[default,inner]`. **갭 G2** 참조 |
| `optionGroups` | size/print_options/materials/processes 테이블군 | §1.2 컴포넌트 매핑 |
| `constraints` | §1.3 | |
| `editors` | `t_prd_products.editor_yn` (단일 플래그) | **부분 갭** — Red는 koi/rp/pdf 3분기. 후니는 `editor_yn`/`file_upload_yn` 2플래그만. 어댑터가 `{koi: editor_yn==='Y', rp:false, pdf: file_upload_yn==='Y'}` 로 매핑(파트너=Edicus 단일 가정) |
| `cta` | `editor_yn`/`file_upload_yn` + DESIGN 부록A | 어댑터 파생 (Red와 동일 방식) |

### 1.2 옵션 그룹 (componentType 매핑)

> 아래 옵션 그룹은 모두 ✅**AUTHORED 상품 마스터** 출처 — **위젯이 NOW 렌더 가능.** (가격 단가는 별개로 미작성, §1.5)

| 정규화 OptionGroup | 후니 출처 테이블 | componentType | 비고 |
|-------------------|----------------|---------------|------|
| 규격(size) | `t_prd_product_sizes` ⋈ `t_siz_sizes` ✅ | `option-button` | `dflt_yn`→기본선택, `disp_seq`→순서. 비규격은 §1.4 |
| 판형(plate) | `t_prd_product_plate_sizes` ⋈ `t_siz_sizes` ✅ | `select-box`/`option-button` | 출력판형 선택(있으면). Red엔 없던 차원 — 어댑터가 별도 그룹화 |
| 용지(material) | `t_prd_product_materials` ⋈ `t_mat_materials` ✅ | `select-box` (값多) / `image-chip`(이미지有) | `use_loc`로 표지/내지 side 분기. `sel_typ`/`max_sel_cnt`→`multiple` |
| 인쇄도수(print) | `t_prd_product_print_options` ⋈ `t_clr_color_counts` ✅ | `option-button` | front/back 도수. `chnl_cnt`→`priceColorCount`(평면화). §1.3-③ |
| 후가공(process) | `t_prd_product_processes` ⋈ `t_proc_processes` ✅ | `finish-button` / `color-chip`(색상有) | `t_proc_processes.prcs_dtl_opt`(text)에 색상값 있으면 color-chip. 택일그룹 §1.3-① |
| 수량(quantity) | `t_prd_products.min/max/dflt_qty,qty_incr` + `t_prd_product_bundle_qtys` ✅ | `counter-input` | InputSpec. 묶음수 별도 그룹 가능 |
| 내지페이지 | `t_prd_product_page_rules.page_min/max/incr` ✅ | `page-counter-input` | 책자 InputSpec |
| 박/형압 크기 | `t_proc_processes.prcs_dtl_opt`(JSON) ✅ | `area-input` | **미명세 G3** — 가로×세로 mm 입력 파라미터의 위치 불명확 |

> 후니 옵션 마스터는 데이터셋 "이름"이 아니라 **테이블 종류**로 구분된다 → 어댑터 룩업 테이블은
> `{테이블종류 → componentType}` 로 작성(Red의 `DATASET_COMPONENT_TYPE`과 동일 패턴, 키만 후니 테이블명).
> 색상 분기(`pcsComponentType(hasColor)`)는 `t_proc_processes.prcs_dtl_opt`에 색상값 존재 여부로 동일 판정.

### 1.3 캐스케이드 제약 (6종)

> **작성 현황 주의:** 캐스케이드 **엔진**은 위젯 내부에서 정규화 제약으로 구동되며 변경 없음(오늘 Red fixture 구동).
> 아래 "후니 출처"는 어댑터가 후니 제약 데이터를 어디서 채울지의 매핑이다. ②③④⑥의 입력(수량/도수/사이즈 차원)은
> 상품 마스터 ✅AUTHORED에서 나오지만, ① disable 규칙·⑤ visible 분류 같은 **제약 규칙 데이터는 🚧미작성**이다.

| 계약 (cascade §0 6종) | 후니 출처 | 작성 | 적합 |
|----------------------|----------|------|------|
| ① material→pcs disable (`disableRules`) | 규칙 데이터 🚧**미작성**. 작성 시 후보: `t_prd_product_materials.dep_proc_cd`(역방향 종속) / `constraint_json` | 🚧 | △ **파생 필요 G1** — 오늘 Red fixture로 엔진 검증 |
| ② quantity (`quantity`) | `t_prd_products.min/max/dflt_qty,qty_incr` + `t_prd_product_page_rules` ✅ | ✅ | ○ 직접 |
| ③ dosu↔bnc → `priceColorCount` 평면화 | `t_clr_color_counts.chnl_cnt`(채널수=색상수) ✅ | ✅ | ○ 직접. 표지/내지는 print_options front/back로 분리 |
| ④ size (`sizeRules`) | `t_siz_sizes.cut_width/height,work_width/height` ✅ | ✅ | ○ 직접 (Red CUT/WRK 1:1) |
| ⑤ pcs essential/hidden → `required/visible` 평면화 | 필수=`t_prd_product_processes.mand_proc_yn` ✅ + 택일그룹 `mand_yn` ✅. **단 hidden(VIEW_YN=N) 분류 데이터 🚧미작성** | 부분 | ○ 필수=mand. hidden 분류는 §1.3-주2 |
| ⑥ base (`base`) | `t_siz_sizes`(여백/마진) + `t_prd_products.nonspec_*` ✅ | ✅ | ○ 직접 (cutMargin은 size 여백 합산 파생) |

**주1 — ① disable 파생 (G1, 가장 중요) — 단, 제약 데이터는 🚧미작성:**
현재 후니에는 "자재 선택 시 특정 후가공 비활성" **규칙 데이터 자체가 아직 없다**(constraint_json·excl_groups 데이터 미작성).
작성될 경우 후보 메커니즘은 두 가지다:
- `t_prd_product_materials.dep_proc_cd` = "이 자재는 이 공정에 **종속**" (자재↔공정 의존)
- `t_prd_product_process_excl_groups` = "이 공정들은 **택일**(mutual-exclusion)"

후니의 의도는 Red의 "disable"과 **방향이 다를** 수 있다(Red는 명시적 disable 목록, 후니는 종속·택일 그래프).
→ 후니 작성 후 어댑터가 그래프를 Red식 `DisableRule[]`로 **파생**하거나, `constraint_json`(text)에 명시적 disable 규칙을 담는 게 가장 단순(**권고 R1**).
**중요:** 이 데이터가 미작성이라는 사실은 **위젯을 막지 않는다** — 캐스케이드 disable **엔진**은 정규화 `DisableRule[]`만 소비하고,
오늘은 **Red fixture가 그 규칙을 제공**하여 엔진을 완전히 구동·검증한다. 후니 어댑터의 제약 population만 후니 작성 완료 후 연결된다.
위젯 계약(`DisableRule`)은 변경 불필요 — 어댑터 내부 파생으로 흡수.

**주2 — ⑤ hidden essential (VIEW_YN=N):**
Red는 `ESN_YN=Y & VIEW_YN=N` = "필수이나 UI 미표시, 자동적용"(예: 재단 CUT_DFT). 후니에는
`mand_proc_yn`(필수)만 있고 "표시여부" 컬럼이 없다. 후니의 의도는 모든 공정을 사용자에게 노출하거나,
필수공정은 항상 자동포함일 수 있다. → 어댑터가 `visible`를 `mand_proc_yn==='Y' && (자동공정 분류)`로
결정. 자동공정 분류 근거가 DB에 없으면 `constraint_json` 또는 `t_cod_base_codes`(공정유형)로 판정.
**갭 G5** — DB가 visible 플래그를 제공하지 않음. 계약은 변경 불필요(어댑터가 visible 계산).

### 1.4 비규격(nonspec) 치수 (G3)

`t_prd_products.nonspec_yn='Y'` + `nonspec_width_min/max,nonspec_height_min/max` 는 자유치수 입력 상품.
계약의 `BaseRule.{minCutW,minCutH,maxCutW,maxCutH,nonStandardAllowed}` + `OptionGroup.inputSpec(axis2)`
(area-input)로 표현 가능. **단 현재 어댑터/계약에 "nonspec → area-input 그룹 생성" 경로가 명세되어
있지 않다**(Red 캡처에 nonspec 상품이 없었음). 위젯 계약(`InputSpec.axis2`, `BaseRule`)은 이미 존재 →
어댑터가 nonspec 상품일 때 area-input OptionGroup을 1개 생성하면 됨. 위젯 변경 0.

### 1.5 가격 (`contract/price.ts`) — 🚧 후니 DB 미작성, 엑셀 4모델이 실원천

> [HARD] **후니 가격 DB(`t_prc_*`/`t_dsc_*`)는 스키마 placeholder만 — 데이터 미작성.** 실제 가격 원천은 **엑셀 가격표**다
> (`pricing-rules.md`, 19시트). 따라서 본 표의 "후니 출처"는 **엑셀 4모델 기준**으로 재작성한다. `t_prc_` 공식 스키마는 후니가
> 향후 작성할 수 있는 한 형태일 뿐이며, **위젯에는 어느 쪽도 포팅하지 않는다**(서버 권위, 불투명 결과). 가격 모델 4종은 `pricing-rules.md §16`.

| 계약 필드 | 실제 원천 (엑셀 4모델) | 작성 | 비고 |
|-----------|------------------------|------|------|
| (Request) `productCode` | `prd_cd` ✅ | ✅ | echo |
| (Request) `priceSchemeKey` | 상품군→4모델 매핑 키 (category prefix `001~012`) — `pricing-rules.md §1` 시트분류 | 🚧 | 불투명 echo. BFF가 "이 상품이 어느 가격모델인지" 판별에 사용 |
| (Request) `customerTier` | 등급할인(`t_dsc_grade_discount_rates` 또는 엑셀 등급정책) | 🚧 | 불투명. 미작성 시 기본 어댑터가 빈값 |
| (Request) `dimensions/colorCounts/materials/quantity/pageCount/selectedFinishes` | 위젯 선택 상태 그대로 (8축 옵션모델 `pricing-rules.md §2`) | ✅(입력) | 4모델 어느 것이든 계산 입력 |
| (Response) `finalPrice` | **BFF가 4모델 중 해당 모델로 계산한 결과** = `QuoteResult.total`(또는 subtotal) (§2 재검증) | 🚧 | BFF 계산, 위젯 불투명 |
| (Response) `vat` | `QuoteResult.vatAmount`(VAT 포함가에서 10/110 분리, `pricing-rules.md §15.1`) | 🚧 | 위젯은 표시만 |
| (Response) `shipping` | `QuoteResult.deliveryFee`(`pricing-rules.md §15.2` 배송정책 — 미정 D-PM-16) | 🚧 | **갭 G7** — 배송정책 미확정. 어댑터가 0 또는 정책 적용 |
| (Response) `lines[]` | `QuoteResult.breakdown[]` (axis: base/paper/ink/finish/binding/option/discount/delivery) | 🚧 | **8 라인종류 직접 대응** (§2.2 검증). 후가공·제본·옵션·할인·배송 모두 별 행 |

---

## 2. 가격 적합성 (핵심 검증 — 후니 실제 4모델 기준 재검증)

> ⚠ **개정 사유:** 이전 §2는 후니 가격을 `t_prc_` 공식+구성요소 3층 스키마로 가정했다. 그러나 그 스키마는 **placeholder(미작성)**이고,
> 후니의 **실제 가격은 엑셀 가격표의 4 모델**이다(`pricing-rules.md §16`). 따라서 적합성은 **4모델 + `QuoteResult` 분해** 기준으로 재검증한다.

### 2.1 후니 실제 가격 = 4 모델 (`pricing-rules.md §16`)

상품군에 따라 네 가지 가격모델 중 하나가 적용된다(BFF가 productCode prefix로 분기):

| 모델 | 계산식 (요지) | 적용 상품군 (`pricing-rules.md`) |
|------|--------------|-----------------------------------|
| **PriceTable3D** | (수량밴드 × inkType × 단/양면) 룩업 단가 × 수량 | 디지털인쇄·코팅·명함 §3·§4·§5 |
| **SizeMatrix2D** | (가로 × 세로) bilinear 보간 셀 | 포스터사인·아크릴 §7·§8 |
| **FixedUnit** | unitPrice × ceil(수량 / step) | 타투스티커·스티커팩 §6.3 |
| **TieredDiscount** | unitPrice × 수량, 수량구간 %할인 적용 | 굿즈·파우치·문구·말랑 §9 |

여기에 공통으로 더해지는 항목: 후가공 합산(`finishPrice` §10), 제본(`bindingPrice` §11), 수량할인(`quantityDiscount` §8.4/§9),
VAT(포함가에서 분리 §15.1), 배송비(`deliveryFee` §15.2). 통합 출력은 `QuoteResult`(`pricing-rules.md §16.1`):

```
QuoteResult { basePrice, finishPrice, optionPrice, bindingPrice,
              quantityDiscount, subtotal, vatAmount, deliveryFee, total, breakdown[] }
breakdown: LineItem{ axis: base|paper|ink|finish|binding|option|discount|delivery, label, amount, formula? }
```

Red의 `ORD_INFO + PCS_INFO` 3단 워터폴과도, `t_prc_` 공식 스키마와도 다르다. **위젯은 셋 중 무엇도 알지 못한다** — 서버 권위가 모두 흡수.

### 2.2 적합 결론: NormalizedPriceBreakdown은 4모델 + QuoteResult를 모두 표현한다

서버 권위 설계가 "어느 모델인지"를 위젯에서 완전히 가린다:

- 위젯은 `NormalizedPriceRequest`(8축 옵션 선택 상태)만 보낸다 — 4모델·단가·할인·VAT·배송 산식을 전혀 모름. ✅
- **BFF(후니 어댑터)**가 `calculateQuote(input)`을 실행 → `QuoteResult` 산출(4모델 분기 포함). ✅
- 어댑터가 `QuoteResult` → `NormalizedPriceBreakdown` 평면화:

| QuoteResult 필드 | → NormalizedPriceBreakdown | 캐리 가능? |
|------------------|---------------------------|-----------|
| `total` | `finalPrice` (또는 subtotal — §2.3 결정) | ✅ |
| `vatAmount` | `vat` | ✅ |
| `deliveryFee` | `shipping` | ✅ |
| `breakdown[]` (8 axis) | `lines[]` (PriceLine{code,label,amount}) | ✅ — axis→code, label→label, amount→amount |
| `basePrice/finishPrice/optionPrice/bindingPrice/quantityDiscount/subtotal` | (개별 필드 아닌 `lines[]`의 행으로 표현) | ✅ — 모두 lines 행으로 분해 |

**`lines[]`가 8 라인종류를 모두 커버하는가? — YES.** `PriceLine`은 `{code, label, amount}` 3필드 구조(가장 일반).
`QuoteResult.breakdown[]`의 8 axis(base/paper/ink/finish/binding/option/discount/delivery)는 각각 1개 이상 `PriceLine` 행으로 매핑된다:
어댑터가 `lines.push({ code: item.axis, label: item.label, amount: item.amount })`. 할인(discount)은 음수 amount, 배송(delivery)은 별 행.
→ **계약의 `lines[]`는 4모델 어느 것의 분해도, 그리고 후가공·제본·옵션·할인·배송 line item을 모두 담는다.** 누락 필드 없음.

**4모델 차이가 위젯에 새는가? — NO.**
- PriceTable3D의 (수량밴드×ink×side), SizeMatrix2D의 (가로×세로), FixedUnit의 step, TieredDiscount의 구간%는 **전부 BFF 내부 계산**.
- 위젯이 보내는 8축 입력(`dimensions/colorCounts/materials/quantity/pageCount/selectedFinishes`)은 4모델 **공통 입력**이며, 모델별로
  BFF가 필요한 차원만 골라 쓴다. 위젯은 어느 차원이 어느 모델에 쓰이는지 모른다. ✅
- 결과는 항상 `finalPrice` 단일값 + `lines[]` 분해 — 모델 종류와 무관하게 동일 형태. ✅

### 2.3 캐리 가능성 점검 — 갭 후보 (계약이 못 담는 것?)

| QuoteResult/4모델 산물 | NormalizedPriceBreakdown 수용 | 판정 |
|------------------------|------------------------------|------|
| 4모델 최종금액 | `finalPrice` 단일값 | ✅ |
| VAT 분리값 | `vat` | ✅ |
| 배송비 | `shipping` | ✅ |
| base/paper/ink/finish/binding/option/discount/delivery 8 라인 | `lines[]`(가변 길이 행) | ✅ — 8종 모두 행으로 |
| `LineItem.formula?`(사람 읽는 산식, 예 "단가 70 × 1000") | `PriceLine`에 **formula 필드 없음** | ⚠ **미세 갭 GP-1** — 산식 문자열을 표시하려면 `label`에 합쳐 담거나 PriceLine에 optional `formula?` 추가. DESIGN Summary가 산식 노출을 요구하지 않으면 무시 가능 |
| `subtotal`(VAT 포함 부분합계) vs `total`(배송포함) | `finalPrice` 1개 슬롯 | ⚠ **결정 GP-2** — `finalPrice`가 "결제금액(부가세 별산 전)"으로 주석됨(price.ts:38). 배송 포함/제외 의미를 어댑터가 명확히(통상 배송은 `shipping`에 별산하고 finalPrice=subtotal). 계약 변경 불요, 어댑터 규약만 |

→ **결론:** 두 갭(GP-1 산식 문자열, GP-2 finalPrice 의미)은 **선택적·어댑터 규약 수준**이며 위젯 가시 계약 변경을 강제하지 않는다.
산식 노출이 DESIGN 요구사항이면 GP-1만 `PriceLine.formula?` 1필드 추가 검토(권고 R4, 미채택 권장 — label에 병기로 해결 가능).

### 2.4 단가 차원 vs 정규화 요청 (id 룩업 점검 — 4모델 공통)

4모델 계산에 필요한 차원이 정규화 요청에서 어댑터로 전달 가능한지:

| 필요 차원 | 정규화 요청 출처 | 가능? |
|-----------|-----------------|-------|
| size id (PriceTable3D 판수/SizeMatrix2D 가로세로) | `dimensions[].cutW/cutH` 수치 (또는 SizeMatrix2D는 수치 그대로 사용) | △ PriceTable3D는 size→판수 매핑에 id 필요 → 어댑터 역매핑. SizeMatrix2D는 수치 직접 사용 ✅ |
| inkType / 색상수 | `colorCounts[side]`(숫자) | △ 숫자→inkType 역매핑(어댑터, 후니 도수정의 보유) |
| material | `materials[side]` | ✅ 불투명 id 그대로 |
| 단/양면 | `dimensions` side 수 또는 colorCounts 키 | ✅ |
| 후가공/옵션 | `selectedFinishes` | ✅ |
| 수량/수량구간 | `quantity` | ✅ |

**점검 결과 — 권고 R2 (선택적, 위젯 가시):** PriceTable3D의 size→판수, 숫자→inkType 룩업을 위해 어댑터가 id를 필요로 할 수 있다.
- 옵션 A (권장, 위젯 무변경): 어댑터가 수치/숫자→id 역매핑(BFF가 상품 마스터 ✅AUTHORED 보유하므로 무비용). 위젯 변경 0.
- 옵션 B (위젯 가시 변경): 요청에 `selectedOptions` 추가하여 id echo. → **계약 1필드 추가, 미권장**.

→ **단순성 우선 옵션 A 권장.** 위젯 0 변경.

---

## 3. 캐스케이드 적합 결론

> **재강조 — 캐스케이드 엔진은 후니 제약 작성과 무관.** 위젯의 캐스케이드 규칙 **엔진**은 정규화 제약(`DisableRule[]`/Quantity/Size/Base)만
> 소비한다. 후니의 제약 데이터(disable 규칙·excl_groups·visible 분류)는 🚧미작성이지만, **오늘은 Red fixture가 그 정규화 제약을 제공**하여
> 엔진을 완전히 구동·검증한다. 후니 어댑터의 제약 population만 후니 작성 완료 후 연결되며, 위젯 코드는 불변이다.

- **입력 차원 5/6 직접(✅AUTHORED)**: quantity, dosu↔color, size, base, essential(필수) 차원은 상품 마스터 테이블에 직접 대응(작성됨).
- **1/6 disable 규칙(G1, 🚧미작성)**: material→pcs disable 규칙 데이터가 아직 없다. 작성 시 종속(`dep_proc_cd`)+택일(`excl_groups`)
  그래프 또는 `constraint_json`에서 파생(권고 R1). **오늘은 Red fixture의 disable 규칙으로 엔진 검증.**
- **택일그룹은 보너스**: `t_prd_product_process_excl_groups`(sel_typ, max_sel_cnt, mand_yn) 스키마는 작성됨. 데이터 작성 시
  → **권고 R3**: 택일그룹을 `OptionGroup.multiple=false` + 동일 그룹으로 묶어 표현. **위젯 계약 변경 불필요**(이미 `multiple` 플래그 존재, `product.ts:58`).

**캐스케이드 위젯 코드 변경: 0건.** 모든 차이는 어댑터 파생/그룹화로 흡수. 제약 데이터 미작성은 어댑터 population만 대기.

---

## 3.5 위젯 진행 범위 — NOW vs 후니 작성 대기 (핵심 의사결정)

> "후니 가격·제약이 미작성"이라는 현황이 위젯 진행을 막는지에 대한 명시적 답.

### 위젯이 NOW 구현·검증 가능 (후니 상품 마스터 ✅AUTHORED + Red fixture)

| 영역 | 근거 | 데이터 소스 |
|------|------|------------|
| `NormalizedProduct` 조립 (code/name/unit/sides/editors/cta) | 상품 마스터 작성됨 | 후니 `t_prd_products` + Red fixture |
| 옵션 차원 (size/material/print/process/quantity/page/plate) | 옵션 마스터 테이블 작성됨 | 후니 옵션 테이블 + Red fixture |
| 14 componentType 렌더 (option-button/select-box/color-chip/area-input/page-counter 등) | DESIGN.md 14종 ↔ 옵션 종류 매핑 확정 | 정규화 OptionGroup |
| 캐스케이드 UI 셸 + 엔진 (disable/required/visible 반영, 면별 분기) | 엔진은 정규화 제약만 소비 | Red fixture 제약 (후니 제약 미작성이어도 무차단) |
| 가격 표시 UI (`NormalizedPriceBreakdown` 렌더 — finalPrice/vat/shipping/lines) | 계약 형태 확정, 서버 권위 | Red fixture 가격 응답 (mock BFF) |
| 옵션 상태관리·셀렉터·debounce 가격요청 조립 | 8축 입력 계약 확정 | 정규화 계약 |

### 후니 작성 완료를 기다리는 것 (위젯 진행을 막지 않음)

| 영역 | 대기 사유 | 위젯 영향 |
|------|----------|----------|
| **실제 가격 수치** (BFF 4모델 계산) | 후니가 엑셀→`t_prc_/t_dsc_` 작성 또는 BFF가 엑셀 4모델 직접 구현 중 | **0** — 위젯은 불투명 `finalPrice`만 표시. mock→실BFF 교체는 어댑터 일 |
| **제약 규칙** (disable/excl/visible 데이터) | 후니 `constraint_json`/excl_groups 데이터 미작성 | **0** — 엔진은 Red fixture 제약으로 구동. 어댑터 population만 교체 |
| **위젯 전용 테이블** (세션/장바구니/주문) | 커머스 UNDECIDED | **0** — 위젯 범위 밖 |

### 결론 (확정)

**가격·제약 미작성은 위젯 진행을 0% 막는다.** 두 안전장치 때문 —
(1) **서버 권위** → 가격 산식이 위젯에 없으므로 후니가 언제 작성하든 위젯 불변.
(2) **정규화 계약 + Red fixture** → 위젯은 계약에만 의존, Red fixture가 계약을 이미 만족 → 상품·옵션·캐스케이드·가격표시 UI를 지금 완성.
위젯은 **Red fixture + 후니 상품마스터-shape 정규화 데이터**로 진행하고, **후니 어댑터의 가격 arm**(BFF 4모델 결과 매핑)·**제약 arm**(constraint population)을 후니 작성 완료 시점에 교체한다. **위젯 코드 무변경.**

---

## 4. 후니 어댑터 설계 (`adapters/huni/` — 구체화)

5개 인터페이스(`adapters/types.ts`) 각 메서드가 읽는 후니 테이블:

```
HuniProductAdapter.getProduct(prd_cd):
  t_prd_products                      → code/name/unit(파생)/editors/cta/nonspec(BaseRule)
  t_prd_product_categories ⋈ t_cat_categories → (분류 메타, 선택)
  t_prd_product_sizes ⋈ t_siz_sizes   → 규격 OptionGroup + sizeRules(cut/work)
  t_prd_product_plate_sizes ⋈ t_siz_sizes → 판형 OptionGroup(있으면)
  t_prd_product_materials ⋈ t_mat_materials → 용지 OptionGroup(use_loc로 side분기, sel_typ→multiple)
  t_prd_product_print_options ⋈ t_clr_color_counts → 도수 OptionGroup(chnl_cnt→priceColorCount)
  t_prd_product_processes ⋈ t_proc_processes → 후가공 OptionGroup(finish/color-chip)
  t_prd_product_process_excl_groups   → 택일그룹 → 동일 OptionGroup 묶기(R3) + required(mand_yn)
  t_prd_product_materials.dep_proc_cd → DisableRule[] 파생(G1/R1)
  t_prd_product_page_rules            → 내지 page-counter InputSpec
  t_prd_product_bundle_qtys           → 묶음수 OptionGroup/단위
  t_prd_products.constraint_json      → 보조 제약(disable 명시 시 우선)

HuniPriceAdapter.quote(NormalizedPriceRequest):   // 🚧 가격 데이터 미작성 — 후니 작성 완료 시 연결
  // 실원천 = 엑셀 4모델 (pricing-rules.md §16). t_prc_/t_dsc_ 는 placeholder.
  // BFF가 calculateQuote(input) 실행 → QuoteResult:
  //   1. productCode prefix(001~012) → 4모델 분기 (PriceTable3D|SizeMatrix2D|FixedUnit|TieredDiscount)
  //   2. 모델별 단가 룩업 (수량밴드×ink×side / 가로×세로 bilinear / step / 구간) → basePrice
  //   3. finishPrice(§10) + bindingPrice(§11) + optionPrice(§8.5) 합산
  //   4. quantityDiscount(§8.4/§9 구간%) + 등급할인 적용
  //   5. subtotal → VAT 분리(§15.1) → deliveryFee(§15.2, G7) → total
  //   6. QuoteResult → NormalizedPriceBreakdown 평면화:
  //      finalPrice ← total(or subtotal, GP-2), vat ← vatAmount, shipping ← deliveryFee,
  //      lines[] ← breakdown[] (8 axis: base/paper/ink/finish/binding/option/discount/delivery)
  //   ※ 후니가 향후 t_prc_/t_dsc_ 를 작성하면 위 룩업이 엑셀→DB로 교체될 뿐 출력 형태는 동일.
  //   ※ 오늘은 mock BFF가 Red fixture 가격응답을 반환 → 위젯 가격표시 UI 검증.

HuniUploadAdapter.issuePresigned: 후니 스토리지(S3/GCS) presigned. DB 무관(인프라 설정)
HuniEditorAdapter.getConfig: .env.local EDICUS_PARTNER_CODE → 토큰발급 → NormalizedEditorConfig. DB 무관
HuniCartAdapter.handoff: [UNDECIDED] — Shopby 제외. 커머스 확정 시 내부만 구현. 위젯·계약 무관
```

**시계열(`apply_ymd`) 처리는 전적으로 어댑터 책임(G8) — 단 후니 가격 작성 이후에 한함:** 후니가 `t_prc_/t_dsc_`를
작성할 경우 모든 `*_prices`/`discount_details`/`grade_discount_rates`가 `apply_ymd` 시계열이 된다. 그때 어댑터가
"기준일 ≤ apply_ymd 중 최신" 행을 선택. 현재 엑셀 단계에서는 단일 가격표라 시점 개념이 없다. 위젯은 어느 쪽도 모름 → 계약 변경 불필요.

---

## 5. 위젯 코드 변경 평가 (ZERO 목표)

| 영역 | 위젯 가시 계약 변경 | 어댑터 내부 작업 |
|------|---------------------|-----------------|
| Product/옵션 그룹 | **0** (componentType·OptionGroup 그대로) | 후니 테이블→OptionGroup 매퍼 작성, componentType 룩업(후니 테이블명 키) |
| 캐스케이드 6종 | **0** (DisableRule/Quantity/Size/Base 그대로, multiple 기존 필드) | disable 파생(G1), 택일 그룹화(R3), visible 계산(G5) |
| 가격 | **0** (NormalizedPriceRequest/Breakdown 그대로) | BFF 4모델 `calculateQuote`→`QuoteResult` 평면화(R2 옵션A: 수치→id 역매핑). 🚧후니 가격 작성 대기 |
| 업로드/에디터 | **0** | presigned/토큰 인프라 교체 |
| 장바구니 | **0** (UNDECIDED 유지) | 커머스 확정 시 handoff 내부 |

**ZERO 위젯 변경 = 달성 가능 (확정).** 필수 위젯 가시 계약 변경 **0건**.

선택적 위젯 가시 변경 후보(**채택 불요, 단순성 우선 미채택 권장**):
- R2 옵션B: `NormalizedPriceRequest`에 `selectedOptions?` 추가(어댑터 역매핑 회피용). → **미권장**. 어댑터가
  product 마스터 보유하므로 역매핑은 서버측에서 무비용. 위젯 계약 오염 회피가 더 가치 있음.

→ **결론: 정규화 계약은 후니 DB를 위젯 무변경으로 수용한다. 키스톤(계약+어댑터) 가설 검증 성공.**

---

## 6. 갭 & 오픈 퀘스천 (사용자 확인 필요)

> **개정 — 진짜 블로커는 후니 측 데이터 작성이지 위젯 설계가 아니다.** 갭을 (A) 후니 작성 임계경로 / (B) 위젯 진행과 무관한
> 어댑터 세부 로 재분류한다. (A)는 위젯이 *최종 통합* 전 후니가 끝내야 할 일, (B)는 위젯이 지금 Red fixture로 우회 가능.

### 6.1 (A) 후니 측 작성 — 위젯 *최종 통합*의 임계경로 (위젯 *개발*은 무차단)

| ID | 블로커 | 영향 | 권고 |
|----|--------|------|------|
| **B1 (최상위)** | **후니 가격 작성** — 엑셀 4모델을 BFF에 구현(또는 `t_prc_/t_dsc_` DB 작성). 현재 placeholder | 실가격 통합 시점 | BFF가 `calculateQuote`(4모델, `pricing-rules.md §16`)를 권위 구현. 위젯은 mock→실BFF 교체만 (어댑터 일) |
| **B2** | **후니 제약 작성** — disable/excl_groups/visible 규칙 데이터. 현재 미작성 | 캐스케이드 실데이터 시점 | `constraint_json`에 disable 규칙 적재(R1) 또는 종속/택일 그래프 파생. 오늘은 Red fixture로 엔진 검증 |
| **B3** | 배송정책 확정(D-PM-16, `pricing-rules.md §15.2`) — 무료기준/기본료/제주/도서산간 | `shipping` 값 | 정책 확정 후 BFF deliveryFee 계산. 위젯 무관(불투명) |

### 6.2 (B) 어댑터 세부 — 위젯 진행과 무관 (후니 작성 시 해소)

| ID | 갭/질문 | 영향 | 권고 |
|----|---------|------|------|
| **G1** | 자재→공정 disable 규칙 데이터 형태(constraint_json vs 종속/택일 그래프) | 캐스케이드 ① population | R1: `constraint_json` 적재가 가장 단순. 위젯 엔진은 Red fixture로 선검증 |
| **G2** | 책자 표지/내지가 `t_prd_product_sets`(세트)인지 단일 상품 side 분리인지 | sides/내지 옵션 | 책자 모델링 확인. 위젯 ProductSide 계약은 양쪽 수용 |
| **G3** | 박/형압 가로×세로 mm 입력이 `prcs_dtl_opt`(text) 어디에 있는지 | area-input 옵션 | `prcs_dtl_opt` JSON 스키마 확인. 위젯 area-input 계약 준비됨 |
| **G4** | nonspec 자유치수→area-input 생성 경로(Red 캡처에 부재) | 비규격 상품 | 어댑터 nonspec→area-input 규칙 추가(계약 이미 지원, `pricing-rules.md §16.1 size.custom`) |
| **G5** | 공정 visible(VIEW_YN) 분류 데이터 없음 | hidden essential 자동적용 | 후니 자동공정 구분법 확인. 위젯 visible 계약 준비됨 |
| **G6** | 상품 단위(`unit`) 직접 컬럼 없음 | 표시용 unit | `bdl_unit_nm`/`prd_typ_cd` 파생(`pricing-rules.md §14` 단위정책 D-PM-14) |
| **G9** | 세트/애드온 상품을 위젯이 다루는가 | 상품 범위 | 현 계약은 단일 상품 견적. 세트/애드온은 미스코프(추후) |
| **GP-1** | `QuoteResult.LineItem.formula?`(산식 문자열)를 `PriceLine`이 못 담음 | 가격 투명성 표시 | label 병기로 해결. DESIGN 요구 시에만 R4 검토 |
| **GP-2** | `finalPrice`가 subtotal(배송제외) vs total(배송포함) 어느 쪽인지 | 가격 표시 의미 | 어댑터 규약: `finalPrice`=subtotal(부가세별산 전), 배송은 `shipping` 별산. 계약 변경 불요 |

---

## 7. 권고 요약 (오케스트레이터 결정 대상)

| 권고 | 내용 | 위젯 가시? | 단순성 판정 |
|------|------|-----------|------------|
| **R1** | 자재→공정 disable을 `constraint_json`에 명시 적재(파생보다 명료) — 후니 작성 시 | No (어댑터/DB) | ✅ 권장 |
| **R2** | 가격 단가 차원의 size/inkType id 확보 — **옵션A(어댑터 역매핑, 위젯 무변경)** 채택 | No | ✅ 옵션A 권장 |
| **R3** | 택일그룹을 단일 OptionGroup(`multiple=false`)으로 그룹화 — 위젯 계약 이미 지원 | No | ✅ 권장 |
| **R4** | (조건부) 산식 노출 필요 시 `PriceLine.formula?` 1필드 추가 (GP-1) | Yes | △ DESIGN 요구 시에만. 기본 미채택(label 병기) |
| (미채택) | `NormalizedPriceRequest.selectedOptions` 추가(R2 옵션B) | Yes | ✗ 미권장 (계약 오염) |

---

## 8. 다음 단계 권고 (개정)

**핵심 인식: 임계경로는 후니 측 가격·제약 작성(B1/B2)이지 위젯 설계가 아니다. 위젯은 그동안 무차단 진행한다.**

1. **위젯은 NOW 진행** — 후니 상품마스터-shape 정규화 데이터 + Red fixture로 §3.5 "NOW 가능" 범위(NormalizedProduct·옵션 차원·
   14 componentType·캐스케이드 UI 셸·가격표시 UI)를 구현·검증. **가격/제약 미작성에 막히지 않음**(서버 권위 + 정규화 계약).
2. **후니 어댑터의 가격 arm**은 BFF `calculateQuote`(4모델 `pricing-rules.md §16`) 결과를 `NormalizedPriceBreakdown`으로 매핑.
   후니가 가격(B1)·배송정책(B3)을 작성하면 mock BFF → 실 BFF 교체. **위젯 코드 무변경.**
3. **후니 어댑터의 제약 arm**은 후니가 constraint(B2)를 작성하면 `DisableRule[]` 등으로 population. 그 전까지 Red fixture가 엔진 구동.
4. **계약 테스트 게이트**: 후니 어댑터 출력이 정규화 스키마 일치 → Red fixture 회귀테스트가 후니 어댑터로도 동일 통과(위젯 불변 증명).
5. 어댑터 세부(G1~G6/G9/GP)는 후니 작성과 병행 확인 — 위젯 *개발* 차단 요소 아님.
6. 위젯 코드·계약은 **본 분석 결과 무변경 확정** — hw-builder 재작업 불필요.
