# Pricing Engine — 가격 산출 엔진 v0.1

- 상태: Draft (D-004 deal-breaker 직접 대응)
- 작성일: 2026-05-27
- 작성자: pq-architect
- 관련: ADR-001 §Deal-breaker, ADR-003 A2/Q-Master-2, domain-model.md §2, block-schema.md §2.7, decisions D-004
- 산출 경로: `_workspace/print-quote/03_architecture/builder-engine/pricing-engine.md`

자체 BFF가 단독 소유하는 가격 엔진의 명세. Shopby/Aurora가 "동적 단가 push 미지원"이므로(D-004 Deal-breaker) 모든 견적 산출은 본 엔진에서만 발생하고, 외부 시스템은 산출 결과의 **결제 채널/주문 채널**로만 동작한다. 단위 테스트 가능한 순수 함수 형태로 구현.

---

## 0. 설계 원칙

1. **결정적(deterministic)** — 동일 입력 → 동일 출력. 시간/난수 의존성 외부 주입.
2. **순수 함수(pure function)** — 사이드 이펙트 없음. 가격표·룰·세팅은 입력 인자.
3. **스냅샷 가능** — 출력의 `breakdown[]`이 견적/주문 시점의 가격 산출 근거를 완전 보존(`price_breakdown JSONB` 저장).
4. **다단계 분해** — 가격 산출 단계별 중간값 모두 노출 (감사·디버깅·고객 설명 가능성).
5. **다중 견적 라인** — V1부터 `QuoteLine[]` 다건 지원 (카트 = 묶음 견적).
6. **외부 시스템 무종속** — Shopby/Edicus 콜은 가격에 영향 없음. Aurora 가격 컴포넌트 우회.

---

## 1. 산출 식 — 6단계

```
[1] BasePriceLookup       단가 = QuantityBreak(qty_from ≤ q ≤ qty_to).unit_price
[2] OptionSurcharge       옵션 가산 = Σ SpecOptionSurcharge(perUnit | fixed | percentage)
[3] LineSubtotal          라인 소계 = (단가 + perUnit 합) × 수량 + fixed 합 + setup_fee
                                     × (1 + percentage 합)
[4] SurchargeRule         조건부 할증 = Σ SurchargeRule.apply(line) — 긴급납기/주말 등
[5] DiscountPolicy        할인 = customer_grade + coupon + loyalty 할인
[6] Tax & Shipping        VAT = (line합 - 할인) × vat_rate;  배송비 = ShippingFeeRule(지역,중량)
                          grand_total = subtotal + surcharge - discount + shipping + vat
```

각 단계가 `breakdown[]`에 항목으로 추가됨. UI는 `breakdown[]`을 그대로 표시해 "왜 이 가격인가"를 설명 가능.

---

## 2. TypeScript 시그니처

```ts
// pricing-engine/types.ts

// ───── 입력 스키마 ─────
export const QuoteInputSchema = z.object({
  productId: z.string().uuid(),
  options: z.record(z.string(), z.string()), // { specName: optionValue }
  quantity: z.number().int().positive(),
  customSize: z.object({                      // 비규격(자유형) 입력 시
    widthMm: z.number().positive(),
    heightMm: z.number().positive(),
    roundMm: z.number().nonnegative().optional(),
  }).optional(),
  rushDeliveryDate: z.string().date().optional(),  // 긴급 납기 요청
  context: z.object({
    memberId: z.string().uuid().optional(),
    customerGrade: z.enum(['guest','normal','silver','gold','vip']).default('guest'),
    coupons: z.array(z.string()).default([]),       // coupon codes
    loyaltyPoints: z.number().nonnegative().default(0),
    shippingRegion: z.string().optional(),          // 'capital'|'others'|'jeju'
    now: z.string().datetime(),                      // injectable clock
  }),
});

export type QuoteInput = z.infer<typeof QuoteInputSchema>;

// ───── 출력 스키마 ─────
export interface QuoteResult {
  productId: string;
  productCode: string;          // MES ITEM_CD (예: '003-0001')
  quantity: number;
  unitPrice: number;            // 최종 단가 (after option, before surcharge/discount)
  lineSubtotal: number;         // [3] line subtotal
  surchargeTotal: number;       // [4]
  discountTotal: number;        // [5]
  setupFee: number;             // [3] 분리 표시
  shippingFee: number;          // [6]
  vatAmount: number;            // [6]
  grandTotal: number;
  breakdown: BreakdownItem[];   // 감사·UI용 상세 (감산 항목은 음수)
  warnings: Warning[];          // 비치명 (예: "최소 수량 미달로 50개로 올림")
  meta: {
    priceTableId: string;
    priceTableVersion: number;
    appliedQuantityBreak: { qty_from: number; qty_to: number | null; unit_price: number };
    appliedRules: string[];     // 적용된 SurchargeRule.id / DiscountPolicy.id 목록
    calculatedAt: string;       // ISO timestamp
  };
}

export interface BreakdownItem {
  step: 1 | 2 | 3 | 4 | 5 | 6;
  category: 'base_price' | 'option_surcharge' | 'subtotal'
          | 'rule_surcharge' | 'grade_discount' | 'coupon_discount'
          | 'loyalty_discount' | 'shipping' | 'vat' | 'setup_fee';
  label: string;                // UI 표시 (한국어)
  amount: number;               // 양수=가산, 음수=감산
  detail?: Record<string, unknown>;  // 룰 ID, 옵션 값, 수량 구간 등
}

export interface Warning {
  code: string;                 // 'qty_rounded_to_min', 'option_not_available', ...
  message: string;
  field?: string;
}

// ───── 엔진 시그니처 ─────
export function calculateQuote(
  input: QuoteInput,
  catalog: PricingCatalog,        // 사전 로드된 가격표·옵션·룰 (DI)
  config: PricingConfig            // VAT rate, setup_fee 정책, ...
): QuoteResult;

// 다건 라인 (카트 합계)
export function calculateCart(
  lines: QuoteInput[],
  catalog: PricingCatalog,
  config: PricingConfig
): CartQuoteResult;
```

**계약 (Contract):**
- 입력 검증 실패 → `QuoteValidationError` (throw). 가격 계산 진입 전 차단.
- 가격표 부재(catalog miss) → `PriceTableNotFoundError`.
- 산출 시간 ≤ 50ms (P99) — 단일 라인 기준. 다건 카트는 라인 수 비례.
- `grandTotal` 음수 불가. 할인이 합계를 초과하면 `grandTotal=0` + warning.

---

## 3. PricingCatalog (입력 자료구조)

엔진이 호출 시점에 받는 사전 로드된 마스터 데이터. BFF는 Neon PG에서 한 번에 fetch + 캐싱(상품별 60초 TTL).

```ts
// pricing_model 열거형 — D-PM-08 잠정안 (2종 공존)
// INC-005 해결: 가격관리 어드민 UI가 모델 선택 가능하도록 PriceTable 레벨에 명시
export type PricingModel = 'PriceTable3D' | 'BasePriceTier';

export interface PricingCatalog {
  product: ProductRow;            // products + extension
  specs: SpecificationRow[];      // product_specifications
  specOptions: SpecOptionRow[];   // product_spec_options
  specRules: SpecRuleRow[];       // product_spec_rules (의존성 검증용)
  priceTable: PriceTableRow & {
    pricing_model: PricingModel;  // ⭐ 디스크리미네이터 (Step 1 분기)
  };
  quantityBreaks: QuantityBreakRow[];  // PriceTable3D 전용 (수량 × 도수 × 단/양면)
  basePrice?: number;                  // BasePriceTier 전용 (기준 단가)
  tierDiscounts?: TierDiscountRow[];   // BasePriceTier 전용 (구간 할인율)
  surcharges: SpecOptionSurchargeRow[]; // 옵션 가산 (양 모델 공통)
  surchargeRules: SurchargeRuleRow[];   // 조건부 할증
  discountPolicies: DiscountPolicyRow[]; // 등급 할인
  shippingRules: ShippingFeeRuleRow[];
}
```

상품·가격·옵션·룰은 **versioning 보존** (`price_tables.valid_from/valid_to`). 견적 산출 시 사용된 row의 ID + version은 `QuoteResult.meta.appliedRules`에 기록되어 추후 재계산 가능.

### 3.0 PricingCatalog.lookup() 정책 — Product Resolution (D-PM-01 Decided 2026-05-28)

`mes_item_cd`는 외부 MES 시스템이 부여하므로 신규 빌더 등록 시 NULL일 수 있다. 따라서 PricingCatalog 조회는 다음 2단계 lookup 전략을 따른다.

| 우선순위 | Lookup 키 | 제약 | 사용 케이스 |
|---|---|---|---|
| **Primary** | internal `product_id` (UUID) | always NOT NULL | 빌더 내부 견적 호출 (V1 표준 경로) |
| **Secondary** | `mes_item_cd` (VARCHAR(8)) | NULL 허용 (MES 동기화 전) | MES 코드를 알고 있는 외부/관리자 직접 lookup |

**계약:**
- `calculateQuote`는 입력 `QuoteInput.productId`(UUID)로만 호출. `mes_item_cd`는 입력 스키마에 미포함.
- `mes_item_cd`가 NULL인 상품도 가격 산출 가능해야 함 (MES 동기화 전 V1 런칭 차단 금지).
- 어드민 lookup tool은 `findByMesItemCd(code) → product_id → calculateQuote()` 2-hop으로 처리.
- `QuoteResult.productCode`는 `mes_item_cd ?? products.code`(fallback)로 직렬화 — NULL일 경우 내부 코드 노출.

### 3.1 pricing_model 매핑 표 — 8 가격관리 팝업 코드 (INC-005)

D-PM-08 잠정안 채택. 출처: `02_business/policy-checklist.md` §가격관리 팝업 8종, `02_business/pricing-rules.md` §3·§7·§9·§11·§12.

| 팝업 코드 | 의미 | pricing_model | 데이터 소스 (pricing-rules.md) | Step 1 분기 |
|---|---|---|---|---|
| DP02 | 디지털인쇄 02 (양면) | `PriceTable3D` | §3 (수량 56구간 × 도수 7종 × 단/양면) | `lookupBasePrice3D()` |
| DP04 | 디지털인쇄 04 (4도) | `PriceTable3D` | §3 동일 매트릭스, CMYK 컬럼 | `lookupBasePrice3D()` |
| DP06 | 디지털인쇄 06 (특수도수) | `PriceTable3D` | §3 별색 컬럼 (화이트/클리어/핑크/금/은) | `lookupBasePrice3D()` |
| GD01 | 굿즈 01 (A타입 할인) | `BasePriceTier` | §9 (상품 기준가 + 1~99/100~499/500+ 할인율) | `lookupBasePriceTier()` |
| GD02 | 굿즈 02 (B타입 할인) | `BasePriceTier` | §9 (동일 구조, 다른 임계값) | `lookupBasePriceTier()` |
| PK01 | 패키지/포장 01 | `BasePriceTier` | §12 (소재별 단가 + 수량구간) | `lookupBasePriceTier()` |
| PR01 | 인쇄 01 (디지털+제본 통합) | `PriceTable3D` | §3 + §11 (제본 surcharge 합성, Step 2 처리) | `lookupBasePrice3D()` |
| PR02 | 인쇄 02 (포스터/사이즈매트릭스) | `PriceTable3D` | §7 (가로 × 세로 2D 매트릭스 — 3D의 특수형, qty=1 고정) | `lookupBasePrice3D()` |

**관찰:**
- 8 팝업 코드는 실제로 2개 모델로 수렴 (`PriceTable3D` 5건, `BasePriceTier` 3건).
- `PR02` (사이즈매트릭스)는 `PriceTable3D`의 특수 케이스 — 수량 축을 사이즈 보간(`§16.4` 의사코드)로 대체. 별도 모델로 분리하지 않고 `quantityBreaks` 메타에 `axis: 'size_matrix'` 플래그로 처리.
- 코팅(§4)·명함(§5)·스티커(§6)·아크릴(§8) 등은 8 팝업 코드 외 별도 가격표지만 동일하게 두 모델 중 하나로 분류 — 각 PriceTable row의 `pricing_model` 컬럼으로 표현.

### 3.2 디스크리미네이터 분기 로직 (Step 1)

`calculateQuote` 내부에서 Step 1 BasePriceLookup이 `pricing_model`에 따라 분기:

```ts
function lookupBasePrice(quantity, input, catalog):
    switch catalog.priceTable.pricing_model:
        case 'PriceTable3D':
            # 기존 §4 Step 1 로직 — quantityBreaks 직접 lookup
            return lookupBasePrice3D(quantity, catalog.quantityBreaks)
        
        case 'BasePriceTier':
            # 기준 단가 + 수량 구간 할인율
            baseUnit = catalog.basePrice
            tier = catalog.tierDiscounts.find(t =>
                t.qty_from ≤ quantity AND (t.qty_to is null OR quantity ≤ t.qty_to))
            discountedUnit = baseUnit * (1 - tier.discount_rate)
            breakdown.add(step=1, category='base_price',
                label=`기준 단가 ${baseUnit} × (1 - ${tier.discount_rate*100}%)`,
                amount=discountedUnit * quantity,
                detail={ model: 'BasePriceTier', tier_id: tier.id })
            return { unit_price: discountedUnit, setup_fee: 0, qb: null, tier }
```

**계약:**
- 모델별로 다른 입력 자료구조를 요구 (`quantityBreaks` vs `basePrice + tierDiscounts`). 모델과 자료구조의 정합성은 Catalog 로더(`catalog.ts`)에서 사전 검증.
- Step 2~6 로직은 양 모델 공통 (옵션 surcharge·할증·할인·세금 동일 흐름).
- `QuoteResult.meta`에 `pricingModel` 필드 추가 — 견적 영속 시 어떤 모델로 산출됐는지 명시.
- 어드민 UI(가격관리 화면)는 상품 등록 시 8 팝업 코드 중 하나를 선택 → 자동으로 `pricing_model` 채워짐.

---

## 4. 알고리즘 의사코드

### Step 0 — 입력 검증

```pseudo
function validate(input, catalog):
    # 4-A. 옵션 의존성 (SpecRule)
    for rule in catalog.specRules where rule.is_active:
        if rule.condition matches input.options:
            switch rule.rule_type:
                case 'disable': if rule.target in input.options:
                    throw ValidationError('disabled option chosen', rule.message)
                case 'require': if rule.target not in input.options:
                    throw ValidationError('required option missing', rule.message)
                case 'enable': # informational
    
    # 4-B. 최소/최대 수량
    if input.quantity < catalog.product.min_order_qty:
        warnings.add('qty_below_min', new qty = min_order_qty)
        input.quantity = catalog.product.min_order_qty
    if catalog.product.max_order_qty and input.quantity > catalog.product.max_order_qty:
        throw ValidationError('qty exceeds max')
    
    # 4-C. 비규격 사이즈 (custom_size)
    if input.customSize:
        spec = catalog.specs.find(s => s.input_type='size_custom')
        if customSize.widthMm * customSize.heightMm > spec.max_value_mm2:
            throw ValidationError('custom size exceeds max area')
```

### Step 1 — BasePriceLookup

```pseudo
function lookupBasePrice(quantity, catalog):
    qb = catalog.quantityBreaks.find(b =>
            b.qty_from ≤ quantity AND (b.qty_to is null OR quantity ≤ b.qty_to)
        )
    if not qb:
        throw PriceTableMissingBracketError(quantity)
    
    breakdown.add(step=1, category='base_price',
        label=`기본 단가 (${qb.qty_from}~${qb.qty_to ?? '∞'} 구간)`,
        amount=qb.unit_price * quantity,
        detail={ qb_id: qb.id, unit_price: qb.unit_price })
    
    if qb.setup_fee > 0:
        breakdown.add(step=1, category='setup_fee',
            label='판비/제판비', amount=qb.setup_fee)
    
    return { unit_price: qb.unit_price, setup_fee: qb.setup_fee, qb }
```

### Step 2 — OptionSurcharge

```pseudo
function applySurcharges(unitPrice, quantity, input, catalog):
    perUnitAdd = 0    # 단가에 더해지는 가산
    fixedAdd = 0      # 라인에 일괄 가산
    percentageMul = 1.0  # 누적 곱셈 (1.15 * 1.05 = ...)
    
    for (specName, optionValue) in input.options:
        spec = catalog.specs.find(s => s.name == specName)
        option = catalog.specOptions.find(o => o.spec_id == spec.id AND o.value == optionValue)
        if not option: continue
        
        surcharge = catalog.surcharges.find(s =>
            s.price_table_id == catalog.priceTable.id AND s.spec_option_id == option.id
        )
        if not surcharge: continue
        
        switch surcharge.cost_type:
            case 'per_unit':
                perUnitAdd += surcharge.cost_value
                breakdown.add(step=2, category='option_surcharge',
                    label=`${spec.display_name}: ${option.display_name} (단가 +${surcharge.cost_value})`,
                    amount=surcharge.cost_value * quantity,
                    detail={ option_id: option.id, cost_type: 'per_unit' })
            
            case 'fixed':
                fixedAdd += surcharge.cost_value
                breakdown.add(step=2, ..., amount=surcharge.cost_value, ...)
            
            case 'percentage':
                percentageMul *= (1.0 + surcharge.cost_value)
                breakdown.add(step=2, ..., 
                    amount=null,  # 누적은 step3에서 계산
                    detail={ percentage: surcharge.cost_value })
    
    return { perUnitAdd, fixedAdd, percentageMul }
```

### Step 3 — LineSubtotal

```pseudo
function computeLineSubtotal(unitPrice, setupFee, quantity, surchargeResult):
    effectiveUnit = unitPrice + surchargeResult.perUnitAdd
    subtotal_before_pct = effectiveUnit * quantity + surchargeResult.fixedAdd + setupFee
    lineSubtotal = subtotal_before_pct * surchargeResult.percentageMul
    
    breakdown.add(step=3, category='subtotal',
        label='소계',
        amount=lineSubtotal,
        detail={
          effective_unit_price: effectiveUnit,
          pct_multiplier: surchargeResult.percentageMul
        })
    
    return { effectiveUnit, lineSubtotal }
```

### Step 4 — SurchargeRule (조건부 할증)

```pseudo
function applyConditionalSurcharges(lineSubtotal, input, catalog, now):
    runningTotal = lineSubtotal
    totalSurcharge = 0
    appliedRuleIds = []
    
    # priority 오름차순 (작은 priority가 먼저)
    rules = catalog.surchargeRules
        .filter(r => r.is_active)
        .filter(r => now within [r.valid_from, r.valid_to])
        .sortBy(r => r.priority)
    
    for rule in rules:
        if not evaluateCondition(rule.condition_type, rule.condition_value, input, now):
            continue
        
        switch rule.surcharge_type:
            case 'percentage':
                amount = runningTotal * rule.surcharge_value
            case 'fixed':
                amount = rule.surcharge_value
        
        runningTotal += amount
        totalSurcharge += amount
        appliedRuleIds.push(rule.id)
        
        breakdown.add(step=4, category='rule_surcharge',
            label=rule.name,
            amount=amount,
            detail={ rule_id: rule.id, condition: rule.condition_value })
    
    return { totalSurcharge, runningTotal, appliedRuleIds }

# 조건 평가기 (확장 가능)
function evaluateCondition(type, value, input, now):
    switch type:
        case 'rush_delivery':
            return input.rushDeliveryDate AND
                businessDaysBetween(now, input.rushDeliveryDate) < value.min_days
        case 'weekend':
            return isWeekendOrHoliday(now)
        case 'category':
            return input.productCategory in value.categories
        case 'quantity_above':
            return input.quantity >= value.threshold
        ...
```

### Step 5 — DiscountPolicy

```pseudo
function applyDiscounts(runningTotal, input, catalog, now):
    totalDiscount = 0
    
    # 5-A. 회원 등급 할인 (자동 적용)
    gradePolicies = catalog.discountPolicies
        .filter(p => p.customer_grade == input.context.customerGrade)
        .filter(p => now within [p.valid_from, p.valid_to])
        .filter(p => runningTotal >= p.min_order_amount)
    
    for policy in gradePolicies:
        switch policy.discount_type:
            case 'percentage':
                amount = runningTotal * policy.discount_value
            case 'fixed':
                amount = policy.discount_value
        if policy.max_discount_amount:
            amount = min(amount, policy.max_discount_amount)
        totalDiscount += amount
        breakdown.add(step=5, category='grade_discount',
            label=`${input.context.customerGrade} 등급 할인 (${policy.name})`,
            amount=-amount)
    
    # 5-B. 쿠폰 (사용자 명시 선택)
    for couponCode in input.context.coupons:
        coupon = catalog.coupons.find(c => c.code == couponCode AND c.isValid(now, runningTotal))
        if not coupon: continue
        amount = computeCouponDiscount(coupon, runningTotal)
        totalDiscount += amount
        breakdown.add(step=5, category='coupon_discount',
            label=`쿠폰: ${coupon.code}`, amount=-amount)
    
    # 5-C. 적립금 (1포인트 = 1원 가정, 결제 직전 적용)
    if input.context.loyaltyPoints > 0:
        ptUsed = min(input.context.loyaltyPoints, runningTotal - totalDiscount)
        totalDiscount += ptUsed
        breakdown.add(step=5, category='loyalty_discount',
            label='적립금 사용', amount=-ptUsed)
    
    return { totalDiscount }
```

### Step 6 — Tax & Shipping

```pseudo
function computeTaxAndShipping(subtotalAfterDiscount, input, catalog, config):
    # 6-A. 배송비 (라인이 아닌 카트/주문 레벨이지만 단일 라인 결과에도 표시)
    shippingRule = catalog.shippingRules.find(r =>
        r.region_group == (input.context.shippingRegion ?? 'capital') AND
        r.is_active
    )
    if subtotalAfterDiscount >= shippingRule.min_amount_for_free:
        shippingFee = 0
    else:
        shippingFee = shippingRule.base_fee
    breakdown.add(step=6, category='shipping',
        label='배송비', amount=shippingFee)
    
    # 6-B. VAT 부가세 (As-Is `woocommerce_calc_taxes=yes` 정렬)
    # vat_rate: system_configs.config_key='VAT_RATE' (default 0.10)
    taxableBase = subtotalAfterDiscount + shippingFee
    if config.taxPolicy == 'included':
        # 표시가 부가세 포함 — 분리 표시만
        vat = taxableBase - taxableBase / (1.0 + config.vatRate)
    else:  # 'separate'
        vat = taxableBase * config.vatRate
    
    breakdown.add(step=6, category='vat',
        label=`부가세 (${config.vatRate * 100}%)`, amount=vat)
    
    return { shippingFee, vatAmount: vat }
```

### Main Entry — `calculateQuote`

```pseudo
function calculateQuote(input, catalog, config):
    breakdown = []
    warnings = []
    
    QuoteInputSchema.parse(input)               # Zod
    validate(input, catalog)                     # Step 0
    
    { unit_price, setup_fee, qb } = lookupBasePrice(input.quantity, catalog)         # Step 1
    surchargeResult = applySurcharges(unit_price, input.quantity, input, catalog)    # Step 2
    { effectiveUnit, lineSubtotal } = computeLineSubtotal(...)                       # Step 3
    { totalSurcharge, runningTotal, appliedRuleIds }
        = applyConditionalSurcharges(lineSubtotal, input, catalog, input.context.now) # Step 4
    { totalDiscount } = applyDiscounts(runningTotal, input, catalog, input.context.now) # Step 5
    afterDiscount = runningTotal - totalDiscount
    { shippingFee, vatAmount } = computeTaxAndShipping(afterDiscount, input, catalog, config) # Step 6
    
    grandTotal = max(0, afterDiscount + shippingFee + vatAmount - 
                       (config.taxPolicy == 'included' ? vatAmount : 0))
    # 'included' 정책에선 vat이 이미 afterDiscount에 포함 → 표시만 분리
    
    return {
        productId: input.productId,
        productCode: catalog.product.code,
        quantity: input.quantity,
        unitPrice: effectiveUnit,
        lineSubtotal,
        surchargeTotal: totalSurcharge,
        discountTotal: totalDiscount,
        setupFee: setup_fee,
        shippingFee,
        vatAmount,
        grandTotal,
        breakdown,
        warnings,
        meta: {
            priceTableId: catalog.priceTable.id,
            priceTableVersion: catalog.priceTable.version,
            appliedQuantityBreak: qb,
            appliedRules: appliedRuleIds,
            calculatedAt: input.context.now,
        }
    }
```

---

## 5. 입력 변수 표 (xlsx 상품마스터 매핑)

product-master.md §7의 "핵심 사양 8축"을 엔진 입력으로 정형화한 표.

| 사양 축 | xlsx 컬럼 | spec.name | input_type | options 예 | 가격 영향 |
|---|---|---|---|---|---|
| 1. 사이즈 | `사이즈(필수)` | `size` | `select` (규격) / `size_custom` (자유형) | "73x98mm", "A6", "custom" | 비규격 → 별도 surcharge / setup_fee 정책 |
| 2. 종이/소재 | `종이(필수)` | `paper` | `select` | "아트지250g", "스노우지200g" | per_unit surcharge |
| 3. 인쇄 도수 | `인쇄(옵션)` | `print_sides` | `radio` | "단면", "양면" | percentage (예: 양면 +50%) |
| 4. 별색 인쇄 | `별색인쇄(옵션)` | `special_color` | `select` | "없음", "화이트", "클리어", "핑크", "금색", "은색" | fixed + setup_fee |
| 5. 후가공 | `후가공` | `finishing` | `multi_select` | ["코팅","박","형압","오시","타공"] | per_unit + setup_fee 누적 |
| 6. 제본 | `제본방식` (책자 시트) | `binding` | `select` | "중철", "무선", "PUR", "트윈링", "하드커버" | fixed surcharge + setup_fee |
| 7. 수량 | `제작수량(필수)` | `quantity` | `number` (step=min/max/increment) | min=50, step=50 | **단가의 1차 결정 요인 — QuantityBreak** |
| 8. 주문방법 | `업로드`/`편집기` | `order_method` | `radio` | "file_upload", "edicus_editor", "passive_template" | 가격 무영향 (워크플로 분기) |

비고:
- xlsx의 `최소/최대/증가` (예: 명함 100/10000/100)를 `product_specifications.min_value/max_value/step_value`에 저장 (베이스라인 17 컬럼 보존).
- `MES ITEM_CD` (`001-0001` 등 12 카테고리 prefix)는 `products.code` UNIQUE로 보존 — schema.sql 참조.
- 옵션 옵션값(`option.value`)은 영문 식별자, `option.display_name`이 한국어.

---

## 6. Tiered Pricing 룰 적용 순서 (As-Is 호환)

As-Is `Tiered Price Table for WooCommerce 8.3.0`의 메타 흡수.

| As-Is 메타 | To-Be 매핑 | 적용 단계 |
|---|---|---|
| `_fixed_price_rules` | `QuantityBreak.setup_fee` (구간별 고정) | Step 1 |
| `_percentage_price_rules` | `SpecOptionSurcharge.cost_type='percentage'` | Step 2 |
| `_tiered_price_rules_type` (`replace`/`add`/`subtract`) | `QuantityBreak.unit_price` (replace 기본), `SpecOptionSurcharge.cost_type='per_unit'` (add/subtract) | Step 1, 2 |
| `tm_meta_cpf` (mode=builder, builder mode form) | `widget_step_fields` + `option_panel` 위젯 (block-schema.md §2.7) | UI 단 (엔진 외부) |
| `tm_meta_cpf.price_display_mode` | `widget_configs.realtime_price_enabled` | UI 단 |
| `_msdp_*` (MShop Display Pricing) | `discount_policies.customer_grade` | Step 5-A |

**적용 순서 규칙:**
1. 수량 구간 → 단가 결정 (Step 1)
2. 옵션 가산: per_unit 먼저, fixed, percentage 순서로 누적 (Step 2)
3. 같은 sort_order의 `SpecOptionSurcharge`가 여럿이면 `cost_type='per_unit' → fixed → percentage` 우선
4. 조건부 할증 (Step 4)은 priority ASC, percentage 룰은 runningTotal에 누적 곱하지 않고 가산
5. 할인은 등급 → 쿠폰 → 적립금 순 (Step 5)

---

## 7. 검증 규칙·엣지 케이스

| 케이스 | 처리 |
|---|---|
| 수량 < min_order_qty | 자동 보정 + warning `qty_rounded_to_min` |
| 수량 > max_order_qty | throw `QtyExceedsMaxError` |
| 수량이 어느 구간에도 속하지 않음 | throw `PriceTableMissingBracketError` |
| 비규격 사이즈 < min_dimension | throw `CustomSizeBelowMinError` |
| 옵션 의존성 위반 (SpecRule.disable) | throw `OptionDependencyError` (UI 표시) |
| 활성 PriceTable 없음 (valid_to 만료) | throw `NoActivePriceTableError` (운영 알림) |
| 할인이 합계 초과 | grandTotal=0 + warning `discount_capped` |
| 0원 견적 (free promo) | 허용. `grandTotal=0` 정상 |
| 부가세 정책 (포함/별도) | system_configs `VAT_INCLUSIVE` (default `included`) — As-Is `woocommerce_calc_taxes=yes` 호환 |
| 게스트 견적 | `customerGrade='guest'` → grade discount 비적용 |
| 쿠폰 중복 사용 | catalog.coupons.stack_policy (`exclusive` / `stackable`) — 기본 exclusive |
| 적립금 + 쿠폰 동시 | 허용. 적립금이 마지막에 적용 |

---

## 8. 단위 테스트 시나리오 (10개)

각 시나리오는 `__tests__/pricing-engine/*.test.ts`에 동일 구조로 작성.

### T-01: 명함 100매 — 단순 단가

```yaml
name: 명함 프리미엄 100매 단면 아트지250g
input:
  productCode: '003-0001'
  options: { paper: 'art_250', print_sides: 'single', finishing: [], special_color: 'none' }
  quantity: 100
  context: { customerGrade: 'normal', now: '2026-05-27T10:00:00Z' }
catalog:
  qb: [{ qty_from:100, qty_to:499, unit_price:50, setup_fee:5000 }]
  surcharges: []  # 기본 사양은 가산 없음
expected:
  unitPrice: 50
  lineSubtotal: 10000   # 50*100 + 5000
  setupFee: 5000
  vatAmount: 1000        # included 정책 시 1000원 분리 표시
  grandTotal: 10000
```

### T-02: 명함 양면 — percentage 가산

```yaml
name: 명함 프리미엄 100매 양면
input: { ..., options: { ..., print_sides: 'double' } }
catalog:
  surcharges: [{ spec_option:print_sides=double, cost_type:'percentage', cost_value:0.50 }]
expected:
  unitPrice: 50           # base 변경 없음
  lineSubtotal: 15000     # (50*100 + 5000) * 1.5
  breakdown:
    - step:2 category:'option_surcharge' label:'인쇄: 양면 (+50%)'
```

### T-03: 명함 수량 구간 변경 (1000매)

```yaml
name: 명함 1000매 — qty bracket 변경
input: { ..., quantity: 1000 }
catalog:
  qb:
    - { qty_from:100, qty_to:499, unit_price:50 }
    - { qty_from:500, qty_to:999, unit_price:40 }
    - { qty_from:1000, qty_to:null, unit_price:30 }
expected:
  unitPrice: 30
  lineSubtotal: 35000   # 30*1000 + 5000
  meta.appliedQuantityBreak: { qty_from:1000, qty_to:null, unit_price:30 }
```

### T-04: 엽서 1000매 + 코팅 (multi-finishing)

```yaml
name: 프리미엄엽서 + 양면 코팅(반광)
input:
  productCode: '001-0001'
  options: { paper:'art_300', print_sides:'double', finishing:['coat_glossy','coat_matte'] }
  quantity: 1000
catalog:
  surcharges:
    - { spec_option:coat_glossy, cost_type:'per_unit', cost_value:15 }
    - { spec_option:coat_matte, cost_type:'per_unit', cost_value:18 }
    - { spec_option:print_sides=double, cost_type:'percentage', cost_value:0.50 }
expected:
  effectiveUnit: 80 + 15 + 18 = 113
  lineSubtotal: (113 * 1000 + setup) * 1.50
```

### T-05: 스티커 자유형 — 비규격 사이즈 surcharge

```yaml
name: 반칼 자유형 스티커 100x100mm
input:
  productCode: '002-0001'
  options: { size:'custom', paper:'pet', finishing:[], print_sides:'single' }
  customSize: { widthMm: 100, heightMm: 100 }
  quantity: 200
catalog:
  qb: [{ qty_from:100, qty_to:499, unit_price:200 }]
  surcharges: [{ spec_option:size=custom, cost_type:'fixed', cost_value:10000 }]  # 자유형 도무송 fee
expected:
  unitPrice: 200
  fixedAdd: 10000
  lineSubtotal: 50000  # 200*200 + 10000
```

### T-06: 책자 100부 — setup_fee + 제본

```yaml
name: 중철책자 A5 100부 36p
input:
  productCode: '006-0001'
  options: { binding:'saddle_stitch', paper_cover:'art_250', paper_inner:'art_120', pages:36, print_sides:'double' }
  quantity: 100
catalog:
  qb: [{ qty_from:100, qty_to:299, unit_price:3500, setup_fee:30000 }]
  surcharges:
    - { spec_option:binding=saddle_stitch, cost_type:'fixed', cost_value:0 }   # 기본 포함
    - { spec_option:pages=36, cost_type:'per_unit', cost_value:1200 }          # 페이지 가산
expected:
  effectiveUnit: 3500 + 1200 = 4700
  lineSubtotal: 4700*100 + 30000 = 500000
```

### T-07: 긴급납기 surcharge_rule (Step 4)

```yaml
name: 명함 100매 + 긴급납기 (2 영업일)
input: { ..., quantity:100, rushDeliveryDate: '2026-05-29', context.now: '2026-05-27T10:00:00Z' }
catalog:
  surchargeRules: [{ id:'rush_2d', condition:{ type:'rush_delivery', min_days:3 }, surcharge_type:'percentage', surcharge_value:0.30 }]
expected:
  surchargeTotal: 10000 * 0.30 = 3000
  breakdown: [..., { step:4, label:'긴급납기 (3 영업일 미만)', amount:3000 }]
  meta.appliedRules: ['rush_2d']
```

### T-08: VIP 등급 할인 (Step 5-A)

```yaml
name: 명함 1000매 + VIP 등급
input: { ..., quantity:1000, context: { customerGrade:'vip' } }
catalog:
  discountPolicies: [{ customer_grade:'vip', discount_type:'percentage', discount_value:0.10, min_order_amount:0 }]
expected:
  lineSubtotal: 35000
  discountTotal: 3500
  afterDiscount: 31500
```

### T-09: 쿠폰 + 적립금 + 무료배송

```yaml
name: 카트 합계 5만원 + 쿠폰 5천원 + 적립금 1만점 + 5만원 이상 무료배송
input: { ..., context: { coupons:['WELCOME5K'], loyaltyPoints:10000, shippingRegion:'capital' } }
catalog:
  shippingRules: [{ region:'capital', min_amount_for_free:50000, base_fee:3000 }]
  coupons: [{ code:'WELCOME5K', discount_type:'fixed', value:5000 }]
expected:
  discountTotal: 5000 + 10000 = 15000
  shippingFee: 0  # afterDiscount=35000 < 50000 이면 3000. 여기선 무료 조건 기준이 라인 소계 또는 그랜드 — 정책에 따라
  # ⚠ 무료배송 기준 (lineSubtotal vs afterDiscount): 정책 결정 필요 (O-006 신규)
```

### T-10: 0원 결제 — 할인이 합계 초과

```yaml
name: 100% 할인 쿠폰
input: { ..., context: { coupons:['FREE100'] } }
catalog:
  coupons: [{ code:'FREE100', discount_type:'percentage', value:1.00 }]
expected:
  grandTotal: 0
  warnings: [{ code:'discount_capped' }]
```

---

## 9. 캐싱·성능 정책

| 항목 | 정책 |
|---|---|
| PricingCatalog fetch | 상품별 60초 TTL (Redis or Next.js `unstable_cache`) |
| 빈번한 견적 산출 | 캐시 키: `(productId, optionsHash, quantity, customerGrade)` — 5초 TTL |
| 실시간 가격 UI 디바운스 | block-schema.md §2.7 `option_panel.debounce_ms` (default 300ms) |
| 캐시 무효화 | PriceTable/Surcharge/Rule 수정 시 `revalidateTag('product:'+id)` |
| 견적 저장 | Quote 생성 시 `price_breakdown` JSONB에 전체 BreakdownItem 영구 저장. 추후 가격표 변경되어도 영향 없음 |

---

## 10. 외부 시스템과의 경계 (D-004 deal-breaker 대응)

```
                      ┌─────────────────────────────────────┐
                      │  Pricing Engine (Self / BFF)        │
   사용자 입력 ───────▶│  calculateQuote()                    │
                      │   - PricingCatalog (Neon PG)        │──▶ QuoteResult
                      │   - 결정적·순수                       │
                      └─────────────────────────────────────┘
                                       │
                                       ▼
                  ┌────────────────────────────────────────┐
                  │  Quote / QuoteLine 영속 (Neon PG)       │
                  │   - price_breakdown JSONB 스냅샷        │
                  └────────────────────────────────────────┘
                                       │
                                       ▼
                  ┌────────────────────────────────────────┐
                  │  주문 전이: Shopby 주문 push 또는 직접  │
                  │   - "이미 계산된 grandTotal"을 payload  │
                  │   - Shopby가 재계산하면 무결성 위반     │
                  │     (D-004 Aurora 폐기 근거 동일)       │
                  └────────────────────────────────────────┘
```

**핵심:** 가격 산출은 **자체 BFF에서만** 발생. Shopby/PG/Aurora는 산출된 단가의 **결제 채널**로만 동작. O-001(Shopby 위임 범위) 결정과 무관하게 본 엔진은 단독 소유.

O-002 (Edicus 장애 시 fallback): 가격 산출에 **영향 없음**. Edicus는 디자인 자산(template_uri, content_uri)만 보유 — 가격 계산 입력에 미포함.

---

## 11. Open Questions

| ID | 질문 | 영향 |
|---|---|---|
| O-PE-1 | 무료배송 기준 (lineSubtotal vs afterDiscount vs grandTotal) | Step 6 정확도 |
| O-PE-2 | 쿠폰 stack 정책 (exclusive vs stackable, 카테고리 제한) | Step 5-B |
| O-PE-3 | 적립금 적립률 (가산 시점·비율) — 본 엔진은 사용만, 적립 별도 도메인 | LoyaltyPoint 도메인 |
| O-PE-4 | 라인 단위 vs 카트 단위 가격 (다건 견적 시 배송비 통합 기준) | calculateCart |
| O-PE-5 | 도소매 등급별 별도 가격표 (B2B 가격) — `customer_grade`별 PriceTable 분기 vs surcharge | 데이터 모델 |
| O-PE-6 | 비규격 사이즈의 면적 기반 단가 (m²당 가격) — 실사·배너 시트에 필요 | 자유형 spec input_type |

---

## 12. 구현 위치 (스켈레톤)

```
apps/web/src/lib/pricing-engine/
├── types.ts                    # QuoteInput / QuoteResult / BreakdownItem (Zod)
├── catalog.ts                  # PricingCatalog 로더 (BFF Neon fetch + cache)
├── calculate.ts                # calculateQuote() — 본 엔진
├── steps/
│   ├── 01-base-price.ts
│   ├── 02-option-surcharge.ts
│   ├── 03-line-subtotal.ts
│   ├── 04-surcharge-rule.ts
│   ├── 05-discount.ts
│   └── 06-tax-shipping.ts
├── validators.ts                # SpecRule, quantity bounds
├── expressions.ts               # SurchargeRule condition 평가기
└── __tests__/
    ├── T01-business-card-100.test.ts ~ T10-zero-grandTotal.test.ts
    ├── catalog.fixtures.ts
    └── golden-snapshots/        # 회귀 방지용 스냅샷
```

---

REQ coverage: REQ-PRICE-ENGINE-001~012  
References: ADR-001 §Deal-breaker, ADR-003 A2, domain-model.md §2, block-schema.md §2.7, decisions D-004, product-master.md §7, _baseline/07_integrated_schema.sql §4 (Pricing), crawl-evidence/2026-05-27_buysangsang/C_findings.md (TM EPO + Tiered Pricing 메타)
