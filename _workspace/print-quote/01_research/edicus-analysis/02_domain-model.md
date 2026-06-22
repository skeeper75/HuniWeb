# 02. Domain Model — 추출된 빌더/주문 엔티티

생성일: 2026-05-27

도메인 엔티티는 거의 전부 `src/types/edicus.ts`와 `src/types/order.ts`에 집중되어 있으며, `src/lib/edicus/*.ts`와 API route Zod 스키마가 보조한다.

---

## A. Editor / SDK Integration Domain

### A1. `EdicusConfig` — SDK 초기화 설정
파일: `src/types/edicus.ts:5-8`
```ts
export interface EdicusConfig {
  base_url: string; // 편집기 베이스 URL (기본: https://edicusbase.firebaseapp.com)
}
```

### A2. `EdicusContext` — 편집기 핸들 (window.edicusSDK.init() 반환)
파일: `src/types/edicus.ts:11-64`
주요 필드: `base_url`, `landing_path`, `tnview_path`, `preview_path`, `lite_path`, `iframe_el`, `messageListener`, `target_callback`, 지연 파라미터 11종 (`ddp_block`, `private_css`, `option_string`, `i18n`, `prod_info`, `options`, `data_row`, `data_feed`, `data_content`, `zoom`, `template_list`)
주요 메서드: `create_project`, `open_project`, `edit_template`, `create_design_project`, `open_design_project`, `recycle_project`, `reform_project`, `fit_project`, `open_preview`, `show_tnview`, `create_tnview`, `open_tnview`, `show_gallery`, `create_lite_project`, `open_lite_project`, `show_lite_editor`, `change_project`, `change_template`, `change_template_v2`, `execute_ddp_block`, `post_to_editor`, `post_to_tnview`, `post_to_preview`, `close`, `destroy`

→ **17가지 편집 모드/뷰**가 SDK 레벨에서 지원됨 (project/template/design/recycle/reform/fit/preview/tnview/gallery/lite의 조합).

### A3. `EdicusCallbackData` / `EdicusCallbackInfo`
파일: `src/types/edicus.ts:70-91`
```ts
type: string;        // 'from-edicus-*' 메시지 종류
action?: string;
info?: { project_id?, prjid?, status?, uid?, [k]: unknown }
```

### A4. `ProjectStatus` (FROZEN 상태머신)
파일: `src/types/edicus.ts:97`
```ts
export type ProjectStatus = 'editing' | 'ordering' | 'ordered';
```
- editing: 편집 중 (잠정주문 전)
- ordering: 잠정주문 완료 (취소 가능, 편집 불가)
- ordered: 확정주문 완료 (취소 불가, 인쇄파일 렌더링 시작)

### A5. `EdicusCommonUrlParams` — iframe URL 파라미터 슈퍼셋
파일: `src/types/edicus.ts:100-146`
주요 필드 분류:
- 환경: `partner`, `mobile`, `div`, `lang`, `ui_locale`, `editor_type`, `ui_style`, `parent_type`, `env_mode`, `run_mode` (`passive` 등)
- 페이지 제어: `num_page`, `max_page`, `min_page`, `max_order`, `min_order`
- 편집 제어: `force_plugin`, `plugin_param`, `resapi_param`, `unlayers`, `edit_lock` (`edit-group`/`set-strict-color`/`no-font-preview`), `no_update`, `clear_src`, `cal_date`, `video_frames`
- 지연 파라미터: `ddp_block`, `private_css`, `prod_info`, `options`, `option_string`
- 개발: `dev_apiHost`, `dev_assetHost`, `dev_uploadHost`, `dev_resHost`
- 필수: `parent_element: HTMLElement`

→ 이 단일 타입이 **모든 편집기 모드의 URL/iframe 파라미터 계약**. To-Be 빌더의 "에디터 진입 컨텍스트" 모델로 직접 이식 가능.

### A6. 파라미터 변형 (10종)
파일: `src/types/edicus.ts:149-292`
- `CreateProjectParams` — `token`, `ps_code`, `title`, `template_uri?`, `content_uri?`
- `OpenProjectParams` — `token`, `prjid`, `ps_code?`
- `EditTemplateParams` — `token`, `ps_code`, `prjid?`, `template_uri?`, `content_uri?`
- `CreateDesignProjectParams` — `token`, `ps_code`, `title`, `template_uri?`
- `RecycleProjectParams` — `token`, `prjid`, `title`
- `ReformProjectParams` — `token`, `prjid`, `ps_code`
- `FitProjectParams` — `token`, `prjid`, `ps_code`, `base_template_uri`, `content_overwrite?`
- `OpenPreviewParams` — `token`, `prjid`, `partner`, `uid`, `npage?`, `flow?`, `mode?`, `data_row?`, `zoom?`
- `TnviewParams` / `OpenTnviewParams` — 썸네일 뷰어 (`rotate?`, `show3d?`)
- `ShowGalleryParams` — 갤러리 (`data_feed`, `data_content`)
- `LiteProjectParams` / `OpenLiteProjectParams` — 라이트 편집기 (`core_size_mm`, `size_type`, `round_mm`)
- `ChangeTemplateV2Option` — `psCode`, `template_uri`, `content_uri?`, `command?`

### A7. `EdicusProject` (서버 모델)
파일: `src/types/edicus.ts:295-300`
```ts
export interface EdicusProject {
  project_id: string;
  status: ProjectStatus;
  created_at: string; // ISO 8601
  updated_at: string;
}
```

### A8. `EdicusTemplate` (Resource API)
파일: `src/types/edicus.ts:321-329`
```ts
export interface EdicusTemplate {
  resource_id: string;
  title: string;
  ps_code: string;          // 상품 코드 (도메인 키)
  template_uri: string;     // 템플릿 URI (외부 스토리지)
  category?: string;
  thumbnail_url?: string;
  [key: string]: unknown;   // 동적 확장
}
```

### A9. `EdicusProduct`
파일: `src/types/edicus.ts:332-337`
```ts
export interface EdicusProduct {
  ps_code: string;
  title: string;
  category: string;
  [key: string]: unknown;
}
```

### A10. `TokenResponse` / `PreviewUrlsResponse` / `EdicusApiResponse<T>`
파일: `src/types/edicus.ts:303-318`

### A11. `QueryOptions` (리소스 쿼리)
파일: `src/types/edicus.ts:340-345`
```ts
export interface QueryOptions {
  category?: string;
  page?: number;
  limit?: number;
  [key: string]: unknown;
}
```

---

## B. Order Domain (잠정 → 확정 → 취소)

### B1. `OrderStatus`
파일: `src/types/order.ts:10-15`
```ts
export type OrderStatus =
  | 'tentative'   // 잠정주문 (취소 가능, 편집 불가)
  | 'definitive'  // 확정주문 (취소 불가, 렌더링 시작)
  | 'cancelled'
  | 'processing'  // 렌더링/인쇄 진행
  | 'completed';
```
주의: README의 상태머신은 7단계(`New, Tentative, Confirmed, Processing, Shipped, Delivered, Cancelled, Failed`)이나 코드는 5단계만 정의. **`Order.status`(코드) vs `Project.status`(SDK)** 두 개의 분리된 상태머신이 공존.

### B2. `Order`
파일: `src/types/order.ts:18-24`
```ts
export interface Order {
  order_id: string;
  project_id: string;
  status: OrderStatus;
  created_at: string;
  updated_at: string;
}
```

### B3. 주문 요청/응답
파일: `src/types/order.ts:27-46`
- `TentativeOrderRequest { project_id }`
- `DefinitiveOrderRequest { project_id }`
- `CancelOrderRequest { order_id }`
- `OrderResponse { order_id, project_id, status }`

### B4. API 입력 검증 스키마 (Zod)
파일: `src/app/api/edicus/orders/route.ts:11-21`
```ts
const CreateOrderBodySchema = z.object({
  projectId: z.string().min(1),
  type: z.enum(['tentative', 'definitive']),
});
const CancelOrderBodySchema = z.object({ orderId: z.string().min(1) });
```

---

## C. Configuration / Environment Domain

### C1. `EnvConfig` (Zod 스키마)
파일: `src/lib/edicus/env.ts:7-20`
```ts
const envSchema = z.object({
  EDICUS_API_KEY: z.string().min(1),
  EDICUS_API_HOST: z.string().url(),
  EDICUS_RESOURCE_HOST: z.string().url(),
  NEXT_PUBLIC_EDICUS_PARTNER: z.string().min(1),
  NEXT_PUBLIC_EDICUS_BASE_URL: z.string().url(),
});
```

### C2. `EdicusClientConfig`
파일: `src/lib/edicus/client.ts:89-96`
```ts
export interface EdicusClientConfig {
  baseUrl: string;
  partner: string;
  scriptUrl?: string;
}
```

### C3. `HuniEditorConfig` (passive mode 진입점)
파일: `src/lib/edicus/huni-editor-sdk.ts:22-41`
```ts
export interface HuniEditorConfig {
  containerId: string;
  productId: string;       // ps_code
  partnerId: string;
  passiveMode?: boolean;
  privateCss?: string;
  extraParams?: Record<string, string>;
  onReady?: () => void;
  onClose?: () => void;
  onError?: (error: Error) => void;
}
```

### C4. `CssPreset` — 파트너 브랜딩 토큰
파일: `src/lib/edicus/custom-css.ts:7-13`
```ts
export interface CssPreset { name; partner; css; description; }
```
프리셋: `default` (hunip, `#5538B6` 보라), `dark`, `redprinting`

### C5. `MobileEditorConfig` / `DesktopEditorConfig`
파일: `src/lib/edicus/mobile-config.ts:8-22`

---

## D. 보조: VDP 가변 데이터

### D1. `VdpField` (컴포넌트 로컬 타입)
파일: `src/components/editor/VdpEditor.tsx:15-26`
```ts
interface VdpField {
  key: string;
  label: string;
  type: 'text' | 'number' | 'date';
  required?: boolean;
  defaultValue?: string;
}
```
실제 SDK varMap (`$TMPL`, `$PSCD`, `$PRCE` 등)은 `docs/red-editor-sdk-analysis.md`에 문서화되어 있으나 코드에서는 `Record<string,string>`로 단순 전달.

---

## E. 클라이언트 인터페이스 (서비스 객체)

### E1. `EdicusClient` (브라우저 싱글턴)
파일: `src/lib/edicus/client.ts:116-246`
공개 메서드: `init()`, `getContext()`, `isReady()`, `createProject()`, `openProject()`, `close()`, `destroy()`, `postToEditor()`

### E2. `HuniEditorSDK` (고수준 합성 래퍼)
파일: `src/lib/edicus/huni-editor-sdk.ts:65-328`
이벤트: `'ready'|'close'|'doc-changed'|'ready-to-listen'|'save-complete'|'error'`
명령: `undo()`, `redo()`, `save()` (action='save-doc'), `close()`
보안: TRUSTED_ORIGIN = `'edicusbase.firebaseapp.com'`, postMessage origin 검증 (`huni-editor-sdk.ts:278`)

### E3. `ServerApiClient` (서버 전용)
파일: `src/lib/edicus/server-api.ts:10-21`
```ts
interface ServerApiClient {
  getToken(uid): Promise<TokenResponse>;
  getStaffToken(uid): Promise<TokenResponse>;
  getProjects(uid): Promise<EdicusProject[]>;
  getProject(projectId): Promise<EdicusProject>;
  deleteProject(projectId): Promise<void>;
  cloneProject(projectId): Promise<EdicusProject>;
  tentativeOrder(projectId): Promise<Order>;
  definitiveOrder(projectId): Promise<Order>;
  cancelOrder(orderId): Promise<void>;
  getPreviewUrls(projectId): Promise<string[]>;
}
```
헤더: `edicus-api-key`, `edicus-uid` (`server-api.ts:42-48`)

### E4. `ResourceApiClient`
파일: `src/lib/edicus/resource-api.ts:9-13`
```ts
interface ResourceApiClient {
  queryTemplates(partner, options?): Promise<EdicusTemplate[]>;
  getProductList(partner): Promise<EdicusProduct[]>;
  getResource(resourceId): Promise<EdicusTemplate>;
}
```

---

## F. 직렬화 / 영속화 모델

- **JSON 직렬화**: 모든 엔티티는 plain JSON (Edicus API의 응답/요청 본문). 별도 자체 ORM 없음.
- **스키마 검증**: **Zod 3.24** — `env.ts`, 모든 API route 입력단에 적용 (`src/app/api/edicus/*/route.ts`).
- **인덱스/스토리지**: 영속화는 외부 Edicus 백엔드(`api-dot-edicusbase.appspot.com`)가 소유. 본 앱은 Firebase Auth만 자체 보유. 자체 DB 없음(README가 언급한 `DATABASE_URL`은 미사용/예약).
- **VDP varMap**: `Record<string, string>` 단순 객체로 SDK에 `post_to_editor('set-variable-data', { variableData })` 전송 (`VdpEditor.tsx:122-127`).
- **`template_uri` / `content_uri`**: 외부 스토리지 URL 참조 (예: Firebase Storage). 본문은 보관하지 않음.

---

## G. 렌더링 모델

- Next.js 15 **App Router**. RSC + Client Component 혼합.
- 편집 자체는 **iframe** (`https://edicusbase.firebaseapp.com/ed#/...`). 트리 → JSX 변환기 **없음**.
- 모바일/PC 별도 컴포넌트 (`MobileEditor`, `PCPassiveEditor`, `EdicusEditor`, `VdpEditor`).
- "passive" 모드: 운영자가 미리 만든 디자인을 사용자가 가변 필드만 수정하는 제한 편집 (`HuniEditorConfig.passiveMode: true` → `run_mode: 'passive'`).
- 편집기 전용 CSS는 `private_css` 파라미터로 iframe에 주입 (브랜딩).

---

## H. 도메인 그룹 요약표

| 그룹 | 핵심 엔티티 | 파일 |
|------|-------------|------|
| SDK 진입 | EdicusConfig, EdicusContext, EdicusClientConfig | types/edicus.ts, lib/edicus/client.ts |
| 편집 컨텍스트 | EdicusCommonUrlParams + 10가지 파라미터 변형 | types/edicus.ts |
| 프로젝트 | EdicusProject, ProjectStatus | types/edicus.ts |
| 카탈로그 | EdicusTemplate, EdicusProduct, QueryOptions | types/edicus.ts |
| 주문 | Order, OrderStatus, Tentative/Definitive/Cancel | types/order.ts |
| 인증 | TokenResponse | types/edicus.ts |
| VDP | VdpField (컴포넌트 로컬), varMap | components/editor/VdpEditor.tsx |
| 브랜딩 | CssPreset, MobileEditorConfig | lib/edicus/custom-css.ts, mobile-config.ts |
| 환경 | EnvConfig (Zod) | lib/edicus/env.ts |
| 서비스 | EdicusClient, HuniEditorSDK, ServerApiClient, ResourceApiClient | lib/edicus/*.ts |

**도메인 모델의 절반은 "Edicus iframe 호출 계약"(A·E 그룹)이고, 나머지 절반은 "프로젝트/주문/카탈로그 메타데이터"(B·G·H 그룹). 빌더 캔버스 내부 구조(Page/Section/Block/Widget/Slot) 자체는 이 코드베이스에 노출되지 않음** — Edicus가 블랙박스로 캡슐화함.
