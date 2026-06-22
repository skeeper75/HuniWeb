# edicus.man — 모듈 의존 그래프 + 라우트 맵

> 권위: `docs/edicus.man/src/**` 코드 직접 분석(Read/Grep). README는 출발점이며 코드와 불일치 시 코드 우선(불일치는 §5에 기록).
> 모든 사실에 `파일:라인` 근거. 외부 연동(Edicus 서버·Firebase)은 경계 노드로 표시.

스택: Next.js 15.3.1 (App Router, `--turbopack`), React 19, TypeScript 5, Tailwind 3.4, Zod 3, Firebase 12 (`docs/edicus.man/package.json:1`).

---

## 1. 디렉토리 레이어

| 레이어 | 경로 | 책임 |
|---|---|---|
| 라우트(App Router) | `src/app/**` | 페이지·레이아웃·API route 핸들러 |
| 훅 | `src/hooks/**` | `useEdicus`·`useHuniEditor`·`useAuth`·`useOrder` |
| 컴포넌트 | `src/components/**` | ui(8)·auth·products·admin·mobile·orders·editor |
| 라이브러리 | `src/lib/edicus/**` | Edicus SDK 클라이언트·서버 API·리소스 API·CSS·config |
| 라이브러리 | `src/lib/firebase/**` | Firebase 앱 초기화·auth 헬퍼 |
| 라이브러리 | `src/lib/red-editor/**` | RedEditorSDK 타입 정의(.d.ts)·래퍼·역공학 분석본(analyzed/) |
| 타입 | `src/types/**` | `edicus.ts`(SDK 도메인)·`order.ts`(주문 도메인) |
| 미들웨어 | `src/middleware.ts` | 인증 라우팅 가드 |

## 2. 의존 그래프 (핵심 import 방향)

```
[app/* 페이지·컴포넌트]
   │  uses
   ▼
[hooks] useEdicus ─────────────► [lib/edicus/client.ts] EdicusClient
        useHuniEditor ─────────► [lib/edicus/huni-editor-sdk.ts] HuniEditorSDK ──► client.ts (합성)
        useAuth ───────────────► [lib/firebase/auth.ts] ──► [lib/firebase/config.ts]
        useOrder ──────────────► fetch /api/edicus/orders/*

[lib/edicus/client.ts] ──► window.edicusSDK (외부 SDK, /edicus-sdk-v2.js)   ◀ 경계 노드
[lib/edicus/huni-editor-sdk.ts] ──► getDesktopConfig (mobile-config.ts) ──► getCssForPartner (custom-css.ts)
[lib/edicus/mobile-config.ts] ──► custom-css.ts

[app/api/edicus/**] ──► [lib/edicus/server-api.ts] createServerApiClient ──► EDICUS_API_HOST  ◀ 경계 노드(Edicus 서버)
                    └─► [lib/edicus/resource-api.ts] createResourceApiClient ──► EDICUS_RESOURCE_HOST  ◀ 경계 노드
                    └─► (resource/*, auth/staff, query, products route는 클라이언트 미사용·직접 fetch 프록시)
[lib/edicus/server-api.ts], [resource-api.ts] ──► [lib/edicus/env.ts] validateEnv (Zod)

[lib/red-editor/wrapper.ts] ──► window.RedEditorSDK + red-editor-sdk.d.ts   ◀ 미배선(아래 §5)
```

핵심: `useEdicus`(`src/hooks/useEdicus.ts:11`)와 `useHuniEditor`(`src/hooks/useHuniEditor.ts:14`)는 **둘 다 `EdicusClient`로 수렴**한다. `HuniEditorSDK`는 `EdicusClient`를 합성으로 감싼 고수준 래퍼(`src/lib/edicus/huni-editor-sdk.ts:13,67`).

## 3. 라우트 맵 (src/app)

전 라우트는 `RootLayout`(`src/app/layout.tsx:29`, html lang=ko, 헤더/푸터/네비)을 공유. 네비=홈/내 프로젝트/주문 내역(`layout.tsx:23`). **루트에 QueryClientProvider·zustand Provider 없음**(§5 참조).

### 3.1 공개 페이지

| 라우트 | 파일 | 타입 | 역할·근거 |
|---|---|---|---|
| `/` | `src/app/page.tsx:26` | RSC(async) | 홈. `searchParams.category`로 카테고리 필터(`page.tsx:27-28`) |
| `/login` | `src/app/login/page.tsx:9` | client page | 로그인. `LoginForm` 사용 |
| `/register` | `src/app/register/page.tsx:10` | client page | 회원가입. `RegisterForm` 사용 |
| `/projects` | `src/app/projects/page.tsx:44` | RSC(async) | 내 프로젝트 목록. 서버 `fetch /api/edicus/projects`(`projects/page.tsx:14`) |
| `/orders` | `src/app/orders/page.tsx:48` | RSC(async) | 주문 내역. 서버 `fetch /api/edicus/orders`(`orders/page.tsx:14`) |

`/projects`·`/orders`에는 `error.tsx`·`loading.tsx` 동봉(`src/app/projects/error.tsx`,`loading.tsx`; `src/app/orders/error.tsx`,`loading.tsx`).

### 3.2 편집기 라우트 (동적 세그먼트)

| 라우트 | 파일 | 타입 | 역할·근거 |
|---|---|---|---|
| `/editor/[templateId]` | `src/app/editor/[templateId]/page.tsx:22` | RSC(async) | PC 편집기. `generateMetadata`(`page.tsx:9`) + `<EdicusEditor>`(`page.tsx:2,27`). 동적 세그먼트 `templateId`(`page.tsx:5,23`) |
| `/vdp/[templateId]` | `src/app/vdp/[templateId]/page.tsx:21` | RSC(async) | VDP(가변데이터) 편집기. `<VdpEditor>`(`page.tsx:2,25`) |

각 편집기 라우트는 `error.tsx`·`loading.tsx` 동봉(`editor/[templateId]/error.tsx`,`loading.tsx`; `vdp/[templateId]/error.tsx`,`loading.tsx`).

### 3.3 모바일 라우트

| 라우트 | 파일 | 타입 | 역할·근거 |
|---|---|---|---|
| `/mobile` | `src/app/mobile/page.tsx:23` | client(`'use client'`) | 모바일 카탈로그. `fetch /api/edicus/products`(`mobile/page.tsx:36`), `useState`로 상품/카테고리(`:24-27`) |
| `/mobile/[productId]` | `src/app/mobile/[productId]/page.tsx:27` | client | 모바일 상품 상세→`<MobileEditor>` 전체화면(`:9,77`). `use(params)`로 productId 언래핑(`:5,29`) |

모바일 라우트는 `src/app/mobile/layout.tsx`를 공유(루트 레이아웃 위 중첩).

### 3.4 관리자 라우트 (`/admin/*`)

`src/app/admin/layout.tsx`(공통 레이아웃 + `Sidebar`). 미들웨어 보호 대상(§3.5). 페이지 14종:

| 라우트 | 파일 |
|---|---|
| `/admin` (대시보드) | `admin/page.tsx:49` (client) |
| `/admin/orders` | `admin/orders/page.tsx` |
| `/admin/products` | `admin/products/page.tsx` |
| `/admin/templates` | `admin/templates/page.tsx` |
| `/admin/templates/[id]` | `admin/templates/[id]/page.tsx` (동적) |
| `/admin/settings` | `admin/settings/page.tsx` |
| `/admin/assets` · `/admin/billing` · `/admin/insights` · `/admin/profile` · `/admin/shipping` · `/admin/shop` · `/admin/sms` · `/admin/stats` | 동명 `page.tsx` |

### 3.5 미들웨어 (`src/middleware.ts`)

- 보호 패턴: `/admin/*`, `/editor/*`(`middleware.ts:9-12`). 미인증 시 `/login?redirect=`로 리다이렉트(`:32-35`).
- 인증 라우트 `/login`·`/register`에 로그인 사용자 접근 시 `/admin`으로(`:15,40-42`).
- 인증 판정=`__session` 쿠키 **존재 여부만**(Edge Runtime, Firebase Admin 검증 없음·`:23-28`). 실제 토큰 검증은 API 라우트 책임(`:24`).
- matcher: `api`·`_next/static`·`_next/image`·정적파일 제외(`:50-58`).

## 4. API 라우트 (src/app/api/edicus)

10개 route handler. 두 종류: **서버 API 클라이언트 경유**(server-api.ts) vs **직접 fetch 프록시**.

| 라우트 | 메서드 | 호출 | 근거 |
|---|---|---|---|
| `/api/edicus/auth` | POST | `createServerApiClient().getToken(uid)` | `auth/route.ts:29-30` |
| `/api/edicus/auth/staff` | POST | 직접 fetch `EDICUS_API_HOST/api/auth/staff/token` (헤더 edicus-email/pwd) | `auth/staff/route.ts:34-41` |
| `/api/edicus/projects` | GET/POST/DELETE | `createServerApiClient().getProjects` 등 | `projects/route.ts:42,65,89` |
| `/api/edicus/orders` | POST(잠정/확정)/DELETE(취소) | `tentativeOrder`/`definitiveOrder`/`cancelOrder` | `orders/route.ts:41-42,66` |
| `/api/edicus/products` | GET | `createResourceApiClient().getProductList` | `products/route.ts:30` |
| `/api/edicus/templates` | GET | `createResourceApiClient().queryTemplates` | `templates/route.ts:37` |
| `/api/edicus/css` | GET/POST | `getCssForPartner`(POST는 미저장 stub·TODO) | `css/route.ts:35,61-63` |
| `/api/edicus/resource/[id]` | GET | 직접 fetch `RESOURCE_HOST/resapi/resource/:id` 프록시 | `resource/[id]/route.ts:50` |
| `/api/edicus/resource/products` | GET | 직접 fetch `/resapi/product/list` 프록시 | `resource/products/route.ts:53` |
| `/api/edicus/resource/query` | POST | 직접 fetch `/resapi/query` 프록시 | `resource/query/route.ts:53` |

비밀값 경계: `EDICUS_API_KEY`·스태프 자격증명은 서버 라우트 내에서만 사용, 응답 비포함(`server-api.ts:2`, `auth/route.ts:5`, `auth/staff/route.ts:4-5`).

## 5. 미구현 스캐폴드 / README↔코드 불일치

**`.gitkeep` 디렉토리는 빈 스캐폴드가 아님** — 전부 실제 파일과 공존(예 `app/editor/.gitkeep` 옆에 `app/editor/[templateId]/page.tsx` 존재). `.gitkeep`은 초기 스캐폴드 잔재이며 해당 디렉토리는 모두 구현됨. 따라서 "빈 디렉토리 미구현"에 해당하는 것은 없음.

부분 미구현(stub):
- `/api/edicus/css` POST: DB 저장 미구현, 성공 응답만(`css/route.ts:43,61-63` `@MX:TODO`).
- `LoginForm`: `useAuth`를 직접 호출하지 않고 부모가 props로 login 주입해야 함(`components/auth/LoginForm.tsx:7-8,31`) — 현재 페이지 배선은 부분적.

미배선 모듈(코드는 있으나 src 어디서도 import 안 됨):
- `src/lib/red-editor/wrapper.ts`(RedEditorWrapper)·`red-editor-sdk.d.ts`·`analyzed/*.js`: 역공학 산출물. 실제 런타임 경로는 `EdicusClient`(client.ts) 사용. wrapper는 `window.RedEditorSDK` 가정이나 client.ts는 `window.edicusSDK` 사용 — **두 SDK 추상이 공존하며 wrapper는 미사용**(grep 결과 import 0건).

README↔코드 불일치(코드 우선):
- README 기술스택표가 "상태관리=Zustand 5 / 데이터페칭=TanStack React Query 5"라고 명시(`README.md:138-139`)하나, **src 어디에도 zustand store·`useQuery`/`useMutation`·`QueryClientProvider` 사용 없음**(grep 0건). 실제 상태=컴포넌트 로컬 `useState` + RSC/클라이언트 `fetch`. 두 패키지는 `package.json` 의존성에만 존재(`package.json` deps `zustand`·`@tanstack/react-query`). → data-flow.md §4 참조.
- README "인증: Firebase (NextAuth.js v5 예정)"(`README.md:140`) — 현재는 Firebase Auth 직접 사용(NextAuth 미도입). 코드 일치(예정 표기 정확).
