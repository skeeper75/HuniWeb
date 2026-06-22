# Form Builder — 옵션 폼 빌더 사양 v0.1

- 상태: Draft
- 작성일: 2026-05-27
- 작성자: pq-architect
- 관련: domain-model.md §2.4~2.6 (Specification/SpecOption/OptionGroup), block-schema.md §2.7 (option_panel), §2.9 (form_field), pricing-engine.md §5
- 산출 경로: `_workspace/print-quote/03_architecture/builder-engine/form-builder.md`

자체 폼 빌더의 명세. As-Is `TM Extra Product Options & Add-Ons 7.5.3`의 `tm_meta_cpf` (mode=builder)를 1:1 대체. 두 종류의 폼을 단일 평면에서 다룬다:

1. **option_panel** (견적 폼) — 상품 사양 입력 + 실시간 가격 산출 (block-schema.md §2.7)
2. **form_field** (일반 폼) — 문의/회원가입/연락처 등 (§2.9)

---

## 0. 두 폼의 공통 모델

| 차원 | option_panel | form_field |
|---|---|---|
| 데이터 소스 | `product_specifications` 마스터 | 빌더 자체 정의 |
| 검증 | `SpecRule` (의존성) + Zod | Zod만 |
| 가격 영향 | **있음** (pricing-engine 입력) | 없음 |
| 제출 액션 | `save_quote` / `open_editor` / `add_to_cart` | `submit_form` (POST) |
| 영속 | `Quote.widget_state` + `quote_lines.spec_snapshot` | `form_submissions` (별도) |

공통 필드 타입은 §2에서 정의.

---

## 1. 폼 스키마 구조 (Zod)

```ts
// option_panel.tsx, FormBuilder.tsx 양쪽이 사용
export const FormSchema = z.object({
  id: z.string().uuid(),
  type: z.enum(['option_panel', 'form']),
  product_id: z.string().uuid().optional(),       // option_panel만
  layout: z.enum(['stepped', 'single_page', 'sidebar', 'accordion']),
  steps: z.array(StepSchema).optional(),           // stepped layout만
  fields: z.array(FieldSchema),                    // single_page / sidebar
  submit_action: SubmitActionSchema,
  realtime_price: z.boolean().default(false),     // option_panel만
  debounce_ms: z.number().default(300),
});

export const StepSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string().optional(),
  fields: z.array(FieldSchema),
  skip_condition: ConditionSchema.optional(),
  is_required: z.boolean().default(true),
});

export const FieldSchema = z.object({
  id: z.string(),
  key: z.string(),                              // 데이터 key (spec.name 또는 form field name)
  type: FieldTypeSchema,                         // §2 참조
  label: z.string(),
  placeholder: z.string().optional(),
  help_text: z.string().optional(),
  spec_id: z.string().uuid().optional(),         // option_panel: Specification 마스터 참조
  options: z.array(OptionSchema).optional(),    // select/radio/swatch
  default_value: z.unknown().optional(),
  required: z.boolean().default(false),
  validation: ValidationSchema,
  display: DisplaySchema,                        // 시각·레이아웃 옵션
  conditional: ConditionSchema.optional(),       // 조건부 표시
  price_impact: PriceImpactSchema.optional(),    // option_panel 전용
});
```

---

## 2. Field Type 카탈로그

### 2.1 V1 (필수 — 한국 인쇄 도메인 최소 셋)

| Type | 설명 | UI 예시 | 사용 케이스 (예) |
|---|---|---|---|
| `text` | 단일 행 텍스트 | input | 주문자명, 메모 |
| `textarea` | 다중 행 텍스트 | textarea | 주문 요청사항 |
| `email` | 이메일 (검증 포함) | input[type=email] | 문의 폼 |
| `tel` | 전화번호 (한국 포맷) | input[type=tel] | 주문자 연락처 |
| `number` | 숫자 (min/max/step) | input[type=number] | 수량 |
| `slider` | 슬라이더 | range | 수량 (대량 인쇄, 5000~100000) |
| `select` | 드롭다운 | select | 종이/소재 (다 옵션) |
| `radio` | 단일 선택 (라디오) | radio group | 단/양면, 코팅 유무 |
| `checkbox` | 다중 선택 | checkbox group | 후가공 (코팅+박+오시 조합) |
| `swatch` | 색상/스와치 | clickable thumbnail | 종이 색상, 별색 |
| `image_grid` | 이미지 그리드 (제품 사양 시각화) | grid of cards | 모양엽서 모양 선택 |
| `quantity` | 인쇄 전용 수량 (step + brackets 표시) | input + bracket hint | "100~499매 단가 50원, 500매~ 40원" |
| `size_select` | 규격 사이즈 선택 | select | "A6 (105×148mm)" |
| `size_custom` | 자유형 사이즈 (W×H mm) | 2 input + 면적 표시 | 반칼 자유형 스티커 |
| `file_upload` | 파일 업로드 | dropzone | 작업파일 직접 업로드 |
| `date` | 날짜 (납기) | input[type=date] | 긴급 납기 |

### 2.2 V2 (확장)

| Type | 설명 |
|---|---|
| `image_swatch` | 이미지 + 라벨 스와치 (종이 질감 미리보기) |
| `repeater` | 반복 필드 그룹 (책자 페이지별 옵션) |
| `vdp_field_definitions` | VDP 필드 정의 + 데이터 행 업로드 |
| `address_autocomplete` | 도로명 주소 검색 (다음 우편번호) |
| `address_book_picker` | 회원 주소록에서 선택 |
| `signature` | 디지털 서명 (canvas) |
| `consent_checkbox` | 약관 동의 (필수 표기 + 링크) |

### 2.3 V3 (선택)

| Type | 설명 |
|---|---|
| `payment_method_picker` | PG 선택 UI |
| `coupon_input` | 쿠폰 코드 + 즉시 적용 |
| `loyalty_slider` | 적립금 사용량 슬라이더 |
| `template_picker` | 디자인 템플릿 갤러리 |

---

## 3. ValidationSchema

```ts
export const ValidationSchema = z.object({
  required: z.boolean().default(false),
  min: z.number().optional(),
  max: z.number().optional(),
  minLength: z.number().optional(),
  maxLength: z.number().optional(),
  step: z.number().optional(),
  pattern: z.string().optional(),               // regex
  email: z.boolean().optional(),
  url: z.boolean().optional(),
  phone_kr: z.boolean().optional(),             // 한국 전화 포맷
  file: z.object({
    max_size_bytes: z.number(),
    accept_mime: z.array(z.string()),           // ['application/pdf','image/*']
    max_files: z.number().default(1),
  }).optional(),
  custom: z.string().optional(),                // expression (block-schema.md §4 평가기)
  error_messages: z.record(z.string()).optional(),
});
```

검증 시점:
- **Client (onChange/onBlur)**: 즉시 피드백
- **Client (onSubmit)**: 종합 검증
- **Server (Zod parse)**: 신뢰 경계 (BFF가 항상 재검증)

custom 검증 예시:
```
"value <= paper.max_size_mm"          // 자유형 사이즈가 종이 한계 미만
"binding === 'PUR' && quantity >= 200" // PUR 제본은 200부 이상
```

---

## 4. 조건부 표시·검증 룰 (ConditionSchema)

block-schema.md §1.3의 `ConditionSchema`를 재사용. 표현식은 §4 데이터 바인딩 평가기로 평가.

```ts
// field.conditional 예시
{
  when: "options.binding === 'hardcover'",
  visibility: 'show',           // hardcover일 때만 표시
  mode: 'client'
}

// 또는 step.skip_condition
{
  when: "options.special_color === 'none'",
  visibility: 'hide',           // 별색 안 쓰면 step 자체 skip
}
```

평가 컨텍스트:
- `options.{field_key}` — 폼의 다른 필드 값
- `product.{field}` — 현재 상품 메타
- `member.{field}` — 회원 정보
- `now` — 현재 시각

`SpecRule` 통합:
- product_spec_rules의 `enable/disable/require` 룰은 자동으로 ConditionSchema로 컴파일 (form-builder 빌드 시점)
- 룰의 `condition_option_id`가 선택되면 `target_spec_id`의 visibility/required가 토글

---

## 5. PriceImpactSchema (option_panel 전용)

```ts
export const PriceImpactSchema = z.object({
  spec_id: z.string().uuid(),
  surcharge_link: z.array(z.object({
    option_id: z.string().uuid(),
    surcharge_id: z.string().uuid(),       // spec_option_surcharges
    cost_type: z.enum(['per_unit', 'fixed', 'percentage']),
    display: z.enum(['show', 'hide']).default('show'),
  })),
});
```

UI 가격 영향 표시 정책:
- `display='show'` → 옵션 라벨 옆에 "(+1,500원)" 또는 "(+10%)" 가산 표시
- 사용자 옵션 변경 → debounce 300ms → POST `/api/products/[code]/pricing` → breakdown 갱신
- 응답의 `QuoteResult.breakdown[]`를 step별로 토글 표시 가능

---

## 6. 견적 폼 → pricing-engine 매핑

```
폼 입력 (option_panel state)
    ↓
{ specName: optionValue, ... }
    ↓ (FormBuilder.onSubmit / debounce)
QuoteInput {
  productId,
  options: { specName: optionValue, ... },
  quantity,
  customSize?: { widthMm, heightMm },
  rushDeliveryDate?,
  context: { customerGrade, coupons, ... }
}
    ↓ POST /api/products/[code]/pricing
calculateQuote(input, catalog, config)
    ↓
QuoteResult { grandTotal, breakdown[], warnings[] }
    ↓
UI 갱신 (quote_preview 위젯 + option_panel breakdown 표시)
```

**핵심:** form-builder는 UI 폼만 관리, 가격 산출은 항상 pricing-engine에 위임. Client에서는 캐시된 결과만 표시 (5초 TTL).

---

## 7. As-Is `tm_meta_cpf` (builder mode) 흡수

`crawl-evidence/2026-05-27_buysangsang/C_findings.md` §"상품 메타"에서 식별된 풀 구조.

| As-Is TM EPO 메타 | To-Be 폼 빌더 매핑 |
|---|---|
| `tm_meta_cpf.mode = 'builder'` | `FormSchema.type = 'option_panel'` |
| `tm_meta_cpf.price_display_mode` | `widget_configs.realtime_price_enabled` |
| `tm_meta_cpf.sections[]` | `FormSchema.steps[]` (stepped layout) |
| `tm_meta_cpf.fields[]` | `StepSchema.fields[]` |
| `field.type` ('select'/'radio'/'checkbox'/'textfield'/'datepicker') | `FieldSchema.type` |
| `field.rules` (TM EPO Conditional) | `FieldSchema.conditional` |
| `field.price` ({fixed/percentage/per_unit}) | `PriceImpactSchema.surcharge_link[].cost_type` |
| `field.is_required` | `FieldSchema.required` |
| `field.options[].text` / `value` / `price` | `OptionSchema { label, value, surcharge_id }` |

마이그레이션 스크립트(`scripts/migrate-tm-epo.ts`)가 buysangsang의 `tm_meta_cpf` JSON을 파싱하여 `product_specifications` + `product_spec_options` + `spec_option_surcharges` 행으로 변환.

---

## 8. 어드민 폼 빌더 UI

운영자가 코드 없이 폼을 만드는 화면. As-Is의 TM EPO 어드민 패널 대체.

### 8.1 좌측 — 필드 팔레트
- §2 V1 16종 필드 타입을 drag-drop으로 캔버스에 추가
- 카테고리: Basic / Choice / Visual / Print-Quote-Specific / File

### 8.2 중앙 — 캔버스
- 스텝/필드 트리 시각화
- 미리보기 모드 (실제 렌더 비교)

### 8.3 우측 — 속성 패널
- 선택된 필드의 props 편집 (Zod schema → react-jsonschema-form 자동 생성)
- 검증 룰
- 조건부 표시 (when 표현식 빌더 — 추후 GUI)
- 가격 영향 (spec_option_surcharges drop-down)

### 8.4 액션
- 발행/임시 저장 → `widget_configs` + `widget_steps` + `widget_step_fields` 영속
- 버전 관리 → 발행 시 snapshot 보존

---

## 9. 빌더 단계 정책 (Wizard vs Single Page)

| Layout | 사용 케이스 | 특성 |
|---|---|---|
| `stepped` | 명함·엽서·스티커 등 사양이 6+ 단계 | 단계별 가격 변화 표시, 뒤로 가기 가능 |
| `single_page` | 단순 상품 (포카드·라벨 등) | 한 화면, 즉시 가격 산출 |
| `sidebar` | 상품 상세 페이지 안의 카드 | 견적 결과를 sticky sidebar로 |
| `accordion` | 복잡 상품 (책자 — 표지/내지/제본/마감) | 섹션별 접기, 컴팩트 |

`product.metadata.preferred_form_layout`으로 상품별 기본값 저장.

---

## 10. V1·V2·V3 단계별 범위

### V1 (Big-Bang 컷오버 시점) — 필수

폼 타입:
- text / textarea / email / tel / number / select / radio / checkbox / quantity
- size_select / size_custom / file_upload / swatch / image_grid

기능:
- stepped + single_page + sidebar layout
- ConditionSchema (when 평가)
- ValidationSchema 기본 (required/min/max/pattern/file)
- SpecRule 자동 컴파일 (enable/disable/require)
- 실시간 가격 산출 (debounce 300ms)
- 게스트 진행 가능

미포함 (V2 이후):
- 어드민 GUI 폼 빌더 (V1은 JSON 직접 편집 또는 임포터 스크립트 사용)
- 다중 언어 i18n (V1은 한국어만)
- 결제 화면 자체 위젯 (V1은 별도 페이지)

### V2 (3~6개월 후)

폼 타입 추가:
- repeater / address_autocomplete / address_book_picker
- vdp_field_definitions / consent_checkbox / signature

기능:
- 어드민 GUI 폼 빌더 (drag-drop)
- i18n (한국어 / 영어)
- 폼 분석 (`widget_analytics` 활용)
- 조건부 가격 룰 (when 식이 SurchargeRule로 변환)
- A/B 테스트 (폼 변형별 전환율)

### V3 (1년+)

- payment_method_picker / coupon_input / loyalty_slider / template_picker
- AI 어시스턴트 (옵션 추천)
- 음성 입력 (모바일)
- 폼 자동 저장 + 이어하기 (member 한정)

---

## 11. 데이터 영속 (DB 매핑)

| FormSchema 요소 | DB 테이블 |
|---|---|
| FormSchema (option_panel 메타) | `widget_configs` (베이스라인) |
| StepSchema | `widget_steps` |
| FieldSchema | `widget_step_fields` |
| ConditionSchema (필드 조건) | `widget_conditional_rules` |
| 미리보기 템플릿 | `preview_templates` |
| 사용자 작성 견적 입력 | `quotes.widget_state` (재진입 시 복원) |
| 견적 라인의 스냅샷 | `quote_lines.spec_snapshot` |
| form 제출 (일반 폼) | `form_submissions` (V2 신규 — schema.sql에 미포함, 별도 추가) |

베이스라인의 widget 도메인 7테이블이 이 폼 빌더의 1차 영속 저장소. 신규 schema.sql은 변경 없음 (베이스라인 보존 정책).

---

## 12. 검증 단계 — 신뢰 경계

```
[1] Browser onChange/onBlur     — UX 즉시 피드백 (errors[fieldKey])
[2] Browser onSubmit            — 종합 검증 (모든 필드 + Condition)
[3] BFF Zod parse               — 신뢰 경계, 클라이언트 우회 방어
[4] Pricing Engine validate()   — SpecRule + min/max qty 등 (pricing-engine.md §4 Step 0)
[5] DB Constraint               — UNIQUE / FK / CHECK
```

순서 보장:
- 1·2가 실패하면 3 진입 차단
- 3 실패 → `ValidationError` + 400 응답
- 4 실패 → `QuoteValidationError` + 400 (pricing 계산 진입 차단)
- 5 실패 → 500 (내부 무결성 위반, 운영 알림)

---

## 13. 실시간 가격 갱신 UX

```
사용자 옵션 변경
    ↓ (state update)
debounce 300ms
    ↓
optimistic UI (이전 결과 회색조 처리)
    ↓
POST /api/products/[code]/pricing
    ↓ (≤200ms typical, cache hit ≤50ms)
QuoteResult arrives
    ↓
breakdown[] 항목별 애니메이션 (변경된 항목 highlight 1초)
    ↓
quote_preview 위젯 갱신 + option_panel 우측 가격 라벨 갱신
```

오류 처리:
- API 실패 → 이전 가격 유지 + 작은 토스트 ("가격 산출 실패. 잠시 후 재시도")
- 5회 연속 실패 → circuit break + "잠시 후 새로고침" 안내

---

## 14. Open Questions

| ID | 질문 | 영향 |
|---|---|---|
| O-FB-1 | 어드민 GUI 폼 빌더 V1 포함 여부 (V2로 미루기 vs V1 슬림 GUI) | 컷오버 분량 |
| O-FB-2 | `tm_meta_cpf` 데이터 마이그레이션 자동화 정도 (auto + 수동 보정 vs 운영자 재입력) | O-005 의존 |
| O-FB-3 | 다국어 i18n V1 포함 여부 (As-Is 한국어 only — V1 보류 가능) | V1 범위 |
| O-FB-4 | 책자 페이지별 다른 옵션 (repeater) V1 vs V2 — 책자가 V1 핵심 SKU(006-0001~)면 V1 필요 | V1 범위 |
| O-FB-5 | 폼 자동 저장 (서버) — 게스트는 localStorage, 회원은 DB? | UX 정책 |

---

REQ coverage: REQ-FORM-BUILDER-001~008  
References: domain-model.md §2.3~2.6, block-schema.md §2.7, §2.9, pricing-engine.md §5, crawl-evidence/2026-05-27_buysangsang/C_findings.md (TM EPO), _baseline/05_widget_schema.sql, _baseline/07_integrated_schema.sql §6
