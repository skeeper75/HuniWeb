# Block Schema — 위젯 prop 표준 v0.1

- 작성일: 2026-05-27
- 작성자: pq-architect
- 관련: domain-model.md §1 (Builder Domain), widget-coverage-matrix.md
- 산출 경로: `_workspace/print-quote/03_architecture/builder-engine/block-schema.md`

자체 빌더의 모든 `Block` 인스턴스가 따르는 props 스키마 표준. As-Is의 Elementor controls(JSON 직렬화) + TM EPO `tm_meta_cpf` builder mode 를 대체.

---

## 1. 표준 직렬화 포맷

### 1.1 Block 직렬화 (DB `block.props` JSONB)

```ts
// Zod (런타임 검증) + JSONSchema (어드민 UI 자동 생성)
const BlockSchema = z.object({
  id: z.string().uuid(),
  widget: z.string(),         // Widget.code
  version: z.number().int(),  // schema version
  props: z.record(z.unknown()), // widget-specific (아래 §2)
  bindings: z.record(z.string()).optional(),   // {propPath: bindingExpression}
  style: StyleSchema.optional(),
  condition: ConditionSchema.optional(),
  children: z.array(BlockSchema).optional(),   // nested blocks
});
```

### 1.2 Style 공통 스키마

```ts
const StyleSchema = z.object({
  margin: SpacingSchema.optional(),    // {top, right, bottom, left, responsive?}
  padding: SpacingSchema.optional(),
  color: z.string().optional(),         // token ref or hex
  background: BackgroundSchema.optional(),
  typography: TypographyTokenSchema.optional(),
  border: BorderSchema.optional(),
  radius: z.string().optional(),
  shadow: z.string().optional(),
  custom_css: z.string().optional(),    // escape hatch
}).strict();

const SpacingSchema = z.object({
  top: z.number().or(z.string()),
  right: z.number().or(z.string()),
  bottom: z.number().or(z.string()),
  left: z.number().or(z.string()),
  responsive: z.object({
    tablet: SpacingValueSchema.optional(),
    mobile: SpacingValueSchema.optional(),
  }).optional(),
});
```

### 1.3 Condition (조건부 표시)

```ts
const ConditionSchema = z.object({
  when: z.string(),                // expression: "qty >= 500 && paper === 'art_250'"
  visibility: z.enum(['show', 'hide', 'disable']),
  mode: z.enum(['client', 'server']).default('client'),
});
```

---

## 2. 위젯별 prop 카탈로그 (V1: 14개)

각 위젯의 `prop_schema`는 DB `widgets.prop_schema` JSONB로 저장 + 코드의 Zod로 검증.

### 2.1 `section` (Layout) [layout]
```ts
{
  width: z.enum(['boxed','full','wide']).default('boxed'),
  height: z.union([z.literal('auto'), z.string()]).default('auto'),
  background: BackgroundSchema.optional(),
  gap: z.number().default(0),
}
```

### 2.2 `column` (Layout) [layout]
```ts
{
  span: z.number().min(1).max(12).default(12),
  span_tablet: z.number().min(1).max(12).optional(),
  span_mobile: z.number().min(1).max(12).optional(),
  align_self: z.enum(['start','center','end','stretch']).default('stretch'),
}
```

### 2.3 `text` (Content) [content]
```ts
{
  content: z.string(),                 // HTML or markdown
  format: z.enum(['plain','rich','markdown']).default('rich'),
  tag: z.enum(['p','h1','h2','h3','h4','h5','h6','span']).default('p'),
  align: z.enum(['left','center','right','justify']).default('left'),
  // bindings supported: content can be "{{product.description}}"
}
```

### 2.4 `image` (Content) [content]
```ts
{
  src: z.string().url(),               // can be binding "{{product.thumbnail_url}}"
  alt: z.string(),
  width: z.union([z.number(), z.string()]).optional(),
  height: z.union([z.number(), z.string()]).optional(),
  fit: z.enum(['cover','contain','fill']).default('cover'),
  href: z.string().url().optional(),   // wrap in <a>
  loading: z.enum(['eager','lazy']).default('lazy'),
}
```

### 2.5 `button` (Content) [content]
```ts
{
  label: z.string(),
  variant: z.enum(['primary','secondary','outline','ghost','link']).default('primary'),
  size: z.enum(['sm','md','lg']).default('md'),
  href: z.string().optional(),
  action: z.enum(['link','submit','open_editor','add_to_cart','open_modal']).optional(),
  action_payload: z.record(z.unknown()).optional(),  // {modal_id, product_code, ...}
  icon_left: z.string().optional(),
  icon_right: z.string().optional(),
  disabled: z.boolean().default(false),
}
```

### 2.6 `product_gallery` (Commerce) [commerce]
상품 리스트 (홈 / 카테고리 / 검색결과). As-Is `woocommerce_product` 위젯 대체.

```ts
{
  source: z.enum(['category','manual','search','best','new']).default('category'),
  category_id: z.string().uuid().optional(),
  product_ids: z.array(z.string().uuid()).optional(),
  limit: z.number().min(1).max(100).default(12),
  columns: z.number().min(1).max(6).default(4),
  columns_mobile: z.number().min(1).max(3).default(2),
  show: z.object({
    price: z.boolean().default(true),
    badge: z.boolean().default(true),
    quick_view: z.boolean().default(false),
  }),
  sort: z.enum(['default','price_asc','price_desc','newest','popular']).default('default'),
}
```

### 2.7 `option_panel` (Print-Quote) [print_quote] ⭐ 핵심
TM EPO + Tiered Pricing 대체. 견적 마법사의 옵션 입력 영역.

```ts
{
  product_id: z.string().uuid(),       // or binding "{{product.id}}"
  layout: z.enum(['stepped','single_page','sidebar']).default('stepped'),
  show_realtime_price: z.boolean().default(true),
  debounce_ms: z.number().default(300),
  step_overrides: z.array(z.object({
    spec_name: z.string(),             // matches Specification.name
    display_as: z.enum(['radio','select','swatch','slider','image_grid']).optional(),
    grouping: z.string().optional(),   // OptionGroup.code
    visible: z.boolean().default(true),
  })).optional(),
  cta_label: z.string().default('견적 진행'),
  cta_action: z.enum(['add_to_cart','open_editor','save_quote']).default('open_editor'),
}
```

→ 이 위젯이 빌더의 가장 큰 신규 설계. form-builder.md에서 상세화.

### 2.8 `quote_preview` (Print-Quote) [print_quote]
현재 견적 요약 (사이드바, 결제 진입 직전).

```ts
{
  quote_id: z.string().uuid().optional(),  // omitted → current session quote
  show: z.object({
    line_items: z.boolean().default(true),
    breakdown: z.boolean().default(true),    // setup_fee, surcharge, discount, VAT
    delivery_estimate: z.boolean().default(true),
  }),
  sticky: z.boolean().default(false),
}
```

### 2.9 `form_field` (Form) [form]
일반 폼 필드 (문의, 회원가입 등). `option_panel`과 별개 — 견적 외 폼용.

```ts
{
  field_key: z.string(),
  field_type: z.enum(['text','email','tel','number','textarea','select','radio','checkbox','file','date']),
  label: z.string(),
  placeholder: z.string().optional(),
  required: z.boolean().default(false),
  validation: ValidationRulesSchema,    // see §3
  options: z.array(z.object({ value: z.string(), label: z.string() })).optional(),
  help_text: z.string().optional(),
}
```

### 2.10 `media_slider` (Content) [content]
Slider Revolution 대체. 히어로 슬라이드 / 배너 카루셀.

```ts
{
  slides: z.array(z.object({
    image_url: z.string(),
    headline: z.string().optional(),
    sub: z.string().optional(),
    cta_label: z.string().optional(),
    cta_href: z.string().optional(),
    overlay_opacity: z.number().min(0).max(1).default(0.3),
  })),
  autoplay: z.boolean().default(true),
  interval_ms: z.number().default(5000),
  navigation: z.enum(['arrows','dots','both','none']).default('dots'),
  height: z.string().default('480px'),
}
```

### 2.11 `tabs` (Layout) [layout]
JetTabs 대체. children은 nested Block 트리.

```ts
{
  variant: z.enum(['horizontal','vertical','accordion']).default('horizontal'),
  tabs: z.array(z.object({
    id: z.string(),
    label: z.string(),
    icon: z.string().optional(),
  })),
  active_default: z.string(),         // tab id
}
// children: 각 tab id 별 nested Block trees (parent_block_id로 묶임)
```

### 2.12 `mega_menu` (Layout) [layout]
Max Mega Menu 대체. 헤더 네비게이션 전용.

```ts
{
  items: z.array(z.object({
    label: z.string(),
    href: z.string().optional(),
    columns: z.array(z.object({
      title: z.string().optional(),
      links: z.array(z.object({ label: z.string(), href: z.string() })),
    })).optional(),
    featured: z.object({
      image_url: z.string(),
      label: z.string(),
      href: z.string(),
    }).optional(),
  })),
}
```

### 2.13 `edicus_slot` (Print-Quote) [print_quote]
디자인 에디터 진입 slot. 실제 iframe은 EdicusEditor 컴포넌트가 채움.

```ts
{
  product_id: z.string().uuid(),
  editor_mode: z.enum(['iframe','passive','lite','vdp']).default('iframe'),
  template_id: z.string().optional(),  // EditorTemplate.resource_id
  height: z.string().default('100vh'),
  vdp_fields: z.array(z.object({
    key: z.string(), label: z.string(),
    type: z.enum(['text','number','date']),
    required: z.boolean().default(false),
    defaultValue: z.string().optional(),
  })).optional(),
}
```

출처: `docs/edicus.man/src/components/editor/EdicusEditor.tsx`, `VdpEditor.tsx:15-26`.

### 2.14 `rich_card` (Content) [content]
상품 미리보기 카드 (홈 카테고리 / 큐레이션).

```ts
{
  image_url: z.string(),
  title: z.string(),
  description: z.string().optional(),
  price: z.string().optional(),     // pre-formatted or binding
  badge: z.string().optional(),
  href: z.string(),
  layout: z.enum(['vertical','horizontal']).default('vertical'),
}
```

---

## 3. Validation 룰 표준

`widget_step_fields.validation_rules` JSONB의 표준 키.

```ts
const ValidationRulesSchema = z.object({
  required: z.boolean().default(false),
  min: z.number().optional(),
  max: z.number().optional(),
  minLength: z.number().optional(),
  maxLength: z.number().optional(),
  pattern: z.string().optional(),       // regex
  step: z.number().optional(),           // for slider/number
  email: z.boolean().optional(),
  url: z.boolean().optional(),
  custom: z.string().optional(),         // expression: "value > paper.weight"
  error_messages: z.record(z.string()).optional(),
});
```

---

## 4. 데이터 바인딩 (Binding Expression)

### 4.1 문법

- `{{name}}` — `Binding` 마스터에서 lookup
- `{{name.field}}` — dot path
- `{{name.field|filter}}` — pipe filter (`|currency`, `|date:yyyy-MM-dd`, `|uppercase`)
- `{{expr | default:'기본값'}}` — fallback
- 표현식 평가 컨텍스트:
  - `product` — 현재 상품 (URL `/{slug}` 또는 widget config)
  - `quote` — 현재 견적 세션
  - `member` — 로그인 회원 (게스트면 null)
  - `cart` — 카트
  - `cms` — 페이지 메타 (`cms.page.title`)
  - `system` — `system.currency`, `system.vat_rate`, `system.now`

### 4.2 사용 예시

```jsonc
// Block.props for `text` widget
{
  "content": "안녕하세요, {{member.name | default:'고객'}}님",
  "tag": "h2"
}

// Block.props for `image`
{
  "src": "{{product.thumbnail_url}}",
  "alt": "{{product.name}}"
}

// Block.props for `text` with quote total
{
  "content": "현재 견적 합계: {{quote.grand_total | currency:'KRW'}}",
  "tag": "p"
}
```

### 4.3 SSR vs CSR 평가

- **SSR 평가 (RSC)**: `product`, `cms`, `system` (요청 시점에 fix됨)
- **CSR 평가 (Client)**: `quote`, `cart`, `member` (사용자 인터랙션에 따라 변동)
- 한 Block이 양쪽을 모두 가지면 Block은 Client Boundary로 격상 (render-pipeline.md §3)

### 4.4 보안 가드

- 표현식은 **샌드박스** (jsonata 또는 자체 limited expression evaluator)
- `eval()`, `Function()`, 임의 globals 금지
- 무한 루프/재귀 방지 (max depth=5)
- 출력은 자동 escape (XSS 방지) — 단 `text.format='rich'`만 sanitize HTML 허용

---

## 5. 스키마 버전 관리

Block은 `version: int` 필드 보유. Widget 스키마가 변경되면:

1. 새 버전(v2)을 widget 코드와 prop_schema에 등록
2. 기존 v1 Block은 그대로 보존 (DB)
3. 렌더 시 widget 코드가 `version` 분기 — backward compatible render
4. 어드민이 "마이그레이션" 액션으로 v1 → v2 변환 (선택)

JSON Schema 정의는 `apps/web/src/widgets/<code>/schema.v<N>.ts`에 위치.

---

## 6. 위젯 prop_schema 등록 절차

1. `apps/web/src/widgets/<code>/index.ts`에 React 컴포넌트 + `prop_schema` (Zod) export
2. 빌드 시 `scripts/sync-widget-catalog.ts`가 DB `widgets` 테이블에 upsert
3. 어드민 UI는 `prop_schema`를 JSONSchema → form auto-generate (react-jsonschema-form)
4. 신규 widget 등록 시 widget-coverage-matrix.md 갱신

---

## 7. block.condition 평가 시점

| `condition.mode` | 평가 시점 | 사용 케이스 |
|---|---|---|
| `server` | SSR 시 평가 → 트리에서 제거 | SEO 영향 있는 영역, 비공개 콘텐츠 |
| `client` | 클라이언트 마운트 후 평가 | 사용자 인터랙션 의존 (예: `qty >= 500`) |

`when` 표현식은 데이터 바인딩 expression과 동일 평가기 사용 — 단 boolean 결과 강제.

---

REQ coverage: REQ-BLDR-SCHEMA-001~005
References: domain-model.md §1, edicus-analysis/02_domain-model.md A.5, _baseline/05_widget_schema.sql, crawl-evidence/2026-05-27_buysangsang/C_findings.md (TM EPO `tm_meta_cpf`)
