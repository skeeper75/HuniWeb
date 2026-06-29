# Huni 위젯 UI 컴포넌트 갭 분석

> 생성일: 2026-04-01
> 근거: 01_evidence_report.md, 02_bestpractice_report.md, schema.prisma, huni_feature_gaps.json, 40_widget_api_spec.yaml, 41_product_api_spec.yaml

---

## Executive Summary (3줄)

1. **컴포넌트 타입 힌트 부재**: DB 스키마(`OptionValue.metadata`)와 Widget API 응답 모두 UI 컴포넌트 타입(`radio`/`select`/`swatch`/`stepper`)을 명시하는 필드가 없다. 현재 설계는 위젯 JS가 `optionType`과 값 개수로 컴포넌트를 추론해야 하며, 이는 RedPrinting의 `item_gbn` 기반 하드코딩 분기와 동일한 한계를 가진다.
2. **수량 모델은 양호하나 불완전**: `QtyModel`이 `bracket`/`input` 2종만 지원하며, RedPrinting의 규칙 기반 동적 생성(`FIR_CNT`/`INC`/`INC_STEP`)과 책자의 2차원 수량(부수+내지장수)을 표현할 수 없다.
3. **후가공 그룹화와 비활성화는 잘 설계됨**: `ProductOption.groupKey/groupLabel` + `ConstraintRule(DISABLE)` + Widget API의 `disabled/disabledReason` 패턴이 RedPrinting `VIEW_YN`/`pdt_disable_pcs_info`를 충분히 커버한다. 즉시 구현 가능한 항목이 가장 많은 영역이다.

---

## 현재 설계 커버리지 평가

### 레벨 A --- 이미 반영됨 (구현만 하면 됨)

| 항목 | DB 근거 | API 근거 | 설명 |
|---|---|---|---|
| **후가공 그룹화 UI** | `ProductOption.groupKey`, `groupLabel` | Widget API `finishing.groups[].groupSlug/groupName` | 코팅/박/접지 등 카테고리별 섹션 분리 가능 |
| **후가공 멀티셀렉트** | `ProductOption.multiSelect: true` | Widget API `finishing.type: select` | checkbox vs radio 결정 가능 |
| **후가공 필수/선택** | `ProductOption.required` | 제약 인라인 포함 | ESN_YN 대응 |
| **옵션 비활성화 + 사유** | `ConstraintRule(DISABLE)` + `affectedValues` | `disabled: true`, `disabledReason: "..."` | RedPrinting `pdt_disable_pcs_info` 대응. 자재-후가공 비활성화 규칙 표현 가능 |
| **옵션 숨김** | `ConstraintRule(SHOW_HIDE)` | `disabledOptions` 배열 | RedPrinting `VIEW_YN: "N"` 대응. Hidden 필수값 자동 선택 가능 |
| **옵션 캐스케이드 의존성** | `ProductOption.cascadeOrder`, `parentValueCode` | `POST /widget/options/cascade` | size->material->color->finishing 체인 서버 측 계산 |
| **가격 실시간 반영** | `PriceBracket`, `PriceFormula`, `FinishingProcess` | `POST /widget/price` breakdown 구조 | 공정별 원가 분해 반환 |
| **규격 프리셋 + 커스텀** | `OptionValue.metadata.customSizeInput` | `SizeOption.isNonStandard`, `nonStandardMin/Max` | 표준 규격 선택 + 비표준 직접 입력 |
| **수량 브래킷 선택** | `PriceBracket.minQty/maxQty` | `QtyModel.type: bracket`, `brackets: [...]` | WowPress 고정 브래킷 방식 대응 |
| **도수 기본+추가도수** | `OptionType.color` + `color_add` enum | Widget API `colorlist` + `coloraddlist` | Red/Wow 양쪽 패턴 대응 |
| **회원 등급별 가격** | - | `memberGrade` 파라미터, `memberDiscount` 응답 | RedPrinting `mb_cust_cod` 대응 |
| **합판/독판 구분** | `Product.pjoin` enum | `pjoin: gang_run` | 인쇄 방식별 분기 |
| **제품 아키타입 분기** | `Product.archetype` 7종 enum | - | RedPrinting `item_gbn` 대응 (더 세분화) |
| **기본 선택값** | `ProductOption.defaultCode` | `defaultSelections` 객체 | 초기 로드 시 권장 조합 |

### 레벨 B --- API 레이어 추가로 해결 가능 (스키마 변경 없음)

| 항목 | 현재 상태 | 해결 방안 | 비고 |
|---|---|---|---|
| **컴포넌트 타입 힌트** | API 응답에 UI 렌더링 힌트 없음 | `WidgetInitResponse`의 각 옵션 항목에 `uiHint: "radio" | "select" | "swatch" | "segmented" | "stepper" | "card_grid"` 필드 추가 | `ProductOption.multiSelect` + 값 개수 + `optionType`으로 서버에서 자동 산출 가능. 스키마 변경 불필요 |
| **비활성화 사유 다국어** | `disabledReason`이 하드코딩 문자열 | 다국어 키 기반으로 변경: `disabledReasonKey: "constraint.material_finishing_incompatible"` + 위젯 측 i18n 사전 | 현재 API 스펙의 string 타입 그대로 사용 가능 |
| **후가공 개별 추가 비용 표시** | `PriceResponse.finishingCosts[]`에 개별 금액 존재 | 위젯 초기화 시 각 후가공 항목에 `estimatedAdditionalPrice` 필드 추가 (현재 `OptionValue.additionalPrice` 컬럼 있음) | 베스트프렉티스: 각 후가공 체크박스 옆 "+3,000원" 인라인 표시 |
| **수량 단위 라벨 분기** | `QtyModel.unit: "매"` 단일 | 책자의 경우 `qtyLabels: { orderCnt: "수량", printCnt: "내지장수" }` 추가 | RedPrinting `skinInfo.quantityGroup.title` 대응 |
| **출고일(리드타임) 표시** | `Product.ctptime` 존재, `PriceResponse.exitDay` 존재 | 가격 응답의 `exitDay`를 위젯에서 "3일 후 출고" 형태로 표시 | 이미 API 스펙에 있으나 위젯 UI 가이드 미정의 |
| **가격 비교 표시 (합판/독판)** | `Product.pjoin` 단일 값 | 합판/독판 둘 다 가능한 상품의 경우 양쪽 가격을 동시 반환하는 `compareMode` 쿼리 파라미터 추가 | 베스트프렉티스 권장: 나란히 비교 |
| **옵션 섹션 표시/라벨 제어** | `ProductOption.label` 존재 | Widget API 응답에 RedPrinting `skinInfo` 유사 구조 추가: `sections[].visible`, `sections[].title` | 스키마의 `isActive` + `label`로 충분히 산출 가능 |

### 레벨 C --- DB 스키마 보강 필요

| 항목 | 현재 상태 | 필요한 변경 | 영향도 |
|---|---|---|---|
| **수량 규칙 기반 동적 생성** | `QtyModel`이 `bracket`/`input` 2종만 지원. `PriceBracket`은 가격 테이블이지 수량 생성 규칙이 아님 | `OptionValue.metadata`(size 타입)에 `quantityRule` 추가: `{ "firCnt": 1, "inc": 10, "incStep": 10, "minQty": 1, "maxQty": 10000, "dftQty": 100 }`. 또는 `QtyModel`에 `rule` 타입 추가 | 중간. RedPrinting 규칙 기반 수량 생성을 지원하려면 필수 |
| **책자 2차원 수량** | 수량 모델이 1차원(`qty` 단일) | `QtyModel`에 `dimensions` 배열 추가: `[{ "key": "orderCnt", "label": "부수", ... }, { "key": "printCnt", "label": "내지장수", ... }]`. DB: `ProductOption`에 `quantity` 타입을 `OptionType` enum에 추가하거나, metadata 확장 | 높음. `booklet` 아키타입 전용이지만 핵심 기능 |
| **표지/내지 이중 옵션 구조** | `ProductOption.coverCd` 필드 존재 (0=통합, 1=표지, 2=내지, 3=간지) | 스키마는 준비됨. 그러나 `OptionValue.metadata`의 paper/color 타입에 `coverCd` 연동 구조 미정의. metadata에 `coverCd` 참조 추가 필요 | 높음. `booklet` 아키타입 핵심 |
| **후가공 속성(ATTB) 추가 선택** | 후가공 선택은 `PCS_CD`+`PCS_DTL_CD` 2단까지만. RedPrinting의 링색상 같은 ATTB 3단째 없음 | `OptionValue.metadata`(finishing 타입)에 `attributes` 배열 추가: `[{ "code": "RIN_BLK", "label": "검정색", "type": "color_swatch" }]` | 낮음. 특정 후가공(링제본, 박 등)에만 해당 |
| **용지 3단 필터 (종류/평량/두께)** | `OptionValue.metadata`(paper 타입)에 `papergroup`, `pgram`은 있으나 두께(`thickness`) 없음 | metadata에 `thickness` 추가, 또는 `Material.thickness` 활용하여 API에서 3단 필터 데이터 구성 | 중간. `Material` 테이블에 `thickness` 컬럼은 이미 있음 |
| **후가공 수량 제한** | `ConstraintRule`로 표현 가능하나, WowPress `jobqtymin/jobqtymax` 패턴 전용 필드 없음 | `OptionValue.metadata`(finishing 타입)에 `qtyConstraint: { "min": 100, "max": 5000 }` 추가 | 낮음. `ConstraintRule.condition` JSON으로 대체 가능 |
| **수량 단위(PDT_UNIT) per 옵션** | `Product.unit` 단일. 규격별 단위 변경 불가 (개, 매, 권, 세트) | `OptionValue.metadata`(size 타입)에 `unit` override 추가 | 낮음. 대부분 상품 레벨 단위로 충분 |

### 레벨 D --- 비즈니스 로직 미정의 (팀 결정 필요)

| 항목 | 질문 | 선택지 | 의존하는 구현 |
|---|---|---|---|
| **컴포넌트 타입 결정 주체** | 위젯 JS가 `optionType` + 값 개수로 자체 결정? 아니면 API가 `uiHint`를 내려줌? | (A) 위젯 자체 결정 -- 클라이언트 로직 복잡, API 단순 / (B) API 힌트 -- 서버에서 일괄 제어, 위젯 경량화 | 전체 위젯 아키텍처 |
| **수량 UI: 드롭다운 vs 스테퍼+프리셋** | 합판 수량 선택 시 드롭다운(WowPress 방식)? 프리셋 버튼+스테퍼(베스트프렉티스 권장)? | (A) 드롭다운 -- 구현 단순, 모바일 친화 / (B) 프리셋 버튼+스테퍼 -- UX 우수, 구현 복잡 / (C) 하이브리드 -- 프리셋 버튼 + 직접입력 | 수량 컴포넌트 설계 |
| **후가공 상호 배타 규칙 표현** | 무광코팅 vs 유광코팅처럼 같은 그룹 내 배타적 선택은 어떻게 표현? | (A) `multiSelect: false`로 그룹 내 radio -- 현재 스키마로 가능 / (B) `ConstraintRule(DISABLE)` 상호 참조 -- 더 유연하지만 복잡 | 후가공 UI 컴포넌트 |
| **용지 선택 UI: 단일 드롭다운 vs 3단 필터** | RedPrinting처럼 단일 합성코드? WowPress처럼 종류/평량/두께 3단? | (A) 단일 선택 -- 구현 단순, 옵션 많으면 스크롤 길어짐 / (B) 3단 필터 -- UX 우수, 구현 복잡 / (C) Visual Swatch Card -- 베스트프렉티스 권장 | 용지 컴포넌트 설계 |
| **Smart Reset vs Full Reset** | 상위 옵션 변경 시 하위 옵션을 어떻게 처리? | (A) Smart Reset -- 이전 선택값 유효하면 유지 (권장) / (B) Full Reset -- 모두 초기화 | 캐스케이드 엔진 로직 |
| **가격 갱신 Debounce 전략** | 수량 직접 입력 시 debounce 시간? 옵션 변경 시 즉시 vs debounce? | 베스트프렉티스: 옵션 변경 즉시, 텍스트 입력 300-500ms debounce, onBlur 즉시 | 가격 API 호출 로직 |
| **Optimistic Price 표시** | 가격 로딩 중 이전 가격 유지? 스켈레톤? | 베스트프렉티스: 이전 가격 유지 + shimmer/pulse indicator | 가격 표시 UI |
| **에디터 연동 타이밍** | 에디터 연동은 위젯 Phase 1에 포함? Phase 2로 분리? | 에디터 Path B가 위젯 cart 흐름에 깊이 통합됨 | 전체 로드맵 |
| **책자 표지/내지 UI 레이아웃** | 표지와 내지를 탭으로 분리? 한 화면에 2컬럼? 아코디언? | 캡처 근거 부족 (WowPress 실제 책자 위젯 미확인) | booklet 아키타입 UI |

---

## 핵심 질문 답변

### Q1. 컴포넌트 타입은 어디서 결정되는가?

**현재 상태**: DB(`OptionValue.metadata`)와 API 응답 어디에도 `component_type`, `displayType`, `uiHint` 같은 필드가 없다.

**RedPrinting 패턴**: `item_gbn`(제품 유형)에 의해 Vue 컴포넌트가 하드코딩 분기된다. `skinInfo`는 섹션 표시/숨김과 라벨만 제어하며, 컴포넌트 타입 자체를 지정하지 않는다.

**Huni 권장안**: API에서 `uiHint` 필드를 내려주는 방식(레벨 B). 서버가 `optionType` + `multiSelect` + 값 개수 + `archetype`을 조합하여 최적 컴포넌트를 결정하면, 위젯은 `uiHint`에 따라 렌더링만 하면 된다. 스키마 변경 없이 API 레이어에서 산출 가능.

### Q2. disabled vs hidden 로직은 어디에 있는가?

**현재 상태**: `ConstraintRule` 모델이 `DISABLE`과 `SHOW_HIDE` 두 타입을 모두 지원한다. Widget API의 `disabled: true` + `disabledReason` 필드가 RedPrinting `pdt_disable_pcs_info`를 대응한다.

**갭**: RedPrinting의 `VIEW_YN: "N"` + `ESN_YN: "Y"` 조합(숨겨진 필수값, Hidden Input 자동 선택)이 `ConstraintRule(SHOW_HIDE)` + `ProductOption.required`로 표현 가능하나, 위젯에서 이 조합을 "hidden required = auto-select default" 로직으로 처리하는 가이드가 미정의.

**결론**: 레벨 A. 스키마와 API 모두 준비됨. 위젯 구현 시 hidden+required 조합 처리 로직만 정의하면 됨.

### Q3. 수량 브래킷 표시는 어떻게 하는가?

**현재 상태**: `QtyModel.type: "bracket"` + `brackets: [100, 200, ...]`로 WowPress 고정 브래킷 방식은 지원. `QtyModel.type: "input"` + `inputMin/inputMax`로 직접 입력도 지원.

**갭 3가지**:
1. RedPrinting `FIR_CNT/INC/INC_STEP` 규칙 기반 동적 수량 생성 미지원 (레벨 C)
2. 책자 2차원 수량(부수+내지장수) 미지원 (레벨 C)
3. 프리셋 버튼 + 스테퍼 혼합 UI 결정 미정 (레벨 D)

**결론**: 합판 표준 상품은 bracket으로 즉시 구현 가능(레벨 A). 독판/책자는 스키마 보강 필요(레벨 C).

### Q4. 후가공 그룹화 UI는?

**현재 상태**: `ProductOption.groupKey`("coating", "foil") + `groupLabel`("코팅", "박") + `multiSelect` 필드로 그룹별 섹션 + 체크박스/라디오 결정 가능. Widget API의 `finishing.groups[]` 구조가 이를 반영.

**권장 렌더링**:
- `multiSelect: true` 그룹 -> Grouped Checkbox List (코팅+박+형압 등 조합 가능)
- `multiSelect: false` 그룹 -> Radio Group (무광 vs 유광 등 배타적)
- 각 항목에 `additionalPrice` 인라인 표시 ("+3,000원")
- 그룹별 Accordion/Expandable Section

**결론**: 레벨 A. 현재 설계로 완전히 구현 가능.

### Q5. 가격 실시간 반영 트리거는?

**현재 상태**: Widget API `POST /widget/price`가 모든 옵션 변경 시 호출 가능. `POST /widget/options/cascade`에서 캐스케이드 의존성 규칙이 명시:
- size/material/color/finishing 변경 -> cascade 먼저 호출 -> 이후 price 호출
- qty 변경 -> cascade 불필요, 바로 price 호출

**갭**: debounce 전략, optimistic price 표시, API 실패 시 rollback 정책이 위젯 레벨에서 미정의(레벨 D).

**`WidgetSession.computedPrice` 업데이트 시점**: price API 응답 수신 시 서버에 세션 저장. 위젯 측 로컬 상태와 서버 세션이 동기화되는 시점은 미정의.

---

## 옵션 타입별 권장 컴포넌트 매핑 테이블

| optionType | 권장 컴포넌트 | metadata에 추가할 필드 | API hint 필드 | 비고 |
|---|---|---|---|---|
| **job_preset** | Segmented Control (2-3개) 또는 Tab | 없음 (현재 충분) | `uiHint: "segmented"` | 디지털/옵셋/UV 등 소수 배타적 선택. 항상 전체 노출 |
| **size** | Card Grid (프리셋) + Custom Input Toggle | `thumbnailUrl` (규격 비율 미리보기) | `uiHint: "card_grid"` | 표준 규격은 시각적 카드, 비표준은 `isNonStandard`로 입력 UI 전환 |
| **paper** | Visual Swatch Card (이미지+텍스트) 또는 3단 Cascading Select | `swatchImageUrl`, `thickness` | `uiHint: "swatch"` 또는 `"cascading_select"` | 지류 질감 시각 정보 중요. 7개 이하 swatch, 이상이면 cascading. 팀 결정 필요(Q4 레벨D) |
| **option** | Select (Dropdown) | 없음 | `uiHint: "select"` | 범용 상품옵션. 값 개수에 따라 radio/select 자동 분기 |
| **color** | Segmented Control (2-4개) 또는 Radio Group | 없음 (현재 충분) | `uiHint: "segmented"` | 도수 선택지가 소수이므로 segmented가 최적. 모바일 드롭다운 대비 1탭 선택 |
| **color_add** | Select (Dropdown) 또는 Radio | 없음 (`addType: "select\|radio"` 이미 있음) | `uiHint: metadata.addType` | 추가도수. metadata의 `addType` 활용 |
| **finishing** | Grouped Checkbox List (Accordion 섹션) | `attributes[]` (ATTB 3단째), `estimatedPrice` | `uiHint: "grouped_checkbox"` | 그룹별 아코디언. `multiSelect` 플래그로 checkbox/radio 분기. 각 항목에 추가비용 인라인 |
| **quantity** | Preset Button Bar + Number Input | `quantityRule` (규칙 기반 동적 생성), `dimensions[]` (2차원) | `uiHint: "preset_stepper"` | 합판: 프리셋 버튼. 독판: 스테퍼+직접입력. 책자: 듀얼 스테퍼 |

---

## OptionValue.metadata JSONB 보강 제안

현재 스키마의 각 optionType별 metadata에 추가해야 할 UI 관련 필드:

### job_preset (변경 없음)
```
현재: { "jobpresetno": "string", "presetname": "string" }
추가: 없음
```

### size (1개 추가)
```
현재: { "sizeno", "width", "height", "cutsize", "itemsPerSheet",
        "nonStandard", "customSizeInput": { min/max/interval/unit } }
추가:
  "thumbnailUrl": "string | null"    // 규격 비율 미리보기 이미지 URL
  "quantityRule": {                  // [레벨 C] 규칙 기반 수량 생성 (규격별 수량 제한)
    "firCnt": number,                // 시작 수량
    "inc": number,                   // 증가 단위
    "incStep": number,               // 스텝 전환 기준
    "minQty": number,                // 최소 수량
    "maxQty": number,                // 최대 수량
    "dftQty": number                 // 기본 수량
  }
```

### paper (2개 추가)
```
현재: { "paperno", "papername", "pgram", "papergroup" }
추가:
  "thickness": number | null         // 두께 (mm). Material.thickness 에서 복사 또는 참조
  "swatchImageUrl": "string | null"  // 용지 질감 썸네일 URL (swatch 렌더링용)
```

### color (변경 없음)
```
현재: { "colorno", "colorname", "pdfpage", "hasColorAdd" }
추가: 없음
```

### color_add (변경 없음)
```
현재: { "colornoadd", "coloraddname", "addType": "select|radio" }
추가: 없음
```

### finishing (2개 추가)
```
현재: { "awkjobno", "groupName", "pricingMethod" }
추가:
  "attributes": [                    // [레벨 C] 후가공 속성 추가 선택 (링색상, 박종류 등)
    {
      "code": "string",             // 속성 코드 (예: "RIN_BLK")
      "label": "string",            // 표시명 (예: "검정색")
      "type": "color_swatch | radio | select"  // 렌더링 타입
    }
  ]
  "qtyConstraint": {                 // [레벨 C] 후가공별 수량 제한
    "min": number | null,
    "max": number | null
  }
```

### Prisma schema comment 업데이트 제안

```prisma
// OptionValue.metadata JSON 구조 (option_type별 상이):
//
// job_preset: { "jobpresetno": "string", "presetname": "string" }
// size:       { "sizeno": "string", "width": number, "height": number,
//               "cutsize": "string", "itemsPerSheet": number, "nonStandard": boolean,
//               "customSizeInput": { "widthMin": n, "widthMax": n, "heightMin": n,
//                                    "heightMax": n, "interval": n, "unit": "mm" },
//               "thumbnailUrl": "string|null",
//               "quantityRule": { "firCnt": n, "inc": n, "incStep": n,
//                                 "minQty": n, "maxQty": n, "dftQty": n } }
// paper:      { "paperno": "string", "papername": "string", "pgram": number,
//               "papergroup": "string", "thickness": number|null,
//               "swatchImageUrl": "string|null" }
// color:      { "colorno": "string", "colorname": "string", "pdfpage": number,
//               "hasColorAdd": boolean }
// color_add:  { "colornoadd": "string", "coloraddname": "string", "addType": "select|radio" }
// finishing:  { "awkjobno": "string", "groupName": "string", "pricingMethod": "string",
//               "attributes": [{ "code": "string", "label": "string",
//                                "type": "color_swatch|radio|select" }],
//               "qtyConstraint": { "min": number|null, "max": number|null } }
```

---

## 즉시 구현 가능 항목 (블로커 없음)

1. **후가공 그룹화 Accordion UI** -- `groupKey/groupLabel` + `multiSelect` 활용. Grouped Checkbox/Radio List 렌더링
2. **옵션 비활성화 + 사유 표시** -- `ConstraintRule(DISABLE)` + `disabled/disabledReason`. Disabled 항목 tooltip으로 사유 표시
3. **옵션 숨김 (Hidden Required)** -- `ConstraintRule(SHOW_HIDE)` + `required`. Hidden input 자동 기본값 선택
4. **수량 브래킷 드롭다운** -- `QtyModel.type: bracket` + `brackets[]`. 합판 표준 상품 수량 선택
5. **규격 프리셋 선택** -- `SizeOption` 배열. 카드 그리드 또는 드롭다운
6. **비표준 규격 직접 입력** -- `isNonStandard` + `nonStandardMin/Max`. 입력 필드 + 유효성 검사
7. **도수 Segmented Control** -- `colorlist` 배열. 소수 선택지 radio/segmented
8. **추가도수 Select** -- `coloraddlist` + `addType`. 조건부 표시
9. **가격 실시간 분해 표시** -- `PriceResponse.breakdown`. 인쇄비/용지비/후가공비/VAT 분리 표시
10. **캐스케이드 옵션 갱신** -- `POST /widget/options/cascade`. 옵션 변경 시 하위 옵션 부분 갱신
11. **회원 등급 할인 표시** -- `memberDiscount` 응답. 할인율/할인액 인라인 표시
12. **출고일 표시** -- `exitDay` 응답. "3일 후 출고" 배지

---

## 구현 전 팀 결정 필요 항목 (블로커)

| 우선순위 | 결정 사항 | 영향 범위 | 권장안 |
|---|---|---|---|
| **P0** | 컴포넌트 타입 결정 주체 (위젯 vs API) | 전체 위젯 아키텍처 | API `uiHint` 방식 권장. 서버 일괄 제어로 A/B 테스트, 모바일 최적화 용이 |
| **P0** | 용지 선택 UI 형태 (단일 vs 3단 필터 vs swatch) | paper 컴포넌트 설계 | 7개 이하: swatch, 이상: 2단 cascading (종류->평량). 두께는 정보 표시만 |
| **P0** | 수량 UI 형태 (드롭다운 vs 프리셋+스테퍼) | quantity 컴포넌트 설계 | 하이브리드 권장: 프리셋 버튼(상위 5개 인기 수량) + 직접 입력 |
| **P1** | Smart Reset vs Full Reset 정책 | 캐스케이드 엔진 로직 | Smart Reset 권장. 이전 선택값 유효하면 유지 |
| **P1** | 책자 표지/내지 UI 레이아웃 | booklet 아키타입 전용 | 탭 분리 권장 (표지 탭 / 내지 탭). `coverCd` 필드 활용 |
| **P1** | 후가공 그룹 내 상호 배타 규칙 표현 방식 | 후가공 UI 렌더링 | `multiSelect: false`로 그룹 내 radio 처리. 그룹 간은 independent |
| **P2** | 가격 Debounce/Optimistic 전략 | 가격 표시 UX | 옵션 변경: 즉시. 텍스트 입력: 300ms debounce. 로딩 중: 이전 가격 + pulse |
| **P2** | 에디터 연동 Phase 분리 여부 | 로드맵 | Phase 1: 파일 업로드만. Phase 2: Edicus 에디터 연동 |
| **P2** | 가격 비교 표시 (합판/독판 동시) | 특수 상품 가격 UI | Phase 2로 분리 가능 |

---

## 다음 세션 권장 작업 순서

### Phase 1: 기초 UI 컴포넌트 (블로커 해소 후 즉시 착수)

1. **[팀 결정]** P0 블로커 3건 결정 (컴포넌트 힌트 방식, 용지 UI, 수량 UI)
2. **[API]** `WidgetInitResponse`에 `uiHint` 필드 추가 (레벨 B, 스키마 변경 없음)
3. **[위젯]** 레벨 A 즉시 구현 12항목 착수: 후가공 그룹, 비활성화, 수량 브래킷, 규격 선택, 도수, 가격 분해
4. **[위젯]** 캐스케이드 엔진 클라이언트 구현 (cascade API 호출 + 로컬 상태 갱신)

### Phase 2: 스키마 보강 + 확장 컴포넌트

5. **[DB]** `OptionValue.metadata` 보강: `quantityRule`, `attributes`, `thickness`, `swatchImageUrl`
6. **[API]** `QtyModel`에 `rule` 타입 추가 + 책자 2차원 수량 지원
7. **[위젯]** 용지 swatch/cascading 컴포넌트, 수량 프리셋+스테퍼 혼합 컴포넌트
8. **[위젯]** 책자 표지/내지 탭 분리 UI

### Phase 3: 고급 기능

9. **[위젯]** 에디터(Edicus) 연동 Path B
10. **[위젯]** Smart Reset 캐스케이드 로직
11. **[위젯]** 합판/독판 가격 비교 표시
12. **[위젯]** i18n + 테마 시스템

---

*본 보고서는 01_evidence_report.md(RedPrinting/WowPress 증거), 02_bestpractice_report.md(글로벌 베스트프렉티스), schema.prisma(DB 스키마), huni_feature_gaps.json(기존 갭), 40_widget_api_spec.yaml/41_product_api_spec.yaml(API 설계) 6개 산출물을 교차 분석하여 작성되었습니다.*
