# Render Pipeline — 렌더 파이프라인 v0.1

- 상태: Draft
- 작성일: 2026-05-27
- 작성자: pq-architect
- 관련: domain-model.md §1 (Builder), block-schema.md, bff-integration.md, decisions D-003 (Next.js 15)
- 산출 경로: `_workspace/print-quote/03_architecture/builder-engine/render-pipeline.md`

자체 빌더의 트리(`Page → Section → Column → Block`)를 Next.js 15 App Router에서 어떻게 React 컴포넌트 트리로 변환하고 렌더·hydrate·캐싱하는지 정의. As-Is의 PHP 기반 Elementor 렌더를 RSC(React Server Components)로 대체.

---

## 0. 핵심 원칙

| 원칙 | 의미 |
|---|---|
| RSC 우선 | 모든 정적 위젯은 RSC. Client는 인터랙션 필요 시에만 |
| Tree → JSX | DB의 트리를 RSC가 직접 React.createElement로 변환 (jsonwebtree 없음) |
| Data Boundary | `bindings`이 동적이면 자동 Client Boundary 격상 |
| Cache-First | ISR 60s + 태그 기반 무효화 (`revalidateTag`) |
| Streaming | 무거운 영역은 Suspense + streaming SSR |
| 자격증명 차폐 | 모든 외부 API는 BFF 경유 (bff-integration.md §0) |

---

## 1. 전체 파이프라인 (5 stage)

```
[Stage 1] URL → Page row 매핑
    ↓
[Stage 2] Page tree fetch (Page + Sections + Columns + Blocks)
    ↓
[Stage 3] Binding resolve (SSR 가능한 binding 평가)
    ↓
[Stage 4] Tree → React 컴포넌트 트리 변환
    ↓
[Stage 5] Render (RSC + Client Boundary + Suspense)
```

### Stage 1: URL Routing

```
app/
├── (marketing)/
│   ├── page.tsx                    → /         (home)
│   ├── about/page.tsx              → /about
│   └── ...
├── (catalog)/
│   ├── products/page.tsx           → /products (category landing)
│   ├── products/[slug]/page.tsx    → /products/business-card-premium
│   └── categories/[slug]/page.tsx
├── (account)/
│   ├── sign-in/page.tsx
│   ├── my-page/page.tsx
│   └── orders/[id]/page.tsx
├── (checkout)/
│   └── checkout/page.tsx
├── (admin)/
│   └── ...
└── [...slug]/page.tsx              → catch-all → DB pages lookup by slug
```

- 정적 라우트가 우선 매칭
- 동적 path `[slug]`는 `pages.slug` 조회 후 fallback (catch-all)
- 미존재 slug → 404

### Stage 2: Page Tree Fetch

```ts
// app/[...slug]/page.tsx
export default async function DynamicPage({ params }: { params: { slug: string[] } }) {
  const slug = params.slug.join('/');
  const page = await fetchPageBySlug(slug);  // unstable_cache, tags:['page:slug']
  if (!page || page.status !== 'published') return notFound();
  
  return <PageRenderer page={page} />;
}

async function fetchPageBySlug(slug: string) {
  return unstable_cache(
    async () => {
      // 단일 쿼리로 트리 전체 로드 (Page + Sections + Columns + Blocks)
      // CTE 또는 다중 SELECT + JS 재구성
      const result = await db.execute(sql`
        WITH RECURSIVE block_tree AS (
          SELECT b.*, c.section_id, NULL::uuid AS parent_id, 0 AS depth
          FROM blocks b
          INNER JOIN columns c ON b.column_id = c.id
          INNER JOIN sections s ON c.section_id = s.id
          WHERE s.page_id = (SELECT id FROM pages WHERE slug = ${slug} AND deleted_at IS NULL)
          UNION ALL
          SELECT b.*, NULL::uuid, b.parent_block_id, bt.depth + 1
          FROM blocks b INNER JOIN block_tree bt ON b.parent_block_id = bt.id
          WHERE bt.depth < 10
        )
        SELECT ... FROM pages JOIN sections JOIN columns JOIN block_tree ...
      `);
      return assembleTree(result);
    },
    [`page:slug:${slug}`],
    { revalidate: 60, tags: [`page:slug:${slug}`, 'pages'] }
  )();
}
```

### Stage 3: Binding Resolve

```ts
interface RenderContext {
  product?: Product;       // SSR 가능 (URL slug → product fetch)
  cms: { page: Page };     // SSR 가능
  system: { vatRate: number; currency: string };  // SSR 가능
  quote?: QuoteState;       // Client 전용 (사용자 인터랙션)
  member?: Member;          // 부분 SSR (cookie → session lookup) + Client
  cart?: CartState;         // Client 전용
}

function resolveBindings(block: Block, ctx: RenderContext): { resolvedProps, isClient } {
  const resolvedProps = { ...block.props };
  let isClient = false;
  
  for (const [propPath, expression] of Object.entries(block.bindings)) {
    const { value, source } = evaluateBinding(expression, ctx);
    
    if (source in ['quote', 'cart']) {
      isClient = true;  // Client Boundary 격상
      // 표현식 자체를 prop에 남김 → Client가 평가
      setPropPath(resolvedProps, propPath, { __expr: expression });
    } else if (source === 'member' && !ctx.member) {
      // 게스트는 server에서 평가 불가 → Client로 미룸
      isClient = true;
    } else {
      setPropPath(resolvedProps, propPath, value);  // SSR에서 평가 완료
    }
  }
  
  return { resolvedProps, isClient };
}
```

### Stage 4: Tree → React Components

```ts
function renderTree(nodes: TreeNode[], ctx: RenderContext): JSX.Element[] {
  return nodes.map(node => {
    if (node.kind === 'section')
      return <SectionRenderer key={node.id} {...node.settings}>{renderTree(node.children, ctx)}</SectionRenderer>;
    if (node.kind === 'column')
      return <ColumnRenderer key={node.id} {...node.settings}>{renderTree(node.children, ctx)}</ColumnRenderer>;
    if (node.kind === 'block') {
      const widget = WidgetRegistry.get(node.widget_code);
      const { resolvedProps, isClient } = resolveBindings(node, ctx);
      
      // condition 평가 (server 모드)
      if (node.condition?.mode === 'server') {
        const visible = evaluateCondition(node.condition.when, ctx);
        if (!visible) return null;
      }
      
      const Component = isClient || widget.ssr_mode === 'client'
        ? widget.ClientComponent
        : widget.ServerComponent;
      
      return (
        <Component key={node.id} {...resolvedProps}>
          {renderTree(node.children, ctx)}
        </Component>
      );
    }
  });
}
```

### Stage 5: Render

```tsx
// app/[...slug]/page.tsx
export default async function DynamicPage(...) {
  const page = await fetchPageBySlug(slug);
  const ctx = await buildContext(page, params);
  
  return (
    <html>
      <head>
        <SeoMeta meta={page.seo_meta} />
        <DesignTokensStyle theme={ctx.theme} />  {/* CSS variables from design_tokens */}
      </head>
      <body>
        <Suspense fallback={<PageSkeleton />}>
          {renderTree(page.tree, ctx)}
        </Suspense>
      </body>
    </html>
  );
}
```

---

## 2. SSR / CSR 결정 트리

각 위젯이 RSC인지 Client인지 결정하는 규칙. block-schema.md §1.1 `widgets.ssr_mode` 컬럼을 기본값으로 사용하되, 런타임에 격상 가능.

```
[Q1] widget.ssr_mode === 'client' 인가?
  YES → Client (확정)
  NO ↓

[Q2] widget.ssr_mode === 'hybrid' 인가?
  YES → RSC 셸 + 내부 Client 부분 (Skeleton + interactive 영역)
  NO ↓ (= 'rsc')

[Q3] block.bindings에 'quote'/'cart' 등 사용자 인터랙션 source가 있는가?
  YES → Client 격상
  NO ↓

[Q4] block.condition.mode === 'client' 인가?
  YES → Client 격상
  NO → RSC
```

### V1 위젯별 ssr_mode 기본값

| 위젯 | ssr_mode | 이유 |
|---|---|---|
| `section` | rsc | 정적 컨테이너 |
| `column` | rsc | 정적 컨테이너 |
| `text` | rsc | 정적 (bindings 시 격상) |
| `image` | rsc | next/image SSR |
| `button` | client | onClick 필요 |
| `product_gallery` | hybrid | SSR 셸 + 클라이언트 정렬/필터 |
| `option_panel` | client | 폼 상태 + 실시간 가격 |
| `quote_preview` | client | quote state 의존 |
| `form_field` | client | 폼 |
| `media_slider` | client | autoplay / interaction |
| `tabs` | client | 활성 탭 state |
| `mega_menu` | client | hover/click |
| `edicus_slot` | client | iframe + postMessage |
| `rich_card` | rsc | 정적 |

---

## 3. 페이지 타입별 캐싱 매트릭스 (ISR/SSR/SSG)

| 페이지 타입 | 인증 상태 | 전략 | revalidate | 태그 |
|---|---|---|---|---|
| 홈 (`/`) | 비인증 | ISR | 300s (5min) | `pages`, `home` |
| 홈 (`/`) | 인증 | SSR (per-request) | — | (cookie 변동) |
| 카테고리 (`/categories/:slug`) | 비인증 | ISR | 600s | `pages`, `category:slug` |
| 상품 상세 (`/products/:slug`) | 비인증 | ISR | 300s | `pages`, `product:id` |
| 상품 상세 | 인증 (등급별 가격) | SSR | — | per-request (Cache-Control: no-store) |
| 정적 페이지 (about, legal, faq) | any | SSG (build-time) | publish 시 revalidate | `pages` |
| 견적 화면 (option_panel 내) | any | SSR + Client | — | (가격은 항상 fresh) |
| 마이페이지 | 인증 | SSR (no cache) | — | per-user |
| 카트 / 체크아웃 | any | SSR (no cache) | — | per-session |
| 어드민 | 인증 | SSR (no cache) | — | per-user |

### 캐시 무효화 트리거

| 이벤트 | revalidateTag |
|---|---|
| Page publish | `pages`, `page:slug:{slug}` |
| Page revision | `page:slug:{slug}` |
| Product 가격표 변경 | `product:{id}`, `pricing:catalog:{id}` |
| Product 카테고리 변경 | `category:{slug}` |
| Design Token 변경 | `tokens`, (전 페이지에 적용되므로 `pages` 까지) |
| Widget catalog 변경 | `widgets` (어드민 빌더 화면 영향) |
| Surcharge/Discount rule 변경 | `pricing:rules` |

---

## 4. Hydration 전략

### 4.1 페이지 단위

Next.js 15는 streaming SSR을 기본 지원. RSC가 렌더 → HTML stream + RSC payload → 브라우저 hydration.

- **First Paint**: RSC HTML이 즉시 표시 (skeleton 포함)
- **Interactive**: Client Component 묶음(option_panel, button, tabs)가 chunk별 hydrate
- **Idle Pre-fetch**: 무거운 client widgets (media_slider, edicus_slot)는 `loading="lazy"` 또는 IntersectionObserver로 lazy-hydrate

### 4.2 블록 단위 (Selective Hydration)

```tsx
// Section 안에 다수 Block이 있을 때, Client Boundary는 개별 Block 단위
<SectionRenderer>
  <ColumnRenderer>
    <TextWidget content="..." />              {/* RSC, no hydration */}
    <OptionPanelWidget product_id="..." />    {/* Client, hydrates */}
    <TextWidget content="..." />              {/* RSC */}
  </ColumnRenderer>
</SectionRenderer>
```

React 19의 selective hydration이 우선순위에 따라 hydrate. 사용자 interaction 우선.

### 4.3 Suspense Boundary

```tsx
<Suspense fallback={<PriceSkeleton />}>
  <QuotePreviewWidget quote_id={quoteId} />   {/* await fetch */}
</Suspense>

<Suspense fallback={<EditorSkeleton />}>
  <EdicusSlot product_id={productId} />
</Suspense>
```

- 무거운 fetch / 외부 SDK 로드는 Suspense로 격리
- 사용자는 페이지 기본 구조 즉시 인지, 무거운 영역은 streaming

---

## 5. 캐싱 계층 (3-tier)

```
[L1] CDN / Edge Cache (Vercel / Cloudfront)
        ↓ miss
[L2] Next.js Data Cache (ISR / unstable_cache)
        ↓ miss
[L3] Redis (PricingCatalog, Session, Hot Product)
        ↓ miss
[L4] Neon PG (source of truth)
```

### TTL 매트릭스

| 데이터 | L1 (Edge) | L2 (Next.js) | L3 (Redis) |
|---|---|---|---|
| Page HTML (비인증) | 5분 | 60초 | — |
| Page tree (DB) | — | 60초 | — |
| Product 상세 | 1분 | 60초 | — |
| PricingCatalog | — | — | 60초 |
| QuoteResult | — | — | 5초 |
| Design Tokens | 1시간 | 1시간 | — |
| Widget catalog | 1시간 | 1시간 | — |
| Member session | — | — | 24시간 (sliding) |

### Stale-While-Revalidate

- 모든 ISR은 SWR 모드: 만료된 캐시 표시 + 백그라운드 revalidate
- 운영 변경 즉시 반영 필요한 케이스(가격, 재고)는 `revalidateTag` 명시적 호출

---

## 6. SEO·메타·Open Graph

### 6.1 페이지 메타 처리

```tsx
// app/[...slug]/page.tsx
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const page = await fetchPageBySlug(params.slug.join('/'));
  if (!page) return {};
  
  const meta = page.seo_meta;
  return {
    title: meta.title ?? page.title,
    description: meta.description,
    openGraph: {
      title: meta.og_title ?? meta.title,
      description: meta.og_description,
      images: meta.og_image ? [meta.og_image] : [],
      type: meta.og_type ?? 'website',
    },
    twitter: {
      card: 'summary_large_image',
      title: meta.title,
      description: meta.description,
    },
    robots: meta.robots ?? { index: true, follow: true },
    alternates: {
      canonical: meta.canonical,
    },
  };
}
```

`pages.seo_meta` JSONB 구조:
```json
{
  "title": "...",
  "description": "...",
  "og_title": "...",
  "og_description": "...",
  "og_image": "https://...",
  "og_type": "website",
  "canonical": "https://huniprinting.com/...",
  "robots": { "index": true, "follow": true },
  "keywords": ["...", "..."],
  "structured_data": { "@context": "...", "@type": "Product", ... }
}
```

### 6.2 구조화 데이터 (JSON-LD)

상품 상세 페이지:
```jsx
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "{{product.name}}",
  "image": "{{product.thumbnail_url}}",
  "description": "...",
  "offers": {
    "@type": "AggregateOffer",
    "priceCurrency": "KRW",
    "lowPrice": "{{lowest_price}}",
    "highPrice": "{{highest_price}}"
  }
}
</script>
```

→ `seo_meta.structured_data`를 페이지 메타에 저장, RSC가 `<script>`로 주입.

### 6.3 sitemap.xml

```ts
// app/sitemap.ts
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const pages = await db.select().from(pagesTable)
    .where(eq(pagesTable.status, 'published'));
  const products = await db.select().from(productsTable)
    .where(eq(productsTable.is_active, true));
  
  return [
    ...pages.map(p => ({
      url: `${env.NEXT_PUBLIC_APP_URL}/${p.slug}`,
      lastModified: p.updated_at,
      changeFrequency: 'weekly',
      priority: p.page_type === 'landing' ? 1.0 : 0.5,
    })),
    ...products.map(p => ({
      url: `${env.NEXT_PUBLIC_APP_URL}/products/${p.slug}`,
      lastModified: p.updated_at,
      changeFrequency: 'weekly',
      priority: 0.8,
    })),
  ];
}
```

As-Is buysangsang의 URL `/shop/{id}/{korean-name}/` 호환을 위해 `next.config.ts`의 redirects:
```ts
async redirects() {
  return [
    { source: '/shop/:id/:name', destination: '/products/:name', permanent: true },
  ];
}
```

### 6.4 robots.txt

```
User-agent: *
Allow: /
Disallow: /admin
Disallow: /api
Disallow: /checkout
Disallow: /my-page

Sitemap: https://huniprinting.com/sitemap.xml
```

---

## 7. Streaming + Suspense 정책

### 7.1 페이지의 streaming 구획

```tsx
<html>
  <body>
    {/* 0. Header — RSC, fast TTFB */}
    <HeaderRenderer />
    
    {/* 1. Hero / Above-the-fold — RSC, no Suspense */}
    <HeroRenderer page={page} />
    
    {/* 2. 무거운 영역 — Suspense */}
    <Suspense fallback={<GallerySkeleton />}>
      <ProductGalleryRenderer source="category" categoryId={...} />
    </Suspense>
    
    {/* 3. 사용자 의존 — Client + Suspense */}
    <Suspense fallback={<QuoteSkeleton />}>
      <OptionPanelClient productId={...} />
    </Suspense>
    
    {/* 4. Footer — RSC */}
    <FooterRenderer />
  </body>
</html>
```

### 7.2 외부 API 호출 격리

- Edicus iframe loading → Suspense + skeleton
- Shopby 회원 정보 fetch → Suspense (마이페이지)
- 가격 산출 (option_panel 내부) → Skeleton state in client

---

## 8. 보안 / XSS 방어

| 영역 | 방어 |
|---|---|
| `text.content` (rich format) | DOMPurify 또는 sanitize-html (서버에서 sanitize 후 저장 권장) |
| `bindings` 표현식 | jsonata 또는 자체 limited evaluator. `eval()`, `Function()`, globals 금지. depth ≤ 5 |
| `custom_css` | CSP `style-src 'self' 'unsafe-inline'`은 어드민 한정, 사용자 페이지는 inline 제거 |
| External URL (`image.src`, `button.href`) | allowlist (`huniprinting.com`, `firebasestorage.googleapis.com`, `edicusbase.firebaseapp.com`) |
| iframe (edicus_slot) | `sandbox="allow-scripts allow-same-origin"` + `postMessage` TRUSTED_ORIGIN 검증 (edicus.man 그대로) |

---

## 9. 성능 목표

| 메트릭 | 목표 |
|---|---|
| TTFB (홈) | < 200ms |
| FCP | < 1.0s (3G) |
| LCP | < 2.5s |
| TBT | < 200ms |
| CLS | < 0.1 |
| Page tree fetch | < 100ms (cache hit) / < 300ms (miss) |
| Pricing API | < 200ms (P95) / < 50ms (cache hit) |
| Edicus iframe load | < 3s (외부 의존) |

모니터링: Vercel Analytics + Sentry + 자체 Real User Monitoring.

---

## 10. Open Questions

| ID | 질문 | 영향 |
|---|---|---|
| O-RP-1 | Page tree 단일 쿼리 vs N+1 어느 쪽이 빠른가 (depth 3~5 트리) | Stage 2 성능 |
| O-RP-2 | Design Token CSS 주입 방식 (inline `<style>` vs CSS Modules generated) | FOUC 위험 |
| O-RP-3 | mobile/desktop 분기 — 단일 페이지 + responsive vs 별도 mobile sub-domain | URL 정책 |
| O-RP-4 | 다국어 i18n V1 — Next.js i18n 라우팅 적용 시점 | V1 vs V2 |
| O-RP-5 | 어드민 빌더 미리보기 vs 라이브 렌더 동등성 보장 방식 | 빌더 UX |

---

REQ coverage: REQ-RENDER-001~010  
References: domain-model.md §1, block-schema.md §1·§3·§7, bff-integration.md §3, decisions D-003 (Next.js 15 베이스), docs/edicus.man/src/app (App Router 참조)
