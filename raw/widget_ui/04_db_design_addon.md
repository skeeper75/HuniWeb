# 위젯 UI DB 설계 보강안 v2

> **생성일**: 2026-04-01
> **소스**: schema.prisma, WowPress captures (namecard/booklet), RedPrinting v2 captures (PRBKORD/GSTGMIC/ACNTHAP), Figma 12개 화면, 01_api-analyst_data-model.md, 02_modeler_product-schema.md, 03_gap_analysis.md
> **목적**: 3개 소스 교차 분석으로 현재 DB 스키마 갭 식별 및 완전한 보강안 작성

---

## 1. 컴포넌트 타입 마스터 매핑

### 1.1 컴포넌트 타입 Enum 정의

Figma OVERVIEW 화면에서 식별된 10가지 UI 컴포넌트 타입:

| componentType | 설명 | Figma 근거 |
|---|---|---|
| `button` | Chip 버튼 그리드 (사이즈, 인쇄, 코팅 등) | Option Group Button Type |
| `select` | 드롭다운 (종이, 호치키수 등) | Option Group Select Box Type |
| `count_input` | 수량 스테퍼 (-, N, +) | Option Group Count Input Type |
| `finish_title_bar` | 후가공 섹션 Collapsible (더보기/닫기) | Option Group Finish Title Bar |
| `finish_button` | 후가공 Chip 버튼 | Option Group Finish Button Type |
| `finish_input` | 크기 직접입력 (W x H) | Option Group Finish Input Type |
| `color_chip` | 색상 스와치 (원형 컬러칩) | Option Group Finish Color Chip Type |
| `image_chip` | 이미지 칩 (원형 이미지 선택) | 책자 탕잉미/탕식탈 |
| `finish_select` | 크기+가격 목록 드롭다운 | Option Group Finish Select Box Type |
| `volume_slider` | 제작수량별 구간할인 슬라이더 | 굿즈/아크릴 제작수량별 구간할인 |

### 1.2 optionType + 아키타입별 componentType 매핑

| optionType | 아키타입 | 상황 | componentType | 근거 |
|---|---|---|---|---|
| `job_preset` | all | 2-3개 선택지 | `button` | Figma: chip 버튼 |
| `size` | single_sheet | 고정 규격 목록 | `button` | Figma PRINT: 7개 chip 그리드 |
| `size` | large_format | 비규격 입력 | `finish_input` | 가로/세로 직접입력 필요 |
| `size` | booklet | 고정 규격 목록 | `button` | Figma BOOK: 2개 chip |
| `size` | goods | 고정 목록 | `button` | Figma GOODS: 3개 chip |
| `size` | accessory | 고정 목록 | `button` | Figma ACCESSORIES: 2개 chip |
| `paper` | single_sheet | 종이 드롭다운 | `select` | Figma: "종이" Select Box (NEW badge 포함) |
| `paper` | booklet | 내지종이/표지종이 | `select` | Figma BOOK: 내지종이, 표지종이 각각 Select |
| `option` | single_sheet | 인쇄(단면/양면) | `button` | Figma PRINT: 2개 chip |
| `option` | sticker | 커팅 | `button` | Figma STICKER: 3개 chip |
| `option` | goods | 컬러 | `color_chip` | Figma GOODS: 10개 원형 색상 스와치 |
| `option` | booklet | 제본방향 | `button` | Figma BOOK: 좌철/상철 chip |
| `option` | booklet | 탕잉미(합지아) | `image_chip` | Figma BOOK: 원형 이미지 4개 (중철/무선/PUR/트윈링) |
| `option` | booklet | 탕식탈(표지사양) | `image_chip` | Figma BOOK: 원형 이미지 3개 (소프트커버/하드커버 등) |
| `color` | single_sheet | 도수 | `button` | Figma PRINT: 별색인쇄 각 행 3개 chip |
| `color` | booklet | 내지인쇄/표지인쇄 | `button` | Figma BOOK: 단면/양면 2개 chip |
| `color_add` | single_sheet | 추가도수 | `button` | Figma PRINT: chip 행 |
| `finishing` | single_sheet | 코팅 | `button` | Figma PRINT: chip 그리드 (후가공 섹션) |
| `finishing` | single_sheet | 라물라 | `finish_button` | Figma PRINT: 후가공 chip |
| `finishing` | single_sheet | 박원판 | `finish_button` + `finish_input` + `color_chip` | Figma PRINT: 박원판/박색조합 |
| `finishing` | single_sheet | 접시봉투 | `finish_select` | Figma PRINT: 크기+가격 드롭다운 |
| `finishing` | booklet | 표지코팅 | `button` | Figma BOOK: 3개 chip |
| `finishing` | booklet | 투명가바 | `button` | Figma BOOK: 4개 chip |
| `finishing` | booklet | 박 절합 기준 | `finish_button` + `finish_input` + `color_chip` | Figma BOOK: PRINT와 동일 패턴 |
| `finishing` | booklet | 제본료상 | `finish_select` | Figma BOOK: 크기+가격 드롭다운 |
| `finishing` | goods | 가공 | `button` | Figma GOODS: 2개 chip |
| `finishing` | acrylic | 가공 | `button` | Figma ACRYLIC: 3개 chip |
| (quantity) | single_sheet | 제작수량 | `count_input` | Figma: -, N, + 스테퍼 |
| (quantity) | goods/acrylic | 제작수량 + 구간할인 | `count_input` + `volume_slider` | Figma: 스테퍼 + 슬라이더 |
| (quantity) | booklet | 내지 페이지 | `count_input` | Figma BOOK: -, N, + (min~max 표시) |
| (quantity) | sticker | 조건수 | `select` | Figma STICKER: 드롭다운 |

### 1.3 componentType Enum (schema.prisma 추가)

```prisma
enum ComponentType {
  button          // chip 버튼 그리드
  select          // 드롭다운
  count_input     // 수량 스테퍼 (-, N, +)
  finish_button   // 후가공 chip 버튼
  finish_input    // W x H 크기 직접입력
  color_chip      // 원형 색상 스와치
  image_chip      // 원형 이미지 선택
  finish_select   // 크기+가격 목록 드롭다운
  volume_slider   // 구간할인 슬라이더
  hidden          // 숨김 (자동 선택)

  @@map("component_type")
}
```

---

## 2. OptionValue.metadata JSONB 보강 (optionType별)

### 2.1 현재 스키마 vs 보강 완성본

#### job_preset (변경 없음)

```jsonc
// 현재
{ "jobpresetno": "3110", "presetname": "디지털인쇄" }
// 추가 필드: 없음. 현재 구조로 충분.
```

#### size (2개 추가)

```jsonc
// 현재
{
  "sizeno": "5456", "width": 90, "height": 50,
  "cutsize": "86x52", "itemsPerSheet": 16, "nonStandard": false,
  "customSizeInput": { "widthMin": 10, "widthMax": 900, "heightMin": 10, "heightMax": 600, "interval": 1, "unit": "mm" }
}
// 추가 필드
{
  // ...기존 필드...
  "thumbnailUrl": "/images/sizes/a4-portrait.png",  // 규격 비율 미리보기 (image_chip용)
  "productSizeInfo": "제품사이즈 : 210 X 297mm"     // RedPrinting PDT_SIZE_INFO 대응. 사용자 안내 텍스트
}
```

#### paper (3개 추가)

```jsonc
// 현재
{ "paperno": "22904", "papername": "몽블랑 240g", "pgram": 240, "papergroup": "일반지" }
// 추가 필드
{
  // ...기존 필드...
  "thickness": 0.35,                                // Material.thickness에서 복사. 3단필터용
  "swatchImageUrl": "/images/papers/montblanc.jpg",  // 용지 질감 썸네일 (swatch 렌더링)
  "isNew": true                                      // 신규 뱃지 표시 (Figma: NEW badge in Select Box)
}
```

#### option (신규 정의 필요 -- 현재 스키마에 option 타입 metadata 주석 없음)

```jsonc
// 신규 정의
{
  "optno": "401",
  "optname": "풀림 방향",
  "optType": "radio"     // radio|checkbox
}
```

#### color (변경 없음)

```jsonc
// 현재
{ "colorno": "255", "colorname": "양면 칼라8도", "pdfpage": 2, "hasColorAdd": false }
// 추가 필드: 없음
```

#### color_add (변경 없음)

```jsonc
// 현재
{ "colornoadd": "WH1", "coloraddname": "화이트1도", "addType": "select" }
// 추가 필드: 없음
```

#### finishing (5개 추가)

```jsonc
// 현재
{ "awkjobno": "COT_DFT", "groupName": "코팅", "pricingMethod": "lot" }
// 추가 필드
{
  // ...기존 필드...
  "pcsCode": "COT_DFT",          // RedPrinting PCS_CD 대응 (후가공 그룹 코드)
  "pcsDtlCode": "TCGLS",         // RedPrinting PCS_DTL_CD (후가공 상세 코드)
  "viewYn": true,                 // 기본 표시 여부 (RedPrinting VIEW_YN). false=hidden required
  "essentialYn": false,           // 필수 선택 여부 (RedPrinting ESN_YN)
  "attributes": [                 // ATTB 3단째 (링색상, 박종류 등)
    {
      "code": "RIN_BLK",
      "label": "검정색",
      "type": "color_chip",       // color_chip|button|select
      "colorHex": "#000000"       // color_chip일 때만
    }
  ],
  "sizeInput": {                  // finish_input용 (박원판/형압 크기 직접입력)
    "widthMin": 30, "widthMax": 125,
    "heightMin": 30, "heightMax": 170,
    "unit": "mm"
  },
  "qtyConstraint": {              // 후가공별 수량 제한 (WowPress rst_jobqty 대응)
    "min": 100, "max": 5000
  }
}
```

### 2.2 신규 metadata 타입: `goods_color` (굿즈 전용 컬러)

Figma GOODS 화면에서 관찰된 색상 스와치는 기존 `color` (도수)와 다른 개념. 굿즈의 "컬러"는 제품 물리적 색상이다.

```jsonc
// OptionType: option, componentType: color_chip
// metadata 구조
{
  "optno": "CLR_WHT",
  "optname": "흰색",
  "colorHex": "#FFFFFF",
  "colorLabel": "흰색",
  "colorGroup": "basic"           // basic|vivid|pastel 등 그룹핑
}
```

### 2.3 신규 metadata 타입: `image_option` (이미지 칩용)

Figma BOOK 화면의 탕잉미/탕식탈은 원형 이미지로 선택하는 패턴.

```jsonc
// OptionType: option, componentType: image_chip
// metadata 구조
{
  "optno": "BIND_SADDLE",
  "optname": "중철제본",
  "imageUrl": "/images/binding/saddle-stitch.png",
  "imageAlt": "중철제본 예시 이미지",
  "description": "4~28페이지, 4의 배수"
}
```

---

## 3. ProductAddon 모델 설계

### 3.1 패턴 설명

3개 소스에서 관찰된 "추가상품/부자재" 패턴:

**WowPress**: `prodaddinfo` -- 메인 상품에 연결된 부자재 목록. 독립 prodno를 가지며 별도 가격 조회.
**RedPrinting**: `pdt_add_info` -- 후가공에 종속된 속성(ATTB). 예: 링제본 -> 링색상(검정/흰/금/은).
**Figma**: 두 가지 패턴 관찰:
1. **추가료 섹션** (PRINT/BOOK 좌측 패널): 썸네일 이미지 + 설명 -> 관련 추가상품 (예: 명함 -> 봉투/케이스)
2. **품목만 Finish Select Box** (GOODS): 드롭다운으로 크기+가격 배열 선택 (예: 파우치 사이즈별 가격)
3. **후가공 속성** (BOOK): 링색상, 제본방향 등 후가공 하위 속성

핵심 구분:
- **ProductAddon** (Type A): 메인 상품과 별개로 주문 가능한 관련 상품 (봉투, 케이스, 볼체인)
- **FinishingAttribute** (Type B): 후가공 선택의 하위 속성 (링색상, 박종류) -> `OptionValue.metadata.attributes`로 처리
- **TriggerAddon** (Type C): 특정 옵션 선택 시에만 나타나는 추가상품 (사이즈 A4 선택시 -> A4 봉투만 표시)

### 3.2 Prisma 모델 코드

```prisma
/// 추가상품 연결 — 메인 상품에 종속된 부자재/추가상품 (WowPress prodaddinfo 대응)
model ProductAddon {
  id              String   @id @default(cuid())
  productSlug     String   @map("product_slug")           // 메인 상품
  addonSlug       String   @map("addon_slug")             // 추가상품 (Product 테이블 참조)
  triggerOption   String?  @map("trigger_option")          // 조건 트리거 옵션 (예: "size")
  triggerValue    String?  @map("trigger_value")           // 조건 트리거 값 (예: "90x50")
  label           String   @map("label")                   // 표시 라벨 (예: "명함 봉투")
  description     String?  @map("description")             // 설명 텍스트
  thumbnailUrl    String?  @map("thumbnail_url")           // 썸네일 이미지 URL
  minQty          Int      @default(0) @map("min_qty")     // 최소 주문 수량 (0=선택 안 해도 됨)
  defaultQty      Int      @default(0) @map("default_qty") // 기본 수량 (0=미선택)
  sortOrder       Int      @default(0) @map("sort_order")
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  // Relations
  product Product  @relation("ProductAddons", fields: [productSlug], references: [slug], onDelete: Cascade)
  addon   Product  @relation("AddonOf", fields: [addonSlug], references: [slug], onDelete: Cascade)

  @@unique([productSlug, addonSlug, triggerOption, triggerValue])
  @@index([productSlug, isActive])
  @@index([addonSlug])
  @@map("product_addons")
}
```

**Product 모델에 relation 추가 필요:**

```prisma
model Product {
  // ...기존 필드...

  // 추가 Relations
  addons       ProductAddon[] @relation("ProductAddons")
  addonOf      ProductAddon[] @relation("AddonOf")
}
```

### 3.3 시드 예시

```typescript
// 명함 -> 명함봉투 (사이즈 연동)
await prisma.productAddon.createMany({
  data: [
    {
      productSlug: "premium-namecard",
      addonSlug: "namecard-envelope-90x50",
      triggerOption: "size",
      triggerValue: "90x50",
      label: "명함봉투 90x50",
      description: "90x50mm 명함에 맞는 봉투",
      thumbnailUrl: "/images/addons/envelope-90x50.jpg",
      minQty: 0,
      defaultQty: 0,
      sortOrder: 1,
    },
    {
      productSlug: "premium-namecard",
      addonSlug: "namecard-envelope-86x52",
      triggerOption: "size",
      triggerValue: "86x52",
      label: "명함봉투 86x52",
      description: "86x52mm 명함에 맞는 봉투",
      thumbnailUrl: "/images/addons/envelope-86x52.jpg",
      minQty: 0,
      defaultQty: 0,
      sortOrder: 2,
    },
    // 조건 없는 범용 추가상품
    {
      productSlug: "premium-namecard",
      addonSlug: "namecard-case-plastic",
      triggerOption: null,
      triggerValue: null,
      label: "명함케이스 (플라스틱)",
      description: "투명 플라스틱 명함케이스",
      thumbnailUrl: "/images/addons/case-plastic.jpg",
      minQty: 0,
      defaultQty: 0,
      sortOrder: 10,
    },
  ],
});
```

---

## 4. ConstraintRule 경우의 수 완전 목록

### 4.1 현재 ConstraintRuleType 5종 검증

| ruleType | WowPress 대응 | RedPrinting 대응 | Figma 관찰 | 충분성 |
|---|---|---|---|---|
| `FILTER` | `req_*` (enable) | - | 선택 시 하위 옵션 필터링 | 충분 |
| `SHOW_HIDE` | 조건부 표시 | `VIEW_YN`, `HIDE_YN` | 후가공 섹션 접힘/펼침 | 충분 |
| `RESET` | `rst_*` (disable) | `pdt_disable_pcs_info` | 옵션 변경 시 하위 초기화 | 충분 |
| `ENABLE` | `req_awkjob` | - | 특정 선택 시 후가공 활성화 | 충분 |
| `DISABLE` | `rst_awkjob` | `pdt_disable_pcs_info` | 비활성 회색 + 툴팁 | 충분 |

**신규 필요 타입**: `SET_VALUE` -- 자동값 설정 (예: 200g+ 종이 + 접지 -> 오시 자동 추가)

```prisma
enum ConstraintRuleType {
  FILTER
  SHOW_HIDE
  RESET
  ENABLE
  DISABLE
  SET_VALUE    // 신규: 자동값 설정 트리거

  @@map("constraint_rule_type")
}
```

### 4.2 아키타입별 Constraint 패턴 완전 목록

#### single_sheet (명함/엽서/전단지)

| # | triggerOption | triggerValue | ruleType | affectedOption | affectedValues | 설명 |
|---|---|---|---|---|---|---|
| S-01 | `paper` | `*` (전체) | `DISABLE` | `finishing(coating)` | 소재별 상이 | 종이-코팅 비호환 (paper.rst_awkjob, 1907건) |
| S-02 | `paper` | 180g 미만 종이 | `DISABLE` | `finishing(coating)` | 코팅 전체 | 180g 미만 코팅 불가 |
| S-03 | `paper` | `*` | `FILTER` | `job_preset` | 인쇄방식별 상이 | 종이-인쇄방식 필터 (paper.rst_prsjob, 758건) |
| S-04 | `color` | 칼라4도/칼라8도 | `ENABLE` | `job_preset` | 옵셋인쇄 | 도수-인쇄방식 연동 (color.req_prsjob, 484건) |
| S-05 | `size` | 특정 사이즈 | `DISABLE` | `finishing(foil)` | 사이즈 초과 후가공 | 사이즈-후가공 호환 (size.rst_awkjob, 146건) |
| S-06 | `finishing(cutting)` | 모양커팅 | `DISABLE` | `finishing(folding)` | 접지 전체 | 커팅-접지 상호배타 |
| S-07 | `finishing(cutting)` | 모양커팅 | `DISABLE` | `finishing(scoring)` | 오시/미싱 전체 | 모양커팅 시 다른 후가공 불가 |
| S-08 | `finishing(folding)` | 접지 선택 | `SET_VALUE` | `finishing(scoring)` | 오시 자동 추가 | 200g+ 종이 접지 시 오시 필수 (도메인 룰) |
| S-09 | `size` | 비규격 | `SHOW_HIDE` | `size_input` | width/height 입력 | 비규격 선택 시 입력 필드 표시 |
| S-10 | `finishing(foil)` | 박 선택 | `SHOW_HIDE` | `finishing(foil_size)` | 박원판 크기 입력 | 박 선택 시 크기/색상 입력 표시 |

#### booklet (책자)

| # | triggerOption | triggerValue | ruleType | affectedOption | affectedValues | 설명 |
|---|---|---|---|---|---|---|
| B-01 | `option(binding_type)` | 중철 | `FILTER` | `option(page_count)` | min=4, max=28, step=4 | 중철 페이지 제약 |
| B-02 | `option(binding_type)` | 무선/PUR | `FILTER` | `option(page_count)` | min=24, max=300, step=2 | 무선/PUR 페이지 제약 |
| B-03 | `option(binding_type)` | 트윈링 | `FILTER` | `option(page_count)` | min=2, max=130, step=1 | 트윈링 페이지 제약 (Red: MAX_INN_PAGE=130) |
| B-04 | `option(binding_type)` | 하드커버 | `FILTER` | `option(page_count)` | min=24, max=500, step=2 | 하드커버 페이지 제약 |
| B-05 | `finishing(coating)` | 양면코팅 | `DISABLE` | `option(binding_type)` | 무선제본 | 양면코팅+무선제본 불가 (접착면 문제) |
| B-06 | `option(binding_type)` | 트윈링 | `SHOW_HIDE` | `finishing(ring_color)` | 링색상 속성 표시 | 트윈링 선택 시 링색상 선택 표시 |
| B-07 | `option(binding_type)` | 하드커버/레더링 | `ENABLE` | `finishing(printed_endpaper)` | 인쇄면지 | 하드커버만 인쇄면지 가능 |
| B-08 | `paper(cover)` | 표지종이 변경 | `DISABLE` | `finishing(cover_coating)` | 소재별 상이 | 표지 종이-코팅 비호환 |
| B-09 | `paper(inner)` | 내지종이 | `FILTER` | `option(page_count)` | 두께 기준 max 조정 | Red: MAX_THCK=1000, INN_MAX_WGT=1000 |
| B-10 | `paper(cover)` | 표지종이 | `FILTER` | `finishing(cover_coating)` | 표지용 코팅만 | 표지 종이 평량에 따른 코팅 필터 (Red: COV_MIN_WGT=200) |

#### sticker (스티커)

| # | triggerOption | triggerValue | ruleType | affectedOption | affectedValues | 설명 |
|---|---|---|---|---|---|---|
| K-01 | `size` | 특정 사이즈 | `FILTER` | `option(cutting)` | 사이즈별 커팅 옵션 | 사이즈-커팅형 연동 |
| K-02 | `option(cutting)` | 반칼 | `ENABLE` | `option(cut_count)` | 조건수 드롭다운 | Figma STICKER: 조건수 Select (반칼 선택시) |
| K-03 | `paper` | 특수소재 | `DISABLE` | `finishing` | 일부 후가공 | 소재별 후가공 비호환 |

#### goods (아크릴/굿즈/에코백)

| # | triggerOption | triggerValue | ruleType | affectedOption | affectedValues | 설명 |
|---|---|---|---|---|---|---|
| G-01 | `size` | 사이즈 변경 | `FILTER` | `finishing(shape_cut)` | 사이즈별 모양커팅 | Red: pcs_info의 WRK_WDT/HGH가 size와 연동 |
| G-02 | `option(color)` | 투명 | `DISABLE` | `finishing(coating)` | 무광코팅 | 투명소재+무광코팅 불가 |
| G-03 | `size` | 사이즈 변경 | `RESET` | `quantity` | 수량 초기화 | 사이즈 변경 시 가격/수량 구간 변경 |

#### accessory (부자재)

| # | triggerOption | triggerValue | ruleType | affectedOption | affectedValues | 설명 |
|---|---|---|---|---|---|---|
| A-01 | - | - | - | - | - | Constraint 없음 (사이즈+수량만) |

---

## 5. 기존 스키마 수정 필요 항목 (schema.prisma diff)

### 5.1 ProductOption 모델 수정

| 필드 | 변경 유형 | 설명 |
|---|---|---|
| `componentType` | **추가** | UI 컴포넌트 타입 힌트 (Figma 10종 대응) |
| `collapsible` | **추가** | 접힘 가능 섹션 여부 (Finish Title Bar 패턴) |
| `collapsedByDefault` | **추가** | 기본 접힘 상태 (더보기/닫기) |

```prisma
model ProductOption {
  // ...기존 필드...
  componentType     ComponentType? @map("component_type")      // UI 렌더링 힌트
  collapsible       Boolean        @default(false) @map("collapsible")  // 접힘 가능 섹션
  collapsedByDefault Boolean       @default(true) @map("collapsed_by_default") // 기본 접힘
}
```

### 5.2 OptionValue 모델 수정

| 필드 | 변경 유형 | 설명 |
|---|---|---|
| `imageUrl` | **추가** | 이미지 칩용 이미지 URL |
| `colorHex` | **추가** | 색상 칩용 HEX 코드 |
| `isNew` | **추가** | 신규 뱃지 표시 (Figma: NEW badge) |
| `description` | **추가** | 옵션 설명 텍스트 (image_chip 하단 설명) |

```prisma
model OptionValue {
  // ...기존 필드...
  imageUrl    String?  @map("image_url")    // image_chip용
  colorHex    String?  @map("color_hex")    // color_chip용 (예: "#FF0000")
  isNew       Boolean  @default(false) @map("is_new")  // 신규 뱃지
  description String?  @map("description")  // 옵션 설명
}
```

### 5.3 ConstraintRuleType Enum 수정

```prisma
enum ConstraintRuleType {
  FILTER
  SHOW_HIDE
  RESET
  ENABLE
  DISABLE
  SET_VALUE    // 신규

  @@map("constraint_rule_type")
}
```

### 5.4 Product 모델에 relation 추가

```prisma
model Product {
  // ...기존 relations...
  addons       ProductAddon[] @relation("ProductAddons")
  addonOf      ProductAddon[] @relation("AddonOf")
}
```

### 5.5 OptionType Enum 수정 (quantity 추가)

현재 스키마에 수량은 별도 모델(`PriceBracket`)로 처리되나, Figma에서 수량은 다른 옵션과 동일한 UI 패턴(count_input, volume_slider)을 사용. 수량을 OptionType으로 포함하면 일관된 렌더링이 가능하다.

```prisma
enum OptionType {
  job_preset
  size
  paper
  option
  color
  color_add
  finishing
  quantity      // 신규: 수량 (count_input/volume_slider 렌더링)
  page_count    // 신규: 내지 페이지 수 (booklet 전용)

  @@map("option_type")
}
```

---

## 6. 신규 모델 (Prisma 코드)

### 6.1 ProductAddon (추가상품 연결)

```prisma
model ProductAddon {
  id              String   @id @default(cuid())
  productSlug     String   @map("product_slug")
  addonSlug       String   @map("addon_slug")
  triggerOption   String?  @map("trigger_option")
  triggerValue    String?  @map("trigger_value")
  label           String   @map("label")
  description     String?  @map("description")
  thumbnailUrl    String?  @map("thumbnail_url")
  minQty          Int      @default(0) @map("min_qty")
  defaultQty      Int      @default(0) @map("default_qty")
  sortOrder       Int      @default(0) @map("sort_order")
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  product Product @relation("ProductAddons", fields: [productSlug], references: [slug], onDelete: Cascade)
  addon   Product @relation("AddonOf", fields: [addonSlug], references: [slug], onDelete: Cascade)

  @@unique([productSlug, addonSlug, triggerOption, triggerValue])
  @@index([productSlug, isActive])
  @@index([addonSlug])
  @@map("product_addons")
}
```

### 6.2 VolumeDiscount (볼륨 할인 구간)

Figma GOODS/ACRYLIC 화면의 "제작수량별 구간할인" 슬라이더를 지원하기 위한 모델. `PriceBracket`은 단가 테이블이지 할인율/구간 표시 데이터가 아니다.

```prisma
/// 볼륨 할인 구간 — 굿즈/아크릴 제작수량별 구간할인 슬라이더용
model VolumeDiscount {
  id              String   @id @default(cuid())
  productSlug     String   @map("product_slug")
  tierLabel       String   @map("tier_label")     // "1~9개", "10~49개", "50~99개" 등
  minQty          Int      @map("min_qty")
  maxQty          Int?     @map("max_qty")         // null = 무제한
  discountPercent Decimal  @map("discount_percent") @db.Decimal(5, 2) // 할인율 (%)
  suggestedQty    Int?     @map("suggested_qty")   // 권장수량 (슬라이더 기본 위치)
  sortOrder       Int      @default(0) @map("sort_order")
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  product Product @relation(fields: [productSlug], references: [slug], onDelete: Cascade)

  @@unique([productSlug, minQty])
  @@index([productSlug, isActive])
  @@map("volume_discounts")
}
```

**Product 모델에 relation 추가:**

```prisma
model Product {
  // ...기존 relations...
  volumeDiscounts VolumeDiscount[]
}
```

### 6.3 QuantityRule (수량 생성 규칙)

RedPrinting의 `FIR_CNT/INC/INC_STEP` 패턴을 DB에 저장. size별 또는 product별 수량 생성 규칙이 다를 수 있음.

```prisma
/// 수량 생성 규칙 — RedPrinting FIR_CNT/INC/INC_STEP 패턴 대응
model QuantityRule {
  id              String   @id @default(cuid())
  productSlug     String   @map("product_slug")
  sizeValueCode   String?  @map("size_value_code")  // null=전체 사이즈 공통, 특정값=사이즈별
  ruleType        String   @default("stepper") @map("rule_type") // stepper|bracket|input
  firCnt          Int      @default(1) @map("fir_cnt")           // 시작 수량
  inc             Int      @default(1) @map("inc")               // 증가 단위
  incStep         Int      @default(10) @map("inc_step")         // 스텝 전환 기준
  minQty          Int      @default(1) @map("min_qty")
  maxQty          Int?     @map("max_qty")                        // null = 무제한
  dftQty          Int      @default(100) @map("dft_qty")         // 기본 수량
  unit            String   @default("매") @map("unit")            // 매/부/개/세트
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  product Product @relation(fields: [productSlug], references: [slug], onDelete: Cascade)

  @@unique([productSlug, sizeValueCode])
  @@index([productSlug])
  @@map("quantity_rules")
}
```

### 6.4 BookletPageRule (책자 페이지 수 규칙)

RedPrinting `pdt_prn_cnt_info`에서 확인된 책자 전용 페이지 수 규칙.

```prisma
/// 책자 페이지 수 규칙 — 제본타입별 내지 페이지 수 제약
model BookletPageRule {
  id              String   @id @default(cuid())
  productSlug     String   @map("product_slug")
  bindingType     String   @map("binding_type")      // saddle|perfect|pur|twin_ring|hardcover
  minInnerPage    Int      @map("min_inner_page")     // 최소 내지 페이지
  maxInnerPage    Int      @map("max_inner_page")     // 최대 내지 페이지
  stepInnerPage   Int      @default(2) @map("step_inner_page") // 페이지 증가 단위
  defaultPage     Int      @map("default_page")       // 기본 페이지 수
  maxThickness    Decimal? @map("max_thickness") @db.Decimal(8, 2) // 최대 두께 (mm)
  coverMinWeight  Int?     @map("cover_min_weight")   // 표지 최소 평량 (g)
  innerMaxWeight  Int?     @map("inner_max_weight")   // 내지 최대 평량 (g)
  isActive        Boolean  @default(true) @map("is_active")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  product Product @relation(fields: [productSlug], references: [slug], onDelete: Cascade)

  @@unique([productSlug, bindingType])
  @@index([productSlug])
  @@map("booklet_page_rules")
}
```

**Product 모델에 relation 추가:**

```prisma
model Product {
  // ...기존 relations...
  quantityRules    QuantityRule[]
  bookletPageRules BookletPageRule[]
}
```

---

## 7. 아키타입별 위젯 렌더링 로직

### 7.1 single_sheet (디지털인쇄 — 명함/엽서/전단지)

```
1. API: GET /widget/init?productSlug=premium-namecard
2. 렌더링 순서 (cascadeOrder 기준):
   [10] 사이즈      → button 그리드 (7개 chip)
   [20] 종이        → select 드롭다운 (NEW badge 포함)
   [30] 인쇄        → button (단면/양면)
   [35] 별색인쇄    → button 행 x 6 (CMYK별 3개씩, Figma 관찰)
   [40] 커팅        → button (3~5개)
   [50] 건수        → count_input (-, N, +) [ordcnt]
   [60] 제작수량    → count_input (-, N, +)
   --- 후가공 섹션 (collapsible, Finish Title Bar) ---
   [70] 코팅        → finish_button (라물라: 2개 chip)
   [71] 접지        → finish_button
   [72] 박 절합 기준 → finish_button (박원판) + finish_input (WxH) + color_chip (색상)
   [73] 형압        → finish_button + finish_input (WxH) + color_chip
   [74] 접시봉투    → finish_select (크기+가격 드롭다운)
   --- 추가상품 섹션 (조건부 표시) ---
   [80] 추가상품    → 썸네일 카드 (ProductAddon에서 로드)
   --- 하단 Summary ---
   [90] Summary     → 인쇄료 / 특기료 / 추가금 / 합계
   [91] Upload      → PDF 업로드 버튼 + 에디터 버튼
```

**캐스케이드 갱신 로직:**
```
사이즈 변경 → cascade([종이, 후가공, 수량, 추가상품])
종이 변경   → cascade([후가공(코팅 필터), 수량])
인쇄 변경   → cascade([수량])
후가공 변경 → validate(rst_* 상호배타) → cascade([수량])
수량 변경   → price_only()
```

### 7.2 booklet (책자)

```
1. API: GET /widget/init?productSlug=saddle-stitch-booklet
2. 렌더링 순서:
   [10] 사이즈      → button (A4/A5 등 2~4개)
   [15] 제본        → image_chip (중철/무선/PUR/트윈링 원형 이미지)
   [16] 제본방향    → button (좌철/상철)
   [17] 탕잉미      → image_chip (합지아 원형 이미지)
   [18] 탕식탈      → image_chip (표지사양 원형 이미지)
   [20] 방식        → button (좌/상 등)
   [25] 제작수량    → count_input
   --- 내지 섹션 (coverCd=2) ---
   [30] 내지종이    → select (드롭다운)
   [31] 내지인쇄    → button (단면/양면)
   [32] 내지 페이지 → count_input (min~max 표시, BookletPageRule 참조)
   --- 표지 섹션 (coverCd=1) ---
   [40] 표지종이    → select (드롭다운)
   [41] 표지인쇄    → button (단면/양면)
   [42] 표지코팅    → button (3개 chip)
   [43] 투명가바    → button (4개 chip)
   --- 후가공 섹션 (collapsible) ---
   [50] 박 절합 기준 → finish_button + finish_input + color_chip
   [51] 형압        → finish_button + finish_input + color_chip
   [55] 제본료상    → finish_select (크기+가격 드롭다운)
   --- Summary ---
   [90] Summary     → 인쇄료(내지) / 인쇄료(표지) / 박 / 기본제본료 / 합계
```

**핵심**: `coverCd` 필드로 내지(2)/표지(1)/간지(3) 옵션을 구분. ProductOption의 `coverCd` 값에 따라 섹션 분리 렌더링.

### 7.3 sticker (스티커)

```
1. 렌더링 순서:
   [10] 사이즈      → button (3개 chip)
   [20] 종이        → select (드롭다운, NEW badge)
   [30] 인쇄        → button (단면)
   [35] 별색인쇄    → button
   [40] 커팅        → button (3~4개 chip)
   [45] 조건수      → select (드롭다운, 반칼 선택 시 표시)
   [60] 제작수량    → count_input
   --- 후가공 섹션 (collapsible, 더보기) ---
   [70] 추가공      → finish_button
   --- Summary ---
   [90] Summary     → 인쇄료 / 특기료 / 추가금 / 합계
```

### 7.4 goods (굿즈/파우치)

```
1. 렌더링 순서:
   [10] 사이즈      → button (3개 chip)
   [20] 컬러        → color_chip (10개 원형 색상 스와치)
   [30] 가공        → button (2개 chip)
   [60] 제작수량    → count_input (-, N, +)
   [61] 구간할인    → volume_slider (VolumeDiscount 데이터)
   [70] 품목만      → finish_select (크기+가격 드롭다운)
   [71] 수량        → select (드롭다운)
   --- Summary ---
   [90] Summary     → 사이즈 / 할인금액(-) / 추가금 / 합계
```

### 7.5 acrylic (아크릴)

```
1. 렌더링 순서:
   [10] 사이즈      → button (7개 chip 그리드)
   [15] 크기 직접입력 → finish_input (W x H, 비규격 선택 시)
   [20] 소재        → button (투명아크릴 3mm 등, 1개 고정인 경우 있음)
   [25] 호치수      → select (드롭다운)
   [30] 가공        → button (3개 chip)
   [60] 제작수량    → count_input
   [61] 구간할인    → volume_slider
   [70] 품목만      → finish_select (드롭다운)
   [71] 수량        → select
   --- Summary ---
   [90] Summary     → 사이즈 / 할인금액(-) / 추가금 / 합계
```

### 7.6 accessory (액세서리)

```
1. 렌더링 순서:
   [10] 사이즈      → button (2개 chip)
   [60] 수량        → count_input
   --- Summary (간소화) ---
   [90] 합계금액만 표시 (분해 없음)
   [91] 장바구니담기 버튼 (에디터/업로드 없음)
```

### 7.7 공통 렌더링 알고리즘

```typescript
function renderWidget(product: Product, options: ProductOption[]) {
  // 1. 아키타입별 활성 레이어 결정
  const activeLayers = getActiveLayers(product.archetype);

  // 2. coverCd별 옵션 그룹핑 (booklet만 해당)
  const optionsByCover = groupBy(options, o => o.coverCd);

  // 3. cascadeOrder 순서로 정렬
  const sorted = sortBy(options.filter(o => activeLayers.includes(o.optionType)), 'cascadeOrder');

  // 4. 각 옵션 렌더링
  for (const option of sorted) {
    // 4a. SHOW_HIDE constraint 체크
    if (isHidden(option, currentSelections)) continue;

    // 4b. collapsible 섹션 처리 (finishing 그룹)
    if (option.collapsible) renderCollapsibleHeader(option);

    // 4c. componentType에 따른 컴포넌트 렌더링
    switch (option.componentType) {
      case 'button':        renderButtonGrid(option.values); break;
      case 'select':        renderDropdown(option.values); break;
      case 'count_input':   renderStepper(option, quantityRule); break;
      case 'color_chip':    renderColorSwatches(option.values); break;
      case 'image_chip':    renderImageChips(option.values); break;
      case 'finish_button': renderFinishButtons(option.values); break;
      case 'finish_input':  renderSizeInput(option.values[0].metadata.sizeInput); break;
      case 'finish_select': renderFinishSelect(option.values, finishingBrackets); break;
      case 'volume_slider': renderVolumeSlider(volumeDiscounts); break;
      case 'hidden':        autoSelectDefault(option); break;
    }

    // 4d. 각 값에 disabled 상태 + 사유 적용
    applyConstraints(option, currentSelections);

    // 4e. isNew badge 표시
    renderNewBadges(option.values.filter(v => v.isNew));
  }

  // 5. 추가상품 섹션 (ProductAddon)
  renderAddons(product.addons, currentSelections);

  // 6. Summary (가격 분해)
  renderSummary(priceBreakdown);

  // 7. Upload/Editor 버튼
  if (product.archetype !== 'accessory') renderUploadSection(product);
}
```

---

## 8. 미해결 질문 (팀 결정 필요)

### P0 (구현 블로커)

| # | 질문 | 선택지 | 영향 범위 | 권장안 |
|---|---|---|---|---|
| Q1 | `componentType`을 DB에 저장할 것인가, API에서 런타임 산출할 것인가? | (A) DB 저장: `ProductOption.componentType` 컬럼 추가 / (B) API 산출: optionType + 값 개수 + archetype으로 서버 로직에서 결정 | 전체 위젯 | **(A) DB 저장 권장**. Figma 관찰 결과 동일 optionType이 아키타입에 따라 다른 componentType을 사용하므로, 상품별 명시적 지정이 안전. |
| Q2 | 후가공 속성(ATTB)을 별도 모델로 분리할 것인가, metadata에 인라인할 것인가? | (A) `OptionValue.metadata.attributes[]` 인라인 / (B) 별도 `FinishingAttribute` 모델 | 후가공 UI | **(A) 인라인 권장**. 속성 수가 적고(링색상 4개, 박종류 2-3개) 항상 부모 후가공과 함께 로드됨. |
| Q3 | 수량 모델을 `QuantityRule` 신규 모델로 갈 것인가, `OptionValue.metadata`에 인라인할 것인가? | (A) 별도 `QuantityRule` 모델 / (B) size metadata에 `quantityRule` JSON 포함 | 수량 UI | **(A) 별도 모델 권장**. 사이즈별 수량 규칙이 다르고, 조회/수정이 독립적. |

### P1 (구현 순서 영향)

| # | 질문 | 설명 |
|---|---|---|
| Q4 | Figma의 "추가료" 좌측 썸네일 패널은 ProductAddon으로 구현하는가, 별도 마케팅 컴포넌트인가? | Figma PRINT 화면 좌측에 "관련 상품 추가" 패널이 썸네일+설명으로 존재. 이것이 DB-driven인지 CMS-driven인지 결정 필요. |
| Q5 | 볼륨 할인 구간(VolumeDiscount)이 WowPress API에서 동적으로 조회 가능한가, 아니면 DB에 시드해야 하는가? | WowPress `cjson_jobcost` 응답에 할인 구간 데이터가 포함되는지 확인 필요. |
| Q6 | Figma BOOK 화면의 "탕잉미"/"탕식탈"은 WowPress의 어떤 필드에 대응하는가? | 이미지 칩으로 제본타입/커버타입을 선택하는 패턴인데, WowPress API의 `coverinfo`/`awkjobinfo` 중 어디에 매핑되는지 확인 필요. |
| Q7 | `isNew` badge는 Product 레벨(현재 `Product.isNew`)과 OptionValue 레벨 모두 필요한가? | Figma에서 종이 드롭다운 내 개별 옵션에도 NEW badge가 있음. 현재 `Product.isNew`만 존재. |

### P2 (Phase 2 이후)

| # | 질문 | 설명 |
|---|---|---|
| Q8 | NCR 상품의 다층 용지 선택 (상지/중지/하지)은 어떤 컴포넌트로 렌더링하는가? | 현재 스키마에 NCR 전용 구조 없음. 별도 아키타입 또는 option metadata 확장 필요. |
| Q9 | 에디터 전용 상품(포토북, 디자인캘린더)의 위젯 표시 범위는? | Figma에 별도 화면 존재하나 옵션이 최소화됨. Phase 2 에디터 연동 시 결정. |
| Q10 | 실사/현수막(large_format)의 면적 기반 가격 표시를 위젯에서 실시간 계산할 것인가? | PriceFormula 패턴 D(area-proportional)의 클라이언트 사이드 계산 여부. |

---

## 부록: 전체 스키마 변경 요약

### 신규 Enum (1개)
- `ComponentType` (10종)

### 신규 모델 (4개)
- `ProductAddon` — 추가상품 연결
- `VolumeDiscount` — 볼륨 할인 구간 (슬라이더용)
- `QuantityRule` — 수량 생성 규칙
- `BookletPageRule` — 책자 페이지 수 규칙

### 기존 Enum 수정 (2개)
- `ConstraintRuleType` += `SET_VALUE`
- `OptionType` += `quantity`, `page_count`

### 기존 모델 수정 (3개)
- `Product` += `addons`, `addonOf`, `volumeDiscounts`, `quantityRules`, `bookletPageRules` relations
- `ProductOption` += `componentType`, `collapsible`, `collapsedByDefault`
- `OptionValue` += `imageUrl`, `colorHex`, `isNew`, `description`

### metadata JSONB 보강 (3개 타입)
- `size` += `thumbnailUrl`, `productSizeInfo`
- `paper` += `thickness`, `swatchImageUrl`, `isNew`
- `finishing` += `pcsCode`, `pcsDtlCode`, `viewYn`, `essentialYn`, `attributes[]`, `sizeInput`, `qtyConstraint`

---

*본 보고서는 schema.prisma, WowPress API captures (namecard/booklet), RedPrinting v2 captures (PRBKORD/GSTGMIC), Figma 12개 아키타입 화면, 01_api-analyst_data-model.md, 02_modeler_product-schema.md, 03_gap_analysis.md 7개 산출물을 교차 분석하여 작성되었습니다.*
